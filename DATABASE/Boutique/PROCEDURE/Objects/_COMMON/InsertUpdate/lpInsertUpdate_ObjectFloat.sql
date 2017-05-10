-- Function: lpinsertupdate_objectFloat()

DROP FUNCTION IF EXISTS lpinsertupdate_objectFloat (Integer, Integer, TFloat);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectFloat(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inObjectId              Integer           , -- ключ 
    IN inValueData             TFloat              -- Значение
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
    UPDATE ObjectFloat SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;

     -- если не нашли + попробуем 0 НЕ вставлять
     IF NOT FOUND AND inValueData <> 0
     THEN
        -- вставить <свойство>
        INSERT INTO ObjectFloat (DescId, ObjectId, ValueData)
                         VALUES (inDescId, inObjectId, inValueData);
     END IF;

     RETURN (TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectFloat (Integer, Integer, TFloat) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.17                                        * IF ... AND inValueData <> 0
*/
