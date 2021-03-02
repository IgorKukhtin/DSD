-- Function: gpSelect_Object_Product()

DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product(
    IN inIsShowAll   Boolean,       -- признак показать удаленные да / нет
    IN inIsSale      Boolean,       -- признак показать проданные да / нет
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ProdColorName TVarChar
             , Hours TFloat, DiscountTax TFloat, DiscountNextTax TFloat
             , DateStart TDateTime, DateBegin TDateTime, DateSale TDateTime
             , CIN TVarChar, EngineNum TVarChar
             , Comment TVarChar
             , ProdGroupId Integer, ProdGroupName TVarChar
             , BrandId Integer, BrandName TVarChar
             , ModelId Integer, ModelName TVarChar, ModelName_full TVarChar
             , EngineId Integer, EngineName TVarChar
             , ReceiptProdModelId Integer, ReceiptProdModelName TVarChar
             , ClientId Integer, ClientCode Integer, ClientName TVarChar
             , MovementId_OrderClient Integer
             , OperDate_OrderClient  TDateTime
             , InvNumber_OrderClient TVarChar
             , StatusCode_OrderClient Integer
             , StatusName_OrderClient TVarChar

             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean

               -- ИТОГО Сумма вх. без НДС (Basis)
             , EKPrice_summ1          TFloat
               -- ИТОГО Сумма вх. с НДС (Basis)
             , EKPriceWVAT_summ1      TFloat
               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis)
             , Basis_summ1            TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis)
             , BasisWVAT_summ1        TFloat
               -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
             , Basis_summ1_orig       TFloat
               -- ИТОГО Сумма продажи с НДС - без Скидки (Basis)
             , BasisWVAT_summ1_orig   TFloat

               -- ИТОГО Сумма вх. без НДС (options)
             , EKPrice_summ2          TFloat
               -- ИТОГО Сумма вх. с НДС (options)
             , EKPriceWVAT_summ2      TFloat
               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (options)
             , Basis_summ2            TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (options)
             , BasisWVAT_summ2        TFloat
               -- ИТОГО Сумма продажи без НДС - без Скидки (options)
             , Basis_summ2_orig       TFloat
               -- ИТОГО Сумма продажи с НДС - без Скидки (options)
             , BasisWVAT_summ2_orig   TFloat

               -- ИТОГО Сумма вх. без НДС
             , EKPrice_summ     TFloat
               -- ИТОГО Сумма вх. с НДС
             , EKPriceWVAT_summ TFloat
               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками
             , Basis_summ       TFloat
               -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками
             , BasisWVAT_summ   TFloat

               -- ИТОГО Сумма продажи без НДС - без Скидки
             , Basis_summ_orig       TFloat
               -- ИТОГО Сумма продажи с НДС - без Скидки
             , BasisWVAT_summ_orig   TFloat
             
             , SummDiscount1      TFloat
             , SummDiscount2      TFloat
             , SummDiscount3      TFloat
             , SummDiscount_total TFloat

             , isBasicConf Boolean
             , Color_fon Integer
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPriceWithVAT Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);

     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     RETURN QUERY
     WITH
          -- базовые цены
          tmpPriceBasis AS (SELECT tmp.GoodsId
                                 , tmp.ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE) AS tmp
                           )
    -- выводим 2 цвета в мастере
  , tmpProdColorItems_find AS (SELECT ObjectLink_Product.ChildObjectId AS ProductId
                                    , Object_ProdColorItems.ObjectCode AS ProdColorItemsCode
                                    , Object_ProdColorItems.ValueData  AS ProdColorItemsName
                                    , Object_ProdColorGroup.ObjectCode AS ProdColorGroupCode
                                    , Object_ProdColorGroup.ValueData  AS ProdColorGroupName
                                    , Object_ProdColor.ValueData       AS ProdColorName
                                    , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Product.ChildObjectId ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP
                                FROM Object AS Object_ProdColorItems
                                     -- Лодка
                                     LEFT JOIN ObjectLink AS ObjectLink_Product
                                                          ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                         AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
                                     -- Товар - если была замена
                                     LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                          ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                                         AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
                                     -- Boat Structure
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                          ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                                         AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
                                     LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = ObjectLink_ProdColorPattern.ChildObjectId

                                     -- Категория/Группа Boat Structure
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                                          ON ObjectLink_ProdColorGroup.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                         AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
                                     LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

                                     -- Товар Boat Structure
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern_Goods
                                                          ON ObjectLink_ProdColorPattern_Goods.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                                         AND ObjectLink_ProdColorPattern_Goods.DescId = zc_ObjectLink_ProdColorPattern_Goods()
                                     -- Цвет Или/Или
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                          ON ObjectLink_ProdColor.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, ObjectLink_ProdColorPattern_Goods.ChildObjectId)
                                                         AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                     LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId

                                WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                                  AND Object_ProdColorItems.isErased = FALSE
                               )
     -- Product
   , tmpProduct AS (SELECT Object_Product.*
                         , ObjectDate_DateSale.ValueData    AS DateSale
                         , ObjectLink_Model.ChildObjectId   AS ModelId
                         , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
                         , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END AS isSale
                           -- !!!учитываем ли в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                         , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
                           -- % скидки №1
                         , COALESCE (ObjectFloat_DiscountTax.ValueData, 0)     AS DiscountTax
                           -- % скидки №2
                         , COALESCE (ObjectFloat_DiscountNextTax.ValueData, 0) AS DiscountNextTax

                    FROM Object AS Object_Product
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

                         LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                 ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                                AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()

                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()

                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                              ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                                             AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()

                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                              ON ObjectFloat_DiscountTax.ObjectId = Object_Product.Id
                                             AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Product_DiscountTax()
                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountNextTax
                                              ON ObjectFloat_DiscountNextTax.ObjectId = Object_Product.Id
                                             AND ObjectFloat_DiscountNextTax.DescId = zc_ObjectFloat_Product_DiscountNextTax()

                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (Object_Product.isErased = FALSE OR inIsShowAll = TRUE)
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                   )
   -- все Элементы сборки Модели - у Лодки - здесь вся база
 , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.Id          AS ProductId
                                         , tmpProduct.isBasicConf AS isBasicConf
                                           -- % скидки №1
                                         , tmpProduct.DiscountTax
                                           -- % скидки №2
                                         , tmpProduct.DiscountNextTax
                                           --
                                         , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                           --
                                         , lpSelect.ObjectId_parent
                                           -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                         , lpSelect.ObjectId
                                           -- значение
                                         , lpSelect.Value
                                           --
                                         , lpSelect.ProdColorPatternId
                                         , lpSelect.ProdOptionsId

                                         , lpSelect.EKPrice, lpSelect.EKPriceWVAT
                                         , lpSelect.BasisPrice, lpSelect.BasisPriceWVAT

                                    FROM lpSelect_Object_ReceiptProdModelChild_detail (vbUserId) AS lpSelect
                                         JOIN tmpProduct ON tmpProduct.ReceiptProdModelId = lpSelect.ReceiptProdModelId
                                   )
        -- существующие Элементы Boat Structure - у Лодки - если была замена, в базовой стоимости НЕ будем учитываем
      , tmpProdColorItems AS (SELECT lpSelect.ProductId
                                   , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                   , lpSelect.ProdColorPatternId
                                     -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                   , lpSelect.isDiff
                                     --
                                   , lpSelect.ProdColorPatternId

                              FROM gpSelect_Object_ProdColorItems (inIsShowAll:= FALSE
                                                                 , inIsErased := FALSE
                                                                 , inIsSale   := TRUE
                                                                 , inSession  := inSession
                                                                  ) AS lpSelect
                             )
          -- существующие элементы ProdOptItems - у Лодки
        , tmpProdOptItems AS (SELECT lpSelect.ProductId
                                   , lpSelect.ProdOptionsId
                                   , lpSelect.ProdColorPatternId
                                     -- % скидки
                                   , lpSelect.DiscountTax
                                     -- Цена вх. без НДС
                                   , lpSelect.EKPrice
                                     -- Цена вх. с НДС
                                   , lpSelect.EKPriceWVAT
                                     -- Цена продажи без НДС
                                   , lpSelect.SalePrice
                                     -- Цена продажи с НДС
                                   , lpSelect.SalePriceWVAT

                              FROM gpSelect_Object_ProdOptItems (inIsShowAll:= FALSE
                                                               , inIsErased := FALSE
                                                               , inIsSale   := TRUE
                                                               , inSession  := inSession
                                                                ) AS lpSelect
                             )
             -- РАСЧЕТ стоимости - у Лодки
           , tmpCalc_all AS (-- 1.1. Базовая - ВСЯ
                             SELECT lpSelect.ProductId                                                         AS ProductId
                                  , TRUE                                                                       AS isBasis
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPrice,        0)) AS EKPrice_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPriceWVAT,    0)) AS EKPriceWVAT_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.BasisPrice,     0)) AS BasisPrice_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.BasisPriceWVAT, 0)) AS BasisPriceWVAT_summ

                                  , 0 AS BasisPrice_summ_disc_1
                                  , 0 AS BasisPrice_summ_disc_2
                                  , 0 AS BasisPriceWVAT_summ_disc
                                  
                                  , lpSelect.DiscountTax
                                  , lpSelect.DiscountNextTax

                             FROM tmpReceiptProdModelChild_all AS lpSelect
                                  LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId          = lpSelect.ProductId
                                                           AND tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                           AND tmpProdOptItems.ProdColorPatternId > 0

                             WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                   lpSelect.isBasicConf = TRUE
                               AND -- если Boat Structure нет в Опциях
                                   tmpProdOptItems.ProductId IS NULL
                             GROUP BY lpSelect.ProductId
                                    , lpSelect.DiscountTax
                                    , lpSelect.DiscountNextTax

                            UNION ALL
                             -- 1.2. Базовая - только по элементам Boat Structure
                             SELECT lpSelect.ProductId                                                           AS ProductId
                                  , TRUE                                                                         AS isBasis
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPrice,        0))   AS EKPrice_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPriceWVAT,    0))   AS EKPriceWVAT_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.BasisPrice,     0))   AS BasisPrice_summ
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.BasisPriceWVAT, 0))   AS BasisPriceWVAT_summ

                                  , 0 AS BasisPrice_summ_disc_1
                                  , 0 AS BasisPrice_summ_disc_2
                                  , 0 AS BasisPriceWVAT_summ_disc
                                  
                                  , lpSelect.DiscountTax
                                  , lpSelect.DiscountNextTax

                             FROM tmpReceiptProdModelChild_all AS lpSelect
                                  LEFT JOIN tmpProdOptItems ON tmpProdOptItems.ProductId          = lpSelect.ProductId
                                                           AND tmpProdOptItems.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                           AND tmpProdOptItems.ProdColorPatternId > 0
                                  -- если есть такой
                                  JOIN (SELECT DISTINCT
                                               tmpProdColorItems.ProductId
                                             , tmpProdColorItems.ReceiptProdModelChildId
                                        FROM tmpProdColorItems
                                       ) AS tmp ON tmp.ProductId               = lpSelect.ProductId
                                               AND tmp.ReceiptProdModelChildId = lpSelect.ReceiptProdModelChildId
                             WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                   lpSelect.isBasicConf = FALSE
                               AND -- если Boat Structure нет в Опциях
                                   tmpProdOptItems.ProductId IS NULL
                             GROUP BY lpSelect.ProductId
                                    , lpSelect.DiscountTax
                                    , lpSelect.DiscountNextTax

                            UNION ALL
                             -- 2. Опции
                             SELECT lpSelect.ProductId                         AS ProductId
                                  , FALSE                                      AS isBasis
                                  , SUM (COALESCE (tmpReceiptProdModelChild_all.Value, 1) * COALESCE (lpSelect.EKPrice,       0)) AS EKPrice_summ
                                  , SUM (COALESCE (tmpReceiptProdModelChild_all.Value, 1) * COALESCE (lpSelect.EKPriceWVAT,   0)) AS EKPriceWVAT_summ
                                  , SUM (COALESCE (lpSelect.SalePrice,     0)) AS BasisPrice_summ
                                  , SUM (COALESCE (lpSelect.SalePriceWVAT, 0)) AS BasisPriceWVAT_summ
                                    -- со ВСЕМИ Скидками - без НДС
                                  , SUM (zfCalc_SummDiscountTax    (lpSelect.SalePrice, lpSelect.DiscountTax))     AS BasisPrice_summ_disc_1
                                  , SUM (zfCalc_SummDiscountTax    (lpSelect.SalePrice, lpSelect.DiscountTax))     AS BasisPrice_summ_disc_2
                                    -- со ВСЕМИ Скидками с НДС
                                  , SUM (zfCalc_SummWVATDiscountTax(lpSelect.SalePrice, lpSelect.DiscountTax, 16)) AS BasisPriceWVAT_summ_disc

                                  , 0 AS DiscountTax
                                  , 0 AS DiscountNextTax

                             FROM tmpProdOptItems AS lpSelect
                                  LEFT JOIN tmpReceiptProdModelChild_all ON tmpReceiptProdModelChild_all.ProductId          = lpSelect.ProductId
                                                                        AND tmpReceiptProdModelChild_all.ProdColorPatternId = lpSelect.ProdColorPatternId
                                                                        AND tmpReceiptProdModelChild_all.ProdColorPatternId > 0

                             GROUP BY lpSelect.ProductId
                            )
                 -- РАСЧЕТ стоимости с учетом СКИДКИ - у Лодки
               , tmpCalc AS (-- 1.1. Базовая - ВСЯ
                             SELECT tmpCalc_all.ProductId
                                  , tmpCalc_all.isBasis
                                  , tmpCalc_all.EKPrice_summ
                                  , tmpCalc_all.EKPriceWVAT_summ
                                  , tmpCalc_all.BasisPrice_summ
                                  , tmpCalc_all.BasisPriceWVAT_summ
                                    -- с учетом % скидки №1 - без НДС
                                  , (zfCalc_SummDiscountTax     (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax)) AS BasisPrice_summ_disc_1
                                    -- с учетом % скидки №2 - без НДС
                                  , (zfCalc_SummDiscountTax     (zfCalc_SummDiscountTax (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax), tmpCalc_all.DiscountNextTax))     AS BasisPrice_summ_disc_2
                                    -- Сумма продажи с НДС - с учетом ВСЕХ скидок
                                  , (zfCalc_SummWVATDiscountTax (zfCalc_SummDiscountTax (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax), tmpCalc_all.DiscountNextTax, 16)) AS BasisPriceWVAT_summ_disc
                             FROM tmpCalc_all
                             WHERE tmpCalc_all.isBasis = TRUE

                            UNION ALL
                             SELECT tmpCalc_all.ProductId
                                  , tmpCalc_all.isBasis
                                  , tmpCalc_all.EKPrice_summ
                                  , tmpCalc_all.EKPriceWVAT_summ
                                  , tmpCalc_all.BasisPrice_summ
                                  , tmpCalc_all.BasisPriceWVAT_summ
                                    -- с учетом % скидки №1 - без НДС
                                  , tmpCalc_all.BasisPrice_summ_disc_1
                                    -- с учетом % скидки №2 - без НДС
                                  , tmpCalc_all.BasisPrice_summ_disc_2
                                    -- Сумма продажи с НДС - с учетом ВСЕХ скидок
                                  , tmpCalc_all.BasisPriceWVAT_summ_disc
                             FROM tmpCalc_all
                             WHERE tmpCalc_all.isBasis = FALSE
                            )

   , tmpResAll AS(SELECT Object_Product.Id               AS Id
                       , Object_Product.ObjectCode       AS Code
                       , Object_Product.ValueData        AS Name
                       , CASE WHEN tmpProdColorItems_1.ProdColorName ILIKE tmpProdColorItems_2.ProdColorName
                              THEN tmpProdColorItems_1.ProdColorName
                              ELSE COALESCE (tmpProdColorItems_1.ProdColorName, '') || ' / ' || COALESCE (tmpProdColorItems_2.ProdColorName, '')
                         END :: TVarChar AS ProdColorName

                       , ObjectFloat_Hours.ValueData      AS Hours
                       , Object_Product.DiscountTax       AS DiscountTax
                       , Object_Product.DiscountNextTax   AS DiscountNextTax

                       , ObjectDate_DateStart.ValueData   AS DateStart
                       , ObjectDate_DateBegin.ValueData   AS DateBegin
                     --, ObjectDate_DateSale.ValueData    AS DateSale
                       , Object_Product.DateSale          AS DateSale
                       , ObjectString_CIN.ValueData       AS CIN
                       , ObjectString_EngineNum.ValueData AS EngineNum
                       , ObjectString_Comment.ValueData   AS Comment

                       , Object_ProdGroup.Id             AS ProdGroupId
                       , Object_ProdGroup.ValueData      AS ProdGroupName

                       , Object_Brand.Id                 AS BrandId
                       , Object_Brand.ValueData          AS BrandName

                       , Object_Model.Id                 AS ModelId
                       , Object_Model.ValueData          AS ModelName
                       , (Object_Model.ValueData ||' (' || Object_Brand.ValueData||')') ::TVarChar AS ModelName_full

                       , Object_Engine.Id                AS EngineId
                       , Object_Engine.ValueData         AS EngineName

                       , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
                       , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName

                       , Object_Client.Id                AS ClientId
                       , Object_Client.ObjectCode        AS ClientCode
                       , Object_Client.ValueData         AS ClientName

                       , Object_Insert.ValueData         AS InsertName
                       , ObjectDate_Insert.ValueData     AS InsertDate
                       --, CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                       , Object_Product.isSale ::Boolean AS isSale
                       , Object_Product.isErased         AS isErased

                       --, COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
                       , Object_Product.isBasicConf      AS isBasicConf

                   FROM tmpProduct AS Object_Product
                        LEFT JOIN tmpProdColorItems_find AS tmpProdColorItems_1
                                                         ON tmpProdColorItems_1.ProductId = Object_Product.Id
                                                        AND tmpProdColorItems_1.NPP = 1
                        LEFT JOIN tmpProdColorItems_find AS tmpProdColorItems_2
                                                         ON tmpProdColorItems_2.ProductId = Object_Product.Id
                                                        AND tmpProdColorItems_2.NPP = 2

                        LEFT JOIN ObjectFloat AS ObjectFloat_Hours
                                              ON ObjectFloat_Hours.ObjectId = Object_Product.Id
                                             AND ObjectFloat_Hours.DescId = zc_ObjectFloat_Product_Hours()

                        LEFT JOIN ObjectDate AS ObjectDate_DateStart
                                             ON ObjectDate_DateStart.ObjectId = Object_Product.Id
                                            AND ObjectDate_DateStart.DescId = zc_ObjectDate_Product_DateStart()

                        LEFT JOIN ObjectDate AS ObjectDate_DateBegin
                                             ON ObjectDate_DateBegin.ObjectId = Object_Product.Id
                                            AND ObjectDate_DateBegin.DescId = zc_ObjectDate_Product_DateBegin()

                        LEFT JOIN ObjectString AS ObjectString_CIN
                                               ON ObjectString_CIN.ObjectId = Object_Product.Id
                                              AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN()

                        LEFT JOIN ObjectString AS ObjectString_EngineNum
                                               ON ObjectString_EngineNum.ObjectId = Object_Product.Id
                                              AND ObjectString_EngineNum.DescId = zc_ObjectString_Product_EngineNum()

                        LEFT JOIN ObjectString AS ObjectString_Comment
                                               ON ObjectString_Comment.ObjectId = Object_Product.Id
                                              AND ObjectString_Comment.DescId = zc_ObjectString_Product_Comment()

                        LEFT JOIN ObjectLink AS ObjectLink_ProdGroup
                                             ON ObjectLink_ProdGroup.ObjectId = Object_Product.Id
                                            AND ObjectLink_ProdGroup.DescId = zc_ObjectLink_Product_ProdGroup()
                        LEFT JOIN Object AS Object_ProdGroup ON Object_ProdGroup.Id = ObjectLink_ProdGroup.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Brand
                                             ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                            AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
                        LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Client
                                             ON ObjectLink_Client.ObjectId = Object_Product.Id
                                            AND ObjectLink_Client.DescId = zc_ObjectLink_Product_Client()
                        LEFT JOIN Object AS Object_Client ON Object_Client.Id = ObjectLink_Client.ChildObjectId

                        LEFT JOIN Object AS Object_Model ON Object_Model.Id = Object_Product.ModelId
                        LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = Object_Product.ReceiptProdModelId

                        LEFT JOIN ObjectLink AS ObjectLink_Engine
                                             ON ObjectLink_Engine.ObjectId = Object_Product.Id
                                            AND ObjectLink_Engine.DescId = zc_ObjectLink_Product_Engine()
                        LEFT JOIN Object AS Object_Engine ON Object_Engine.Id = ObjectLink_Engine.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Insert
                                             ON ObjectLink_Insert.ObjectId = Object_Product.Id
                                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

                        LEFT JOIN ObjectDate AS ObjectDate_Insert
                                             ON ObjectDate_Insert.ObjectId = Object_Product.Id
                                            AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()
                  )
     -- документы заказа
    , tmpOrderClient AS (SELECT tmp.*
                         FROM (SELECT Movement.*
                              , ('№ ' || Movement.InvNumber || '  ' || Movement.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_full
                              , Object_Status.ObjectCode   AS StatusCode
                              , Object_Status.ValueData    AS StatusName
                              , Object_From.Id         AS FromId
                              , Object_From.ObjectCode AS FromCode
                              , Object_From.ValueData  AS FromName
                              , MovementLinkObject_Product.ObjectId AS ProductId
                              , MovementFloat_DiscountTax.ValueData      AS DiscountTax
                              , MovementFloat_DiscountNextTax.ValueData    AS DiscountNextTax
                              , ROW_NUMBER() OVER (PARTITION BY MovementLinkObject_Product.ObjectId
                                                   ORDER BY CASE WHEN Movement.StatusId = zc_Enum_Status_Complete() THEN 1
                                                                 WHEN Movement.StatusId = zc_Enum_Status_UnComplete() THEN 2
                                                                 ELSE 9999
                                                            END)    AS Ord
                         FROM MovementLinkObject AS MovementLinkObject_Product
                              INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                 AND Movement.DescId = zc_Movement_OrderClient()
                                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                              LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                      ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()
                              LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                      ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountNextTax.DescId = zc_MovementFloat_DiscountNextTax()
                         WHERE MovementLinkObject_Product.ObjectId IN (SELECT DISTINCT tmpProduct.Id FROM tmpProduct)
                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                               ) AS tmp
                         --WHERE tmp.Ord = 1
                         )


     -- Результат
    SELECT
           tmpResAll.Id
         , tmpResAll.Code
         , tmpResAll.Name
         , tmpResAll.ProdColorName

         , tmpResAll.Hours            ::TFloat
         --, tmpResAll.DiscountTax      ::TFloat
         --, tmpResAll.DiscountNextTax  ::TFloat
         , tmpOrderClient.DiscountTax    ::TFloat AS DiscountTax
         , tmpOrderClient.DiscountNextTax  ::TFloat AS DiscountNextTax
         , tmpResAll.DateStart
         , tmpResAll.DateBegin
         , tmpResAll.DateSale
         , tmpResAll.CIN
         , tmpResAll.EngineNum
         , tmpResAll.Comment

         , tmpResAll.ProdGroupId
         , tmpResAll.ProdGroupName

         , tmpResAll.BrandId
         , tmpResAll.BrandName

         , tmpResAll.ModelId
         , tmpResAll.ModelName
         , tmpResAll.ModelName_full

         , tmpResAll.EngineId
         , tmpResAll.EngineName

         , tmpResAll.ReceiptProdModelId
         , tmpResAll.ReceiptProdModelName

/*         , tmpResAll.ClientId
         , tmpResAll.ClientCode
         , tmpResAll.ClientName
*/
         , tmpOrderClient.FromId    ::Integer   AS ClientId
         , tmpOrderClient.FromCode  ::Integer   AS ClientCode
         , tmpOrderClient.FromName  ::TVarChar  AS ClientName
         , tmpOrderClient.Id        ::Integer   AS MovementId_OrderClient
         , tmpOrderClient.OperDate  ::TDateTime AS OperDate_OrderClient
         , tmpOrderClient.InvNumber ::TVarChar  AS InvNumber_OrderClient
         , tmpOrderClient.StatusCode ::Integer  AS StatusCode_OrderClient
         , tmpOrderClient.StatusName ::TVarChar AS StatusName_OrderClient

         , tmpResAll.InsertName
         , tmpResAll.InsertDate
         , tmpResAll.isSale

           -- ИТОГО Сумма вх. без НДС (Basis)
         , tmpCalc_1.EKPrice_summ          :: TFloat AS EKPrice_summ1
         , tmpCalc_1.EKPriceWVAT_summ      :: TFloat AS EKPriceWVAT_summ1
           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis)
         , tmpCalc_1.BasisPrice_summ_disc_2     :: TFloat AS Basis_summ1
         , tmpCalc_1.BasisPriceWVAT_summ_disc   :: TFloat AS BasisWVAT_summ1
           -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
         , tmpCalc_1.BasisPrice_summ       :: TFloat AS Basis_summ1_orig
         , tmpCalc_1.BasisPriceWVAT_summ   :: TFloat AS BasisWVAT_summ1_orig

           -- ИТОГО Сумма вх. без НДС (options)
         , tmpCalc_2.EKPrice_summ          :: TFloat AS EKPrice_summ2
         , tmpCalc_2.EKPriceWVAT_summ      :: TFloat AS EKPriceWVAT_summ2
           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (options)
         , tmpCalc_2.BasisPrice_summ_disc_2     :: TFloat AS Basis_summ2
         , tmpCalc_2.BasisPriceWVAT_summ_disc   :: TFloat AS BasisWVAT_summ2
           -- ИТОГО Сумма продажи без НДС - без Скидки (options)
         , tmpCalc_2.BasisPrice_summ       :: TFloat AS Basis_summ2_orig
         , tmpCalc_2.BasisPriceWVAT_summ   :: TFloat AS BasisWVAT_summ2_orig

           -- ИТОГО Сумма вх. без НДС
         , (COALESCE (tmpCalc_1.EKPrice_summ, 0)        + COALESCE (tmpCalc_2.EKPrice_summ, 0))           :: TFloat AS EKPrice_summ
           -- ИТОГО Сумма вх. с НДС
         , (COALESCE (tmpCalc_1.EKPriceWVAT_summ, 0)    + COALESCE (tmpCalc_2.EKPriceWVAT_summ, 0))       :: TFloat AS EKPriceWVAT_summ
           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками
         , (COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0)   + COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0))      :: TFloat AS Basis_summ
           -- ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками
         , (COALESCE (tmpCalc_1.BasisPriceWVAT_summ_disc, 0) + COALESCE (tmpCalc_2.BasisPriceWVAT_summ_disc, 0))    :: TFloat AS BasisWVAT_summ

           -- ИТОГО Сумма продажи без НДС - без Скидки
         , (COALESCE (tmpCalc_1.BasisPrice_summ, 0)     + COALESCE (tmpCalc_2.BasisPrice_summ, 0))        :: TFloat AS Basis_summ_orig
           -- ИТОГО Сумма продажи с НДС - без Скидки
         , (COALESCE (tmpCalc_1.BasisPriceWVAT_summ, 0) + COALESCE (tmpCalc_2.BasisPriceWVAT_summ, 0))    :: TFloat AS BasisWVAT_summ_orig

           -- ИТОГО Сумма Скидки - без НДС
         , (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_1, 0)) :: TFloat AS SummDiscount1

         , (-- итоговая скидка
            (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0))
            -- минус Скидка № 1
          - (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_1, 0))
           ) :: TFloat AS SummDiscount2

         , (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)) :: TFloat AS SummDiscount3

         , (-- итоговая скидка (Basis)
            (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0))
            -- плюс итоговая скидка (options)
          + (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0))
           ) :: TFloat AS SummDiscount_total

         , tmpResAll.isBasicConf

         , CASE WHEN tmpResAll.isSale
                     THEN zc_Color_Lime()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS Color_fon

         , tmpResAll.isErased

     FROM tmpResAll
          LEFT JOIN tmpCalc AS tmpCalc_1 ON tmpCalc_1.ProductId = tmpResAll.Id AND tmpCalc_1.isBasis = TRUE
          LEFT JOIN tmpCalc AS tmpCalc_2 ON tmpCalc_2.ProductId = tmpResAll.Id AND tmpCalc_2.isBasis = FALSE
          
          LEFT JOIN tmpOrderClient ON tmpOrderClient.ProductId = tmpResAll.Id 
          
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.21         *
 08.10.20         *
*/

-- тест
--
-- SELECT * FROM gpSelect_Object_Product (false, true, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Product (false, false, zfCalc_UserAdmin())
