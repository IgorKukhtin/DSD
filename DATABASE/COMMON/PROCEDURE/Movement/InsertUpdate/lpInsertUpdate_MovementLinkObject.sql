CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementLinkObject(
 inDescId                    Integer           ,  /* код класса свойства       */
 inParentMovementId          Integer           ,  /* ключ главного объекта     */
 inChildObjectId             Integer              /* ключ подчиненного объекта */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementLinkObject SET ChildObjectId = inChildObjectId WHERE ParentMovementId = inParentMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementLinkObject (DescId, ParentMovementId, ChildObjectId)
           VALUES (inDescId, inParentMovementId, inChildObjectId);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementLinkObject(Integer, Integer, Integer)
  OWNER TO postgres;
