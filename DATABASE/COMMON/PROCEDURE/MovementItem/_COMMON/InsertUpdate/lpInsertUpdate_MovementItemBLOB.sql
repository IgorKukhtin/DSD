-- Function: lpinsertupdate_MovementItemBLOB()

-- DROP FUNCTION lpinsertupdate_MovementItemBLOB();

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemBLOB(
 inDescId                    Integer           ,  /* код класса свойства  */
 inMovementItemId            Integer           ,  /* ключ объекта         */
 inValueData                 TBLOB             /* данные свойства      */
)
  RETURNS boolean AS
$BODY$BEGIN

    /* изменить данные по значению <ключ свойства> и <ключ объекта> */
    UPDATE MovementItemBLOB SET ValueData = inValueData WHERE MovementItemId = inMovementItemId AND DescId = inDescId;
    IF NOT found THEN            
       /* вставить <ключ свойства> , <ключ объекта> и <данные> */
       INSERT INTO MovementItemBLOB (DescId, MovementItemId, ValueData)
           VALUES (inDescId, inMovementItemId, inValueData);
    END IF;             
    RETURN true;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemBLOB(Integer, Integer, TBLOB)
  OWNER TO postgres;
