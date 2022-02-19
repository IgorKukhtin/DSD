-- Function: gpUpdate_MI_Inventory_AmountRemains()

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_AmountRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_AmountRemains(
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());


     -- определяются параметры из шапки документа
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
            INTO vbStatusId, vbInvNumber, vbOperDate, vbFromId, vbToId
     FROM Movement
          -- Подразделение (магазин)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          -- Подразделение (склад)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- вставить рассчет остатка на начало дня
     CREATE TEMP TABLE _tmpContainer (MovementItemId Integer, PartionId Integer, Remains TFloat, RemainsDebt TFloat, SecondRemains TFloat) ON COMMIT DROP;
     --
     INSERT INTO _tmpContainer (MovementItemId, PartionId, Remains, RemainsDebt, SecondRemains)
        WITH tmpMI AS (SELECT MovementItem.Id        AS MovementItemId
                            , MovementItem.PartionId AS PartionId
                            , MovementItem.ObjectId  AS GoodsId
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                      )
       , tmpRemains AS (SELECT Container.PartionId AS PartionId
                             , Container.ObjectId  AS GoodsId
                             , CASE WHEN Container.WhereObjectId  = vbFromId AND CLO_Client.ContainerId IS NULL THEN  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) ELSE 0 END AS Remains
                             , CASE WHEN Container.WhereObjectId  = vbFromId AND CLO_Client.ContainerId > 0     THEN  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) ELSE 0 END AS RemainsDebt
                             , CASE WHEN Container.WhereObjectId  = vbToId   AND CLO_Client.ContainerId IS NULL THEN  Container.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) ELSE 0 END AS SecondRemains
                        FROM Container
                             LEFT JOIN ContainerLinkObject AS CLO_Client
                                                           ON CLO_Client.ContainerId = Container.Id
                                                          AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                             LEFT JOIN MovementItemContainer AS MIContainer
                                                             ON MIContainer.ContainerId = Container.Id
                                                            AND MIContainer.OperDate >= vbOperDate
                        WHERE Container.DescId        = zc_Container_Count()
                          AND Container.WhereObjectId IN (vbFromId, vbToId)
                        GROUP BY Container.Id
                               , Container.PartionId
                               , Container.WhereObjectId
                               , Container.Amount
                               , Container.ObjectId
                               , CLO_Client.ContainerId
                        HAVING Container.Amount <> 0
                            OR COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                       )
             -- Результат
             SELECT COALESCE (tmpMI.MovementItemId, 0)           AS MovementItemId
                  , COALESCE (tmpRem.PartionId, tmpMI.PartionId) AS PartionId
                  , COALESCE (tmpRem.Remains, 0)                 AS Remains
                  , COALESCE (tmpRem.RemainsDebt, 0)             AS RemainsDebt
                  , COALESCE (tmpRem.SecondRemains, 0)           AS SecondRemains
             FROM (SELECT tmpRemains.PartionId
                        , tmpRemains.GoodsId
                        , SUM (tmpRemains.Remains)       AS Remains
                        , SUM (tmpRemains.RemainsDebt)   AS RemainsDebt
                        , SUM (tmpRemains.SecondRemains) AS SecondRemains
                   FROM tmpRemains
                   GROUP BY tmpRemains.PartionId
                          , tmpRemains.GoodsId
                   HAVING SUM (tmpRemains.Remains)       <> 0
                       OR SUM (tmpRemains.RemainsDebt)   <> 0
                       OR SUM (tmpRemains.SecondRemains) <> 0
                  ) AS tmpRem
                  FULL JOIN tmpMI ON tmpMI.PartionId = tmpRem.PartionId
                                 AND tmpMI.GoodsId   = tmpRem.GoodsId
             ;

     -- сохранили
     UPDATE _tmpContainer SET MovementItemId = lpInsertUpdate_MovementItem (0, zc_MI_Master()
                                                                          , (SELECT Object_PartionGoods.GoodsId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = _tmpContainer.PartionId)
                                                                          , _tmpContainer.PartionId
                                                                          , inMovementId
                                                                          , 0
                                                                          , NULL
                                                                           )
     WHERE _tmpContainer.MovementItemId = 0;


     -- сохранили
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountRemains(),       _tmpContainer.MovementItemId, _tmpContainer.Remains)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountClient(),        _tmpContainer.MovementItemId, _tmpContainer.RemainsDebt)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSecondRemains(), _tmpContainer.MovementItemId, _tmpContainer.SecondRemains)

           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(),     _tmpContainer.MovementItemId, Object_PartionGoods.OperPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountForPrice(), _tmpContainer.MovementItemId, Object_PartionGoods.CountForPrice)
           , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), _tmpContainer.MovementItemId, Object_PartionGoods.OperPriceList)
     FROM _tmpContainer
          LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpContainer.PartionId
         ;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (_tmpContainer.MovementItemId, vbUserId, FALSE)
     FROM _tmpContainer;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.02.22         *

*/

-- SELECT * FROM gpUpdate_MI_Inventory_AmountRemains (inMovementId:= 11, inSession:= zfCalc_UserAdmin())
