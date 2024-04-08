-- Function: gpSelect_Movement_QualityParams()

DROP FUNCTION IF EXISTS gpSelect_Movement_QualityParams (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_QualityParams (TDateTime, TDateTime, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_QualityParams(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean   ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar,
               OperDateCertificate TDateTime, CertificateNumber TVarChar, CertificateSeries TVarChar, CertificateSeriesNumber TVarChar,
               ExpertPrior TVarChar, ExpertLast TVarChar, QualityNumber TVarChar, Comment TBlob
             , QualityId Integer, QualityName TVarChar
             , RetailName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
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
           , Object_Quality.ValueData   		        AS QualityName
           , Object_Retail.ValueData                            AS RetailName

       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate  AND Movement.DescId = zc_Movement_QualityParams() AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement

            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId =  Movement.Id
                                  AND MD_OperDateCertificate.DescId = NULL -- zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId =  Movement.Id
                                    AND MS_CertificateNumber.DescId = NULL -- zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId =  Movement.Id
                                    AND MS_CertificateSeries.DescId = NULL -- zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId =  Movement.Id
                                    AND MS_CertificateSeriesNumber.DescId = NULL -- zc_MovementString_CertificateSeriesNumber()
            LEFT JOIN MovementString AS MS_ExpertPrior
                                     ON MS_ExpertPrior.MovementId =  Movement.Id
                                    AND MS_ExpertPrior.DescId = zc_MovementString_ExpertPrior()
            LEFT JOIN MovementString AS MS_ExpertLast
                                     ON MS_ExpertLast.MovementId =  Movement.Id
                                    AND MS_ExpertLast.DescId = zc_MovementString_ExpertLast()
            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId =  Movement.Id
                                    AND MS_QualityNumber.DescId = NULL -- zc_MovementString_QualityNumber()
            LEFT JOIN MovementBlob AS MB_Comment
                                   ON MB_Comment.MovementId =  Movement.Id
                                  AND MB_Comment.DescId = zc_MovementBlob_Comment()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Quality
                                         ON MovementLinkObject_Quality.MovementId = Movement.Id
                                        AND MovementLinkObject_Quality.DescId = zc_MovementLinkObject_Quality()
            LEFT JOIN Object AS Object_Quality ON Object_Quality.Id = MovementLinkObject_Quality.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                         ON MovementLinkObject_Retail.MovementId = Movement.Id
                                        AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_QualityParams (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.10.16         * add inJuridicalBasisId
 22.05.15                                        * add RetailName
 09.02.15                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_QualityParams (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inJuridicalBasisId:= 0, inSession:= '2')