CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementBoolean(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementId                Integer           ,  /* ключ главного объекта     */
 inValue                     TBoolean               /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementBoolean SET Value = inValue WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementBoolean (DescId, MovementId, Value)
           VALUES (inDescId, inMovementId, inValue);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementBoolean(Integer, Integer, TBoolean)
  OWNER TO postgres;
