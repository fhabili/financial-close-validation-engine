/*
CONTROL SUMMARY VIEW
Provides high-level close health overview
*/

WITH doc_balance AS (
    SELECT
        COUNT(*) AS total_docs,
        SUM(CASE WHEN net_balance <> 0 THEN 1 ELSE 0 END) AS unbalanced_docs
    FROM (
        SELECT doc_id,
               SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) AS net_balance
        FROM gl_entries
        GROUP BY doc_id
    ) t
),

grir_check AS (
    SELECT
        COALESCE(SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END),0) AS grir_balance
    FROM gl_entries
    WHERE account='200000'
),

ar_diff AS (
    SELECT
        COALESCE(ar_gl_balance - ar_open,0) AS ar_difference
    FROM (
        SELECT SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) AS ar_gl_balance
        FROM gl_entries
        WHERE account='110000'
    ) gl,
    (
        SELECT SUM(amount_gross) AS ar_open
        FROM ar_open_items
        WHERE status='OPEN'
    ) sl
)

SELECT
    total_docs,
    unbalanced_docs,
    grir_balance,
    ar_difference
FROM doc_balance, grir_check, ar_diff;
