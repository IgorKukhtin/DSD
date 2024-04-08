-- Function: gpReport_Sale_Olap()

DROP FUNCTION IF EXISTS gpReport_OrderGoods_Olap (TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderGoods_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inUnitId             Integer   ,    -- от кого
    IN inPriceListId        Integer   ,    -- прайс
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar, OperDate TDateTime
             , MonthDate TDateTime
             , GoodsGroupName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Summ TFloat
             , MeasureName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupAnalystName TVarChar
             , TradeMarkName TVarChar
             , GoodsTagName TVarChar
             , GoodsPlatformName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar, InfoMoneyId Integer
             )   
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!Только просмотр Аудитор!!!
    PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


    -- Результат
    RETURN QUERY
      WITH _tmpGoods AS (SELECT lfObject_Goods_byGoodsGroup.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfObject_Goods_byGoodsGroup
                         WHERE COALESCE (inGoodsId, 0) = 0 AND inGoodsGroupId > 0
                        UNION 
                         SELECT inGoodsId WHERE inGoodsId > 0
                        UNION 
                         SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND COALESCE (inGoodsId, 0) = 0 AND COALESCE (inGoodsGroupId, 0) = 0
                        )
         , _tmpFromGroup AS (SELECT lfSelect_Object_Unit_byGroup.UnitId AS UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect_Object_Unit_byGroup
                             WHERE inUnitId > 0
                            UNION
                             SELECT Object_Unit_View.Id FROM Object_Unit_View WHERE COALESCE (inUnitId, 0) = 0
                            )
         -- выбираем документы , период + подразделение + прайслист
         , tmpMovement AS (SELECT Movement.*
                                , MovementLinkObject_PriceList.ObjectId AS PriceListId
                                , MovementLinkObject_Unit.ObjectId      AS UnitId
                                , DATE_TRUNC ('Month',Movement.OperDate) AS MonthDate

                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                             ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                                            AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                                                            
                                
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
			     --   INNER JOIN _tmpFromGroup ON _tmpFromGroup.UnitId = MovementLinkObject_Unit.ObjectId

                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_OrderGoods()
                          AND Movement.StatusId <> zc_Enum_Status_Erased() --zc_Enum_Status_Complete()
                          AND (MovementLinkObject_PriceList.ObjectId = inPriceListId OR inPriceListId = 0)
                          )
         , tmpMI_All AS (SELECT tmpMovement.Id        AS MovementId
                              , tmpMovement.OperDate  AS OperDate
                              , tmpMovement.MonthDate AS MonthDate
                              , tmpMovement.InvNumber AS InvNumber
                              , MovementItem.Id       AS Id
                              , MovementItem.ObjectId AS GoodsId
                              , MovementItem.Amount   AS Amount
                         FROM tmpMovement
                             INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.DescId     = zc_MI_Master()
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                         )

         , tmpMI_Float AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                             AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_AmountSecond())
                          )

         , tmpMI AS (SELECT CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementId ELSE 0 END AS MovementId
                          , CASE WHEN inIsMovement = TRUE THEN MovementItem.OperDate ELSE NULL END AS OperDate
                          , CASE WHEN inIsMovement = TRUE THEN MovementItem.InvNumber ELSE '' END AS InvNumber
                          , MovementItem.MonthDate
                          , MovementItem.GoodsId
                          , SUM (MovementItem.Amount) AS Amount
                          , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))  AS AmountSecond
                          , SUM (COALESCE (MIFloat_Price.ValueData, 0)
                               * CASE WHEN COALESCE (MovementItem.Amount,0) <> 0 THEN MovementItem.Amount ELSE COALESCE (MIFloat_AmountSecond.ValueData, 0) END) AS OperSumm
                     FROM tmpMI_All AS MovementItem
                          LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MovementItem.Id
                                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                                ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                     GROUP BY CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementId ELSE 0 END
                            , CASE WHEN inIsMovement = TRUE THEN MovementItem.OperDate ELSE NULL END
                            , CASE WHEN inIsMovement = TRUE THEN MovementItem.InvNumber ELSE '' END
                            , MovementItem.GoodsId
                            , MovementItem.MonthDate
                     )

 

         , tmpGoodsParam AS (SELECT tmpGoods.GoodsId
                                  , Object_GoodsGroup.ValueData                  AS GoodsGroupName
                                  , ObjectLink_Goods_Measure.ChildObjectId       AS MeasureId
                                  , Object_Measure.ValueData                     AS MeasureName
                                  , ObjectFloat_Weight.ValueData                 AS Weight
                                  , ObjectString_Goods_GoodsGroupFull.ValueData  AS GoodsGroupNameFull
                                  , Object_GoodsGroupAnalyst.ValueData           AS GoodsGroupAnalystName
                                  , Object_TradeMark.ValueData                   AS TradeMarkName
                                  , Object_GoodsTag.ValueData                    AS GoodsTagName
                                  , Object_GoodsPlatform.ValueData               AS GoodsPlatformName

                                  , Object_InfoMoney_View.InfoMoneyCode
                                  , Object_InfoMoney_View.InfoMoneyGroupName
                                  , Object_InfoMoney_View.InfoMoneyDestinationName
                                  , Object_InfoMoney_View.InfoMoneyName
                                  , Object_InfoMoney_View.InfoMoneyName_all
                                  , Object_InfoMoney_View.InfoMoneyId
                             FROM (SELECT DISTINCT tmpMI.GoodsId
                                   FROM tmpMI
                                   ) AS tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                        ON ObjectFloat_Weight.ObjectId = tmpGoods.GoodsId
                                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                       ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                                  LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                       ON ObjectLink_Goods_TradeMark.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                  LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                       ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                                  LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                       ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                                  LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                       ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                            )

      -- Результат 
      SELECT tmpMI.InvNumber  :: TVarChar
           , tmpMI.OperDate   :: TDateTime
           , tmpMI.MonthDate  :: TDateTime

           , tmpGoodsParam.GoodsGroupName     AS GoodsGroupName 
           , Object_Goods.ObjectCode          AS GoodsCode
           , Object_Goods.ValueData           AS GoodsName  
           
           , (CASE WHEN tmpGoodsParam.MeasureId= zc_Measure_Sh() THEN tmpMI.AmountSecond ELSE tmpMI.Amount END)  :: TFloat AS Amount
           , tmpMI.OperSumm  :: TFloat AS Summ
           
           
           , tmpGoodsParam.MeasureName
           , tmpGoodsParam.GoodsGroupNameFull
           , tmpGoodsParam.GoodsGroupAnalystName
           , tmpGoodsParam.TradeMarkName
           , tmpGoodsParam.GoodsTagName
           , tmpGoodsParam.GoodsPlatformName
           , tmpGoodsParam.InfoMoneyCode
           , tmpGoodsParam.InfoMoneyGroupName
           , tmpGoodsParam.InfoMoneyDestinationName
           , tmpGoodsParam.InfoMoneyName
           , tmpGoodsParam.InfoMoneyName_all
           , tmpGoodsParam.InfoMoneyId
        FROM tmpMI

             LEFT JOIN Object AS Object_Goods on Object_Goods.Id = tmpMI.GoodsId

             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = tmpMI.GoodsId
             
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.20         *
 17.07.18         *
*/

-- тест-
-- SELECT * FROM gpReport_OrderGoods_Olap (inStartDate:= '01.06.2020', inEndDate:= '01.06.2023', inIsMovement:= true, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitId:= 0, inPriceListId:= 0, inSession:= zfCalc_UserAdmin()) 