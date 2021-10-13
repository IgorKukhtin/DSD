CREATE OR REPLACE FUNCTION zc_MIFloat_OperPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_OperPrice', 'Цена' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_CountForPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_CountForPrice', 'Цена за количество' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_CountForPrice');
  
CREATE OR REPLACE FUNCTION zc_MIFloat_AmountPartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountPartner', 'Количество у контрагента'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountPartner');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountBasis() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountBasis'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountBasis', 'Количество шаблон сборки'  WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountBasis');

CREATE OR REPLACE FUNCTION zc_MIFloat_AmountSecond() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_AmountSecond', 'Количество дополнительное' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_AmountSecond');

CREATE OR REPLACE FUNCTION zc_MIFloat_Summ() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_Summ', 'Сумма' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Summ');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPriceList() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPriceList', 'Цена без скидки' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPriceList');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPricePartner() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPricePartner'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPricePartner', 'Цена у контрагента' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPricePartner');

CREATE OR REPLACE FUNCTION zc_MIFloat_BasisPrice() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BasisPrice'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_BasisPrice', 'Базовая цена лодки без скидки' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_BasisPrice');

CREATE OR REPLACE FUNCTION zc_MIFloat_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_MovementId', 'Ссылка на документ' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId');

CREATE OR REPLACE FUNCTION zc_MIFloat_OperPrice_orig() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice_orig'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_OperPrice_orig', 'Цена вх.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_OperPrice_orig');

CREATE OR REPLACE FUNCTION zc_MIFloat_DiscountTax() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DiscountTax'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_DiscountTax', '% скидки' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_DiscountTax');

CREATE OR REPLACE FUNCTION zc_MIFloat_SummIn() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummIn'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc (Code, ItemName)
  SELECT 'zc_MIFloat_SummIn', 'Сумма вх. с учетом скидки' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_SummIn');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.21         * zc_MIFloat_OperPrice_orig
 12.04.21         * zc_MIFloat_MovementId
 06.04.21         * zc_MIFloat_BasisPrice
 05.04.21         * zc_MIFloat_OperPriceList
 28.08.20                                        * 
*/
