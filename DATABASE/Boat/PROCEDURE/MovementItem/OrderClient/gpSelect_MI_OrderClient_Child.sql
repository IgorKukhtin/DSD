-- Function: gpSelect_MI_Invoice_Child()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderClient_Child (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderClient_Child(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS SETOF refcursor
/*RETURNS TABLE (Id Integer
             , ObjectId Integer, ObjectCode Integer, Article_Object TVarChar, ObjectName TVarChar, DescName TVarChar
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PartnerId_goods Integer, PartnerName_goods TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Amount TFloat, AmountPartner TFloat
             , OperPrice TFloat
             , TotalSumm_unit TFloat
             , TotalSumm_partner TFloat
             , TotalSumm TFloat
             , isErased Boolean
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar
             , MeasureName TVarChar
             , GoodsTagName    TVarChar
             , GoodsTypeName   TVarChar
             , ProdColorName   TVarChar
             , ProdOptionsName TVarChar
             , TaxKindName    TVarChar
             , Amount_in      TFloat -- Итого кол-во Приход от поставщика
             , EKPrice        TFloat -- Цена вх.
             , CountForPrice  TFloat -- Кол. в цене вх.
             , OperPriceList  TFloat -- Цена по прайсу
             , CostPrice      TFloat -- Цена вх + затрата
             , OperPrice_cost TFloat -- сумма затраты

             , MovementId_OrderPartner Integer
             , InvNumber               Integer
             , OperDate                TDateTime
             , OperDatePartner         TDateTime

             , PartNumber TVarChar

              )*/
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReceiptProdModelId Integer;

   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры

     vbUserId:= lpGetUserBySession (inSession);
     
     --из шапки лодка по ней находим модель
     vbReceiptProdModelId := (SELECT ObjectLink_Product_ReceiptProdModel.ChildObjectId
                              FROM MovementLinkObject AS MovementLinkObject_Product
                                   LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                                                        ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementLinkObject_Product.ObjectId
                                                       AND ObjectLink_Product_ReceiptProdModel.DescId = zc_ObjectLink_Product_ReceiptProdModel()
                              WHERE MovementLinkObject_Product.MovementId = inMovementId
                                AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
                              );

     -- таблица - элементы документа, со всеми свойствами
     CREATE TEMP TABLE _tmpItem (MovementItemId Integer, ParentId Integer, PartionId Integer
                               , UnitId Integer, PartnerId Integer
                               , GoodsId Integer, ObjectId Integer
                               , ProdOptionsId Integer
                               , ColorPatternId Integer
                               , ProdColorPatternId  Integer
                               , Amount TFloat
                               , AmountBasis TFloat
                               , AmountPartner TFloat
                               , OperPrice TFloat
                               , OperPricePartner TFloat
                               , isErased Boolean
                                ) ON COMMIT DROP;
     -- элементы документа
     INSERT INTO _tmpItem (MovementItemId, ParentId, PartionId, UnitId, PartnerId, GoodsId, ObjectId, ProdOptionsId, ColorPatternId, ProdColorPatternId, Amount, AmountBasis, AmountPartner, OperPrice, OperPricePartner, isErased)
        SELECT MovementItem.Id                           AS MovementItemId
             , COALESCE (MovementItem.ParentId, 0)       AS ParentId
             , MovementItem.PartionId                    AS PartionId
             , MILinkObject_Unit.ObjectId                AS UnitId
             , MILinkObject_Partner.ObjectId             AS PartnerId

             , COALESCE (MILinkObject_Goods.ObjectId, 0) AS GoodsId
             , MovementItem.ObjectId                     AS ObjectId
             , MILinkObject_ProdOptions.ObjectId         AS ProdOptionsId
             , MILinkObject_ColorPattern.ObjectId        AS ColorPatternId
             , MILinkObject_ProdColorPattern.ObjectId    AS ProdColorPatternId

             , MovementItem.Amount                       AS Amount
             , MIFloat_AmountBasis.ValueData             AS AmountBasis
             , MIFloat_AmountPartner.ValueData           AS AmountPartner
             , MIFloat_OperPrice.ValueData               AS OperPrice
             , MIFloat_OperPricePartner.ValueData        AS OperPricePartner
               -- !!! временно для отладки
           --,  CASE WHEN MS.ValueData = '1' THEN MIFloat_OperPrice.ValueData

             , MovementItem.isErased

        FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
             INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Child()
                                    AND MovementItem.isErased   = tmpIsErased.isErased
               -- !!! временно для отладки
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
             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                              ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                             AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                              ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                             AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
             LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                              ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                             AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountBasis
                                         ON MIFloat_AmountBasis.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountBasis.DescId         = zc_MIFloat_AmountBasis()
             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                         ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
             LEFT JOIN MovementItemFloat AS MIFloat_OperPricePartner
                                         ON MIFloat_OperPricePartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_OperPricePartner.DescId         = zc_MIFloat_OperPricePartner()
            ;


     -- таблица - элементы ProdColorItems
     CREATE TEMP TABLE _tmpProdColorItems (ProductId Integer, ProdColorPatternId Integer, GoodsId Integer, ProdColorName TVarChar) ON COMMIT DROP;
     --
     INSERT INTO _tmpProdColorItems (ProductId, ProdColorPatternId, GoodsId, ProdColorName)
        SELECT ObjectLink_Product.ChildObjectId          AS ProductId
             , ObjectLink_ProdColorPattern.ChildObjectId AS ProdColorPatternId
             , ObjectLink_Goods.ChildObjectId            AS GoodsId
               -- здесь цвет (когда нет GoodsId)
             , CASE WHEN ObjectLink_Goods.ChildObjectId > 0 THEN COALESCE (Object_ProdColor.ValueData) WHEN TRIM (ObjectString_Comment.ValueData) <> '' THEN TRIM (ObjectString_Comment.ValueData) ELSE TRIM (COALESCE (ObjectString_ProdColorPattern_Comment.ValueData, '')) END AS ProdColorName

        FROM Object AS Object_ProdColorItems
             -- Лодка
             INNER JOIN ObjectLink AS ObjectLink_Product
                                   ON ObjectLink_Product.ObjectId = Object_ProdColorItems.Id
                                  AND ObjectLink_Product.DescId   = zc_ObjectLink_ProdColorItems_Product()
             -- Заказ Клиента
             INNER JOIN ObjectFloat AS ObjectFloat_MovementId_OrderClient
                                    ON ObjectFloat_MovementId_OrderClient.ObjectId  = Object_ProdColorItems.Id
                                   AND ObjectFloat_MovementId_OrderClient.DescId    = zc_ObjectFloat_ProdColorItems_OrderClient()
                                   AND ObjectFloat_MovementId_OrderClient.ValueData = inMovementId

             -- здесь цвет, если было изменение для Лодки (когда нет GoodsId)
             LEFT JOIN ObjectString AS ObjectString_Comment
                                    ON ObjectString_Comment.ObjectId = Object_ProdColorItems.Id
                                   AND ObjectString_Comment.DescId   = zc_ObjectString_ProdColorItems_Comment()

             -- если меняли на другой товар, не тот что в ReceiptGoodsChild
             LEFT JOIN ObjectLink AS ObjectLink_Goods
                                  ON ObjectLink_Goods.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_Goods.DescId   = zc_ObjectLink_ProdColorItems_Goods()
             -- цвет
             LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                  ON ObjectLink_ProdColor.ObjectId = ObjectLink_Goods.ChildObjectId
                                 AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
             LEFT JOIN Object AS Object_ProdColor ON Object_ProdColor.Id = ObjectLink_ProdColor.ChildObjectId
             -- Элемент
             LEFT JOIN ObjectLink AS ObjectLink_ProdColorPattern
                                  ON ObjectLink_ProdColorPattern.ObjectId = Object_ProdColorItems.Id
                                 AND ObjectLink_ProdColorPattern.DescId   = zc_ObjectLink_ProdColorItems_ProdColorPattern()
             -- здесь цвет из Boat Structure (когда нет GoodsId)
             LEFT JOIN ObjectString AS ObjectString_ProdColorPattern_Comment
                                    ON ObjectString_ProdColorPattern_Comment.ObjectId = ObjectLink_ProdColorPattern.ChildObjectId
                                   AND ObjectString_ProdColorPattern_Comment.DescId   = zc_ObjectString_ProdColorPattern_Comment()

        WHERE Object_ProdColorItems.DescId   = zc_Object_ProdColorItems()
          AND Object_ProdColorItems.isErased = FALSE
       ;

     -- таблица - элементы _tmpReceiptLevel
     CREATE TEMP TABLE _tmpReceiptLevel (GoodsId Integer, ReceiptLevelName TVarChar) ON COMMIT DROP;
     --
     INSERT INTO _tmpReceiptLevel ( GoodsId, ReceiptLevelName)
        SELECT DISTINCT
               _tmpItem.ObjectId AS GoodsId
             , Object_ReceiptLevel.ValueData :: TVarChar AS ReceiptLevelName
        FROM _tmpItem
            LEFT JOIN ObjectLink AS ObjectLink_ReceiptProdModelChild_Object
                                 ON ObjectLink_ReceiptProdModelChild_Object.ChildObjectId = _tmpItem.ObjectId
                                AND ObjectLink_ReceiptProdModelChild_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
            ---берем  не удаленные
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
       ;

     -- Результат
     OPEN Cursor1 FOR
      WITH tmpSumm AS (SELECT _tmpItem.ParentId
                            , SUM (_tmpItem.Amount) AS Amount_unit
                            , SUM (_tmpItem.Amount * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice))  AS TotalSumm_unit
                            , SUM (_tmpItem.Amount * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0)))  AS TotalSummCost_unit
                            , STRING_AGG (DISTINCT COALESCE (MIString_PartNumber.ValueData, ''), '; ') AS PartNumber
                            , STRING_AGG (DISTINCT COALESCE (Object_Unit.ValueData, ''), '; ')         AS UnitName
                       FROM _tmpItem
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId
                            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
                            LEFT JOIN MovementItemString AS MIString_PartNumber
                                                         ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
                       WHERE _tmpItem.ParentId > 0
                       GROUP BY _tmpItem.ParentId
                      )
         , tmpProdColor AS (SELECT _tmpItem.GoodsId
                                 , STRING_AGG (_tmpProdColorItems.ProdColorName, '; ') AS ProdColorName
                            FROM _tmpItem
                                 JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpItem.ProdColorPatternId
                                                        AND _tmpProdColorItems.ProdColorName      <> ''
                            WHERE _tmpItem.GoodsId > 0
                            GROUP BY _tmpItem.GoodsId
                           )
 
      SELECT
             _tmpItem.MovementItemId                  AS MovementItemId
           , _tmpItem.ObjectId                        AS KeyId

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , Object_Object.ValueData                  AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName

           , 0 :: Integer                             AS UnitId
           , tmpSumm.UnitName :: TVarChar             AS UnitName
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

           , _tmpItem.AmountBasis                            AS Amount_basis   -- Количество шаблон сборки
           --,  COALESCE (tmpSumm.Amount_unit, _tmpItem.Amount) AS Amount_unit    -- Количество резерв
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_Goods()          THEN COALESCE (tmpSumm.Amount_unit, _tmpItem.Amount) ELSE 0 END ::TFloat   AS Amount_unit    -- Количество резерв
           , CASE WHEN ObjectDesc_Object.Id = zc_Object_ReceiptService() THEN COALESCE (tmpSumm.Amount_unit, _tmpItem.Amount) ELSE 0 END ::TFloat   AS Value_service  -- работы/услуги
           
           
           
           , _tmpItem.AmountPartner                          AS Amount_partner -- Количество заказ поставщику

           , _tmpItem.OperPrice                       AS OperPrice_basis   -- Цена вх без НДС
           , _tmpItem.OperPricePartner                AS OperPrice_partner -- Цена вх без НДС
             -- Цена вх. с затратами без НДС
           , CASE WHEN tmpSumm.Amount_unit > 0 THEN COALESCE (tmpSumm.TotalSummCost_unit / tmpSumm.Amount_unit) ELSE 0 END :: TFloat AS OperPrice_unit

           , (_tmpItem.AmountBasis   * _tmpItem.OperPrice)        :: TFloat AS TotalSumm_basis
           , COALESCE (tmpSumm.TotalSummCost_unit, _tmpItem.Amount * _tmpItem.OperPrice) :: TFloat AS TotalSumm_unit
           , (_tmpItem.AmountPartner * _tmpItem.OperPricePartner) :: TFloat AS TotalSumm_partner

           , (COALESCE (tmpSumm.TotalSummCost_unit, _tmpItem.Amount * _tmpItem.OperPrice, 0)
            + COALESCE (_tmpItem.AmountPartner * _tmpItem.OperPricePartner, 0)) :: TFloat AS TotalSumm_real

           , _tmpItem.isErased

           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , CASE WHEN Object_ProdColor.ValueData <> ''
                  THEN Object_ProdColor.ValueData
                    || CASE WHEN tmpProdColor.ProdColorName <> '' THEN '; ' || tmpProdColor.ProdColorName ELSE '' END
                  ELSE tmpProdColor.ProdColorName
             END :: TVarChar AS ProdColorName
           , Object_ProdOptions.ValueData   AS ProdOptionsName

           , Movement_OrderPartner.Id                                   AS MovementId_OrderPartner
           , zfConvert_StringToNumber (Movement_OrderPartner.InvNumber) AS InvNumber
           , Movement_OrderPartner.OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner

           , tmpSumm.PartNumber :: TVarChar AS PartNumber
           , _tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName

       FROM _tmpItem
            LEFT JOIN tmpProdColor ON tmpProdColor.GoodsId = _tmpItem.ObjectId
            LEFT JOIN tmpSumm      ON tmpSumm.ParentId     = _tmpItem.MovementItemId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = _tmpItem.ObjectId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectLink AS ObjectLink_ProdColor
                                 ON ObjectLink_ProdColor.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_ProdColor.DescId   = zc_ObjectLink_Goods_ProdColor()
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

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = _tmpItem.PartnerId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = ObjectLink_GoodsGroup.ChildObjectId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = ObjectLink_Measure.ChildObjectId
            LEFT JOIN Object AS Object_GoodsTag    ON Object_GoodsTag.Id    = ObjectLink_GoodsTag.ChildObjectId
            LEFT JOIN Object AS Object_GoodsType   ON Object_GoodsType.Id   = ObjectLink_GoodsType.ChildObjectId
            LEFT JOIN Object AS Object_ProdColor   ON Object_ProdColor.Id   = ObjectLink_ProdColor.ChildObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_OrderPartner.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

            LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = _tmpItem.ObjectId--  and 1=0

       -- без этой структуры
       WHERE _tmpItem.GoodsId  = 0
         AND _tmpItem.ParentId = 0
      ;
     RETURN NEXT Cursor1;


     -- Результат
     OPEN Cursor2 FOR
      SELECT _tmpItem.MovementItemId                  AS MovementItemId
           , COALESCE (_tmpItem_parent.ObjectId, _tmpItem.GoodsId) :: Integer AS KeyId

           , Object_Object.Id                         AS ObjectId
           , Object_Object.ObjectCode                 AS ObjectCode
           , ObjectString_Article_Object.ValueData    AS Article_Object
           , CASE WHEN Object_Object.DescId = zc_Object_ProdColorPattern()
                       THEN Object_ProdColorGroup.ValueData || ' ' || Object_Object.ValueData
                  ELSE Object_Object.ValueData
             END :: TVarChar AS ObjectName
           , ObjectDesc_Object.ItemName               AS DescName

           , Object_Unit.Id                           AS UnitId
           , Object_Unit.ValueData                    AS UnitName
           , Object_Partner.Id                        AS PartnerId
           , Object_Partner.ValueData                 AS PartnerName

           , _tmpItem.AmountBasis                     AS Amount_basis       -- Количество шаблон сборки
           , CASE WHEN Object_Object.DescId = zc_Object_ReceiptService() THEN 0 ELSE _tmpItem.Amount END :: TFloat AS Amount_unit        -- Количество резерв
           , _tmpItem.AmountPartner                   AS Amount_partner     -- Количество заказ поставщику

           , _tmpItem.OperPrice                       AS OperPrice_basis   -- Цена вх без НДС
           , _tmpItem.OperPricePartner                AS OperPrice_partner   -- Цена вх без НДС
             -- Цена вх. с затратами без НДС
           , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0)) :: TFloat AS OperPrice_unit

           , (_tmpItem.AmountBasis   * _tmpItem.OperPrice) :: TFloat AS TotalSumm_basis
           , (_tmpItem.Amount        * (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice, 0))) :: TFloat AS TotalSumm_unit
           , (_tmpItem.AmountPartner * _tmpItem.OperPricePartner) :: TFloat AS TotalSumm_partner

           , _tmpItem.isErased

           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName
           , _tmpProdColorItems.ProdColorName :: TVarChar AS ProdColorName
           , Object_ProdOptions.ValueData   AS ProdOptionsName

           , Object_PartionGoods.Amount     AS Amount_in
           , Object_PartionGoods.CountForPrice

             -- Цена затрат без НДС
           , Object_PartionGoods.CostPrice :: TFloat CostPrice

           , Movement_OrderPartner.Id                                   AS MovementId_OrderPartner
           , zfConvert_StringToNumber (Movement_OrderPartner.InvNumber) AS InvNumber
           , Movement_OrderPartner.OperDate
           , MovementDate_OperDatePartner.ValueData AS OperDatePartner
           
           , MIString_PartNumber.ValueData AS PartNumber

           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber_partion
           , Movement.OperDate  AS OperDate_partion
           
           , _tmpItem.PartionId

           , _tmpReceiptLevel.ReceiptLevelName :: TVarChar AS ReceiptLevelName

       FROM _tmpItem
            LEFT JOIN _tmpItem AS _tmpItem_parent ON _tmpItem_parent.MovementItemId = _tmpItem.ParentId
            
            LEFT JOIN _tmpProdColorItems ON _tmpProdColorItems.ProdColorPatternId = _tmpItem.ProdColorPatternId

            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = _tmpItem.PartionId
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = _tmpItem.PartionId
                                        AND MIString_PartNumber.DescId         = zc_MIString_PartNumber()
            LEFT JOIN Movement ON Movement.Id = Object_PartionGoods.MovementId

            LEFT JOIN Object AS Object_Object ON Object_Object.Id = _tmpItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Article_object
                                   ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                  AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

            LEFT JOIN ObjectLink AS ObjectLink_ProdColorGroup
                                 ON ObjectLink_ProdColorGroup.ObjectId = _tmpItem.ProdColorPatternId
                                AND ObjectLink_ProdColorGroup.DescId    = zc_ObjectLink_ProdColorPattern_ProdColorGroup()
            LEFT JOIN Object AS Object_ProdColorGroup ON Object_ProdColorGroup.Id = ObjectLink_ProdColorGroup.ChildObjectId

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = _tmpItem.UnitId

            LEFT JOIN ObjectLink AS ObjectLink_Measure
                                 ON ObjectLink_Measure.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup
                                 ON ObjectLink_GoodsGroup.ObjectId = _tmpItem.ObjectId
                                AND ObjectLink_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()

            LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = _tmpItem.ProdOptionsId

            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id     = COALESCE (Object_PartionGoods.FromId, _tmpItem.PartnerId)
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = COALESCE (Object_PartionGoods.GoodsGroupId, ObjectLink_GoodsGroup.ChildObjectId)
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = COALESCE (Object_PartionGoods.MeasureId, ObjectLink_Measure.ChildObjectId)

            LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                        ON MIFloat_MovementId.MovementItemId = _tmpItem.MovementItemId
                                       AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
            LEFT JOIN Movement AS Movement_OrderPartner ON Movement_OrderPartner.Id = MIFloat_MovementId.ValueData :: Integer
            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement_OrderPartner.Id
                                  AND MovementDate_OperDatePartner.DescId     = zc_MovementDate_OperDatePartner()

            LEFT JOIN _tmpReceiptLevel ON _tmpReceiptLevel.GoodsId = _tmpItem.ObjectId  and 1=0
     --WHERE _tmpItem.GoodsId > 0
       WHERE Object_Object.DescId <> zc_Object_ProdColorPattern() 
     ;
     RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.16         *
*/

-- тест
-- SELECT * from gpSelect_MI_OrderClient_Child (inMovementId:= 224, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
