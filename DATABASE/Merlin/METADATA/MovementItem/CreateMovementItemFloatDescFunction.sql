
CREATE OR REPLACE FUNCTION zc_MIFloat_MovementId() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_MovementId', 'MovementId' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_MovementId');

CREATE OR REPLACE FUNCTION zc_MIFloat_Amount() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Amount'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Amount', 'Сумма (приход)' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Amount');

CREATE OR REPLACE FUNCTION zc_MIFloat_Price() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Price'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Price', 'Цена за кв.м.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Price');

CREATE OR REPLACE FUNCTION zc_MIFloat_Area() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Area'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementItemFloatDesc(Code, ItemName)
  SELECT 'zc_MIFloat_Area', 'Площадь кв.м.' WHERE NOT EXISTS (SELECT * FROM MovementItemFloatDesc WHERE Code = 'zc_MIFloat_Area');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   
 01.06.22         *
 08.01.22                                        *
*/
