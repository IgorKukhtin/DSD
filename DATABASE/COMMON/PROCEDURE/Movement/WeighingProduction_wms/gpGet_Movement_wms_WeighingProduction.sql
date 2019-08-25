-- Function: gpGet_wms_Movement_WeighingProduction(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_wms_Movement_WeighingProduction (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_wms_Movement_WeighingProduction (BigInt, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_wms_Movement_WeighingProduction (
    IN inMovementId        BigInt   , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
          -- , Id BigInt
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
             , GoodsTypeKindId_1 Integer, GoodsTypeKindName_1 TVarChar
             , GoodsTypeKindId_2 Integer, GoodsTypeKindName_2 TVarChar
             , GoodsTypeKindId_3 Integer, GoodsTypeKindName_3 TVarChar
             , BarCodeBoxId_1 Integer, BarCodeBoxName_1 TVarChar
             , BarCodeBoxId_2 Integer, BarCodeBoxName_2 TVarChar
             , BarCodeBoxId_3 Integer, BarCodeBoxName_3 TVarChar
             , BoxId_1 Integer, BoxName_1 TVarChar
             , BoxId_2 Integer, BoxName_2 TVarChar
             , BoxId_3 Integer, BoxName_3 TVarChar
             , UserId Integer, UserName TVarChar

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Get_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY 
         SELECT
               0 :: Integer AS Id
           --  0 :: BigInt AS Id
             , CAST (NEXTVAL ('wms_Movement_WeighingProduction_seq') AS TVarChar) AS InvNumber
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

             , 0                      AS GoodsTypeKindId_1
             , CAST ('' as TVarChar)  AS GoodsTypeKindName_1
             , 0                      AS GoodsTypeKindId_2
             , CAST ('' as TVarChar)  AS GoodsTypeKindName_2
             , 0                      AS GoodsTypeKindId_3
             , CAST ('' as TVarChar)  AS GoodsTypeKindName_3
             , 0                      AS BarCodeBoxId_1
             , CAST ('' as TVarChar)  AS BarCodeBoxName_1
             , 0                      AS BarCodeBoxId_2
             , CAST ('' as TVarChar)  AS BarCodeBoxName_2
             , 0                      AS BarCodeBoxId_3
             , CAST ('' as TVarChar)  AS BarCodeBoxName_3

             , 0                      AS BoxId_1
             , CAST ('' as TVarChar)  AS BoxName_1
             , 0                      AS BoxId_2
             , CAST ('' as TVarChar)  AS BoxName_2
             , 0                      AS BoxId_3
             , CAST ('' as TVarChar)  AS BoxName_3

             , 0                      AS UserId
             , CAST ('' as TVarChar)  AS UserName
             
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY 
         SELECT
               Movement.Id :: Integer
             , Movement.InvNumber                   AS InvNumber
             , Movement.OperDate                    AS OperDate
             , Object_Status.ObjectCode             AS StatusCode
             , Object_Status.ValueData              AS StatusName

             , Movement.StartWeighing  
             , Movement.EndWeighing

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

             , Object_GoodsTypeKind_1.Id            AS GoodsTypeKindId_1
             , CASE WHEN Movement.GoodsTypeKindId_1 < 0 THEN Movement.GoodsTypeKindId_1 :: TVarChar ELSE Object_GoodsTypeKind_1.ValueData END AS GoodsTypeKindName_1
             , Object_GoodsTypeKind_2.Id            AS GoodsTypeKindId_2
             , CASE WHEN Movement.GoodsTypeKindId_2 < 0 THEN Movement.GoodsTypeKindId_2 :: TVarChar ELSE Object_GoodsTypeKind_2.ValueData END AS GoodsTypeKindName_2
             , Object_GoodsTypeKind_3.Id            AS GoodsTypeKindId_3
             , CASE WHEN Movement.GoodsTypeKindId_3 < 0 THEN Movement.GoodsTypeKindId_3 :: TVarChar ELSE Object_GoodsTypeKind_3.ValueData END AS GoodsTypeKindName_3
             , Object_BarCodeBox_1.Id               AS BarCodeBoxId_1
             , CASE WHEN Movement.BarCodeBoxId_1 = 0 THEN Movement.BarCodeBoxId_1 :: TVarChar ELSE Object_BarCodeBox_1.ValueData END AS BarCodeBoxName_1
             , Object_BarCodeBox_2.Id               AS BarCodeBoxId_2
             , CASE WHEN Movement.BarCodeBoxId_2 = 0 THEN Movement.BarCodeBoxId_2 :: TVarChar ELSE Object_BarCodeBox_2.ValueData END AS BarCodeBoxName_2
             , Object_BarCodeBox_3.Id               AS BarCodeBoxId_3
             , CASE WHEN Movement.BarCodeBoxId_3 = 0 THEN Movement.BarCodeBoxId_3 :: TVarChar ELSE Object_BarCodeBox_3.ValueData END AS BarCodeBoxName_3

             , Object_Box1.Id                   AS BoxId_1
             , Object_Box1.ValueData            AS BoxName_1
             , Object_Box2.Id                   AS BoxId_2
             , Object_Box2.ValueData            AS BoxName_2
             , Object_Box3.Id                   AS BoxId_3
             , Object_Box3.ValueData            AS BoxName_3

             , Object_User.Id                       AS UserId
             , Object_User.ValueData                AS UserName

       FROM wms_Movement_WeighingProduction AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.MovementDescId
            
            LEFT JOIN Object AS Object_From ON Object_From.Id = Movement.FromId
            LEFT JOIN Object AS Object_To   ON Object_To.Id   = Movement.ToId
            LEFT JOIN Object AS Object_User ON Object_User.Id = Movement.UserId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = Movement.GoodsKindId

            LEFT JOIN Object AS Object_GoodsTypeKind_1 ON Object_GoodsTypeKind_1.Id = Movement.GoodsTypeKindId_1
            LEFT JOIN Object AS Object_GoodsTypeKind_2 ON Object_GoodsTypeKind_2.Id = Movement.GoodsTypeKindId_2
            LEFT JOIN Object AS Object_GoodsTypeKind_3 ON Object_GoodsTypeKind_3.Id = Movement.GoodsTypeKindId_3
            LEFT JOIN Object AS Object_BarCodeBox_1    ON Object_BarCodeBox_1.Id = Movement.BarCodeBoxId_1
            LEFT JOIN Object AS Object_BarCodeBox_2    ON Object_BarCodeBox_2.Id = Movement.BarCodeBoxId_2
            LEFT JOIN Object AS Object_BarCodeBox_3    ON Object_BarCodeBox_3.Id = Movement.BarCodeBoxId_3

            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box1
                                 ON ObjectLink_BarCodeBox_Box1.ObjectId = Object_BarCodeBox_1.Id
                                AND ObjectLink_BarCodeBox_Box1.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box1 ON Object_Box1.Id = ObjectLink_BarCodeBox_Box1.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box2
                                 ON ObjectLink_BarCodeBox_Box2.ObjectId = Object_BarCodeBox_2.Id
                                AND ObjectLink_BarCodeBox_Box2.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box2 ON Object_Box2.Id = ObjectLink_BarCodeBox_Box2.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box3
                                 ON ObjectLink_BarCodeBox_Box3.ObjectId = Object_BarCodeBox_3.Id
                                AND ObjectLink_BarCodeBox_Box3.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box3 ON Object_Box3.Id = ObjectLink_BarCodeBox_Box3.ChildObjectId

       WHERE Movement.Id =  inMovementId;

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
-- SELECT * FROM gpGet_wms_Movement_WeighingProduction(inMovementId := 0 ,  inSession := '5');
