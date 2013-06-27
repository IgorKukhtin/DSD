INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_AmountPartner(), 'AmountPartner', 'Количество у контрагента' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_AmountPartner()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_Price(), 'Price', 'Цена' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_Price()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_CountForPrice(), 'CountForPrice', 'Цена за количество' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_CountForPrice()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_LiveWeight(), 'LiveWeight', 'Живой вес' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_LiveWeight()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_HeadCount(), 'HeadCount', 'Количество голов' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_HeadCount()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_Count(), 'Count', 'Количество голов' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_Count()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_RealWeight(), 'RealWeight', 'Реальный вес' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_RealWeight()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_CuterCount(), 'CuterCount', 'Количество кутеров' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_CuterCount()); 

INSERT INTO MovementItemFloatDesc(Id, Code, ItemName)
SELECT zc_MovementItemFloat_AmountReceipt(), 'AmountReceipt', 'Количество кутеров' 
       WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Id = zc_MovementItemFloat_AmountReceipt()); 


--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!
