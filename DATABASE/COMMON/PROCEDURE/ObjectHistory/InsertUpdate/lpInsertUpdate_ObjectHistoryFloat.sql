-- Function: lpInsertUpdate_ObjectHistoryFloat()

-- DROP FUNCTION lpInsertUpdate_ObjectHistoryFloat();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistoryFloat(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectHistoryId           Integer           ,  /* ключ объекта         */
 inValueData                 TFloat               /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectHistoryFloat SET ValueData = inValueData WHERE ObjectHistoryId = inObjectHistoryId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectHistoryFloat (DescId, ObjectHistoryId, ValueData)
           VALUES (inDescId, inObjectHistoryId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectHistoryFloat(Integer, Integer, TFloat)
  OWNER TO postgres;
