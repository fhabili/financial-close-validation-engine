/*
FINANCIAL CLOSE CONTROL PACK

C1 Posting period control (no postings in closed periods)
C2 Document balance integrity (double-entry)
C3 Reversal integrity
C4 AR subledger vs GL reconciliation
C5 AP subledger vs GL reconciliation
C6 GR/IR clearing balance
C7 AR aging view
*/

------------------------------------------------------------
-- C1: Posting period control
-- Expected result: 0 rows (no postings in closed periods)
------------------------------------------------------------
SELECT g.doc_id, g.posting_date, g.company_code
FROM gl_entries g
JOIN posting_period_control p
  ON p.company_code = g.company_code
 AND p.fiscal_year  = EXTRACT(YEAR FROM g.posting_date)
 AND p.period       = EXTRACT(MONTH FROM g.posting_date)
WHERE p.is_open = FALSE
GROUP BY g.doc_id, g.posting_date, g.company_code
ORDER BY g.posting_date, g.doc_id;

------------------------------------------------------------
-- C2: Document balance integrity
-- Expected result: 0 rows
------------------------------------------------------------
SELECT doc_id, ledger,
       SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) AS net_balance
FROM gl_entries
GROUP BY doc_id, ledger
HAVING SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) <> 0;

------------------------------------------------------------
-- C3: Reversal integrity
-- Expected result: 0 rows (reversal_flag=true must reference original doc)
------------------------------------------------------------
SELECT doc_id, ledger, posting_date
FROM gl_entries
WHERE reversal_flag = TRUE AND reversed_doc_id IS NULL;

------------------------------------------------------------
-- C4: AR subledger vs GL
-- Expected result: difference = 0
------------------------------------------------------------
WITH ar_gl AS (
  SELECT SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) AS ar_gl_balance
  FROM gl_entries
  WHERE account='110000'
),
ar_sl AS (
  SELECT SUM(amount_gross) AS ar_open
  FROM ar_open_items
  WHERE status='OPEN'
)
SELECT ar_gl.ar_gl_balance, ar_sl.ar_open,
       (ar_gl.ar_gl_balance - ar_sl.ar_open) AS difference
FROM ar_gl, ar_sl;

------------------------------------------------------------
-- C5: AP subledger vs GL
-- Expected result: difference = 0
------------------------------------------------------------
WITH ap_gl AS (
  SELECT SUM(CASE WHEN dc_indicator='C' THEN amount ELSE -amount END) AS ap_gl_balance
  FROM gl_entries
  WHERE account='300000'
),
ap_sl AS (
  SELECT SUM(amount_gross) AS ap_open
  FROM ap_open_items
  WHERE status='OPEN'
)
SELECT ap_gl.ap_gl_balance, ap_sl.ap_open,
       (ap_gl.ap_gl_balance - ap_sl.ap_open) AS difference
FROM ap_gl, ap_sl;

------------------------------------------------------------
-- C6: GR/IR clearing balance
-- Expected result: 0 rows
------------------------------------------------------------
SELECT
  SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) AS grir_net_balance
FROM gl_entries
WHERE account='200000'
HAVING SUM(CASE WHEN dc_indicator='D' THEN amount ELSE -amount END) <> 0;

------------------------------------------------------------
-- C7: AR aging view
------------------------------------------------------------
SELECT
  CASE
    WHEN CURRENT_DATE - posting_date <= 30 THEN '0-30'
    WHEN CURRENT_DATE - posting_date <= 60 THEN '31-60'
    ELSE '60+'
  END AS aging_bucket,
  SUM(amount_gross) AS amount
FROM ar_open_items
WHERE status='OPEN'
GROUP BY aging_bucket
ORDER BY aging_bucket;
