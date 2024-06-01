import requests
import pandas as pd
import panel as pn
from bokeh.plotting import figure
from bokeh.models import Title
import re

pn.extension()

# URLs base de los endpoints
BASE_URL = "http://localhost:8080/api/v1/parkings"

# Funciones para obtener datos de los endpoints
def fetch_entry_exit_differences():
    response = requests.get(f"{BASE_URL}/reservations/entry-exit-differences")
    return response.json()

def fetch_unutilized_reservations():
    response = requests.get(f"{BASE_URL}/reservations/unutilized")
    return response.json()

def fetch_late_exits_percentage():
    response = requests.get(f"{BASE_URL}/reservations/late-exits-percentage")
    return response.json()

def fetch_peak_hours():
    response = requests.get(f"{BASE_URL}/peak-hours")
    return response.json()

def fetch_frequent_users():
    response = requests.get(f"{BASE_URL}/users/frequent-users")
    return response.json()

def fetch_demanded_spots():
    response = requests.get(f"{BASE_URL}/demanded-spots")
    return response.json()

def fetch_demanded_parkings():
    response = requests.get(f"{BASE_URL}/demanded-parkings")
    return response.json()

def parse_duration(duration):
    """Parses an ISO 8601 duration string, handling negative durations."""
    match = re.match(r'PT(?P<sign>-)?(?P<hours>\d+H)?(?P<minutes>\d+M)?(?P<seconds>\d+\.?\d*S)?', duration)
    if not match:
        return 0

    sign = -1 if match.group('sign') else 1
    hours = int(match.group('hours')[:-1]) if match.group('hours') else 0
    minutes = int(match.group('minutes')[:-1]) if match.group('minutes') else 0
    seconds = float(match.group('seconds')[:-1]) if match.group('seconds') else 0

    total_minutes = sign * (hours * 60 + minutes + seconds / 60)
    return total_minutes

# Función para crear las gráficas
def crear_graficos():
    # Obtener datos
    entry_exit_differences = fetch_entry_exit_differences()
    unutilized_reservations = fetch_unutilized_reservations()
    late_exits_percentage = fetch_late_exits_percentage()
    peak_hours = fetch_peak_hours()
    frequent_users = fetch_frequent_users()
    demanded_spots = fetch_demanded_spots()
    demanded_parkings = fetch_demanded_parkings()

    widgets = []

    # Gráfica de diferencias entre horas de entrada y salida
    if entry_exit_differences:
        data = pd.DataFrame(entry_exit_differences)
        if 'entryDifference' in data.columns and 'exitDifference' in data.columns:
            data['entry_difference'] = data['entryDifference'].apply(parse_duration)
            data['exit_difference'] = data['exitDifference'].apply(parse_duration)

            p1 = figure(title="Diferencias de Entrada y Salida", x_axis_label='Reserva ID', y_axis_label='Diferencia en Minutos', height=250)
            p1.line(data['reservationId'], data['entry_difference'], legend_label='Entrada', line_color='blue', line_width=2)
            p1.line(data['reservationId'], data['exit_difference'], legend_label='Salida', line_color='red', line_width=2)
            p1.add_layout(Title(text="Diferencias de Entrada y Salida", text_font_size="16pt", text_font_style="bold"), 'above')

            widgets.append(p1)

    # Reservas no utilizadas
    p2 = pn.pane.Markdown(f"**Reservas no utilizadas:** {unutilized_reservations} reservas")
    widgets.append(p2)

    # Porcentaje de salidas tardías
    p3 = pn.pane.Markdown(f"**Porcentaje de Salidas Tardías:** {late_exits_percentage:.2f}%")
    widgets.append(p3)

    # Horas pico
    if peak_hours:
        data = pd.DataFrame(peak_hours)
        data['hour'] = pd.to_datetime(data['hour'])
        p4 = figure(title="Horas Pico", x_axis_label='Hora', y_axis_label='Cantidad', x_axis_type='datetime', height=250)
        p4.vbar(x=data['hour'], top=data['count'], width=3600000, color='blue')  # 3600000 ms = 1 hour
        p4.add_layout(Title(text="Horas Pico", text_font_size="16pt", text_font_style="bold"), 'above')

        widgets.append(p4)

    # Usuarios frecuentes
    if frequent_users:
        data = pd.DataFrame(frequent_users)
        p5 = figure(title="Usuarios Frecuentes", x_axis_label='Usuario ID', y_axis_label='Cantidad de Reservas', height=250)
        p5.vbar(x=data['userId'], top=data['count'], width=0.9, color='green')
        p5.add_layout(Title(text="Usuarios Frecuentes", text_font_size="16pt", text_font_style="bold"), 'above')

        widgets.append(p5)

    # Espacios más demandados
    if demanded_spots:
        data = pd.DataFrame(demanded_spots)
        p6 = figure(title="Espacios Más Demandados", x_axis_label='Espacio ID', y_axis_label='Cantidad de Reservas', height=250)
        p6.vbar(x=data['spotId'], top=data['count'], width=0.9, color='orange')
        p6.add_layout(Title(text="Espacios Más Demandados", text_font_size="16pt", text_font_style="bold"), 'above')

        widgets.append(p6)

    # Estacionamientos más demandados
    if demanded_parkings:
        data = pd.DataFrame(demanded_parkings)
        p7 = figure(title="Estacionamientos Más Demandados", x_axis_label='Estacionamiento ID', y_axis_label='Cantidad de Reservas', height=250)
        p7.vbar(x=data['parkingId'], top=data['count'], width=0.9, color='purple')
        p7.add_layout(Title(text="Estacionamientos Más Demandados", text_font_size="16pt", text_font_style="bold"), 'above')

        widgets.append(p7)

    return pn.Column(*widgets, height_policy='fit')

# Configuración del dashboard
update_button = pn.widgets.Button(name='Actualizar Dashboard', button_type='primary')
dashboard = crear_graficos()

def update_dashboard(event):
    global dashboard
    new_dashboard = crear_graficos()
    dashboard.objects = new_dashboard.objects

update_button.on_click(update_dashboard)

# Servir el dashboard
pn.Column(update_button, dashboard).servable()
pn.serve(pn.Column(update_button, dashboard), title="Parking Dashboard", show=True)
