CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemString(
 inDescId                    Integer           ,  /* код класса свойства       */
 inMovementItemId            Integer           ,  /* ключ главного объекта     */
 inValueData                 TVarChar             /* Значение */
)
  RETURNS boolean AS
$BODY$BEGIN

    UPDATE MovementItemString SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ главного объекта> и <ключ подчиненного объекта> */
       INSERT INTO MovementItemString (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemString(Integer, Integer, TVarChar)
  OWNER TO postgres;
