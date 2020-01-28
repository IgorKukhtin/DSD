-- Function: gpInsert_MovementItem_Loss_WriteRestFromPoint()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loss_WriteRestFromPoint (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loss_WriteRestFromPoint(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS Void
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_MI_Send_Remains());
    -- vbUserId:= lpGetUserBySession (inSession);

    -- определяется подразделение
    SELECT MovementLinkObject_Unit.ObjectId
    INTO vbUnitId
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.ID
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    PERFORM lpInsertUpdate_MovementItem_Loss(ioId := tempResult.Id,
                                             inMovementId := inMovementId,
                                             inGoodsId := tempResult.GoodsId,
                                             inAmount := COALESCE(tempResult.AmountRemains, 0),
                                             inUserId := vbUserId)
    FROM
            (WITH
                tmpRemains AS(  SELECT
                                    Container.ObjectId                  AS GoodsId
                                  , SUM(Container.Amount)::TFloat       AS Amount
                                FROM Container
                                    INNER JOIN ContainerLinkObject AS ContainerLinkObject_Unit
                                                                   ON Container.Id = ContainerLinkObject_Unit.ContainerId
                                                                  AND ContainerLinkObject_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                                  AND ContainerLinkObject_Unit.ObjectId = vbUnitId

                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                                GROUP BY Container.ObjectId
                                HAVING SUM(Container.Amount) > 0
                             )
               ,MovementItem_Loss AS (SELECT MovementItem_Loss.Id
                                           , MovementItem_Loss.ObjectId
                                           , MovementItem_Loss.Amount

                                        FROM MovementItem AS MovementItem_Loss

                                        WHERE MovementItem_Loss.MovementId = inMovementId
                                          AND MovementItem_Loss.DescId = zc_MI_Master()
                                     )


            SELECT
                COALESCE(MovementItem_Loss.Id,0)                            AS Id
              , COALESCE(MovementItem_Loss.ObjectId,tmpRemains.GoodsId)     AS GoodsId
              , tmpRemains.Amount::TFloat                                   AS AmountRemains

            FROM tmpRemains
                FULL OUTER JOIN MovementItem_Loss ON tmpRemains.GoodsId = MovementItem_Loss.ObjectId) AS tempResult;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsert_MovementItem_Loss_WriteRestFromPoint (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 27.01.20         *

*/

-- тест
-- select * from gpInsert_MovementItem_Loss_WriteRestFromPoint(inMovementId := 17515906 ,  inSession := '3');