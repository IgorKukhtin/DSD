-- Function: gpSelect_Object_MobileGoods()

DROP FUNCTION IF EXISTS gpSelect_Object_MobileGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MobileGoods(
    IN inShowAll     Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , Name TVarChar
             , Article TVarChar
             , ArticleFilter TVarChar
             , EAN TVarChar
             , GoodsGroupName TVarChar
             , MeasureName TVarChar
             , FromId Integer
             , ToId Integer
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

                                  ORDER BY MovementItem.ObjectId, Movement.Id
                                 )
          , tmpMovementPL AS (SELECT STRING_AGG (tmpMovementPL_all.InvNumber, ';')    AS InvNumber
                                   , STRING_AGG (tmpMovementPL_all.Comment, ';') AS Comment
                                   , tmpMovementPL_all.GoodsId
                              FROM (SELECT DISTINCT tmpMovementPL_all.InvNumber, tmpMovementPL_all.Comment, tmpMovementPL_all.GoodsId, tmpMovementPL_all.Id FROM tmpMovementPL_all ORDER BY tmpMovementPL_all.GoodsId, tmpMovementPL_all.Id
                                   ) AS tmpMovementPL_all
                              GROUP BY tmpMovementPL_all.GoodsId
                             )
          -- все
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
                             )
         , tmpGoods_limit AS (SELECT Object_Goods.*
                              FROM Object AS Object_Goods
                              WHERE Object_Goods.DescId = zc_Object_Goods()
                              --AND Object_Goods.isErased = FALSE
                                AND (Object_Goods.isErased = FALSE OR inShowAll = TRUE)
                                --AND (Object_Goods.ObjectCode < 0 or vbUserId <> 5)
                            --ORDER BY Object_Goods.Id ASC
                              ORDER BY CASE WHEN vbUserId = 5 AND 1=0 THEN Object_Goods.Id ELSE 0 END ASC, Object_Goods.Id DESC
                             )
         , tmpGoods AS (SELECT tmpGoods_limit.*
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
                                                  --AND Object_Goods.ObjectCode < 0
                        WHERE Object_Goods.DescId = zc_Object_Goods()
                       UNION
                        SELECT DISTINCT Object_Goods.*
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail(), zc_MI_Reserv())
                             INNER JOIN Object AS Object_Goods
                                               ON Object_Goods.Id     = MovementItem.ObjectId
                                              AND Object_Goods.DescId = zc_Object_Goods()
                        WHERE Movement.DescId = zc_Movement_OrderClient()
                       )
         , tmpObjectString_Article AS (SELECT ObjectString_Article.*
                                            , REPLACE(REPLACE(REPLACE(ObjectString_Article.ValueData, ' ', ''), '.', ''), '-', '')::TVarChar AS ArticleFilter
                                       FROM ObjectString AS ObjectString_Article
                                       WHERE ObjectString_Article.DescId   = zc_ObjectString_Article()
                                         AND COALESCE(ObjectString_Article.ValueData, '') <> '')
                       
       -- Результат
       SELECT Object_Goods.Id                     AS Id
            , Object_Goods.ObjectCode             AS Code
              --
            , Object_Goods.ValueData              AS Name
            , ObjectString_Article.ValueData      AS Article
            , ObjectString_Article.ArticleFilter  AS ArticleFilter

            , ObjectString_EAN.ValueData          AS EAN

            , Object_GoodsGroup.ValueData         AS GoodsGroupName
            , Object_Measure.ValueData            AS MeasureName
            
            , CASE -- узел Стеклопластик + Опция
                   WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE AND tmpReceiptGoods.isProdOptions = TRUE
                        -- Склад Основной
                        THEN 35139

                   -- Опция
                   WHEN tmpReceiptGoods.isProdOptions = TRUE
                        -- Склад Основной
                        THEN 35139

                   -- узел
                   WHEN tmpReceiptGoods.isReceiptGoods_group = TRUE
                        -- Склад Основной
                        THEN 35139

                   -- Деталь + НЕ Узел + есть Unit-ПФ
                   WHEN tmpReceiptGoods.isReceiptGoods = TRUE AND tmpReceiptGoods.isReceiptGoods_group = FALSE AND tmpReceiptGoods.UnitName_child_receipt <> ''
                        THEN tmpReceiptGoods.UnitId_child_receipt

                   -- Участок сборки Hypalon
                   WHEN tmpReceiptGoods.UnitId_receipt = 38875
                        THEN tmpReceiptGoods.UnitId_receipt

                   -- Участок UPHOLSTERY
                   WHEN tmpReceiptGoods.UnitId_receipt = 253225
                        THEN tmpReceiptGoods.UnitId_receipt

                   -- Склад Основной
                   ELSE 35139

              END  :: Integer AS FromId

            , COALESCE(tmpReceiptGoods.UnitID_receipt
                     , tmpReceiptGoods.UnitId_child_receipt
                     , tmpReceiptGoods.UnitId_parent_receipt
                     , 33347) AS ToId

            , Object_Goods.isErased
       FROM tmpGoods AS Object_Goods


            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpObjectString_Article AS ObjectString_Article
                                              ON ObjectString_Article.ObjectId = Object_Goods.Id
                                             AND ObjectString_Article.DescId = zc_ObjectString_Article()

            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = Object_Goods.Id
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()
                                  
            -- это
            LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = Object_Goods.Id
                                  
        ORDER BY Object_Goods.Id  desc
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_MobileGoods (inShowAll:= False, inSession := zfCalc_UserAdmin())