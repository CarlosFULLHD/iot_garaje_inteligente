from machine import Pin
import utime
import urequests
from wifi_lib import wifi_init

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
        # Valor por defecto si todas las lecturas fueron atípicas
        average_distance = threshold

    return average_distance

# Función para actualizar el estado del espacio


def update_space_status(space_id, status):
    # Cambia esto a la URL correcta de tu backend
    url = "http://<IP_DE_TU_BACKEND>:8080/api/v1/parkings/spaces/update"
    data = {"spaceId": space_id, "status": status}
    headers = {'Content-Type': 'application/json'}
    response = urequests.post(url, json=data, headers=headers)
    response.close()


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
        update_space_status(space_id, 0)  # Estado 0 para "ocupado"
    else:
        ledR.value(0)
        # Verificar si está reservado
        # Cambia esto a la URL correcta de tu backend
        response = urequests.get(
            f"http://<IP_DE_TU_BACKEND>:8080/api/v1/parkings/spaces/{space_id}")
        data = response.json()
        if data["status"] == 2:  # Estado 2 para "reservado"
            ledG.value(0)
            ledB.value(1)
        else:
            ledB.value(0)
            ledG.value(1)
            update_space_status(space_id, 1)  # Estado 1 para "disponible"

    utime.sleep(10)  # Esperar 10 segundos antes de la próxima medición
