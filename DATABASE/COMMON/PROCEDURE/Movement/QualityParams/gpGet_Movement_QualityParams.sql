-- Function: gpGet_Movement_QualityParams()

DROP FUNCTION IF EXISTS gpGet_Movement_QualityParams (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_QualityParams (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_QualityParams(
    IN inMovementId        Integer  , -- ключ Документа
    IN inMovementId_Value  Integer  ,
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar,
               OperDateCertificate TDateTime, CertificateNumber TVarChar, CertificateSeries TVarChar, CertificateSeriesNumber TVarChar,
               ExpertPrior TVarChar, ExpertLast TVarChar, QualityNumber TVarChar, Comment TBlob
             , QualityId Integer, QualityName TVarChar
             , RetailId Integer, RetailName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_QualityParams());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId_Value, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_QualityParams_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , inOperDate                                       AS OperDateCertificate
             , CAST ('' as TVarChar)                            AS CertificateNumber
             , CAST ('' AS TVarChar) 				AS CertificateSeries
             , CAST ('' AS TVarChar) 				AS CertificateSeriesNumber
             , CAST ('' AS TVarChar) 				AS ExpertPrior
             , CAST ('' AS TVarChar) 				AS ExpertLast
             , CAST ('' AS TVarChar) 				AS QualityNumber
             , CAST ('' AS TBlob) 				AS Comment
             , CAST (0  AS Integer)                             AS QualityId
             , CAST ('' AS TVarChar) 				AS QualityName
             , CAST (0  AS Integer)                             AS RetailId
             , CAST ('' AS TVarChar) 				AS RetailName

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;

     ELSE

     RETURN QUERY
       SELECT
             inMovementId                                       AS Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_QualityParams_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
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
        -- , ( SELECT ResourseProtocol.ProtocolData FROM ResourseProtocol where ResourseProtocol.Id = 96857)AS Comment

           , Object_Quality.Id                                  AS QualityId
           , Object_Quality.ValueData   		        AS QualityName
           , Object_Retail.id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName

       FROM Movement
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

       WHERE Movement.Id =  inMovementId_Value
         AND Movement.DescId = zc_Movement_QualityParams();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_QualityParams (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.05.15                                        * add Retail...
 02.04.15                                        * all
 09.02.15                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_QualityParams (inMovementId:= 1, inMovementId_Value:= 1, inOperDate:= null, inSession:= '9818')
