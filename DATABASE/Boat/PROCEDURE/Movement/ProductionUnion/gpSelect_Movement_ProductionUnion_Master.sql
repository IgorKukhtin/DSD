DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionUnion_Master (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionUnion_Master (
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, InvNumber_Full  TVarChar
             , OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , TotalCountChild TFloat
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Comment TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , UpdateName TVarChar, UpdateDate TDateTime
             , MovementId_parent Integer
             , InvNumber_parent TVarChar
             , DescName_parent TVarChar
             , FromName_parent TVarChar
             , ProductName_parent TVarChar 
             --
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar, GoodsName_all TVarChar, ItemName_goods TVarChar, Comment_goods TVarChar
             , Amount TFloat
             , ReceiptProdModelId Integer
             , ReceiptProdModelName TVarChar 
             , Comment_mi TVarChar
             , MovementId_OrderClient Integer
             , InvNumberFull_OrderClient TVarChar
             , FromId_OrderClient Integer , FromName_OrderClient TVarChar
             , ProductName_OrderClient TVarChar
             , CIN_OrderClient TVarChar
             , InsertName_mi TVarChar
             , InsertDate_mi TDateTime
             )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_ProductionUnion AS ( SELECT Movement_ProductionUnion.Id
                                             , Movement_ProductionUnion.ParentId
                                             , Movement_ProductionUnion.InvNumber
                                             , Movement_ProductionUnion.OperDate             AS OperDate
                                             , Movement_ProductionUnion.StatusId             AS StatusId
                                             , MovementLinkObject_To.ObjectId     AS ToId
                                             , MovementLinkObject_From.ObjectId   AS FromId
                                        FROM tmpStatus
                                             INNER JOIN Movement AS Movement_ProductionUnion
                                                                 ON Movement_ProductionUnion.StatusId = tmpStatus.StatusId
                                                                AND Movement_ProductionUnion.OperDate BETWEEN inStartDate AND inEndDate
                                                                AND Movement_ProductionUnion.DescId = zc_Movement_ProductionUnion()
           
                                             LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                          ON MovementLinkObject_To.MovementId = Movement_ProductionUnion.Id
                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
           
                                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                          ON MovementLinkObject_From.MovementId = Movement_ProductionUnion.Id
                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                       )

        , tmpMI_Master AS (SELECT MovementItem.Id
                                , MovementItem.MovementId
                                , MovementItem.ObjectId       AS GoodsId
                                , MovementItem.Amount         
                                , MovementItem.isErased
                                , MIString_Comment.ValueData  AS Comment
                                , Object_Insert.ValueData     AS InsertName
                                , MIDate_Insert.ValueData     AS InsertDate
                                , MIFloat_MovementId.ValueData :: Integer AS MovementId_OrderClient
                                , MILO_ReceiptProdModel.ObjectId AS ReceiptProdModelId
                           FROM Movement_ProductionUnion AS Movement
                               JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND (MovementItem.isErased  = inIsErased OR inIsErased = TRUE)

                               LEFT JOIN MovementItemLinkObject AS MILO_ReceiptProdModel
                                                                ON MILO_ReceiptProdModel.MovementItemId = MovementItem.Id
                                                               AND MILO_ReceiptProdModel.DescId = zc_MILinkObject_ReceiptProdModel()

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
                          )

        --результат
        SELECT Movement_ProductionUnion.Id
             , zfConvert_StringToNumber (Movement_ProductionUnion.InvNumber) AS InvNumber
             , ('№ ' || Movement_ProductionUnion.InvNumber || ' от ' || zfConvert_DateToString (Movement_ProductionUnion.OperDate) :: TVarChar ) :: TVarChar  AS InvNumber_Full
             , Movement_ProductionUnion.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
             , MovementFloat_TotalCountChild.ValueData    AS TotalCountChild

             , Object_From.Id                             AS FromId
             , Object_From.ObjectCode                     AS FromCode
             , Object_From.ValueData                      AS FromName
             , Object_To.Id                               AS ToId
             , Object_To.ObjectCode                       AS ToCode
             , Object_To.ValueData                        AS ToName
             , MovementString_Comment.ValueData :: TVarChar AS Comment

             , Object_Insert.ValueData              AS InsertName
             , MovementDate_Insert.ValueData        AS InsertDate
             , Object_Update.ValueData              AS UpdateName
             , MovementDate_Update.ValueData        AS UpdateDate

             , Movement_Parent.Id                         AS MovementId_parent
             , zfCalc_InvNumber_isErased ('', Movement_Parent.InvNumber, Movement_Parent.OperDate, Movement_Parent.StatusId) AS InvNumber_parent
             , MovementDesc_Parent.ItemName               AS DescName_parent
             , Object_From_parent.ValueData               AS FromName_parent
             , Object_Product_parent.ValueData            AS ProductName_parent

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
             , Object_ReceiptProdModel.Id           AS ReceiptProdModelId
             , Object_ReceiptProdModel.ValueData    AS ReceiptProdModelName
             , MovementItem.Comment ::TVarChar      AS Comment_mi

             , Movement_OrderClient.Id              AS MovementId_OrderClient
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
             , Object_From_OrderClient.Id           AS FromId_OrderClient 
             , Object_From_OrderClient.ValueData    AS FromName_OrderClient 
             , zfCalc_ValueData_isErased (Object_Product_OrderClient.ValueData, Object_Product_OrderClient.isErased)  AS ProductName_OrderClient
             , zfCalc_ValueData_isErased (ObjectString_CIN_OrderClient.ValueData,Object_Product_OrderClient.isErased) AS CIN_OrderClient

             , MovementItem.InsertName AS InsertName_mi
             , MovementItem.InsertDate AS InsertDate_mi
        FROM Movement_ProductionUnion

        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ProductionUnion.StatusId
        LEFT JOIN Object AS Object_From   ON Object_From.Id   = Movement_ProductionUnion.FromId
        LEFT JOIN Object AS Object_To     ON Object_To.Id     = Movement_ProductionUnion.ToId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId = Movement_ProductionUnion.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCountChild
                                ON MovementFloat_TotalCountChild.MovementId = Movement_ProductionUnion.Id
                               AND MovementFloat_TotalCountChild.DescId = zc_MovementFloat_TotalCountChild()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_ProductionUnion.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement_ProductionUnion.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement_ProductionUnion.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement_ProductionUnion.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()
        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement_ProductionUnion.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
        
        -- Parent - если указан
        LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement_ProductionUnion.ParentId
        LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From_parent
                                     ON MovementLinkObject_From_parent.MovementId = Movement_Parent.Id
                                    AND MovementLinkObject_From_parent.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From_parent ON Object_From_parent.Id = MovementLinkObject_From_parent.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Product_parent
                                     ON MovementLinkObject_Product_parent.MovementId = Movement_Parent.Id
                                    AND MovementLinkObject_Product_parent.DescId = zc_MovementLinkObject_Product()
        LEFT JOIN Object AS Object_Product_parent ON Object_Product_parent.Id = MovementLinkObject_Product_parent.ObjectId


        --- строки Master
        LEFT JOIN tmpMI_Master AS MovementItem ON MovementItem.MovementId = Movement_ProductionUnion.Id
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
        LEFT JOIN ObjectDesc AS ObjectDesc_Goods ON ObjectDesc_Goods.Id = Object_Goods.DescId

        LEFT JOIN Object AS Object_ReceiptProdModel ON Object_ReceiptProdModel.Id = MovementItem.ReceiptProdModelId

        LEFT JOIN ObjectString AS ObjectString_Article
                               ON ObjectString_Article.ObjectId = MovementItem.GoodsId
                              AND ObjectString_Article.DescId   = zc_ObjectString_Article()
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = MovementItem.GoodsId
                              AND ObjectString_Comment.DescId   = zc_ObjectString_Goods_Comment()

        LEFT JOIN Movement AS Movement_OrderClient ON Movement_OrderClient.Id = MovementItem.MovementId_OrderClient
        LEFT JOIN MovementLinkObject AS MovementLinkObject_From_OrderClient
                                     ON MovementLinkObject_From_OrderClient.MovementId = MovementItem.MovementId_OrderClient
                                    AND MovementLinkObject_From_OrderClient.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From_OrderClient ON Object_From_OrderClient.Id = MovementLinkObject_From_OrderClient.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Product_OrderClient
                                     ON MovementLinkObject_Product_OrderClient.MovementId = MovementItem.MovementId_OrderClient
                                    AND MovementLinkObject_Product_OrderClient.DescId = zc_MovementLinkObject_Product()
        LEFT JOIN Object AS Object_Product_OrderClient ON Object_Product_OrderClient.Id = MovementLinkObject_Product_OrderClient.ObjectId  

        LEFT JOIN ObjectString AS ObjectString_CIN_OrderClient
                               ON ObjectString_CIN_OrderClient.ObjectId = Object_Product_OrderClient.Id
                              AND ObjectString_CIN_OrderClient.DescId = zc_ObjectString_Product_CIN()
                                                           
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProductionUnion_Master (inStartDate:= '29.01.2022', inEndDate:= '01.02.2023', inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
