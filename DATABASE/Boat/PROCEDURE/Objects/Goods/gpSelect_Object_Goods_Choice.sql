-- Function: gpSelect_Object_Goods_Choice()

DROP FUNCTION IF EXISTS gpSelect_Object_Goods_Choice (Integer, Boolean, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods_Choice(
    IN inPriceListId Integer,
    IN inShowAll     Boolean,
    IN inIsLimit_100 Boolean,
    IN inArticle     TVarChar,
    IN inName        TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_all TVarChar
             , Article TVarChar, Article_all TVarChar, ArticleVergl TVarChar, GoodsArticle TVarChar
             , ModelName_calc TVarChar
             , EAN TVarChar, ASIN TVarChar, MatchCode TVarChar
             , FeeNumber TVarChar, GoodsGroupNameFull TVarChar, Comment TVarChar
             , PartnerDate TDateTime
               -- Узел (да/нет)
             , isReceiptGoods_group  Boolean
               -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
             , isReceiptGoods        Boolean
               -- Опция (да/нет) - Участвует в опциях
             , isProdOptions         Boolean
               -- Архив (да/нет)
             , isArc Boolean
               --
             , Feet TFloat, Metres TFloat
             , Weight TFloat
             , AmountMin TFloat, AmountRefer TFloat  
             
             , AmountRemains TFloat

             , EKPrice TFloat, EKPriceWVAT TFloat
             , EmpfPrice TFloat, EmpfPriceWVAT TFloat
             , BasisPrice TFloat, BasisPriceWVAT TFloat
             , BasisPrice_choice TFloat 
             , StartDate_price TDateTime
             , PriceListId Integer

             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId Integer, ProdColorName TVarChar
             , Color_Value Integer, Color_remains Integer
             , PartnerId Integer, PartnerName   TVarChar
             , UnitId Integer, UnitName TVarChar
               -- Где эта деталь/Узел участвует в сборке Узла/Лодки
             , UnitName_receipt TVarChar
               -- Где эта деталь  участвует в сборке Узла-ПФ
             , UnitName_child_receipt TVarChar
               -- Где собирается узел
             , UnitName_parent_receipt TVarChar
               -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
             , GoodsName_receipt TVarChar
               -- в каких ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
             --, GoodsName_receipt TVarChar
               --
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
     
     -- IF vbUserId = 5 THEN inShowAll:= TRUE; END IF;


     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());

     -- Результат
     RETURN QUERY
       WITH 
            tmpPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS GoodsId
                              , Object_GoodsPhoto.Id                      AS PhotoId
                              , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                         FROM Object AS Object_GoodsPhoto
                                JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                                ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                               AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                          WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                            AND Object_GoodsPhoto.isErased = FALSE
                            AND 1=0
                        )
           , tmpDoc AS (SELECT DISTINCT ObjectLink_GoodsDocument_Goods.ChildObjectId AS GoodsId
                         FROM Object AS Object_GoodsDocument
                                JOIN ObjectLink AS ObjectLink_GoodsDocument_Goods
                                                ON ObjectLink_GoodsDocument_Goods.ObjectId = Object_GoodsDocument.Id
                                               AND ObjectLink_GoodsDocument_Goods.DescId   = zc_ObjectLink_GoodsDocument_Goods()
                          WHERE Object_GoodsDocument.DescId   = zc_Object_GoodsDocument()
                            AND Object_GoodsDocument.isErased = FALSE
                            AND 1=0
                       )
          -- все что в сборке
        , tmpReceiptGoods AS (SELECT Object_ReceiptGoods_find_View.GoodsId
                                     -- это узел (да/нет)
                                   , Object_ReceiptGoods_find_View.isReceiptGoods_group
                                     -- все из чего собирается + узлы
                                   , Object_ReceiptGoods_find_View.isReceiptGoods
                                     -- Опция (да/нет) - Участвует в опциях
                                   , Object_ReceiptGoods_find_View.isProdOptions
                       
                                     -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                   , Object_ReceiptGoods_find_View.GoodsId_receipt
                                     -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                   , Object_ReceiptGoods_find_View.GoodsName_receipt
                                     -- в каких ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
                                   , Object_ReceiptGoods_find_View.GoodsName_receipt_all
                       
                                     -- На каком участке происходит расход Узла/Детали на сборку
                                   , Object_ReceiptGoods_find_View.UnitId_receipt
                                   , Object_ReceiptGoods_find_View.UnitName_receipt
                                     -- На каком участке происходит расход Детали на сборку ПФ
                                   , Object_ReceiptGoods_find_View.UnitId_child_receipt
                                   , Object_ReceiptGoods_find_View.UnitName_child_receipt
                                     -- На каком участке происходит сборка Узла
                                   , Object_ReceiptGoods_find_View.UnitId_parent_receipt
                                   , Object_ReceiptGoods_find_View.UnitName_parent_receipt
            
                              FROM Object_ReceiptGoods_find_View
                              -- когда ВСЕ
                              WHERE inIsLimit_100 = FALSE
                             )
           -- !!!или все или 100!!!
         , tmpGoods_limit AS (SELECT Object_Goods.*
                              FROM Object AS Object_Goods
                                   LEFT JOIN ObjectBoolean AS ObjectBoolean_Arc
                                                           ON ObjectBoolean_Arc.ObjectId = Object_Goods.Id
                                                          AND ObjectBoolean_Arc.DescId = zc_ObjectBoolean_Goods_Arc()
                                   LEFT JOIN ObjectString AS ObjectString_Article
                                                          ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                         AND ObjectString_Article.DescId = zc_ObjectString_Article()
                                   LEFT JOIN ObjectString AS ObjectString_EAN
                                                          ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                                         AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()

                              WHERE Object_Goods.DescId = zc_Object_Goods()
                              --AND Object_Goods.isErased = FALSE
                                AND (Object_Goods.isErased = FALSE OR inShowAll = TRUE)
                                -- огр. по вх. параметрам
                                AND ((Object_Goods.ValueData         ILIKE ('%'||inName   ||'%') AND LENGTH (TRIM (inName))    > 2)
                                  OR (ObjectString_Article.ValueData ILIKE ('%'||inArticle||'%') AND LENGTH (TRIM (inArticle)) > 2)
                                  OR (ObjectString_EAN.ValueData ILIKE ('%'||inArticle||'%') AND LENGTH (TRIM (inArticle)) > 10)
                                  OR TRIM (inName) = '*'
                                  OR TRIM (inArticle) = '*'
                                    )
                             )
         , tmpGoods AS (-- здесь ВСЕ или 100
                        SELECT tmpGoods_limit.*
                        FROM tmpGoods_limit

                      /*UNION
                        -- эти всегда
                        SELECT Object_Goods.*
                        FROM Object AS Object_Goods
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                          -- если есть в сборке
                          AND Object_Goods.Id IN (SELECT DISTINCT tmpReceiptGoods.GoodsId FROM tmpReceiptGoods)
                          -- когда ВСЕ
                          AND inIsLimit_100 = FALSE*/

                     /*UNION
                        -- эти всегда
                        SELECT Object_Goods.*
                        FROM Object AS Object_Goods
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                             -- нет дублей
                             INNER JOIN ObjectBoolean AS ObjectBoolean_Arc
                                                      ON ObjectBoolean_Arc.ObjectId  = Object_Goods.Id
                                                     AND ObjectBoolean_Arc.DescId    = zc_ObjectBoolean_Goods_Arc()
                                                     AND ObjectBoolean_Arc.ValueData = FALSE

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
                                                  --AND Object_Goods.ObjectCode < 0
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                          -- когда только 100
                          --AND inIsLimit_100 = TRUE
                          -- когда все
                          AND inIsLimit_100 = FALSE   
                          AND (COALESCE (inArticle,'') = '' AND COALESCE (inName,'') = '')*/
                       )
           , tmpPriceBasis AS (SELECT ObjectLink_PriceListItem_Goods.ChildObjectId     AS GoodsId
                                    , ObjectHistory_PriceListItem.StartDate            AS StartDate
                                    , ObjectHistoryFloat_PriceListItem_Value.ValueData AS ValuePrice
                                    , inPriceListId                                    AS PriceListId
                               FROM ObjectLink AS ObjectLink_PriceListItem_Goods
                                    INNER JOIN ObjectLink AS ObjectLink_PriceListItem_PriceList
                                                          ON ObjectLink_PriceListItem_PriceList.ObjectId     = ObjectLink_PriceListItem_Goods.ObjectId
                                                         AND ObjectLink_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_PriceList()
                                                         AND ObjectLink_PriceListItem_PriceList.ChildObjectId = inPriceListId
                                    LEFT JOIN ObjectHistory AS ObjectHistory_PriceListItem
                                                            ON ObjectHistory_PriceListItem.ObjectId = ObjectLink_PriceListItem_PriceList.ObjectId
                                                           AND ObjectHistory_PriceListItem.DescId = zc_ObjectHistory_PriceListItem()
                                                           AND CURRENT_DATE >= ObjectHistory_PriceListItem.StartDate AND CURRENT_DATE < ObjectHistory_PriceListItem.EndDate
                                    INNER JOIN ObjectHistoryFloat AS ObjectHistoryFloat_PriceListItem_Value
                                                                  ON ObjectHistoryFloat_PriceListItem_Value.ObjectHistoryId = ObjectHistory_PriceListItem.Id
                                                                 AND ObjectHistoryFloat_PriceListItem_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
                                                                 AND ObjectHistoryFloat_PriceListItem_Value.ValueData <> 0
                               WHERE ObjectLink_PriceListItem_Goods.ChildObjectId IN (SELECT DISTINCT tmpGoods.Id FROM tmpGoods)
                                 AND ObjectLink_PriceListItem_Goods.DescId = zc_ObjectLink_PriceListItem_Goods()
                              )
           -- текущие остатки
         , tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                             --, Container.WhereObjectId       AS UnitId
                               , SUM (Container.Amount)        AS Remains
                          FROM Container
                          WHERE Container.WhereObjectId = 35139 -- Склад Основной
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId IN (SELECT DISTINCT tmpGoods.Id FROM tmpGoods)
                            AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                               --, Container.WhereObjectId
                          HAVING SUM (Container.Amount) <> 0
                         )

       -- Результат
       SELECT Object_Goods.Id                     AS Id
            , Object_Goods.ObjectCode             AS Code
              --
            , LEFT (Object_Goods.ValueData, 124) :: TVarChar AS Name
            , LEFT (zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_Goods.ValueData), 124) :: TVarChar AS Name_all
              --
            , ObjectString_Article.ValueData      AS Article
            , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '') || '_' || COALESCE (ObjectString_EAN.ValueData, '')) ::TVarChar AS Article_all
              --
            , COALESCE (ObjectString_ArticleVergl.ValueData, '') :: TVarChar AS ArticleVergl
              -- Артикул Комплектующие (в загрузке прайсов)
            , '' ::TVarChar AS GoodsArticle
              --
            , CASE WHEN ObjectString_Comment.ValueData ILIKE '%Hypalon%'
                     OR ObjectString_Comment.ValueData ILIKE '%HULL%'
                     OR ObjectString_Comment.ValueData ILIKE '%DECK%'
                     OR ObjectString_Comment.ValueData ILIKE '%STEERING CONSOLE%'
                     OR ObjectString_Comment.ValueData ILIKE '%Kreslo%'
                     OR ObjectString_Comment.ValueData ILIKE '%Teak%'
                   THEN CASE SPLIT_PART (SPLIT_PART (ObjectString_Article.ValueData, 'AGL-', 2), '-', 1)
                             WHEN '305' THEN '305C'
                             WHEN '330' THEN '330C'
                             WHEN '355' THEN '355C'
                             WHEN '360' THEN '360D'
                             ELSE SPLIT_PART (SPLIT_PART (ObjectString_Article.ValueData, 'AGL-', 2), '-', 1)
                        END
                   ELSE ''
              END :: TVarChar AS ModelName_calc
              --
            , ObjectString_EAN.ValueData            AS EAN
            , ObjectString_ASIN.ValueData           AS ASIN
            , ObjectString_MatchCode.ValueData      AS MatchCode
            , ObjectString_FeeNumber.ValueData      AS FeeNumber
            , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , LEFT (ObjectString_Comment.ValueData, 124) :: TVarChar        AS Comment

            , ObjectDate_PartnerDate.ValueData  :: TDateTime AS PartnerDate

              -- это узел (да/нет)
            , COALESCE (tmpReceiptGoods.isReceiptGoods_group, FALSE) :: Boolean AS isReceiptGoods_group
              -- все из чего собирается + узлы
            , COALESCE (tmpReceiptGoods.isReceiptGoods, FALSE)       :: Boolean AS isReceiptGoods
              -- Опция (да/нет) - Участвует в опциях
            , COALESCE (tmpReceiptGoods.isProdOptions, FALSE)        :: Boolean AS isProdOptions

              -- Архив (да/нет)
            , COALESCE (ObjectBoolean_Arc.ValueData, FALSE) :: Boolean AS isArc

            , ObjectFloat_Feet.ValueData    ::TFloat AS Feet
            , ObjectFloat_Metres.ValueData  ::TFloat AS Metres
            , ObjectFloat_Weight.ValueData  ::TFloat AS Weight

            , ObjectFloat_Min.ValueData          AS AmountMin
            , ObjectFloat_Refer.ValueData        AS AmountRefer
            
              -- остатки на гл. складе
            , tmpRemains.Remains ::TFloat        AS AmountRemains

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
              END ::TFloat AS BasisPrice

              -- Цена продажи с НДС
            , CASE WHEN vbPriceWithVAT = FALSE
                   THEN CAST ( COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 + COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))
                   ELSE COALESCE (tmpPriceBasis.ValuePrice, 0)
              END ::TFloat AS BasisPriceWVAT
              
              -- Цена продажи без НДС - передается в грид
            , CASE WHEN vbPriceWithVAT = FALSE AND tmpPriceBasis.ValuePrice > 0
                   THEN COALESCE (tmpPriceBasis.ValuePrice, 0)
                   WHEN vbPriceWithVAT = TRUE AND tmpPriceBasis.ValuePrice > 0
                   THEN CAST (COALESCE (tmpPriceBasis.ValuePrice, 0) * ( 1 - COALESCE (ObjectFloat_TaxKind_Value.ValueData,0) / 100)  AS NUMERIC (16, 2))

                   -- Рекомендованная цена без НДС
                   WHEN ObjectFloat_EmpfPrice.ValueData > 0
                   THEN COALESCE (ObjectFloat_EmpfPrice.ValueData, 0)

                   ELSE 0

              END ::TFloat AS BasisPrice_choice  
              
            , tmpPriceBasis.StartDate ::TDateTime AS StartDate_price
            , tmpPriceBasis.PriceListId ::Integer 

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
            , CASE WHEN COALESCE (tmpRemains.Remains,0) <> 0 THEN zc_Color_Yelow() ELSE zc_Color_White() END ::Integer AS Color_remains 
            , Object_Partner.Id                  AS PartnerId
            , Object_Partner.ValueData           AS PartnerName

            , Object_Unit.Id                     AS UnitId
            --, Object_Unit.ValueData              AS UnitName
     
            , /*CASE -- узел Стеклопластик + Опция
                   WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE AND tmpReceiptGoods.isProdOptions = TRUE
                        -- Склад Основной
                        THEN lfGet_Object_ValueData_sh (35139)

                   -- Опция
                   WHEN tmpReceiptGoods.isProdOptions = TRUE
                        -- Склад Основной
                        THEN lfGet_Object_ValueData_sh (35139)

                   -- узел
                   WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE
                        -- Склад Основной
                        THEN lfGet_Object_ValueData_sh (35139)

                   -- Деталь + НЕ Узел + есть Unit-ПФ
                   WHEN tmpReceiptGoods.isReceiptGoods = TRUE AND tmpReceiptGoods.isReceiptGoods_group = FALSE AND tmpReceiptGoods.UnitName_child_receipt <> ''
                        THEN tmpReceiptGoods.UnitName_child_receipt

                   -- Участок сборки Hypalon
                   WHEN tmpReceiptGoods.UnitId_receipt = 38875
                        THEN tmpReceiptGoods.UnitName_receipt

                   -- Участок UPHOLSTERY
                   WHEN tmpReceiptGoods.UnitId_receipt = 253225
                        THEN tmpReceiptGoods.UnitName_receipt

                   -- Склад Основной
                   ELSE lfGet_Object_ValueData_sh (35139)

              END*/ '' :: TVarChar AS UnitName

              -- На каком участке происходит расход Узла/Детали на сборку
            , '' :: TVarChar -- tmpReceiptGoods.UnitName_receipt
              -- На каком участке происходит расход Детали на сборку ПФ
            , '' :: TVarChar -- tmpReceiptGoods.UnitName_child_receipt
              -- На каком участке происходит сборка Узла
            , '' :: TVarChar -- tmpReceiptGoods.UnitName_parent_receipt


              -- в каком ОДНОМ Узле/Модель лодки Детали/узлы участвуют в сборке, т.е. что собирается
            , '' :: TVarChar -- tmpReceiptGoods.GoodsName_receipt
              -- в каких ВСЕХ Узлах/Моделях лодки Детали/узлы участвуют в сборке, т.е. что собирается
          --, SUBSTRING (tmpReceiptGoods.GoodsName_receipt_all, 1, 128) :: TVarChar AS GoodsName_receipt

            , Object_DiscountPartner.Id           AS DiscountPartnerId
            , Object_DiscountPartner.ValueData    AS DiscountPartnerName
            , Object_TaxKind.Id                   AS TaxKindId
            , Object_TaxKind.ValueData            AS TaxKindName
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

            , FALSE :: Boolean -- CASE WHEN tmpDoc.GoodsId    > 0 THEN TRUE ELSE FALSE END :: Boolean AS isDoc
            , FALSE :: Boolean -- CASE WHEN tmpPhoto1.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPhoto

            , '' :: TVarChar -- tmpMovementPL.InvNumber     :: TVarChar AS InvNumber_pl
            , '' :: TVarChar -- tmpMovementPL.Comment       :: TVarChar AS Comment_pl
            , 0  :: Integer  -- tmpMovementPL_count.myCount :: Integer  AS myCount_pl

            , LENGTH (Object_Goods.ValueData)                :: Integer AS Len_1
            , LENGTH (ObjectString_Article.ValueData)        :: Integer AS Len_2
            , 0 :: Integer -- LENGTH (Object_GoodsArticle.GoodsArticle)      :: Integer AS Len_3
            , LENGTH (ObjectString_EAN.ValueData)            :: Integer AS Len_4
            , LENGTH (ObjectString_GoodsGroupFull.ValueData) :: Integer AS Len_5
            , LENGTH (ObjectString_Comment.ValueData)        :: Integer AS Len_6
            , 0                                              :: Integer AS Len_7
            , 0                                              :: Integer AS Len_8
            , 0                                              :: Integer AS Len_9
            , 0                                              :: Integer AS Len_10

            , Object_Goods.isErased              AS isErased

       FROM tmpGoods AS Object_Goods

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

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

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
            -- это
            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = Object_Goods.Id

            -- это
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_Goods.Id

            -- это
            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = Object_Goods.Id

        --WHERE ObjectString_Article.ValueData ILIKE 'AGL%'

        ORDER BY Object_Goods.Id  desc
        -- LIMIT 197022
        -- LIMIT CASE WHEN vbUserId = 5 THEN  185000 else 300000 end
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.25         *
 29.08.25         * add Remains
 01.12.23         * UnitName_child_receipt
 18.05.22         * add inIsLimit_100
 10.04.22         *
 11.11.20         *
*/

-- тест
--  SELECT * FROM gpSelect_Object_Goods_Choice (inPriceListId:= 0, inShowAll:= FALSE, inIsLimit_100:= TRUE, inArticle := 'TD90775'::TVarChar, inName := ''::TVarChar, inSession := zfCalc_UserAdmin())
