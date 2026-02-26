-- Financial Close Validation Engine (PostgreSQL)

-- 1) Posting period control (simulates OB52-like logic)
CREATE TABLE posting_period_control (
  company_code TEXT NOT NULL,
  fiscal_year  INT  NOT NULL,
  period       INT  NOT NULL,
  is_open      BOOLEAN NOT NULL,
  PRIMARY KEY (company_code, fiscal_year, period)
);

-- 2) Universal journal-like postings (simplified)
CREATE TABLE gl_entries (
  doc_id        TEXT NOT NULL,
  line_no       INT  NOT NULL,
  company_code  TEXT NOT NULL,
  ledger        TEXT NOT NULL,      -- e.g., '0L', '2L'
  posting_date  DATE NOT NULL,
  account       TEXT NOT NULL,
  account_type  TEXT NOT NULL,      -- 'REV','EXP','BS'
  dc_indicator  CHAR(1) NOT NULL,   -- 'D' or 'C'
  amount        NUMERIC(15,2) NOT NULL,
  profit_center_id TEXT,
  cost_center_id   TEXT,
  reversed_doc_id  TEXT,
  reversal_flag    BOOLEAN DEFAULT FALSE,
  description      TEXT,
  PRIMARY KEY (doc_id, line_no, ledger)
);

-- 3) AR/AP Subledgers (open items)
CREATE TABLE ar_open_items (
  customer_id  TEXT NOT NULL,
  doc_id       TEXT NOT NULL,
  posting_date DATE NOT NULL,
  amount_gross NUMERIC(15,2) NOT NULL,
  status       TEXT NOT NULL  -- 'OPEN','CLEARED'
);

CREATE TABLE ap_open_items (
  vendor_id    TEXT NOT NULL,
  doc_id       TEXT NOT NULL,
  posting_date DATE NOT NULL,
  amount_gross NUMERIC(15,2) NOT NULL,
  status       TEXT NOT NULL  -- 'OPEN','CLEARED'
);
