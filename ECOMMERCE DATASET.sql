SELECT * FROM ecommerce_analytics.ecommerce_orders;
SELECT 
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Sales) AS Avg_Order_Value,
    AVG(Discount) AS Avg_Discount
FROM ecommerce_analytics.ecommerce_orders;

SELECT
    Category,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_analytics.ecommerce_orders
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT
    Region,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    ProductName,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM ecommerce_analytics.ecommerce_orders
GROUP BY ProductName
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    CustomerID,
    CustomerName,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY CustomerID, CustomerName
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Gender,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Sales) AS Avg_Order_Value
FROM ecommerce_analytics.ecommerce_orders
GROUP BY Gender
ORDER BY Total_Sales DESC;

SELECT
    CASE
        WHEN Discount = 0 THEN '0% Discount'
        WHEN Discount <= 0.10 THEN '1–10% Discount'
        WHEN Discount <= 0.20 THEN '11–20% Discount'
        WHEN Discount <= 0.30 THEN '21–30% Discount'
        ELSE '30%+ Discount'
    END AS Discount_Band,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit) AS Avg_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY
    CASE
        WHEN Discount = 0 THEN '0% Discount'
        WHEN Discount <= 0.10 THEN '1–10% Discount'
        WHEN Discount <= 0.20 THEN '11–20% Discount'
        WHEN Discount <= 0.30 THEN '21–30% Discount'
        ELSE '30%+ Discount'
    END
ORDER BY Total_Sales DESC;

SELECT
    YEAR(OrderDate) AS Order_Year,
    MONTH(OrderDate) AS Order_Month,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    Order_Year,
    Order_Month;
    
    SELECT
    OrderStatus,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY OrderStatus
ORDER BY Total_Orders DESC;

SELECT
    PaymentMethod,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Sales) AS Avg_Order_Value
FROM ecommerce_analytics.ecommerce_orders
GROUP BY PaymentMethod
ORDER BY Total_Sales DESC;

SELECT
    City,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Region,
    Category,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY Region, Category
ORDER BY Total_Sales DESC;

SELECT
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND((SUM(Profit) / NULLIF(SUM(Sales), 0)) * 100, 2) AS Profit_Margin_Percent
FROM ecommerce_analytics.ecommerce_orders
GROUP BY Category
ORDER BY Profit_Margin_Percent DESC;

WITH MonthlySales AS (
    SELECT
        YEAR(OrderDate) AS Order_Year,
        MONTH(OrderDate) AS Order_Month,
        SUM(Sales) AS Total_Sales
    FROM ecommerce_analytics.ecommerce_orders
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    Order_Year,
    Order_Month,
    Total_Sales,
    LAG(Total_Sales) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Sales,
    ROUND(
        ((Total_Sales - LAG(Total_Sales) OVER (
            ORDER BY Order_Year, Order_Month
        )) / NULLIF(LAG(Total_Sales) OVER (
            ORDER BY Order_Year, Order_Month
        ), 0)) * 100,
        2
    ) AS MoM_Growth_Percent
FROM MonthlySales
ORDER BY Order_Year, Order_Month;

SELECT
    ProductName,
    Category,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY ProductName, Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC
LIMIT 10;

SELECT
    ProductName,
    Category,
    AVG(Discount) AS Avg_Discount,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM ecommerce_analytics.ecommerce_orders
GROUP BY ProductName, Category
HAVING AVG(Discount) >= 0.20
ORDER BY Total_Profit ASC
LIMIT 10;