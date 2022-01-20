-- Function: gpReport_Layout_OutOrder()

DROP FUNCTION IF EXISTS gpReport_Layout_OutOrder (TVarChar);


CREATE OR REPLACE FUNCTION gpReport_Layout_OutOrder(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar
             , JuridicalMainName TVarChar
             , GoodsId Integer
             , GoodsCode Integer
             , GoodsName TVarChar
             , OperDatePriceLink TDateTime
             , JuridicalNameLink TVarChar
             , OperDatePrice TDateTime
             , JuridicalName TVarChar
             , AmountLayout TFloat
             , Remains TFloat
             , MCSValue TFloat
             , InvnNumberIncome TVarChar
             , OperDateIncome TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTmpDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);
    
    vbTmpDate := '01.01.2022';

   RETURN QUERY
   WITH
        -- Выкладка       
         tmpLayoutMovement AS (SELECT Movement.Id                                             AS Id
                                    , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
                               FROM Movement
                                    LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                              ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                             AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                               WHERE Movement.DescId = zc_Movement_Layout()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
       , tmpLayout AS (SELECT Movement.ID                        AS Id
                            , MovementItem.ObjectId              AS GoodsId
                            , MovementItem.Amount                AS Amount
                            , Movement.isPharmacyItem            AS isPharmacyItem
                       FROM tmpLayoutMovement AS Movement
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId = zc_MI_Master()
                                                   AND MovementItem.isErased = FALSE
                                                   AND MovementItem.Amount > 0
                      )
       , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                , MovementItem.ObjectId              AS UnitId
                           FROM tmpLayoutMovement AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Child()
                                                       AND MovementItem.isErased = FALSE
                                                       AND MovementItem.Amount > 0
                          )
       , tmpLayoutAll AS (SELECT DISTINCT
                                 tmpLayoutUnit.UnitId
                               , tmpLayout.GoodsId
                               , tmpLayout.Amount
                          FROM tmpLayout
                                       
                               LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                             
                           )
       , tmpOrderInternal AS (SELECT Movement.id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                                   , MovementLinkObject_Unit.ObjectId AS UnitId
                              FROM Movement
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              WHERE Movement.OperDate BETWEEN vbTmpDate AND CURRENT_DATE - INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_OrderInternal() AND Movement.StatusId = zc_Enum_Status_Complete()
                             )
       , tmpMIOrderInternal AS (SELECT Movement.ID                        AS Id
                                     , Movement.InvNumber
                                     , Movement.OperDate
                                     , Movement.UnitId
                                     , MovementItem.ObjectId              AS GoodsId
                                     , ROW_NUMBER()OVER(PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) as ORD
                                FROM tmpOrderInternal AS Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                            AND MovementItem.DescId = zc_MI_Master()
                                     INNER JOIN tmpLayoutAll ON tmpLayoutAll.UnitId = Movement.UnitId
                                                            AND tmpLayoutAll.GoodsId = MovementItem.ObjectId
                               )
       , tmpIncome AS (SELECT Movement.id
                            , Movement.InvNumber
                            , Movement.OperDate
                            , MovementLinkObject_Unit.ObjectId AS UnitId
                       FROM Movement
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_To()
                       WHERE Movement.OperDate >= vbTmpDate 
                         AND Movement.DescId = zc_Movement_Income() AND Movement.StatusId <> zc_Enum_Status_Erased()
                      )
       , tmpMIIncome AS (SELECT Movement.ID                        AS Id
                              , Movement.InvNumber
                              , Movement.OperDate
                              , Movement.UnitId
                              , MovementItem.ObjectId              AS GoodsId
                              , ROW_NUMBER()OVER(PARTITION BY Movement.UnitId, MovementItem.ObjectId ORDER BY Movement.OperDate DESC) as ORD
                         FROM tmpIncome AS Movement
                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                              INNER JOIN tmpLayoutAll ON tmpLayoutAll.UnitId = Movement.UnitId
                                                     AND tmpLayoutAll.GoodsId = MovementItem.ObjectId
                        )
       , tmpLayoutGoods AS (SELECT DISTINCT
                                   MovementItem.ObjectId              AS GoodsId
                            FROM tmpLayoutMovement AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                           )
       , tmpNotLinkPriceList AS (SELECT Object_Goods_Main.Id
                                      , MAX(LoadPriceList.OperDate)::TDateTime                    AS OperDate
                                      , string_agg(Object_Juridical.ValueData, ' , ')::TVarChar   AS JuridicalName
                                 FROM tmpLayoutGoods AS tmpLayout
                                   
                                      INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpLayout.GoodsId
                                      INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                      LEFT JOIN Object_Goods_BarCode ON Object_Goods_BarCode.ID = Object_Goods_Main.Id
                                        
                                      LEFT JOIN LoadPriceListItem ON (LoadPriceListItem.CommonCode = Object_Goods_Main.MorionCode or LoadPriceListItem.barcode = Object_Goods_BarCode.barcode)
                                                                 AND LoadPriceListItem.goodsid is Null
                                      INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                      LEFT JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = LoadPriceListItem.goodsid
                                                                      AND Object_Goods_Juridical.JuridicalId = LoadPriceList.JuridicalId
                                        
                                      LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId

                                 WHERE COALESCE(LoadPriceListItem.id, 0) <> 0 AND 
                                       (COALESCE (Object_Goods_Juridical.ID, 0) = 0 OR Object_Goods_Juridical.GoodsMainId <> Object_Goods_Retail.GoodsMainId)
                                 GROUP BY Object_Goods_Main.Id)
       , tmpLinkPriceList AS (SELECT Object_Goods_Main.Id
                                   , MAX(LoadPriceList.OperDate)::TDateTime                    AS OperDate
                                   , string_agg(DISTINCT Object_Juridical.ValueData, ' , ')::TVarChar   AS JuridicalName
                              FROM tmpLayoutGoods AS tmpLayout
                                   
                                   INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpLayout.GoodsId
                                   INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                   INNER JOIN Object_Goods_Juridical ON Object_Goods_Juridical.GoodsMainId = Object_Goods_Main.ID
                                        
                                   INNER JOIN LoadPriceListItem ON LoadPriceListItem.GoodsId = Object_Goods_Main.Id
                                                               AND COALESCE(LoadPriceListItem.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE + INTERVAL '1 YEAR'
                                        
                                   INNER JOIN LoadPriceList ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = LoadPriceList.JuridicalId
 
                              GROUP BY Object_Goods_Main.Id)
       , tmpLayoutOutOrder AS (SELECT MIOrderInternal.ID
                                    , MIOrderInternal.InvNumber
                                    , MIOrderInternal.OperDate
                                    , MIOrderInternal.UnitId
                                    , ObjectUnit.ObjectCode         AS UnitCode
                                    , ObjectUnit.ValueData          AS UnitName
                                    , Object_Juridical.ValueData    AS JuridicalMainName
                                    , MIOrderInternal.GoodsId
                                    , Object_Goods_Main.ObjectCode  AS GoodsCode
                                    , Object_Goods_Main.Name        AS GoodsName
                                    , tmpLinkPriceList.OperDate     AS OperDatePriceLink
                                    , tmpLinkPriceList.JuridicalName  AS JuridicalNameLink
                                    , tmpNotLinkPriceList.OperDate  AS OperDatePrice
                                    , tmpNotLinkPriceList.JuridicalName
                                    , tmpLayoutAll.Amount           AS AmountLayout 
                               FROM tmpMIOrderInternal AS MIOrderInternal 
                               
                                    INNER JOIN tmpLayoutAll ON tmpLayoutAll.UnitId = MIOrderInternal.UnitId
                                                           AND tmpLayoutAll.GoodsId = MIOrderInternal.GoodsId

                                    LEFT JOIN tmpMIIncome ON tmpMIIncome.GoodsId = MIOrderInternal.GoodsId
                                                         AND tmpMIIncome.UnitId = MIOrderInternal.UnitId
                                                         AND tmpMIIncome.OperDate >= MIOrderInternal.OperDate
                                                         AND tmpMIIncome.ORD = 1
                                                         
                                    LEFT JOIN Object AS ObjectUnit ON ObjectUnit.ID = MIOrderInternal.UnitId

                                    LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                         ON ObjectLink_Unit_Juridical.ObjectId = MIOrderInternal.UnitId
                                                        AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                    LEFT JOIN Object AS Object_Juridical ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId

                                    LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MIOrderInternal.GoodsId
                                    LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                          
                                    LEFT JOIN tmpNotLinkPriceList ON tmpNotLinkPriceList.ID = Object_Goods_Retail.GoodsMainId

                                    LEFT JOIN tmpLinkPriceList ON tmpLinkPriceList.ID = Object_Goods_Retail.GoodsMainId

                               WHERE MIOrderInternal.ORD = 1
                                 AND COALESCE (tmpMIIncome.Id, 0) = 0
                                 AND (COALESCE (tmpLinkPriceList.ID, 0) <> 0 OR COALESCE (tmpNotLinkPriceList.ID, 0) <> 0))
       , tmpRemains AS (SELECT LayoutOutOrder.GoodsId
                             , LayoutOutOrder.UnitId
                             , SUM(Container.Amount)::TFloat   AS Amount
                             , MAX(COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)) AS MovementId
                        FROM tmpLayoutOutOrder AS LayoutOutOrder
                        
                             INNER JOIN Container ON Container.DescId = zc_Container_Count()
                                                 AND Container.ObjectId = LayoutOutOrder.GoodsId
                                                 AND Container.WhereObjectId = LayoutOutOrder.UnitId
                                                
                             LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                           ON ContainerLinkObject_MovementItem.Containerid = Container.Id
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

                        GROUP BY LayoutOutOrder.GoodsId
                               , LayoutOutOrder.UnitId  
                        )
       , tmpPrice AS (SELECT LayoutOutOrder.GoodsId
                           , LayoutOutOrder.UnitId
                           , MCS_Value.ValueData                     AS MCSValue
                      FROM tmpLayoutOutOrder AS LayoutOutOrder
                        
                         INNER JOIN ObjectLink AS ObjectLink_Price_Unit 
                                               ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                              AND ObjectLink_Price_Unit.ChildObjectId = LayoutOutOrder.UnitId
                         INNER JOIN ObjectLink AS Price_Goods
                                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                              AND Price_Goods.ChildObjectId = LayoutOutOrder.GoodsId
                         LEFT JOIN ObjectFloat AS MCS_Value
                                               ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                      )
                         
   SELECT LayoutOutOrder.ID
        , LayoutOutOrder.InvNumber
        , LayoutOutOrder.OperDate
        , LayoutOutOrder.UnitId
        , LayoutOutOrder.UnitCode
        , LayoutOutOrder.UnitName
        , LayoutOutOrder.JuridicalMainName
        , LayoutOutOrder.GoodsId
        , LayoutOutOrder.GoodsCode
        , LayoutOutOrder.GoodsName
        , LayoutOutOrder.OperDatePriceLink
        , LayoutOutOrder.JuridicalNameLink
        , LayoutOutOrder.OperDatePrice
        , LayoutOutOrder.JuridicalName
        , LayoutOutOrder.AmountLayout
        , tmpRemains.Amount                   AS Remains
        , tmpPrice.MCSValue  
        , MovementIncome.InvNumber
        , MovementIncome.OperDate
   FROM tmpLayoutOutOrder AS LayoutOutOrder 
   
        LEFT JOIN tmpRemains ON tmpRemains.GoodsId = LayoutOutOrder.GoodsId
                            AND tmpRemains.UnitId = LayoutOutOrder.UnitId
                            
        LEFT JOIN tmpPrice ON tmpPrice.GoodsId = LayoutOutOrder.GoodsId
                          AND tmpPrice.UnitId = LayoutOutOrder.UnitId

        LEFT JOIN Movement AS MovementIncome ON MovementIncome.Id = tmpRemains.MovementId
                                                                                                                 
                            
   WHERE LayoutOutOrder.AmountLayout > COALESCE (tmpRemains.Amount, 0)
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 12.01.22                                                       *
*/

-- тест
--
SELECT * FROM gpReport_Layout_OutOrder (inSession:= '3')