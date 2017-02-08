-- Function: lpinsertupdate_objectDate()

-- DROP FUNCTION lpinsertupdate_objectDate();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectDate(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectId                  Integer           ,  /* ключ объекта         */
 inValueData                 TDateTime            /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectDate SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectDate (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_ObjectDate(Integer, Integer, TDateTime)  OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.13          * 

*/