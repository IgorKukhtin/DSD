-- Function: lpinsertupdate_objectstring()

-- DROP FUNCTION lpinsertupdate_objectstring();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectString(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectId                  Integer           ,  /* ключ объекта         */
 inValueData                 TVarChar             /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectString SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectString (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectString(Integer, Integer, TVarChar)
  OWNER TO postgres;
