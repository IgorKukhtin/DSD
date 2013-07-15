--DROP FUNCTION lpDelete_MovementItemContainer(integer);

CREATE OR REPLACE FUNCTION lpDelete_MovementItemContainer(
IN inMovementId integer)
  RETURNS void AS
$BODY$BEGIN
   /* изменить количество остатка */
  UPDATE Container SET amount = Container.Amount - Oper.Amount
  FROM (SELECT SUM(MovementItemContainer.Amount) AS Amount,
               MovementItemContainer.ContainerId
        FROM MovementItemContainer
        WHERE MovementItemContainer.MovementId = inMovementId
     GROUP BY MovementItemContainer.ContainerId) AS Oper
   WHERE Oper.ContainerId = Container.id;

   /* Удалить все проводки */
   DELETE FROM MovementItemContainer WHERE MovementId = inMovementId;
END;           $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION lpDelete_MovementItemContainer(integer)
  OWNER TO postgres; 