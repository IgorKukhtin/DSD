-- Function: gpSelect_MI_Income_Master()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Income_Master (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Income_Master (
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar

             , Amount         TFloat
             , Amount_old     TFloat
             , CountForPrice  TFloat
             , Amount_unit    TFloat    -- резерв

             , OperPrice      TFloat    -- Цена вх. без НДС, с учетом скидки по элементу
             , CostPrice      TFloat    -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
             , OperPrice_cost TFloat    -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка

             , EKPrice_orig     TFloat    -- ***Цена вх. без НДС, с учетом скидки по элементу = MovementItem.OperPrice
             , EKPrice_discount TFloat    -- ***Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)

             , EmpfPrice      TFloat
             , OperPriceList  TFloat

             , Summ_cost      TFloat    -- Сумма затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
             , TotalSumm_cost TFloat    -- Сумма вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
             , TotalSummIn    TFloat    -- Сумма без НДС, с учетом ВСЕХ скидок (затрат здесь нет)

             , OperPrice_orig TFloat        -- Вх. цена БЕЗ скидки
             , OperPrice_orig_old TFloat    -- Вх. цена БЕЗ скидки
             , DiscountTax    TFloat    -- % скидки
             , SummIn         TFloat    -- Сумма вх., с учетом скидки в элементе

             , PartNumber TVarChar
             , Comment TVarChar
             , PartionCellId Integer, PartionCellCode Integer, PartionCellName TVarChar
             , isErased Boolean
             , InsertName TVarChar, InsertDate TDateTime

             , Article TVarChar
             , ArticleVergl TVarChar
             , Article_all TVarChar
             , GoodsGroupId Integer
             , GoodsGroupName TVarChar
             , GoodsGroupNameFull TVarChar
             , MeasureId Integer
             , MeasureName TVarChar
             , GoodsTagId Integer, GoodsTagName TVarChar
             , GoodsTypeId  Integer, GoodsTypeName TVarChar
             , GoodsSizeId  Integer, GoodsSizeName TVarChar
             , ProdColorId  Integer, ProdColorName TVarChar

             , Ord Integer

               -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
             , isReceiptGoods Boolean
               -- Опция (да/нет) - Участвует в опциях
             , isProdOptions  Boolean
              )
AS
$BODY$
  DECLARE vbUserId       Integer;

  DECLARE vbStatusId     Integer;
  DECLARE vbToId         Integer;
  DECLARE vbFromId       Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);

    SELECT Movement_Income.StatusId           AS StatusId
         , MovementLinkObject_From.ObjectId   AS FromId
         , MovementLinkObject_To.ObjectId     AS ToId
           INTO
               vbStatusId
             , vbFromId
             , vbToId
    FROM Movement AS Movement_Income
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
    WHERE Movement_Income.Id = inMovementId
      AND Movement_Income.DescId = zc_Movement_Income();


    IF inShowAll = TRUE
    THEN
        RETURN QUERY
          WITH tmpIsErased AS (SELECT FALSE AS isErased
                                UNION ALL
                               SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                              )
               -- Все Комплектующие Поставщика
