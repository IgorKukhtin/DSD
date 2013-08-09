-- Function: lpInsertUpdate_MovementItemContainer

-- DROP FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId Integer          , --
    IN inDescId Integer      , --
    IN inMovementId Integer  , -- 
    IN inMovementItemId Integer  , -- 
    IN inParentId Integer , --
    IN inContainerId Integer , --
    IN inAmount TFloat       , --
    IN inOperDate TDateTime  , --
    IN inIsActive Boolean  --
)
AS
$BODY$
BEGIN
     -- меняем параметр
     IF inParentId = 0 THEN inParentId:= NULL; END IF;
     -- меняем параметр
     inAmount:= COALESCE (inAmount, 0);

     -- изменить значение остатка
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;
     -- сохранили проводку
     INSERT INTO MovementItemContainer (DescId, MovementId, MovementItemId, ContainerId, ParentId, Amount, OperDate, IsActive)
                                VALUES (inDescId, inMovementId, inMovementItemId, inContainerId, inParentId, inAmount, inOperDate, inIsActive) RETURNING Id INTO ioId;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TDateTime, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.08.13                                        * add inParentId and inIsActive
 25.07.13                                        * add inMovementItemId
 11.07.13                                        * !!! finich !!!
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer (ioId:=0, inDescId:= zc_MIContainer_Count(), )