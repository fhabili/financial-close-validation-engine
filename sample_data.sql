-- Sample configuration: Jan open, Feb closed
INSERT INTO posting_period_control VALUES
('1000', 2026, 1, TRUE),
('1000', 2026, 2, FALSE);

-- Doc 1001: Customer invoice (AR + Revenue)
INSERT INTO gl_entries VALUES
('1001',1,'1000','0L','2026-01-15','110000','BS','D',10000,'PC_A',NULL,NULL,FALSE,'Customer invoice AR'),
('1001',2,'1000','0L','2026-01-15','400000','REV','C',10000,'PC_A',NULL,NULL,FALSE,'Customer invoice Revenue');

INSERT INTO ar_open_items VALUES
('CUST01','1001','2026-01-15',10000,'OPEN');

-- Doc 1002: Vendor invoice (Expense + AP)
INSERT INTO gl_entries VALUES
('1002',1,'1000','0L','2026-01-20','500000','EXP','D',6000,'PC_A','CC_01',NULL,FALSE,'Vendor invoice Expense'),
('1002',2,'1000','0L','2026-01-20','300000','BS','C',6000,NULL,NULL,NULL,FALSE,'Vendor invoice AP');

INSERT INTO ap_open_items VALUES
('VEND01','1002','2026-01-20',6000,'OPEN');

-- Doc 1003: GR/IR mismatch example
INSERT INTO gl_entries VALUES
('1003',1,'1000','0L','2026-01-25','200000','BS','D',2000,NULL,NULL,NULL,FALSE,'GR/IR posted (should clear later)'),
('1003',2,'1000','0L','2026-01-25','500000','EXP','C',2000,NULL,NULL,NULL,FALSE,'Offset line');

-- Doc 2001: Illegal posting in closed period (Feb)
INSERT INTO gl_entries VALUES
('2001',1,'1000','0L','2026-02-05','110000','BS','D',500,NULL,NULL,NULL,FALSE,'Illegal Feb posting'),
('2001',2,'1000','0L','2026-02-05','400000','REV','C',500,NULL,NULL,NULL,FALSE,'Illegal Feb posting');

-- Reversal example: reverse doc 1002
INSERT INTO gl_entries VALUES
('9002',1,'1000','0L','2026-01-28','500000','EXP','C',6000,'PC_A','CC_01','1002',TRUE,'Reversal expense'),
('9002',2,'1000','0L','2026-01-28','300000','BS','D',6000,NULL,NULL,'1002',TRUE,'Reversal AP');
