-- Function: gpGet_Goods_MobilebyOrderInternal()

DROP FUNCTION IF EXISTS gpGet_Goods_MobilebyOrderInternal(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_MobilebyOrderInternal(
    IN inMovementItemId      Integer  ,  -- строка документа заказа
    IN inSession             TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar, PartNumber TVarChar
             , PartionCellId Integer, PartionCellName TVarChar
             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar
             , isErased Boolean
              ) 
AS 
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbFromId        Integer;
   DECLARE vbToId          Integer;
   DECLARE vbPUId          Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
    vbUserId := lpGetUserBySession (inSession);
        
    SELECT PU.Id
    INTO vbPUId
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
      AND MovementItem.isErased = False;
    
    -- Найдем подразделения            
    IF COALESCE (vbPUId, 0) = 0
    THEN

      SELECT CASE -- Если лодка
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
      , CASE -- Если лодка
             WHEN EXISTS(SELECT FROM Object AS Object_Product WHERE Object_Product.Id = MovementItem.ObjectId AND Object_Product.DescId= zc_Object_Product())
                  -- Склад Основной
                  THEN 35139
                  -- На каком участке происходит расход Узла/Детали на сборку
             ELSE Object_ReceiptGoods_find_View.UnitId_receipt
        END      
      INTO vbFromId
         , vbToId
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
        
    ELSE

      SELECT MLO_From.ObjectId, MLO_To.ObjectId
      INTO vbFromId, vbToId
      FROM Movement
           LEFT JOIN MovementLinkObject AS MLO_From
                                        ON MLO_From.MovementId = Movement.Id
                                       AND MLO_From.DescId     = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MLO_To
                                        ON MLO_To.MovementId = Movement.Id
                                       AND MLO_To.DescId     = zc_MovementLinkObject_To()
      WHERE Movement.Id = vbPUId;
         
    END IF;
            

    -- Результат такой
    RETURN QUERY
      WITH tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                               , Sum(Container.Amount)::TFloat AS Remains
                          FROM Container
                          WHERE Container.WhereObjectId = vbFromId
                            AND Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId      = (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
                            AND Container.Amount <> 0
                          GROUP BY Container.ObjectId
                          HAVING Sum(Container.Amount) <> 0
                         )
         , tmpMovement AS (SELECT Movement.Id
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MLO_From
                                                              ON MLO_From.MovementId = Movement.Id
                                                             AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                             AND MLO_From.ObjectId   = vbFromId
                           WHERE Movement.DescId   = zc_Movement_Send()
                             AND Movement.StatusId <> zc_Enum_Status_Erased()
                             AND Movement.OperDate = CURRENT_DATE) 
       
          , tmpData AS (SELECT MovementItem.ObjectId             AS GoodsId
                             , SUM(MovementItem.Amount)::TFloat  AS TotalCount
                        FROM tmpMovement AS Movement
                        
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Scan()
                                                    AND MovementItem.isErased   = False
                                                    
                        GROUP BY MovementItem.ObjectId
                       )

     
     SELECT
           0::Integer                          AS Id
         , Object_Goods.Id                     AS GoodsId
         , Object_Goods.ObjectCode             AS GoodsCode
         , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
         , ObjectString_Article.ValueData      AS Article 
         , ObjectString_EAN.ValueData          AS EAN
         , Object_GoodsGroup.Id                AS GoodsGroupId
         , Object_GoodsGroup.ValueData         AS GoodsGroupName
         , Object_Measure.ValueData            AS MeasureName
         , ''::TVarChar                        AS PartNumber
           
         , NULL::Integer                       AS PartionCellId
         , NULL::TVarChar                      AS PartionCellName

         , tmpMI.Amount                        AS Amount
         , tmpData.TotalCount ::TFloat         AS TotalCount
         , COALESCE(tmpRemains.Remains, 0) ::TFloat  AS AmountRemains

         , vbFromId
         , Object_From.ObjectCode              AS FromCode
         , Object_From.ValueData               AS FromName
         , vbToId
         , Object_ToId.ObjectCode              AS ToCode
         , Object_ToId.ValueData               AS ToName

         , Movement_OrderClient.Id             AS MovementId_OrderClient
         , Movement_OrderClient.InvNumber      AS InvNumber_OrderClient

         , False                               AS isErased

     FROM MovementItem AS tmpMI

          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.ObjectId

          LEFT JOIN Object AS Object_From ON Object_From.Id = vbFromId
          LEFT JOIN Object AS Object_ToId ON Object_ToId.Id = vbToId

          LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                               ON OL_Goods_GoodsGroup.ObjectId = tmpMI.ObjectId
                              AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
          LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

          LEFT JOIN ObjectLink AS OL_Goods_Measure
                               ON OL_Goods_Measure.ObjectId = tmpMI.ObjectId
                              AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
          LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Article
                                 ON ObjectString_Article.ObjectId = tmpMI.ObjectId
                                AND ObjectString_Article.DescId   = zc_ObjectString_Article()
          LEFT JOIN ObjectString AS ObjectString_EAN
                                 ON ObjectString_EAN.ObjectId = tmpMI.ObjectId
                                AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()

          LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = tmpMI.ObjectId

          LEFT JOIN tmpData ON tmpData.GoodsId = tmpMI.ObjectId

          LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                      ON MIFloat_MovementId.MovementItemId = tmpMI.Id
                                     AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                     
          LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MIFloat_MovementId.ValueData::Integer
 
     WHERE tmpMI.Id = inMovementItemId;
      

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Goods_MobilebyOrderInternal(559363, zfCalc_UserAdmin());