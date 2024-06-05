from machine import Pin, time_pulse_us, PWM
import time
import utime
import urequests
from Wifi_lib import wifi_init

# Configuración de pines
trigger = Pin(2, Pin.OUT)
echo = Pin(3, Pin.IN)
led_verde = Pin(6, Pin.OUT)
led_amarillo = Pin(7, Pin.OUT)
led_rojo = Pin(8, Pin.OUT)
barrera = PWM(Pin(1))  # Usar PWM para el servomotor
barrera.freq(50)

# Configuración de pines para teclado matricial
rows = [Pin(i, Pin.OUT) for i in range(9, 13)]
cols = [Pin(i, Pin.IN, Pin.PULL_DOWN) for i in range(13, 17)]

# Mapa del teclado matricial 4x4 ajustado según el comportamiento observado
keys = [
    ['D', 'C', 'B', 'A'],
    ['#', '9', '6', '3'],
    ['0', '8', '5', '2'],
    ['*', '7', '4', '1']
]

wifi_init()

# Función para medir la distancia
def measure_distance(samples=5, sample_delay=0.1, threshold=50):
    distances = []

    for _ in range(samples):
        trigger.value(1)
        utime.sleep_us(10)
        trigger.value(0)

        t1 = utime.ticks_us()
        while echo.value() == 0:
            t1 = utime.ticks_us()
        while echo.value() == 1:
            t2 = utime.ticks_us()

        t = t2 - t1
        d = 17 * t / 1000  # Convertir el tiempo en microsegundos a distancia en cm
        if d <= threshold:  # Filtrar valores atípicos
            distances.append(d)

        utime.sleep(sample_delay)  # Esperar antes de la próxima muestra

    if distances:
        average_distance = sum(distances) / len(distances)
    else:
        # Valor por defecto si todas las lecturas fueron atípicas
        average_distance = threshold

    return average_distance

# Función para leer el teclado matricial
def read_keypad():
    for row in range(4):
        # Poner todas las filas en bajo
        for r in rows:
            r.value(0)
        
        # Activar una fila a la vez
        rows[row].value(1)
        
        # Leer todas las columnas
        for col in range(4):
            if cols[col].value() == 1:
                return keys[row][col]
    
    return None

# Función para leer el teclado matricial con debouncing y filtrado
def read_keypad_filtered():
    last_key = None
    key_press_time = utime.ticks_ms()

    while True:
        key = read_keypad()
        current_time = utime.ticks_ms()

        if key and key != last_key and (current_time - key_press_time) > 300:
            last_key = key
            key_press_time = current_time
            return key

# Función para verificar el PIN
def verify_pin(pin):
    url = "http://192.168.41.196:8080/api/v1/users/verify-pin"  # Cambia esto a la URL correcta de tu backend
    data = {"pin": pin}
    headers = {'Content-Type': 'application/json'}
    response = urequests.post(url, json=data, headers=headers)
    result = response.json()
    response.close()
    return result["valid"]

# Función para controlar la barrera
def controlar_barrera(estado):
    if estado == "abrir":
        for position in range(1000, 9000, 50):
            barrera.duty_u16(position)
            time.sleep(0.01)
    elif estado == "cerrar":
        for position in range(9000, 1000, -50):
            barrera.duty_u16(position)
            time.sleep(0.01)

# Loop principal
while True:
    distance = measure_distance()
    if distance < 10:  # Si se detecta un vehículo a menos de 10 cm
        led_amarillo.off()
        led_rojo.off()
        led_verde.on()

        # Leer código PIN desde el teclado matricial
        pin_code = ""
        while len(pin_code) < 4:  # Suponiendo que el PIN tiene 4 dígitos
            key = read_keypad_filtered()
            if key and (len(pin_code) == 0 or key != pin_code[-1]):
                pin_code += key
                print("Key Pressed: ", key)
                while read_keypad() == key:  # Esperar a que se suelte la tecla
                    pass

        if verify_pin(pin_code):
            controlar_barrera("abrir")  # Abrir barrera
            time.sleep(5)  # Esperar 5 segundos
            controlar_barrera("cerrar")  # Cerrar barrera
        else:
            led_verde.off()
            led_rojo.on()
    else:
        led_verde.off()
        led_amarillo.on()
    time.sleep(1)


