from machine import Pin, time_pulse_us
import time
import urequests
import sqlite3

# Configuración de pines
trigger = Pin(2, Pin.OUT)
echo = Pin(3, Pin.IN)
led_verde = Pin(6, Pin.OUT)
led_amarillo = Pin(7, Pin.OUT)
led_rojo = Pin(8, Pin.OUT)
barrera = Pin(9, Pin.OUT)

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

# Función para verificar la reserva
def check_reservation(keypad_code):
    url = "http://tu-servidor-api/reservations/check"
    response = urequests.post(url, json={"keypad_code": keypad_code})
    if response.status_code == 200:
        data = response.json()
        if data["status"] == "valid":
            return data["space_id"]
    return None

# Función para actualizar el estado del espacio
def update_space_status(space_id, status):
    url = "http://tu-servidor-api/spaces/update"
    urequests.post(url, json={"space_id": space_id, "status": status})

# Loop principal
while True:
    distance = measure_distance()
    if distance < 10:  # Si se detecta un vehículo a menos de 10 cm
        keypad_code = input("Ingrese el código de reserva: ")  # Simulación de entrada de código
        space_id = check_reservation(keypad_code)
        if space_id:
            led_amarillo.off()
            led_rojo.off()
            led_verde.on()
            barrera.on()  # Abrir barrera
            time.sleep(5)  # Esperar 5 segundos
            barrera.off()  # Cerrar barrera
            update_space_status(space_id, "occupied")
        else:
            led_verde.off()
            led_rojo.on()
    else:
        led_verde.off()
        led_amarillo.on()
    time.sleep(1)
