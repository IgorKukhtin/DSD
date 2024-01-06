-- Function: gpGet_Movement_QualityDoc()

DROP FUNCTION IF EXISTS gpGet_Movement_QualityDoc (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_QualityDoc(
    IN inMovementId       Integer  , -- ключ Документа
    IN inMovementId_Sale  Integer  , -- ключ Документа
    IN inSession          TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , OperDateIn TDateTime, OperDateOut TDateTime
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , CarId Integer, CarName TVarChar, CarModelId Integer, CarModelName TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , QualityNumber TVarChar, CertificateNumber TVarChar, OperDateCertificate TDateTime, CertificateSeries TVarChar, CertificateSeriesNumber TVarChar
             , isNew Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_QualityDoc());
     vbUserId:= lpGetUserBySession (inSession);

     IF inMovementId > 0 THEN inMovementId:= 0; END IF;
     
     
     -- пытаемся найти по продаже
     IF inMovementId_Sale <> 0 AND COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId_Sale AND MLM.DescId = zc_MovementLinkMovement_Child() LIMIT 1);
     END IF;

     -- Проверка
     IF inMovementId > 0 AND NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_QualityDoc())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не найден.Обратитесь к разработчику.';
     END IF;

     IF inMovementId > 0
     THEN
     -- Результат
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , MovementDate_OperDateIn.ValueData AS OperDateIn
           , MovementDate_OperDateOut.ValueData AS OperDateOut

           , Movement_Sale.Id        AS MovementId_Sale
           , Movement_Sale.InvNumber AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale

           , Object_Car.Id                    AS CarId
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.Id               AS CarModelId
           , Object_CarModel.ValueData        AS CarModelName

           , Object_From.Id           AS FromId
           , Object_From.ValueData    AS FromName
           , Object_To.Id             AS ToId
           , Object_To.ValueData      AS ToName

           , MS_QualityNumber.ValueData            AS QualityNumber
           , MS_CertificateNumber.ValueData        AS CertificateNumber
           , MD_OperDateCertificate.ValueData      AS OperDateCertificate
           , MS_CertificateSeries.ValueData        AS CertificateSeries
           , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
           
           , FALSE AS isNew
        FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateIn
                                   ON MovementDate_OperDateIn.MovementId =  Movement.Id
                                  AND MovementDate_OperDateIn.DescId = zc_MovementDate_OperDateIn()
            LEFT JOIN MovementDate AS MovementDate_OperDateOut
                                   ON MovementDate_OperDateOut.MovementId =  Movement.Id
                                  AND MovementDate_OperDateOut.DescId = zc_MovementDate_OperDateOut()

            LEFT JOIN Movement AS Movement_QualityNumber
                               ON Movement_QualityNumber.OperDate = DATE_TRUNC ('DAY', MovementDate_OperDateIn.ValueData)
                              AND Movement_QualityNumber.DescId = zc_Movement_QualityNumber()
                              AND Movement_QualityNumber.StatusId = zc_Enum_Status_Complete()

            LEFT JOIN MovementString AS MS_QualityNumber
                                     ON MS_QualityNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                    AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
            LEFT JOIN MovementDate AS MD_OperDateCertificate
                                   ON MD_OperDateCertificate.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                  AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
            LEFT JOIN MovementString AS MS_CertificateNumber
                                     ON MS_CertificateNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                    AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
            LEFT JOIN MovementString AS MS_CertificateSeries
                                     ON MS_CertificateSeries.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                    AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
            LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                     ON MS_CertificateSeriesNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                    AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                           ON MovementLinkMovement_Child.MovementId = Movement.Id 
                                          AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()
            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_Child.MovementChildId
                                               -- AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_QualityDoc()
      ;
     ELSE
     -- Результат
     RETURN QUERY 
     WITH tmpOperDate AS (SELECT COALESCE (MovementDate.ValueData, Movement.OperDate) AS OperDate FROM Movement LEFT JOIN MovementDate ON MovementDate.MovementId = Movement.Id AND MovementDate.DescId = zc_MovementDate_OperDatePartner() WHERE Movement.Id = inMovementId_Sale)
        , tmpQualityDoc AS (SELECT Movement.Id                           AS MovementId
                                 , MS_QualityNumber.ValueData            AS QualityNumber
                                 , MS_CertificateNumber.ValueData        AS CertificateNumber
                                 , MD_OperDateCertificate.ValueData      AS OperDateCertificate
                                 , MS_CertificateSeries.ValueData        AS CertificateSeries
                                 , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
                            FROM tmpOperDate
                                 LEFT JOIN Movement AS Movement_QualityNumber
                                                    ON Movement_QualityNumber.OperDate = tmpOperDate.OperDate
                                                   AND Movement_QualityNumber.DescId = zc_Movement_QualityNumber()
                                                   AND Movement_QualityNumber.StatusId = zc_Enum_Status_Complete()
                                 LEFT JOIN Movement ON Movement.DescId = zc_Movement_QualityDoc()
                                                    AND Movement.OperDate = tmpOperDate.OperDate
                                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                                    AND Movement_QualityNumber.Id IS NULL

                                 LEFT JOIN MovementString AS MS_QualityNumber
                                                          ON MS_QualityNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                                         AND MS_QualityNumber.DescId = zc_MovementString_QualityNumber()
                                 LEFT JOIN MovementDate AS MD_OperDateCertificate
                                                        ON MD_OperDateCertificate.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                                       AND MD_OperDateCertificate.DescId = zc_MovementDate_OperDateCertificate()
                                 LEFT JOIN MovementString AS MS_CertificateNumber
                                                          ON MS_CertificateNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                                         AND MS_CertificateNumber.DescId = zc_MovementString_CertificateNumber()
                                 LEFT JOIN MovementString AS MS_CertificateSeries
                                                          ON MS_CertificateSeries.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                                         AND MS_CertificateSeries.DescId = zc_MovementString_CertificateSeries()
                                 LEFT JOIN MovementString AS MS_CertificateSeriesNumber
                                                          ON MS_CertificateSeriesNumber.MovementId = COALESCE (Movement_QualityNumber.Id, Movement.Id)
                                                         AND MS_CertificateSeriesNumber.DescId = zc_MovementString_CertificateSeriesNumber()
                           WHERE MS_QualityNumber.ValueData <> ''
                           ORDER BY Movement.Id DESC
                           LIMIT 1
                           )
        , tmpQualityDoc_old AS (SELECT Movement.Id                           AS MovementId
                                     , MS_QualityNumber.ValueData            AS QualityNumber
                                     , MS_CertificateNumber.ValueData        AS CertificateNumber
                                     , MD_OperDateCertificate.ValueData      AS OperDateCertificate
                                     , MS_CertificateSeries.ValueData        AS CertificateSeries
                                     , MS_CertificateSeriesNumber.ValueData  AS CertificateSeriesNumber
                                FROM tmpOperDate
                                     INNER JOIN Movement ON Movement.DescId = zc_Movement_QualityDoc()
                                                        AND Movement.OperDate BETWEEN (tmpOperDate.OperDate - INTERVAL '8 DAY') AND (tmpOperDate.OperDate - INTERVAL '1 DAY')
                                                        AND Movement.StatusId = zc_Enum_Status_Complete()
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
                                WHERE MS_QualityNumber.ValueData <> ''
                                ORDER BY Movement.Id DESC
                                LIMIT 1
                               )
       SELECT
             0                 AS Id
           , '' :: TVarChar    AS InvNumber
           , NULL :: TDateTime AS OperDate
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate.ValueData, Movement.OperDate) ELSE Movement.OperDate END :: TDateTime AS OperDateIn
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate.ValueData, Movement.OperDate) ELSE Movement.OperDate END :: TDateTime AS OperDateOut

           , Movement.Id        AS MovementId_Sale
           , Movement.InvNumber AS InvNumber_Sale
             -- параметр для Склад ГП ф.Киев + Львов - !!!временно!!!
           , CASE WHEN MovementLinkObject_From.ObjectId IN (8411, 3080691) THEN COALESCE (MovementDate.ValueData, Movement.OperDate) ELSE Movement.OperDate END :: TDateTime AS OperDate_Sale

           , Object_Car.Id                    AS CarId
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.Id               AS CarModelId
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

           , Object_From.Id           AS FromId
           , Object_From.ValueData    AS FromName
           , Object_To.Id             AS ToId
           , Object_To.ValueData      AS ToName

           , COALESCE (tmpQualityDoc.QualityNumber, tmpQualityDoc_old.QualityNumber) :: TVarChar AS QualityNumber
           , COALESCE (tmpQualityDoc.CertificateNumber, tmpQualityDoc_old.CertificateNumber) :: TVarChar AS CertificateNumber
           , COALESCE (tmpQualityDoc.OperDateCertificate, tmpQualityDoc_old.OperDateCertificate) :: TDateTime AS OperDateCertificate
           , COALESCE (tmpQualityDoc.CertificateSeries, tmpQualityDoc_old.CertificateSeries) :: TVarChar AS CertificateSeries
           , COALESCE (tmpQualityDoc.CertificateSeriesNumber, tmpQualityDoc_old.CertificateSeriesNumber) :: TVarChar AS CertificateSeriesNumber

           , TRUE AS isNew
       FROM (SELECT inMovementId_Sale AS MovementId) AS tmp
            LEFT JOIN Movement ON Movement.Id = tmp.MovementId
                             -- AND Movement.DescId IN zc_Movement_Sale()

            LEFT JOIN MovementDate ON MovementDate.MovementId = Movement.Id
                                  AND MovementDate.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = MovementLinkMovement_TransportGoods.MovementChildId
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId =  Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

            LEFT JOIN tmpQualityDoc ON 1 = 1
            LEFT JOIN tmpQualityDoc_old ON 1 = 1
      ;
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_QualityDoc (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.05.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_QualityDoc (inMovementId:= 0, inMovementId_Sale:= 2, inSession:= zfCalc_UserAdmin())
