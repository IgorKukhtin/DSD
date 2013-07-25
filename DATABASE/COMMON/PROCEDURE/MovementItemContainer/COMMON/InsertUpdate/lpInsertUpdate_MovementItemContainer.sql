-- Function: lpInsertUpdate_MovementItemContainer

-- DROP FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, TFloat, TDateTime);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItemContainer(
 INOUT ioId Integer          , --
    IN inDescId Integer      , --
    IN inMovementId Integer  , -- 
    IN inMovementItemId Integer  , -- 
    IN inContainerId Integer , --
    IN inAmount TFloat       , --
    IN inOperDate TDateTime    --
)
AS
$BODY$
BEGIN
     --  изменить значение остатка
     UPDATE Container SET Amount = Amount + COALESCE (inAmount, 0) WHERE Id = inContainerId;
     -- сохранили проводку
     INSERT INTO MovementItemContainer (DescId, MovementId, MovementItemId, ContainerId, Amount, OperDate)
                                VALUES (inDescId, inMovementId, inMovementItemId, inContainerId, COALESCE (inAmount, 0), inOperDate) RETURNING Id INTO ioId;
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementItemContainer (Integer, Integer, Integer, Integer, TFloat, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.07.13                                        * add inMovementItemId               
 11.07.13                                        * !!! finich !!!
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MovementItemContainer (ioId:=0, inDescId:= zc_MIContainer_Count(), )