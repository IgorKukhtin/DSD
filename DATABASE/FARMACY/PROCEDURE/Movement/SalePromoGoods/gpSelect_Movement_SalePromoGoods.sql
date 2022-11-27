-- Function: gpSelect_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_SalePromoGoods (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_SalePromoGoods(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber     TVarChar
             , OperDate      TDateTime
             , StatusId      Integer
             , StatusCode    Integer
             , StatusName    TVarChar
             , RetailName    TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , InsertId      Integer
             , InsertName    TVarChar
             , InsertDate    TDateTime
             , UpdateId      Integer
             , UpdateName    TVarChar
             , UpdateDate    TDateTime
             , Comment       TVarChar
             , isAmountCheck Boolean
             , AmountCheck   TFloat
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
          , Object_Retail.ValueData                                        AS RetailName
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo
          , Object_Insert.Id                                               AS InsertId
          , Object_Insert.ValueData                                        AS InsertName
          , MovementDate_Insert.ValueData                                  AS InsertDate
          , Object_Update.Id                                               AS UpdateId
          , Object_Update.ValueData                                        AS UpdateName
          , MovementDate_Update.ValueData                                  AS UpdateDate
          , MovementString_Comment.ValueData                               AS Comment
          , COALESCE (MovementBoolean_AmountCheck.ValueData, False)        AS isAmountCheck
          , MovementFloat_AmountCheck.ValueData                            AS AmountCheck
     FROM Movement
        INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_AmountCheck
                                  ON MovementBoolean_AmountCheck.MovementId = Movement.Id
                                 AND MovementBoolean_AmountCheck.DescId = zc_MovementBoolean_AmountCheck()
        LEFT JOIN MovementFloat AS MovementFloat_AmountCheck
                                ON MovementFloat_AmountCheck.MovementId = Movement.Id
                               AND MovementFloat_AmountCheck.DescId = zc_MovementFloat_AmountCheck()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                     ON MovementLinkObject_Update.MovementId = Movement.Id
                                    AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

     WHERE Movement.DescId = zc_Movement_SalePromoGoods()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
     ORDER BY InvNumber;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/
-- select * from gpSelect_Movement_SalePromoGoods(inStartDate := ('13.03.2016')::TDateTime ,inEndDate := ('13.03.2020')::TDateTime , inIsErased:= true, inSession := '3');

