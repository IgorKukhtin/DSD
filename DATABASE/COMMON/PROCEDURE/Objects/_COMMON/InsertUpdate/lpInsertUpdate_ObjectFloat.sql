-- Function: lpinsertupdate_objectFloat()

-- DROP FUNCTION lpinsertupdate_objectFloat();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectFloat(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectId                  Integer           ,  /* ключ объекта         */
 inValueData                 TFloat               /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectFloat SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectFloat (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectFloat(Integer, Integer, TFloat)
  OWNER TO postgres;
