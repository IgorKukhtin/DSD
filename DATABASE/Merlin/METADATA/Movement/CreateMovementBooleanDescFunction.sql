
CREATE OR REPLACE FUNCTION zc_MovementBoolean_Sign() RETURNS integer AS $BODY$BEGIN RETURN (SELECT Id FROM MovementBooleanDesc WHERE Code = 'zc_MovementBoolean_Sign'); END;  $BODY$ LANGUAGE plpgsql IMMUTABLE;
INSERT INTO MovementBooleanDesc (Code, ItemName)
  SELECT 'zc_MovementBoolean_Sign', 'Корректировка подтверждена'  WHERE NOT EXISTS (SELECT * FROM MovementBooleanDesc WHERE Code= 'zc_MovementBoolean_Sign');

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         * zc_MovementBoolean_Sign
*/