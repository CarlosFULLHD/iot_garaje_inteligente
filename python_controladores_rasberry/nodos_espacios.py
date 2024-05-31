from machine import Pin
from Wifi_lib import wifi_init
import utime
import urequests

# Configuración de pines
trig = Pin(2, Pin.OUT)
echo = Pin(3, Pin.IN)
ledR = Pin(6, Pin.OUT)
ledG = Pin(7, Pin.OUT)
ledB = Pin(8, Pin.OUT)

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

# Función para actualizar el estado del espacio
def update_space_status(space_id, status):
    url = "http://192.168.137.1:8080/api/v1/parkings/spots/update"
    try:
        response = urequests.post(url, json={"spaceId": space_id, "status": status})
        response.close()  # Cerrar la respuesta para liberar memoria
    except Exception as e:
        print("Error al actualizar el estado del espacio:", e)

# Función para verificar el estado del espacio
def check_space_status(space_id):
    url = f"http://192.168.137.1:8080/api/v1/parkings/spots/{space_id}"
    try:
        response = urequests.get(url)
        data = response.json()
        response.close()  # Cerrar la respuesta para liberar memoria
        return data["status"]
    except Exception as e:
        print("Error al verificar el estado del espacio:", e)
        return None

# ID del espacio correspondiente
space_id = 1  # Configurar esto para cada Raspberry Pi

# Loop principal
while True:
    distance = measure_distance()
    print("Distancia: ", distance, " cm")
    
    if distance < 10:  # Si se detecta un vehículo a menos de 10 cm
        ledR.value(1)
        ledG.value(0)
        ledB.value(0)
        update_space_status(space_id, "0")
    else:
        ledR.value(0)
        # Verificar si está reservado
        status = check_space_status(space_id)
        if status == 2:
            ledG.value(0)
            ledB.value(1)
        else:
            ledB.value(0)
            ledG.value(1)
            update_space_status(space_id, "1")
