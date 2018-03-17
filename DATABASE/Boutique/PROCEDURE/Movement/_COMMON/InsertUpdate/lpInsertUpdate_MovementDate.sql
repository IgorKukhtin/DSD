-- Function: lpInsertUpdate_MovementDate()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementDate(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementId            Integer           , -- ключ 
    IN inValueData             TDateTime           -- Значение
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE MovementDate SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;

     -- если не нашли
     IF NOT FOUND
     THEN
        -- вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта>
        INSERT INTO MovementDate (DescId, MovementId, ValueData)
                          VALUES (inDescId, inMovementId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementDate (Integer, Integer, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.03.18                                        *
 */

-- тест
-- SELECT * FROM lpInsertUpdate_MovementDate ();
