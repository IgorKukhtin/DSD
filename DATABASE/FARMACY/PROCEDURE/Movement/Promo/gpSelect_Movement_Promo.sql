-- Function: gpSelect_Movement_Promo()

DROP FUNCTION IF EXISTS gpSelect_Movement_Promo (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Promo(
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
             , StartPromo TDateTime
             , EndPromo TDateTime
             , ChangePercent TFloat
             , Amount TFloat
             , TotalCount TFloat
             , TotalSumm TFloat
             , MakerId Integer
             , MakerName TVarChar
             , PersonalId Integer
             , PersonalName TVarChar
             , Comment TVarChar
             , Prescribe TVarChar
             , isSupplement Boolean
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
          , MovementDate_StartPromo.ValueData                              AS StartPromo
          , MovementDate_EndPromo.ValueData                                AS EndPromo 
          , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat      AS ChangePercent
          , COALESCE(MovementFloat_Amount.ValueData,0)::TFloat             AS Amount

          , COALESCE(MovementFloat_TotalCount.ValueData,0)::TFloat         AS TotalCount
          , COALESCE(MovementFloat_TotalSumm.ValueData,0)::TFloat          AS TotalSumm
          , MovementLinkObject_Maker.ObjectId                              AS MakerId
          , Object_Maker.ValueData                                         AS MakerName
          , MovementLinkObject_Personal.ObjectId                           AS PersonalId  
          , Object_Personal.ValueData                                      AS PersonalName 
          , MovementString_Comment.ValueData                               AS Comment
          , CASE WHEN COALESCE(MovementBoolean_Prescribe.ValueData, FALSE)
            THEN 'Ожидает прописи'
            ELSE 'Прописано' END::TVarChar                                 AS Prescribe
          , COALESCE(MovementBoolean_Supplement.ValueData, FALSE)          AS isSupplement
     FROM Movement 
        INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId =  Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                   
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Maker
                                     ON MovementLinkObject_Maker.MovementId = Movement.Id
                                    AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
        LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = MovementLinkObject_Maker.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                     ON MovementLinkObject_Personal.MovementId = Movement.Id
                                    AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
        LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_Prescribe
                                  ON MovementBoolean_Prescribe.MovementId =  Movement.Id
                                 AND MovementBoolean_Prescribe.DescId = zc_MovementBoolean_Promo_Prescribe()

        LEFT JOIN MovementBoolean AS MovementBoolean_Supplement
                                  ON MovementBoolean_Supplement.MovementId =  Movement.Id
                                 AND MovementBoolean_Supplement.DescId = zc_MovementBoolean_Supplement()

     WHERE Movement.DescId = zc_Movement_Promo()
       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
     ORDER BY InvNumber;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.   Шаблий О.В.
 17.10.16                                                                                      *
 24.04.16         *
*/
--select * from gpSelect_Movement_Promo(inStartDate := ('13.03.2016')::TDateTime ,inEndDate := ('13.03.2016')::TDateTime , inIsErased:= true, inSession := '3');

