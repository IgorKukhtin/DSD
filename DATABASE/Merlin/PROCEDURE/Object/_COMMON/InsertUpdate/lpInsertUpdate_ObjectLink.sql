-- Function: lpInsertUpdate_ObjectLink

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectLink (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectLink(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inObjectId              Integer           , -- ключ главного объекта
    IN inChildObjectId         Integer             -- ключ подчиненного объекта
)
RETURNS Boolean

AS
$BODY$
BEGIN
    -- заменили
    IF inChildObjectId = 0
    THEN
        inChildObjectId := NULL;
    END IF;


    -- изменить <свойство>
    UPDATE ObjectLink SET ChildObjectId = inChildObjectId WHERE ObjectId = inObjectId AND DescId = inDescId;

    -- если не нашли + попробуем NULL НЕ вставлять
    IF NOT FOUND AND inChildObjectId IS NOT NULL
    THEN
        -- вставить <свойство>
        INSERT INTO ObjectLink (DescId, ObjectId, ChildObjectId)
                        VALUES (inDescId, inObjectId, inChildObjectId);
    END IF;             

    RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectLink (Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * IF ... AND inChildObjectId IS NOT NULL
*/
