-- Function: gpSelect_Object_ReceiptProdModelChild_Goods()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_Goods (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelChild_Goods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelChild_Goods(
    IN inReceiptLevelId  Integer,
    IN inIsErased        Boolean,       -- признак показать удаленные да / нет
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor

AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbPriceWithVAT Boolean;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptProdModelChild());
     vbUserId:= lpGetUserBySession (inSession);


     -- Определили
     vbPriceWithVAT:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());


     -- Цены
     CREATE TEMP TABLE tmpPriceBasis ON COMMIT DROP AS
       (SELECT tmp.GoodsId
             , tmp.ValuePrice
        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                 , inOperDate   := CURRENT_DATE) AS tmp
       -- было когда не было цен на работы/услуги
       --UNION
       -- SELECT Object.Id, 1 AS ValuePrice FROM Object WHERE Object.DescId = zc_Object_ReceiptService()
       );


     -- элементы ReceiptProdModelChild
     CREATE TEMP TABLE tmpReceiptProdModelChild ON COMMIT DROP AS
       (SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
             , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
             , Object_ReceiptProdModelChild.ObjectCode   AS ObjectCode
             , Object_ReceiptProdModelChild.ValueData    AS ValueData
             , Object_ReceiptProdModelChild.isErased     AS isErased
               -- элемент который будем раскладывать
             , ObjectLink_Object.ChildObjectId           AS ObjectId
               -- значение
             , COALESCE (ObjectFloat_Value.ValueData, 0) / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END :: TFloat AS Value
             , COALESCE (ObjectFloat_ForCount.ValueData,0) AS ForCount

               -- Цена вх. без НДС
             , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
               -- Цена вх. с НДС
             , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0), ObjectFloat_TaxKind_Value.ValueData ) :: TFloat AS EKPriceWVAT

        FROM Object AS Object_ReceiptProdModelChild

             LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                  ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()

             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()

             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                  ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                 AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

             LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                   ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()
             LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                   ON ObjectFloat_ForCount.ObjectId = Object_ReceiptProdModelChild.Id
                                  AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptProdModelChild_ForCount()

             LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                   ON ObjectFloat_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                  AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                -- цены для Работы/Услуги вход. без НДС
             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                   ON ObjectFloat_ReceiptService_EKPrice.ObjectId = ObjectLink_Object.ChildObjectId
                                  AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                -- цены для Работы/Услуги продажи без НДС
             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                   ON ObjectFloat_ReceiptService_SalePrice.ObjectId = ObjectLink_Object.ChildObjectId
                                  AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() -- COALESCE (ObjectLink_Goods_TaxKind.ChildObjectId, ObjectLink_ReceiptService_TaxKind.ChildObjectId)
                                  AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()

        WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
          AND (Object_ReceiptProdModelChild.isErased = FALSE OR inIsErased = TRUE)
        --AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)
       );

     -- раскладываем ReceiptProdModelChild                                                                                Article_all
     CREATE TEMP TABLE tmpReceiptGoodsChild ON COMMIT DROP AS
       (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
             , Object_Goods.Id                       AS GoodsId
             , Object_Goods.ObjectCode               AS GoodsCode
             , Object_Goods.ValueData                AS GoodsName

             , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
             , Object_GoodsGroup.ValueData           AS GoodsGroupName
             , ObjectString_Article.ValueData        AS Article
             , Object_ProdColor.ValueData            AS ProdColorName
             , Object_Measure.ValueData              AS MeasureName

             , Object_Partner.ValueData              AS PartnerName
             , Object_Unit.ValueData                 AS UnitName

             , ROW_NUMBER() OVER (PARTITION BY tmpReceiptProdModelChild.ReceiptProdModelChildId ORDER BY Object_ReceiptGoodsChild.Id ASC) :: Integer AS NPP

               -- умножили
             , CASE WHEN (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END) = 0 THEN NULL
                    ELSE (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END) 
               END:: NUMERIC (16, 8) AS Value
             , COALESCE (ObjectFloat_ForCount.ValueData,0) AS ForCount

               -- Цена вх. без НДС
             , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0) :: TFloat AS EKPrice
               -- Цена вх. с НДС
             , zfCalc_SummWVAT (COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0), ObjectFloat_TaxKind_Value.ValueData) :: TFloat AS EKPriceWVAT

               -- Сумма вх. без НДС
             , zfCalc_SummIn (tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                            , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                            , 1) :: TFloat AS EKPrice_summ
               -- Сумма вх. с НДС
             , zfCalc_SummWVAT (zfCalc_SummIn ( tmpReceiptProdModelChild.Value * COALESCE (ObjectFloat_Value.ValueData, 0) / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END
                                              , COALESCE (ObjectFloat_EKPrice.ValueData, ObjectFloat_ReceiptService_EKPrice.ValueData, 0)
                                              , 1)
                              , ObjectFloat_TaxKind_Value.ValueData) :: TFloat AS EKPriceWVAT_summ

        FROM tmpReceiptProdModelChild
             -- нашли его в сборке узлов
             INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                   ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpReceiptProdModelChild.ObjectId
                                  AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
             -- это главный шаблон
             INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                      ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                     AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                     AND ObjectBoolean_Main.ValueData = TRUE
             -- из чего состоит
             INNER JOIN ObjectLink AS ObjectLink_ReceiptGoodsChild_ReceiptGoods
                                   ON ObjectLink_ReceiptGoodsChild_ReceiptGoods.ChildObjectId = ObjectLink_ReceiptGoods_Object.ObjectId
                                  AND ObjectLink_ReceiptGoodsChild_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
             -- не удален
             INNER JOIN Object AS Object_ReceiptGoodsChild ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                                          AND Object_ReceiptGoodsChild.isErased = FALSE
             -- Комплектующие / Работы/Услуги
             LEFT JOIN ObjectLink AS ObjectLink_Object
                                  ON ObjectLink_Object.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
             -- с этой структурой
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                 AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
             -- значение в сборке
             LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                   ON ObjectFloat_Value.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                  AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value()
             LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                   ON ObjectFloat_ForCount.ObjectId = ObjectLink_ReceiptGoodsChild_ReceiptGoods.ObjectId
                                  AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                                  
             -- !!!с этой структурой!!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

             --
             LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                    ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                   AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = Object_Goods.Id
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                  ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                                  ON ObjectLink_Goods_Unit.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Unit.DescId   = zc_ObjectLink_Goods_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Goods_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                  ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                   ON ObjectFloat_EKPrice.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                -- цены для Работы/Услуги вход. без НДС
             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_EKPrice
                                   ON ObjectFloat_ReceiptService_EKPrice.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_ReceiptService_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()
                -- цены для Работы/Услуги продажи без НДС
             LEFT JOIN ObjectFloat AS ObjectFloat_ReceiptService_SalePrice
                                   ON ObjectFloat_ReceiptService_SalePrice.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_ReceiptService_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

             LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                   ON ObjectFloat_TaxKind_Value.ObjectId = zc_Enum_TaxKind_Basis() --Object_TaxKind.Id
                                  AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()

        -- без этой структуры
        -- WHERE ObjectLink_ProdColorPattern.ChildObjectId IS NULL
       );


     CREATE TEMP TABLE tmpChild ON COMMIT DROP AS
       (SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
               -- Цена без НДС
             , tmpReceiptProdModelChild.EKPrice
               -- Цена вх. с НДС
             , tmpReceiptProdModelChild.EKPriceWVAT
               --
             , zfCalc_SummIn (tmpReceiptProdModelChild.Value , tmpReceiptProdModelChild.EKPrice, 1)        :: TFloat AS EKPrice_summ
             , zfCalc_SummIn (tmpReceiptProdModelChild.Value , tmpReceiptProdModelChild.EKPriceWVAT, 1)    :: TFloat AS EKPriceWVAT_summ
             --
             , FALSE AS isReceiptGoods

        FROM tmpReceiptProdModelChild
             LEFT JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
        WHERE tmpReceiptGoodsChild.ReceiptProdModelChildId IS NULL

       UNION ALL
        SELECT tmpReceiptProdModelChild.ReceiptProdModelChildId
               -- Цена без НДС
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.EKPrice_summ)     / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS EKPrice
               -- Цена вх. с НДС
             , CASE WHEN tmpReceiptProdModelChild.Value > 0 THEN SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) / tmpReceiptProdModelChild.Value ELSE 0 END :: TFloat AS EKPriceWVAT
               --
             , SUM (tmpReceiptGoodsChild.EKPrice_summ)     :: TFloat AS EKPrice_summ
             , SUM (tmpReceiptGoodsChild.EKPriceWVAT_summ) :: TFloat AS EKPriceWVAT_summ
             --
             , TRUE AS isReceiptGoods
        FROM tmpReceiptProdModelChild
             INNER JOIN tmpReceiptGoodsChild ON tmpReceiptGoodsChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId
        GROUP BY tmpReceiptProdModelChild.ReceiptProdModelChildId
               , tmpReceiptProdModelChild.Value
       );

     CREATE TEMP TABLE tmpResult ON COMMIT DROP AS
       (     SELECT
           tmpReceiptProdModelChild.ReceiptProdModelChildId AS Id
         , ROW_NUMBER() OVER (PARTITION BY tmpReceiptProdModelChild.ReceiptProdModelId ORDER BY tmpReceiptProdModelChild.ReceiptProdModelChildId ASC) :: Integer AS NPP
         , tmpReceiptProdModelChild.ValueData               AS Comment

         , CASE WHEN ObjectDesc.Id = zc_Object_Goods()          THEN tmpReceiptProdModelChild.Value ELSE 0 END ::NUMERIC (16, 8)   AS Value
         , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN tmpReceiptProdModelChild.Value ELSE 0 END ::NUMERIC (16, 8)   AS Value_service
         , tmpReceiptProdModelChild.ForCount ::TFloat

         , tmpReceiptProdModelChild.ReceiptProdModelId

         , Object_ReceiptLevel.Id         ::Integer  AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData  ::TVarChar AS ReceiptLevelName

         , Object_Object.Id               ::Integer  AS ObjectId
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , Object_Object.ValueData        ::TVarChar AS ObjectName
         , ObjectDesc.ItemName            ::TVarChar AS DescName

         , Object_Insert.ValueData                    AS InsertName
         , Object_Update.ValueData                    AS UpdateName
         , ObjectDate_Insert.ValueData                AS InsertDate
         , ObjectDate_Update.ValueData                AS UpdateDate
         , tmpReceiptProdModelChild.isErased          AS isErased

         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
         , Object_ProdColor.ValueData                 AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName

         , Object_Partner.ValueData              AS PartnerName
         , Object_Unit.ValueData                 AS UnitName

         , tmpChild.EKPrice            :: TFloat AS EKPrice
         , tmpChild.EKPriceWVAT        :: TFloat AS EKPriceWVAT

         , tmpChild.EKPrice_summ       :: TFloat AS EKPrice_summ
         , tmpChild.EKPriceWVAT_summ   :: TFloat AS EKPriceWVAT_summ
         --         
         , 15138790 /*zc_Color_Pink()*/                       AS Color_value                          --  фон для Value
         
         , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN 15073510  -- малиновый
                WHEN Object_ReceiptLevel.Id = 32658 THEN zc_Color_Blue()       -- синий                   32658;1;"Boat"
                WHEN Object_ReceiptLevel.Id = 32851 THEN 3372543               -- оранжевый               32851;2;"Electric"
                WHEN Object_ReceiptLevel.Id = 32852 THEN 40704                 -- зеленый                 32852;3;"Engine"
                ELSE  zc_Color_Black()
           END                                   AS Color_Level                          --  цвет шрифта по ReceiptLevelId

         , tmpChild.isReceiptGoods = TRUE   AS Bold_isReceiptGoods                       --  если товар раскладывается, его выделить жирным цветом ???
     FROM tmpReceiptProdModelChild

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Update
                               ON ObjectLink_Update.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

          LEFT JOIN ObjectDate AS ObjectDate_Update
                               ON ObjectDate_Update.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()

          -- цены
          LEFT JOIN tmpChild ON tmpChild.ReceiptProdModelChildId = tmpReceiptProdModelChild.ReceiptProdModelChildId

          -- из чего состоит
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpReceiptProdModelChild.ObjectId
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                               ON ObjectLink_Goods_Partner.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Partner.DescId   = zc_ObjectLink_Goods_Partner()
          LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Unit
                               ON ObjectLink_Goods_Unit.ObjectId = Object_Object.Id
                              AND ObjectLink_Goods_Unit.DescId   = zc_ObjectLink_Goods_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Goods_Unit.ChildObjectId
       );

     -- Результат
     OPEN Cursor1 FOR
     WITH tmpProtocol AS (SELECT ObjectProtocol.*
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                          FROM ObjectProtocol
                          WHERE ObjectProtocol.ObjectId IN (SELECT tmpResult.Id FROM tmpResult)
                            AND ObjectProtocol.UserId <> 5 -- 139 Maxim
                         )
     SELECT tmpResult.*

          , ObjectString_Goods_Comment.ValueData AS Comment_goods

          , CASE WHEN 1=0 AND tmpProtocol.UserId = 139 -- Maxim
                      THEN TRUE
                 ELSE COALESCE (ObjectBoolean_Check.ValueData, FALSE)
            END :: Boolean AS isCheck
          , CASE WHEN COALESCE (ObjectBoolean_Check.ValueData, FALSE) = TRUE
                      THEN zc_Color_Blue()
                 ELSE zc_Color_Yelow()
            END AS Color_isCheck
          , tmpProtocol.OperDate  AS OperDate_protocol
          , Object_User.ValueData AS UserName_protocol
     FROM tmpResult
          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = tmpResult.Id
                               AND tmpProtocol.Ord      = 1
          LEFT JOIN Object AS Object_User ON Object_User.Id = tmpProtocol.UserId
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Check
                                  ON ObjectBoolean_Check.ObjectId = tmpResult.Id
                                 AND ObjectBoolean_Check.DescId   = zc_ObjectBoolean_Check()
          LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                 ON ObjectString_Goods_Comment.ObjectId = tmpResult.ObjectId
                                AND ObjectString_Goods_Comment.DescId   = zc_ObjectString_Goods_Comment()
     ;
     
     RETURN NEXT Cursor1;

     -- Результат
     OPEN Cursor2 FOR
     
     SELECT *
     FROM tmpReceiptGoodsChild;
     
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.12.20         * add ReceiptLevel
 09.12.20         *
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptProdModelChild_Goods (0,false, zfCalc_UserAdmin()); --FETCH ALL "<unnamed portal 89>";
