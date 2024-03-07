-- Function: gpInsertUpdate_Movement_MobileProductionUnion()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MobileProductionUnion(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MobileProductionUnion(
    IN inMovementItemId      Integer  ,  -- строка документа заказа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOrderClient Integer;
   DECLARE vbProductionUnionId Integer;
   DECLARE vbProductionUnionMIId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
    vbUserId := lpGetUserBySession (inSession);
    
    IF NOT EXISTS(SELECT MovementItem.Id
                  FROM MovementItem
                  
                       INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                                AND OI.descid = zc_Movement_OrderInternal() 
                                                AND OI.StatusId <> zc_Enum_Status_Erased() 
                  
                  WHERE MovementItem.Id = inMovementItemId 
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = False)
    THEN
      RAISE EXCEPTION 'Ошибка. По штрихкоду заказ на производство не найден.';
    END IF;
    
    IF EXISTS(SELECT MovementItem.Id
              FROM MovementItem 

                   INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                            AND OI.descid = zc_Movement_OrderInternal() 
                                            AND OI.StatusId <> zc_Enum_Status_Erased()

                   INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                               AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                    
                   INNER JOIN MovementItem AS MI_Master
                                           ON MI_Master.ObjectId   = MovementItem.ObjectId
                                          AND MI_Master.DescId = zc_MI_Master() 
                                          AND MI_Master.isErased   = FALSE

                   INNER JOIN MovementItemFloat AS MIFloat_PU
                                                ON MIFloat_PU.MovementItemId = MI_Master.Id
                                               AND MIFloat_PU.DescId         = zc_MIFloat_MovementId()
                                               AND MIFloat_PU.valuedata      = MIFloat_MovementId.valuedata

                   INNER JOIN Movement AS PU ON PU.Id = MI_Master.MovementId 
                                            AND PU.descid = zc_Movement_ProductionUnion() 
                                            AND PU.StatusId <> zc_Enum_Status_Erased()
                    
              WHERE MovementItem.Id = inMovementItemId 
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = False)
    THEN
      RAISE EXCEPTION 'Ошибка. Документ сборки узла/лодки уже создан.';
    END IF;

    --
    SELECT lpInsertUpdate_Movement_ProductionUnion(ioId                       := 0
                                                 , inParentId                 := MIFloat_MovementId.ValueData::Integer
                                                 , inInvNumber                := CAST (NEXTVAL ('movement_ProductionUnion_seq') AS TVarChar)
                                                 , inOperDate                 := CURRENT_DATE
                                                 , inFromId                   := CASE -- Если лодка
                                                                                       WHEN EXISTS(SELECT FROM Object AS Object_Product WHERE Object_Product.Id = MovementItem.ObjectId AND Object_Product.DescId= zc_Object_Product())
                                                                                            -- Участок сборки Основной
                                                                                            THEN 33347
                                                                                       -- На каком участке происходит сборка Узла
                                                                                       WHEN COALESCE(Object_ReceiptGoods_find_View.unitid_parent_receipt, 0) <> 0         
                                                                                            -- На каком участке происходит сборка Узла
                                                                                            THEN Object_ReceiptGoods_find_View.unitid_parent_receipt          
                                                                                       -- узел Стеклопластик + Опция
                                                                                       WHEN Object_ReceiptGoods_find_View.isReceiptGoods_group = TRUE AND Object_ReceiptGoods_find_View.isProdOptions = TRUE
                                                                                            -- Склад Основной
                                                                                            THEN 35139

                                                                                       -- Опция
                                                                                       WHEN Object_ReceiptGoods_find_View.isProdOptions = TRUE
                                                                                            -- Склад Основной
                                                                                            THEN 35139

                                                                                       -- узел
                                                                                       WHEN Object_ReceiptGoods_find_View.isReceiptGoods_group = TRUE
                                                                                            -- Склад Основной
                                                                                            THEN 35139

                                                                                       -- Деталь + НЕ Узел + есть Unit-ПФ
                                                                                       WHEN Object_ReceiptGoods_find_View.isReceiptGoods = TRUE AND Object_ReceiptGoods_find_View.isReceiptGoods_group = FALSE AND Object_ReceiptGoods_find_View.UnitName_child_receipt <> ''
                                                                                            THEN Object_ReceiptGoods_find_View.UnitId_child_receipt

                                                                                       -- Участок сборки Hypalon
                                                                                       WHEN Object_ReceiptGoods_find_View.UnitId_receipt = 38875
                                                                                            THEN Object_ReceiptGoods_find_View.UnitId_receipt

                                                                                       -- Участок UPHOLSTERY
                                                                                       WHEN Object_ReceiptGoods_find_View.UnitId_receipt = 253225
                                                                                            THEN Object_ReceiptGoods_find_View.UnitId_receipt

                                                                                       -- Склад Основной
                                                                                       ELSE 35139

                                                                                  END  
                                                 , inToId                     := CASE -- Если лодка
                                                                                       WHEN EXISTS(SELECT FROM Object AS Object_Product WHERE Object_Product.Id = MovementItem.ObjectId AND Object_Product.DescId= zc_Object_Product())
                                                                                            -- Склад Основной
                                                                                            THEN 35139
                                                                                            -- На каком участке происходит расход Узла/Детали на сборку
                                                                                       ELSE Object_ReceiptGoods_find_View.UnitId_receipt
                                                                                  END      
                                                 , inInvNumberInvoice         := ''
                                                 , inComment                  := ''
                                                 , inUserId                   := vbUserId)
         , MIFloat_MovementId.ValueData::Integer
    INTO vbProductionUnionId
       , vbOrderClient
    FROM MovementItem
                  
         INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                  AND OI.descid = zc_Movement_OrderInternal() 
                                  AND OI.StatusId <> zc_Enum_Status_Erased() 
                  
         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

         LEFT JOIN Object_ReceiptGoods_find_View ON Object_ReceiptGoods_find_View.GoodsId = MovementItem.ObjectId
        
    WHERE MovementItem.Id = inMovementItemId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = False;
            
     WITH -- Заказ Клиента строки
         tmpMI_all AS (--
                   SELECT MovementItem.Id
                        , MovementItem.MovementId
                        , MovementItem.DescId
                        , MovementItem.Amount
                          -- Узел / Комплектующие
                        , MovementItem.ObjectId
                          -- какой Узел собирается - только для zc_MI_Detail
                        , MILinkObject_Goods.ObjectId AS GoodsId
                          -- "базовый" или "виртуальный-ПФ" Узел
                        , MILinkObject_Goods_basis.ObjectId AS GoodsId_basis

                   FROM MovementItem 
                   
                        -- какой Узел собирается
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                         ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                                                        -- для этого элемента
                                                        AND MovementItem.DescId               = zc_MI_Detail()
                        -- "базовый" или "виртуальный-ПФ" Узел
                        LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                         ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                   WHERE MovementItem.MovementId = vbOrderClient
                     AND MovementItem.DescId     IN (zc_MI_Child(), zc_MI_Detail())
                     -- !!!никогда в журнале не показывать удаленные элементы!!!
                     AND MovementItem.isErased   = FALSE
                  )
       , tmpMI AS (-- только узлы
                   SELECT tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                          -- Узел
                        , tmpMI_all.ObjectId
                          -- тот же самый
                        , tmpMI_all.ObjectId AS ObjectId_orig
                          --
                        , tmpMI_all.Amount
                          -- "базовый" Узел
                        , tmpMI_all.GoodsId_basis
                   FROM tmpMI_all
                        -- если Узел собирается
                        JOIN (SELECT DISTINCT tmpMI_all.MovementId, tmpMI_all.GoodsId FROM tmpMI_all WHERE tmpMI_all.DescId = zc_MI_Detail()
                             ) AS tmpMI_Detail
                               ON tmpMI_Detail.MovementId = tmpMI_all.MovementId
                              AND tmpMI_Detail.GoodsId    = tmpMI_all.ObjectId
                   WHERE tmpMI_all.DescId = zc_MI_Child()

                  UNION ALL
                   -- "виртуальный-ПФ" Узел
                   SELECT DISTINCT
                          tmpMI_all.Id
                        , tmpMI_all.MovementId
                        , tmpMI_all.DescId
                          -- "виртуальный-ПФ" Узел
                        , tmpMI_Detail.GoodsId_basis AS ObjectId
                          -- Узел
                        , tmpMI_all.ObjectId AS ObjectId_orig
                          --
                        , 1 :: TFloat AS Amount
                          -- "базовый" Узел
                        , tmpMI_all.GoodsId_basis
                   FROM tmpMI_all
                        -- если Узел собирается
                        JOIN (SELECT DISTINCT tmpMI_all.MovementId, tmpMI_all.GoodsId, tmpMI_all.GoodsId_basis FROM tmpMI_all
                              WHERE tmpMI_all.DescId = zc_MI_Detail()
                                -- установлен "виртуальный-ПФ"
                               AND  tmpMI_all.GoodsId_basis > 0
                             ) AS tmpMI_Detail
                               ON tmpMI_Detail.MovementId = tmpMI_all.MovementId
                              AND tmpMI_Detail.GoodsId    = tmpMI_all.ObjectId
                   WHERE tmpMI_all.DescId = zc_MI_Child()
                  )

       , tmpItem AS (SELECT MovementItem.MovementId AS MovementId
                          , MovementItem.Id         AS MovementItemId
                          , MovementItem.DescId     AS DescId
                          , MovementItem.Amount     AS Amount
                            -- Узел или "виртуальный-ПФ" Узел или Комплектующие
                          , MovementItem.ObjectId
                            -- Узел
                          , MovementItem.ObjectId_orig
                            -- "базовый" Узел
                          , MovementItem.GoodsId_basis

                            -- только для zc_MI_Detail
                          , COALESCE (MILinkObject_ReceiptLevel.ObjectId, 0)      AS ReceiptLevelId
                          , COALESCE (MILinkObject_ProdOptions.ObjectId, 0)       AS ProdOptionsId
                          , COALESCE (MILinkObject_ColorPattern.ObjectId, 0)      AS ColorPatternId
                          , COALESCE (MILinkObject_ProdColorPattern.ObjectId, 0)  AS ProdColorPatternId

                     FROM tmpMI AS MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                           ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                           ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                           ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                           ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                    )
           -- Шаблон сборки Узла
         , tmpReceiptGoods AS (SELECT tmpItem.ObjectId_orig  AS ObjectId_orig
                                    , Object_ReceiptGoods.Id AS ReceiptGoodsId
                               FROM (SELECT DISTINCT tmpItem.ObjectId_orig FROM tmpItem) AS tmpItem
                                    -- нашли его в сборке узлов
                                    INNER JOIN ObjectLink AS ObjectLink_ReceiptGoods_Object
                                                          ON ObjectLink_ReceiptGoods_Object.ChildObjectId = tmpItem.ObjectId_orig
                                                         AND ObjectLink_ReceiptGoods_Object.DescId        = zc_ObjectLink_ReceiptGoods_Object()
                                    -- не удален
                                    INNER JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id       = ObjectLink_ReceiptGoods_Object.ObjectId
                                                                            AND Object_ReceiptGoods.isErased = FALSE
                                    -- это главный шаблон сборки узлов
                                    INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                             ON ObjectBoolean_Main.ObjectId  = ObjectLink_ReceiptGoods_Object.ObjectId
                                                            AND ObjectBoolean_Main.DescId    = zc_ObjectBoolean_ReceiptGoods_Main()
                                                            AND ObjectBoolean_Main.ValueData = TRUE
                              )
           -- Результат
         , tmpOrderClient AS (SELECT Object_Object.Id                         AS ObjectId
                                   , Object_Object.ObjectCode                 AS ObjectCode
                                   , ObjectString_Article_Object.ValueData    AS Article_Object
                                   , Object_Object.ValueData                  AS ObjectName
                                   , ObjectDesc_Object.ItemName               AS DescName

                                   , Object_Object_basis.Id                   AS GoodsId_basis
                                   , Object_Object_basis.ObjectCode           AS GoodsCode_basis
                                   , Object_Object_basis.ValueData            AS GoodsName_basis
                                   , ObjectString_Article_basis.ValueData     AS Article_basis

                                   , Object_ReceiptGoods.Id                   AS ReceiptGoodsId
                                   , Object_ReceiptGoods.ObjectCode           AS ReceiptGoodsCode
                                   , Object_ReceiptGoods.ValueData            AS ReceiptGoodsName

                              FROM tmpItem  
                                
                                   LEFT JOIN Object AS Object_Object ON Object_Object.Id = tmpItem.ObjectId

                                   LEFT JOIN tmpReceiptGoods ON tmpReceiptGoods.ObjectId_orig = tmpItem.ObjectId_orig
                                   LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = tmpReceiptGoods.ReceiptGoodsId

                                   LEFT JOIN ObjectString AS ObjectString_Article_object
                                                          ON ObjectString_Article_object.ObjectId = Object_Object.Id
                                                         AND ObjectString_Article_object.DescId   = zc_ObjectString_Article()
                                   LEFT JOIN ObjectDesc AS ObjectDesc_Object ON ObjectDesc_Object.Id = Object_Object.DescId

                                   LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = tmpItem.ObjectId_orig
                                   --LEFT JOIN Object AS Object_Object_basis ON Object_Object_basis.Id = tmpItem.GoodsId_basis

                                   LEFT JOIN ObjectString AS ObjectString_Article_basis
                                                          ON ObjectString_Article_basis.ObjectId = Object_Object_basis.Id
                                                         AND ObjectString_Article_basis.DescId   = zc_ObjectString_Article())

      
    SELECT gpInsertUpdate_MovementItem_ProductionUnion(ioId                     := 0
                                                     , inMovementId             := vbProductionUnionId
                                                     , inMovementId_OrderClient := MIFloat_MovementId.ValueData::Integer
                                                     , inObjectId               := MovementItem.ObjectId 
                                                     , inReceiptProdModelId     := COALESCE(tmpOrderClient.ReceiptGoodsId, ObjectLink_Product_ReceiptProdModel.ChildObjectId)
                                                     , inAmount                 := MovementItem.Amount
                                                     , inComment                := ''
                                                     , inSession                := inSession
                                                       )      
    INTO vbProductionUnionMIId
    FROM MovementItem
                  
         INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                  AND OI.descid = zc_Movement_OrderInternal() 
                                  AND OI.StatusId <> zc_Enum_Status_Erased() 
                  
         INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                      ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()


         LEFT JOIN ObjectLink AS ObjectLink_Product_ReceiptProdModel
                              ON ObjectLink_Product_ReceiptProdModel.ObjectId = MovementItem.ObjectId
                             AND ObjectLink_Product_ReceiptProdModel.DescId   = zc_ObjectLink_Product_ReceiptProdModel()

         LEFT JOIN tmpOrderClient ON tmpOrderClient.ObjectId = MovementItem.ObjectId
                                                                      
    WHERE MovementItem.Id = inMovementItemId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = False;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_MobileProductionUnion(559363, zfCalc_UserAdmin());