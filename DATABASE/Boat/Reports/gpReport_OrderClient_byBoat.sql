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
              
              , ObjectId Integer
              , ObjectCode Integer
              , ObjectName TVarChar
              , Article TVarChar
              , Article_all TVarChar
              , GoodsGroupName TVarChar
              , GoodsGroupNameFull TVarChar
              , MeasureName TVarChar 
              , ProdColorName TVarChar
              , GoodsName_basis TVarChar
              , GoodsName TVarChar
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
    tmpProduct AS (SELECT DISTINCT ObjectDate.ObjectId AS Id
                        , ObjectDate.ValueData AS DateBegin 
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
                         , tmpProduct.DateBegin
                    FROM tmpProduct
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Product
                                                      ON MovementLinkObject_Product.ObjectId = tmpProduct.Id
                                                     AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product() 
                        INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                           AND Movement.DescId = zc_Movement_OrderClient()
                                           AND Movement.StatusId = zc_Enum_Status_Complete()
                    )
    --
  , tmpMI_Detail AS (SELECT Movement.ProductId
                          , Movement.DateBegin
                          , Movement.OperDate 
                          , Movement.InvNumber
                          , Movement.Id AS MovementId
                          -- Поставщик
                          , MILinkObject_Partner.ObjectId             AS PartnerId

                            -- какой узел собирается = zc_MI_Child.ObjectId, всегда заполнен
                          , COALESCE (MILinkObject_Goods.ObjectId, 0)       AS GoodsId
                          , COALESCE (MILinkObject_Goods_basis.ObjectId, 0) AS GoodsId_basis
                            -- Комплектующие / Работы/Услуги
                          , MovementItem.ObjectId                     AS ObjectId
                            --  Опция
                          , MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
                            -- Шаблон Boat Structure
                          , MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
                            --  Boat Structure
                          , MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId
                            --
                          , MILinkObject_ReceiptLevel.ObjectId        AS ReceiptLevelId
                            -- Количество для сборки Узла
                          , zfCalc_Value_ForCount (MovementItem.Amount, MIFloat_ForCount.ValueData) AS Amount
                            -- Количество заказ поставщику
                          , MIFloat_AmountPartner.ValueData           AS AmountPartner
                     FROM tmpMovement AS Movement
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Detail()
                                                 AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                           ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                           ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                           ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                           ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                           ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                           ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                           ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                          LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                      ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                     AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                          LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                      ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                     AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

                       )

     -- Комплектующие сборка узла
   , tmpItem_Detail AS (-- уровень 1 - собираем только "виртуальные" узлы
                        SELECT tmpItem_Detail.GoodsId_basis AS GoodsId
                             , tmpItem_Detail.ObjectId
                             , tmpItem_Detail.PartnerId
                             , tmpItem_Detail.Amount
                             , tmpItem_Detail.AmountPartner
                             , tmpItem_Detail.GoodsId_basis
                             , tmpItem_Detail.ReceiptLevelId
                             , tmpItem_Detail.ProdColorPatternId
                             , tmpItem_Detail.ProductId
                             , tmpItem_Detail.MovementId
                             , tmpItem_Detail.InvNumber
                             , tmpItem_Detail.OperDate
                             , tmpItem_Detail.DateBegin
                        FROM tmpMI_Detail AS tmpItem_Detail
                        WHERE tmpItem_Detail.GoodsId_basis > 0
                       UNION ALL
                        -- уровень 2 - собираем узлы и подставляем "виртуальные" узлы
                        SELECT DISTINCT
                               tmpItem_Detail.GoodsId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN tmpItem_Detail.GoodsId_basis ELSE tmpItem_Detail.ObjectId END AS ObjectId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.PartnerId     END AS PartnerId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 1 ELSE tmpItem_Detail.Amount        END AS Amount
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.AmountPartner END AS AmountPartner
                             , 0 AS GoodsId_basis
                             , 0 AS ReceiptLevelId
                             , CASE WHEN tmpItem_Detail.GoodsId_basis > 0 THEN 0 ELSE tmpItem_Detail.ProdColorPatternId END AS ProdColorPatternId
                             , tmpItem_Detail.ProductId
                             , tmpItem_Detail.MovementId
                             , tmpItem_Detail.InvNumber
                             , tmpItem_Detail.OperDate
                             , tmpItem_Detail.DateBegin
                        FROM tmpMI_Detail AS tmpItem_Detail
                       )


  , tmpMI_group AS (SELECT  CASE WHEN inisDetail = TRUE THEN tmp.ProductId  ELSE 0    END AS ProductId
                          , CASE WHEN inisDetail = TRUE THEN tmp.MovementId ELSE 0    END AS MovementId
                          , CASE WHEN inisDetail = TRUE THEN tmp.InvNumber  ELSE ''   END AS InvNumber
                          , CASE WHEN inisDetail = TRUE THEN tmp.OperDate   ELSE NULL END AS OperDate
                          , tmp.ObjectId -- Комплектующие 
                          , CASE WHEN inisDetail = TRUE THEN tmp.GoodsId_basis ELSE 0 END AS GoodsId_basis
                          , CASE WHEN inisDetail = TRUE THEN tmp.GoodsId ELSE 0 END AS GoodsId
                          , CASE WHEN inisDetail = TRUE THEN tmp.ReceiptLevelId ELSE 0 END AS ReceiptLevelId
                          , SUM (tmp.Amount) AS Amount
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 1 THEN tmp.Amount ELSE 0 END) AS Amount1
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 2 THEN tmp.Amount ELSE 0 END) AS Amount2
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 3 THEN tmp.Amount ELSE 0 END) AS Amount3
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 4 THEN tmp.Amount ELSE 0 END) AS Amount4
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 5 THEN tmp.Amount ELSE 0 END) AS Amount5
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 6 THEN tmp.Amount ELSE 0 END) AS Amount6
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 7 THEN tmp.Amount ELSE 0 END) AS Amount7
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 8 THEN tmp.Amount ELSE 0 END) AS Amount8
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 9 THEN tmp.Amount ELSE 0 END) AS Amount9
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 10 THEN tmp.Amount ELSE 0 END) AS Amount10
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 11 THEN tmp.Amount ELSE 0 END) AS Amount11
                          , SUM (CASE WHEN EXTRACT (MONTH FROM tmp.DateBegin) = 12 THEN tmp.Amount ELSE 0 END) AS Amount12
                    FROM tmpItem_Detail AS tmp
                    GROUP BY CASE WHEN inisDetail = TRUE THEN tmp.ProductId ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.MovementId ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.InvNumber  ELSE '' END
                           , CASE WHEN inisDetail = TRUE THEN tmp.OperDate  ELSE NULL END
                           , tmp.ObjectId
                           , CASE WHEN inisDetail = TRUE THEN tmp.ReceiptLevelId ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.GoodsId_basis ELSE 0 END
                           , CASE WHEN inisDetail = TRUE THEN tmp.GoodsId ELSE 0 END
                    )

    -- Параметры - Комплектующие
  , tmpGoodsParams AS (SELECT tmpGoods.ObjectId
                            , Object_Goods.ObjectCode            AS ObjectCode
                            , Object_Goods.ValueData             AS ObjectName
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
                       FROM (SELECT DISTINCT tmpMI_group.ObjectId FROM tmpMI_group) AS tmpGoods
                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.ObjectId
                           LEFT JOIN ObjectString AS ObjectString_Article
                                                  ON ObjectString_Article.ObjectId = tmpGoods.ObjectId
                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                           LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                  ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.ObjectId
                                                 AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                           LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                           LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                 ON ObjectFloat_EKPrice.ObjectId = tmpGoods.ObjectId
                                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                ON ObjectLink_Goods_TaxKind.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                 ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId
                                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                           LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                           LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                           LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                           LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                           LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                                ON ObjectLink_Goods_Engine.ObjectId = tmpGoods.ObjectId
                                               AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
                           LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId 
                      )


      -- Результат
      SELECT tmp.MovementId ::Integer
           , tmp.InvNumber  ::TVarChar
           , tmp.OperDate   ::TDateTime
           , Object_Product.Id                   AS ProductId
           , Object_Product.ValueData ::TVarChar AS ProductName
           , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData, Object_Product.isErased) ::TVarChar AS CIN
           , tmp.ObjectId
           , tmpGoodsParams.ObjectCode
           , tmpGoodsParams.ObjectName  ::TVarChar
           , tmpGoodsParams.Article     ::TVarChar
           , zfCalc_Article_all (tmpGoodsParams.Article) ::TVarChar AS Article_all
           , tmpGoodsParams.GoodsGroupName        ::TVarChar
           , tmpGoodsParams.GoodsGroupNameFull    ::TVarChar
           , tmpGoodsParams.MeasureName           ::TVarChar
           , tmpGoodsParams.ProdColorName         ::TVarChar

           , Object_Goods_basis.ValueData         ::TVarChar AS GoodsName_basis
           , Object_Goods.ValueData               ::TVarChar AS GoodsName
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
           LEFT JOIN tmpGoodsParams ON tmpGoodsParams.ObjectId = tmp.ObjectId

           LEFT JOIN Object AS Object_Product ON Object_Product.Id = tmp.ProductId
           LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = tmp.GoodsId_basis
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
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