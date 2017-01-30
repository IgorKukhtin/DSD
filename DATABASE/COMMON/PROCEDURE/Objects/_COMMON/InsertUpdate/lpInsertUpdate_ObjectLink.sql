-- Function: lpInsertUpdate_ObjectLink()

-- DROP FUNCTION lpInsertUpdate_ObjectLink();

CREATE OR REPLACE FUNCTION lpInsertUpdate_ObjectLink(
 inDescId                    Integer           ,  /* код класса свойства       */
 inObjectId                  Integer           ,  /* ключ главного объекта     */
 inChildObjectId             Integer              /* ключ подчиненного объекта */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inChildObjectId = 0 THEN
       inChildObjectId := NULL;
    END IF;

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE ObjectLink SET ChildObjectId = inChildObjectId WHERE ObjectId = inObjectId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO ObjectLink (DescId, ObjectId, ChildObjectId)
           VALUES (inDescId, inObjectId, inChildObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_ObjectLink(Integer, Integer, Integer)
  OWNER TO postgres;
