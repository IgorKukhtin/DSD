CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkObject(
 inDescId                Integer           ,  /* код класса свойства       */
 inMovementId            Integer           ,  /* ключ главного объекта     */
 inObjectId              Integer              /* ключ подчиненного объекта */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inObjectId = 0 THEN
       inObjectId := NULL;
    END IF;

    /* изменить данные по значению <ключ объекта> */
    UPDATE MovementLinkObject SET ObjectId = inObjectId WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementLinkObject (DescId, MovementId, ObjectId)
           VALUES (inDescId, inMovementId, inObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementLinkObject(Integer, Integer, Integer)
  OWNER TO postgres;
