-- Function: gpSelect_Movement_WeighingProduction _wms()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction _wms (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction _wms(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer
             , MovementDescName TVarChar
             , PlaceNumber Integer
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , UserId Integer, UserName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 

       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

       SELECT  Movement.Id
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate                    AS OperDate
             , Object_Status.ObjectCode             AS StatusCode
             , Object_Status.ValueData              AS StatusName

             , MovementDate_StartWeighing.ValueData AS StartWeighing  
             , MovementDate_EndWeighing.ValueData   AS EndWeighing

             , Movement.MovementDescNumber          AS MovementDescNumber
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
       FROM tmpStatus
            INNER JOIN Movement_WeighingProduction ON Movement.StatusId = tmpStatus.StatusId
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.MovementDescId
            
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = Movement.ToId
            LEFT JOIN Object AS Object_User ON Object_User.Id = Movement.UserId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Movement.GoodsKindId
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.05.19         *
*/

-- тест
--