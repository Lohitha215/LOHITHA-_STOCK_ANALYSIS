
use analysis_db;
CREATE TABLE stock_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    symbol VARCHAR(10),
    open_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    volume BIGINT,
    daily_return DECIMAL(10,4),
    trend VARCHAR(10)
);

ALTER TABLE stock_prices
ADD COLUMN MA_7 DECIMAL(10,2),
ADD COLUMN MA_30 DECIMAL(10,2);

DESCRIBE stock_prices;

SELECT COUNT(*) FROM stock_prices;

SELECT date, symbol, close_price
FROM stock_prices
ORDER BY date;

SELECT symbol,
       STDDEV(daily_return) AS volatility
FROM stock_prices
GROUP BY symbol
ORDER BY volatility DESC;

SELECT symbol,
(
    (AVG(volume * daily_return) - AVG(volume) * AVG(daily_return)) /
    SQRT(
        (AVG(volume * volume) - POW(AVG(volume), 2)) *
        (AVG(daily_return * daily_return) - POW(AVG(daily_return), 2))
    )
) AS correlation
FROM stock_prices
GROUP BY symbol;

SELECT symbol,
       AVG(daily_return) AS avg_return
FROM stock_prices
GROUP BY symbol
ORDER BY avg_return DESC;

SELECT symbol, trend, COUNT(*) AS days
FROM stock_prices
GROUP BY symbol, trend;

SELECT *
FROM stock_prices
WHERE volume > (
    SELECT AVG(volume) + 2*STDDEV(volume)
    FROM stock_prices
);
