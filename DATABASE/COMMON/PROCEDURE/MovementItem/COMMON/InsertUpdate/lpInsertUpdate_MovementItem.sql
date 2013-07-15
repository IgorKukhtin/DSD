CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
INOUT ioId Integer, 
IN inDescId Integer, 
IN inObjectId Integer, 
IN inMovementId Integer,
IN inAmount TFloat,
IN inParentId Integer)
 AS
$BODY$BEGIN
  IF COALESCE(ioId, 0) = 0 THEN
     INSERT INTO MovementItem (DescId, ObjectId, MovementId, Amount, ParentId)
            VALUES (inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
  ELSE
     UPDATE MovementItem SET ObjectId = inObjectId, Amount = inAmount, ParentId = inParentId WHERE Id = ioId;
     IF NOT found THEN
        INSERT INTO MovementItem (Id, DescId, ObjectId, MovementId, Amount, ParentId)
               VALUES (ioId, inDescId, inObjectId, inMovementId, inAmount, inParentId) RETURNING Id INTO ioId;
     END IF;
  END IF;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItem(integer, integer, Integer, Integer, TFloat, Integer)
  OWNER TO postgres; 