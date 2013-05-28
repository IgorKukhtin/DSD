--DROP FUNCTION lpInsertUpdate_MovementItemContainer(Integer, Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
INOUT ioId integer, 
IN inDescId integer, 
IN inMovementId integer, 
IN inContainerId integer,
IN inAmount TFloat,
IN inOperDate TDateTime)
 AS
$BODY$BEGIN
    /* изменить <код объекта> и <данные> по значению <ключа> */
   UPDATE Container SET Amount = Amount + inAmount WHERE Id = inContainerId;
   /* вставить <ключ класса объекта> , <код объекта> , <данные> со значением <ключа> */
   INSERT INTO MovementItemContainer (DescId, MovementId, ContainerId, Amount, OperDate)
               VALUES (inDescId, inMovementId, inContainerId, inAmount, inOperDate) RETURNING Id INTO ioId;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer(integer, integer, integer, integer, TFloat, TDateTime)
  OWNER TO postgres; 