import requests
import pandas as pd
import panel as pn
from bokeh.plotting import figure
from bokeh.models import Title
import re
import os

# Función para obtener la ruta relativa de la imagen
def get_icon_path(icon_name):
    return f'/assets/img/{icon_name}'

# Ruta a las imágenes de iconos
ICON_PATHS = {
    "entry_exit_differences": get_icon_path("arriba-y-abajo.png"),
    "unutilized_reservations": get_icon_path("reservas_sin_usar.png"),
    "late_exits_percentage": get_icon_path("porcentaje.png"),
    "peak_hours": get_icon_path("hora-pico.png"),
    "frequent_users": get_icon_path("usuario-frecuente.png"),
    "demanded_spots": get_icon_path("garaje.png"),
    "demanded_parkings": get_icon_path("estacionamiento.png")
}

# Cargar el archivo CSS
pn.extension(css_files=['/assets/css/dashboard_styles.css'])

pn.extension(sizing_mode="stretch_width")

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

def styled_figure(title):
    fig = figure(title=title, height=250, background_fill_color="#2e2e2e", border_fill_color="#2e2e2e")
    fig.title.text_color = "white"
    fig.title.text_font_size = "18pt"
    fig.xaxis.axis_label_text_color = "white"
    fig.yaxis.axis_label_text_color = "white"
    fig.xaxis.major_label_text_color = "white"
    fig.yaxis.major_label_text_color = "white"
    fig.xgrid.grid_line_color = "white"
    fig.ygrid.grid_line_color = "white"
    fig.sizing_mode = 'stretch_width'
    return fig

def styled_bar_figure(title):
    fig = styled_figure(title)
    fig.vbar(x=[], top=[], width=0.9, color='blue', alpha=0.5)
    return fig

def styled_line_figure(title):
    fig = styled_figure(title)
    fig.line(x=[], y=[], color="red", line_width=2, alpha=0.5)
    fig.scatter(x=[], y=[], size=8, color="red", alpha=0.5)
    return fig

def card_with_icon(icon_path, title, content, small=False):
    css_classes = ["card"]
    if small:
        css_classes.append("small-card")
    return pn.Column(
        pn.Row(pn.pane.HTML(f'<img src="{icon_path}" class="card-header-icon"> <span class="card-header-title">{title}</span>'), align="center", sizing_mode="stretch_width", css_classes=["card-header"]),
        pn.pane.Markdown(content, css_classes=["card-content"]),
        css_classes=css_classes,
        sizing_mode="stretch_width"
    )


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

            p1 = styled_line_figure("Diferencias de Entrada y Salida")
            p1.line(data['reservationId'], data['entry_difference'], legend_label='Entrada', line_color='#fc9f66', line_width=2, alpha=0.5)
            p1.line(data['reservationId'], data['exit_difference'], legend_label='Salida', line_color='#209ebb', line_width=2, alpha=0.5)
            p1.scatter(data['reservationId'], data['entry_difference'], size=8, color='#fc9f66', alpha=0.5)
            p1.scatter(data['reservationId'], data['exit_difference'], size=8, color='#209ebb', alpha=0.5)

            card_p1 = card_with_icon(ICON_PATHS["entry_exit_differences"], "Diferencias de Entrada y Salida", "", small=False)
            card_p1.append(p1)
            widgets.append(card_p1)

    # Reservas no utilizadas
    card_unutilized_reservations = card_with_icon(ICON_PATHS["unutilized_reservations"], "Reservas no utilizadas", f"<div style='margin-top: 30px;'>{unutilized_reservations} reservas 📝</div>", small=True)

    # Porcentaje de salidas tardías
    card_late_exits_percentage = card_with_icon(ICON_PATHS["late_exits_percentage"], "Porcentaje de Salidas Tardías", f"<div style='margin-top: 30px;'>{late_exits_percentage:.2f}% ⏲️</div>", small=True)

    # Agrupar las tarjetas pequeñas en una fila
    small_cards_row = pn.Row(card_unutilized_reservations, card_late_exits_percentage, css_classes=["small-card-row"], height=200)
    widgets.append(small_cards_row)

    # Horas pico
    if peak_hours:
        data = pd.DataFrame(peak_hours)
        data['hour'] = pd.to_datetime(data['hour'])
        p4 = styled_bar_figure("Horas Pico")
        p4.vbar(x=data['hour'], top=data['count'], width=3600000, color='#209ebb', alpha=0.5)  # 3600000 ms = 1 hour

        card_p4 = card_with_icon(ICON_PATHS["peak_hours"], "Horas Pico", "", small=False)
        card_p4.append(p4)
        widgets.append(card_p4)

    # Usuarios frecuentes
    if frequent_users:
        data = pd.DataFrame(frequent_users)
        p5 = styled_bar_figure("Usuarios Frecuentes")
        p5.vbar(x=data['userId'], top=data['count'], width=0.9, color='#ffb701', alpha=0.5)

        card_p5 = card_with_icon(ICON_PATHS["frequent_users"], "Usuarios Frecuentes", "", small=False)
        card_p5.append(p5)
        widgets.append(card_p5)

    # Espacios más demandados
    if demanded_spots:
        data = pd.DataFrame(demanded_spots)
        p6 = styled_bar_figure("Espacios Más Demandados")
        p6.vbar(x=data['spotId'], top=data['count'], width=0.9, color='#fc9f66', alpha=0.5)

        card_p6 = card_with_icon(ICON_PATHS["demanded_spots"], "Espacios Más Demandados", "", small=False)
        card_p6.append(p6)
        widgets.append(card_p6)

    # Estacionamientos más demandados
    if demanded_parkings:
        data = pd.DataFrame(demanded_parkings)
        p7 = styled_bar_figure("Estacionamientos Más Demandados")
        p7.vbar(x=data['parkingId'], top=data['count'], width=0.9, color='#adebbe', alpha=0.5)

        card_p7 = card_with_icon(ICON_PATHS["demanded_parkings"], "Estacionamientos Más Demandados", "", small=False)
        card_p7.append(p7)
        widgets.append(card_p7)

    return pn.Column(*[pn.Row(*widgets[i:i+2]) for i in range(0, len(widgets), 2)], height_policy='fit')

# Configuración del dashboard
update_button = pn.widgets.Button(name='Actualizar Dashboard', button_type='primary', css_classes=['update-button'], width=150)
update_button_container = pn.Row(pn.layout.HSpacer(), update_button, css_classes=['update-button-container'])
dashboard = crear_graficos()

def update_dashboard(event):
    global dashboard
    new_dashboard = crear_graficos()
    dashboard.objects = new_dashboard.objects

update_button.on_click(update_dashboard)

# Servir el dashboard
pn.serve({'/': pn.Column(update_button_container, dashboard)}, static_dirs={'/assets/img': './img', '/assets/css': './css'}, title="Parking Dashboard", port=9091, show=True)
