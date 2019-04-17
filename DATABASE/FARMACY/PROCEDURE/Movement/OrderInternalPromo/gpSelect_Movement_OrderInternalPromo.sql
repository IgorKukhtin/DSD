-- Function: gpSelect_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPromo (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPromo(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusId  Integer
             , StatusCode Integer
             , StatusName TVarChar
             , StartSale TDateTime
             , Amount TFloat
             , RetailId Integer
             , RetailName TVarChar
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Movement.StatusId
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartSale.ValueData                               AS StartSale
          , COALESCE(MovementFloat_Amount.ValueData,0)::TFloat             AS Amount
          , MovementLinkObject_Retail.ObjectId                             AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementString_Comment.ValueData                               AS Comment
     FROM Movement 
        INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
                                   
        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

     WHERE Movement.DescId = zc_Movement_OrderInternalPromo()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
     ORDER BY InvNumber;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/
--select * from gpSelect_Movement_OrderInternalPromo(inStartDate := ('13.03.2019')::TDateTime ,inEndDate := ('13.03.2019')::TDateTime , inIsErased:= False, inSession := '3');

