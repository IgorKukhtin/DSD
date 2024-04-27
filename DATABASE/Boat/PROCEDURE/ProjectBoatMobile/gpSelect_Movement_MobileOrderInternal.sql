-- Function: gpSelect_Movement_MobileOrderInternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_MobileOrderInternal (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MobileOrderInternal(
    IN inOrderBy          Integer      , --
    IN inLimit            Integer      , -- 
    IN inFilter           TVarChar     , -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber Integer, InvNumberFull  TVarChar
             , BarCode TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , Comment TVarChar

             , Id Integer
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar, GoodsName_all TVarChar, ItemName_goods TVarChar, Comment_goods TVarChar
             , GoodsGroupId Integer, GoodsGroupName TVarChar
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
             )

AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH tmpMovement_OrderInternal AS (SELECT Movement_OrderInternal.Id
                                             , Movement_OrderInternal.InvNumber
                                             , Movement_OrderInternal.OperDate             AS OperDate
                                             , Movement_OrderInternal.StatusId             AS StatusId
                                        FROM Movement AS Movement_OrderInternal
                                        WHERE Movement_OrderInternal.StatusId <> zc_Enum_Status_Erased()
                                          AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal()
                                        )
        , tmpMI_Master AS (SELECT MovementItem.Id
                                , MovementItem.MovementId
                                , MovementItem.ObjectId       AS GoodsId
                                , MovementItem.Amount
                                , MovementItem.isErased
                                , MIString_Comment.ValueData  AS Comment
                                , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                , MILinkObject_Unit.ObjectId  AS UnitId
                           FROM tmpMovement_OrderInternal AS Movement
                               JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_Unit.DescId         = zc_MILinkObject_Unit()

                               LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                           ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                          AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()

                               LEFT JOIN MovementItemString AS MIString_Comment
                                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                                           AND MIString_Comment.DescId = zc_MIString_Comment()
                          )
        , tmpProductionUnion AS (SELECT DISTINCT MovementItem.Id 
                                 FROM tmpMI_Master AS MovementItem 

                                      INNER JOIN Movement AS OI ON OI.Id = MovementItem.MovementId 
                                                               AND OI.descid = zc_Movement_OrderInternal() 
                                                               AND OI.StatusId <> zc_Enum_Status_Erased()

                                      INNER JOIN MovementItemFloat AS MIFloat_MovementId
                                                                   ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                        
                                      INNER JOIN MovementItem AS MI_Master
                                                              ON MI_Master.ObjectId   = MovementItem.GoodsId
                                                             AND MI_Master.DescId = zc_MI_Master() 
                                                             AND MI_Master.isErased   = FALSE

                                      INNER JOIN MovementItemFloat AS MIFloat_PU
                                                                   ON MIFloat_PU.MovementItemId = MI_Master.Id
                                                                  AND MIFloat_PU.DescId         = zc_MIFloat_MovementId()
                                                                  AND MIFloat_PU.valuedata      = MIFloat_MovementId.valuedata

                                      INNER JOIN Movement AS PU ON PU.Id = MI_Master.MovementId 
                                                               AND PU.descid = zc_Movement_ProductionUnion() 
                                                               AND PU.StatusId <> zc_Enum_Status_Erased()                                                                      
                                       
                                 )

        -- Результат
        SELECT Movement_OrderInternal.Id
             , zfConvert_StringToNumber (Movement_OrderInternal.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_OrderInternal.InvNumber, Movement_OrderInternal.OperDate, Movement_OrderInternal.StatusId) AS InvNumberFull
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderInternal.Id) AS BarCode
             , Movement_OrderInternal.OperDate
             , Object_Status.ObjectCode                     AS StatusCode
             , Object_Status.ValueData                      AS StatusName

             , MovementFloat_TotalCount.ValueData           AS TotalCount
             , MovementString_Comment.ValueData :: TVarChar AS Comment

               -- строки
             , MovementItem.Id                      AS MovementItemId
             , MovementItem.GoodsId                 AS GoodsId
             , Object_Goods.ObjectCode              AS GoodsCode
             , ObjectString_Article.ValueData       AS Article
             , Object_Goods.ValueData               AS GoodsName
             , zfCalc_GoodsName_all (ObjectString_Article.ValueData, Object_Goods.ValueData) AS GoodsName_all
             , CASE WHEN Object_Goods.DescId = zc_Object_Product() THEN 'Лодка' WHEN Object_Goods.DescId = zc_Object_Goods() THEN 'Узел' ELSE ObjectDesc_Goods.ItemName END :: TVarChar AS ItemName_goods
             , ObjectString_Comment.ValueData       AS Comment_goods
             , Object_GoodsGroup.Id                AS GoodsGroupId
             , Object_GoodsGroup.ValueData         AS GoodsGroupName
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

        FROM tmpMovement_OrderInternal AS Movement_OrderInternal

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_OrderInternal.StatusId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_OrderInternal.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN MovementString AS MovementString_Comment
                                      ON MovementString_Comment.MovementId = Movement_OrderInternal.Id
                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()

             ---
             LEFT JOIN tmpMI_Master AS MovementItem ON MovementItem.MovementId = Movement_OrderInternal.Id
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
             LEFT JOIN ObjectDesc AS ObjectDesc_Goods ON ObjectDesc_Goods.Id = Object_Goods.DescId

             LEFT JOIN ObjectLink AS OL_Goods_GoodsGroup
                                  ON OL_Goods_GoodsGroup.ObjectId = MovementItem.GoodsId
                                 AND OL_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id  = OL_Goods_GoodsGroup.ChildObjectId
             
             LEFT JOIN tmpProductionUnion ON tmpProductionUnion.Id = MovementItem.Id

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
             
        WHERE COALESCE (tmpProductionUnion.Id, 0) = 0 AND COALESCE (MovementItem.Id, 0) <> 0

       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.04.24                                                       *
*/

-- тест
-- select * from gpSelect_Movement_MobileOrderInternal(inOrderBy := 0, inLimit := 100, inFilter := '', inSession := zfCalc_UserAdmin());