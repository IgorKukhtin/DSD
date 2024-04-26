-- Function: gpSelect_Object_Product()

DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product (Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Product (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Product(
    IN inMovementId_OrderClient  Integer,
    IN inIsShowAll               Boolean,       -- признак показать удаленные да / нет
    IN inIsSale                  Boolean,       -- признак показать проданные да / нет
    IN inSession                 TVarChar       -- сессия пользователя
)
RETURNS TABLE (KeyId TVarChar, Id Integer, Code Integer, Name TVarChar, ProdColorName TVarChar
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
             , InvNumberFull_OrderClient TVarChar
             , InvNumber_OrderClient TVarChar
             , StatusCode_OrderClient Integer
             , StatusName_OrderClient TVarChar
             , InfoMoneyId_Client   Integer
             , InfoMoneyName_Client TVarChar
             , TaxKind_Value_Client TFloat
             --, Value_TaxKind TFloat, Info_TaxKind TVarChar
             , TaxKindName_Client  TVarChar
             , TaxKindName_info_Client TVarChar

               -- данные Счета
             , MovementId_Invoice      Integer
             , InvNumberFull_Invoice   TVarChar
             , ReceiptNumber_Invoice   Integer
             , Amount_Invoice          TFloat
             , InvoiceKindId           Integer
             , InvoiceKindName         TVarChar

               -- Итого оплата
             , MovementId_BankAccount  Integer
             , OperDate_BankAccount    TDateTime
             , Amount_BankAccount      TFloat

               -- ДОЛГ
             , Amount_Debt             TFloat

               --
             , NPP_OrderClient Integer
             , NPP_2 Integer

             , InsertName TVarChar
             , InsertDate TDateTime
             , isSale Boolean

               -- ИТОГО Сумма вх. без НДС (Basis)
             , EKPrice_summ1          TFloat
               -- ИТОГО Сумма вх. без НДС (options)
             , EKPrice_summ2          TFloat
               -- ИТОГО Сумма вх. без НДС (Basis+options)
             , EKPrice_summ     TFloat


               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis)
             , Basis_summ1            TFloat
               -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
             , Basis_summ1_orig       TFloat

               -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (options)
             , Basis_summ2            TFloat
               -- ИТОГО Сумма продажи без НДС - без Скидки (options)
             , Basis_summ2_orig       TFloat

               -- 1.*Total LP (Basis + Opt) - ИТОГО БЕЗ учета скидки и Транспорта, Сумма продажи без НДС
             , Basis_summ_orig       TFloat

               -- 2.***Total LP - ИТОГО с учетом всех % скидок, без Транспорта, Сумма продажи без НДС
             , Basis_summ       TFloat

               -- 4. Total LP - ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , Basis_summ_transport       TFloat
               -- 5. Total LP + Vat - ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
             , BasisWVAT_summ_transport       TFloat


               -- Цена продажи с сайта - без НДС, Basis+options
             , OperPrice_load TFloat
               -- Базовая цена продажи модели с сайта
             , BasisPrice_load TFloat
               -- load Сумма транспорт с сайта
             , TransportSumm_load TFloat
             , TransportSumm TFloat

               -- ИТОГО Сумма Скидка № 1 (Basis) - без НДС
             , SummDiscount1      TFloat
               -- -- ИТОГО Сумма Скидка № 2 (Basis) - без НДС
             , SummDiscount2      TFloat

               -- ИТОГО Сумма Скидка № 1 (options) - без НДС
             , SummDiscount1_opt  TFloat
               -- ИТОГО Сумма Скидка № 2 (options) - без НДС
             , SummDiscount2_opt  TFloat
               -- ИТОГО Сумма Скидка № 1 + 2 (options) - без НДС
             , SummDiscount3_opt  TFloat
             , SummDiscount3      TFloat  ---так назівался раньше, исп. в печ формах

               -- Сумма скидки по всем % скидки
             , SummDiscount TFloat

               -- Скидка (ввод) - Cумма откорректированной скидки, без НДС (доп.скидка)
             , SummTax TFloat
               -- Скидка ИТОГО
             , SummDiscount_total TFloat

               -- 3. Cумма после скидки (расчет)
             , Basis_summ_calc TFloat

             , isBasicConf Boolean
             , isReserve Boolean

             , StateText   TVarChar
             , StateColor  Integer
             , isErased    Boolean
              )
AS
$BODY$
   DECLARE vbUserId             Integer;
   DECLARE vbPriceWithVAT_pl    Boolean;
   DECLARE vbTaxKindValue_basis TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Product());
     vbUserId:= lpGetUserBySession (inSession);


     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());


     -- Результат
     RETURN QUERY
     WITH
          -- Цена продажи - БЕЗ НДС
          tmpPriceBasis AS (SELECT lfSelect.GoodsId
                                   -- Цена продажи без НДС
                                 , CASE WHEN vbPriceWithVAT_pl = FALSE
                                        THEN COALESCE (lfSelect.ValuePrice, 0)
                                        -- расчет
                                        ELSE zfCalc_Summ_NoVAT (lfSelect.ValuePrice, vbTaxKindValue_basis)
                                   END ::TFloat  AS ValuePrice
                            FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                     , inOperDate   := CURRENT_DATE
                                                                      ) AS lfSelect
                           )
      -- документы Заказ Клиента
    , tmpOrderClient AS (SELECT Movement.Id                AS MovementId
                              , Movement.StatusId          AS StatusId
                              , Movement.InvNumber         AS InvNumber
                              , Movement.OperDate          AS OperDate
                              , Object_Status.ObjectCode   AS StatusCode
                              , Object_Status.ValueData    AS StatusName
                              , Object_From.Id             AS FromId
                              , Object_From.ObjectCode     AS FromCode
                              , Object_From.ValueData      AS FromName 
                              , MovementLinkObject_TaxKind.ObjectId         AS TaxKindId
                              , MovementLinkObject_Product.ObjectId         AS ProductId
                              , MovementFloat_DiscountTax.ValueData         AS DiscountTax
                              , MovementFloat_DiscountNextTax.ValueData     AS DiscountNextTax
                              , MovementFloat_OperPrice_load.ValueData      AS OperPrice_load
                              , MovementFloat_TransportSumm_load.ValueData  AS TransportSumm_load 
                              , MovementFloat_TransportSumm.ValueData       AS TransportSumm
                                -- Скидка (ввод)
                              , MovementFloat_SummTax.ValueData             AS SummTax
                                --
                              , Object_InfoMoney_View.InfoMoneyId
                              , Object_InfoMoney_View.InfoMoneyName_all
                                -- % НДС Заказ клиента
                              , MovementFloat_VATPercent.ValueData       AS VATPercent
                                --
                              , COALESCE (MovementFloat_NPP.ValueData,0) :: Integer AS NPP

                         FROM MovementLinkObject AS MovementLinkObject_Product
                              INNER JOIN Movement ON Movement.Id = MovementLinkObject_Product.MovementId
                                                 AND Movement.DescId = zc_Movement_OrderClient()
                                                 AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inIsShowAll = TRUE)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                           ON MovementLinkObject_From.MovementId = Movement.Id
                                                          AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                              LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_TaxKind
                                                           ON MovementLinkObject_TaxKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_TaxKind.DescId = zc_MovementLinkObject_TaxKind()

                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                              LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                                      ON MovementFloat_VATPercent.MovementId = Movement.Id
                                                     AND MovementFloat_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                              LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                                      ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()
                              LEFT JOIN MovementFloat AS MovementFloat_DiscountNextTax
                                                      ON MovementFloat_DiscountNextTax.MovementId = Movement.Id
                                                     AND MovementFloat_DiscountNextTax.DescId     = zc_MovementFloat_DiscountNextTax()

                              LEFT JOIN MovementFloat AS MovementFloat_OperPrice_load
                                                      ON MovementFloat_OperPrice_load.MovementId = Movement.Id
                                                     AND MovementFloat_OperPrice_load.DescId     = zc_MovementFloat_OperPrice_load()
                              LEFT JOIN MovementFloat AS MovementFloat_TransportSumm_load
                                                      ON MovementFloat_TransportSumm_load.MovementId = Movement.Id
                                                     AND MovementFloat_TransportSumm_load.DescId     = zc_MovementFloat_TransportSumm_load()
                              LEFT JOIN MovementFloat AS MovementFloat_TransportSumm
                                                      ON MovementFloat_TransportSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TransportSumm.DescId     = zc_MovementFloat_TransportSumm()

                              LEFT JOIN MovementFloat AS MovementFloat_NPP
                                                      ON MovementFloat_NPP.MovementId = Movement.Id
                                                     AND MovementFloat_NPP.DescId = zc_MovementFloat_NPP()

                             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                     ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                             LEFT JOIN MovementFloat AS MovementFloat_SummTax
                                                     ON MovementFloat_SummTax.MovementId = Movement.Id
                                                    AND MovementFloat_SummTax.DescId = zc_MovementFloat_SummTax()

                              LEFT JOIN ObjectLink AS ObjectLink_InfoMoney
                                                   ON ObjectLink_InfoMoney.ObjectId = Object_From.Id
                                                  AND ObjectLink_InfoMoney.DescId   = zc_ObjectLink_Client_InfoMoney()
                              LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_InfoMoney.ChildObjectId

                         -- !!!временно, надо будет как-то выбирать НЕ ВСЕ!!!
                         WHERE MovementLinkObject_Product.ObjectId > 0
                           AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                           AND (MovementLinkObject_Product.MovementId = inMovementId_OrderClient OR COALESCE (inMovementId_OrderClient, 0) = 0)
                        )
    -- выводим 2 цвета в мастере
  , tmpProdColorItems_find AS (SELECT ObjectFloat_MovementId_OrderClient.ValueData :: Integer AS MovementId_OrderClient
                                    , ObjectLink_Product.ChildObjectId AS ProductId
                                    , Object_ProdColorItems.ObjectCode AS ProdColorItemsCode
                                    , Object_ProdColorItems.ValueData  AS ProdColorItemsName
                                    , Object_ProdColorGroup.ObjectCode AS ProdColorGroupCode
                                    , Object_ProdColorGroup.ValueData  AS ProdColorGroupName
                                    , Object_ProdColor.ValueData       AS ProdColorName
                                    , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Product.ChildObjectId ORDER BY Object_ProdColorGroup.ObjectCode ASC, Object_ProdColorPattern.ObjectCode ASC) :: Integer AS NPP
                                FROM Object AS Object_ProdColorItems
                                     -- Заказ Клиента
                                     LEFT JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                                           ON ObjectFloat_MovementId_OrderClient.ObjectId = Object_ProdColorItems.Id
                                                          AND ObjectFloat_MovementId_OrderClient.DescId   = zc_ObjectFloat_ProdColorItems_OrderClient()
                                     -- Лодка
                                     LEFT JOIN ObjectLink AS ObjectLink_Product
                                                          ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                                         AND ObjectLink_Product.DescId = zc_ObjectLink_ProdColorItems_Product()
                                     -- Товар в ProdColorItems - если была замена
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
                                                         AND ObjectLink_ProdColorPattern_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
                                     -- Цвет Или/Или
                                     LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                                          ON ObjectLink_ProdColor.ObjectId = COALESCE (ObjectLink_Goods.ChildObjectId, ObjectLink_ProdColorPattern_Goods.ChildObjectId)
                                                         AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
                                     LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId

                                WHERE Object_ProdColorItems.DescId = zc_Object_ProdColorItems()
                                  AND Object_ProdColorItems.isErased = FALSE
                                  AND (ObjectFloat_MovementId_OrderClient.ValueData = inMovementId_OrderClient OR COALESCE (inMovementId_OrderClient, 0) = 0)
                               )
     -- Product
   , tmpProduct AS (SELECT COALESCE (tmpOrderClient.MovementId, 0) AS MovementId_OrderClient
                         , Object_Product.Id
                         , Object_Product.ObjectCode
                         , Object_Product.ValueData
                         , Object_Product.isErased
                         , ObjectDate_DateSale.ValueData    AS DateSale
                         , ObjectLink_Model.ChildObjectId   AS ModelId
                         , COALESCE (ObjectLink_ReceiptProdModel.ChildObjectId,0) AS ReceiptProdModelId
                         , CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END AS isSale

                           -- !!!учитываем ли в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                         , COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) AS isBasicConf
                           -- !!!Предварительный заказ с нейизвестной конфигурацией!!
                         , COALESCE (ObjectBoolean_Reserve.ValueData, FALSE) AS isReserve

                           -- % скидки №1
                         , COALESCE (tmpOrderClient.DiscountTax, 0)     AS DiscountTax
                           -- % скидки №2
                         , COALESCE (tmpOrderClient.DiscountNextTax, 0) AS DiscountNextTax
                           -- % НДС Заказ клиента
                         , COALESCE (tmpOrderClient.VATPercent, 0)      AS VATPercent

                           -- Цена продажи из истории??? - без НДС (ReceiptProdModel - Basis)
                         , COALESCE (tmpPriceBasis.ValuePrice, 0) ::TFloat  AS BasisPrice

                           -- Цена продажи с сайта - без НДС, Basis+options
                         , COALESCE (tmpOrderClient.OperPrice_load, 0)         AS OperPrice_load
                           -- Сумма транспорт с сайта
                         , COALESCE (tmpOrderClient.TransportSumm_load, 0)     AS TransportSumm_load
                             -- Сумма транспорт
                         , COALESCE (tmpOrderClient.TransportSumm, 0)          AS TransportSumm
                           -- Базовая цена продажи модели с сайта
                         , COALESCE (MIFloat_BasisPrice_load.ValueData, 0)     AS BasisPrice_load

                         , tmpOrderClient.NPP
                         , tmpOrderClient.OperDate
                         , COALESCE (tmpOrderClient.StatusId, zc_Enum_Status_Erased()) AS StatusId

                           -- Скидка (ввод)
                         , tmpOrderClient.SummTax

                    FROM Object AS Object_Product
                         LEFT JOIN ObjectDate AS ObjectDate_DateSale
                                              ON ObjectDate_DateSale.ObjectId = Object_Product.Id
                                             AND ObjectDate_DateSale.DescId = zc_ObjectDate_Product_DateSale()

                         LEFT JOIN ObjectBoolean AS ObjectBoolean_BasicConf
                                                 ON ObjectBoolean_BasicConf.ObjectId = Object_Product.Id
                                                AND ObjectBoolean_BasicConf.DescId   = zc_ObjectBoolean_Product_BasicConf()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Reserve
                                                 ON ObjectBoolean_Reserve.ObjectId = Object_Product.Id
                                                AND ObjectBoolean_Reserve.DescId   = zc_ObjectBoolean_Product_Reserve()

                         LEFT JOIN ObjectLink AS ObjectLink_Model
                                              ON ObjectLink_Model.ObjectId = Object_Product.Id
                                             AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()

                         LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                              ON ObjectLink_ReceiptProdModel.ObjectId = Object_Product.Id
                                             AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()

                         -- Заказ клиента
                         LEFT JOIN tmpOrderClient ON tmpOrderClient.ProductId = Object_Product.Id

                         -- Заказ клиента - Лодка
                         LEFT JOIN MovementItem ON MovementItem.MovementId = tmpOrderClient.MovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.ObjectId   = Object_Product.Id
                                               AND MovementItem.isErased   = FALSE
                         -- Базовая цена продажи модели с сайта
                         LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice_load
                                                     ON MIFloat_BasisPrice_load.MovementItemId = MovementItem.Id
                                                    AND MIFloat_BasisPrice_load.DescId         = zc_MIFloat_BasisPrice_load()

                         -- цены для <Шаблон сборка Модели>
                         LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = ObjectLink_ReceiptProdModel.ChildObjectId
                                                -- учитываем ли в стоимости ВСЮ БАЗОВУЮ конфигурацию
                                                AND ObjectBoolean_BasicConf.ValueData = TRUE

                    WHERE Object_Product.DescId = zc_Object_Product()
                     AND (Object_Product.isErased = FALSE OR inIsShowAll = TRUE)
                     AND (COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() OR inIsSale = TRUE)
                     AND (tmpOrderClient.MovementId = inMovementId_OrderClient OR COALESCE (inMovementId_OrderClient, 0) = 0)
                   )
   -- все Элементы сборки Модели - у Лодки - здесь вся база
 , tmpReceiptProdModelChild_all AS (SELECT tmpProduct.MovementId_OrderClient
                                         , tmpProduct.Id          AS ProductId
                                         , tmpProduct.isBasicConf AS isBasicConf
                                         , tmpProduct.isReserve   AS isReserve
                                           -- % скидки №1
                                         , tmpProduct.DiscountTax
                                           -- % скидки №2
                                         , tmpProduct.DiscountNextTax
                                           -- % НДС Заказ клиента
                                         , tmpProduct.VATPercent
                                           -- Цена продажи из истории??? - без НДС (ReceiptProdModel - Basis) - Лодка
                                         , tmpProduct.BasisPrice
                                           --
                                         , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                           --
                                         , lpSelect.ObjectId_parent
                                           -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                         , lpSelect.ObjectId
                                           -- значение - Элемент
                                         , lpSelect.Value
                                           -- цена вх. без НДС - Элемент
                                         , lpSelect.EKPrice
                                           --
                                         , lpSelect.ProdColorPatternId
                                       --, lpSelect.ProdOptionsId

                                    FROM lpSelect_Object_ReceiptProdModelChild_detail (inIsGroup:= TRUE, inUserId:= vbUserId) AS lpSelect
                                         JOIN tmpProduct ON tmpProduct.ReceiptProdModelId = lpSelect.ReceiptProdModelId
                                   )
        -- существующие Элементы Boat Structure - у Лодки - если была замена, в базовой стоимости НЕ будем учитываем
      , tmpProdColorItems AS (SELECT lpSelect.MovementId_OrderClient
                                   , lpSelect.ProductId
                                   , lpSelect.ReceiptProdModelId, lpSelect.ReceiptProdModelChildId
                                   , lpSelect.ProdColorPatternId
                                     -- либо Goods "такой" как в Boat Structure /либо другой Goods, не такой как в Boat Structure /либо ПУСТО
                                   , lpSelect.isDiff
                                     --
                                   , lpSelect.ProdColorPatternId

                              FROM gpSelect_Object_ProdColorItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                                                 , inIsShowAll             := FALSE
                                                                 , inIsErased              := FALSE
                                                                 , inIsSale                := TRUE
                                                                 , inSession               := inSession
                                                                  ) AS lpSelect
                              WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient OR COALESCE (inMovementId_OrderClient, 0) = 0
                             )
          -- существующие элементы ProdOptItems - у Лодки
        , tmpProdOptItems AS (SELECT lpSelect.MovementId_OrderClient
                                   , lpSelect.ProductId
                                   , lpSelect.ProdOptionsId
                                   , lpSelect.ProdColorPatternId
                                     -- % скидки
                                   , lpSelect.DiscountTax
                                   , lpSelect.DiscountTax_order
                                   , lpSelect.DiscountNextTax_order
                                     -- % НДС Заказ клиента
                                   , lpSelect.VATPercent
                                     -- Сумма вх. без НДС
                                   , lpSelect.EKPrice_summ
                                     -- Цена продажи
                                   , lpSelect.SalePrice
                                     -- Сумма продажи
                                   , lpSelect.Sale_summ
                                   , lpSelect.SaleWVAT_summ

                              FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                                               , inIsShowAll             := FALSE
                                                               , inIsErased              := FALSE
                                                               , inIsSale                := TRUE
                                                               , inSession               := inSession
                                                                ) AS lpSelect
                              WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient OR COALESCE (inMovementId_OrderClient, 0) = 0
                             )
             -- РАСЧЕТ стоимости - у Лодки
           , tmpCalc_all AS (-- 1.1. Базовая - ВСЯ
                             SELECT lpSelect.MovementId_OrderClient                                            AS MovementId_OrderClient
                                  , lpSelect.ProductId                                                         AS ProductId
                                  , TRUE                                                                       AS isBasis
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPrice,        0)) AS EKPrice_summ

                                  , 0 AS BasisPrice_summ_disc_1
                                  , 0 AS BasisPrice_summ_disc_2
                                  , 0 AS BasisPriceWVAT_summ_disc

                                  , lpSelect.DiscountTax
                                  , lpSelect.DiscountNextTax
                                  , 0 AS DiscountTax_opt
                                  , lpSelect.VATPercent
                                    -- Цена продажи из истории??? - без НДС (ReceiptProdModel - Basis) - Лодка
                                  , lpSelect.BasisPrice      AS BasisPrice_summ

                             FROM tmpReceiptProdModelChild_all AS lpSelect
                                  LEFT JOIN tmpProdOptItems ON tmpProdOptItems.MovementId_OrderClient = lpSelect.MovementId_OrderClient
                                                           AND tmpProdOptItems.ProductId              = lpSelect.ProductId
                                                           AND tmpProdOptItems.ProdColorPatternId     = lpSelect.ProdColorPatternId
                                                           AND tmpProdOptItems.ProdColorPatternId     > 0

                             WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                   lpSelect.isBasicConf = TRUE
                               AND -- если Boat Structure нет в Опциях
                                   tmpProdOptItems.ProductId IS NULL
                             GROUP BY lpSelect.MovementId_OrderClient
                                    , lpSelect.ProductId
                                    , lpSelect.DiscountTax
                                    , lpSelect.DiscountNextTax
                                    , lpSelect.VATPercent
                                    , lpSelect.BasisPrice

                            UNION ALL
                             -- 1.2. Базовая - только по элементам Boat Structure
                             SELECT lpSelect.MovementId_OrderClient                                              AS MovementId_OrderClient
                                  , lpSelect.ProductId                                                           AS ProductId
                                  , TRUE                                                                         AS isBasis
                                  , SUM (COALESCE (lpSelect.Value, 0) * COALESCE (lpSelect.EKPrice,        0))   AS EKPrice_summ

                                  , 0 AS BasisPrice_summ_disc_1
                                  , 0 AS BasisPrice_summ_disc_2
                                  , 0 AS BasisPriceWVAT_summ_disc

                                  , lpSelect.DiscountTax
                                  , lpSelect.DiscountNextTax
                                  , 0 AS DiscountTax_opt
                                  , lpSelect.VATPercent

                                  , 0 AS BasisPrice_summ

                             FROM tmpReceiptProdModelChild_all AS lpSelect
                                  LEFT JOIN tmpProdOptItems ON tmpProdOptItems.MovementId_OrderClient = lpSelect.MovementId_OrderClient
                                                           AND tmpProdOptItems.ProductId              = lpSelect.ProductId
                                                           AND tmpProdOptItems.ProdColorPatternId     = lpSelect.ProdColorPatternId
                                                           AND tmpProdOptItems.ProdColorPatternId     > 0
                                  -- если есть такой
                                  JOIN (SELECT DISTINCT
                                               tmpProdColorItems.MovementId_OrderClient
                                             , tmpProdColorItems.ProductId
                                             , tmpProdColorItems.ReceiptProdModelChildId
                                        FROM tmpProdColorItems
                                       ) AS tmp ON tmp.MovementId_OrderClient  = lpSelect.MovementId_OrderClient
                                               AND tmp.ProductId               = lpSelect.ProductId
                                               AND tmp.ReceiptProdModelChildId = lpSelect.ReceiptProdModelChildId
                             WHERE -- !!!если учитываем в стоимости ВСЮ БАЗОВУЮ конфигурацию!!
                                   lpSelect.isBasicConf = FALSE
                               AND -- если Boat Structure нет в Опциях
                                   tmpProdOptItems.ProductId IS NULL
                             GROUP BY lpSelect.MovementId_OrderClient
                                    , lpSelect.ProductId
                                    , lpSelect.DiscountTax
                                    , lpSelect.DiscountNextTax
                                    , lpSelect.VATPercent

                            UNION ALL
                             -- 2. Опции
                             SELECT lpSelect.MovementId_OrderClient            AS MovementId_OrderClient
                                  , lpSelect.ProductId                         AS ProductId
                                  , FALSE                                      AS isBasis
                                  , SUM (COALESCE (lpSelect.EKPrice_summ, 0))  AS EKPrice_summ

                                    -- со ВСЕМИ Скидками - без НДС
                                  /*
                                  , SUM (zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order))  AS BasisPrice_summ_disc_1
                                  , SUM (zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order)
                                                                                       , lpSelect.DiscountNextTax_order)
                                                               , lpSelect.DiscountTax)) AS BasisPrice_summ_disc_2
                                    -- со ВСЕМИ Скидками с НДС
                                  , SUM (zfCalc_SummWVATDiscountTax (zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order)
                                                                                           , lpSelect.DiscountNextTax_order)
                                                                   , lpSelect.DiscountTax, lpSelect.VATPercent)) AS BasisPriceWVAT_summ_disc
                                  */
                                  , SUM (CASE WHEN COALESCE (lpSelect.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax) 
                                              ELSE zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order)
                                         END)  AS BasisPrice_summ_disc_1
                                  , SUM (CASE WHEN COALESCE (lpSelect.DiscountTax,0) <> 0 THEN zfCalc_SummDiscountTax (zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax), 0) 
                                              ELSE zfCalc_SummDiscountTax ( zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order), lpSelect.DiscountNextTax_order)
                                         END) AS BasisPrice_summ_disc_2
                                    -- со ВСЕМИ Скидками с НДС
                                  , SUM (CASE WHEN COALESCE (lpSelect.DiscountTax,0) <> 0 THEN zfCalc_SummWVATDiscountTax ( lpSelect.Sale_summ, lpSelect.DiscountTax, lpSelect.VATPercent) 
                                              ELSE zfCalc_SummWVATDiscountTax (zfCalc_SummDiscountTax (lpSelect.Sale_summ, lpSelect.DiscountTax_order)
                                                                        , lpSelect.DiscountNextTax_order
                                                                        , lpSelect.VATPercent)
                                         END) AS BasisPriceWVAT_summ_disc                                  

                                  , 0 AS DiscountTax
                                  , 0 AS DiscountNextTax
                                  , 0 AS DiscountTax_opt

                                  , lpSelect.VATPercent

                                    -- Цена продажи НЕ из истории??? - без НДС - опции
                                  , SUM (lpSelect.Sale_summ)     AS BasisPrice_summ

                             FROM tmpProdOptItems AS lpSelect
                                --LEFT JOIN tmpReceiptProdModelChild_all ON tmpReceiptProdModelChild_all.MovementId_OrderClient = lpSelect.MovementId_OrderClient
                                --                                      AND tmpReceiptProdModelChild_all.ProductId              = lpSelect.ProductId
                                --                                      AND tmpReceiptProdModelChild_all.ProdColorPatternId     = lpSelect.ProdColorPatternId
                                --                                      AND tmpReceiptProdModelChild_all.ProdColorPatternId     > 0

                             GROUP BY lpSelect.MovementId_OrderClient
                                    , lpSelect.ProductId
                                    , lpSelect.VATPercent
                            )
                 -- РАСЧЕТ стоимости с учетом СКИДКИ - у Лодки
               , tmpCalc AS (-- 1.1. Базовая - ВСЯ
                             SELECT tmpCalc_all.MovementId_OrderClient
                                  , tmpCalc_all.ProductId
                                  , tmpCalc_all.isBasis
                                  , tmpCalc_all.EKPrice_summ
                                   -- Цена продажи из истории??? - без НДС
                                  , tmpCalc_all.BasisPrice_summ
                                    -- с учетом % скидки №1 - без НДС
                                  , (zfCalc_SummDiscountTax     (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax)) AS BasisPrice_summ_disc_1
                                    -- с учетом % скидки №2 - без НДС
                                  , (zfCalc_SummDiscountTax     (zfCalc_SummDiscountTax (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax), tmpCalc_all.DiscountNextTax)) AS BasisPrice_summ_disc_2
                                    -- Сумма продажи с НДС - с учетом ВСЕХ скидок
                                  , (zfCalc_SummWVATDiscountTax (zfCalc_SummDiscountTax (tmpCalc_all.BasisPrice_summ, tmpCalc_all.DiscountTax), tmpCalc_all.DiscountNextTax, tmpCalc_all.VATPercent)) AS BasisPriceWVAT_summ_disc
                             FROM tmpCalc_all
                             WHERE tmpCalc_all.isBasis = TRUE

                            UNION ALL
                             -- 1.2. Опции
                             SELECT tmpCalc_all.MovementId_OrderClient
                                  , tmpCalc_all.ProductId
                                  , tmpCalc_all.isBasis
                                  , tmpCalc_all.EKPrice_summ
                                  , tmpCalc_all.BasisPrice_summ
                                    -- с учетом % скидки №1 - без НДС
                                  , tmpCalc_all.BasisPrice_summ_disc_1
                                    -- с учетом % скидки №1+2 - без НДС
                                  , tmpCalc_all.BasisPrice_summ_disc_2
                                    -- Сумма продажи с НДС - с учетом ВСЕХ скидок
                                  , tmpCalc_all.BasisPriceWVAT_summ_disc
                             FROM tmpCalc_all
                             WHERE tmpCalc_all.isBasis = FALSE
                            )

   , tmpResAll AS(SELECT Object_Product.MovementId_OrderClient
                       , Object_Product.Id               AS Id
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
                       , ROW_NUMBER() OVER (ORDER BY CASE WHEN Object_Product.NPP > 0 AND Object_Product.StatusId <> zc_Enum_Status_Erased() THEN 0 ELSE 1 END
                                                   , ObjectDate_DateBegin.ValueData
                                                   , Object_Product.NPP
                                                   , Object_Product.OperDate
                                           ) :: Integer AS NPP_2
                       , Object_Product.StatusId

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
                       , (Object_Brand.ValueData || ' ' || Object_Model.ValueData) ::TVarChar AS ModelName_full

                       , Object_Engine.Id                AS EngineId
                       , Object_Engine.ValueData         AS EngineName

                       , Object_ReceiptProdModel.Id        AS ReceiptProdModelId
                       , Object_ReceiptProdModel.ValueData AS ReceiptProdModelName

                       , Object_Insert.ValueData         AS InsertName
                       , ObjectDate_Insert.ValueData     AS InsertDate
                       --, CASE WHEN COALESCE (ObjectDate_DateSale.ValueData, zc_DateStart()) = zc_DateStart() THEN FALSE ELSE TRUE END ::Boolean AS isSale
                       , Object_Product.isSale ::Boolean AS isSale
                       , Object_Product.isErased         AS isErased

                       --, COALESCE (ObjectBoolean_BasicConf.ValueData, FALSE) :: Boolean AS isBasicConf
                       , Object_Product.isBasicConf      AS isBasicConf
                       , Object_Product.isReserve        AS isReserve

                         -- Цена продажи с сайта - без НДС, Basis+options
                       , Object_Product.OperPrice_load
                         -- Сумма транспорт с сайта
                       , Object_Product.TransportSumm_load
                         -- Сумма транспорт
                       , Object_Product.TransportSumm
                         -- Базовая цена продажи модели с сайта
                       , Object_Product.BasisPrice_load

                         -- Скидка (ввод) - Cумма откорректированной скидки, без НДС
                       , Object_Product.SummTax

                   FROM tmpProduct AS Object_Product
                        LEFT JOIN tmpProdColorItems_find AS tmpProdColorItems_1
                                                         ON tmpProdColorItems_1.MovementId_OrderClient = Object_Product.MovementId_OrderClient
                                                        AND tmpProdColorItems_1.ProductId              = Object_Product.Id
                                                        AND tmpProdColorItems_1.NPP                    = 1
                        LEFT JOIN tmpProdColorItems_find AS tmpProdColorItems_2
                                                         ON tmpProdColorItems_2.MovementId_OrderClient = Object_Product.MovementId_OrderClient
                                                        AND tmpProdColorItems_2.ProductId              = Object_Product.Id
                                                        AND tmpProdColorItems_2.NPP                    = 2

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

     -- Проведенные Заказ производство и Производство-сборка
   , tmpMIFloat_MovementId AS (SELECT MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                    , Movement.DescId
                                    , Object.DescId AS ObjectDescId
                                    , MAX (Movement.Id) AS MovementId
                               FROM MovementItemFloat AS MIFloat_MovementId
                                    JOIN MovementItem ON MovementItem.Id       = MIFloat_MovementId.MovementItemId
                                                     AND MovementItem.isErased = FALSE
                                                     AND MovementItem.DescId   = zc_MI_Master()
                                    LEFT JOIN Object ON Object.Id = MovementItem.ObjectId
                                    JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.DescId   IN (zc_Movement_ProductionUnion(), zc_Movement_OrderInternal())

                               WHERE MIFloat_MovementId.MovementItemId = MovementItem.Id
                                 AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                 AND MIFloat_MovementId.ValueData IN (SELECT DISTINCT tmpResAll.MovementId_OrderClient :: TFloat FROM tmpResAll)
                               GROUP BY MIFloat_MovementId.ValueData :: Integer
                                      , Movement.DescId
                                      , Object.DescId
                              )

      -- ВСЕ счета
     , tmpInvoice AS (SELECT Movement.Id              AS MovementId_Invoice
                           , Movement.ParentId        AS MovementId_OrderClient
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Movement.StatusId
                             --
                           , MovementString_ReceiptNumber.ValueData  AS ReceiptNumber
                             --
                           , Object_InvoiceKind.Id                   AS InvoiceKindId
                           , Object_InvoiceKind.ValueData            AS InvoiceKindName
                             -- с НДС
                           , MovementFloat_Amount.ValueData          AS Amount
                             -- данные последнего счета
                             -- , ROW_NUMBER () OVER (PARTITION BY Movement.ParentId ORDER BY Movement.Id DESC) AS Ord
                      FROM Movement
                           LEFT JOIN MovementFloat AS MovementFloat_Amount
                                                   ON MovementFloat_Amount.MovementId = Movement.Id
                                                  AND MovementFloat_Amount.DescId     = zc_MovementFloat_Amount()
                           LEFT JOIN MovementString AS MovementString_ReceiptNumber
                                                    ON MovementString_ReceiptNumber.MovementId = Movement.Id
                                                   AND MovementString_ReceiptNumber.DescId     = zc_MovementString_ReceiptNumber()
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_InvoiceKind
                                                        ON MovementLinkObject_InvoiceKind.MovementId = Movement.Id
                                                       AND MovementLinkObject_InvoiceKind.DescId     = zc_MovementLinkObject_InvoiceKind()
                           LEFT JOIN Object AS Object_InvoiceKind ON Object_InvoiceKind.Id = MovementLinkObject_InvoiceKind.ObjectId

                      WHERE Movement.ParentId IN (SELECT DISTINCT tmpResAll.MovementId_OrderClient FROM tmpResAll)
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId   = zc_Movement_Invoice()
                     )

       -- данные по оплате ВСЕХ счетов
     , tmpBankAccount AS (SELECT tmpInvoice.MovementId_OrderClient   AS MovementId_OrderClient
                               , MAX (Movement_BankAccount.OperDate) AS OperDate
                               , MAX (Movement_BankAccount.Id)       AS MovementId_BankAccount
                               , SUM (MovementItem.Amount)           AS Amount
                          FROM tmpInvoice
                               INNER JOIN MovementLinkMovement ON MovementLinkMovement.MovementChildId = tmpInvoice.MovementId_Invoice
                                                              AND MovementLinkMovement.DescId          = zc_MovementLinkMovement_Invoice()
                               INNER JOIN Movement AS Movement_BankAccount
                                                   ON Movement_BankAccount.Id       = MovementLinkMovement.MovementId
                                                  AND Movement_BankAccount.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement_BankAccount.DescId   = zc_Movement_BankAccount()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement_BankAccount.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                          GROUP BY tmpInvoice.MovementId_OrderClient
                         )

     -- Результат
    SELECT
           (tmpResAll.Id :: TVarChar || '_' || tmpResAll.MovementId_OrderClient :: TVarChar) :: TVarChar KeyId
         , tmpResAll.Id
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

         , tmpOrderClient.FromId            AS ClientId
         , tmpOrderClient.FromCode          AS ClientCode
         , tmpOrderClient.FromName          AS ClientName
         , tmpOrderClient.MovementId        AS MovementId_OrderClient
         , tmpOrderClient.OperDate          AS OperDate_OrderClient
         , zfCalc_InvNumber_isErased ('', tmpOrderClient.InvNumber, tmpOrderClient.OperDate, tmpOrderClient.StatusId) AS InvNumberFull_OrderClient
         , tmpOrderClient.InvNumber         AS InvNumber_OrderClient
         , tmpOrderClient.StatusCode        AS StatusCode_OrderClient
         , tmpOrderClient.StatusName        AS StatusName_OrderClient
         , tmpOrderClient.InfoMoneyId       AS InfoMoneyId_Client
         , tmpOrderClient.InfoMoneyName_all AS InfoMoneyName_Client
           -- % НДС Заказ клиента
         , tmpOrderClient.VATPercent             AS TaxKind_Value_Client       --заказ клиента
         , Object_TaxKind.ValueData              AS TaxKindName_Client         --заказ клиента
         , ObjectString_TaxKind_Info.ValueData   AS TaxKindName_info_Client    --заказ клиента

           -- данные последнего счета
         , tmpInvoice.MovementId_Invoice  :: Integer  AS MovementId_Invoice
         , zfCalc_InvNumber_two_isErased ('', tmpInvoice.InvNumber, tmpInvoice.ReceiptNumber, tmpInvoice.OperDate, tmpInvoice.StatusId) AS InvNumberFull_Invoice
         , zfConvert_StringToNumber_null (tmpInvoice.ReceiptNumber) AS ReceiptNumber_Invoice
         , tmpInvoice.Amount              :: TFloat   AS Amount_Invoice
         , tmpInvoice.InvoiceKindId
         , tmpInvoice.InvoiceKindName

           -- последняя оплата
         , tmpBankAccount.MovementId_BankAccount ::Integer
           -- Итого оплата
         , tmpBankAccount.OperDate               ::TDateTime AS OperDate_BankAccount
         , tmpBankAccount.Amount                 ::TFloat    AS Amount_BankAccount

           -- ДОЛГ
         , (COALESCE (tmpCalc_1.BasisPriceWVAT_summ_disc, 0) + COALESCE (tmpCalc_2.BasisPriceWVAT_summ_disc, 0)
            -- минус Скидка (ввод)
          - zfCalc_SummWVAT (tmpResAll.SummTax, tmpOrderClient.VATPercent)
            -- плюс Транспорт
          + zfCalc_SummWVAT (tmpResAll.TransportSumm_load, tmpOrderClient.VATPercent)
          + zfCalc_SummWVAT (tmpResAll.TransportSumm, tmpOrderClient.VATPercent)
            -- минус оплаты
          - COALESCE (tmpBankAccount.Amount, 0)
           ) :: TFloat AS Amount_Debt

           --
         , tmpOrderClient.NPP    :: Integer AS NPP_OrderClient
           --
         , CASE WHEN tmpOrderClient.NPP > 0 AND tmpResAll.StatusId <> zc_Enum_Status_Erased() THEN tmpResAll.NPP_2 ELSE 0 END :: Integer AS NPP_2

         , tmpResAll.InsertName
         , tmpResAll.InsertDate
         , tmpResAll.isSale

           -- ИТОГО Сумма вх. без НДС (Basis)
         , tmpCalc_1.EKPrice_summ          :: TFloat AS EKPrice_summ1
           -- ИТОГО Сумма вх. без НДС (options)
         , tmpCalc_2.EKPrice_summ          :: TFloat AS EKPrice_summ2
           -- ИТОГО Сумма вх. без НДС (Basis+options)
         , (COALESCE (tmpCalc_1.EKPrice_summ, 0) + COALESCE (tmpCalc_2.EKPrice_summ, 0)) :: TFloat AS EKPrice_summ

           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis)
         , tmpCalc_1.BasisPrice_summ_disc_2     :: TFloat AS Basis_summ1
           -- ИТОГО Сумма продажи без НДС - без Скидки (Basis)
         , tmpCalc_1.BasisPrice_summ       :: TFloat AS Basis_summ1_orig

           -- ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (options)
         , tmpCalc_2.BasisPrice_summ_disc_2     :: TFloat AS Basis_summ2
           -- ИТОГО Сумма продажи без НДС - без Скидки (options)
         , tmpCalc_2.BasisPrice_summ       :: TFloat AS Basis_summ2_orig

           -- 1.*Total LP (Basis + Opt) - ИТОГО БЕЗ учета скидки и Транспорта, Сумма продажи без НДС
         , (COALESCE (tmpCalc_1.BasisPrice_summ, 0)          + COALESCE (tmpCalc_2.BasisPrice_summ, 0))        :: TFloat AS Basis_summ_orig
           -- 2.***Total LP - ИТОГО с учетом всех % скидок, без Транспорта, Сумма продажи без НДС
         , (COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0)   + COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)) :: TFloat AS Basis_summ

           -- 4. Total LP - ИТОГО Сумма продажи без НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
         , (COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0) + COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)
            -- минус Скидка (ввод)
          - COALESCE (tmpResAll.SummTax, 0)
            -- плюс Транспорт
          + COALESCE (tmpResAll.TransportSumm_load, 0)+ COALESCE (tmpResAll.TransportSumm, 0)
           ) :: TFloat AS Basis_summ_transport

           -- 5.Total LP + Vat - ИТОГО Сумма продажи с НДС - со ВСЕМИ Скидками (Basis+options) + TRANSPORT
         , (COALESCE (tmpCalc_1.BasisPriceWVAT_summ_disc, 0) + COALESCE (tmpCalc_2.BasisPriceWVAT_summ_disc, 0)
            -- минус Скидка (ввод)
          - zfCalc_SummWVAT (tmpResAll.SummTax, tmpOrderClient.VATPercent)
            -- плюс Транспорт
          + zfCalc_SummWVAT (tmpResAll.TransportSumm_load, tmpOrderClient.VATPercent)
          + zfCalc_SummWVAT (tmpResAll.TransportSumm, tmpOrderClient.VATPercent)
           ) :: TFloat AS BasisWVAT_summ_transport

           -- Цена продажи с сайта - без НДС, Basis+options
         , tmpResAll.OperPrice_load     :: TFloat AS OperPrice_load
           -- Базовая цена продажи модели с сайта
         , tmpResAll.BasisPrice_load    :: TFloat AS BasisPrice_load
           -- Сумма транспорт с сайта
         , tmpResAll.TransportSumm_load :: TFloat AS TransportSumm_load  
         , tmpResAll.TransportSumm      :: TFloat AS TransportSumm

           -- ИТОГО Сумма Скидка № 1 (Basis) - без НДС
         , (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_1, 0)) :: TFloat AS SummDiscount1

           -- ИТОГО Сумма Скидка № 2 (Basis) - без НДС
         , (-- скидка № 1 + 2
            (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0))
            -- минус скидка № 1
          - (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_1, 0))
           ) :: TFloat AS SummDiscount2

           -- ИТОГО Сумма Скидка № 1 (options) - без НДС
         , (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_1, 0)) :: TFloat AS SummDiscount1_opt
 
           -- ИТОГО Сумма Скидка № 2 (options) - без НДС
         , (-- скидка № 1 + 2
          ( COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0))
            -- минус скидка № 1
          - (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_1, 0))
           ) :: TFloat AS SummDiscount2_opt


           -- ИТОГО Сумма Скидка № 1+2 (options) - без НДС
         , (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)) :: TFloat AS SummDiscount3_opt
         , (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)) :: TFloat AS SummDiscount3

           -- ***Скидка % итого - Сумма скидки по всем % скидки
         , (-- итоговая скидка (Basis)
            (COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0))
            -- плюс итоговая скидка (options)
          + (COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0))
           ) :: TFloat AS SummDiscount

           -- Скидка (ввод) - Cумма откорректированной скидки, без НДС (доп.скидка)
         , tmpResAll.SummTax :: TFloat AS SummTax

            -- Скидка ИТОГО
         , (-- итоговая скидка (Basis)
            COALESCE (tmpCalc_1.BasisPrice_summ, 0) - COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0)
            -- плюс итоговая скидка (options)
          + COALESCE (tmpCalc_2.BasisPrice_summ, 0) - COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)
            -- плюс Скидка (ввод)
          + COALESCE (tmpResAll.SummTax, 0)
           ) :: TFloat AS SummDiscount_total

           -- 4.Cумма после скидки (расчет) - ИТОГО с учетом всех скидок, без Транспорта, Сумма продажи без НДС
         , (COALESCE (tmpCalc_1.BasisPrice_summ_disc_2, 0) + COALESCE (tmpCalc_2.BasisPrice_summ_disc_2, 0)
            -- минус Скидка (ввод)
          - COALESCE (tmpResAll.SummTax, 0)
           ) :: TFloat AS Basis_summ_calc

         , tmpResAll.isBasicConf
         , tmpResAll.isReserve

           -- Состояние
         , zfCalc_Order_State (tmpResAll.isSale
                             , CASE WHEN tmpOrderClient.StatusId = zc_Enum_Status_Complete()
                                         THEN tmpOrderClient.NPP
                                    WHEN tmpOrderClient.StatusId = zc_Enum_Status_UnComplete()
                                         THEN 0
                                    ELSE -1
                               END :: Integer
                             , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                             , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                             , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                             , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                              ) AS StateText
           -- все состояния подсветить
     /*    , CASE WHEN tmpResAll.isSale THEN zc_Color_Lime()
                -- если состояние готова то выделяем фоном
                WHEN COALESCE (tmpOrderClient.NPP,0) > 0 AND tmpOrderInternal_1.MovementId_OrderClient IS NOT NULL AND tmpProductionUnion_1.MovementId_OrderClient IS NOT NULL THEN zc_Color_GreenL()
                ELSE
                    -- нет цвета
                    zc_Color_White()
           END :: Integer AS StateColor */
         , zfCalc_Order_State_color (tmpResAll.isSale
                                   , CASE WHEN tmpOrderClient.StatusId = zc_Enum_Status_Complete()
                                               THEN tmpOrderClient.NPP
                                          WHEN tmpOrderClient.StatusId = zc_Enum_Status_UnComplete()
                                               THEN 0
                                          ELSE -1
                                     END :: Integer
                                   , COALESCE (tmpOrderInternal_1.MovementId, tmpOrderInternal_2.MovementId)
                                   , COALESCE (tmpProductionUnion_1.MovementId, tmpProductionUnion_2.MovementId)
                                   , COALESCE (tmpOrderInternal_1.ObjectDescId, tmpOrderInternal_2.ObjectDescId)
                                   , COALESCE (tmpProductionUnion_1.ObjectDescId, tmpProductionUnion_2.ObjectDescId)
                                    ) :: Integer AS StateColor

         , tmpResAll.isErased

     FROM tmpResAll
          LEFT JOIN tmpCalc AS tmpCalc_1 ON tmpCalc_1.MovementId_OrderClient = tmpResAll.MovementId_OrderClient AND tmpCalc_1.ProductId = tmpResAll.Id AND tmpCalc_1.isBasis = TRUE
          LEFT JOIN tmpCalc AS tmpCalc_2 ON tmpCalc_2.MovementId_OrderClient = tmpResAll.MovementId_OrderClient AND tmpCalc_2.ProductId = tmpResAll.Id AND tmpCalc_2.isBasis = FALSE

          LEFT JOIN tmpOrderClient ON  tmpOrderClient.MovementId = tmpResAll.MovementId_OrderClient AND tmpOrderClient.ProductId = tmpResAll.Id

          LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_1   ON tmpOrderInternal_1.MovementId_OrderClient   = tmpResAll.MovementId_OrderClient AND tmpOrderInternal_1.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_1.ObjectDescId   = zc_Object_Product()
          LEFT JOIN tmpMIFloat_MovementId AS tmpOrderInternal_2   ON tmpOrderInternal_2.MovementId_OrderClient   = tmpResAll.MovementId_OrderClient AND tmpOrderInternal_2.DescId   = zc_Movement_OrderInternal()   AND tmpOrderInternal_2.ObjectDescId   = zc_Object_Goods()
          LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_1 ON tmpProductionUnion_1.MovementId_OrderClient = tmpResAll.MovementId_OrderClient AND tmpProductionUnion_1.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_1.ObjectDescId = zc_Object_Product()
          LEFT JOIN tmpMIFloat_MovementId AS tmpProductionUnion_2 ON tmpProductionUnion_2.MovementId_OrderClient = tmpResAll.MovementId_OrderClient AND tmpProductionUnion_2.DescId = zc_Movement_ProductionUnion() AND tmpProductionUnion_2.ObjectDescId = zc_Object_Goods()

          /*LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                               ON ObjectLink_TaxKind.ObjectId = tmpOrderClient.FromId
                              AND ObjectLink_TaxKind.DescId = zc_ObjectLink_Client_TaxKind()
          */                     
          LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = tmpOrderClient.TaxKindId --ObjectLink_TaxKind.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_TaxKind_Info
                                 ON ObjectString_TaxKind_Info.ObjectId = Object_TaxKind.Id 
                                AND ObjectString_TaxKind_Info.DescId = zc_ObjectString_TaxKind_Info()

          -- данные Счета
          LEFT JOIN MovementLinkMovement AS MLM_Invoice
                                         ON MLM_Invoice.MovementId = tmpResAll.MovementId_OrderClient
                                        AND MLM_Invoice.DescId     = zc_MovementLinkMovement_Invoice()
          LEFT JOIN tmpInvoice ON tmpInvoice.MovementId_Invoice = MLM_Invoice.MovementChildId

          -- Итого оплата
          LEFT JOIN tmpBankAccount ON tmpBankAccount.MovementId_OrderClient = tmpResAll.MovementId_OrderClient
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.04.24         *
 18.05.23         * add inMovementId_OrderClient
 05.02.23         *
 04.01.21         *
 08.10.20         *
