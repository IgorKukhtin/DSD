-- Function: gpGet_Movement_QualityNumber()

DROP FUNCTION IF EXISTS gpGet_Movement_QualityNumber (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_QualityNumber(
    IN inMovementId       Integer  , -- ключ Документа
    IN inOperDate         TDateTime , --
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , QualityNumber TVarChar
             , CertificateNumber TVarChar
             , OperDateCertificate TDateTime
             , CertificateSeries TVarChar
             , CertificateSeriesNumber TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_QualityNumber());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     -- Результат
     RETURN QUERY 
     WITH tmpQualityDoc_old AS (SELECT Movement.Id                           AS MovementId
                                     , MS_QualityNumber.ValueData            AS QualityNumber
                                     , MS_CertificateNumber.ValueData        AS CertificateNumber
                                     , MD_OperDateCertificate.ValueData      AS OperDateCertificate
                                     , MS_CertificateSeries.ValueData        AS CertificateSeries
                                     , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
                                FROM Movement
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
                                WHERE Movement.DescId = zc_Movement_QualityNumber()
                                  AND Movement.OperDate >= CURRENT_DATE - INTERVAL '31 DAY'
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                  AND MS_QualityNumber.ValueData <> ''
                                ORDER BY Movement.OperDate DESC
                                LIMIT 1
                               )
       SELECT  0 AS Id
             , CAST (NEXTVAL ('Movement_QualityNumber_seq') AS TVarChar) AS InvNumber
             , tmp.OperDate                 AS OperDate

             , tmpQualityDoc_old.QualityNumber
             , tmpQualityDoc_old.CertificateNumber
             , COALESCE (tmpQualityDoc_old.OperDateCertificate, tmp.OperDate) :: TDateTime AS OperDateCertificate
             , tmpQualityDoc_old.CertificateSeries
             , tmpQualityDoc_old.CertificateSeriesNumber
       FROM (SELECT inOperDate AS OperDate) AS tmp
            LEFT JOIN tmpQualityDoc_old ON 1 = 1
      ;
     ELSE
     -- Результат
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
          
           , MS_QualityNumber.ValueData            AS QualityNumber
           , MS_CertificateNumber.ValueData        AS CertificateNumber
           , MD_OperDateCertificate.ValueData      AS OperDateCertificate
           , MS_CertificateSeries.ValueData        AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
           
        FROM Movement

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

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_QualityNumber();
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.03.16         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_QualityNumber (inMovementId:= 0, := 2, inSession:= zfCalc_UserAdmin())
