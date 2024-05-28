from machine import Pin
import utime

# Configuración de pines
trig = Pin(2, Pin.OUT)
echo = Pin(3, Pin.IN)
ledR = Pin(6, Pin.OUT)
ledG = Pin(7, Pin.OUT)
ledB = Pin(8, Pin.OUT)

# Inicializar el trigger a bajo
trig.value(0)

while True:
    # Enviar un pulso al trigger
    trig.value(1)
    utime.sleep_us(10)
    trig.value(0)
    
    # Medir el tiempo de ida y vuelta del pulso
    t1 = utime.ticks_us()
    while echo.value() == 0:
        t1 = utime.ticks_us()
    while echo.value() == 1:
        t2 = utime.ticks_us()
    
    # Calcular la distancia
    t = t2 - t1
    d = 17*t/1000  # Convertir el tiempo en microsegundos a distancia en cm
    
    print("Distancia: ", d, " cm")
    
    # Encender el LED correspondiente
    if d < 10:
        ledR.value(1)
        ledG.value(0)
    else:
        ledR.value(0)
        ledG.value(1)
    
    # Esperar un segundo antes de la próxima medición
    utime.sleep(1)
