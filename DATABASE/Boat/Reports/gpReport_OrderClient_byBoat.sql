-- Function: gpReport_OrderClient)

DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderClient_byBoat (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderClient_byBoat (
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inisDetail    Boolean   , -- развернуть по лодкам
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE  (MovementId Integer
              , InvNumber TVarChar
              , OperDate TDateTime
              
              , ProductId Integer
              , ProductName TVarChar
              , CIN              TVarChar
              
              , GoodsId Integer
              , GoodsCode Integer
              , GoodsName TVarChar
              , Article TVarChar
              , Article_all TVarChar
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar
              , ReceiptGoodsName TVarChar
              , ReceiptLevelName TVarChar
              , Amount     TFloat
              , Amount1    TFloat
              , Amount2    TFloat
              , Amount3    TFloat
              , Amount4    TFloat
              , Amount5    TFloat
              , Amount6    TFloat
              , Amount7    TFloat
              , Amount8    TFloat
              , Amount9    TFloat
              , Amount10   TFloat
              , Amount11   TFloat
              , Amount12   TFloat
)
AS
$BODY$
 DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Goods());
     vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY
    WITH
    --выбираем лодки по zc_ObjectDate_Product_DateBegin за период
    tmpProduct AS (SELECT ObjectDate.ObjectId AS Id 
                   FROM ObjectDate
                   WHERE ObjectDate.DescId = zc_ObjectDate_Product_DateBegin()
                     AND ObjectDate.ValueData >=inStartDate
                     AND ObjectDate.ValueData <=inEndDate
                   )

    --все заказы по выбранным лодкам
  , tmpMovement AS (SELECT Movement.Id
                         , Movement.OperDate
                         , Movement.InvNumber
                         , MovementLinkObject_Product.ObjectId AS ProductId
                    FROM Movement
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Product
                                                      ON MovementLinkObject_Product.MovementId = Movement.Id
                                                     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product() 
                                                     AND MovementLinkObject_Product.ObjectId IN (SELECT DISTINCT tmpProduct.Id FROM tmpProduct)
                    WHERE Movement.DescId = zc_Movement_OrderClient()
                      AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
    --
  , tmpMI_Detail AS (SELECT MovementItem.Id
                          , MovementItem.ObjectId    -- Комплектующие 
                          , MovementItem.Amount
                          , Movement.ProductId
                          , Movement.OperDate 
                          , Movement.InvNumber
                          , Movement.Id AS MovementId
                          -- только для zc_MI_Child
                          , COALESCE (MILinkObject_ReceiptGoods.ObjectId, 0) AS ReceiptGoodsId
                            -- только для zc_MI_Detail
                          , COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0) AS ReceiptLevelId
                     FROM tmpMovement AS Movement
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Detail()
                                                 AND MovementItem.isErased = FALSE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptGoods
                                                           ON MILinkObject_ReceiptGoods.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReceiptGoods.DescId         = zc_MILinkObject_ReceiptGoods()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                           ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                                                          
                     )

  , tmpMI_group AS (SELECT  CASE WHEN inisDetail = TRUE THEN tmp.ProductId ELSE 0 END AS ProductId
                          , CASE WHEN inisDetail = TRUE THEN tmp.MovementId ELSE 0 END AS MovementId
                          , CASE WHEN inisDetail = TRUE THEN tmp.InvNumber  ELSE '' END AS InvNumber
                          , CASE WHEN inisDetail = TRUE THEN tmp.OperDate  ELSE NULL END AS OperDate
                          , tmp.ObjectId  AS GoodsId  -- Комплектующие  
                          , tmp.ReceiptLevelId
                          , tmp.ReceiptGoodsId
                          , SUM (tmp.Amount) AS Amount
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 1 THEN tmp.Amount ELSE 0 END) AS Amount1
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 2 THEN tmp.Amount ELSE 0 END) AS Amount2
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 3 THEN tmp.Amount ELSE 0 END) AS Amount3
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 4 THEN tmp.Amount ELSE 0 END) AS Amount4
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 5 THEN tmp.Amount ELSE 0 END) AS Amount5
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 6 THEN tmp.Amount ELSE 0 END) AS Amount6
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 7 THEN tmp.Amount ELSE 0 END) AS Amount7
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 8 THEN tmp.Amount ELSE 0 END) AS Amount8
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 9 THEN tmp.Amount ELSE 0 END) AS Amount9
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 10 THEN tmp.Amount ELSE 0 END) AS Amount10
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 11 THEN tmp.Amount ELSE 0 END) AS Amount11
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.OperDate) = 12 THEN tmp.Amount ELSE 0 END) AS Amount12
                    FROM tmpMI_Detail AS tmp
                    GROUP BY CASE WHEN inisDetail = TRUE THEN tmp.ProductId ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.MovementId ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.InvNumber  ELSE '' END
                           , CASE WHEN inisDetail = TRUE THEN tmp.OperDate  ELSE NULL END
                           , tmp.ObjectId
                           , tmp.ReceiptLevelId
                           , tmp.ReceiptGoodsId
                    )

    -- Параметры - Комплектующие
  , tmpGoodsParams AS (SELECT tmpGoods.GoodsId
                            , Object_Goods.ObjectCode            AS GoodsCode
                            , Object_Goods.ValueData             AS GoodsName
                            , ObjectString_Article.ValueData     AS Article
                            , Object_GoodsGroup.Id               AS GoodsGroupId
                            , Object_GoodsGroup.ValueData        AS GoodsGroupName
                            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                            , Object_Measure.Id                  AS MeasureId
                            , Object_Measure.ValueData           AS MeasureName
                            , Object_GoodsTag.Id                 AS GoodsTagId
                            , Object_GoodsTag.ValueData          AS GoodsTagName
                            , Object_GoodsType.Id                AS GoodsTypeId
                            , Object_GoodsType.ValueData         AS GoodsTypeName
                            , Object_GoodsSize.Id                AS GoodsSizeId
                            , Object_GoodsSize.ValueData         AS GoodsSizeName
                            , Object_ProdColor.Id                AS ProdColorId
                            , Object_ProdColor.ValueData         AS ProdColorName
                            , Object_Engine.Id                   AS EngineId
                            , Object_Engine.ValueData            AS EngineName
                            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice  -- Цена вх. без НДС   
                       FROM (SELECT DISTINCT tmpMI_group.GoodsId FROM tmpMI_group) AS tmpGoods
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                           LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                           LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                           LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId 
                           
                          /* LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpGoods.GoodsId
                                               AND ObjectLink_ReceiptGoods_Object.DescId = zc_ObjectLink_ReceiptGoods_Object()
                           LEFT JOIN Object AS Object_ReceiptGoods
                                            ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods_Object.ObjectId
                                           AND Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                           AND Object_ReceiptGoods.isErased = FALSE
                          */
                       )


      -- Результат
      SELECT tmp.MovementId ::Integer
           , tmp.InvNumber  ::TVarChar
           , tmp.OperDate   ::TDateTime
           , Object_Product.Id                   AS ProductId
           , Object_Product.ValueData ::TVarChar AS ProductName
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) ::TVarChar AS CIN
           , tmp.GoodsId
           , tmpGoodsParams.GoodsCode
           , tmpGoodsParams.GoodsName  ::TVarChar
           , tmpGoodsParams.Article    ::TVarChar
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName        ::TVarChar
           , tmpGoodsParams.GoodsGroupNameFull    ::TVarChar
           , tmpGoodsParams.MeasureName           ::TVarChar
           , Object_ReceiptGoods.ValueData        ::TVarChar AS ReceiptGoodsName
           , Object_ReceiptLevel.ValueData        ::TVarChar AS ReceiptLevelName

           , tmp.Amount    :: TFloat
           , tmp.Amount1   :: TFloat
           , tmp.Amount2   :: TFloat
           , tmp.Amount3   :: TFloat
           , tmp.Amount4   :: TFloat
           , tmp.Amount5   :: TFloat
           , tmp.Amount6   :: TFloat
           , tmp.Amount7   :: TFloat
           , tmp.Amount8   :: TFloat
           , tmp.Amount9   :: TFloat
           , tmp.Amount10  :: TFloat
           , tmp.Amount11  :: TFloat
           , tmp.Amount12  :: TFloat
      FROM tmpMI_group AS tmp
           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.GoodsId = tmp.GoodsId

           LEFT JOIN Object AS Object_Product ON Object_Product.Id = tmp.ProductId
           LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = tmp.ReceiptGoodsId
           LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmp.ReceiptLevelId 

           LEFT JOIN ObjectString AS ObjectString_CIN
                                  ON ObjectString_CIN.ObjectId = Object_Product.Id
                                 AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.05.23         *
*/

-- тест
--      SELECT * FROM gpReport_OrderClient_byBoat(inStartDate := ('01.01.2020')::TDateTime , inEndDate := ('03.05.2023')::TDateTime , inisDetail := False ,inSession := '5');