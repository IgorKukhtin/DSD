CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemLinkObject(
 inDescId                Integer           ,  /* код класса свойства       */
 inMovementItemId        Integer           ,  /* ключ главного объекта     */
 inObjectId              Integer              /* ключ подчиненного объекта */
)
  RETURNS boolean AS
$BODY$BEGIN
    IF inObjectId = 0 THEN
       inObjectId := NULL;
    END IF;

    /* изменить данные по значению <ключ объекта> */
    UPDATE MovementItemLinkObject SET ObjectId = inObjectId WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementItemLinkObject (DescId, MovementItemId, ObjectId)
           VALUES (inDescId, inMovementItemId, inObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemLinkObject(Integer, Integer, Integer)
  OWNER TO postgres;
