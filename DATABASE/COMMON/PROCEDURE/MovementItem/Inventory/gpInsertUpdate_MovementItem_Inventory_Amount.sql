-- Function: gpInsertUpdate_MovementItem_Inventory_Amount (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Inventory_Amount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Inventory_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCLODescId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     SELECT Movement.OperDate                  AS OperDate
          , MovementLinkObject_From.ObjectId   AS UnitId
          INTO vbOperDate, vbUnitId
     FROM Movement
      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = Movement.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()    
     WHERE Movement.Id = inMovementId;

     vbCLODescId = (SELECT CASE WHEN Object.DescId = zc_Object_Unit() THEN zc_ContainerLinkObject_Unit()
                                WHEN Object.DescId = zc_Object_Car()  THEN zc_ContainerLinkObject_Car()
                                WHEN Object.DescId = zc_Object_Member() THEN zc_ContainerLinkObject_Member()
                           END
                    FROM Object WHERE Object.Id = vbUnitId);
                    
     
     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Inventory (ioId                 := COALESCE (tmp.MovementItemId, 0)
                                                  , inMovementId         := inMovementId
                                                  , inGoodsId            := tmp.GoodsId
                                                  , inAmount             := COALESCE (tmp.Amount_End,0)
                                                  , inPartionGoodsDate   := CASE WHEN tmp.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmp.PartionGoodsDate END
                                                  , inPrice              := 0
                                                  , inSumm               := 0
                                                  , inHeadCount          := 0
                                                  , inCount              := COALESCE (tmp.Count_End,0)
                                                  , inPartionGoods       := tmp.PartionGoods   
                                                  , inPartNumber         := NULL
                                                  , inPartionGoodsId     := tmp.PartionGoodsId
                                                  , inGoodsKindId        := tmp.GoodsKindId
                                                  , inGoodsKindCompleteId:= tmp.GoodsKindCompleteId
                                                  , inAssetId            := NULL
                                                  , inUnitId             := NULL
                                                  , inStorageId          := NULL  
                                                  , inPartionModelId     := NULL
                                                  , inUserId             := vbUserId
                                                   )
     FROM (WITH
           tmpContainer AS (SELECT Container.Id                                               AS ContainerId
                                 , Container.ObjectId                                         AS GoodsId
                                 , Container.Amount  - COALESCE (SUM (MIContainer.Amount), 0) AS Amount_End
                            FROM ContainerLinkObject AS CLO_Unit
                                 INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId
                                                     AND Container.DescId = zc_Container_Count()
                                 LEFT JOIN ContainerLinkObject AS CLO_Account
                                                               ON CLO_Account.ContainerId = Container.Id
                                                              AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate > vbOperDate -- т.к. остаток на Дата + 1
                            WHERE CLO_Unit.ObjectId = vbUnitId
                              AND CLO_Unit.DescId = vbCLODescId
                              AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                           GROUP BY Container.Id
                                   , Container.ObjectId
                                   , Container.Amount
                            HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                           ) 

         , tmpContainerCount AS (SELECT CLO_Unit.ContainerId                                       AS ContainerId
                                      , Container.ObjectId                                         AS GoodsId
                                      , Container.Amount  - SUM (COALESCE (MIContainer.Amount, 0)) AS Count_End
                                 FROM ContainerLinkObject AS CLO_Unit
                                      INNER JOIN Container ON Container.ParentId = CLO_Unit.ContainerId
                                                          AND Container.DescId = zc_Container_CountCount()
                                      LEFT JOIN MovementItemContainer AS MIContainer 
                                                                      ON MIContainer.ContainerId = Container.Id
                                                                     AND MIContainer.DescId = zc_MIContainer_CountCount()
                                                                     AND MIContainer.OperDate > vbOperDate

                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                          ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                                         AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                      LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_Destination
                                                           ON ObjectLink_InfoMoney_Destination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                          AND ObjectLink_InfoMoney_Destination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()
                                 WHERE CLO_Unit.ObjectId = 8449  -- -Только для Цех сирокопчених ковбас  -vbUnitId
                                   AND CLO_Unit.DescId = vbCLODescId
                                   -- Готовая продукция + Тушенка + Ирна
                                   AND ObjectLink_InfoMoney_Destination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_20900())
                                 GROUP BY CLO_Unit.ContainerId  --Container.Id
                                        , Container.ObjectId
                                        , Container.Amount
                                 HAVING (Container.Amount  - SUM (COALESCE (MIContainer.Amount, 0))) <> 0
                                ) 
                                                                  
         , tmpContainerAll AS (SELECT tmp.ContainerId
                                    , tmp.GoodsId
                                    , tmp.Amount_End
                                    , 0 AS Count_End
                               FROM tmpContainer AS tmp
                               UNION
                               SELECT tmp.ContainerId
                                    , tmp.GoodsId
                                    , 0 AS Amount_End
                                    , tmp.Count_End
                               FROM tmpContainerCount AS tmp
                               )                                                               

         , tmpMI AS (SELECT MovementItem.Id                                          AS MovementItemId
                          , MovementItem.ObjectId                                    AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)            AS GoodsKindId
                          , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)    AS GoodsKindCompleteId
                          , COALESCE (MILinkObject_PartionGoods.ObjectId, 0)         AS PartionGoodsId
                          , COALESCE (MIString_PartionGoods.ValueData, '')           AS PartionGoods
                          , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) AS PartionGoodsDate
                            --  № п/п
                          , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId
                                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                          , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0)
                                                          , COALESCE (MILinkObject_PartionGoods.ObjectId, 0)
                                                          , COALESCE (MIString_PartionGoods.ValueData, '')
                                                          , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart())
                                               ORDER BY MovementItem.Amount DESC
                                              ) AS Ord
                     FROM Movement
                          INNER JOIN MovementItem ON Movement.id = MovementItem.MovementId
                                                 AND MovementItem.isErased = FALSE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                           ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                          LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                       ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                                      AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                                           ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()

                     WHERE Movement.Id = inMovementId
                    )

         , tmpGoodsByPartion AS (SELECT tmp.GoodsId
                                 FROM (SELECT DISTINCT tmpContainerAll.GoodsId FROM tmpContainerAll
                                       UNION
                                       SELECT DISTINCT tmpMI.GoodsId FROM tmpMI
                                       ) AS tmp
                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                       INNER JOIN Object_InfoMoney_View AS View_InfoMoney 
                                                                        ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                       AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20100() -- Общефирменные + Запчасти и Ремонты
                                                                                                                   , zc_Enum_InfoMoneyDestination_20200() -- Общефирменные + Прочие ТМЦ
                                                                                                                   , zc_Enum_InfoMoneyDestination_20300() -- Общефирменные + МНМА
                                                                                                                    )
                                 )

           SELECT tmpMI.MovementItemId                                                   AS MovementItemId
                , COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)                         AS GoodsId
                , COALESCE (tmpContainer.GoodsKindId, tmpMI.GoodsKindId)                 AS GoodsKindId
                , COALESCE (tmpContainer.GoodsKindCompleteId, tmpMI.GoodsKindCompleteId) AS GoodsKindCompleteId
                , CASE WHEN tmpGoodsByPartion.GoodsId IS NULL THEN NULL ELSE COALESCE (tmpContainer.PartionGoodsId, tmpMI.PartionGoodsId) END  AS PartionGoodsId
                , COALESCE (tmpContainer.PartionGoods, tmpMI.PartionGoods)               AS PartionGoods
                , COALESCE (tmpContainer.PartionGoodsDate, tmpMI.PartionGoodsDate)       AS PartionGoodsDate
                , COALESCE (tmpContainer.Amount_End,0)                                   AS Amount_End
                , COALESCE (tmpContainer.Count_End,0)                                    AS Count_End

           FROM (SELECT tmpContainer.GoodsId
                      , COALESCE (CLO_GoodsKind.ObjectId, 0)                               AS GoodsKindId
                      , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)           AS GoodsKindCompleteId
                      , COALESCE (Object_PartionGoods.Id, 0)                               AS PartionGoodsId
                      , CASE WHEN Object_PartionGoods.ValueData <> '0' THEN Object_PartionGoods.ValueData ELSE '' END AS PartionGoods
                      , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                      , SUM (COALESCE (tmpContainer.Amount_End,0))                         AS Amount_End
                      , SUM (COALESCE (tmpContainer.Count_End,0))                          AS Count_End

                 FROM tmpContainerAll AS tmpContainer
                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                    ON CLO_GoodsKind.ContainerId = tmpContainer.ContainerId
                                                   AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()
                      LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                    ON CLO_PartionGoods.ContainerId = tmpContainer.ContainerId
                                                   AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                      LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId
                      LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                           ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                          AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                      LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                           ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                          AND ObjectLink_GoodsKindComplete.DescId = zc_ObjectLink_PartionGoods_GoodsKindComplete()
                 GROUP BY tmpContainer.GoodsId
                        , COALESCE (CLO_GoodsKind.ObjectId, 0)
                        , COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, 0)
                        , COALESCE (Object_PartionGoods.ValueData, '')
                        , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart())
                        , Object_PartionGoods.Id
                 HAVING SUM (tmpContainer.Amount_End) <> 0
                ) tmpContainer

                  FULL JOIN tmpMI ON tmpMI.GoodsId             = tmpContainer.GoodsId
                                 AND tmpMI.GoodsKindId         = tmpContainer.GoodsKindId
                                 AND tmpMI.GoodsKindCompleteId = tmpContainer.GoodsKindCompleteId
                                 AND tmpMI.PartionGoodsId      = tmpContainer.PartionGoodsId
                                 AND tmpMI.PartionGoods        = tmpContainer.PartionGoods
                                 AND tmpMI.PartionGoodsDate    = tmpContainer.PartionGoodsDate
                                 AND tmpMI.Ord                 = 1 -- !!!вдруг дублируются строки!!!
            LEFT JOIN tmpGoodsByPartion ON tmpGoodsByPartion.GoodsId = COALESCE (tmpContainer.GoodsId, tmpMI.GoodsId)
           ) AS tmp
           
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.18         *
 20.09.18         * vbContainerDescId
 06.08.17         *
 26.04.15                                        * all
 24.04.15         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Inventory_Amount
