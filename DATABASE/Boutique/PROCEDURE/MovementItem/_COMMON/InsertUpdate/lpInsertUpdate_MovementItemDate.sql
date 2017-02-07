CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemDate(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementItemId            Integer           ,  /* ключ главного объекта     */
 inValueData                 TDateTime            /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementItemDate SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementItemDate (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemDate(Integer, Integer, TDateTime)
  OWNER TO postgres;

