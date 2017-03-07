-- Function: lpInsertUpdate_ObjectHistoryDate()

-- DROP FUNCTION lpInsertUpdate_ObjectHistoryDate();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectHistoryDate(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectHistoryId           Integer           ,  /* ключ объекта         */
 inValueData                 TDateTime            /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectHistoryDate SET ValueData = inValueData WHERE ObjectHistoryId = inObjectHistoryId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectHistoryDate (DescId, ObjectHistoryId, ValueData)
           VALUES (inDescId, inObjectHistoryId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$ 
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.03.17         *
*/