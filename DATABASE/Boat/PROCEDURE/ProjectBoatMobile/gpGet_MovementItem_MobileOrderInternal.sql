-- Function: gpGet_MovementItem_MobileOrderInternal()

DROP FUNCTION IF EXISTS gpGet_MovementItem_MobileOrderInternal(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_MobileOrderInternal(
    IN inMovementItemId      Integer  ,  -- Ключ объекта <Master OrderInternal>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
               --
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar, GoodsName_all TVarChar, ItemName_goods TVarChar, Comment_goods TVarChar
             , Amount TFloat
             , UnitId Integer
             , UnitName TVarChar
             , Comment_mi TVarChar
             , MovementId_OrderClient Integer
             , InvNumberFull_OrderClient TVarChar
             , InvNumber_OrderClient TVarChar
             , FromId Integer , FromName TVarChar
             , ProductName TVarChar
             , CIN TVarChar
             , ModelId Integer, ModelName TVarChar, ModelName_full TVarChar
             , InsertName_mi TVarChar
             , InsertDate_mi TDateTime             
             , MovementPUId Integer
             , MovementItemPUId Integer
             
             , InvNumberFull_ProductionUnion TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
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
        
    -- Результат
    RETURN QUERY
     WITH tmpMI_Master AS (SELECT MovementItem.Id
                                , MovementItem.MovementId
                                , MovementItem.ObjectId       AS GoodsId
                                , MovementItem.Amount
                                , MovementItem.isErased
                                , MIString_Comment.ValueData  AS Comment
                                , Object_Insert.ValueData     AS InsertName
                                , MIDate_Insert.ValueData     AS InsertDate
                                , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                , MILinkObject_Unit.ObjectId  AS UnitId
                           FROM MovementItem

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()

                               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

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
                               
                           WHERE MovementItem.Id         = inMovementItemId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          ),
          tmpProductionUnion AS (SELECT MovementItem.Id   AS Id
                                      , PU.Id             AS MovementId
                                      , MI_Master.Id      AS MovementItemId
    
                                      , zfFormat_BarCode (zc_BarCodePref_Movement(), PU.Id) AS BarCode_ProductionUnion
                                      , zfCalc_InvNumber_isErased ('', PU.InvNumber, PU.OperDate, PU.StatusId) AS InvNumberFull_ProductionUnion 
                                      , PU.InvNumber
                                      , PU.OperDate                         AS OperDate

                                      , Object_From.Id                            AS FromId
                                      , Object_From.ValueData                     AS FromName
                                      , Object_To.Id                              AS ToId      
                                      , Object_To.ValueData                       AS ToName
                                      , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
                                      , Object_Insert.ValueData                   AS InsertName
                                      , MovementDate_Insert.ValueData             AS InsertDate

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
                                  
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = PU.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                      LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = PU.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                                      LEFT JOIN MovementString AS MovementString_Comment
                                                               ON MovementString_Comment.MovementId = PU.Id
                                                              AND MovementString_Comment.DescId = zc_MovementString_Comment()

                                      LEFT JOIN MovementDate AS MovementDate_Insert
                                                             ON MovementDate_Insert.MovementId = PU.Id
                                                            AND MovementDate_Insert.DescId     = zc_MovementDate_Insert()
                                      LEFT JOIN MovementLinkObject AS MLO_Insert
                                                                   ON MLO_Insert.MovementId = PU.Id
                                                                  AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
                                      LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                                 WHERE MovementItem.Id         = inMovementItemId
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE)

        -- Результат
        SELECT Movement_OrderInternal.Id
             , zfConvert_StringToNumber (Movement_OrderInternal.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_OrderInternal.InvNumber, Movement_OrderInternal.OperDate, Movement_OrderInternal.StatusId) AS InvNumber_Full
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderInternal.Id) AS BarCode
             , Movement_OrderInternal.OperDate
             , Object_Status.ObjectCode                     AS StatusCode
             , Object_Status.ValueData                      AS StatusName

             , MovementFloat_TotalCount.ValueData           AS TotalCount
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

               -- строки
             , MovementItem.Id                      AS MovementItemId
             , MovementItem.GoodsId                 AS GoodsId
             , Object_Goods.ObjectCode              AS GoodsCode
             , ObjectString_Article.ValueData       AS Article
             , Object_Goods.ValueData               AS GoodsName
             , zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_Goods.ValueData) AS GoodsName_all
             , CASE WHEN Object_Goods.DescId = zc_Object_Product() THEN 'Лодка' WHEN Object_Goods.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc_Goods.ItemName END :: TVarChar AS ItemName_goods
             , ObjectString_Comment.ValueData       AS Comment_goods
             , MovementItem.Amount ::TFloat         AS Amount
             , Object_Unit.Id                       AS UnitId
             , Object_Unit.ValueData                AS UnitName
             , MovementItem.Comment ::TVarChar      AS Comment_mi

             , Movement_OrderClient.Id              AS MovementId_OrderClient
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient 
             , Movement_OrderClient.InvNumber  AS InvNumber_OrderClient
             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased)  AS ProductName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN
             , Object_Model.Id                      AS ModelId
             , Object_Model.ValueData               AS ModelName
             , (Object_Brand.ValueData || '-' || Object_Model.ValueData) ::TVarChar AS ModelName_full

             , MovementItem.InsertName AS InsertName_mi
             , MovementItem.InsertDate AS InsertDate_mi
             
             , tmpProductionUnion.MovementId        AS MovementPUId
             , tmpProductionUnion.MovementItemId    AS MovementItemPUId
             
             , tmpProductionUnion.InvNumberFull_ProductionUnion

        FROM tmpMI_Master AS MovementItem
        
             INNER JOIN Movement AS Movement_OrderInternal ON Movement_OrderInternal.Id = MovementItem.MovementId

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderInternal.StatusId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_OrderInternal.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             LEFT JOIN MovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_OrderInternal.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_OrderInternal.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementDate AS MovementDate_Update
                                    ON MovementDate_Update.MovementId = Movement_OrderInternal.Id
                                   AND MovementDate_Update.DescId = zc_MovementDate_Update()
             LEFT JOIN MovementLinkObject AS MLO_Update
                                          ON MLO_Update.MovementId = Movement_OrderInternal.Id
                                         AND MLO_Update.DescId = zc_MovementLinkObject_Update()
             LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId

             ---
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
             LEFT JOIN ObjectDesc AS ObjectDesc_Goods ON ObjectDesc_Goods.Id = Object_Goods.DescId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.UnitId

             LEFT JOIN ObjectString AS ObjectString_Article
                                    ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                                   AND ObjectString_Article.DescId   = zc_ObjectString_Article()
             LEFT JOIN ObjectString AS ObjectString_Comment
                                    ON ObjectString_Comment.ObjectId = MovementItem.GoodsId
                                   AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()

             LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_OrderClient
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = MovementItem.MovementId_OrderClient
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Product
                                          ON MovementLinkObject_Product.MovementId = MovementItem.MovementId_OrderClient
                                         AND MovementLinkObject_Product.DescId = zc_MovementLinkObject_Product()
             LEFT JOIN Object AS Object_Product ON Object_Product.Id = MovementLinkObject_Product.ObjectId

             LEFT JOIN ObjectString AS ObjectString_CIN
                                    ON ObjectString_CIN.ObjectId = Object_Product.Id
                                   AND ObjectString_CIN.DescId = zc_ObjectString_Product_CIN() 

             LEFT JOIN ObjectLink AS ObjectLink_Model
                                  ON ObjectLink_Model.ObjectId = Object_Product.Id
                                 AND ObjectLink_Model.DescId = zc_ObjectLink_Product_Model()
             LEFT JOIN Object AS Object_Model ON Object_Model.Id = ObjectLink_Model.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Brand
                                  ON ObjectLink_Brand.ObjectId = Object_Product.Id
                                 AND ObjectLink_Brand.DescId = zc_ObjectLink_Product_Brand()
             LEFT JOIN Object AS Object_Brand ON Object_Brand.Id = ObjectLink_Brand.ChildObjectId
             
             LEFT JOIN tmpProductionUnion ON tmpProductionUnion.Id = MovementItem.Id

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
-- SELECT * FROM gpGet_MovementItem_MobileOrderInternal(559434, zfCalc_UserAdmin());