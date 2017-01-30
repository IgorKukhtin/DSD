-- Function: lpinsertupdate_objectBoolean()

-- DROP FUNCTION lpinsertupdate_objectBoolean();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectBoolean(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectId                  Integer           ,  /* ключ объекта         */
 inValueData                 Boolean              /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectBoolean SET ValueData = inValueData WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectBoolean (DescId, ObjectId, ValueData)
           VALUES (inDescId, inObjectId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectBoolean(Integer, Integer, Boolean)
  OWNER TO postgres;
