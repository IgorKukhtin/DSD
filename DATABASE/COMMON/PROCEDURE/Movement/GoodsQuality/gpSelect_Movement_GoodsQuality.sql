-- Function: gpSelect_Movement_GoodsQuality()

DROP FUNCTION IF EXISTS gpSelect_Movement_GoodsQuality (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GoodsQuality(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar,
               OperDateCertificate TDateTime, CertificateNumber TVarChar, CertificateSeries TVarChar, CertificateSeriesNumber TVarChar,
               ExpertPrior TVarChar, ExpertLast TVarChar, QualityNumber TVarChar, Comment TBlob, QualityId Integer, QualityName TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_GoodsQuality());
--     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
        , tmpRoleAccessKey AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND NOT EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                         UNION SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE EXISTS (SELECT UserId FROM tmpUserAdmin) GROUP BY AccessKeyId
                              )

       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MD_OperDateCertificate.ValueData                   AS OperDateCertificate
           , MS_CertificateNumber.ValueData                     AS CertificateNumber
           , MS_CertificateSeries.ValueData                     AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData               AS CertificateSeriesNumber
           , MS_ExpertPrior.ValueData                           AS ExpertPrior
           , MS_ExpertLast.ValueData                            AS ExpertLast
           , MS_QualityNumber.ValueData                         AS QualityNumber
           , MB_Comment.ValueData                               AS Comment
           , Object_Quality.Id                                  AS QualityId
           , Object_Quality.ValueData   		                AS QualityName


       FROM (SELECT Movement.id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_GoodsQuality() AND Movement.StatusId = tmpStatus.StatusId
--                  JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId =  Movement.Id
                                  AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId =  Movement.Id
                                    AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId =  Movement.Id
                                    AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId =  Movement.Id
                                    AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
            LEFT JOIN MovementString AS MS_ExpertPrior
                                     ON MS_ExpertPrior.MovementId =  Movement.Id
                                    AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
            LEFT JOIN MovementString AS MS_ExpertLast
                                     ON MS_ExpertLast.MovementId =  Movement.Id
                                    AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId =  Movement.Id
                                    AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
            LEFT JOIN MovementBlob AS MB_Comment
                                   ON MB_Comment.MovementId =  Movement.Id
                                  AND MB_Comment.DescId = zc_MovementBlob_Comment()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Quality
                                         ON MovementLinkObject_Quality.MovementId = Movement.Id
                                        AND MovementLinkObject_Quality.DescId = zc_MovementLinkObject_Quality()
            LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = MovementLinkObject_Quality.ObjectId

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_GoodsQuality (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 09.02.15                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_GoodsQuality (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')