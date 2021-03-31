-- Function: gpReport_StockTiming_Remainder()

DROP FUNCTION IF EXISTS gpReport_StockTiming_Remainder (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_StockTiming_Remainder(
    IN inOperDate     TDateTime,
    IN inUnitID       Integer,
    IN inMakerId      Integer,    -- Производитель
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE ( UnitCode         Integer      --Код подразделение откуда
              , UnitName         TVarChar     --Наименование подразделение откуда
              , GoodsCode        Integer      --Код товара
              , GoodsName        TVarChar     --Наименование товара
              , MakerCode        Integer      --Производитель
              , MakerName        TVarChar     --Наименование производителя
              , Price            TFloat
              , AmountDischarged TFloat
              , AmountDeferred   TFloat
              , SummaDeferred    TFloat
              , AmountComplete   TFloat
              , SummaComplete    TFloat
              , AmountLoss       TFloat
              , Amount5          TFloat
              , AmountUnit       TFloat
              , Amount           TFloat
              , Summa            TFloat
              , MakerId          Integer
              , ExpirationDate   TDateTime    --Срок годности
              , Remains          TFloat
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     inOperDate := DATE_TRUNC ('DAY', inOperDate) + INTERVAL '1 DAY';

     RETURN QUERY
     WITH
          tmpGoodsPromo AS (SELECT DISTINCT
                                     MI_Goods.ObjectId  AS GoodsId        -- здесь товар
                                   , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                   , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                                   , MIFloat_Price.ValueData            AS Price
                                   , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                                   , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
                                   , MovementLinkObject_Maker.ObjectId  AS MakerId
                              FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                              ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                             AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                             AND (MovementLinkObject_Maker.ObjectId = inMakerId OR inMakerId = 0)
                                INNER JOIN MovementDate AS MovementDate_StartPromo
                                                        ON MovementDate_StartPromo.MovementId = Movement.Id
                                                       AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                INNER JOIN MovementDate AS MovementDate_EndPromo
                                                        ON MovementDate_EndPromo.MovementId = Movement.Id
                                                       AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                   AND MI_Goods.DescId = zc_MI_Master()
                                                                   AND MI_Goods.isErased = FALSE
                                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                              ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                             AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                              WHERE Movement.StatusId = zc_Enum_Status_Complete()
                                AND Movement.DescId = zc_Movement_Promo()
                         )
          -- товары промо
     ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- здесь товар
                              , tmpGoodsPromo.StartDate_Promo
                              , tmpGoodsPromo.EndDate_Promo
                              , tmpGoodsPromo.Price               AS PriceSIP
                              , tmpGoodsPromo.isChecked
                              , tmpGoodsPromo.isReport
                              , tmpGoodsPromo.MakerId
                         FROM tmpGoodsPromo
                                 -- !!!
                                INNER JOIN ObjectLink AS ObjectLink_Child
                                                      ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId
                                                     AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                        AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                          AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                           AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                          WHERE  ObjectLink_Child_R.ChildObjectId<>0
                        )
      ,   tmpGoods AS (SELECT DISTINCT tmpGoods_All.GoodsId FROM tmpGoods_All)

      ,   tmpListGodsMarket AS (SELECT DISTINCT tmpGoods_All.GoodsId
                                     , tmpGoods_All.StartDate_Promo
                                     , tmpGoods_All.EndDate_Promo
                                     , tmpGoods_All.PriceSIP
                                     , tmpGoods_All.isChecked
                                     , tmpGoods_All.isReport
                                     , tmpGoods_All.MakerId
                                FROM tmpGoods_All
                                WHERE tmpGoods_All.StartDate_Promo <= inOperDate
                                  AND tmpGoods_All.EndDate_Promo >= '01.01.2019'
                                )
      , tmpMovementLoss AS (SELECT Movement.ID
                                 , Movement.OperDate
                                 , MovementLinkObject_Unit.ObjectId            AS UnitID
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                                              ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                                             AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                            WHERE Movement.operdate < inOperDate
                              AND Movement.DescId = zc_Movement_Loss()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND COALESCE(MovementLinkObject_ArticleLoss.ObjectId, 0) = 13892113
                              AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0))
      , tmpMovementItemLossAll AS (SELECT Movement.UnitID                          AS UnitID,
                                       MovementItem.ObjectId                    AS GoodsID,
                                       MovementItemContainer.ContainerId        AS ContainerId,
                                       MovementItem.Amount                      AS AmountLoss,
                                       tmpListGodsMarket.MakerId,
                                       Object_PartionMovementItem.ObjectCode

                                 FROM tmpMovementLoss AS Movement

                                      INNER JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                                             AND MovementItem.Amount > 0
                                                             AND MovementItem.DescId = zc_MI_Master()
                                                             AND MovementItem.iserased = False

                                      LEFT JOIN MovementItemContainer ON MovementItemContainer.movementitemid = MovementItem.id
                                                                     AND MovementItemContainer.descid = zc_Container_Count()
                                                                     AND MovementItemContainer.Amount < 0

/*                                      LEFT JOIN MovementItemContainer AS MICPD
                                                                      ON MICPD.movementitemid =  MovementItemContainer.movementitemid
                                                                     AND MICPD.descid = zc_Container_CountPartionDate()
                                                                     AND MICPD.Amount < 0

                                      LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MICPD.ContainerId
                                                                   AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                      LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                           ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                                                          AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
*/
                                      LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = MovementItem.ObjectId
                                                                 AND tmpListGodsMarket.StartDate_Promo <= Movement.OperDate
                                                                 AND tmpListGodsMarket.EndDate_Promo >= Movement.OperDate
                                                                 
                                      LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                    ON ContainerLinkObject_MovementItem.Containerid = MovementItemContainer.Containerid
                                                                   AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                      LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                                                                          AND Object_PartionMovementItem.Descid = zc_object_PartionMovementItem()   
                                                                 )
      , tmpMIFLoss As (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementItemLossAll.ObjectCode FROM tmpMovementItemLossAll))
                                                                       
      , tmpMovementItemLossIncome AS (SELECT Movement.UnitID                          AS UnitID,
                                       Movement.GoodsID                         AS GoodsID,
                                       Movement.ContainerId                     AS ContainerId,
                                       Movement.AmountLoss                      AS AmountLoss,
                                       Movement.MakerId,
                                      -- COALESCE(MI_Income_find.Id,MI_Income.Id) AS MI_IncomeId,
                                       COALESCE(MIFloat_MovementItem.ValueData :: Integer,Movement.ObjectCode) AS MI_IncomeId

                                 FROM tmpMovementItemLossAll AS Movement
                                      -- элемент прихода
                                     -- LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Movement.ObjectCode
                                      -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                      LEFT JOIN tmpMIFLoss AS MIFloat_MovementItem
                                                           ON MIFloat_MovementItem.MovementItemId = Movement.ObjectCode
                                                          AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                      -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    --  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                      )
      , tmpMIDLoss As (SELECT * FROM MovementItemDate WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovementItemLossIncome.MI_IncomeId FROM tmpMovementItemLossIncome))
      , tmpMovementItemLoss AS (SELECT Movement.UnitID                          AS UnitID,
                                       Movement.GoodsID                         AS GoodsID,
                                       Movement.ContainerId                     AS ContainerId,
                                       SUM(Movement.AmountLoss)                 AS AmountLoss,
                                       Movement.MakerId,
                                       COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate

                                 FROM tmpMovementItemLossIncome AS Movement

                                      LEFT OUTER JOIN tmpMIDLoss  AS MIDate_ExpirationDate
                                                                        ON MIDate_ExpirationDate.MovementItemId = Movement.MI_IncomeId
                                                                       AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                 GROUP BY Movement.UnitID
                                        , Movement.GoodsID
                                        , Movement.ContainerId
                                        , Movement.MakerId
                                        , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()))
      ,   tmpMovementSend AS (SELECT MovementLinkObject_Unit.ObjectId            AS UnitID,
                                     MovementItem.ObjectId                       AS GoodsID,
                                     MIFloat_ContainerId.ValueData::Integer      AS ContainerId,

                                     SUM(movementitem_Child.Amount)::TFloat      AS AmountSend
                               FROM Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                                  ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

                                    INNER JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                                           AND MovementItem.Amount > 0
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.iserased = False

                                    INNER JOIN movementitem AS movementitem_Child
                                                            ON movementitem_Child.movementid = Movement.Id
                                                           AND movementitem_Child.parentid = movementitem.id
                                                           AND movementitem_Child.amount > 0
                                                           AND movementitem_Child.DescId = zc_MI_Child()
                                                           AND movementitem_Child.iserased = False

                                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                ON MIFloat_ContainerId.MovementItemId = movementitem_Child.Id
                                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_To
                                                                 ON MovementLinkObject_Unit_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit_To.DescId = zc_MovementLinkObject_To()

                               WHERE Movement.operdate < inOperDate
                                 AND Movement.DescId = zc_Movement_Send()
                                 AND Movement.statusid = zc_Enum_Status_UnComplete() 
                                 AND MovementLinkObject_Unit_To.ObjectId = 11299914
                                 AND COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0) = zc_Enum_PartionDateKind_0()
                                 AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0)
                               GROUP BY MovementLinkObject_Unit.ObjectId
                                      , MovementItem.ObjectId
                                      , MIFloat_ContainerId.ValueData)
      , tmpContainerAll AS (SELECT Container.ParentId                       AS ContainerId,
                                   Container.WhereObjectId                  AS UnitId,
                                   Container.ObjectId                       AS GoodsId,
                                   SUM(CASE WHEN COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, False) = False 
                                            THEN Container.Amount - COALESCE (tmpMovementSend.AmountSend, 0) END)                    AS AmountUnit,
                                   SUM(CASE WHEN COALESCE (ObjectBoolean_PartionGoods_Cat_5.ValueData, False) = True 
                                            THEN Container.Amount - COALESCE (tmpMovementSend.AmountSend, 0) END)                    AS Amount5,
                                   MIN(ObjectDate_ExpirationDate.ValueData) AS ExpirationDate
                            FROM Container
                                 INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()
                                                          
                                 INNER JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                       ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId    
                                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                                 LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoods_Cat_5
                                                          ON ObjectBoolean_PartionGoods_Cat_5.ObjectId = ContainerLinkObject.ObjectId    
                                                         AND ObjectBoolean_PartionGoods_Cat_5.DescID = zc_ObjectBoolean_PartionGoods_Cat_5()
                                                         AND ObjectBoolean_PartionGoods_Cat_5.ValueData = True
                                 LEFT JOIN tmpMovementSend ON tmpMovementSend.ContainerId = Container.Id
                            WHERE Container.DescId = zc_Container_CountPartionDate()
                              AND Container.Amount > 0
                              AND (Container.WhereObjectId  = inUnitID OR COALESCE(inUnitID, 0) = 0)
                              AND ObjectDate_ExpirationDate.ValueData < CURRENT_DATE
                            GROUP BY Container.ParentId
                                   , Container.WhereObjectId
                                   , Container.ObjectId)
      ,   tmpMovementItem AS (SELECT MovementLinkObject_Unit.ObjectId            AS UnitID,
                                     MovementItem.ObjectId                       AS GoodsID,
                                     COALESCE(MovementItemContainer.ContainerId, ContainerMain.ParentId)  AS ContainerId,

                                     SUM(CASE WHEN Movement.statusid <> zc_Enum_Status_Complete() AND
                                                   COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = FALSE THEN movementitem_Child.Amount  END)::TFloat AS AmountDischarged,
                                     SUM(CASE WHEN COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE THEN - COALESCE(MICPD.Amount, MovementItemContainer.Amount)  END)::TFloat AS AmountDeferred,
                                     SUM(CASE WHEN Movement.statusid = zc_Enum_Status_Complete() THEN - COALESCE(MICPD.Amount, MovementItemContainer.Amount)  END)::TFloat AS AmountComplete,
                                     SUM(COALESCE(- MICPD.Amount, - MovementItemContainer.Amount, movementitem_Child.Amount))::TFloat    AS Amount,
                                     Null::TFloat                                                           AS AmountLoss,
                                     Null::TFloat                                                           AS Amount5,
                                     Null::TFloat                                                           AS AmountUnit,
                                     tmpListGodsMarket.MakerId,
                                     COALESCE (ObjectDate_ExpirationDate.ValueData, ObjectDate_ExpirationDate_Child.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate

                               FROM Movement

                                    INNER JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                                                  ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()

                                    INNER JOIN MovementItem ON MovementItem.movementid = Movement.Id
                                                           AND MovementItem.Amount > 0
                                                           AND MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.iserased = False

                                    INNER JOIN movementitem AS movementitem_Child
                                                            ON movementitem_Child.movementid = Movement.Id
                                                           AND movementitem_Child.parentid = movementitem.id
                                                           AND movementitem_Child.amount > 0
                                                           AND movementitem_Child.DescId = zc_MI_Child()
                                                           AND movementitem_Child.iserased = False

                                    LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                ON MIFloat_ContainerId.MovementItemId = movementitem_Child.Id
                                                               AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                                    LEFT JOIN Container AS ContainerMain
                                                        ON ContainerMain.Id = MIFloat_ContainerId.ValueData::Integer
                                    
                                    LEFT JOIN ContainerLinkObject AS CLO_Child
                                                                  ON CLO_Child.ContainerId = MIFloat_ContainerId.ValueData::Integer
                                                                 AND CLO_Child.DescId = zc_ContainerLinkObject_PartionGoods()

                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate_Child
                                                         ON ObjectDate_ExpirationDate_Child.ObjectId = CLO_Child.ObjectId 
                                                        AND ObjectDate_ExpirationDate_Child.DescId = zc_ObjectDate_PartionGoods_Value()

                                    LEFT JOIN MovementItemContainer ON MovementItemContainer.movementitemid =  COALESCE(movementitem_Child.ID, movementitem.id)
                                                                   AND MovementItemContainer.descid = zc_Container_Count()
                                                                   AND MovementItemContainer.Amount < 0

                                    LEFT JOIN MovementItemContainer AS MICPD
                                                                    ON MICPD.movementitemid =  MovementItemContainer.movementitemid
                                                                   AND MICPD.descid = zc_Container_CountPartionDate()
                                                                   AND MICPD.Amount < 0

                                    LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = MICPD.ContainerId
                                                                 AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId 
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                    LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = MovementItem.ObjectId
                                                               AND tmpListGodsMarket.StartDate_Promo <= Movement.OperDate
                                                               AND tmpListGodsMarket.EndDate_Promo >= Movement.OperDate

                                    LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                              ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                             AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()

                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit_To
                                                                 ON MovementLinkObject_Unit_To.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit_To.DescId = zc_MovementLinkObject_To()

                                    LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                  ON ContainerLinkObject_MovementItem.Containerid = MovementItemContainer.Containerid
                                                                 AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                    LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                    -- элемент прихода
                                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                    -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                    LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                                ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                               AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                    -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                    LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                         -- AND 1=0
                                    LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                                      ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                                     AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                               WHERE Movement.operdate < inOperDate
                                 AND Movement.DescId = zc_Movement_Send()
                                 AND Movement.statusid = zc_Enum_Status_UnComplete() 
                                 --AND (Movement.statusid = zc_Enum_Status_Complete() OR COALESCE (MovementBoolean_Deferred.ValueData, FALSE) = TRUE)
                                 AND MovementLinkObject_Unit_To.ObjectId = 11299914
                                 AND COALESCE(MovementLinkObject_PartionDateKind.ObjectId, 0) = zc_Enum_PartionDateKind_0()
                                 AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0)
                               GROUP BY MovementLinkObject_Unit.ObjectId, MovementItem.ObjectId, COALESCE(MovementItemContainer.ContainerId, ContainerMain.ParentId),
                                        tmpListGodsMarket.MakerId, COALESCE (ObjectDate_ExpirationDate.ValueData, ObjectDate_ExpirationDate_Child.ValueData, MIDate_ExpirationDate.ValueData, zc_DateEnd())
                               UNION ALL
                               SELECT tmpMovementItemLoss.UnitID                   AS UnitID,
                                      tmpMovementItemLoss.GoodsID                  AS GoodsID,
                                      tmpMovementItemLoss.ContainerId              AS ContainerId,
                                      Null::TFloat                                 AS AmountDischarged,
                                      Null::TFloat                                 AS AmountDeferred,
                                      Null::TFloat                                 AS AmountComplete,
                                      Null::TFloat                                 AS Amount,
                                      tmpMovementItemLoss.AmountLoss::TFloat       AS AmountLoss,
                                      Null::TFloat                                 AS Amount5,
                                      Null::TFloat                                 AS AmountUnit,
                                      tmpMovementItemLoss.MakerId,
                                      tmpMovementItemLoss.ExpirationDate           AS ExpirationDate
                               FROM tmpMovementItemLoss
                               UNION ALL
                               SELECT tmpContainerAll.UnitID                       AS UnitID,
                                      tmpContainerAll.GoodsID                      AS GoodsID,
                                      tmpContainerAll.ContainerId                  AS ContainerId,
                                      Null::TFloat                                 AS AmountDischarged,
                                      Null::TFloat                                 AS AmountDeferred,
                                      Null::TFloat                                 AS AmountComplete,
                                      Null::TFloat                                 AS Amount,
                                      Null::TFloat                                 AS AmountLoss,
                                      tmpContainerAll.Amount5::TFloat              AS Amount5,
                                      tmpContainerAll.AmountUnit::TFloat           AS AmountUnit,
                                      tmpListGodsMarket.MakerId,
                                      tmpContainerAll.ExpirationDate               AS ExpirationDate
                               FROM tmpContainerAll
                                    LEFT JOIN tmpListGodsMarket ON tmpListGodsMarket.GoodsId = tmpContainerAll.GoodsID 
                                                               AND tmpListGodsMarket.StartDate_Promo <= inOperDate
                                                               AND tmpListGodsMarket.EndDate_Promo >= inOperDate
                               
                               )

      ,   tmpMovementItemSum AS (SELECT Movement.UnitId,
                                       Movement.GoodsId,
                                       
                                       CASE WHEN SUM(COALESCE(Movement.Amount, 0) +
                                                     COALESCE(Movement.AmountLoss, 0) +
                                                     COALESCE(Movement.Amount5, 0) +
                                                     COALESCE(Movement.AmountUnit, 0)) <> 0 
                                           THEN SUM(AnalysisContainer.Price * (COALESCE(Movement.Amount, 0) +
                                                     COALESCE(Movement.AmountLoss, 0) +
                                                     COALESCE(Movement.Amount5, 0) +
                                                     COALESCE(Movement.AmountUnit, 0))) / SUM(COALESCE(Movement.Amount, 0) +
                                                     COALESCE(Movement.AmountLoss, 0) +
                                                     COALESCE(Movement.Amount5, 0) +
                                                     COALESCE(Movement.AmountUnit, 0))
                                           ELSE 0 END::TFloat  AS Price,

                                       SUM(Movement.AmountDischarged)::TFloat                                AS AmountDischarged,
                                       SUM(Movement.AmountDeferred)::TFloat                                  AS AmountDeferred,
                                       SUM(Movement.AmountComplete)::TFloat                                  AS AmountComplete,
                                       SUM(Movement.AmountLoss)::TFloat                                      AS AmountLoss,
                                       SUM(Movement.Amount5)::TFloat                                         AS Amount5,
                                       SUM(Movement.AmountUnit)::TFloat                                      AS AmountUnit,
                                       SUM(COALESCE(Movement.Amount, 0) +
                                           COALESCE(Movement.Amount5, 0) +
                                           COALESCE(Movement.AmountUnit, 0))::TFloat                         AS Amount,
                                       Movement.MakerId,
                                       Movement.ExpirationDate                                               AS ExpirationDate

                                 FROM tmpMovementItem AS Movement

                                      LEFT JOIN AnalysisContainer ON AnalysisContainer.Id = Movement.ContainerId

                                 GROUP BY Movement.UnitId, Movement.GoodsId, Movement.MakerId, Movement.ExpirationDate)

      ,   tmpContainer AS (SELECT tmpContainerId.UnitID
                                , tmpContainerId.GoodsId
                                , SUM(Container.Amount)::TFloat  AS Remains
                           FROM (SELECT DISTINCT tmpMovementItemSum.UnitID, tmpMovementItemSum.GoodsId FROM tmpMovementItemSum) AS tmpContainerId
                                INNER JOIN Container ON Container.WhereObjectId = tmpContainerId.UnitID
                                                    AND Container.ObjectId = tmpContainerId.GoodsId
                                                    AND Container.DescId  = zc_Container_Count()
                                                    AND Container.Amount > 0
                          GROUP BY tmpContainerId.UnitID
                                 , tmpContainerId.GoodsId
                          )

     SELECT

           Object_Unit.ObjectCode,
           Object_Unit.ValueData,
           Object_Goods.ObjectCode,
           Object_Goods.ValueData,
           Object_Maker.ObjectCode,
           Object_Maker.ValueData,

           Round(Movement.Price, 2)::TFloat ,

           Movement.AmountDischarged,
           Movement.AmountDeferred,
           ROUND(Movement.AmountDeferred * Round(Movement.Price, 2), 2)::TFloat ,
           Movement.AmountComplete,
           ROUND(Movement.AmountComplete * Round(Movement.Price, 2), 2)::TFloat ,
           Movement.AmountLoss,
           Movement.Amount5,
           Movement.AmountUnit,
           Movement.Amount,
           ROUND(Movement.Amount * Round(Movement.Price, 2), 2)::TFloat,

           Movement.MakerId,
           DATE_TRUNC ('DAY', Movement.ExpirationDate)::TDateTime,
           tmpContainer.Remains

     FROM tmpMovementItemSum AS Movement

          LEFT JOIN tmpContainer ON tmpContainer.UnitId = Movement.UnitId
                                AND tmpContainer.GoodsId = Movement.GoodsId


          LEFT JOIN Object AS Object_Unit
                           ON Object_Unit.ID = Movement.UnitId

          LEFT JOIN Object AS Object_Goods
                           ON Object_Goods.ID = Movement.GoodsId

          LEFT JOIN Object AS Object_Maker
                           ON Object_Maker.ID = Movement.MakerId

     WHERE Movement.MakerId = inMakerId OR inMakerId = 0;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.01.20                                                       *
*/

-- тест
-- SELECT * FROM gpReport_StockTiming_Remainder(inOperDate :=  '15.01.2020', inUnitID := 0, inMakerId := 0, inSession := '3')

--select * from gpReport_StockTiming_Remainder(inOperDate := ('11.03.2021')::TDateTime , inUnitId := 377606 , inMakerId := 0 ,  inSession := '3');

--select * from gpReport_StockTiming_Remainder(inOperDate := ('11.03.2021')::TDateTime , inUnitId := 377613 , inMakerId := 0 ,  inSession := '3');

select * from gpReport_StockTiming_Remainder(inOperDate := ('30.03.2021')::TDateTime , inUnitId := 8393158 , inMakerId := 0 ,  inSession := '3');