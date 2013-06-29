--------------------------- !!!!!!!!!!!!!!!!!!!
--------------------------- !!! НОВАЯ СХЕМА !!!
--------------------------- !!!!!!!!!!!!!!!!!!!


INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_AmountPartner', 'Количество у контрагента'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountPartner'); 
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_AmountPacker', 'Количество у заготовителя'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountPacker');

INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_Price', 'Цена' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_Price'); 
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_CountForPrice', 'Цена за количество' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_CountForPrice'); 


INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_LiveWeight', 'Живой вес' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_LiveWeight');
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_HeadCount', 'Количество голов' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_HeadCount');
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_RealWeight', 'Реальный вес' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_RealWeight');

INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_Count', 'Количество батонов или упаковок' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_Count');

INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_CuterCount', 'Количество кутеров' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_CuterCount');
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MovementItemFloat_AmountReceipt', 'Количество по рецептуре на 1 кутер' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MovementItemFloat_AmountReceipt');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.06.13                                        * НОВАЯ СХЕМА
 29.06.13                                        * zc_MovementItemFloat_AmountPacker
*/
