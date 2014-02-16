CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemFloat(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementItemId            Integer           ,  /* ключ главного объекта     */
 inValueData                 TFloat               /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementItemFloat SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementItemFloat (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemFloat(Integer, Integer, TFloat)
  OWNER TO postgres;
