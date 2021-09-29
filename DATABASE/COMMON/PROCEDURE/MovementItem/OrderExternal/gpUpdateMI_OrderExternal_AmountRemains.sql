-- Function: gpUpdateMI_OrderExternal_AmountRemains()

DROP FUNCTION IF EXISTS gptUpdateMI_OrderExternal_AmountRemains (Integer, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderExternal_AmountRemains (Integer, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderExternal_AmountRemains(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderExternalUnit());


     --
     vbPriceListId:= (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PriceList());

     -- таблица
     CREATE TEMP TABLE tmpContainer_Count (ContainerId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE tmpContainer (GoodsId Integer, GoodsKindId Integer, Amount_end TFloat) ON COMMIT DROP;
     CREATE TEMP TABLE tmpAll (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount_end TFloat, Amount TFloat) ON COMMIT DROP;

     --
     INSERT INTO tmpContainer_Count (ContainerId, GoodsId, GoodsKindId, Amount)
        WITH tmpGoods AS (SELECT Id AS GoodsId FROM Object WHERE DescId = zc_Object_Goods())
        SELECT Container.Id AS ContainerId
             , Container.ObjectId AS GoodsId
             , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
             , Container.Amount
        FROM tmpGoods
             INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                 AND Container.DescId = zc_Container_Count()
             INNER JOIN ContainerLinkObject AS CLO_Unit
                                            ON CLO_Unit.ContainerId = Container.Id
                                           AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                           AND CLO_Unit.ObjectId = inUnitId
             LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                           ON CLO_GoodsKind.ContainerId = Container.Id
                                          AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
      --     LEFT JOIN ContainerLinkObject AS CLO_Account
      --                                   ON CLO_Account.ContainerId = CLO_Unit.ContainerId
      --                                  AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
      --WHERE CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
       ;

     --
     INSERT INTO tmpContainer (GoodsId, GoodsKindId, Amount_end)
        SELECT tmpContainer_Count.GoodsId
             , tmpContainer_Count.GoodsKindId
             , SUM (tmpContainer_Count.Amount_end) AS Amount_end
        FROM (SELECT tmpContainer_Count.GoodsId
                   , tmpContainer_Count.GoodsKindId
                   , tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Amount_end
              FROM tmpContainer_Count
                   LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = tmpContainer_Count.ContainerId
                                                                 AND MIContainer.OperDate >= (inOperDate + INTERVAL '1 DAY')
              GROUP BY tmpContainer_Count.ContainerId
                     , tmpContainer_Count.GoodsId
                     , tmpContainer_Count.GoodsKindId
                     , tmpContainer_Count.Amount
              HAVING (tmpContainer_Count.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
             ) AS tmpContainer_Count
        GROUP BY tmpContainer_Count.GoodsId
               , tmpContainer_Count.GoodsKindId
        HAVING SUM (tmpContainer_Count.Amount_end) <> 0
       ;

     --
     INSERT INTO tmpAll (MovementItemId, GoodsId, GoodsKindId, Amount_end, Amount)
                 SELECT tmp.MovementItemId
                      , COALESCE (tmp.GoodsId, tmpContainer.GoodsId)         AS GoodsId
                      , COALESCE (tmp.GoodsKindId, tmpContainer.GoodsKindId) AS GoodsKindId
                      , COALESCE (tmpContainer.Amount_end, 0)              AS Amount_end
                      , COALESCE (tmp.Amount, 0)                             AS Amount
                 FROM tmpContainer
                      FULL JOIN
                           (SELECT MovementItem.Id                               AS MovementItemId
                                 , MovementItem.ObjectId                         AS GoodsId
                                 , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , MovementItem.Amount
                            FROM MovementItem
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           ) AS tmp  ON tmp.GoodsId = tmpContainer.GoodsId
                                    AND tmp.GoodsKindId = tmpContainer.GoodsKindId
                ;

       -- таблица -  Цены из прайса
     CREATE TEMP TABLE tmpPriceList (GoodsId Integer, GoodsKindId Integer, ValuePrice TFloat) ON COMMIT DROP;
        INSERT INTO tmpPriceList (GoodsId, GoodsKindId, ValuePrice)
            SELECT lfSelect.GoodsId     AS GoodsId
                 , lfSelect.GoodsKindId AS GoodsKindId
                 , lfSelect.ValuePrice  AS ValuePrice
            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= inOperDate) AS lfSelect;

     -- сохранили
     PERFORM lpUpdate_MovementItem_OrderExternal_Property (inId                 := tmpAll.MovementItemId
                                                         , inMovementId         := inMovementId
                                                         , inGoodsId            := tmpAll.GoodsId
                                                         , inGoodsKindId        := tmpAll.GoodsKindId
                                                         , inAmount_Param       := tmpAll.Amount_end
                                                         , inDescId_Param       := zc_MIFloat_AmountRemains()
                                                         , inAmount_ParamOrder  := NULL
                                                         , inDescId_ParamOrder  := NULL
                                                         , inPrice              := COALESCE (tmpPriceList_kind.ValuePrice, tmpPriceList.ValuePrice, 0) :: TFloat
                                                         , inCountForPrice      := 1
                                                         , inUserId             := vbUserId
                                                          )
     FROM tmpAll
          LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpAll.GoodsId
                                AND tmpPriceList.GoodsKindId IS NULL
          LEFT JOIN tmpPriceList AS tmpPriceList_kind
                                 ON tmpPriceList_kind.GoodsId = tmpAll.GoodsId
                                AND COALESCE (tmpPriceList_kind.GoodsKindId, 0) = COALESCE (tmpAll.GoodsKindId, 0)
    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.12.19         *
 13.02.15         *
*/

-- тест
-- SELECT * FROM gpUpdateMI_OrderExternal_AmountRemains (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
