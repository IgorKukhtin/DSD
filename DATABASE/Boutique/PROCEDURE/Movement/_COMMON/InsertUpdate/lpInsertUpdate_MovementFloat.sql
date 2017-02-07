-- Function: lpInsertUpdate_MovementItemFloat

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inMovementId            Integer           , -- ключ 
    IN inValueData             TFloat             -- свойство
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE MovementFloat SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;

     -- если не нашли
     IF NOT FOUND AND inValueData <> 0
     THEN
        -- вставить <свойство>
        INSERT INTO MovementFloat (DescId, MovementId, ValueData)
                           VALUES (inDescId, inMovementId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inValueData <> 0
*/
