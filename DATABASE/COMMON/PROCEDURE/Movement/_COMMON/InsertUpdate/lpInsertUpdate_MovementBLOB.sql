-- Function: lpinsertupdate_MovementBLOB()

-- DROP FUNCTION lpinsertupdate_MovementBLOB();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementBLOB(
 inDescId                    Integer           ,  /* код класса свойства  */
 inMovementId                Integer           ,  /* ключ объекта         */
 inValueData                 TBLOB             /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE MovementBLOB SET ValueData = inValueData WHERE MovementId = inMovementId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO MovementBLOB (DescId, MovementId, ValueData)
           VALUES (inDescId, inMovementId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementBLOB(Integer, Integer, TBLOB)
  OWNER TO postgres;
