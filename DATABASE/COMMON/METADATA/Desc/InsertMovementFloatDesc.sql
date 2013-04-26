INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalSumm(), 'TotalSumm', 'Итого сумма по накладной (с учетом НДС и скидки)' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalSumm()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_VATPercent(), 'VATPercent', '% НДС' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_VATPercent()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_DiscountPercent(), 'DiscountPercent', '% Скидки' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_DiscountPercent()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_ExtraChargesPercent(), 'ExtraChargesPercent', '% Наценки' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_ExtraChargesPercent()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalCountKg(), 'TotalCountKg', 'Итого количество, кг' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalCountKg()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalCountSh(), 'TotalCountSh', 'Итого количество, шт' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalCountSh()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalCountTare(), 'TotalCountTare', 'Итого количество, тары' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalCountTare()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalCount(), 'TotalCount', 'Итого количество' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalCount()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalSummMVAT(), 'TotalSummMVAT', 'Итого сумма по накладной (без НДС)' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalSummMVAT()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalSummPVAT(), 'TotalSummPVAT', 'Итого сумма по накладной (с НДС)' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalSummPVAT()); 

INSERT INTO MovementFloatDesc(Id, Code, ItemName)
SELECT zc_MovementFloat_TotalSpending(), 'TotalSpending', 'Итого сумма затрат по накладной (с учетом НДС)' 
       WHERE NOT EXISTS (SELECT * FROM MovementFloatDesc WHERE Id = zc_MovementFloat_TotalSpending()); 
