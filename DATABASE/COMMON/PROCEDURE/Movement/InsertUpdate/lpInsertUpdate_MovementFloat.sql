CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementId                Integer           ,  /* ключ главного объекта     */
 inValue                     TFloat               /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementFloat SET Value = inValue WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementFloat (DescId, MovementId, Value)
           VALUES (inDescId, inMovementId, inValue);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementFloat(Integer, Integer, TFloat)
  OWNER TO postgres;
