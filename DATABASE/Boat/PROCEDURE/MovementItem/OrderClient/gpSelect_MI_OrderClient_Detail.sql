 -- Function: gpSelect_MI_OrderClient_detail()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_detail(
    IN inMovementId       Integer      , -- ЛМАЮ дПЛХНЕОФБ
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- УЕУУЙС РПМШЪПЧБФЕМС
)
RETURNS TABLE ( Id                      Integer
               , GoodsId_basis          Integer
               , GoodsCode_basis        Integer
               , GoodsName_basis        TVarChar
               , Article_basis          TVarChar
               , ObjectId_child         Integer
               , ObjectCode_child       Integer
               , ObjectName_child       TVarChar
               , Article_child          TVarChar
               , ReceiptLevelName_child TVarChar
               , ProdOptionsName_child  TVarChar
               , NPP_child              Integer
               , ObjectId_detail        Integer
               , ObjectCode_detail      Integer
               , ObjectName_detail      TVarChar
               , Article_detail         TVarChar 
               , DescName_detail        TVarChar
               , GoodsGroupName_detail  TVarChar
               , MeasureName_detail     TVarChar
               , ReceiptLevelName_detail TVarChar
               , ProdOptionsName_detail  TVarChar
               , Amount_detail           TFloat 
               , ForCount_detail         TFloat
               , Amount_remains  TFloat
               , Amount_send     TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReceiptProdModelId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
 /*
 1) № пп узла 
 2) артикул  (Узел) 
 3) назв узла 
 4)  назв Узел-пф 
 5) ReceiptLevel 
  6)Опция 
 7) артикул + Название комплектубшие 
 8) zc_MI_Detail.Amount - изменение в гриде 
 + изменение в гриде товара 
 + кнопки  (внизу панель ) добавить изм удалить 

 + остаток на гл складе
 + перемещ с гл склада в привязке к этому заказу 
 + вверху отчет движение товара по накладным на гл складе

*/
     --из шапки лодка по ней находим модель
     vbReceiptProdModelId := (SELECT ObjectLink_Product_ReceiptProdModel.ChildObjectId
                              FROM MovementLinkObject AS MovementLinkObject_Product
                                   LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                                        ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                                                       AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                              WHERE MovementLinkObject_Product.MovementId = inMovementId
                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                              );
     RETURN QUERY
     WITH 
     _tmpItem AS (SELECT MovementItem.DescId                                                 AS DescId_mi
                       , MovementItem.Id                                                     AS MovementItemId
                       , COALESCE (MovementItem.ParentId, 0)                                 AS ParentId
                       , MovementItem.PartionId                                              AS PartionId
                       , MILinkObject_Unit.ObjectId                                          AS UnitId
                       , MILinkObject_Partner.ObjectId                                       AS PartnerId
                                                                                             
                         -- какой Узел собирается
                       , COALESCE (MILinkObject_Goods.ObjectId, 0)                           AS GoodsId
                         -- Комплектующие
                       , MovementItem.ObjectId                                               AS ObjectId
          
                         -- какой узел был в ReceiptProdModel - для zc_MI_Child ИЛИ какой "ПФ" Узел собирается - для zc_MI_Detail
                       , CASE WHEN MovementItem.DescId = zc_MI_Child()
                                  -- какой узел был в ReceiptProdModel
                                   THEN COALESCE (MILinkObject_Goods_basis.ObjectId, 0)
                              WHEN MovementItem.DescId = zc_MI_Detail()
                                   -- какой "ПФ" Узел собирается
                                   THEN COALESCE (MILinkObject_Goods_basis.ObjectId, 0)
                         END AS ObjectId_basis
                     --, COALESCE (MILinkObject_Goods_basis.ObjectId, MovementItem.ObjectId) AS ObjectId_basis
          
                         -- только для zc_MI_Child
                       , CASE WHEN MovementItem.DescId = zc_MI_Child()
                                   THEN COALESCE (MILinkObject_ReceiptGoods.ObjectId, 0)
                         END AS ReceiptGoodsId
                         -- только для zc_MI_Detail
                       , CASE WHEN MovementItem.DescId = zc_MI_Detail()
                                   THEN COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)
                         END AS ReceiptLevelId
          
                         --
                       , MILinkObject_ProdOptions.ObjectId                                   AS ProdOptionsId
                       , MILinkObject_ColorPattern.ObjectId                                  AS ColorPatternId
                       , MILinkObject_ProdColorPattern.ObjectId                              AS ProdColorPatternId
                                                                                             
                       , MovementItem.Amount                                                 AS Amount
                       , 0                                                                   AS AmountPartner
                     --, MIFloat_AmountPartner.ValueData                                     AS AmountPartner
                       , MIFloat_ForCount.ValueData                                          AS ForCount
                       , MIFloat_OperPrice.ValueData                                         AS OperPrice
                       , MIFloat_OperPricePartner.ValueData                                  AS OperPricePartner
                         -- !!! временно для отладки
                     --,  CASE WHEN MS.ValueData = '1' THEN MIFloat_OperPrice.ValueData
          
                       , MovementItem.isErased
          
                  FROM (SELECT FALSE AS isErased ) AS tmpIsErased
                       INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                                              AND MovementItem.isErased   = tmpIsErased.isErased
                         -- !!! !!! временно для отладки
                       LEFT JOIN MovementString AS MS ON MS.MovementId = inMovementId AND MS.DescId = zc_MovementString_Comment()
          
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                        ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Partner.DescId         = zc_MILinkObject_Partner()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                        ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                        ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                        ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                        ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                        ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
          
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptGoods
                                                        ON MILinkObject_ReceiptGoods.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ReceiptGoods.DescId         = zc_MILinkObject_ReceiptGoods()
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                        ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                       LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                   ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                  AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                       LEFT JOIN MovementItemFloat AS MIFloat_OperPricePartner
                                                   ON MIFloat_OperPricePartner.MovementItemId = MovementItem.Id
                                                  AND MIFloat_OperPricePartner.DescId         = zc_MIFloat_OperPricePartner()
                       LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                                   ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                                  AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
          )

  , _tmpReceiptLevel AS (SELECT DISTINCT
                                CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END AS GoodsId
                              , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
                         FROM _tmpItem
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                                  ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END
                                                 AND ObjectLink_ReceiptProdModelChild_Object.DescId        = zc_ObjectLink_ReceiptProdModelChild_Object()
                             --- берем не удаленные
                             INNER JOIN Object AS Object_ReceiptProdModelChild ON Object_ReceiptProdModelChild.Id = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                                              AND Object_ReceiptProdModelChild.IsErased = FALSE
                             -- ReceiptProdModel по лодке
                             INNER JOIN ObjectLink AS ObjectLink_ReceiptProdModel
                                                   ON ObjectLink_ReceiptProdModel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                  AND ObjectLink_ReceiptProdModel.DescId = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()
                                                  AND ObjectLink_ReceiptProdModel.ChildObjectId = vbReceiptProdModelId
                 
                             LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_ReceiptLevel
                                                  ON ObjectLink_ReceiptProdModelChild_ReceiptLevel.ObjectId = ObjectLink_ReceiptProdModelChild_Object.ObjectId
                                                 AND ObjectLink_ReceiptProdModelChild_ReceiptLevel.DescId   = zc_ObjectLink_ReceiptProdModelChild_ReceiptLevel()
                             LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = ObjectLink_ReceiptProdModelChild_ReceiptLevel.ChildObjectId
                         )
   , tmpMI_Child AS (SELECT
                            _tmpItem.MovementItemId                  AS MovementItemId
                          , _tmpItem.ObjectId                        AS KeyId

                          , Object_Object.Id                         AS ObjectId
                          , Object_Object.ObjectCode                 AS ObjectCode
                          , ObjectString_Article_Object.ValueData    AS Article_Object
                          , Object_Object.ValueData                  AS ObjectName
                          , CASE WHEN _tmpItem_child.GoodsId > 0 THEN 'Узел'
                                 WHEN ObjectDesc_Object.Id = zc_Object_ProdOptions() THEN 'Опция'
                                 ELSE ObjectDesc_Object.ItemName
                            END AS DescName

                          , Object_ReceiptGoods.Id                   AS ReceiptGoodsId
                          , Object_ReceiptGoods.ObjectCode           AS ReceiptGoodsCode
                          , Object_ReceiptGoods.ValueData            AS ReceiptGoodsName

                            -- Количество шаблон сборки
                          , zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount) AS Amount_basis
                            -- Количество резерв
                          , CASE WHEN 1=1 THEN 0 WHEN ObjectDesc_Object.Id = zc_Object_Goods()          THEN zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)  ELSE 0 END :: NUMERIC (16, 8) AS Amount_unit
                            -- работы/услуги
                          , CASE WHEN ObjectDesc_Object.Id = zc_Object_ReceiptService() THEN zfCalc_Value_ForCount (_tmpItem.Amount, _tmpItem.ForCount)  ELSE 0 END :: NUMERIC (16, 8) AS Value_service
                            -- Количество заказ поставщику
                          , zfCalc_Value_ForCount (_tmpItem.AmountPartner, _tmpItem.ForCount) AS Amount_partner
                          , _tmpItem.ForCount                        AS ForCount
                          , _tmpItem.isErased
                          , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                          , Object_GoodsGroup.ValueData           AS GoodsGroupName
                          , Object_Measure.ValueData              AS MeasureName

                          , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName
               
                          , _tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName
               
                          , ROW_NUMBER() OVER (ORDER BY CASE WHEN _tmpReceiptLevel.ReceiptLevelName <> '' THEN 0 ELSE 1 END
                                                      , _tmpReceiptLevel.ReceiptLevelName
                                                      , Object_Object.ValueData
                                                      , CASE WHEN Object_ProdOptions.ValueData <> '' THEN 1 ELSE 0 END
                                                      , Object_ProdOptions.ValueData
                                              ) :: Integer AS NPP
                     FROM _tmpItem
                          LEFT JOIN (SELECT DISTINCT _tmpItem.GoodsId FROM _tmpItem WHERE _tmpItem.GoodsId <> _tmpItem.ObjectId) AS _tmpItem_child ON _tmpItem_child.GoodsId = _tmpItem.ObjectId

                          LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
                          LEFT JOIN ObjectString AS ObjectString_Article_object
                                                 ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                                AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
                          LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

                          LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = _tmpItem.ObjectId_basis
                          LEFT JOIN ObjectString AS ObjectString_Article_basis
                                                 ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                                AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

                          LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = _tmpItem.ReceiptGoodsId

                          LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                                 ON ObjectString_GoodsGroupFull.ObjectId = _tmpItem.ObjectId
                                                AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsTag
                                               ON ObjectLink_GoodsTag.ObjectId = _tmpItem.ObjectId
                                              AND ObjectLink_GoodsTag.DescId   = zc_ObjectLink_Goods_GoodsTag()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsType
                                               ON ObjectLink_GoodsType.ObjectId = _tmpItem.ObjectId
                                              AND ObjectLink_GoodsType.DescId   = zc_ObjectLink_Goods_GoodsType()
                          LEFT JOIN ObjectLink AS ObjectLink_Measure
                                               ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                              AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                               ON ObjectLink_GoodsGroup.ObjectId = _tmpItem.ObjectId
                                              AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

                          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
                          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                               ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                              AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
                          LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

                          LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = ObjectLink_GoodsGroup.ChildObjectId
                          LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = ObjectLink_Measure.ChildObjectId
                          LEFT JOIN Object AS Object_GoodsTag    ON Object_GoodsTag.Id    = ObjectLink_GoodsTag.ChildObjectId
                          LEFT JOIN Object AS Object_GoodsType   ON Object_GoodsType.Id   = ObjectLink_GoodsType.ChildObjectId

                          LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = CASE WHEN _tmpItem.ObjectId_basis > 0 THEN _tmpItem.ObjectId_basis ELSE _tmpItem.ObjectId END

                     -- без этой структуры
                     WHERE _tmpItem.GoodsId  = 0
                       AND _tmpItem.ParentId = 0
                       AND _tmpItem.DescId_mi = zc_MI_Child()
                     )

   -- Итого остаток
   , tmpRemains AS (SELECT Container.ObjectId     AS GoodsId
                         , SUM (Container.Amount) AS Remains
                    FROM Container
                    WHERE Container.WhereObjectId = zc_Unit_Sklad() -- Всегда для этого Склада
                      AND Container.DescId        = zc_Container_Count()
                      AND Container.ObjectId IN (SELECT DISTINCT _tmpItem.ObjectId FROM _tmpItem WHERE _tmpItem.DescId_mi = zc_MI_Detail())
                    GROUP BY Container.ObjectId
                   )
   -- все перемещения
   , tmpSend AS (SELECT MI.ObjectId                  AS GoodsId
                      , SUM (COALESCE (MI.Amount,0)) AS Amount
                 FROM MovementItemFloat AS MIFloat_MovementId
                      LEFT JOIN MovementItem AS MI
                                             ON MI.Id = MIFloat_MovementId.MovementItemId
                                            AND MI.DescId     = zc_MI_Master()
                                            AND MI.isErased   = FALSE
                      INNER JOIN Movement AS Movement_Send
                                          ON Movement_Send.Id = MI.MovementId
                                         AND Movement_Send.DescId = zc_Movement_Send()
                      INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                    ON MovementLinkObject_From.MovementId = Movement_Send.Id
                                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                   AND MovementLinkObject_From.ObjectId = zc_Unit_Sklad()
                 WHERE MIFloat_MovementId.ValueData :: Integer = inMovementId
                   AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId() 
                 GROUP BY MI.ObjectId
                )




   SELECT _tmpItem.MovementItemId                  AS Id
          --узел пф
        , Object_Object_basis.Id                   AS GoodsId_basis
        , Object_Object_basis.ObjectCode           AS GoodsCode_basis
        , Object_Object_basis.ValueData            AS GoodsName_basis
        , ObjectString_Article_basis.ValueData     AS Article_basis
          --узел/ комплектующие
        , tmpMI_Child.ObjectId                   AS ObjectId_child
        , tmpMI_Child.ObjectCode                 AS ObjectCode_child
        , tmpMI_Child.ObjectName                 AS ObjectName_child
        , tmpMI_Child.Article_Object             AS Article_child
        , tmpMI_Child.ReceiptLevelName :: TVarChar AS ReceiptLevelName_child
        , tmpMI_Child.ProdOptionsName  :: TVarChar AS ProdOptionsName_child
        , tmpMI_Child.NPP                          AS NPP_child
        
          -- комплектующие
        , Object_Detail.Id                        AS ObjectId_detail
        , Object_Detail.ObjectCode                AS ObjectCode_detail
        , Object_Detail.ValueData                 AS ObjectName_detail
        , ObjectString_Article_Detail.ValueData   AS Article_detail
        , ObjectDesc_Detail.ItemName              AS DescName_detail
        , Object_GoodsGroup.ValueData    AS GoodsGroupName_detail
        , Object_Measure.ValueData       AS MeasureName_detail
        , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName_detail
        , (CASE WHEN Object_MaterialOptions_opt.ValueData <> '' THEN Object_MaterialOptions_opt.ValueData || ' ' ELSE '' END || Object_ProdOptions.ValueData) :: TVarChar AS ProdOptionsName_detail
        , _tmpItem.Amount   ::TFloat AS Amount_detail
        , _tmpItem.ForCount ::TFloat AS ForCount_detail 
        
        --
        , tmpRemains.Remains ::TFloat AS Amount_remains
        , tmpSend.Amount     ::TFloat AS Amount_send
        
  FROM tmpMI_Child
            LEFT JOIN _tmpItem ON _tmpItem.GoodsId = tmpMI_Child.KeyId 
                              AND _tmpItem.DescId_mi = zc_MI_Detail()
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
            
            LEFT JOIN Object AS Object_Detail ON Object_Detail.Id = _tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_Detail
                                   ON ObjectString_Article_Detail.ObjectId = Object_Detail.Id
                                  AND ObjectString_Article_Detail.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Detail ON ObjectDesc_Detail.Id = Object_Detail.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)

            LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = _tmpItem.ObjectId_basis
            LEFT JOIN ObjectString AS ObjectString_Article_basis
                                   ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                  AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article()

            LEFT JOIN Object AS Object_ReceiptLevel ON Object_ReceiptLevel.Id = _tmpItem.ReceiptLevelId
            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId
            LEFT JOIN ObjectLink AS ObjectLink_ProdOptions_MaterialOptions
                                 ON ObjectLink_ProdOptions_MaterialOptions.ObjectId = Object_ProdOptions.Id
                                AND ObjectLink_ProdOptions_MaterialOptions.DescId   = zc_ObjectLink_ProdOptions_MaterialOptions()
            LEFT JOIN Object AS Object_MaterialOptions_opt ON Object_MaterialOptions_opt.Id = ObjectLink_ProdOptions_MaterialOptions.ChildObjectId

            -- Итого остаток
            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = _tmpItem.ObjectId
            -- Итого перемещение
            LEFT JOIN tmpSend ON tmpSend.GoodsId = _tmpItem.ObjectId 
  ;

  /*
 1) № пп узла 
 2) артикул  (Узел) 
 3) назв узла 
 4)  назв Узел-пф 
 5) ReceiptLevel 
  6)Опция 
 7) артикул + Название комплектубшие 
 8) zc_MI_Detail.Amount - изменение в гриде 
 + изменение в гриде товара 

 + кнопки  (внизу панель ) добавить изм удалить 

 + остаток на гл складе
 + перемещ с гл склада в привязке к этому заказу 
 + вверху отчет движение товара по накладным на гл складе

*/

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.08.25         *
*/

-- тест
-- SELECT * from gpSelect_MI_OrderClient_detail (inMovementId:= 5489, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());

