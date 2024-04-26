-- Function: gpGet_MovementItem_MobileOrderInternal()

DROP FUNCTION IF EXISTS gpGet_MovementItem_MobileOrderInternal(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_MobileOrderInternal(
    IN inMovementItemId      Integer  ,  -- Ключ объекта <Master OrderInternal>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar

             , Amount TFloat, AmountRemains TFloat
             
             , OperDate TDateTime, InvNumber TVarChar, InvNumberFull TVarChar, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar, InvNumberFull_OrderClient TVarChar, StatusCode_OrderClient Integer, StatusName_OrderClient TVarChar
             , OperDate_OrderInternal TDateTime, InvNumber_OrderInternal TVarChar, InvNumberFull_OrderInternal TVarChar, StatusCode_OrderInternal Integer, StatusName_OrderInternal TVarChar
             , isErased Boolean

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);
    
    IF NOT EXISTS(SELECT MovementItem.Id
              FROM MovementItem
              
                   INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
                                      AND Movement.descid = zc_Movement_OrderInternal() 
                                      AND Movement.StatusId <> zc_Enum_Status_Erased() 
              
              WHERE MovementItem.Id = inMovementItemId 
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.isErased = False)
    THEN
      RAISE EXCEPTION 'Ошибка. Заказ на производство не найден.';
    END IF;
        
     -- Результат такой
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId                          AS GoodsId
                           , Movement.Id                                    AS MovementId
                           , Movement.OperDate
                           , Movement.InvNumber
                           , Movement.StatusId
                           , MovementItem.Amount
                           , MIFloat_MovementId.ValueData :: Integer        AS MovementId_OrderClient

                           , CASE -- Если лодка
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

                             END AS FromId 
                           , CASE -- Если лодка
                                   WHEN EXISTS(SELECT FROM Object AS Object_Product WHERE Object_Product.Id = MovementItem.ObjectId AND Object_Product.DescId= zc_Object_Product())
                                        -- Склад Основной
                                        THEN 35139
                                        -- На каком участке происходит расход Узла/Детали на сборку
                                   ELSE Object_ReceiptGoods_find_View.UnitId_receipt
                             END  AS ToId     


                           , MovementItem.isErased
                      FROM MovementItem 

                           LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                       ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                      AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                                      
                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                           LEFT JOIN Object_ReceiptGoods_find_View ON Object_ReceiptGoods_find_View.GoodsId = MovementItem.ObjectId
                                                        
                      WHERE MovementItem.DescId = zc_MI_Master() 
                        AND MovementItem.Id     = inMovementItemId
                     )
         , tmpProductionUnion AS (SELECT inMovementItemId                               AS MovementItemId
                                       , COALESCE(MI_Scan.id, MI_Master.Id)::Integer    AS ID
                                       , MI_Master.ObjectId                             AS GoodsId
                                       , PU.Id                                          AS MovementId
                                       , PU.OperDate
                                       , PU.InvNumber
                                       , PU.StatusId
                                       , MLO_From.ObjectId                              AS FromId
                                       , MLO_To.ObjectId                                AS ToId
                                       , MI_Master.Amount
                                       , MI_Scan.isErased
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

                                       LEFT JOIN MovementItem AS MI_Scan
                                                              ON MI_Scan.ParentId   = MI_Master.Id
                                                             AND MI_Scan.DescId = zc_MI_Scan() 
                                                             AND MI_Scan.isErased   = FALSE

                                       INNER JOIN MovementItemFloat AS MIFloat_PU
                                                                    ON MIFloat_PU.MovementItemId = MI_Master.Id
                                                                   AND MIFloat_PU.DescId         = zc_MIFloat_MovementId()
                                                                   AND MIFloat_PU.valuedata      = MIFloat_MovementId.valuedata

                                       INNER JOIN Movement AS PU ON PU.Id = MI_Master.MovementId 
                                                                AND PU.descid = zc_Movement_ProductionUnion() 
                                                                AND PU.StatusId <> zc_Enum_Status_Erased()
                                                                
                                       INNER JOIN MovementLinkObject AS MLO_From
                                                                     ON MLO_From.MovementId = PU.Id
                                                                    AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                       INNER JOIN MovementLinkObject AS MLO_To
                                                                     ON MLO_To.MovementId = PU.Id
                                                                    AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                                      
                                        
                                  WHERE MovementItem.Id = inMovementItemId 
                                    AND MovementItem.DescId = zc_MI_Master()
                                    AND MovementItem.isErased = False
                                  )
         , tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                               , Container.WhereObjectId       AS UnitId
                               , Sum(Container.Amount)::TFloat AS Remains
                          FROM Container
                          WHERE Container.DescId        = zc_Container_Count()
                            AND Container.ObjectId IN (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                            AND Container.Amount <> 0
                          GROUP BY Container.WhereObjectId
                                 , Container.ObjectId
                          HAVING Sum(Container.Amount) <> 0
                         )
                         
       -- Результат
       SELECT
             ProductionUnion.Id
           , ProductionUnion.MovementId  
           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , CASE WHEN Object_Goods.isErased = TRUE THEN '***удален ' || Object_Goods.ValueData ELSE Object_Goods.ValueData END :: TVarChar AS GoodsName
           , ObjectString_Article.ValueData      AS Article 
           , ObjectString_EAN.ValueData          AS EAN
           , Object_GoodsGroup.Id                AS GoodsGroupId
           , Object_GoodsGroup.ValueData         AS GoodsGroupName
           , Object_Measure.ValueData            AS MeasureName
           
           , tmpMI.Amount                        AS Amount
           , COALESCE(tmpRemains.Remains, 0) ::TFloat  AS AmountRemains

           , ProductionUnion.OperDate
           , ProductionUnion.InvNumber
           , zfCalc_InvNumber_isErased ('', ProductionUnion.InvNumber, ProductionUnion.OperDate, ProductionUnion.StatusId) AS InvNumberFull
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           
           , COALESCE(ProductionUnion.FromId, tmpMI.FromId) AS FromId
           , Object_From.ObjectCode                      AS FromCode
           , Object_From.ValueData                       AS FromName
           , COALESCE(ProductionUnion.ToId, tmpMI.ToId)  AS ToId
           , Object_ToId.ObjectCode                      AS ToCode
           , Object_ToId.ValueData                       AS ToName

           , Movement_OrderClient.Id                     AS MovementId_OrderClient
           , Movement_OrderClient.InvNumber              AS InvNumber_OrderClient
           , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
           , Object_Status_OrderClient.ObjectCode      AS StatusCode_OrderInternal
           , Object_Status_OrderClient.ValueData       AS StatusName_OrderInternal

           , tmpMI.OperDate                              AS OperDate_OrderInternal
           , tmpMI.InvNumber                             AS InvNumber_OrderInternal
           , zfCalc_InvNumber_isErased ('', tmpMI.InvNumber, tmpMI.OperDate, tmpMI.StatusId) AS InvNumberFull_OrderInternal
           , Object_Status_OrderInternal.ObjectCode      AS StatusCode_OrderInternal
           , Object_Status_OrderInternal.ValueData       AS StatusName_OrderInternal

           , tmpMI.isErased

       FROM tmpMI
       
            LEFT JOIN tmpProductionUnion AS ProductionUnion ON ProductionUnion.MovementItemId = tmpMI.ID

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = ProductionUnion.StatusId
            LEFT JOIN Object AS Object_Status_OrderInternal ON Object_Status_OrderInternal.Id = tmpMI.StatusId
            
            LEFT JOIN Object AS Object_From ON Object_From.Id = COALESCE(ProductionUnion.FromId, tmpMI.FromId)
            LEFT JOIN Object AS Object_ToId ON Object_ToId.Id = COALESCE(ProductionUnion.ToId, tmpMI.ToId)

            LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                 ON OL_Goods_GoodsGroup.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId

            LEFT JOIN ObjectLink AS OL_Goods_Measure
                                 ON OL_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND OL_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = OL_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()
            LEFT JOIN ObjectString AS ObjectString_EAN
                                   ON ObjectString_EAN.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_EAN.DescId   = zc_ObjectString_EAN()

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId    = tmpMI.GoodsId
                                AND tmpRemains.UnitId     = COALESCE(ProductionUnion.FromId, tmpMI.FromId)

            LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = tmpMI.MovementId_OrderClient
            LEFT JOIN Object AS Object_Status_OrderClient ON Object_Status_OrderClient.Id = Movement_OrderClient.StatusId

       ;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_MobileOrderInternal(566931, zfCalc_UserAdmin());