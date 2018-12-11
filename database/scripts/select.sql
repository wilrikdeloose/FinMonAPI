-- Query for the sum of all transactions per month.
SELECT
  Month,
  ROUND(-1 * getAmount(month, ''), 2) AS Total,
  ROUND(-1 * getAmount(month, 'food'), 2) AS 'Total food',
  ROUND(-1 * getAmount(month, 'groceries'), 2) AS 'Total groceries',
  ROUND(-1 * getAmount(month, 'fuel'), 2) AS 'Total fuel'
FROM
  transaction_details td
GROUP BY
  Month
ORDER BY
  month DESC;