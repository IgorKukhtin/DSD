-- Function: gpGet_ScaleCeh_Movement()

DROP FUNCTION IF EXISTS gpGet_ScaleCeh_Movement (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ScaleCeh_Movement(
    IN inMovementId            Integer     , --
    IN inOperDate              TDateTime   , --
    IN inIsNext                Boolean     , --
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (MovementId       Integer
             , BarCode          TVarChar
             , InvNumber        TVarChar
             , OperDate         TDateTime

             , isProductionIn     Boolean
             , MovementDescNumber Integer

             , MovementDescId Integer
             , FromId         Integer, FromCode         Integer, FromName       TVarChar
             , ToId           Integer, ToCode           Integer, ToName         TVarChar
              )
AS	
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);


    -- Результат
    RETURN QUERY
       WITH tmpMovement_find AS (-- если inMovementId = 0, тогда - последний не закрытый
                                 SELECT MAX (Movement.Id) AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '3 DAY') AS StartDate, (inOperDate + INTERVAL '3 DAY') AS EndDate WHERE COALESCE (inMovementId, 0) = 0) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId   = vbUserId
                                UNION
                                 -- или "следующий" не закрытый, т.е. <> inMovementId, для inIsNext = TRUE
                                 SELECT Movement.Id AS Id
                                 FROM (SELECT (inOperDate - INTERVAL '1 DAY') AS StartDate, (inOperDate + INTERVAL '1 DAY') AS EndDate WHERE inIsNext = TRUE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             AND Movement.OperDate BETWEEN tmp.StartDate AND tmp.EndDate
                                      INNER JOIN MovementLinkObject
                                              AS MovementLinkObject_User
                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                             AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                             AND MovementLinkObject_User.ObjectId = vbUserId
                                 WHERE Movement.Id <> inMovementId
                                 -- LIMIT 2 -- если больше 1-ого то типа ошибка
                                UNION
                                 -- или inMovementId если он тоже не закрытый, для inIsNext = FALSE
                                 SELECT Movement.Id
                                 FROM (SELECT inMovementId AS MovementId WHERE inMovementId > 0 AND inIsNext = FALSE) AS tmp
                                      INNER JOIN Movement
                                              ON Movement.Id = tmp.MovementId
                                             AND Movement.DescId = zc_Movement_WeighingProduction()
                                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                )
               , tmpMovement AS (SELECT tmpMovement_find.Id
                                      , Movement.InvNumber
                                      , Movement.OperDate
                                      , MovementFloat_MovementDesc.ValueData  AS MovementDescId
                                      , MovementLinkObject_From.ObjectId      AS FromId
                                      , MovementLinkObject_To.ObjectId        AS ToId
                                 FROM tmpMovement_find
                                      LEFT JOIN Movement ON Movement.Id = tmpMovement_find.Id
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                      LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                              ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                             AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                 WHERE tmpMovement_find.Id > 0
                                )
       SELECT tmpMovement.Id                                 AS MovementId
            , '' ::TVarChar                                  AS BarCode
            , tmpMovement.InvNumber                          AS InvNumber
            , tmpMovement.OperDate                           AS OperDate

            , MovementBoolean_isIncome.ValueData             AS isProductionIn
            , MovementFloat_MovementDescNumber.ValueData :: Integer AS MovementDescNumber

            , tmpMovement.MovementDescId :: Integer          AS MovementDescId
            , Object_From.Id                                 AS FromId
            , Object_From.ObjectCode                         AS FromCode
            , Object_From.ValueData                          AS FromName
            , Object_To.Id                                   AS ToId
            , Object_To.ObjectCode                           AS ToCode
            , Object_To.ValueData                            AS ToName

       FROM tmpMovement
            LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.FromId
            LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
            LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId =  tmpMovement.Id
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
            LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                    ON MovementFloat_MovementDescNumber.MovementId =  tmpMovement.Id
                                   AND MovementFloat_MovementDescNumber.DescId = zc_MovementFloat_MovementDescNumber()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_ScaleCeh_Movement (Integer, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.01.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_ScaleCeh_Movement (0, CURRENT_TIMESTAMP, FALSE, zfCalc_UserAdmin())
-- SELECT * FROM gpGet_ScaleCeh_Movement (0, CURRENT_TIMESTAMP, FALSE, zfCalc_UserAdmin())
