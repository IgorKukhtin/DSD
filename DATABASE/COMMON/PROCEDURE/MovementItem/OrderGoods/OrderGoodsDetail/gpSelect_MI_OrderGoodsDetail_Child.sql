-- Function: gpSelect_MI_OrderGoodsDetail_Child()
DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Child (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_OrderGoodsDetail_Child (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderGoodsDetail_Child(
    IN inParentId    Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureName TVarChar
             , Amount TFloat

             , GoodsGroupNameFull_parent TVarChar
             , GoodsCode_parent Integer, GoodsName_parent TVarChar
             , GoodsKindName_parent TVarChar
             , MeasureName_parent TVarChar

             , ReceiptCode Integer, ReceiptCode_str TVarChar, ReceiptName TVarChar
             , ReceiptBasisCode Integer, ReceiptBasisCode_str TVarChar, ReceiptBasisName TVarChar
             
             , isErased Boolean
             , GroupNumber Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar
             , Color_calc Integer

             , TradeMarkName         TVarChar
             , GoodsTagName          TVarChar
             , GoodsPlatformName     TVarChar
             , GoodsGroupAnalystName TVarChar
             , isTop Boolean
              )
AS
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbMovementId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoodsDetail());
     vbUserId:= lpGetUserBySession (inSession);


     -- Нашли документ
     vbMovementId := (SELECT Movement.Id FROM Movement WHERE Movement.ParentId = inParentId AND Movement.DescId = zc_Movement_OrderGoodsDetail());

     -- Результат
     RETURN QUERY
     WITH 
     tmpMI AS (SELECT MovementItem.*
               FROM MovementItem
               WHERE MovementItem.MovementId = vbMovementId
                 AND MovementItem.DescId     = zc_MI_Child()
                 AND (MovementItem.isErased  = FALSE OR inisErased = TRUE)
               )

   , tmpData AS (SELECT CASE WHEN inShowAll = TRUE THEN MovementItem.Id ELSE 0 END AS Id
                      , CASE WHEN inShowAll = TRUE THEN MovementItem.ParentId ELSE 0 END AS ParentId
                      , MovementItem.ObjectId
                      , COALESCE (MILO_GoodsKind.ObjectId,0) AS GoodsKindId

                      , Object_InfoMoney_View.InfoMoneyCode
                      , Object_InfoMoney_View.InfoMoneyGroupName
                      , Object_InfoMoney_View.InfoMoneyDestinationName
                      , Object_InfoMoney_View.InfoMoneyName

                      , (COALESCE (MovementItem.Amount,0)) :: TFloat AS Amount
            
                      , CASE WHEN inShowAll = TRUE THEN ObjectString_Goods_GoodsGroupFull_parent.ValueData ELSE '' END ::TVarChar AS GoodsGroupNameFull_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.Id                       ELSE 0  END            AS GoodsId_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ObjectCode  	     ELSE 0  END            AS GoodsCode_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_Goods_parent.ValueData   	     ELSE '' END ::TVarChar AS GoodsName_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_GoodsKind_parent.Id                   ELSE 0  END            AS GoodsKindId_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_GoodsKind_parent.ValueData            ELSE '' END ::TVarChar AS GoodsKindName_parent
                      , CASE WHEN inShowAll = TRUE THEN Object_Measure_parent.ValueData              ELSE '' END ::TVarChar AS MeasureName_parent
            
                      , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ObjectCode                    ELSE 0  END AS ReceiptCode
                      , CASE WHEN inShowAll = TRUE THEN ObjectString_Receipt_Code.ValueData          ELSE '' END ::TVarChar AS ReceiptCode_str
                      , CASE WHEN inShowAll = TRUE THEN Object_Receipt.ValueData                     ELSE '' END ::TVarChar AS ReceiptName
            
                      , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ObjectCode               ELSE 0 END AS ReceiptBasisCode
                      , CASE WHEN inShowAll = TRUE THEN ObjectString_ReceiptBasis_Code.ValueData     ELSE '' END ::TVarChar AS ReceiptBasisCode_str
                      , CASE WHEN inShowAll = TRUE THEN Object_ReceiptBasis.ValueData                ELSE '' END ::TVarChar AS ReceiptBasisName

                      , zfCalc_ReceiptChild_GroupNumber (inGoodsId                := MovementItem.ObjectId
                                                       , inGoodsKindId            := COALESCE (MILO_GoodsKind.ObjectId,0)
                                                       , inInfoMoneyDestinationId := Object_InfoMoney_View.InfoMoneyDestinationId
                                                       , inInfoMoneyId            := Object_InfoMoney_View.InfoMoneyId
                                                       , inIsWeightMain           := ObjectBoolean_WeightMain.ValueData
                                                       , inIsTaxExit              := ObjectBoolean_TaxExit.ValueData
                                                        ) AS GroupNumber
                      , MovementItem.isErased 
                 FROM tmpMI AS MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                       ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                      LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                           ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                      LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                      LEFT JOIN MovementItem AS MI_parent
                                             ON MI_parent.Id = MovementItem.ParentId
                                            AND inShowAll = TRUE   -- показываем данные мастер по галке "показать детально"
                      LEFT JOIN Object AS Object_Goods_parent ON Object_Goods_parent.Id = MI_parent.ObjectId
            
                      LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind_parent
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
            
                      LEFT JOIN MovementItemLinkObject AS MILO_Receipt
                                                       ON MILO_Receipt.MovementItemId = MI_parent.Id
                                                      AND MILO_Receipt.DescId = zc_MILinkObject_Receipt()
                      LEFT JOIN Object AS Object_Receipt ON Object_Receipt.Id = MILO_Receipt.ObjectId
                      LEFT JOIN ObjectString AS ObjectString_Receipt_Code
                                             ON ObjectString_Receipt_Code.ObjectId = Object_Receipt.Id
                                            AND ObjectString_Receipt_Code.DescId   = zc_ObjectString_Receipt_Code()
            
                      LEFT JOIN MovementItemLinkObject AS MILO_ReceiptBasis
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
       
     , tmpGoodsParam AS (SELECT tmp.GoodsId
                              , Object_TradeMark.ValueData      AS TradeMarkName
                              , Object_GoodsTag.ValueData       AS GoodsTagName
                              , Object_GoodsPlatform.ValueData  AS GoodsPlatformName
                              , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName
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
                        )
             
     -- выбираем данные по признаку товара ТОП из GoodsByGoodsKind
     , tmpTOP AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                       , Object_GoodsByGoodsKind_View.GoodsKindId
                  FROM ObjectBoolean
                       LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean.ObjectId
                  WHERE ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()
                    AND COALESCE (ObjectBoolean.ValueData, FALSE) = TRUE
                   )                               


     SELECT MovementItem.Id
          , MovementItem.ParentId
          , Object_Goods.Id          		AS GoodsId
          , Object_Goods.ObjectCode  		AS GoodsCode
          , Object_Goods.ValueData   		AS GoodsName
          , Object_GoodsKind.ValueData          AS GoodsKindName
          , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
          , Object_Measure.ValueData            AS MeasureName

          , SUM (COALESCE (MovementItem.Amount,0)) :: TFloat AS Amount

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

          , MovementItem.isErased  ::Boolean AS isErased

          , MovementItem.GroupNumber
          , MovementItem.InfoMoneyCode
          , MovementItem.InfoMoneyGroupName
          , MovementItem.InfoMoneyDestinationName
          , MovementItem.InfoMoneyName
          
          , CASE MovementItem.GroupNumber
                   WHEN 6 THEN 15993821 -- _colorRecord_GoodsPropertyId_Ice           - inGoodsId = zc_Goods_WorkIce()
                   WHEN 1 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                   WHEN 2 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                   WHEN 3 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                   WHEN 4 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                   WHEN 5 THEN 32896    -- _colorRecord_KindPackage_Composition_K_MB  -  zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 7 THEN 35980    -- _colorRecord_KindPackage_Composition_K     - zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 8 THEN 10965163 -- _colorRecord_KindPackage_Composition_Y     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                   ELSE 0 -- clBlack
            END :: Integer AS Color_calc

           , tmpGoodsParam.TradeMarkName         :: TVarChar
           , tmpGoodsParam.GoodsTagName          :: TVarChar
           , tmpGoodsParam.GoodsPlatformName     :: TVarChar
           , tmpGoodsParam.GoodsGroupAnalystName :: TVarChar
           , CASE WHEN tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END :: Boolean AS isTop

     FROM tmpData AS MovementItem
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

          LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                 ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId =  Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem.GoodsId_parent
          LEFT JOIN tmpTOP ON tmpTOP.GoodsId = MovementItem.GoodsId_parent
                          AND COALESCE (tmpTOP.GoodsKindId,0) = COALESCE (MovementItem.GoodsKindId_parent,0)

     GROUP BY MovementItem.Id
            , MovementItem.ParentId
            , Object_Goods.Id
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , Object_GoodsKind.ValueData
            , ObjectString_Goods_GoodsGroupFull.ValueData
            , Object_Measure.ValueData  
            , MovementItem.InfoMoneyCode
            , MovementItem.InfoMoneyGroupName
            , MovementItem.InfoMoneyDestinationName
            , MovementItem.InfoMoneyName
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
            , CASE MovementItem.GroupNumber
                   WHEN 6 THEN 15993821 -- _colorRecord_GoodsPropertyId_Ice           - inGoodsId = zc_Goods_WorkIce()
                   WHEN 1 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                   WHEN 2 THEN 14614528 -- _colorRecord_KindPackage_MaterialBasis     - inInfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                   WHEN 3 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                   WHEN 4 THEN 14614528 -- _colorRecord_KindPackage_PF                - inInfoMoneyDestinationId inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                   WHEN 5 THEN 32896    -- _colorRecord_KindPackage_Composition_K_MB  -  zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 7 THEN 35980    -- _colorRecord_KindPackage_Composition_K     - zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   WHEN 8 THEN 10965163 -- _colorRecord_KindPackage_Composition_Y     - inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                   ELSE 0 -- clBlack
              END
            , MovementItem.isErased 
            , MovementItem.GroupNumber
            , tmpGoodsParam.TradeMarkName
            , tmpGoodsParam.GoodsTagName
            , tmpGoodsParam.GoodsPlatformName
            , tmpGoodsParam.GoodsGroupAnalystName
            , CASE WHEN tmpTOP.GoodsId IS NULL THEN FALSE ELSE TRUE END

       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.21         *
 15.09.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderGoodsDetail_Child (inParentId := 21114328, inisErased:= FALSE, inSession:= '5')
-- select * from gpSelect_MI_OrderGoodsDetail_Child (inParentId := 20228197  , inShowAll := 'true'::Boolean , inIsErased := 'False'::Boolean , inSession := '378f6845-ef70-4e5b-aeb9-45d91bd5e82e');