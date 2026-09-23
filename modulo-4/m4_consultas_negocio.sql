USE Ventas_Tech_DB;
GO
--consulta 1--
SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

--consulta 2--
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--consulta 3--
SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

--consulta 4--
WITH resumen_mensual AS (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT 
    mes,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM resumen_mensual) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM resumen_mensual;

-- Hallazgo 1: el producto 1 (Laptop Pro 15) concentra el 56% de la facturación total 
-- ($3.600 de $6.444), muy por delante del segundo producto más vendido (producto 3, $1.350).

-- Hallazgo 2: los 5 clientes de la base realizaron exactamente 2 pedidos cada uno, 
-- por lo que el 100% de la cartera calificó como "cliente recurrente" en esta muestra, 
-- sin ningún caso de compra única. El cliente 1 fue el de mayor gasto acumulado ($2.640).

-- Hallazgo 3: como todos los registros de venta corresponden a marzo de 2024, 
-- la comparación mes a mes de la Consulta 4 no es representativa todavía; 
-- se necesitarán datos de más meses para detectar tendencias reales de estacionalidad.
