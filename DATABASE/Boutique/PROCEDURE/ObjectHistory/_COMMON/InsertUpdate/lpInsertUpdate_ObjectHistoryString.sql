-- Function: lpInsertUpdate_ObjectHistoryString()

DROP FUNCTION IF EXISTS lpInsertUpdate_ObjectHistoryString(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistoryString(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectHistoryId           Integer           ,  /* ключ объекта         */
 inValueData                 TVarChar             /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectHistoryString SET ValueData = inValueData WHERE ObjectHistoryId = inObjectHistoryId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectHistoryString (DescId, ObjectHistoryId, ValueData)
           VALUES (inDescId, inObjectHistoryId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectHistoryString(Integer, Integer, TVarChar)
  OWNER TO postgres;
