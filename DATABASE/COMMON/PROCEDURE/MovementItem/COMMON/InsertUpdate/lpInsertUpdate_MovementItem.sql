CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem(
INOUT ioId Integer, 
IN inDescId Integer, 
IN inObjectId Integer, 
IN inMovementId Integer,
IN inAmount TFloat,
IN inParentId Integer)
 AS
$BODY$BEGIN

     -- меняем параметр
     IF inParentId = 0 THEN
        inParentId := NULL;
     END IF;

     -- меняем параметр
     IF inObjectId = 0 THEN
        inObjectId := NULL;
     END IF;

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
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpInsertUpdate_MovementItem(integer, integer, Integer, Integer, TFloat, Integer)
  OWNER TO postgres; 


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.13                                        * add inObjectId := NULL
 23.07.13                                        * add inParentId := NULL

*/

-- тест
