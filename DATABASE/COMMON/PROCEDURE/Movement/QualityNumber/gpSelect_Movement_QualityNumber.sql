-- Function: gpSelect_Movement_QualityNumber()

DROP FUNCTION IF EXISTS gpSelect_Movement_QualityNumber (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_QualityNumber (TDateTime, TDateTime, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpselect_movement_qualitynumber(
    IN inStartdate          tdatetime,
    IN inEnddate            tdatetime,
    IN inJuridicalBasisId   Integer  , -- Главное юр.лицо
    IN inisErased           boolean  ,
    IN inSession            tvarchar
)
 RETURNS TABLE(Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar

             , OperDateCertificate TDateTime
             , CertificateNumber TVarChar
             , CertificateSeries TVarChar
             , CertificateSeriesNumber TVarChar
             , QualityNumber TVarChar
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_QualityNumber());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION
                        SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                       )
        
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MD_OperDateCertificate.ValueData      AS OperDateCertificate
           , MS_CertificateNumber.ValueData        AS CertificateNumber
           , MS_CertificateSeries.ValueData        AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
           , MS_QualityNumber.ValueData            AS QualityNumber
           
       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_QualityNumber()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
         

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId = Movement.Id
                                  AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId = Movement.Id
                                    AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId = Movement.Id
                                    AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId = Movement.Id
                                    AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId = Movement.Id   
                                    AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()

      ;
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_QualityNumber (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_QualityNumber (inStartDate:= '01.05.2015', inEndDate:= '31.05.2016', inIsErased:=false , inJuridicalBasisId:= 0, inSession:= zfCalc_UserAdmin())