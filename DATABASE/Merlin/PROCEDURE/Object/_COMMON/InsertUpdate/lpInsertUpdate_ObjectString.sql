-- Function: lpInsertUpdate_MovementString

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectString (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectString(
    IN inDescId                Integer           , -- ключ класса свойства
    IN inObjectId              Integer           , -- ключ 
    IN inValueData             TVarChar            -- Значение
)
RETURNS Boolean
AS
$BODY$
BEGIN

     -- изменить <свойство>
     UPDATE ObjectString SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    
     -- если не нашли + попробуем ПУСТО НЕ вставлять
     IF NOT FOUND AND inValueData <> ''
     THEN
        -- вставить <свойство>
        INSERT INTO ObjectString (DescId, ObjectId, ValueData)
                          VALUES (inDescId, inObjectId, inValueData);
     END IF;

     RETURN (TRUE);
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectString (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.17                                        * IF ... AND inValueData <> ''
*/
