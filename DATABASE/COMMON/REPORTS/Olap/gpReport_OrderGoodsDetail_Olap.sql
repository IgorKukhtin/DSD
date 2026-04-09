-- Function: gpReport_OrderGoodsDetail_Olap()

DROP FUNCTION IF EXISTS gpReport_OrderGoodsDetail_Olap (TDateTime, TDateTime, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderGoodsDetail_Olap (
    IN inStartDate          TDateTime ,  
    IN inEndDate            TDateTime ,
    IN inIsMovement         Boolean   ,
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inUnitId             Integer   ,    -- от кого
    IN inPriceListId        Integer   ,    -- прайс
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             --, MonthDate TDateTime 
             , ServiceDate TDateTime
             , OrderPeriodKindName TVarChar
             , PriceListName TVarChar
             , UnitName TVarChar
             , OrderGoodsName TVarChar

             --, MovementItemId Integer
             --, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName      TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsGroupName     TVarChar
             , MeasureName        TVarChar
             , Amount             TFloat  
             , Amount_master      TFloat
             , Weight_master      TFloat

             , GoodsGroupNameFull_parent TVarChar
             , GoodsCode_parent Integer, GoodsName_parent TVarChar
             , GoodsKindName_parent TVarChar
             , MeasureName_parent TVarChar

             , ReceiptCode Integer, ReceiptCode_str TVarChar, ReceiptName TVarChar
             , ReceiptBasisCode Integer, ReceiptBasisCode_str TVarChar, ReceiptBasisName TVarChar
             
             , GroupNumber Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar

             , TradeMarkName         TVarChar
             , GoodsTagName          TVarChar
             , GoodsPlatformName     TVarChar
             , GoodsGroupAnalystName TVarChar
             , InfoMoneyName_all     TVarChar
             , isTop Boolean
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
                                , MovementLinkObject_PriceList.ObjectId  AS PriceListId
                                , MovementLinkObject_Unit.ObjectId       AS UnitId
                                --, DATE_TRUNC ('Month',Movement.OperDate) AS MonthDate
                           FROM Movement
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                                             ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                                            AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
                                                            
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
			                    INNER JOIN _tmpFromGroup ON _tmpFromGroup.UnitId = MovementLinkObject_Unit.ObjectId

                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_OrderGoods()
                          AND Movement.StatusId <> zc_Enum_Status_Erased() --zc_Enum_Status_Complete()
                          AND (MovementLinkObject_PriceList.ObjectId = inPriceListId OR inPriceListId = 0)
                          )

         , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                                     FROM MovementLinkObject
                                     WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                       AND MovementLinkObject.DescId IN (zc_MovementLinkObject_OrderPeriodKind()
                                                                       , zc_MovementLinkObject_OrderGoods())
                                    )
         , tmpMovementDate AS (SELECT MovementDate.*
                               FROM MovementDate
                               WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                 AND MovementDate.DescId IN (zc_MovementDate_ServiceDate())
                              )
          --
         , tmpMovementDetail AS (SELECT Movement.* 
                                 FROM Movement
                                 WHERE Movement.ParentId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                   AND Movement.DescId = zc_Movement_OrderGoodsDetail()
                                 )

         , tmpMI_Child AS (SELECT *
                           FROM MovementItem 
                           WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementDetail.Id FROM tmpMovementDetail)
                             AND MovementItem.isErased   = FALSE
                             AND MovementItem.DescId     = zc_MI_Child()
                           )

         , tmpMI_parent AS (SELECT *
                            FROM MovementItem
                                 --ограничиваем по товару ГП
                                 INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MovementItem.ObjectId
                            WHERE MovementItem.Id IN (SELECT DISTINCT tmpMI_Child.ParentId FROM tmpMI_Child)
                              AND MovementItem.isErased   = FALSE
                              AND MovementItem.DescId     = zc_MI_Master()
                            )

         , tmpMILO_GoodsKind_Child AS (SELECT MovementItemLinkObject.*
                                       FROM MovementItemLinkObject
                                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_Child.Id FROM tmpMI_Child)
                                         AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                                      )

         , tmpMILO_GoodsKind_parent AS (SELECT MovementItemLinkObject.*
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_parent.Id FROM tmpMI_parent)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                                       )          

         , tmpMILO_parent AS (SELECT MovementItemLinkObject.*
                              FROM MovementItemLinkObject
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_parent.Id FROM tmpMI_parent)
                                AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Receipt()
                                                                    , zc_MILinkObject_ReceiptBasis())
                             )

         , tmpData AS (SELECT tmpMovementDetail.ParentId           AS MovementId_Parent
                            , MovementItem.MovementId
                            , MovementItem.Id
                            , MovementItem.ParentId
                            , MovementItem.ObjectId                AS GoodsId
                            , COALESCE (MILO_GoodsKind.ObjectId,0) AS GoodsKindId
      
                            , Object_InfoMoney_View.InfoMoneyCode
                            , Object_InfoMoney_View.InfoMoneyGroupName
                            , Object_InfoMoney_View.InfoMoneyDestinationName
                            , Object_InfoMoney_View.InfoMoneyDestinationId
                            , Object_InfoMoney_View.InfoMoneyName_all
                            , Object_InfoMoney_View.InfoMoneyName
                            , Object_InfoMoney_View.InfoMoneyId

                            , (COALESCE (MovementItem.Amount,0)) :: TFloat AS Amount
                            , CAST (CASE WHEN Object_Measure_parent.Id = zc_Measure_Sh() 
                                         THEN CASE WHEN COALESCE (ObjectFloat_Weight_parent.ValueData,0) <> 0 THEN COALESCE (MI_parent.Amount,0) / ObjectFloat_Weight_parent.ValueData ELSE COALESCE (MI_parent.Amount,0) END 
                                         ELSE 0
                                    END AS NUMERIC (16,0))       :: TFloat AS Amount_master
                            , (COALESCE (MI_parent.Amount,0))    :: TFloat AS Weight_master

                            , ObjectString_Goods_GoodsGroupFull_parent.ValueData ::TVarChar AS GoodsGroupNameFull_parent
                            , Object_Goods_parent.Id                                        AS GoodsId_parent
                            , Object_Goods_parent.ObjectCode  	                             AS GoodsCode_parent
                            , Object_Goods_parent.ValueData   	                  ::TVarChar AS GoodsName_parent
                            , Object_GoodsKind_parent.Id                                    AS GoodsKindId_parent
                            , Object_GoodsKind_parent.ValueData                  ::TVarChar AS GoodsKindName_parent
                            , Object_Measure_parent.ValueData                    ::TVarChar AS MeasureName_parent
                            , Object_Receipt.ObjectCode                                     AS ReceiptCode
                            , ObjectString_Receipt_Code.ValueData                ::TVarChar AS ReceiptCode_str
                            , Object_Receipt.ValueData                           ::TVarChar AS ReceiptName
                            , Object_ReceiptBasis.ObjectCode                                AS ReceiptBasisCode
                            , ObjectString_ReceiptBasis_Code.ValueData           ::TVarChar AS ReceiptBasisCode_str
                            , Object_ReceiptBasis.ValueData                      ::TVarChar AS ReceiptBasisName

                            , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := MovementItem.ObjectId
                                                             , inGoodsKindId            := COALESCE (MILO_GoodsKind.ObjectId,0)
                                                             , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                             , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                             , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                             , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                              )                            AS GroupNumber

                            , ROW_NUMBER() OVER (PARTITION BY tmpMovementDetail.Id, MovementItem.ParentId ORDER BY tmpMovementDetail.Id, MovementItem.Id) AS Ord
                       FROM tmpMovementDetail
                            INNER JOIN tmpMI_Child AS MovementItem ON MovementItem.MovementId = tmpMovementDetail.Id
                            LEFT JOIN tmpMILO_GoodsKind_Child AS MILO_GoodsKind
                                                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
      
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                            INNER JOIN tmpMI_parent AS MI_parent ON MI_parent.Id = MovementItem.ParentId
                            LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MI_parent.ObjectId
           
                            LEFT JOIN tmpMILO_GoodsKind_parent AS MILO_GoodsKind_parent
                                                               ON MILO_GoodsKind_parent.MovementItemId = MI_parent.Id
                                                              AND MILO_GoodsKind_parent.DescId         = zc_MILinkObject_GoodsKind()
                            LEFT JOIN Object AS Object_GoodsKind_parent ON Object_GoodsKind_parent.Id = MILO_GoodsKind_parent.ObjectId
           
                            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull_parent
                                                   ON ObjectString_Goods_GoodsGroupFull_parent.ObjectId = Object_Goods_parent.Id
                                                  AND ObjectString_Goods_GoodsGroupFull_parent.DescId   = zc_ObjectString_Goods_GroupNameFull()
           
                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure_parent
                                                 ON ObjectLink_Goods_Measure_parent.ObjectId =  Object_Goods_parent.Id
                                                AND ObjectLink_Goods_Measure_parent.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN Object AS Object_Measure_parent ON Object_Measure_parent.Id = ObjectLink_Goods_Measure_parent.ChildObjectId

                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight_parent
                                                  ON ObjectFloat_Weight_parent.ObjectId = Object_Goods_parent.Id
                                                 AND ObjectFloat_Weight_parent.DescId = zc_ObjectFloat_Goods_Weight()
           
                            LEFT JOIN tmpMILO_parent AS MILO_Receipt
                                                     ON MILO_Receipt.MovementItemId = MI_parent.Id
                                                    AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                            LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_Receipt.ObjectId
                            LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                                   ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                                  AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()
           
                            LEFT JOIN tmpMILO_parent AS MILO_ReceiptBasis
                                                     ON MILO_ReceiptBasis.MovementItemId = MI_parent.Id
                                                    AND MILO_ReceiptBasis.DescId = zc_MILinkObject_ReceiptBasis()
                            LEFT JOIN Object AS Object_ReceiptBasis ON Object_ReceiptBasis.Id = MILO_ReceiptBasis.ObjectId
                            LEFT JOIN ObjectString AS ObjectString_ReceiptBasis_Code
                                                   ON ObjectString_ReceiptBasis_Code.ObjectId = Object_ReceiptBasis.Id
                                                  AND ObjectString_ReceiptBasis_Code.DescId   = zc_ObjectString_Receipt_Code()

                            LEFT JOIN ObjectBoolean AS ObjectBoolean_WeightMain
                                                    ON ObjectBoolean_WeightMain.ObjectId = MILO_Receipt.ObjectId
                                                   AND ObjectBoolean_WeightMain.DescId = zc_ObjectBoolean_ReceiptChild_WeightMain()
                            LEFT JOIN ObjectBoolean AS ObjectBoolean_TaxExit
                                                    ON ObjectBoolean_TaxExit.ObjectId = MILO_Receipt.ObjectId
                                                   AND ObjectBoolean_TaxExit.DescId = zc_ObjectBoolean_ReceiptChild_TaxExit()
                       ) 

  -- выбираем данные по признаку товара ТОП из GoodsByGoodsKind
     , tmpTOP AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                       , Object_GoodsByGoodsKind_View.GoodsKindId
                  FROM ObjectBoolean
                       LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean.ObjectId
                  WHERE ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()
                    AND COALESCE (ObjectBoolean.ValueData, FALSE) = TRUE
                   )

     , tmpGoodsParam AS (SELECT tmp.GoodsId
                              , Object_TradeMark.ValueData      AS TradeMarkName
                              , Object_GoodsTag.ValueData       AS GoodsTagName
                              , Object_GoodsPlatform.ValueData  AS GoodsPlatformName
                              , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName

                              , Object_InfoMoney_View.InfoMoneyCode
                              , Object_InfoMoney_View.InfoMoneyGroupName
                              , Object_InfoMoney_View.InfoMoneyDestinationName
                              , Object_InfoMoney_View.InfoMoneyDestinationId
                              , Object_InfoMoney_View.InfoMoneyName_all
                              , Object_InfoMoney_View.InfoMoneyName
                              , Object_InfoMoney_View.InfoMoneyId
                         FROM (SELECT DISTINCT tmpData.GoodsId_parent AS GoodsId FROM tmpData) AS tmp

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                  ON ObjectLink_Goods_TradeMark.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                                  ON ObjectLink_Goods_GoodsPlatform.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                             LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                                  ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                             LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
                
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                  ON ObjectLink_Goods_GoodsTag.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                             LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmp.GoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                        )

      --
      SELECT Movement.Id                            AS MovementId
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate  ::TDateTime         AS OperDate
           --, Movement.MonthDate ::TDateTime         AS MonthDate
           , COALESCE (MovementDate_ServiceDate.ValueData, DATE_TRUNC ('Month', Movement.OperDate)) ::TDateTime AS ServiceDate

           , Object_OrderPeriodKind.ValueData       AS OrderPeriodKindName
           , Object_PriceList.ValueData  ::TVarChar AS PriceListName
           , Object_Unit.ValueData                  AS UnitName
           , Object_OrderGoods.ValueData            AS OrderGoodsName
           
           --, MovementItem.Id                        AS MovementItemId
           --, MovementItem.ParentId
           , Object_Goods.Id          		        AS GoodsId
           , Object_Goods.ObjectCode  		        AS GoodsCode
           , Object_Goods.ValueData   		        AS GoodsName
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData ::TVarChar AS GoodsGroupName
           , Object_Measure.ValueData               AS MeasureName

           , SUM (COALESCE (MovementItem.Amount,0))  :: TFloat AS Amount
           , SUM (CASE WHEN MovementItem.Ord = 1 THEN COALESCE (MovementItem.Amount_master,0) ELSE 0 END)  ::TFloat AS Amount_master 
           , SUM (CASE WHEN MovementItem.Ord = 1 THEN COALESCE (MovementItem.Weight_master,0) ELSE 0 END)  ::TFloat AS Weight_master

           , MovementItem.GoodsGroupNameFull_parent ::TVarChar AS GoodsGroupNameFull_parent
           , MovementItem.GoodsCode_parent                     AS GoodsCode_parent
           , MovementItem.GoodsName_parent          ::TVarChar AS GoodsName_parent
           , MovementItem.GoodsKindName_parent      ::TVarChar AS GoodsKindName_parent
           , MovementItem.MeasureName_parent        ::TVarChar AS MeasureName_parent
           , MovementItem.ReceiptCode                          AS ReceiptCode
           , MovementItem.ReceiptCode_str           ::TVarChar AS ReceiptCode_str
           , MovementItem.ReceiptName               ::TVarChar AS ReceiptName
           , MovementItem.ReceiptBasisCode                     AS ReceiptBasisCode
           , MovementItem.ReceiptBasisCode_str      ::TVarChar AS ReceiptBasisCode_str
           , MovementItem.ReceiptBasisName          ::TVarChar AS ReceiptBasisName

           , MovementItem.GroupNumber
           , MovementItem.InfoMoneyCode
           , MovementItem.InfoMoneyGroupName
           , MovementItem.InfoMoneyDestinationName
           , MovementItem.InfoMoneyName
          
           , tmpGoodsParam.TradeMarkName         :: TVarChar
           , tmpGoodsParam.GoodsTagName          :: TVarChar
           , tmpGoodsParam.GoodsPlatformName     :: TVarChar
           , tmpGoodsParam.GoodsGroupAnalystName :: TVarChar
           , tmpGoodsParam.InfoMoneyName_all     :: TVarChar AS InfoMoneyName_all_parent 
           , CASE WHEN tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END :: Boolean AS isTop

     FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = Movement.PriceListId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_OrderPeriodKind
                                            ON MovementLinkObject_OrderPeriodKind.MovementId = Movement.Id
                                           AND MovementLinkObject_OrderPeriodKind.DescId = zc_MovementLinkObject_OrderPeriodKind()
            LEFT JOIN Object AS Object_OrderPeriodKind ON Object_OrderPeriodKind.Id = MovementLinkObject_OrderPeriodKind.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_OrderGoods
                                            ON MovementLinkObject_OrderGoods.MovementId = Movement.Id
                                           AND MovementLinkObject_OrderGoods.DescId = zc_MovementLinkObject_OrderGoods()
            LEFT JOIN Object AS Object_OrderGoods ON Object_OrderGoods.Id = MovementLinkObject_OrderGoods.ObjectId

            LEFT JOIN tmpMovementDate AS MovementDate_ServiceDate
                                      ON MovementDate_ServiceDate.MovementId = Movement.Id
                                     AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            INNER JOIN tmpData AS MovementItem ON MovementItem.MovementId_Parent = Movement.Id

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId =  Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem.GoodsId_parent
            LEFT JOIN tmpTOP ON tmpTOP.GoodsId = MovementItem.GoodsId_parent
                            AND COALESCE (tmpTOP.GoodsKindId,0) = COALESCE (MovementItem.GoodsKindId_parent,0) 

     GROUP BY Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , COALESCE (MovementDate_ServiceDate.ValueData, DATE_TRUNC ('Month', Movement.OperDate))
           , Object_OrderPeriodKind.Id
           , Object_OrderPeriodKind.ValueData
           , Object_PriceList.Id
           , Object_PriceList.ValueData
           , Object_Unit.Id
           , Object_Unit.ValueData
           , Object_OrderGoods.Id
           , Object_OrderGoods.ValueData
           
           --, MovementItem.Id
           --, MovementItem.ParentId
           , Object_Goods.Id
           , Object_Goods.ObjectCode
           , Object_Goods.ValueData
           , Object_GoodsKind.ValueData
           , ObjectString_Goods_GoodsGroupFull.ValueData
           , Object_Measure.ValueData
           , MovementItem.GoodsGroupNameFull_parent
           , MovementItem.GoodsCode_parent
           , MovementItem.GoodsName_parent
           , MovementItem.GoodsKindName_parent
           , MovementItem.MeasureName_parent
           , MovementItem.ReceiptCode
           , MovementItem.ReceiptCode_str
           , MovementItem.ReceiptName
           , MovementItem.ReceiptBasisCode
           , MovementItem.ReceiptBasisCode_str
           , MovementItem.ReceiptBasisName
           , MovementItem.GroupNumber
           , MovementItem.InfoMoneyCode
           , MovementItem.InfoMoneyGroupName
           , MovementItem.InfoMoneyDestinationName
           , MovementItem.InfoMoneyName
           , tmpGoodsParam.TradeMarkName
           , tmpGoodsParam.GoodsTagName
           , tmpGoodsParam.GoodsPlatformName
           , tmpGoodsParam.GoodsGroupAnalystName
           , CASE WHEN tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END
           , Object_GoodsGroup.ValueData
           , tmpGoodsParam.InfoMoneyName_all
  ;
         
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/* -------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.04.26         *
*/

-- тест-
-- SELECT * FROM gpReport_OrderGoodsDetail_Olap (inStartDate:= '01.02.2026', inEndDate:= '01.05.2026', inIsMovement:= true, inGoodsGroupId:= 0, inGoodsId:= 0, inUnitId:= 0, inPriceListId:= 0, inSession:= zfCalc_UserAdmin()) 