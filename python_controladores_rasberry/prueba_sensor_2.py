from machine import Pin
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

# Loop principal
while True:
    distance = measure_distance()
    print("Distancia promedio: ", distance, " cm")
    
    # Encender el LED correspondiente
    if distance < 10:
        ledR.value(1)
        ledG.value(0)
    else:
        ledR.value(0)
        ledG.value(1)
    
    # Esperar un segundo antes de la próxima medición
    utime.sleep(1)
