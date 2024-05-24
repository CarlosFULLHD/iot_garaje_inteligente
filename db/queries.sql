
-- Comparación de Horas de Entrada y Salida
SELECT 
    user_id,
    scheduled_entry,
    actual_entry,
    TIMESTAMPDIFF(MINUTE, scheduled_entry, actual_entry) AS entry_delay,
    scheduled_exit,
    actual_exit,
    TIMESTAMPDIFF(MINUTE, scheduled_exit, actual_exit) AS exit_delay
FROM reservations;


-- Reservas No Utilizadas
SELECT 
    COUNT(*) AS unused_reservations
FROM reservations
WHERE actual_entry IS NULL AND actual_exit IS NULL;

-- Porcentaje de Usuarios que Salen Tarde
SELECT 
    COUNT(*) AS late_exits,
    (COUNT(*) / (SELECT COUNT(*) FROM reservations) * 100) AS late_exit_percentage
FROM reservations
WHERE TIMESTAMPDIFF(MINUTE, scheduled_exit, actual_exit) > 0;


-- Horas de Mayor Ocupación
SELECT 
    HOUR(actual_entry) AS hour, 
    COUNT(*) AS number_of_entries
FROM reservations
WHERE actual_entry IS NOT NULL
GROUP BY HOUR(actual_entry)
ORDER BY number_of_entries DESC;


-- Espacios Más Demandados
SELECT 
    spot_id, 
    COUNT(*) AS reservation_count
FROM reservations
GROUP BY spot_id
ORDER BY reservation_count DESC;



