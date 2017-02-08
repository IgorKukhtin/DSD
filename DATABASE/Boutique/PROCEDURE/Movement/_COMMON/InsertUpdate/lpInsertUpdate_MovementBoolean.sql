CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementBoolean(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementId                Integer           ,  /* ключ главного объекта     */
 inValueData                 Boolean              /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementBoolean SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementBoolean (DescId, MovementId, ValueData)
           VALUES (inDescId, inMovementId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementBoolean(Integer, Integer, Boolean)
  OWNER TO postgres;
