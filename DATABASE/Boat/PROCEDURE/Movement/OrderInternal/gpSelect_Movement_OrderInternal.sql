-- Function: gpSelect_Movement_OrderInternalChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternal (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
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
             , GoodsId Integer, GoodsCode Integer, Article TVarChar, GoodsName TVarChar, Comment_goods TVarChar
             , Amount TFloat
             , UnitId Integer
             , UnitName TVarChar 
             , Comment_mi TVarChar
             , MovementId_OrderClient Integer
             , InvNumberFull_OrderClient TVarChar
             , FromName TVarChar
             , ProductName TVarChar
             , CIN TVarChar
             , InsertName_mi TVarChar
             , InsertDate_mi TDateTime
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

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , Movement_OrderInternal AS ( SELECT Movement_OrderInternal.Id
                                           , Movement_OrderInternal.InvNumber
                                           , Movement_OrderInternal.OperDate             AS OperDate
                                           , Movement_OrderInternal.StatusId             AS StatusId
                                      FROM tmpStatus
                                           INNER JOIN Movement AS Movement_OrderInternal
                                                               ON Movement_OrderInternal.StatusId = tmpStatus.StatusId
                                                              AND Movement_OrderInternal.OperDate BETWEEN inStartDate AND inEndDate
                                                              AND Movement_OrderInternal.DescId = zc_Movement_OrderInternal()
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
                                , MILinkObject_Unit.ObjectId  AS UnitId
                           FROM Movement_OrderInternal AS Movement
                               JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND (MovementItem.isErased  = inIsErased OR inIsErased = TRUE)

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
                          )
        -- Результат
        SELECT Movement_OrderInternal.Id
             , zfConvert_StringToNumber (Movement_OrderInternal.InvNumber) AS InvNumber
             , zfCalc_InvNumber_isErased ('', Movement_OrderInternal.InvNumber, Movement_OrderInternal.OperDate, Movement_OrderInternal.StatusId) AS InvNumber_Full
             , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_OrderInternal.Id) AS BarCode
             , Movement_OrderInternal.OperDate
             , Object_Status.ObjectCode                   AS StatusCode
             , Object_Status.ValueData                    AS StatusName

             , MovementFloat_TotalCount.ValueData         AS TotalCount
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
             , ObjectString_Comment.ValueData       AS Comment_goods
             , MovementItem.Amount ::TFloat         AS Amount
             , Object_Unit.Id                       AS UnitId
             , Object_Unit.ValueData                AS UnitName
             , MovementItem.Comment ::TVarChar      AS Comment_mi

             , Movement_OrderClient.Id                                   AS MovementId_OrderClient
             , zfCalc_InvNumber_isErased ('', Movement_OrderClient.InvNumber, Movement_OrderClient.OperDate, Movement_OrderClient.StatusId) AS InvNumberFull_OrderClient
             , Object_From.ValueData                      AS FromName 
             , zfCalc_ValueData_isErased (Object_Product.ValueData, Object_Product.isErased) AS ProductName
             , zfCalc_ValueData_isErased (ObjectString_CIN.ValueData,Object_Product.isErased) AS CIN

             , MovementItem.InsertName AS InsertName_mi
             , MovementItem.InsertDate AS InsertDate_mi

        FROM Movement_OrderInternal

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
             LEFT JOIN tmpMI_Master AS MovementItem ON MovementItem.MovementId = Movement_OrderInternal.Id
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.GoodsId
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
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.12.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal (inStartDate:= '01.01.2021', inEndDate:= '31.12.2021', inClientId:=0 , inIsErased := FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_Movement_OrderInternal(inStartDate := ('24.12.2022')::TDateTime , inEndDate := ('24.12.2022')::TDateTime , inIsErased := 'False' ,  inSession := '5');
