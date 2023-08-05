-- Function: gpSelect_Object_Goods_ReceiptService()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Goods_ReceiptService (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods_ReceiptService (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_ReceiptService(
    IN inIsLimit_100 Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_all TVarChar
             , DescName TVarChar
             , Article TVarChar, Article_all TVarChar, ArticleVergl TVarChar, EAN TVarChar, ASIN TVarChar, MatchCode TVarChar
             , FeeNumber TVarChar, GoodsGroupNameFull TVarChar, Comment TVarChar
             , ModelName_calc TVarChar
             , PartnerDate TDateTime
             , isArc Boolean
             , AmountMin TFloat, AmountRefer TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , PartnerId Integer, PartnerName   TVarChar
             , UnitId Integer, UnitName TVarChar
             , DiscountPartnerId Integer, DiscountPartnerName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
               -- Узел (да/нет)
             , isReceiptGoods_group  Boolean
               -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
             , isReceiptGoods        Boolean
               -- Опция (да/нет) - Участвует в опциях
             , isProdOptions         Boolean
               --
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAccessKeyRight Boolean;
  DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - есть ли ограничения
     -- vbAccessKeyRight:= NOT zfCalc_AccessKey_GuideAll (vbUserId) AND EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Результат
     RETURN QUERY
       WITH tmpPriceBasis AS (SELECT tmp.GoodsId
                                   , tmp.ValuePrice
                              FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                       , inOperDate   := CURRENT_DATE) AS tmp
                              )
     -- если это узел
   , tmpReceiptGoods_group AS (-- узел в сборке
                               SELECT DISTINCT ObjectLink_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_ReceiptGoods
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId      = Object_ReceiptGoods.Id
                                                        AND ObjectLink_Goods.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                                        AND ObjectLink_Goods.ChildObjectId > 0
                               WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                 AND Object_ReceiptGoods.isErased = FALSE
                              UNION
                               -- в сборке узла - ПФ
                               SELECT DISTINCT ObjectLink_GoodsChild.ChildObjectId AS GoodsId
                               FROM Object AS Object_ReceiptGoodsChild
                                    INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                          ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                         AND ObjectLink_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                    INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId
                                                                            AND Object_ReceiptGoods.isErased = FALSE
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                          ON ObjectLink_GoodsChild.ObjectId      = Object_ReceiptGoodsChild.Id
                                                         AND ObjectLink_GoodsChild.DescId        = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                                                         AND ObjectLink_GoodsChild.ChildObjectId > 0
                               WHERE Object_ReceiptGoodsChild.DescId   = zc_Object_ReceiptGoodsChild()
                                 AND Object_ReceiptGoodsChild.isErased = FALSE
                              )
      -- если Товар участвует в сборке + Опции
    , tmpReceiptGoods_all AS (-- Сборка Модели
                              SELECT ObjectLink_ReceiptProdModelChild_Object.ChildObjectId AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , 0 AS GoodsId_child
                                   , FALSE AS isProdOptions
                              FROM Object AS Object_ReceiptProdModel
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptProdModel
                                                         ON ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ChildObjectId = Object_ReceiptProdModel.Id
                                                        AND ObjectLink_ReceiptProdModelChild_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                   INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModelChild_ReceiptProdModel.ObjectId
                                                                                    AND Object_ReceiptProdModelChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                         ON ObjectLink_ReceiptProdModelChild_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                        AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()



                              WHERE Object_ReceiptProdModel.DescId   = zc_Object_ReceiptProdModelChild()
                                AND Object_ReceiptProdModel.isErased = FALSE

                             UNION ALL
                              -- Сборка узлов
                              SELECT ObjectLink_ReceiptGoodsChild_Object.ChildObjectId     AS GoodsId_from
                                   , ObjectLink_ReceiptGoods_Object.ChildObjectId          AS GoodsId_to
                                   , ObjectLink_ReceiptGoodsChild_GoodsChild.ChildObjectId AS GoodsId_child
                                   , FALSE AS isProdOptions
                              FROM Object AS Object_ReceiptGoods
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                         ON ObjectLink_ReceiptGoods_Object.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                                         ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                   INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                                                AND Object_ReceiptGoodsChild.isErased = FALSE
                                   INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_Object
                                                         ON ObjectLink_ReceiptGoodsChild_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                        AND ObjectLink_ReceiptGoodsChild_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()

                                   LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_GoodsChild
                                                        ON ObjectLink_ReceiptGoodsChild_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                       AND ObjectLink_ReceiptGoodsChild_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                              WHERE Object_ReceiptGoods.DescId   = zc_Object_ReceiptGoods()
                                AND Object_ReceiptGoods.isErased = FALSE

                             UNION ALL
                              -- Опции
                              SELECT DISTINCT
                                     0 AS GoodsId_from
                                   , 0 AS GoodsId_to
                                   , ObjectLink_ProdOptions_Goods.ChildObjectId AS GoodsId_child
                                   , TRUE AS isProdOptions
                              FROM Object AS Object_ProdOptions
                                   INNER JOIN ObjectLink AS ObjectLink_ProdOptions_Goods
                                                         ON ObjectLink_ProdOptions_Goods.ObjectId = Object_ProdOptions.Id
                                                        AND ObjectLink_ProdOptions_Goods.DescId   = zc_ObjectLink_ProdOptions_Goods()

                              WHERE Object_ProdOptions.DescId   = zc_Object_ProdOptions()
                                AND Object_ProdOptions.isErased = FALSE
                             )
          -- если Товар участвует в сборке + Опции
        , tmpReceiptGoods AS (-- Сборка Модели
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_from AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_from > 0
                             UNION
                              -- Сборка узлов
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_to AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_to > 0
                             UNION
                              -- Опции
                              SELECT DISTINCT tmpReceiptGoods_all.GoodsId_child AS GoodsId
                              FROM tmpReceiptGoods_all
                              WHERE tmpReceiptGoods_all.GoodsId_child > 0
                             )
         , tmpGoods_limit AS (SELECT Object_Goods.*
                              FROM Object AS Object_Goods
                              WHERE Object_Goods.DescId = zc_Object_Goods()
                                AND Object_Goods.isErased = FALSE
                              ORDER BY CASE WHEN vbUserId = 5 AND 1=0 THEN Object_Goods.Id ELSE 0 END ASC, Object_Goods.Id DESC
                              LIMIT CASE WHEN inIsLimit_100 = TRUE THEN 100 WHEN vbUserId = 5 AND 1=0 THEN 25000 ELSE 350000 END
                             )
     , tmpGoods_all AS (SELECT tmpGoods_limit.*
                        FROM tmpGoods_limit
                       UNION
                        SELECT Object_Goods.*
                        FROM Object AS Object_Goods
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                          AND Object_Goods.Id IN (SELECT DISTINCT tmpReceiptGoods.GoodsId FROM tmpReceiptGoods)
                       UNION
                        SELECT Object_Goods.*
                        FROM Object AS Object_Goods
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                             INNER JOIN ObjectString AS ObjectString_Article
                                                     ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                    AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                                    AND (ObjectString_Article.ValueData ILIKE 'AGL%'
                                                      OR ObjectString_Article.ValueData ILIKE 'BEL%'
                                                      OR ObjectString_Article.ValueData ILIKE '%x-7%'
                                                      OR ObjectString_Article.ValueData ILIKE '%74976%'
                                                      --
                                                      OR Object_Goods.ObjectCode < 0
                                                      OR Object_GoodsGroup.ValueData ILIKE '%ПФ%'
                                                      --
                                                      OR Object_Goods.ValueData ILIKE '%ПФ%'
                                                      OR Object_Goods.ValueData ILIKE '%motor%'
                                                      OR Object_Goods.ValueData ILIKE '%RAL%'
                                                      OR Object_Goods.ValueData ILIKE '%ndige Inspektionsluke%'
                                                    --OR Object_Goods.ValueData ILIKE '%Bonding Paste%'
                                                      OR Object_Goods.ValueData ILIKE '%FA®-%'
                                                        )
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                          AND inIsLimit_100 = FALSE
                       )
            -- Комплектующие
          , tmpGoods AS (SELECT Object_Goods.Id                     AS Id
                              , Object_Goods.ObjectCode             AS Code
                              , Object_Goods.ValueData              AS Name
                              , CASE WHEN tmpReceiptGoods_group.GoodsId > 0 THEN 'Узел' ELSE ObjectDesc.ItemName END :: TVarChar AS DescName
                              , ObjectString_Article.ValueData      AS Article
                              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
                              , ObjectString_EAN.ValueData          AS EAN
                              , ObjectString_ASIN.ValueData         AS ASIN
                              , ObjectString_MatchCode.ValueData    AS MatchCode
                              , ObjectString_FeeNumber.ValueData    AS FeeNumber
                              , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                              , ObjectString_Comment.ValueData      AS Comment

                              , ObjectDate_PartnerDate.ValueData  :: TDateTime AS PartnerDate
                              , COALESCE (ObjectBoolean_Arc.ValueData, FALSE) :: Boolean AS isArc

                              , ObjectFloat_Min.ValueData          AS AmountMin
                              , ObjectFloat_Refer.ValueData        AS AmountRefer

                              , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
                              , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                                   * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

                              , ObjectFloat_EmpfPrice.ValueData ::TFloat   AS EmpfPrice
                              , CAST (COALESCE (ObjectFloat_EmpfPrice.ValueData, 0)
                                   * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100) ) AS NUMERIC (16, 2)) ::TFloat AS EmpfPriceWVAT-- расчет рекомендованной цены с НДС, до 4 знаков

                               -- расчет базовой цены без НДС, до 2 знаков
                             , CASE WHEN vbPriceWithVAT = FALSE
                                    THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                                    ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                               END ::TFloat  AS BasisPrice   -- сохраненная цена - цена без НДС

                               -- расчет базовой цены с НДС, до 2 знаков
                             , CASE WHEN vbPriceWithVAT = FALSE
                                    THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                                    ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
                               END ::TFloat  AS BasisPriceWVAT

                              , Object_GoodsGroup.Id               AS GoodsGroupId
                              , Object_GoodsGroup.ValueData        AS GoodsGroupName
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
                              , Object_Partner.Id                  AS PartnerId
                              , Object_Partner.ValueData           AS PartnerName
                              , Object_Unit.Id                     AS UnitId
                              , Object_Unit.ValueData              AS UnitName
                              , Object_DiscountPartner.Id           AS DiscountPartnerId
                              , Object_DiscountPartner.ValueData    AS DiscountPartnerName
                              , Object_TaxKind.Id                  AS TaxKindId
                              , Object_TaxKind.ValueData           AS TaxKindName
                              , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

                              , Object_InfoMoney_View.InfoMoneyCode
                              , Object_InfoMoney_View.InfoMoneyGroupName
                              , Object_InfoMoney_View.InfoMoneyDestinationName
                              , Object_InfoMoney_View.InfoMoneyName
                              , Object_InfoMoney_View.InfoMoneyId

                              , Object_Goods.isErased              AS isErased

                         FROM tmpGoods_all AS Object_Goods
                              LEFT JOIN ObjectString AS ObjectString_Comment
                                                     ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                                    AND ObjectString_Comment.DescId = zc_ObjectString_Goods_Comment()

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                    ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                               LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                    ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                               LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                    ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                               LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                    ON ObjectLink_Goods_GoodsType.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                               LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                    ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                               LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                    ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                               LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                                    ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                                    ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_Unit.DescId = zc_ObjectLink_Goods_Unit()
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Goods_Unit.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                    ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                               LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_DiscountPartner
                                                    ON ObjectLink_Goods_DiscountPartner.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_DiscountPartner.DescId = zc_ObjectLink_Goods_DiscountPartner()
                               LEFT JOIN Object AS Object_DiscountPartner ON Object_DiscountPartner.Id = ObjectLink_Goods_DiscountPartner.ChildObjectId

                               LEFT JOIN ObjectLink AS ObjectLink_Goods_TaxKind
                                                    ON ObjectLink_Goods_TaxKind.ObjectId = Object_Goods.Id
                                                   AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                               LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = ObjectLink_Goods_TaxKind.ChildObjectId

                               LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                                     ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                                    AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

                               LEFT JOIN ObjectDate AS ObjectDate_PartnerDate
                                                    ON ObjectDate_PartnerDate.ObjectId = Object_Goods.Id
                                                   AND ObjectDate_PartnerDate.DescId = zc_ObjectDate_Goods_PartnerDate()

                               LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                                     ON ObjectFloat_Min.ObjectId = Object_Goods.Id
                                                    AND ObjectFloat_Min.DescId   = zc_ObjectFloat_Goods_Min()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Refer
                                                     ON ObjectFloat_Refer.ObjectId = Object_Goods.Id
                                                    AND ObjectFloat_Refer.DescId   = zc_ObjectFloat_Goods_Refer()
                               LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                     ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                                    AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()
                               LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                     ON ObjectFloat_EmpfPrice.ObjectId = Object_Goods.Id
                                                    AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                               LEFT JOIN ObjectBoolean AS ObjectBoolean_Arc
                                                       ON ObjectBoolean_Arc.ObjectId = Object_Goods.Id
                                                      AND ObjectBoolean_Arc.DescId = zc_ObjectBoolean_Goods_Arc()

                               LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                      ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                                     AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                               LEFT JOIN ObjectString AS ObjectString_FeeNumber
                                                      ON ObjectString_FeeNumber.ObjectId = Object_Goods.Id
                                                     AND ObjectString_FeeNumber.DescId = zc_ObjectString_Goods_FeeNumber()

                               LEFT JOIN ObjectString AS ObjectString_Article
                                                      ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                     AND ObjectString_Article.DescId = zc_ObjectString_Article()
                               LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                                      ON ObjectString_ArticleVergl.ObjectId = Object_Goods.Id
                                                     AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()
                               LEFT JOIN ObjectString AS ObjectString_EAN
                                                      ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                                     AND ObjectString_EAN.DescId = zc_ObjectString_EAN()
                               LEFT JOIN ObjectString AS ObjectString_ASIN
                                                      ON ObjectString_ASIN.ObjectId = Object_Goods.Id
                                                     AND ObjectString_ASIN.DescId = zc_ObjectString_ASIN()
                               LEFT JOIN ObjectString AS ObjectString_MatchCode
                                                      ON ObjectString_MatchCode.ObjectId = Object_Goods.Id
                                                     AND ObjectString_MatchCode.DescId = zc_ObjectString_MatchCode()

                               LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

                               LEFT JOIN tmpReceiptGoods_group ON tmpReceiptGoods_group.GoodsId = Object_Goods.Id

                               LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Goods.DescId
                        )
       -- Результат
       -- Комплектующие
       SELECT tmpGoods.Id
            , tmpGoods.Code
            , SUBSTRING (tmpGoods.Name, 1, 128) :: TVarChar AS Name
            , zfCalc_GoodsName_all (tmpGoods.Article, SUBSTRING (tmpGoods.Name, 1, 128)) AS Name_all
            , tmpGoods.DescName
            , tmpGoods.Article
            , zfCalc_Article_all (COALESCE (tmpGoods.Article, '') || '_' || COALESCE (tmpGoods.ArticleVergl, '')) ::TVarChar AS Article_all
            , tmpGoods.ArticleVergl
            , tmpGoods.EAN
            , tmpGoods.ASIN
            , tmpGoods.MatchCode
            , tmpGoods.FeeNumber
            , tmpGoods.GoodsGroupNameFull
            , SUBSTRING (tmpGoods.Comment, 1, 128) :: TVarChar AS Comment

            , CASE WHEN tmpGoods.Comment ILIKE '%Hypalon%'
                     OR tmpGoods.Comment ILIKE '%HULL%'
                     OR tmpGoods.Comment ILIKE '%DECK%'
                     OR tmpGoods.Comment ILIKE '%STEERING CONSOLE%'
                     OR tmpGoods.Comment ILIKE '%Kreslo%'
                     OR tmpGoods.Comment ILIKE '%Teak%'
                   THEN CASE SPLIT_PART (SPLIT_PART (tmpGoods.Article, 'AGL-', 2), '-', 1)
                             WHEN '305' THEN '305C'
                             WHEN '330' THEN '330C'
                             WHEN '355' THEN '355C'
                             WHEN '360' THEN '360D'
                             ELSE SPLIT_PART (SPLIT_PART (tmpGoods.Article, 'AGL-', 2), '-', 1)
                        END
                   ELSE ''
              END :: TVarChar AS ModelName_calc

            , tmpGoods.PartnerDate
            , tmpGoods.isArc

            , tmpGoods.AmountMin
            , tmpGoods.AmountRefer

            , tmpGoods.EKPrice
            , tmpGoods.EKPriceWVAT-- расчет входной цены с НДС, до 4 знаков

            , tmpGoods.EmpfPrice
            , tmpGoods.EmpfPriceWVAT-- расчет рекомендованной цены с НДС, до 4 знаков

              -- расчет базовой цены без НДС, до 2 знаков
            , tmpGoods.BasisPrice   -- сохраненная цена - цена без НДС

              -- расчет базовой цены с НДС, до 2 знаков
            , tmpGoods.BasisPriceWVAT

            , tmpGoods.GoodsGroupId
            , tmpGoods.GoodsGroupName
            , tmpGoods.MeasureId
            , tmpGoods.MeasureName
            , tmpGoods.GoodsTagId
            , tmpGoods.GoodsTagName
            , tmpGoods.GoodsTypeId
            , tmpGoods.GoodsTypeName
            , tmpGoods.GoodsSizeId
            , tmpGoods.GoodsSizeName
            , tmpGoods.ProdColorId
            , tmpGoods.ProdColorName
            , tmpGoods.PartnerId
            , tmpGoods.PartnerName
            , tmpGoods.UnitId
            , tmpGoods.UnitName
            , tmpGoods.DiscountPartnerId
            , tmpGoods.DiscountPartnerName
            , tmpGoods.TaxKindId
            , tmpGoods.TaxKindName
            , tmpGoods.TaxKind_Value

            , tmpGoods.InfoMoneyCode
            , tmpGoods.InfoMoneyGroupName
            , tmpGoods.InfoMoneyDestinationName
            , tmpGoods.InfoMoneyName
            , tmpGoods.InfoMoneyId

              -- Узел (да/нет)
            , CASE WHEN tmpReceiptGoods_group.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods_group
              -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
            , CASE WHEN tmpReceiptGoods.GoodsId > 0       THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
              -- Опция (да/нет) - Участвует в опциях
            , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)                  :: Boolean AS isProdOptions
              --
            , tmpGoods.isErased

       FROM tmpGoods
             -- если Товар участвует в сборке + Опции
             LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpGoods.Id
             -- если Опции
             LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = tmpGoods.Id
                                          AND tmpReceiptGoods_all.isProdOptions = TRUE
             -- если это узел
             LEFT JOIN tmpReceiptGoods_group ON tmpReceiptGoods_group.GoodsId = tmpGoods.Id

      UNION
              -- Работы/Услуги
       SELECT Object_ReceiptService.Id               AS Id
            , Object_ReceiptService.ObjectCode       AS Code
            , Object_ReceiptService.ValueData        AS Name
            , zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_ReceiptService.ValueData) AS Name_all
            , ObjectDesc.ItemName                    AS DescName
            , ObjectString_Article.ValueData         AS Article
            , ObjectString_Article.ValueData         AS Article_all

            , '' ::TVarChar AS ArticleVergl
            , '' ::TVarChar         AS EAN
            , '' ::TVarChar         AS ASIN
            , '' ::TVarChar    AS MatchCode
            , '' ::TVarChar    AS FeeNumber
            , '' ::TVarChar AS GoodsGroupNameFull

            , COALESCE (ObjectString_Comment.ValueData, NULL) :: TVarChar AS Comment
            , '' :: TVarChar AS ModelName_calc

            , NULL  :: TDateTime AS PartnerDate
            , FALSE :: Boolean   AS isArc

            , 0 ::TFloat    AS AmountMin
            , 0 ::TFloat    AS AmountRefer
            , 0 ::TFloat    AS EKPrice
            , 0 ::TFloat    AS EKPriceWVAT
            , 0 ::TFloat    AS EmpfPrice
            , 0 ::TFloat    AS EmpfPriceWVAT
            , 0 ::TFloat    AS BasisPrice
            , 0 ::TFloat    AS BasisPriceWVAT

            , 0  ::Integer  AS GoodsGroupId
            , '' ::TVarChar AS GoodsGroupName
            , 0  ::Integer  AS MeasureId
            , '' ::TVarChar AS MeasureName
            , 0  ::Integer  AS GoodsTagId
            , '' ::TVarChar AS GoodsTagName
            , 0  ::Integer  AS GoodsTypeId
            , '' ::TVarChar AS GoodsTypeName
            , 0  ::Integer  AS GoodsSizeId
            , '' ::TVarChar AS GoodsSizeName
            , 0  ::Integer  AS ProdColorId
            , '' ::TVarChar AS ProdColorName
            , 0  ::Integer  AS PartnerId
            , '' ::TVarChar AS PartnerName
            , 0  ::Integer  AS UnitId
            , '' ::TVarChar AS UnitName
            , 0  ::Integer  AS DiscountPartnerId
            , '' ::TVarChar AS DiscountPartnerName
            , 0  ::Integer  AS TaxKindId
            , '' ::TVarChar AS TaxKindName
            , 0  ::TFloat   AS TaxKind_Value

            , 0  ::Integer  AS InfoMoneyCode
            , '' ::TVarChar AS InfoMoneyGroupName
            , '' ::TVarChar AS InfoMoneyDestinationName
            , '' ::TVarChar AS InfoMoneyName
            , 0  ::Integer  AS InfoMoneyId

            , FALSE :: Boolean AS isReceiptGoods_group
            , FALSE :: Boolean AS isReceiptGoods
            , FALSE :: Boolean AS isProdOptions

            , Object_ReceiptService.isErased         AS isErased

       FROM Object AS Object_ReceiptService
           LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_ReceiptService.DescId

           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptService_Comment()

           LEFT JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

       WHERE Object_ReceiptService.DescId = zc_Object_ReceiptService()
         AND Object_ReceiptService.isErased = FALSE
      UNION
              -- Удалить
       SELECT 0                     AS Id
            , 0                     AS Code
            , 'УДАЛИТЬ' ::TVarChar  AS Name
            , '' ::TVarChar         AS Name_all
            , '' ::TVarChar         AS DescName
            , '' ::TVarChar         AS Article
            , '' ::TVarChar         AS Article_all

            , '' ::TVarChar    AS ArticleVergl
            , '' ::TVarChar    AS EAN
            , '' ::TVarChar    AS ASIN
            , '' ::TVarChar    AS MatchCode
            , '' ::TVarChar    AS FeeNumber
            , '' ::TVarChar    AS GoodsGroupNameFull

            , '' ::TVarChar    AS Comment
            , '' :: TVarChar   AS ModelName_calc

            , NULL  :: TDateTime AS PartnerDate
            , FALSE :: Boolean   AS isArc

            , 0 ::TFloat    AS AmountMin
            , 0 ::TFloat    AS AmountRefer
            , 0 ::TFloat    AS EKPrice
            , 0 ::TFloat    AS EKPriceWVAT
            , 0 ::TFloat    AS EmpfPrice
            , 0 ::TFloat    AS EmpfPriceWVAT
            , 0 ::TFloat    AS BasisPrice
            , 0 ::TFloat    AS BasisPriceWVAT

            , 0  ::Integer  AS GoodsGroupId
            , '' ::TVarChar AS GoodsGroupName
            , 0  ::Integer  AS MeasureId
            , '' ::TVarChar AS MeasureName
            , 0  ::Integer  AS GoodsTagId
            , '' ::TVarChar AS GoodsTagName
            , 0  ::Integer  AS GoodsTypeId
            , '' ::TVarChar AS GoodsTypeName
            , 0  ::Integer  AS GoodsSizeId
            , '' ::TVarChar AS GoodsSizeName
            , 0  ::Integer  AS ProdColorId
            , '' ::TVarChar AS ProdColorName
            , 0  ::Integer  AS PartnerId
            , '' ::TVarChar AS PartnerName
            , 0  ::Integer  AS UnitId
            , '' ::TVarChar AS UnitName
            , 0  ::Integer  AS DiscountPartnerId
            , '' ::TVarChar AS DiscountPartnerName
            , 0  ::Integer  AS TaxKindId
            , '' ::TVarChar AS TaxKindName
            , 0  ::TFloat   AS TaxKind_Value

            , 0  ::Integer  AS InfoMoneyCode
            , '' ::TVarChar AS InfoMoneyGroupName
            , '' ::TVarChar AS InfoMoneyDestinationName
            , '' ::TVarChar AS InfoMoneyName
            , 0  ::Integer  AS InfoMoneyId

            , FALSE :: Boolean AS isReceiptGoods_group
            , FALSE :: Boolean AS isReceiptGoods
            , FALSE :: Boolean AS isProdOptions

            , FALSE         AS isErased
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods_ReceiptService (inIsLimit_100:= TRUE, inSession := zfCalc_UserAdmin())
