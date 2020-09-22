
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


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.20                                        *
*/
