-- Function: gpGet_Movement_WeighingProduction_wms(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_WeighingProduction_wms (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_WeighingProduction_wms (
    IN inMovementId        BIGINT   , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id BIGINT
             , InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer
             , MovementDescId Integer, MovementDescName TVarChar
             , PlaceNumber Integer
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , UserId Integer, UserName TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 :: BIGINT AS Id
             , CAST (NEXTVAL ('Movement_WeighingProduction_seq') AS TVarChar) AS InvNumber
             , CAST (CURRENT_DATE as TDateTime) AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName

             , CAST (CURRENT_DATE as TDateTime) AS StartWeighing
             , CAST (CURRENT_DATE as TDateTime) AS EndWeighing

             , 0                      AS MovementDescNumber
             , 0                      AS MovementDescId
             , CAST ('' as TVarChar)  AS MovementDescName
             , 0                      AS PlaceNumber

             , 0                      AS FromId
             , CAST ('' as TVarChar)  AS FromName
             , 0                      AS ToId
             , CAST ('' as TVarChar)  AS ToName

             , 0                      AS GoodsId
             , CAST ('' as TVarChar)  AS GoodsName
             , 0                      AS GoodsKindId
             , CAST ('' as TVarChar)  AS GoodsKindName

             , 0                      AS UserId
             , CAST ('' as TVarChar)  AS UserName
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate                    AS OperDate
             , Object_Status.ObjectCode             AS StatusCode
             , Object_Status.ValueData              AS StatusName

             , MovementDate_StartWeighing.ValueData AS StartWeighing  
             , MovementDate_EndWeighing.ValueData   AS EndWeighing

             , Movement.MovementDescNumber          AS MovementDescNumber
             , MovementDesc.Id                      AS MovementDescId
             , MovementDesc.ItemName                AS MovementDescName
             , Movement.PlaceNumber                 AS PlaceNumber

             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , Object_To.Id                         AS Toid
             , Object_To.ValueData                  AS ToName

             , Object_Goods.Id                      AS GoodsId
             , Object_Goods.ValueData               AS GoodsName
             , Object_GoodsKind.Id                  AS GoodsKindId
             , Object_GoodsKind.ValueData           AS GoodsKindName

             , Object_User.Id                       AS UserId
             , Object_User.ValueData                AS UserName

       FROM Movement_WeighingProduction AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.MovementDescId
            
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = Movement.ToId
            LEFT JOIN Object AS Object_User ON Object_User.Id = Movement.UserId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Movement.GoodsKindId

       WHERE Movement.Id =  inMovementId;
       --  AND Movement.DescId = zc_Movement_WeighingProduction();
     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.19         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_WeighingProduction_wms(inMovementId := 0 ,  inSession := '5');
