-- ==========================================
-- REPORTING LAYER SIMULATION
-- Validation -> Aggregation -> Reporting
-- ==========================================

-- 1) Monthly revenue reporting view
SELECT
    company_code,
    DATE_TRUNC('month', posting_date) AS reporting_period,
    SUM(
        CASE
            WHEN dc_indicator = 'C' THEN amount
            ELSE -amount
        END
    ) AS total_revenue
FROM gl_entries
WHERE account_type = 'REV'
GROUP BY company_code, DATE_TRUNC('month', posting_date)
ORDER BY company_code, reporting_period;


-- 2) Accounts receivable open balance summary
SELECT
    company_code,
    customer_id,
    SUM(amount_gross) AS total_ar_open
FROM customer_subledger
WHERE status = 'OPEN'
GROUP BY company_code, customer_id
ORDER BY company_code, total_ar_open DESC;


-- 3) Accounts payable open balance summary
SELECT
    company_code,
    vendor_id,
    SUM(amount_gross) AS total_ap_open
FROM vendor_subledger
WHERE status = 'OPEN'
GROUP BY company_code, vendor_id
ORDER BY company_code, total_ap_open DESC;


-- 4) GR/IR open balance summary
SELECT
    company_code,
    account AS grir_account,
    SUM(
        CASE
            WHEN dc_indicator = 'D' THEN amount
            ELSE -amount
        END
    ) AS grir_balance
FROM gl_entries
WHERE account = '200000'
GROUP BY company_code, account
ORDER BY company_code;


-- 5) Simple P&L reporting view
SELECT
    company_code,
    account_type,
    SUM(
        CASE
            WHEN account_type = 'REV' AND dc_indicator = 'C' THEN amount
            WHEN account_type = 'REV' AND dc_indicator = 'D' THEN -amount
            WHEN account_type = 'EXP' AND dc_indicator = 'D' THEN amount
            WHEN account_type = 'EXP' AND dc_indicator = 'C' THEN -amount
            ELSE 0
        END
    ) AS total_amount
FROM gl_entries
WHERE account_type IN ('REV', 'EXP')
GROUP BY company_code, account_type
ORDER BY company_code, account_type;