/*             , tmpGoods AS (SELECT Object_Goods.Id               AS GoodsId
                                 , Object_Goods.ObjectCode       AS GoodsCode
                                 , Object_Goods.ValueData        AS GoodsName
                            FROM ObjectLink AS ObjectLink_Goods_Partner
                                 LEFT JOIN Object AS Object_Goods
                                                   ON Object_Goods.Id = ObjectLink_Goods_Partner.ObjectId
                                                  AND Object_Goods.isErased = FALSE
                            WHERE ObjectLink_Goods_Partner.ChildObjectId = vbFromId
                              AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                              -- отключил!
                            --AND 1=0
                           )*/
             , tmpGoods AS (SELECT Object_Goods.Id               AS GoodsId
                                 , Object_Goods.ObjectCode       AS GoodsCode
                                 , Object_Goods.ValueData        AS GoodsName
                            FROM Object AS Object_Goods
                            WHERE Object_Goods.DescId = zc_Object_Goods()
                              AND Object_Goods.isErased = FALSE
                              -- отключил!
                            --AND 1=0
                           )
               -- св-ва Комплектующих
             , tmpGoodsParams AS (SELECT tmpGoods.GoodsId                   AS GoodsId
                                       , tmpGoods.GoodsCode                 AS GoodsCode
                                       , tmpGoods.GoodsName                 AS GoodsName
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

                                         -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
                                       , ObjectFloat_EKPrice.ValueData   ::TFloat AS EKPrice
                                         -- ???-Цена вх. без НДС, с учетом скидки по элементу
                                       , ObjectFloat_EKPrice.ValueData   ::TFloat AS EKPrice_orig
                                         -- ???-Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
                                       , ObjectFloat_EKPrice.ValueData   ::TFloat AS EKPrice_discount

                                         --
                                       , 1                               ::TFloat AS CountForPrice
                                        -- Рекомендованная цена без НДС
                                       , ObjectFloat_EmpfPrice.ValueData ::TFloat AS EmpfPrice

                                  FROM tmpGoods
                                       LEFT JOIN ObjectString AS ObjectString_Article
                                                              ON ObjectString_Article.ObjectId = tmpGoods.GoodsId
                                                             AND ObjectString_Article.DescId = zc_ObjectString_Article()

                                       LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                              ON ObjectString_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                                             AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                                       LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                            ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                       LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                                       LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                                             ON ObjectFloat_EKPrice.ObjectId = tmpGoods.GoodsId
                                                            AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_Goods_EKPrice()

                                       LEFT JOIN ObjectFloat AS ObjectFloat_EmpfPrice
                                                             ON ObjectFloat_EmpfPrice.ObjectId = tmpGoods.GoodsId
                                                            AND ObjectFloat_EmpfPrice.DescId   = zc_ObjectFloat_Goods_EmpfPrice()

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                                            ON ObjectLink_Goods_GoodsTag.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                                       LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsType
                                                            ON ObjectLink_Goods_GoodsType.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                                       LEFT JOIN Object AS Object_GoodsType ON Object_GoodsType.Id = ObjectLink_Goods_GoodsType.ChildObjectId

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                                            ON ObjectLink_Goods_GoodsSize.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
                                       LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

                                       LEFT JOIN ObjectLink AS ObjectLink_Goods_ProdColor
                                                            ON ObjectLink_Goods_ProdColor.ObjectId = tmpGoods.GoodsId
                                                           AND ObjectLink_Goods_ProdColor.DescId = zc_ObjectLink_Goods_ProdColor()
                                       LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_Goods_ProdColor.ChildObjectId
                                )
                  -- Элементы
                , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                                 , MovementItem.Id         AS PartionId
                                 , MovementItem.Amount

                                   -- Вх. цена БЕЗ скидки
                                 , COALESCE (MIFloat_OperPrice_orig.ValueData, 0) AS OperPrice_orig
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice

                                   -- % скидки
                                 , COALESCE (MIFloat_DiscountTax.ValueData, 0)    AS DiscountTax
                                   -- Вх. цена с учетом скидки в элементе
                                 , MIFloat_OperPrice.ValueData                    AS OperPrice
                                   -- Сумма вх. с учетом скидки в элементе
                                 , COALESCE (MIFloat_SummIn.ValueData, 0)         AS SummIn

                                   -- Цена продажи
                                 , MIFloat_OperPriceList.ValueData                AS OperPriceList

                                   --
                                 , MovementItem.Id
                                 , MovementItem.isErased

                                 , MIString_PartNumber.ValueData AS PartNumber
                                 , MIString_Comment.ValueData    AS Comment

                                 , Object_Insert.ValueData       AS InsertName
                                 , MIDate_Insert.ValueData       AS InsertDate

                                 , Object_PartionCell.Id         AS PartionCellId
                                 , Object_PartionCell.ObjectCode AS PartionCellCode
                                 , Object_PartionCell.ValueData  AS PartionCellName

                            FROM tmpIsErased
                                 JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPrice_orig
                                                             ON MIFloat_OperPrice_orig.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPrice_orig.DescId = zc_MIFloat_OperPrice_orig()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                 LEFT JOIN MovementItemFloat AS MIFloat_DiscountTax
                                                             ON MIFloat_DiscountTax.MovementItemId = MovementItem.Id
                                                            AND MIFloat_DiscountTax.DescId = zc_MIFloat_DiscountTax()
                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                             ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_SummIn
                                                             ON MIFloat_SummIn.MovementItemId = MovementItem.Id
                                                            AND MIFloat_SummIn.DescId = zc_MIFloat_SummIn()

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                             ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                                 LEFT JOIN MovementItemString AS MIString_Comment
                                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                                             AND MIString_Comment.DescId = zc_MIString_Comment()

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                  ON MILO_Insert.MovementItemId = MovementItem.Id
                                                                 AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                                 LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                  ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                 AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                                 LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILO_PartionCell.ObjectId

                           )
        -- С/с + затраты из проводок
      , tmpMIContainer AS (SELECT MIContainer.PartionId
                                , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SummIn()   THEN MIContainer.Amount ELSE 0 END) AS SummIn
                                , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SummCost() THEN MIContainer.Amount ELSE 0 END) AS SummCost
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId = zc_Container_Summ()
                             AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummIn(), zc_Enum_AnalyzerId_SummCost())
                          GROUP BY MIContainer.PartionId
                         )
              -- Затраты
            , tmpCost AS (SELECT MIContainer.PartionId
                               , MIContainer.ObjectId_analyzer         AS GoodsId
                               , SUM (COALESCE (MIContainer.Amount,0)) AS Amount      -- Сумма затраты
                          FROM Movement AS Movement_Cost
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementId = Movement_Cost.Id
                                                               AND MIContainer.DescId = zc_Container_Summ()
                                                               AND MIContainer.isActive = TRUE
                          WHERE Movement_Cost.ParentId = inMovementId
                          GROUP BY MIContainer.PartionId
                                 , MIContainer.ObjectId_analyzer
                          HAVING SUM (COALESCE (MIContainer.Amount,0)) <> 0
                         )
              -- резерв
            , tmpMI_Child AS (SELECT MovementItem.ParentId
                                   , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                              FROM MovementItem
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                              GROUP BY MovementItem.ParentId
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
         -- если Товар участвует в сборке
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
                                -- !!!отключил!!!
                                AND 1=0
                             )
            -- Результат
            SELECT
                0 :: Integer               AS Id
              , 0 :: Integer               AS PartionId
              , tmpGoodsParams.GoodsId     AS GoodsId
              , tmpGoodsParams.GoodsCode   AS GoodsCode
              , tmpGoodsParams.GoodsName   AS GoodsName

              , CAST (NULL AS TFloat)      AS Amount
              , CAST (NULL AS TFloat)      AS Amount_old
              , tmpGoodsParams.CountForPrice
                -- резерв
              , 0 :: TFloat AS Amount_unit

                -- Цена вх. без НДС, с учетом скидки по элементу
              , tmpGoodsParams.EKPrice_orig     ::TFloat AS OperPrice
                -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , 0                               ::TFloat AS CostPrice
                -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , tmpGoodsParams.EKPrice          ::TFloat AS OperPrice_cost

                -- ***Цена вх. без НДС, с учетом скидки по элементу = MovementItem.OperPrice
              , tmpGoodsParams.EKPrice_orig     ::TFloat AS EKPrice_orig
                -- ***Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , tmpGoodsParams.EKPrice_discount ::TFloat AS EKPrice_discount

                --
              , tmpGoodsParams.EmpfPrice        ::TFloat AS EmpfPrice
              , 0                               ::TFloat AS OperPriceList

                -- Сумма затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , 0                               ::TFloat AS Summ_cost
                -- Сумма вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , 0                               ::TFloat AS TotalSumm_cost
                -- Сумма без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , 0                               ::TFloat AS TotalSummIn

                -- Вх. цена без скидки
              , 0 ::TFloat AS OperPrice_orig
              , 0 ::TFloat AS OperPrice_orig_old
                -- % скидки
              , 0 ::TFloat AS DiscountTax
                -- Сумма вх. с учетом скидки в элементе
              , 0 ::TFloat AS SummIn

              , NULL::TVarChar             AS PartNumber
              , NULL::TVarChar             AS Comment

              , 0    ::Integer             AS PartionCellId
              , 0    ::Integer             AS PartionCellCode
              , NULL::TVarChar             AS PartionCellName

              , FALSE ::Boolean            AS isErased

              , NULL::TVarChar             AS InsertName
              , NULL::TDateTime            AS InsertDate
              --
              , tmpGoodsParams.Article
              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
              , zfCalc_Article_all (COALESCE (tmpGoodsParams.Article, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
              , tmpGoodsParams.GoodsGroupId
              , tmpGoodsParams.GoodsGroupName
              , tmpGoodsParams.GoodsGroupNameFull
              , tmpGoodsParams.MeasureId
              , tmpGoodsParams.MeasureName
              , tmpGoodsParams.GoodsTagId
              , tmpGoodsParams.GoodsTagName
              , tmpGoodsParams.GoodsTypeId
              , tmpGoodsParams.GoodsTypeName
              , tmpGoodsParams.GoodsSizeId
              , tmpGoodsParams.GoodsSizeName
              , tmpGoodsParams.ProdColorId
              , tmpGoodsParams.ProdColorName

              , 0 :: Integer AS Ord

                -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)            :: Boolean AS isProdOptions

            FROM tmpGoods
                 LEFT JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                 LEFT JOIN tmpGoodsParams AS tmpGoodsParams ON tmpGoodsParams.GoodsId = tmpGoods.GoodsId
                 -- если Товар участвует в сборке
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = tmpGoods.GoodsId
                 -- если Опции
                 LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = tmpGoods.GoodsId
                                              AND tmpReceiptGoods_all.isProdOptions = TRUE

                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = tmpGoods.GoodsId
                                       AND ObjectString_ArticleVergl.DescId   = zc_ObjectString_ArticleVergl()

            WHERE tmpMI.GoodsId IS NULL

          UNION ALL
            SELECT
                MovementItem.Id           AS Id
              , MovementItem.PartionId    AS PartionId
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName

              , MovementItem.Amount           ::TFloat
              , MovementItem.Amount           ::TFloat AS Amount_old
              , MovementItem.CountForPrice    ::TFloat
                -- резерв
              , tmpMI_Child.Amount            :: TFloat AS Amount_unit

                -- Вх. цена с учетом скидки в элементе
              , MovementItem.OperPrice        ::TFloat AS OperPrice

                -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , CASE WHEN MovementItem.Amount <> 0
                     THEN CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                               THEN Object_PartionGoods.CostPrice
                               ELSE COALESCE (tmpCost.Amount, 0) / MovementItem.Amount
                          END
                     ELSE 0
                END ::TFloat AS CostPrice

                -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , CASE WHEN MovementItem.Amount <> 0
                     THEN CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                               THEN Object_PartionGoods.EKPrice
                               ELSE (MovementItem.SummIn + COALESCE (tmpCost.Amount, 0)) / MovementItem.Amount
                          END
                     ELSE 0
                END ::TFloat AS OperPrice_cost

                -- ***Цена вх. без НДС, с учетом скидки по элементу = MovementItem.OperPrice
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN Object_PartionGoods.EKPrice_orig     ELSE 0 END ::TFloat AS EKPrice_orig
                -- ***Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN Object_PartionGoods.EKPrice_discount ELSE 0 END ::TFloat AS EKPrice_discount


              , Object_PartionGoods.EmpfPrice    ::TFloat AS EmpfPrice
              , MovementItem.OperPriceList       ::TFloat AS OperPriceList

                -- Сумма затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                     THEN COALESCE (tmpMIContainer.SummCost, 0)
                     ELSE COALESCE (tmpCost.Amount, 0)
                END ::TFloat AS Summ_cost

                -- Сумма вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                     THEN COALESCE (tmpMIContainer.SummIn + tmpMIContainer.SummCost, 0)
                     ELSE MovementItem.SummIn + COALESCE (tmpCost.Amount, 0)
                END ::TFloat AS TotalSumm_cost

                -- Сумма без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , tmpMIContainer.SummIn ::TFloat AS TotalSummIn

                -- Вх. цена БЕЗ скидки
              , MovementItem.OperPrice_orig ::TFloat
              , MovementItem.OperPrice_orig ::TFloat AS OperPrice_orig_old
                -- % скидки
              , MovementItem.DiscountTax    ::TFloat
                -- Сумма вх. с учетом скидки в элементе
              , MovementItem.SummIn         ::TFloat

              , MovementItem.PartNumber ::TVarChar
              , MovementItem.Comment    :: TVarChar

              , MovementItem.PartionCellId   ::Integer
              , MovementItem.PartionCellCode ::Integer
              , MovementItem.PartionCellName ::TVarChar

              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate

              --
              , ObjectString_Article.ValueData     AS Article
              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
              , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all
              , Object_GoodsGroup.Id        AS GoodsGroupId
              , Object_GoodsGroup.ValueData AS GoodsGroupName
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

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord

                -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)            :: Boolean AS isProdOptions

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId

                 LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
                 LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_PartionGoods.MeasureId
                 LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = Object_PartionGoods.GoodsTagId
                 LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = Object_PartionGoods.GoodsTypeId
                 LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = Object_PartionGoods.GoodsSizeId
                 LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = Object_PartionGoods.ProdColorId

                 LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                        ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_Article.DescId = zc_ObjectString_Article()
                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()

                 -- берем из проводок - затраты
                 LEFT JOIN tmpCost ON tmpCost.PartionId = MovementItem.PartionId
                 -- берем из проводок - сумму без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PartionId = MovementItem.PartionId
                 --
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
                 -- если Товар участвует в сборке
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = MovementItem.GoodsId
                 -- если Опции
                 LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = MovementItem.GoodsId
                                              AND tmpReceiptGoods_all.isProdOptions = TRUE
            ;
    ELSE
       RETURN QUERY
         WITH tmpIsErased AS (SELECT FALSE AS isErased
                               UNION ALL
                              SELECT inIsErased AS isErased WHERE inIsErased = TRUE
                             )
                  -- Элементы
                , tmpMI AS (SELECT MovementItem.ObjectId   AS GoodsId
                                 , MovementItem.Id         AS PartionId
                                 , MovementItem.Amount

                                   -- Вх. цена БЕЗ скидки
                                 , COALESCE (MIFloat_OperPrice_orig.ValueData, 0) AS OperPrice_orig
                                 , CASE WHEN COALESCE (MIFloat_CountForPrice.ValueData, 1) = 0 THEN 1 ELSE COALESCE (MIFloat_CountForPrice.ValueData, 1) END AS CountForPrice

                                   -- % скидки
                                 , COALESCE (MIFloat_DiscountTax.ValueData, 0)    AS DiscountTax
                                   -- Вх. цена с учетом скидки в элементе
                                 , MIFloat_OperPrice.ValueData                    AS OperPrice
                                   -- Сумма вх. с учетом скидки в элементе
                                 , COALESCE (MIFloat_SummIn.ValueData, 0)         AS SummIn

                                   -- Цена продажи
                                 , MIFloat_OperPriceList.ValueData                AS OperPriceList


                                 , MovementItem.Id
                                 , MovementItem.isErased
                                 , MIString_PartNumber.ValueData AS PartNumber
                                 , MIString_Comment.ValueData    AS Comment

                                 , Object_Insert.ValueData       AS InsertName
                                 , MIDate_Insert.ValueData       AS InsertDate

                                 , Object_PartionCell.Id         AS PartionCellId
                                 , Object_PartionCell.ObjectCode AS PartionCellCode
                                 , Object_PartionCell.ValueData  AS PartionCellName
                            FROM tmpIsErased
                                 JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                             ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                             ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                  LEFT JOIN MovementItemFloat AS MIFloat_OperPrice_orig
                                                              ON MIFloat_OperPrice_orig.MovementItemId = MovementItem.Id
                                                             AND MIFloat_OperPrice_orig.DescId = zc_MIFloat_OperPrice_orig()
                                  LEFT JOIN MovementItemFloat AS MIFloat_DiscountTax
                                                              ON MIFloat_DiscountTax.MovementItemId = MovementItem.Id
                                                             AND MIFloat_DiscountTax.DescId = zc_MIFloat_DiscountTax()
                                  LEFT JOIN MovementItemFloat AS MIFloat_SummIn
                                                              ON MIFloat_SummIn.MovementItemId = MovementItem.Id
                                                             AND MIFloat_SummIn.DescId = zc_MIFloat_SummIn()

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()

                                 LEFT JOIN MovementItemString AS MIString_Comment
                                                              ON MIString_Comment.MovementItemId = MovementItem.Id
                                                             AND MIString_Comment.DescId = zc_MIString_Comment()

                                 LEFT JOIN MovementItemDate AS MIDate_Insert
                                                            ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                           AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                 LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                  ON MILO_Insert.MovementItemId = MovementItem.Id
                                                                 AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                 LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                                 LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                  ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                 AND MILO_PartionCell.DescId = zc_MILinkObject_PartionCell()
                                 LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = MILO_PartionCell.ObjectId
                           )
        -- С/с + затраты из проводок
      , tmpMIContainer AS (SELECT MIContainer.PartionId
                                , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SummIn()   THEN MIContainer.Amount ELSE 0 END) AS SummIn
                                , SUM (CASE WHEN MIContainer.AnalyzerId = zc_Enum_AnalyzerId_SummCost() THEN MIContainer.Amount ELSE 0 END) AS SummCost
                          FROM MovementItemContainer AS MIContainer
                          WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId = zc_Container_Summ()
                             AND MIContainer.AnalyzerId IN (zc_Enum_AnalyzerId_SummIn(), zc_Enum_AnalyzerId_SummCost())
                          GROUP BY MIContainer.PartionId
                         )
              -- Затраты
            , tmpCost AS (SELECT MIContainer.PartionId
                               , SUM (COALESCE (MIContainer.Amount,0)) AS Amount      -- Сумма затраты
                          FROM Movement AS Movement_Cost
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.MovementId = Movement_Cost.Id
                                                              AND MIContainer.DescId = zc_Container_Summ()
                                                              AND MIContainer.isActive = TRUE
                          WHERE Movement_Cost.ParentId = inMovementId
                          GROUP BY MIContainer.PartionId
                                 , MIContainer.ObjectId_analyzer
                          HAVING SUM (COALESCE (MIContainer.Amount,0)) <> 0
                         )
              -- резерв
            , tmpMI_Child AS (SELECT MovementItem.ParentId
                                   , SUM (COALESCE (MovementItem.Amount,0)) AS Amount
                              FROM MovementItem
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                              GROUP BY MovementItem.ParentId
                             )
     -- если Товар участвует в сборке
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
         -- если Товар участвует в сборке
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
                                -- !!!отключил!!!
                                AND 1=0
                             )
         -- Результат
         SELECT
                MovementItem.Id           AS Id
              , MovementItem.PartionId    AS PartionId
              , MovementItem.GoodsId      AS GoodsId
              , Object_Goods.ObjectCode   AS GoodsCode
              , Object_Goods.ValueData    AS GoodsName

              , MovementItem.Amount           ::TFloat
              , MovementItem.Amount           ::TFloat AS Amount_old
              , MovementItem.CountForPrice    ::TFloat
                -- резерв
              , tmpMI_Child.Amount            ::TFloat AS Amount_unit

                -- Вх. цена с учетом скидки в элементе
              , MovementItem.OperPrice        ::TFloat AS OperPrice

                -- Цена затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , CASE WHEN MovementItem.Amount <> 0
                     THEN CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                               THEN Object_PartionGoods.CostPrice
                               ELSE COALESCE (tmpCost.Amount, 0) / MovementItem.Amount
                          END
                     ELSE 0
                END ::TFloat AS CostPrice

                -- Цена вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , CASE WHEN MovementItem.Amount <> 0
                     THEN CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                               THEN Object_PartionGoods.EKPrice
                               ELSE (MovementItem.SummIn + COALESCE (tmpCost.Amount, 0)) / MovementItem.Amount
                          END
                     ELSE 0
                END ::TFloat AS OperPrice_cost

                -- ***Цена вх. без НДС, с учетом скидки по элементу = MovementItem.OperPrice
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN Object_PartionGoods.EKPrice_orig     ELSE 0 END ::TFloat AS EKPrice_orig
                -- ***Цена вх. без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete() THEN Object_PartionGoods.EKPrice_discount ELSE 0 END ::TFloat AS EKPrice_discount


              , Object_PartionGoods.EmpfPrice    ::TFloat AS EmpfPrice
              , COALESCE (MovementItem.OperPriceList, 0)       ::TFloat AS OperPriceList

                -- Сумма затрат без НДС (затраты + расходы: Почтовые + Упаковка + Страховка)
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                     THEN COALESCE (tmpMIContainer.SummCost, 0)
                     ELSE COALESCE (tmpCost.Amount, 0)
                END ::TFloat AS Summ_cost

                -- Сумма вх. без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
              , CASE WHEN vbStatusId = zc_Enum_Status_Complete()
                     THEN COALESCE (tmpMIContainer.SummIn + tmpMIContainer.SummCost, 0)
                     ELSE MovementItem.SummIn + COALESCE (tmpCost.Amount, 0)
                END ::TFloat AS TotalSumm_cost

                -- Сумма без НДС, с учетом ВСЕХ скидок (затрат здесь нет)
              , tmpMIContainer.SummIn ::TFloat AS TotalSummIn

                -- Вх. цена БЕЗ скидки
              , MovementItem.OperPrice_orig ::TFloat
              , MovementItem.OperPrice_orig ::TFloat AS OperPrice_orig_old
                -- % скидки
              , MovementItem.DiscountTax    ::TFloat
                -- Сумма вх., с учетом скидки в элементе
              , MovementItem.SummIn         ::TFloat

              , MovementItem.PartNumber ::TVarChar
              , MovementItem.Comment    ::TVarChar

              , MovementItem.PartionCellId   ::Integer
              , MovementItem.PartionCellCode ::Integer
              , MovementItem.PartionCellName ::TVarChar

              , MovementItem.isErased

              , MovementItem.InsertName
              , MovementItem.InsertDate

              --
              , ObjectString_Article.ValueData     AS Article
              , ObjectString_ArticleVergl.ValueData AS ArticleVergl
              , zfCalc_Article_all (COALESCE (ObjectString_Article.ValueData, '') || '_' || COALESCE (ObjectString_ArticleVergl.ValueData, '')) ::TVarChar AS Article_all

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

              , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord

                -- Сборка (да/нет) - Участвует в сборке Узла/Модели или в опциях
              , CASE WHEN tmpReceiptGoods.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isReceiptGoods
                -- Опция (да/нет) - Участвует в опциях
              , COALESCE (tmpReceiptGoods_all.isProdOptions, FALSE)            :: Boolean AS isProdOptions

            FROM tmpMI AS MovementItem
                 LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId

                 LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId

                 LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_PartionGoods.GoodsGroupId
                 LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = Object_PartionGoods.MeasureId
                 LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = Object_PartionGoods.GoodsTagId
                 LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = Object_PartionGoods.GoodsTypeId
                 LEFT JOIN Object AS Object_GoodsSize  ON Object_GoodsSize.Id  = Object_PartionGoods.GoodsSizeId
                 LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = Object_PartionGoods.ProdColorId

                 LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                        ON ObjectString_GoodsGroupFull.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                 LEFT JOIN ObjectString AS ObjectString_Article
                                        ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_Article.DescId = zc_ObjectString_Article()
                 LEFT JOIN ObjectString AS ObjectString_ArticleVergl
                                        ON ObjectString_ArticleVergl.ObjectId = MovementItem.GoodsId
                                       AND ObjectString_ArticleVergl.DescId = zc_ObjectString_ArticleVergl()
                 -- берем из проводок - затраты
                 LEFT JOIN tmpCost ON tmpCost.PartionId = MovementItem.PartionId
                 -- берем из проводок - сумму без НДС, с учетом ВСЕХ скидок + затраты + расходы: Почтовые + Упаковка + Страховка
                 LEFT JOIN tmpMIContainer ON tmpMIContainer.PartionId = MovementItem.PartionId
                 --
                 LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = MovementItem.Id
                 -- если Товар участвует в сборке
                 LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.GoodsId = MovementItem.GoodsId
                 -- если Опции
                 LEFT JOIN tmpReceiptGoods_all ON tmpReceiptGoods_all.GoodsId_child = MovementItem.GoodsId
                                              AND tmpReceiptGoods_all.isProdOptions = TRUE
            ;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.01.24         *
 07,06,21         *
 08.02.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_Income_Master (inMovementId:= 0, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
