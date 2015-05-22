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
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_QualityDoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- пытаемся найти по продаже
     IF inMovementId_Sale <> 0 AND COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT MLM.MovementId FROM MovementLinkMovement AS MLM WHERE MLM.MovementChildId = inMovementId_Sale AND MLM.DescId = zc_MovementLinkMovement_Child() LIMIT 1);
     END IF;

     -- Проверка
     IF inMovementId > 0 AND NOT EXISTS (SELECT Movement.Id FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_Loss()))
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

       FROM Movement
            LEFT JOIN MovementDate AS MovementDate_OperDateIn
                                   ON MovementDate_OperDateIn.MovementId =  Movement.Id
                                  AND MovementDate_OperDateIn.DescId = zc_MovementDate_OperDateIn()
            LEFT JOIN MovementDate AS MovementDate_OperDateOut
                                   ON MovementDate_OperDateOut.MovementId =  Movement.Id
                                  AND MovementDate_OperDateOut.DescId = zc_MovementDate_OperDateOut()

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
       SELECT
             0                 AS Id
           , '' :: TVarChar    AS InvNumber
           , NULL :: TDateTime AS OperDate
           , Movement.OperDate AS OperDateIn
           , Movement.OperDate AS OperDateOut

           , Movement.Id        AS MovementId_Sale
           , Movement.InvNumber AS InvNumber_Sale
           , Movement.OperDate  AS OperDate_Sale

           , Object_Car.Id                    AS CarId
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.Id               AS CarModelId
           , Object_CarModel.ValueData        AS CarModelName

           , Object_From.Id           AS FromId
           , Object_From.ValueData    AS FromName
           , Object_To.Id             AS ToId
           , Object_To.ValueData      AS ToName

       FROM Movement
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

       WHERE Movement.Id = inMovementId_Sale
         AND Movement.DescId = zc_Movement_QualityDoc()
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
