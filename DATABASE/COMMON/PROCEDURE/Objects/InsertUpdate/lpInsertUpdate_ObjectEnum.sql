-- Function: lpInsertUpdate_ObjectEnum()

-- DROP FUNCTION lpInsertUpdate_ObjectEnum();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectEnum(
 inDescId                    Integer           ,  /* код класса свойства  */
 inObjectId                  Integer           ,  /* ключ объекта         */
 inEnumId                    Integer              /* ключ Enum            */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectEnum SET EnumId = inEnumId WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO ObjectEnum (DescId, ObjectId, EnumId)
           VALUES (inDescId, inObjectId, inEnumId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectEnum(Integer, Integer, Integer)
  OWNER TO postgres;
