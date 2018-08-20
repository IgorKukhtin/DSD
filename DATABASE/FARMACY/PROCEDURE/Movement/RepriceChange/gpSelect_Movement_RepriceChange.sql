-- Function: gpSelect_Movement_RepriceChange()

DROP FUNCTION IF EXISTS gpSelect_Movement_RepriceChange (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_RepriceChange(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , ChangePercent TFloat
             , RetailId Integer, RetailName TVarChar
             , RetailForwardingId Integer, RetailForwardingName TVarChar
             , GUID TVarChar
             , InsertName TVarChar, InsertDate TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    RETURN QUERY
    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
      , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
      
      , MovementLinkObject_Retail.ObjectId                      AS RetailId
      , Object_Retail.ValueData                                 AS RetailName

      , Object_RetailForwarding.Id                              AS RetailForwardingId
      , Object_RetailForwarding.ValueData                       AS RetailForwardingName

      , MovementString_GUID.ValueData                           AS GUID

      , Object_Insert.ValueData                                 AS InsertName
      , MovementDate_Insert.ValueData                           AS InsertDate
      
    FROM Movement 
         LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                 ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                 ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                                
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
         LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_RetailForwarding
                                      ON MovementLinkObject_RetailForwarding.MovementId = Movement.Id
                                     AND MovementLinkObject_RetailForwarding.DescId = zc_MovementLinkObject_RetailForwarding()
         LEFT JOIN Object AS Object_RetailForwarding ON Object_RetailForwarding.Id = MovementLinkObject_RetailForwarding.ObjectId

         LEFT OUTER JOIN MovementString AS MovementString_GUID
                                        ON MovementString_GUID.MovementId = Movement.Id
                                       AND MovementString_GUID.DescId = zc_MovementString_Comment()

         LEFT JOIN MovementDate AS MovementDate_Insert
                                ON MovementDate_Insert.MovementId = Movement.Id
                               AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

         LEFT JOIN MovementLinkObject AS MLO_Insert
                                      ON MLO_Insert.MovementId = Movement.Id
                                     AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

    WHERE Movement.DescId = zc_Movement_RepriceChange()
      AND DATE_TRUNC ('DAY', Movement.OperDate) BETWEEN inStartDate AND inEndDate
    ORDER BY Movement.InvNumber;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/

--select * from gpSelect_Movement_RepriceChange(inStartDate := ('27.02.2016')::TDateTime , inEndDate := ('13.03.2016')::TDateTime ,  inSession := '3');