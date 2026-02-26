# Financial Close Validation Engine

## Overview

This project simulates a structured financial month-end close control framework using SQL.

It models how enterprise ERP systems validate financial integrity before reporting and consolidation.

The engine includes:

- Posting period validation
- Double-entry balance checks
- Reversal integrity validation
- Subledger vs GL reconciliation (AR/AP)
- GR/IR clearing balance verification
- Aging analysis
- Aggregated close health summary view

---

## Business Context

In regulated environments (banking, capital markets, large corporates), financial close requires systematic validation before:

- Regulatory reporting
- Financial statement submission
- Consolidation
- Management reporting

Errors typically arise from:

- Postings in closed periods
- Unbalanced documents
- Missing reversals
- Subledger mismatches
- Clearing account residuals

This project models those control mechanisms in a simplified architecture.

---

## Architecture

The solution contains:

- `schema.sql` – Data model for ledger, AR/AP open items, and posting period control
- `sample_data.sql` – Close scenario sample transactions
- `controls.sql` – Detailed validation control queries
- `control_summary.sql` – Aggregated close health overview (dashboard-ready)

---

## Close Control Philosophy

Controls are structured across three layers:

1. Structural integrity (double-entry, reversals)
2. Reconciliation integrity (AR/AP vs GL, GR/IR)
3. Period governance (posting period enforcement)

This mirrors real-world close governance frameworks.

---

## Example Usage (PostgreSQL)

1. Run `schema.sql`
2. Run `sample_data.sql`
3. Run `controls.sql`
4. Run `control_summary.sql`

The summary view provides a high-level close health indicator.

---

## Purpose

This repository demonstrates:

- Financial systems architecture understanding
- Control-driven thinking
- SQL-based financial validation logic
- Close governance modeling

It is intended as a finance systems portfolio artifact.
