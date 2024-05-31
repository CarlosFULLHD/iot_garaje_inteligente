from machine import Pin
import utime
import urequests
from wifi_lib import wifi_init

# Configuración de pines para el sensor ultrasónico
trig = Pin(2, Pin.OUT)
echo = Pin(3, Pin.IN)

# Configuración de pines para el teclado matricial
rows = [Pin(6, Pin.OUT), Pin(7, Pin.OUT), Pin(8, Pin.OUT), Pin(9, Pin.OUT)]
cols = [Pin(10, Pin.IN, Pin.PULL_DOWN), Pin(11, Pin.IN, Pin.PULL_DOWN), Pin(12, Pin.IN, Pin.PULL_DOWN), Pin(13, Pin.IN, Pin.PULL_DOWN)]

# Mapa de teclas
keys = [['1', '2', '3', 'A'],
        ['4', '5', '6', 'B'],
        ['7', '8', '9', 'C'],
        ['*', '0', '#', 'D']]

# Inicializar el trigger a bajo
trig.value(0)

# Inicializar conexión Wi-Fi
wifi_init()

# Función para medir la distancia
def measure_distance(samples=5, sample_delay=0.1, threshold=50):
    distances = []
    
    for _ in range(samples):
        trig.value(1)
        utime.sleep_us(10)
        trig.value(0)
        
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
        average_distance = threshold  # Valor por defecto si todas las lecturas fueron atípicas
    
    return average_distance

# Función para leer el teclado matricial
def read_keypad():
    for row in range(4):
        rows[row].value(1)
        for col in range(4):
            if cols[col].value() == 1:
                rows[row].value(0)
                return keys[row][col]
        rows[row].value(0)
    return None

# Función para verificar el PIN
def verify_pin(pin):
    url = "http://<IP_DE_TU_BACKEND>:8080/api/v1/users/verify-pin"  # Cambia esto a la URL correcta de tu backend
    data = {"pin": pin}
    headers = {'Content-Type': 'application/json'}
    response = urequests.post(url, json=data, headers=headers)
    result = response.json()
    response.close()
    return result["valid"]

# Loop principal
while True:
    distance = measure_distance()
    print("Distancia: ", distance, " cm")
    
    if distance < 10:  # Si se detecta un vehículo a menos de 10 cm
        pin_code = ""
        while len(pin_code) < 4:
            key = read_keypad()
            if key:
                pin_code += key
                print("PIN ingresado: ", pin_code)
                utime.sleep(0.3)  # Esperar un poco para evitar múltiples lecturas de la misma tecla

        if verify_pin(pin_code):
            print("PIN correcto")
            # Realizar la acción necesaria
        else:
            print("PIN incorrecto")
            # Realizar la acción necesaria
    
    utime.sleep(1)  # Esperar 1 segundo antes de la próxima medición
