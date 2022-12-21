-- Function: gpSelect_Object_ReceiptProdModelGoods_Print ()

DROP FUNCTION IF EXISTS gpSelect_Object_ReceiptProdModelGoods_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReceiptProdModelGoods_Print(
    IN inReceiptProdModelId           Integer   ,   --    
    IN inReceiptLevelId               Integer   ,   --    
    IN inSession                      TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
    DECLARE Cursor3 refcursor;

    DECLARE vbPriceWithVAT_pl    Boolean;
    DECLARE vbTaxKindValue_basis TFloat;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     -- Признак в Базовом Прайсе
     vbPriceWithVAT_pl:= (SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = zc_PriceList_Basis() AND ObjectBoolean.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     -- !!!Базовый % НДС!!!
     vbTaxKindValue_basis:= (SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = zc_Enum_TaxKind_Basis() AND OFl.DescId = zc_ObjectFloat_TaxKind_Value());


     -- Результат
     OPEN Cursor1 FOR

     SELECT
           Object_ReceiptProdModel.Id         AS Id
         , Object_ReceiptProdModel.ObjectCode AS Code
         , Object_ReceiptProdModel.ValueData  AS Name

         , ObjectString_Code.ValueData        ::TVarChar  AS UserCode
         --, ObjectBoolean_Main.ValueData       ::Boolean   AS isMain

         , Object_Model.Id           ::Integer  AS ModelId
         , Object_Model.ValueData    ::TVarChar AS ModelName
         , Object_Brand.Id                      AS BrandId
         , Object_Brand.ValueData               AS BrandName
         , Object_ProdEngine.Id                 AS EngineId
         , Object_ProdEngine.ValueData          AS EngineName


         , '' ::TVarChar AS ModelGroupName
         , ObjectFloat_Power.ValueData               ::TFloat   AS EnginePower
         , ObjectFloat_Volume.ValueData              ::TFloat   AS EngineVolume

         , tmpInfo.Footer1        ::TVarChar AS Footer1
         , tmpInfo.Footer2        ::TVarChar AS Footer2
         , tmpInfo.Footer3        ::TVarChar AS Footer3
         , tmpInfo.Footer4        ::TVarChar AS Footer4

     FROM Object AS Object_ReceiptProdModel
          LEFT JOIN ObjectString AS ObjectString_Code
                                 ON ObjectString_Code.ObjectId = Object_ReceiptProdModel.Id
                                AND ObjectString_Code.DescId = zc_ObjectString_ReceiptProdModel_Code()

          LEFT JOIN ObjectLink AS ObjectLink_Model
                               ON ObjectLink_Model.ObjectId = Object_ReceiptProdModel.Id
                              AND ObjectLink_Model.DescId = zc_ObjectLink_ReceiptProdModel_Model()
          LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Brand
                               ON ObjectLink_Brand.ObjectId = Object_Model.Id
                              AND ObjectLink_Brand.DescId = zc_ObjectLink_ProdModel_Brand()
          LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdEngine
                               ON ObjectLink_ProdEngine.ObjectId = Object_Model.Id
                              AND ObjectLink_ProdEngine.DescId = zc_ObjectLink_ProdModel_ProdEngine()
          LEFT JOIN Object AS Object_ProdEngine ON Object_ProdEngine.Id = ObjectLink_ProdEngine.ChildObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Power
                                ON ObjectFloat_Power.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Power.DescId = zc_ObjectFloat_ProdEngine_Power()
          LEFT JOIN ObjectFloat AS ObjectFloat_Volume
                                ON ObjectFloat_Volume.ObjectId = Object_ProdEngine.Id
                               AND ObjectFloat_Volume.DescId = zc_ObjectFloat_ProdEngine_Volume()

          LEFT JOIN Object_Product_PrintInfo_View AS tmpInfo ON 1=1

     WHERE Object_ReceiptProdModel.DescId = zc_Object_ReceiptProdModel()
      AND Object_ReceiptProdModel.Id = inReceiptProdModelId
          ;

     RETURN NEXT Cursor1;

     OPEN Cursor2 FOR  
     WITH
          -- элементы ReceiptProdModelChild
          tmpReceiptProdModelChild AS(SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId           AS ObjectId
                                             -- значение
                                           , ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                                      FROM Object AS Object_ReceiptProdModelChild

                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                                           -- из чего собирается
                                           LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                           -- шаблон ProdModel
                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                            -- значение в сборке
                                           LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                                 ON ObjectFloat_Value.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptProdModelChild_Value()
                                           LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                                 ON ObjectFloat_ForCount.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptProdModelChild_ForCount()
                                             
                                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                        AND Object_ReceiptProdModelChild.isErased = FALSE
                                        AND ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
                                        AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)
                                     )

          -- раскладываем ReceiptProdModelChild
        , tmpProdColorPattern            --tmpReceiptChild --
                              AS (SELECT tmpReceiptProdModelChild.ReceiptProdModelId     AS ReceiptProdModelId 
                                       , tmpReceiptProdModelChild.ReceiptProdModelChildId
                                       , Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                                       , Object_ReceiptGoodsChild.isErased               AS isErased
                                         -- если меняли на другой товар, не тот что в Boat Structure
                                       , ObjectLink_Object.ChildObjectId                 AS ObjectId
                                         -- нашли Элемент Boat Structure
                                       , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId    ---
                                         -- умножили
                                       , tmpReceiptProdModelChild.Value * ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
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
                                  AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()

             -- !!!с этой структурой!!!
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId

                                 )                     

    , tmpResult AS
      (SELECT
           tmpReceiptProdModelChild.ReceiptProdModelChildId AS Id
         , ROW_NUMBER() OVER (PARTITION BY tmpReceiptProdModelChild.ReceiptProdModelId ORDER BY tmpReceiptProdModelChild.ReceiptProdModelChildId ASC) :: Integer AS NPP
         , tmpReceiptProdModelChild.Value               AS Comment

         , CASE WHEN ObjectDesc.Id = zc_Object_Goods()          THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value
         , CASE WHEN ObjectDesc.Id = zc_Object_ReceiptService() THEN tmpReceiptProdModelChild.Value ELSE 0 END ::TFloat   AS Value_service

         , tmpReceiptProdModelChild.ReceiptProdModelId

         , Object_ReceiptLevel.Id         ::Integer  AS ReceiptLevelId
         , Object_ReceiptLevel.ValueData  ::TVarChar AS ReceiptLevelName

         , Object_Object.Id               ::Integer  AS ObjectId
         , Object_Object.ObjectCode       ::Integer  AS ObjectCode
         , Object_Object.ValueData        ::TVarChar AS ObjectName
         , ObjectDesc.ItemName            ::TVarChar AS DescName

         --
         , ObjectString_GoodsGroupFull.ValueData      AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData                AS GoodsGroupName
         , ObjectString_Article.ValueData             AS Article
         , zfCalc_Article_all (ObjectString_Article.ValueData) AS Article_all
         , Object_ProdColor.ValueData                 AS ProdColorName
         , Object_Measure.ValueData                   AS MeasureName
         , ObjectString_Goods_Comment.ValueData       AS GoodsComment

     FROM tmpReceiptProdModelChild

          LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                               ON ObjectLink_ReceiptLevel.ObjectId = tmpReceiptProdModelChild.ReceiptProdModelChildId
                              AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptLevel.ChildObjectId

          -- из чего состоит
          INNER JOIN Object AS Object_Object ON Object_Object.Id = tmpReceiptProdModelChild.ObjectId  AND  Object_Object.DescId = zc_Object_Goods()
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Object.DescId

          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Object.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Object.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectString AS ObjectString_Goods_Comment
                                 ON ObjectString_Goods_Comment.ObjectId = Object_Object.Id
                                AND ObjectString_Goods_Comment.DescId = zc_ObjectString_Goods_Comment()

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
       )
       
       , tmpPhoto AS (SELECT ObjectLink_GoodsPhoto_Goods.ChildObjectId AS GoodsId
                           , Object_GoodsPhoto.Id                      AS PhotoId
                           , Object_GoodsPhoto.ValueData               AS FileName
                           , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsPhoto_Goods.ChildObjectId ORDER BY Object_GoodsPhoto.Id) AS Ord
                      FROM Object AS Object_GoodsPhoto
                             JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
                                             ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
                                            AND ObjectLink_GoodsPhoto_Goods.DescId   = zc_ObjectLink_GoodsPhoto_Goods()
                                            AND ObjectLink_GoodsPhoto_Goods.ChildObjectId IN (SELECT DISTINCT tmpResult.ObjectId FROM tmpResult)
                       WHERE Object_GoodsPhoto.DescId   = zc_Object_GoodsPhoto()
                         AND Object_GoodsPhoto.isErased = FALSE
                     )

     SELECT 
 
          tmpResult.NPP
         --, tmpResult.Comment

         , tmpResult.Value
         , tmpResult.Value_service

         --, tmpResult.ReceiptLevelId
         , tmpResult.ReceiptLevelName

         , tmpResult.ObjectCode
         , tmpResult.ObjectName 
         , ObjectString_EAN.ValueData  AS EAN

         --
         , tmpResult.GoodsGroupNameFull
         , tmpResult.GoodsGroupName
         , tmpResult.Article
         , tmpResult.ProdColorName
         , tmpResult.MeasureName

         , ObjectBlob_GoodsPhoto_Data1.ValueData AS Photo1
         , tmpPhoto1.FileName AS FileName1
         , tmpResult.GoodsComment AS GoodsComment

     FROM tmpResult
          LEFT JOIN ObjectString AS ObjectString_EAN
                                 ON ObjectString_EAN.ObjectId = tmpResult.ObjectId
                                AND ObjectString_EAN.DescId = zc_ObjectString_EAN()

          LEFT JOIN tmpPhoto AS tmpPhoto1
                             ON tmpPhoto1.GoodsId = tmpResult.ObjectId
                            AND tmpPhoto1.Ord = 1
          LEFT JOIN ObjectBLOB AS ObjectBlob_GoodsPhoto_Data1
                               ON ObjectBlob_GoodsPhoto_Data1.ObjectId = tmpPhoto1.PhotoId   
     ;

     RETURN NEXT Cursor2;
     
     OPEN Cursor3 FOR  
          WITH -- справочные элементы Boat Structure
          -- элементы ReceiptProdModelChild
          tmpReceiptProdModelChild AS(SELECT ObjectLink_ReceiptProdModel.ChildObjectId AS ReceiptProdModelId
                                           , Object_ReceiptProdModelChild.Id           AS ReceiptProdModelChildId
                                             -- элемент который будем раскладывать
                                           , ObjectLink_Object.ChildObjectId           AS ObjectId
                                             -- значение
                                           , ObjectLink_ReceiptGoods.ObjectId          AS ReceiptGoodsId

                                           , (COALESCE(ObjectString_Article.ValueData, '')||
                                              CASE WHEN COALESCE(ObjectString_Article.ValueData, '') <> '' AND COALESCE(Object_Goods.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                                              COALESCE(Object_Goods.ValueData, '')):: TVarChar AS TitleReceipt
                                           
                                      FROM Object AS Object_ReceiptProdModelChild

                                           LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                                ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptProdModelChild.Id
                                                               AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()

                                           -- шаблон ProdModel
                                           INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                                 ON ObjectLink_ReceiptProdModel.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectLink_ReceiptProdModel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                           -- из чего собирается
                                           INNER JOIN ObjectLink AS ObjectLink_Object
                                                                 ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                                                AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                                                                
                                           -- Шаблон сборка Узла
                                           INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                                 ON ObjectLink_ReceiptGoods.ChildObjectId = ObjectLink_Object.ChildObjectId
                                                                AND ObjectLink_ReceiptGoods.DescId   = zc_ObjectLink_ReceiptGoods_Object()
                                           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Object.ChildObjectId
                                           
                                           LEFT JOIN ObjectString AS ObjectString_Article
                                                                  ON ObjectString_Article.ObjectId = Object_Goods.Id
                                                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

                                      WHERE Object_ReceiptProdModelChild.DescId   = zc_Object_ReceiptProdModelChild()
                                        AND Object_ReceiptProdModelChild.isErased = FALSE
                                        AND ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
                                        AND (ObjectLink_ReceiptLevel.ChildObjectId = inReceiptLevelId OR inReceiptLevelId = 0)
                                     )
        , tmpObject AS (SELECT ObjectLink_ReceiptGoods_ColorPattern.ObjectId   AS ReceiptGoodsId
                             , OL_ProdColorPattern_ColorPattern.ObjectId       AS ProdColorPatternId
                        FROM ObjectLink AS ObjectLink_ReceiptGoods_ColorPattern
                             -- получили Элементы Boat Structure
                             INNER JOIN ObjectLink AS OL_ProdColorPattern_ColorPattern
                                                   ON OL_ProdColorPattern_ColorPattern.ChildObjectId = ObjectLink_ReceiptGoods_ColorPattern.ChildObjectId
                                                  AND OL_ProdColorPattern_ColorPattern.DescId        = zc_ObjectLink_ProdColorPattern_ColorPattern() 
                             
                        WHERE ObjectLink_ReceiptGoods_ColorPattern.DescId = zc_ObjectLink_ReceiptGoods_ColorPattern()
                          AND ObjectLink_ReceiptGoods_ColorPattern.ObjectId in (SELECT DISTINCT tmpReceiptProdModelChild.ReceiptGoodsId FROM tmpReceiptProdModelChild)  
                          and 1 =0
                       )
          -- существующие элементы Boat Structure
        , tmpItems AS (SELECT Object_ReceiptGoodsChild.Id                     AS ReceiptGoodsChildId
                            , ObjectLink_ReceiptGoods.ChildObjectId           AS ReceiptGoodsId
                              -- Товар сборки
                            , ObjectLink_ObjectMain.ChildObjectId             AS GoodsMainId
                              -- если меняли на другой товар, не тот что в Boat Structure
                            , ObjectLink_Object.ChildObjectId                 AS ObjectId
                              -- нашли Элемент Boat Structure
                            , ObjectLink_ProdColorPattern.ChildObjectId       AS ProdColorPatternId
                              -- нашли Этап сборки
                            , ObjectLink_ReceiptLevel.ChildObjectId           AS ReceiptLevelId
                              -- нашли Комплектующие
                            , ObjectLink_GoodsChild.ChildObjectId             AS GoodsChildId
                              -- значение
                            , ObjectFloat_Value.ValueData / CASE WHEN ObjectFloat_ForCount.ValueData > 1 THEN ObjectFloat_ForCount.ValueData ELSE 1 END AS Value
                              --
                            , Object_ReceiptGoodsChild.ValueData              AS Comment
                            , Object_ReceiptGoodsChild.isErased               AS isErased

                       FROM Object AS Object_ReceiptGoodsChild  
                            INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                 ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                                AND ObjectLink_ReceiptGoods.ChildObjectId in (SELECT DISTINCT tmpReceiptProdModelChild.ReceiptGoodsId FROM tmpReceiptProdModelChild)  
                            LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                  ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                 AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                               --  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                            LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                                 ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                AND ObjectLink_ObjectMain.DescId   = zc_ObjectLink_ReceiptGoods_Object() 

                            LEFT JOIN ObjectLink AS ObjectLink_Object
                                                 ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object() 
                            -- значение в сборке
                            LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                  ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_Value.DescId = zc_ObjectFloat_ReceiptGoodsChild_Value()
                            LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                                  ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                                                 AND ObjectFloat_ForCount.DescId = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
                            -- Этап сборки
                            LEFT JOIN ObjectLink AS ObjectLink_ReceiptLevel
                                                 ON ObjectLink_ReceiptLevel.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel() 
                            -- 	Комплектующие
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                 ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild() 
                                                 
                                                 
                       WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                         AND Object_ReceiptGoodsChild.isErased = FALSE  
                         
                      )
          -- объединили все элементы Boat Structure
        , tmpProdColorPattern AS
                      (SELECT tmpItems.ReceiptGoodsChildId                                         AS ReceiptGoodsChildId
                            , tmpItems.GoodsMainId                                                 AS GoodsMainId
                            , tmpItems.ObjectId                                                    AS ObjectId
                            , COALESCE (tmpItems.ReceiptGoodsId, tmpObject.ReceiptGoodsId)         AS ReceiptGoodsId

                            , COALESCE (tmpItems.ProdColorPatternId, tmpObject.ProdColorPatternId) AS ProdColorPatternId
                              -- нашли Этап сборки
                            , tmpItems.ReceiptLevelId
                              -- нашли Комплектующие
                            , tmpItems.GoodsChildId

                            , tmpItems.Value                                                       AS Value
                            , tmpItems.Comment                                                     AS Comment
                            , COALESCE (tmpItems.isErased, FALSE)                                  AS isErased
                            , CASE WHEN tmpItems.ProdColorPatternId > 0 THEN TRUE ELSE FALSE END   AS isEnabled

                       FROM tmpItems
                            FULL JOIN tmpObject ON tmpObject.ReceiptGoodsId     = tmpItems.ReceiptGoodsId
                                               AND tmpObject.ProdColorPatternId = tmpItems.ProdColorPatternId
                      ),
          -- существующие элементы Boat Structure
          tmpItemsGoodsChild AS (SELECT DISTINCT ObjectLink_ReceiptGoods.ChildObjectId                     AS ReceiptGoodsId

                                 FROM Object AS Object_ReceiptGoodsChild  
                                      INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods
                                                            ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                      INNER JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                                            ON ObjectLink_ProdColorPattern.ObjectId      = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_ProdColorPattern.DescId        = zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern()
                                                         --  AND ObjectLink_ProdColorPattern.ChildObjectId > 0
                                      INNER JOIN ObjectLink AS ObjectLink_ObjectMain
                                                            ON ObjectLink_ObjectMain.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                           AND ObjectLink_ObjectMain.DescId   = zc_ObjectLink_ReceiptGoods_Object() 
                                      -- 	Комплектующие
                                      INNER JOIN ObjectLink AS ObjectLink_GoodsChild
                                                            ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                           AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild() 
                                                           
                                                           
                                 WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
                                   AND Object_ReceiptGoodsChild.isErased = FALSE  
                                )

     -- Результат
     SELECT 
     
           tmpReceiptProdModelChild.ReceiptGoodsId
         , tmpReceiptProdModelChild.TitleReceipt

         , tmpProdColorPattern.Value  ::TFloat   AS Value
         --, CASE WHEN Object_Goods.DescId <> zc_Object_ReceiptService() THEN tmpProdColorPattern.Value ELSE 0 END ::TFloat   AS Value
         --, CASE WHEN Object_Goods.DescId =  zc_Object_ReceiptService() THEN tmpProdColorPattern.Value ELSE 0 END ::TFloat   AS Value_service

          , Object_Goods.ObjectCode            ::Integer  AS ObjectCode
          , CASE WHEN COALESCE (Object_Goods.ValueData,'') <> '' THEN Object_Goods.ValueData ELSE Object_ProdColorGroup.ValueData END ::TVarChar AS ObjectName
       -- ,  Object_Goods.ValueData  ::TVarChar AS ObjectName

         , ObjectString_EAN.ValueData                AS EAN

         , ObjectString_GoodsGroupFull.ValueData ::TVarChar  AS GoodsGroupNameFull
         , Object_GoodsGroup.ValueData           ::TVarChar  AS GoodsGroupName
         , ObjectString_Article.ValueData        ::TVarChar  AS Article
         --, Object_ProdColor.ValueData            :: TVarChar AS ProdColorName
         , CASE WHEN ObjectLink_Goods.ChildObjectId IS NULL THEN ObjectString_Comment.ValueData ELSE Object_ProdColor.ValueData END :: TVarChar AS ProdColorName
         , Object_Measure.ValueData              ::TVarChar  AS MeasureName
         , Object_ProdColorGroup.ValueData       AS  ProdColorGroupName
          -- Этап сборки
         , Object_ReceiptLevel.ValueData         ::TVarChar  AS ReceiptLevelName
          -- Комплектующие
         , Object_GoodsChild.ValueData           ::TVarChar  AS GoodsChildName
         , ObjectString_ArticleChild.ValueData   ::TVarChar  AS ArticleChild
         , Object_ProdColorPattern.ValueData     ::TVarChar  AS ProdColorPattern
         
         , Object_GoodsMain.ValueData           ::TVarChar  AS GoodsMainName

         , COALESCE(Object_GoodsChild.ValueData,
                    Object_GoodsMain.ValueData)    ::TVarChar  AS GoodsNameShow

         , COALESCE(ObjectString_ArticleChild.ValueData,
                    ObjectString_ArticleChildMain.ValueData)    ::TVarChar  AS ArticleShow

         , COALESCE(Object_GoodsChildGroup.ValueData,
                    Object_GoodsMainGroup.ValueData)    ::TVarChar  AS GoodsGroupNameShow
                              
         , CASE WHEN COALESCE(tmpProdColorPattern.GoodsChildId, 0) = 0
                THEN COALESCE(ObjectString_ArticleChildMain.ValueData, '')||
                     CASE WHEN COALESCE(ObjectString_ArticleChildMain.ValueData, '') <> '' AND COALESCE(Object_GoodsMain.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                     COALESCE(Object_GoodsMain.ValueData, '')
                ELSE COALESCE(ObjectString_ArticleChild.ValueData, '')||
                     CASE WHEN COALESCE(ObjectString_ArticleChild.ValueData, '') <> '' AND COALESCE(Object_GoodsChildGroup.ValueData, '') <> '' THEN ' - ' ELSE '' END||
                     COALESCE(Object_GoodsChildGroup.ValueData, '') END:: TVarChar AS TitleGroup
                     
         , COALESCE (tmpItemsGoodsChild.ReceiptGoodsId, 0) <> 0  AS isGoodsChild
     FROM tmpProdColorPattern

          INNER JOIN tmpReceiptProdModelChild ON tmpReceiptProdModelChild.ReceiptGoodsId = tmpProdColorPattern.ReceiptGoodsId

          LEFT JOIN Object AS Object_ProdColorPattern ON Object_ProdColorPattern.Id = tmpProdColorPattern.ProdColorPatternId
          

          LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = tmpProdColorPattern.ReceiptLevelId
          LEFT JOIN Object AS Object_GoodsChild ON Object_GoodsChild.Id = tmpProdColorPattern.GoodsChildId
          LEFT JOIN Object AS Object_GoodsMain ON Object_GoodsMain.Id = tmpProdColorPattern.GoodsMainId

          LEFT JOIN ObjectString AS ObjectString_ArticleChildMain
                                 ON ObjectString_ArticleChildMain.ObjectId = tmpProdColorPattern.GoodsMainId
                                AND ObjectString_ArticleChildMain.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectString AS ObjectString_ArticleChild
                                 ON ObjectString_ArticleChild.ObjectId = tmpProdColorPattern.GoodsChildId
                                AND ObjectString_ArticleChild.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdColorPattern.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdColorPattern_Comment()

          LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                               ON ObjectLink_ProdColorGroup.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ProdColorGroup.DescId = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
          LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId
          LEFT JOIN ObjectLink AS ObjectLink_ColorPattern
                               ON ObjectLink_ColorPattern.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_ColorPattern.DescId = zc_ObjectLink_ProdColorPattern_ColorPattern()
          LEFT JOIN Object AS Object_ColorPattern ON Object_ColorPattern.Id = ObjectLink_ColorPattern.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods
                               ON ObjectLink_Goods.ObjectId = Object_ProdColorPattern.Id
                              AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorPattern_Goods()
          -- !!!замена!!!
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpProdColorPattern.ObjectId, ObjectLink_Goods.ChildObjectId)   

          --
          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                 ON ObjectString_GoodsGroupFull.ObjectId = Object_Goods.Id
                                AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = Object_Goods.Id
                                AND ObjectString_Article.DescId = zc_ObjectString_Article()

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                               ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                               ON ObjectLink_Goods_ProdColor.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
          LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                               ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                              AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsMainGroup
                               ON ObjectLink_Goods_GoodsMainGroup.ObjectId = tmpProdColorPattern.GoodsMainId
                              AND ObjectLink_Goods_GoodsMainGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsMainGroup ON Object_GoodsMainGroup.Id = ObjectLink_Goods_GoodsMainGroup.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsChildGroup
                               ON ObjectLink_Goods_GoodsChildGroup.ObjectId = tmpProdColorPattern.GoodsChildId
                              AND ObjectLink_Goods_GoodsChildGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsChildGroup ON Object_GoodsChildGroup.Id = ObjectLink_Goods_GoodsChildGroup.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_EAN
                                 ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                AND ObjectString_EAN.DescId = zc_ObjectString_EAN() 
                                
          LEFT JOIN tmpItemsGoodsChild AS tmpItemsGoodsChild ON tmpItemsGoodsChild.ReceiptGoodsId = tmpProdColorPattern.ReceiptGoodsId
                                
     ORDER BY tmpReceiptProdModelChild.TitleReceipt
            , CASE WHEN COALESCE(Object_ReceiptLevel.ValueData, '') = '' THEN 1 ELSE 0 END
            , Object_ReceiptLevel.ValueData
            , Object_ProdColorPattern.ObjectCode ASC;
     
     RETURN NEXT Cursor3;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.22          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ReceiptProdModelGoods_Print(inReceiptProdModelId := 39753 , inReceiptLevelId := 0,  inSession := '5');
