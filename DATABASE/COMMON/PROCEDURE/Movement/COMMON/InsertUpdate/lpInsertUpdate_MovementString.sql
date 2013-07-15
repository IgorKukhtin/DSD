CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementString(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementId                Integer           ,  /* ключ главного объекта     */
 inValueData                 TVarChar             /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementString SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementString (DescId, MovementId, ValueData)
           VALUES (inDescId, inMovementId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementString(Integer, Integer, TVarChar)
  OWNER TO postgres;
