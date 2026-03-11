-- Function: gpSelect_Object_Products_effie

DROP FUNCTION IF EXISTS gpSelect_Object_Products_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Products_effie(
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS TABLE (extId                  TVarChar   -- Уникальный идентификатор продукта
             , globalCode             TVarChar   -- Глобальный код товара
             , productName            TVarChar   -- Название продукта
             , groupExtId             TVarChar   -- Идентификатор группы товаров
             , groupName              TVarChar   -- Название группы товаров
             , manufacturerId         TVarChar   -- Идентификатор производителя
             , manufacturerName       TVarChar   -- Название производителя
             , brandId                TVarChar   -- Идентификатор бренда
             , brandName              TVarChar   -- Название бренда
             , subBrandId             TVarChar   -- Идентификатор бренда
             , subBrandName           TVarChar   -- Название саб-бренда
             , categoryExtId          TVarChar   -- Идентификатор категории
             , categoryName           TVarChar   -- Название категории
             , subCategoryExtId       TVarChar   -- Идентификатор саб-категории
             , subCategoryName        TVarChar   -- Название саб-категории
             , subCategoryLineExtId   TVarChar   -- Идентификатор линейки
             , subCategoryLineName    TVarChar   -- Название линейки
             , unitId                 Integer    --"Id единицы измерения.Пример: 1 - метры, 2 - сантиметры, 3 - киллограммы, 4 - штуки, 5 - литры, 6 - граммы, 7 - денежные единици, 8 - декалитр (10л), 9 - упаковка"
             , additionalUnitId       Integer    -- Id единицы измерения.Пример: 4 - штуки при unitId 9 - упаковка"
             , typeId                 Integer    -- Id типа продукта. Пример: 1 - SKU, 2 - POSM, 3- ДМП
             , unitFactor             TFloat     -- 1 - Весовой/0 - невесовой товар
             , quantity               TFloat     -- Кол-во товара в единице измерения (для весового товара unitFactor= 1, количество будет равно 1)
             , length                 TFloat     -- Длина
             , width                  TFloat     -- Ширина
             , height                 TFloat     -- Высота
             , vatRate                TFloat     -- Размер НДС. Пример: 0.2
             , basePrice              TFloat     -- Базовая цена
             , needLicense            Boolean    -- Необходима ли продукту лицензия
             , ean                    TVarChar   -- EAN (Штрих код)
             , photoName              TVarChar   -- Название фото
             , photoChangeDateTime    TVarChar   -- Дата обновления фото
             , isCompetitor           Boolean    -- Признак компании производителя продукта: false - свой/true - чужой (в случае не заполнения поля будет проставлено false)
             , qntPerPack             TFloat     -- Кол-во в упаковке
             , qntPerCase             TFloat     -- Кол-во в коробке
             , qntPerPall             TFloat     -- Кол-во в паллете
             , multiplicity           TFloat     -- Кратность (кратно какому кол-ву можно набивать этот товар в заказе. Пример: Кратность 3 - можем набить 3 или 6 или 9 и т.д.)
             , sortId                 TFloat     -- Порядок сортировки продукта при формировании заказа
             , fullName               TVarChar   -- Полное название
             , enableSellByPack       Boolean    -- Продажа товаров упаковками false = Нет / true = да
             , IsPromoGift            Boolean    -- Подарочный товар false = Нет / true = да
             , minOrder               TFloat     -- Минимальное кол-во для заказа
             , grossWeight            TFloat     -- Вес товара, брутто (кг)
             , isDeleted              Boolean    -- Признак активности: false = активен / true = не активен
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
           WITH
           tmpGoodsByGoodsKind AS (SELECT DISTINCT
                                          ObjectLink_GoodsByGoodsKind_Goods.ObjectId                        AS ObjectId
                                        , ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId                   AS GoodsId
                                        , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                                   FROM Object AS Object_GoodsByGoodsKind
                                        JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                        ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                                       AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                       AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId > 0
                                        -- Ограничим - есть Вид товара
                                        INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                              ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                             AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
                                       --
                                        JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_Order
                                                           ON ObjectBoolean_GoodsByGoodsKind_Order.ObjectId  = Object_GoodsByGoodsKind.Id
                                                          AND ObjectBoolean_GoodsByGoodsKind_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                                          AND (ObjectBoolean_GoodsByGoodsKind_Order.ValueData = TRUE -- условие что разрешен
                                                            OR (ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     = 9505524 -- 457 - Сосиски ФІЛЕЙКИ вар 1 ґ ТМ Наші Ковбаси
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = 8344    -- Б/В 0,5кг
                                                              ))
                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsByGoodsKind_NotMobile
                                                                ON ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId  = Object_GoodsByGoodsKind.Id
                                                               AND ObjectBoolean_GoodsByGoodsKind_NotMobile.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()
                                                               AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ValueData = TRUE -- условие что НЕ разрешен

                                        -- Ограничим - если НЕ удален
                                        JOIN Object AS Object_Goods ON Object_Goods.Id       = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                                   AND Object_Goods.isErased = FALSE
                                        -- Ограничим - если НЕ удален
                                        JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id       = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId
                                                                       AND Object_GoodsKind.isErased = FALSE
                                        -- Ограничим - ТОЛЬКО если ГП
                                        LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                             ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                                            AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                        INNER JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                        AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                           , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                           , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                            )

                                   WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
                                     AND Object_GoodsByGoodsKind.isErased = FALSE
                                     AND ObjectBoolean_GoodsByGoodsKind_NotMobile.ObjectId IS NULL
                                  )

         , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId          AS GoodsId
                                          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId      AS GoodsKindId

                                          , ObjectString_BarCode.ValueData         AS BarCode

                                     FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                        INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                              ON ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                             AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = 83955

                                        LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                             ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                            AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                        LEFT JOIN Object AS Object_GoodsPropertyValue
                                                         ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                        AND Object_GoodsPropertyValue.DescId = zc_Object_GoodsPropertyValue()
                                                        AND Object_GoodsPropertyValue.isErased = FALSE

                                        LEFT JOIN ObjectString AS ObjectString_BarCode
                                                               ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                              AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                     WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                       AND COALESCE (ObjectString_BarCode.ValueData ,'') <> ''
                                    )


                   SELECT COALESCE(tmpGoodsByGoodsKind.ObjectId::TVarchar ,'') ::TVarChar AS extId
                        , (Object_Goods.ObjectCODE)                   ::TVarChar AS globalCode
                        , TRIM (Object_Goods.ValueData)               ::TVarChar AS productName
                        , COALESCE(Object_GoodsGroup.Id::TVarchar ,'')  ::TVarChar AS groupExtId
                        , TRIM (Object_GoodsGroup.ValueData ,'')      ::TVarChar AS groupName
                        , COALESCE(Object_GoodsPlatform.Id::TVarchar ,'')    ::TVarChar AS manufacturerId
                        , TRIM (COALESCE(Object_GoodsPlatform.ValueData,'')) ::TVarChar AS manufacturerName
                        , COALESCE(Object_TradeMark.Id ::TVarchar ,'')       ::TVarChar AS brandId
                        , TRIM (COALESCE(Object_TradeMark.ValueData,''))     ::TVarChar AS brandName
                        , COALESCE(Object_GoodsGroupDirection.Id::TVarchar ,'')    ::TVarChar AS subBrandId
                        , TRIM (COALESCE(Object_GoodsGroupDirection.ValueData,'')) ::TVarChar AS subBrandName
                        , COALESCE(Object_GoodsGroupPropertyParent.Id::TVarchar ,'')    ::TVarChar AS categoryExtId
                        , TRIM (COALESCE(Object_GoodsGroupPropertyParent.ValueData,'')) ::TVarChar AS categoryName
                        , COALESCE(Object_GoodsGroupProperty.Id::TVarchar ,'')          ::TVarChar AS subCategoryExtId
                        , TRIM (COALESCE(Object_GoodsGroupProperty.ValueData,''))       ::TVarChar AS subCategoryName
                        , COALESCE(Object_GoodsKind.Id::TVarchar ,'')                   ::TVarChar AS subCategoryLineExtId
                        , TRIM (COALESCE(Object_GoodsKind.ValueData,''))                ::TVarChar AS subCategoryLineName
                        , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 4 ELSE 3 END) ::Integer AS unitId
                        , 1 ::Integer AS additionalUnitId
                        , 1 ::Integer AS typeId
                        , (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN 0 ELSE 1 END) ::TFloat AS unitFactor
                        , 1   ::TFloat AS quantity
                        , 0   ::TFloat AS length
                        , 0   ::TFloat AS width
                        , 0   ::TFloat AS height
                        , 0.2 ::TFloat AS vatRate
                        , 0   ::TFloat AS basePrice
                        , FALSE ::Boolean AS needLicense
                        , tmpGoodsPropertyValue.BarCode ::TVarChar AS ean
                        , '' ::TVarChar AS photoName
                        , '' ::TVarChar AS photoChangeDateTime
                        , FALSE ::Boolean  AS isCompetitor
                        , 0     ::TFloat   AS qntPerPack
                        , 0     ::TFloat   AS qntPerCase
                        , 0     ::TFloat   AS qntPerPall
                        , 0     ::TFloat   AS multiplicity
                        , 0     ::TFloat   AS sortId
                        , (TRIM (Object_Goods.ValueData) || ' ' || TRIM (COALESCE(Object_GoodsKind.ValueData,''))) ::TVarChar AS fullName
                        , FALSE ::Boolean  AS enableSellByPack
                        , FALSE ::Boolean  AS IsPromoGift
                        , 0     ::TFloat   AS minOrder
                        , (COALESCE (ObjectFloat_Weight.ValueData,0) + COALESCE (ObjectFloat_WeightTare.ValueData,0)) ::TFloat AS grossWeight
                        , Object_Goods.isErased ::Boolean AS isDeleted

                   FROM tmpGoodsByGoodsKind
                        INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsByGoodsKind.GoodsId
                        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoodsByGoodsKind.GoodsKindId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                             ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                        LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                             ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
                        LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = ObjectLink_Goods_GoodsGroupDirection.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                             ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                        LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                             ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
                        LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                             ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                            AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                        LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = ObjectLink_GoodsGroupProperty_Parent.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                        LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                             ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                            AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()

                        LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                              ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                             AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                        LEFT JOIN ObjectFloat AS ObjectFloat_WeightTare
                                              ON ObjectFloat_WeightTare.ObjectId = Object_Goods.Id
                                             AND ObjectFloat_WeightTare.DescId   = zc_ObjectFloat_Goods_WeightTare()


                        LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.GoodsId = Object_Goods.Id
                                                       AND tmpGoodsPropertyValue.GoodsKindId = Object_GoodsKind.Id

                  --LIMIT 10
                  ;



END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Products_effie (zfCalc_UserAdmin()::TVarChar);
