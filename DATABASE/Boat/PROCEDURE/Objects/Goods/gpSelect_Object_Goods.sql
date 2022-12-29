-- Function: gpSelect_Object_Goods()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Goods (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Goods (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inShowAll     Boolean,
    IN inIsLimit_100 Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar, Article_all TVarChar, ArticleVergl TVarChar, GoodsArticle TVarChar
             , EAN TVarChar, ASIN TVarChar, MatchCode TVarChar
             , FeeNumber TVarChar, GoodsGroupNameFull TVarChar, Comment TVarChar
             , PartnerDate TDateTime
             , isReceiptGoods Boolean
             , isArc Boolean
             , Feet TFloat, Metres TFloat
             , AmountMin TFloat, AmountRefer TFloat
             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar, Color_Value Integer
             , PartnerId Integer, PartnerName   TVarChar
             , UnitId Integer, UnitName TVarChar, UnitName_receipt TVarChar, GoodsName_receipt TVarChar
             , DiscountPartnerId Integer, DiscountPartnerName TVarChar
             , TaxKindId Integer, TaxKindName TVarChar, TaxKind_Value TFloat
             , EngineId Integer, EngineName TVarChar
             , InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyId Integer
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , isDoc Boolean, isPhoto Boolean
             , InvNumber_pl TVarChar
             , Comment_pl TVarChar
             , myCount_pl Integer
             , Len_1 Integer, Len_2 Integer, Len_3 Integer, Len_4 Integer, Len_5 Integer, Len_6 Integer, Len_7 Integer, Len_8 Integer, Len_9 Integer, Len_10 Integer
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPriceWithVAT Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Результат
     RETURN QUERY
       WITH tmpMovementPL_all AS (SELECT Movement.Id
                                       , Movement.InvNumber       AS InvNumber
                                       , MovementString.ValueData AS Comment
                                       , MovementItem.ObjectId    AS GoodsId
                                  FROM Movement
                                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                              AND MovementItem.DescId    = zc_MI_Master()
                                       LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id
                                                               AND MovementString.DescId     = zc_MovementString_Comment()
                                  WHERE Movement.OperDate BETWEEN '01.01.2022' AND CURRENT_DATE
                                    AND Movement.DescId   = zc_Movement_PriceList()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                  --AND vbUserId NOT IN (5, 236658)
                                  --AND vbUserId NOT IN (236658)
                                    AND inIsLimit_100 = FALSE

                                  ORDER BY MovementItem.ObjectId, Movement.Id
                                 )
          , tmpMovementPL AS (SELECT STRING_AGG (tmpMovementPL_all.InvNumber, ';')    AS InvNumber
                                   , STRING_AGG (tmpMovementPL_all.Comment, ';') AS Comment
                                   , tmpMovementPL_all.GoodsId
                              FROM (SELECT DISTINCT tmpMovementPL_all.InvNumber, tmpMovementPL_all.Comment, tmpMovementPL_all.GoodsId, tmpMovementPL_all.Id FROM tmpMovementPL_all ORDER BY tmpMovementPL_all.GoodsId, tmpMovementPL_all.Id
                                   ) AS tmpMovementPL_all
                              GROUP BY tmpMovementPL_all.GoodsId
                             )
          , tmpPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS GoodsId
                              , Object_GoodsPhoto.Id                      AS PhotoId
                              , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                         FROM Object AS Object_GoodsPhoto
                                JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                                ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                               AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                          WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                            AND Object_GoodsPhoto.isErased = FALSE
                        )
           , tmpDoc AS (SELECT DISTINCT ObjectLink_GoodsDocument_Goods.ChildObjectId AS GoodsId
                         FROM Object AS Object_GoodsDocument
                                JOIN ObjectLink AS ObjectLink_GoodsDocument_Goods
                                                ON ObjectLink_GoodsDocument_Goods.ObjectId = Object_GoodsDocument.Id
                                               AND ObjectLink_GoodsDocument_Goods.DescId   = zc_ObjectLink_GoodsDocument_Goods()
                          WHERE Object_GoodsDocument.DescId   = zc_Object_GoodsDocument()
                            AND Object_GoodsDocument.isErased = FALSE
                       )
           , tmpPriceBasis AS (SELECT tmp.GoodsId
                                    , tmp.ValuePrice
                               FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                        , inOperDate   := CURRENT_DATE) AS tmp
                              )

           , tmpGoodsArticle AS (SELECT ObjectLink_GoodsArticle_Goods.ChildObjectId    AS GoodsId
                                      , STRING_AGG (Object.ValueData, '; ') ::TVarChar AS GoodsArticle
                                 FROM Object
                                      INNER JOIN ObjectLink AS ObjectLink_GoodsArticle_Goods
                                                            ON ObjectLink_GoodsArticle_Goods.ObjectId = Object.Id
                                                           AND ObjectLink_GoodsArticle_Goods.DescId   = zc_ObjectLink_GoodsArticle_Goods()
                                 WHERE Object.DescId = zc_Object_GoodsArticle()
                                   AND Object.isErased = FALSE
                                 GROUP BY ObjectLink_GoodsArticle_Goods.ChildObjectId
                                 )
           , tmpGoods_err_1 AS (SELECT LOWER (ObjectString_Article.ValueData) AS Article
                                FROM Object AS Object_Goods
                                     JOIN ObjectString AS ObjectString_Article
                                                       ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                      AND ObjectString_Article.DescId   = zc_ObjectString_Article()
                                                      AND ObjectString_Article.ValueData <> ''
                                WHERE Object_Goods.DescId   = zc_Object_Goods()
                                  AND Object_Goods.isErased = FALSE
                                GROUP BY LOWER (ObjectString_Article.ValueData)
                                HAVING COUNT (*) > 1
                               )
           , tmpGoods_err_2 AS (SELECT Object_Goods.ObjectCode AS GoodsCode
                                FROM Object AS Object_Goods
                                WHERE Object_Goods.DescId     = zc_Object_Goods()
                                  AND Object_Goods.ObjectCode <> 0
                                --AND Object_Goods.isErased = FALSE
                                --AND 1=0
                                GROUP BY Object_Goods.ObjectCode
                                HAVING COUNT (*) > 1
                               )
           , tmpGoods_err_3 AS (SELECT ObjectString_EAN.ValueData AS EAN
                                FROM Object AS Object_Goods
                                     JOIN ObjectString AS ObjectString_EAN
                                                       ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                                      AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
                                                      AND ObjectString_EAN.ValueData <> ''
                                WHERE Object_Goods.DescId   = zc_Object_Goods()
                                  AND Object_Goods.isErased = FALSE
                                --AND 1=0
                                GROUP BY ObjectString_EAN.ValueData
                                HAVING COUNT (*) > 1
                               )
         , tmpReceiptGoods AS (SELECT DISTINCT ObjectLink_Goods.ChildObjectId AS GoodsId
                               FROM Object AS Object_ReceiptGoods
                                    LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                         ON ObjectLink_Goods.ObjectId = Object_ReceiptGoods.Id
                                                        AND ObjectLink_Goods.DescId = zc_ObjectLink_ReceiptGoods_Object()
                               WHERE Object_ReceiptGoods.DescId = zc_Object_ReceiptGoods()
                                 AND Object_ReceiptGoods.isErased = FALSE
                              )
         , tmpGoods_limit AS (SELECT Object_Goods.*
                              FROM Object AS Object_Goods
                              WHERE Object_Goods.DescId = zc_Object_Goods()
                              --AND Object_Goods.ObjectCode < 0
                              --AND (Object_Goods.isErased = FALSE OR inShowAll = TRUE)
                            --ORDER BY Object_Goods.Id ASC
                              ORDER BY CASE WHEN vbUserId = 5 THEN Object_Goods.Id ELSE 0 END ASC, Object_Goods.Id DESC
                              LIMIT CASE WHEN inIsLimit_100 = TRUE THEN 100 WHEN vbUserId = 5 AND 1=1 THEN 20000 ELSE 350000 END
                             )
         , tmpGoods AS (SELECT tmpGoods_limit.*
                        FROM tmpGoods_limit
                       UNION
                        SELECT Object_Goods.*
                        FROM Object AS Object_Goods
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                          AND Object_Goods.Id IN (SELECT DISTINCT tmpReceiptGoods.GoodsId FROM tmpReceiptGoods)
                          AND Object_Goods.ObjectCode < 0
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
                                                      OR Object_Goods.ObjectCode < 0
                                                      OR Object_Goods.ValueData ILIKE '%ПФ%'
                                                      OR Object_Goods.ValueData ILIKE '%motor%'
                                                      OR Object_GoodsGroup.ValueData ILIKE '%ПФ%'
                                                      OR Object_Goods.ValueData ILIKE '%ndige Inspektionsluke%'
                                                    --OR Object_Goods.ValueData ILIKE '%Bonding Paste%'
                                                      OR Object_Goods.ValueData ILIKE '%FA®-%'
                                                        )
                                                  --AND Object_Goods.ObjectCode < 0
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                        --AND inIsLimit_100 = TRUE
                       UNION
                        SELECT DISTINCT Object_Goods.*
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail(), zc_MI_Reserv())
                             INNER JOIN Object AS Object_Goods
                                               ON Object_Goods.Id     = MovementItem.ObjectId
                                              AND Object_Goods.DescId = zc_Object_Goods()
                        WHERE Movement.DescId = zc_Movement_OrderClient()
                          AND vbUserId = 5
                        --AND inIsLimit_100 = TRUE
                       )

      , tmpReceipt AS (-- сборка узлов
                       SELECT DISTINCT
                              tmpGoods.Id AS GoodsId
                            , ObjectLink_Unit.ChildObjectId AS UnitId
                              -- какой узел собирается
                            , ObjectLink_ReceiptGoods_Object.ChildObjectId AS ObjectId_master
                       FROM tmpGoods
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ChildObjectId = tmpGoods.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                 ON ObjectLink_GoodsChild.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                            INNER JOIN Object AS ObjectReceiptChild ON ObjectReceiptChild.Id       = ObjectLink_Object.ObjectId
                                                                   AND ObjectReceiptChild.isErased = FALSE

                            INNER JOIN Object AS ObjectReceipt ON ObjectReceipt.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                              AND ObjectReceipt.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = ObjectReceipt.Id
                                                AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptGoods_Unit()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                 ON ObjectLink_ReceiptGoods_Object.ObjectId = ObjectReceipt.Id
                                                AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                       -- это НЕ виртуальная сборка
                       WHERE ObjectLink_GoodsChild.ChildObjectId IS NULL

                     UNION
                       -- сборка "виртуальных" узлов
                       SELECT DISTINCT
                              tmpGoods.Id AS GoodsId
                            , ObjectLink_Unit.ChildObjectId AS UnitId
                              -- какой узел собирается
                            , ObjectLink_GoodsChild.ChildObjectId AS ObjectId_master
                       FROM tmpGoods
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ChildObjectId = tmpGoods.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                 ON ObjectLink_GoodsChild.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                            INNER JOIN Object AS ObjectReceiptChild ON ObjectReceiptChild.Id       = ObjectLink_Object.ObjectId
                                                                   AND ObjectReceiptChild.isErased = FALSE

                            INNER JOIN Object AS ObjectReceipt ON ObjectReceipt.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                              AND ObjectReceipt.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = ObjectReceipt.Id
                                                AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptGoods_Unit()
                          --LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                          --                     ON ObjectLink_ReceiptGoods_Object.ObjectId = ObjectReceipt.Id
                          --                    AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                       -- это виртуальная сборка
                       WHERE ObjectLink_GoodsChild.ChildObjectId > 0

                     UNION
                       -- сборка узлов из "виртуальных" узлов
                       SELECT DISTINCT
                              ObjectLink_GoodsChild.ChildObjectId AS GoodsId
                            , ObjectLink_Unit.ChildObjectId       AS UnitId
                              -- какой узел собирается
                            , ObjectLink_ReceiptGoods_Object.ChildObjectId AS ObjectId_master
                       FROM tmpGoods
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ChildObjectId = tmpGoods.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptGoodsChild_Object()
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                 ON ObjectLink_GoodsChild.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                            INNER JOIN Object AS ObjectReceiptChild ON ObjectReceiptChild.Id       = ObjectLink_Object.ObjectId
                                                                   AND ObjectReceiptChild.isErased = FALSE

                            INNER JOIN Object AS ObjectReceipt ON ObjectReceipt.Id       = ObjectLink_ReceiptGoods.ChildObjectId
                                                              AND ObjectReceipt.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = ObjectReceipt.Id
                                                AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptGoods_Unit()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                 ON ObjectLink_ReceiptGoods_Object.ObjectId = ObjectReceipt.Id
                                                AND ObjectLink_ReceiptGoods_Object.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                       -- это виртуальная сборка
                       WHERE ObjectLink_GoodsChild.ChildObjectId > 0

                     UNION
                       -- сборка моделей
                       SELECT DISTINCT
                              tmpGoods.Id AS GoodsId
                            , ObjectLink_Unit.ChildObjectId  AS UnitId
                              -- какая модель собирается
                            , ObjectLink_ReceiptProdModel_Model.ChildObjectId AS ObjectId_master
                       FROM tmpGoods
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ChildObjectId = tmpGoods.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()   --
                            LEFT JOIN ObjectLink AS ObjectLink_ProdModel
                                                 ON ObjectLink_ProdModel.ObjectId = ObjectLink_Object.ObjectId
                                                AND ObjectLink_ProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                            INNER JOIN Object AS ObjectReceiptProdModelChild ON ObjectReceiptProdModelChild.Id       = ObjectLink_Object.ObjectId
                                                                            AND ObjectReceiptProdModelChild.isErased = FALSE

                            INNER JOIN Object AS ObjectReceiptProdModel ON ObjectReceiptProdModel.Id       = ObjectLink_ProdModel.ChildObjectId
                                                                       AND ObjectReceiptProdModel.isErased = FALSE
                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = ObjectReceiptProdModel.Id
                                                AND ObjectLink_Unit.DescId   = zc_ObjectLink_ReceiptProdModel_Unit()
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel_Model
                                                 ON ObjectLink_ReceiptProdModel_Model.ObjectId = ObjectReceiptProdModel.Id
                                                AND ObjectLink_ReceiptProdModel_Model.DescId   = zc_ObjectLink_ReceiptProdModel_Model()
                      )
         -- подразделение сборки
         , tmpUnit_receipt AS (SELECT tmpReceipt.GoodsId
                                    , STRING_AGG (DISTINCT Object_Unit.ValueData, '; ') AS UnitName_receipt
                               FROM tmpReceipt
                                   LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpReceipt.UnitId
                               WHERE tmpReceipt.UnitId > 0
                               GROUP BY tmpReceipt.GoodsId
                               )
           -- товар сборки
         , tmpGoods_receipt AS (SELECT tmp.GoodsId
                                     , Object_Goods.ValueData AS GoodsName_receipt
                                     , tmp.Name_all
                                FROM (SELECT tmpReceipt.GoodsId
                                           , MAX (tmpReceipt.ObjectId_master) AS GoodsId_receipt
                                           , STRING_AGG (DISTINCT Object_Goods.ValueData, ';') as Name_all
                                      FROM tmpReceipt
                                           INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpReceipt.ObjectId_master
                                      GROUP BY tmpReceipt.GoodsId
                                      ) AS tmp
                                     INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId_receipt
                               )

       -- Результат
       SELECT Object_Goods.Id                     AS Id
            , Object_Goods.ObjectCode             AS Code
            , SUBSTRING (Object_Goods.ValueData, 1, 128) :: TVarChar AS Name
            , CASE WHEN vbUserId = 5 AND 1=0 THEN LOWER (ObjectString_Article.ValueData) ELSE ObjectString_Article.ValueData END :: TVarChar AS Article
            , (zfCalc_Article_all (ObjectString_Article.ValueData)
            || CASE WHEN zfCalc_Article_all (ObjectString_Article.ValueData) <> ObjectString_Article.ValueData THEN '___' || ObjectString_Article.ValueData ELSE '' END
              ) :: TVarChar AS Article_all
            , (CASE WHEN tmpGoods_err_1.Article   IS NOT NULL
                         THEN '**a*'
                    WHEN tmpGoods_err_2.GoodsCode IS NOT NULL
                         THEN '**c*'
                    WHEN tmpGoods_err_3.EAN       IS NOT NULL
                         THEN '**e*'
                    ELSE ''
               END || COALESCE (ObjectString_ArticleVergl.ValueData, '')) :: TVarChar AS ArticleVergl
            , Object_GoodsArticle.GoodsArticle ::TVarChar AS GoodsArticle
            , ObjectString_EAN.ValueData          AS EAN
            , ObjectString_ASIN.ValueData         AS ASIN
            , ObjectString_MatchCode.ValueData    AS MatchCode
            , ObjectString_FeeNumber.ValueData    AS FeeNumber
            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , SUBSTRING (ObjectString_Comment.ValueData, 1, 128) :: TVarChar AS Comment

            , ObjectDate_PartnerDate.ValueData  :: TDateTime AS PartnerDate

            , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
            , COALESCE (ObjectBoolean_Arc.ValueData, FALSE) :: Boolean AS isArc

            , ObjectFloat_Feet.ValueData    ::TFloat AS Feet
            , ObjectFloat_Metres.ValueData  ::TFloat AS Metres

            , ObjectFloat_Min.ValueData          AS AmountMin
            , ObjectFloat_Refer.ValueData        AS AmountRefer

              -- Цена вх. без НДС
            , ObjectFloat_EKPrice.ValueData   ::TFloat   AS EKPrice
              -- Цена вх. с НДС
            , CAST (COALESCE (ObjectFloat_EKPrice.ValueData, 0)
                 * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100)) AS NUMERIC (16, 2))  ::TFloat AS EKPriceWVAT

              -- Рекомендованная цена без НДС
            , ObjectFloat_EmpfPrice.ValueData ::TFloat   AS EmpfPrice
              -- Рекомендованная цена с НДС
            , CAST (COALESCE (ObjectFloat_EmpfPrice.ValueData, 0)
                 * (1 + (COALESCE (ObjectFloat_TaxKind_Value.ValueData, 0) / 100) ) AS NUMERIC (16, 2)) ::TFloat AS EmpfPriceWVAT

              -- Цена продажи без НДС
            , CASE WHEN vbPriceWithVAT = FALSE
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   ELSE CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
              END ::TFloat  AS BasisPrice

              -- Цена продажи с НДС
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
            , COALESCE(ObjectFloat_ProdColor_Value.ValueData, zc_Color_White())::Integer  AS Color_Value
            , Object_Partner.Id                  AS PartnerId
            , Object_Partner.ValueData           AS PartnerName
            , Object_Unit.Id                     AS UnitId
            , Object_Unit.ValueData              AS UnitName
            , tmpUnit_receipt.UnitName_receipt   ::TVarChar

            , tmpGoods_receipt.GoodsName_receipt ::TVarChar
          --, SUBSTRING (tmpGoods_receipt.Name_all, 1, 128) :: TVarChar AS GoodsName_receipt

            , Object_DiscountPartner.Id           AS DiscountPartnerId
            , Object_DiscountPartner.ValueData    AS DiscountPartnerName
            , Object_TaxKind.Id                  AS TaxKindId
            , Object_TaxKind.ValueData           AS TaxKindName
            , ObjectFloat_TaxKind_Value.ValueData AS TaxKind_Value

            , Object_Engine.Id                   AS EngineId
            , Object_Engine.ValueData            AS EngineName

            , Object_InfoMoney_View.InfoMoneyCode
            , Object_InfoMoney_View.InfoMoneyGroupName
            , Object_InfoMoney_View.InfoMoneyDestinationName
            , Object_InfoMoney_View.InfoMoneyName
            , Object_InfoMoney_View.InfoMoneyId

            , Object_Insert.ValueData            AS InsertName
            , ObjectDate_Insert.ValueData        AS InsertDate
            , Object_Update.ValueData            AS UpdateName
            , ObjectDate_Update.ValueData        AS UpdateDate

            , CASE WHEN tmpDoc.GoodsId    > 0 THEN TRUE ELSE FALSE END :: Boolean AS isDoc
            , CASE WHEN tmpPhoto1.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPhoto

            , tmpMovementPL.InvNumber     :: TVarChar AS InvNumber_pl
            , tmpMovementPL.Comment       :: TVarChar AS Comment_pl
            , tmpMovementPL_count.myCount :: Integer  AS myCount_pl

            , LENGTH (Object_Goods.ValueData)                :: Integer AS Len_1
            , LENGTH (ObjectString_Article.ValueData)        :: Integer AS Len_2
            , LENGTH (Object_GoodsArticle.GoodsArticle)      :: Integer AS Len_3
            , LENGTH (ObjectString_EAN.ValueData)            :: Integer AS Len_4
            , LENGTH (ObjectString_GoodsGroupFull.ValueData) :: Integer AS Len_5
            , LENGTH (ObjectString_Comment.ValueData)        :: Integer AS Len_6
            , 0                                              :: Integer AS Len_7
            , 0                                              :: Integer AS Len_8
            , 0                                              :: Integer AS Len_9
            , 0                                              :: Integer AS Len_10

            , Object_Goods.isErased              AS isErased

       FROM tmpGoods AS Object_Goods
            LEFT JOIN tmpMovementPL ON tmpMovementPL.GoodsId = Object_Goods.Id
            LEFT JOIN (SELECT tmpMovementPL_count.GoodsId, MAX (tmpMovementPL_count.myCount) AS myCount
                       FROM (SELECT tmpMovementPL_all.Id, tmpMovementPL_all.GoodsId, COUNT(*) AS myCount
                             FROM tmpMovementPL_all
                             GROUP BY tmpMovementPL_all.Id, tmpMovementPL_all.GoodsId
                             HAVING COUNT(*) > 1
                            ) AS tmpMovementPL_count
                       GROUP BY tmpMovementPL_count.GoodsId
                      ) AS tmpMovementPL_count ON tmpMovementPL_count.GoodsId = Object_Goods.Id
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Goods.Id
                                  AND ObjectString_Comment.DescId = zc_ObjectString_Goods_Comment()

            LEFT JOIN ObjectLink AS ObjectLink_Insert
                                 ON ObjectLink_Insert.ObjectId = Object_Goods.Id
                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Update
                                 ON ObjectLink_Update.ObjectId = Object_Goods.Id
                                AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

            LEFT JOIN ObjectDate AS ObjectDate_Insert
                                 ON ObjectDate_Insert.ObjectId = Object_Goods.Id
                                AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
            LEFT JOIN ObjectDate AS ObjectDate_Update
                                 ON ObjectDate_Update.ObjectId = Object_Goods.Id
                                AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

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
             LEFT JOIN ObjectFloat AS ObjectFloat_ProdColor_Value
                                   ON ObjectFloat_ProdColor_Value.ObjectId = Object_ProdColor.Id
                                  AND ObjectFloat_ProdColor_Value.DescId   = zc_ObjectFloat_ProdColor_Value()

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

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Engine
                                  ON ObjectLink_Goods_Engine.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Engine.DescId = zc_ObjectLink_Goods_Engine()
             LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Goods_Engine.ChildObjectId

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

             LEFT JOIN ObjectFloat AS ObjectFloat_Feet
                                   ON ObjectFloat_Feet.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Feet.DescId   = zc_ObjectFloat_Goods_Feet()
             LEFT JOIN ObjectFloat AS ObjectFloat_Metres
                                   ON ObjectFloat_Metres.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Metres.DescId   = zc_ObjectFloat_Goods_Metres()

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
                                   AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
             LEFT JOIN ObjectString AS ObjectString_ASIN
                                    ON ObjectString_ASIN.ObjectId = Object_Goods.Id
                                   AND ObjectString_ASIN.DescId = zc_ObjectString_ASIN()
             LEFT JOIN ObjectString AS ObjectString_MatchCode
                                    ON ObjectString_MatchCode.ObjectId = Object_Goods.Id
                                   AND ObjectString_MatchCode.DescId = zc_ObjectString_MatchCode()

             LEFT JOIN tmpDoc ON tmpDoc.GoodsId = Object_Goods.Id

             LEFT JOIN tmpPhoto AS tmpPhoto1
                                ON tmpPhoto1.GoodsId = Object_Goods.Id
                               AND tmpPhoto1.Ord = 1
             LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data1
                                  ON ObjectBlob_GoodsPhoto_Data1.ObjectId = tmpPhoto1.PhotoId

             LEFT JOIN tmpPhoto AS tmpPhoto2
                                ON tmpPhoto2.GoodsId = Object_Goods.Id
                               AND tmpPhoto2.Ord = 2
             LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data2
                                  ON ObjectBlob_GoodsPhoto_Data2.ObjectId = tmpPhoto2.PhotoId

             LEFT JOIN tmpPhoto AS tmpPhoto3
                                ON tmpPhoto3.GoodsId = Object_Goods.Id
                               AND tmpPhoto3.Ord = 3
             LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data3
                                  ON ObjectBlob_GoodsPhoto_Data3.ObjectId = tmpPhoto3.PhotoId

             LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

             LEFT JOIN tmpGoodsArticle AS Object_GoodsArticle ON Object_GoodsArticle.GoodsId = Object_Goods.Id

             LEFT JOIN tmpGoods_err_1 ON tmpGoods_err_1.Article   ILIKE ObjectString_Article.ValueData
             LEFT JOIN tmpGoods_err_2 ON tmpGoods_err_2.GoodsCode = Object_Goods.ObjectCode
             LEFT JOIN tmpGoods_err_3 ON tmpGoods_err_3.EAN       = ObjectString_EAN.ValueData

             LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = Object_Goods.Id

             LEFT JOIN tmpUnit_receipt  ON tmpUnit_receipt.GoodsId  = Object_Goods.Id
             LEFT JOIN tmpGoods_receipt ON tmpGoods_receipt.GoodsId = Object_Goods.Id
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.22         * add inIsLimit_100
 10.04.22         *
 11.11.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Goods (inShowAll:= FALSE, inIsLimit_100:= TRUE, inSession := zfCalc_UserAdmin())
