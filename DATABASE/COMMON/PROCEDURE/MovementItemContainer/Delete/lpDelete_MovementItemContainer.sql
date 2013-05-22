--DROP FUNCTION lpDelete_MovementItemContainer(integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainer(
IN inMovementId integer)
  RETURNS void AS
$BODY$BEGIN
   /* изменить количество остатка */
  UPDATE Container SET Amount = Container.Amount - MovementItemContainer.Amount 
  FROM MovementItemContainer
  WHERE Container.Id = MovementItemContainer.ContainerId
    AND MovementItemContainer.MovementId = inMovementId;

   /* Удалить все проводки */
   DELETE FROM MovementItemContainer WHERE MovementId = inMovementId;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_MovementItemContainer(integer)
  OWNER TO postgres; 