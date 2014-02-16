CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementDate(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementId                Integer           ,  /* ключ главного объекта     */
 inValueData                 TDateTime            /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementDate SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementDate (DescId, MovementId, ValueData)
           VALUES (inDescId, inMovementId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementDate(Integer, Integer, TDateTime)
  OWNER TO postgres;
