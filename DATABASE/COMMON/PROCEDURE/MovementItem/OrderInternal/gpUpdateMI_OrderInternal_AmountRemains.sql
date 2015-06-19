-- Function: gpUpdateMI_OrderInternal_AmountRemains()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemains (Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_AmountRemains (Integer, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_AmountRemains(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inFromId              Integer   , -- 
    IN inToId                Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderInternal());


    -- таблица
    CREATE TEMP TABLE tmpContainer_Count (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpContainer (MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat) ON COMMIT DROP;
    CREATE TEMP TABLE tmpAll (MovementItemId Integer, MIDescId Integer, ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount_start TFloat, Amount TFloat) ON COMMIT DROP;
    
    --
    --
    INSERT INTO tmpContainer_Count (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount)
                                WITH tmpUnit AS (SELECT UnitId, zc_MI_Master() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inFromId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inFromId
                                                UNION
                                                 SELECT UnitId, zc_MI_Child() AS MIDescId FROM lfSelect_Object_Unit_byGroup (inToId) AS lfSelect_Object_Unit_byGroup WHERE UnitId <> inToId)
                                   , tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                                                  FROM Object_InfoMoney_View
                                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                            ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                  WHERE Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_30000() -- Доходы
                                                 )
                                SELECT tmpUnit.MIDescId
                                     , Container.Id                         AS ContainerId
                                     , Container.ObjectId                   AS GoodsId
                                     , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                     , Container.Amount
                                FROM tmpGoods
                                     INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                                         AND Container.DescId = zc_Container_Count()
                                     INNER JOIN ContainerLinkObject AS CLO_Unit 
                                                                    ON CLO_Unit.ContainerId = Container.Id
                                                                   AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = CLO_Unit.ObjectId

                                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind 
                                                                   ON CLO_GoodsKind.ContainerId = Container.Id
                                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind();

       --
       --
       INSERT INTO tmpContainer (MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start)
                                  SELECT 
                                           tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_start
                                  FROM tmpContainer_Count
                                       LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                                     AND MIContainer.OperDate >= inOperDate
                                  GROUP BY tmpContainer_Count.MIDescId
                                         , tmpContainer_Count.ContainerId
                                         , tmpContainer_Count.GoodsId
                                         , tmpContainer_Count.GoodsKindId
                                         , tmpContainer_Count.Amount
                                  HAVING  (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                  ;      
          --
          --
          INSERT INTO tmpAll (MovementItemId, MIDescId, ContainerId, GoodsId, GoodsKindId, Amount_start, Amount)
                      WITH tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                                          , MovementItem.DescId                           AS MIDescId
                                          , MovementItem.ObjectId                         AS GoodsId
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , MovementItem.Amount                           AS Amount
                                          , MIFloat_ContainerId.ValueData :: Integer      AS ContainerId
                                     FROM MovementItem 
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                          LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                      ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                                     AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                     WHERE MovementItem.MovementId = inMovementId
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                                    )
                      SELECT tmpMI.MovementItemId
                           , COALESCE (tmpContainer.MIDescId,     tmpMI.MIDescId)    AS MIDescId
                           , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                      FROM tmpContainer
                           FULL JOIN tmpMI ON tmpMI.GoodsId     = tmpContainer.GoodsId
                                          AND tmpMI.GoodsKindId = tmpContainer.GoodsKindId
                                          AND tmpMI.MIDescId    = tmpContainer.MIDescId
                      WHERE tmpContainer.MIDescId = zc_MI_Master()
                     UNION ALL
                      SELECT tmpMI.MovementItemId
                           , COALESCE (tmpContainer.MIDescId,     tmpMI.MIDescId)    AS MIDescId
                           , COALESCE (tmpContainer.ContainerId,  tmpMI.ContainerId) AS ContainerId
                           , COALESCE (tmpContainer.GoodsId,      tmpMI.GoodsId)     AS GoodsId
                           , COALESCE (tmpContainer.GoodsKindId,  tmpMI.GoodsKindId) AS GoodsKindId
                           , COALESCE (tmpContainer.Amount_start, 0)                 AS Amount_start
                      FROM tmpContainer
                           FULL JOIN tmpMI ON tmpMI.ContainerId = tmpContainer.ContainerId
                                          AND tmpMI.MIDescId    = tmpContainer.MIDescId
                      WHERE tmpContainer.MIDescId = zc_MI_Child()
                     ;

       -- сохранили
       PERFORM lpUpdate_MI_OrderInternal_Property (inId                 := tmpAll.MovementItemId
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := tmpAll.GoodsId
                                                 , inGoodsKindId        := tmpAll.GoodsKindId
                                                 , inAmount_Param       := tmpAll.Amount_start
                                                 , inDescId_Param       := zc_MIFloat_AmountRemains()
                                                 , inAmount_ParamOrder  := tmpAll.ContainerId
                                                 , inDescId_ParamOrder  := zc_MIFloat_ContainerId()
                                                 , inUserId             := vbUserId
                                                  ) 
       FROM tmpAll
       WHERE tmpAll.MIDescId = zc_MI_Master();

       -- сохранили
       PERFORM lpInsertUpdate_MI_OrderInternal_Child (inId                 := tmpAll.MovementItemId
                                                    , inMovementId         := inMovementId
                                                    , inGoodsId            := tmpAll.GoodsId
                                                    , inAmount             := tmpAll.Amount_start
                                                    , inContainerId        := tmpAll.ContainerId
                                                    , inUserId             := vbUserId
                                                     ) 
       FROM tmpAll
       WHERE tmpAll.MIDescId = zc_MI_Master();


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.06.15                                        *
 13.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_AmountRemains (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