*/

/*
 -- исправляются суммы журнал/лодки
 SELECT  *
    --, lpInsertUpdate_MovementFloat_TotalSumm_order (MovementId_OrderClient_2)
 FROM (SELECT gpSelect.Basis_summ, gpSelect.Basis_summ_orig, gpSelect.Basis_summ1_orig
            , gpSelect.*
            , MovementId_OrderClient AS MovementId_OrderClient_2
            --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice(), MovementItem.Id, gpSelect.Basis_summ)
            --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), MovementItem.Id, gpSelect.Basis_summ_orig)
            --, lpInsertUpdate_MovementItemFloat (zc_MIFloat_BasisPrice(), MovementItem.Id, gpSelect.Basis_summ1_orig)

       FROM gpSelect_Object_Product (0, FALSE, FALSE, '5' :: TVarChar) AS gpSelect
            INNER JOIN MovementItem ON MovementItem.MovementId = MovementId_OrderClient
                                   AND MovementItem.DescId     IN (zc_MI_Master())
                                   AND MovementItem.isErased   = false

            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
            LEFT JOIN MovementItemFloat AS MIFloat_BasisPrice
                                        ON MIFloat_BasisPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_BasisPrice.DescId         = zc_MIFloat_BasisPrice()

       WHERE MIFloat_OperPrice.ValueData      <> gpSelect.Basis_summ
          OR MIFloat_OperPriceList.ValueData  <> gpSelect.Basis_summ_orig
          OR MIFloat_BasisPrice.ValueData     <> gpSelect.Basis_summ1_orig
      ) as tmp
*/

-- тест
--
-- SELECT * FROM gpSelect_Object_Product (254225, false, true, zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Object_Product (254225, false, false, zfCalc_UserAdmin())
