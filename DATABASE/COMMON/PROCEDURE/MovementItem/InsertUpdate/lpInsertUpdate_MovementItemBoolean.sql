CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemBoolean(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementItemId            Integer           ,  /* ключ главного объекта     */
 inValueData                 Boolean              /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementItemBoolean SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementItemBoolean (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemBoolean(Integer, Integer, Boolean)
  OWNER TO postgres;
