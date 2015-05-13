-- Function: lpInsertUpdate_MovementItemLinkObject

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementLinkObject (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkObject(
    IN inDescId                Integer           , -- код класса свойства
    IN inMovementId            Integer           , -- ключ 
    IN inObjectId              Integer             -- ключ объекта
)
RETURNS Boolean
AS
$BODY$
BEGIN
    -- меняется значение
    IF inObjectId = 0
    THEN
        inObjectId := NULL;
    END IF;

    -- изменить <свойство>
    UPDATE MovementLinkObject SET ObjectId = inObjectId WHERE MovementId = inMovementId AND DescId = inDescId;

    -- если не нашли
    IF NOT FOUND AND inObjectId IS NOT NULL
    THEN
        -- вставить <свойство>
        INSERT INTO MovementLinkObject (DescId, MovementId, ObjectId)
                                VALUES (inDescId, inMovementId, inObjectId);
    END IF;
  
    RETURN TRUE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementLinkObject (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inObjectId IS NOT NULL
*/

-- тест
