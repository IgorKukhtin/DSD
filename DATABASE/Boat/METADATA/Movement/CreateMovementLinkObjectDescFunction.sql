
CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Insert() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Insert', 'Пользователь созд.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Insert');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Update() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Update', 'Пользователь корр.' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Update');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_From() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_From'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_From', 'От кого (в документе)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_From');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_To() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_To'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_To', 'Кому (в документе)' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_To');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Object() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Object'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Object', 'Client/Partner' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Object');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Unit() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Unit'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Unit', 'Unit' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Unit');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_InfoMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_InfoMoney', 'InfoMoney' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_InfoMoney');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_Product() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Product'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_Product', 'Product' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_Product');

CREATE OR REPLACE FUNCTION zc_MovementLinkObject_PaidKind() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKind'); END; $BODY$ LANGUAGE PLPGSQL IMMUTABLE;
INSERT INTO MovementLinkObjectDesc (Code, ItemName)
  SELECT 'zc_MovementLinkObject_PaidKind', 'PaidKind' WHERE NOT EXISTS (SELECT * FROM MovementLinkObjectDesc WHERE Code = 'zc_MovementLinkObject_PaidKind');



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.02.21         * zc_MovementLinkObject_PaidKind
                    zc_MovementLinkObject_Product
                    zc_MovementLinkObject_InfoMoney
                    zc_MovementLinkObject_Unit
                    zc_MovementLinkObject_Object
 24.08.20                                        *
*/
