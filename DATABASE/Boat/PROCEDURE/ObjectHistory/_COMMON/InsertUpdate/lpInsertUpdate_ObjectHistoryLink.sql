-- Function: lpInsertUpdate_ObjectHistoryLink()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistoryLink(Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistoryLink(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectHistoryId           Integer           ,  /* ключ объекта         */
 inObjectId                  Integer             /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inObjectId = 0 THEN
       inObjectId := NULL;
    END IF;

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectHistoryLink SET ObjectId = inObjectId WHERE ObjectHistoryId = inObjectHistoryId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectHistoryLink (DescId, ObjectHistoryId, ObjectId)
           VALUES (inDescId, inObjectHistoryId, inObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectHistoryLink(Integer, Integer, Integer)
  OWNER TO postgres;
