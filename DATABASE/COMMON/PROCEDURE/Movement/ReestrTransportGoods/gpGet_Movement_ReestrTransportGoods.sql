-- FunctiON: gpGet_Movement_ReestrTransportGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_ReestrTransportGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ReestrTransportGoods(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , InsertId Integer, InsertName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Reestr());
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
        inMovementId:=( SELECT MAX(MLО.MovementId)
                        FROM Movement
                            INNER JOIN MovementLinkObject AS MLО
                                                          ON MLО.MovementId = Movement.Id 
                                                         AND MLО.DescId = zc_MovementLinkObject_Insert()
                                                         AND MLО.ObjectId = vbUserId
                        WHERE Movement.DescId = zc_Movement_ReestrTransportGoods()
                          AND Movement.OperDate = CURRENT_Date
                          AND Movement.StatusId <> zc_Enum_Status_Erased())
                        ;
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 AS Id
             , CAST ('' AS TVarChar)   AS InvNumber 
             , CURRENT_DATE::TDateTime AS OperDate
             , Object_Status.Code      AS StatusCode
             , Object_Status.Name      AS StatusName
             , 0                       AS InsertId
             , Object_Insert.ValueData AS InsertName
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;
     ELSE
       RETURN QUERY 
       
         -- результат
         SELECT
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_Status.ObjectCode          AS StatusCode
             , Object_Status.ValueData           AS StatusName
             , Object_Insert.Id                  AS InsertId
             , Object_Insert.ValueData           AS InsertName
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId 

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_ReestrTransportGoods();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.20         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReestrTransportGoods (inMovementId:= 0 ::integer,  inSession:= '5'::TVarChar)
--select * from gpGet_Movement_ReestrTransportGoods(inMovementId := 0 ,  inSession := '5');
