-- Function: gpSelect_Movement_WeighingProduction_wms()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingProduction_wms (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingProduction_wms (
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inIsErased          Boolean ,
    IN inJuridicalBasisId  Integer ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
          -- , Id BigInt
             , InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer
             , MovementDescName TVarChar
             , PlaceNumber Integer
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
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

       SELECT  Movement.Id :: Integer
             , zfConvert_StringToNumber (Movement.InvNumber)  AS InvNumber
             , Movement.OperDate                    AS OperDate
             , Object_Status.ObjectCode             AS StatusCode
             , Object_Status.ValueData              AS StatusName

             , Movement.StartWeighing               AS StartWeighing  
             , Movement.EndWeighing                 AS EndWeighing

             , Movement.MovementDescNumber          AS MovementDescNumber
             , MovementDesc.ItemName                AS MovementDescName
             , Movement.PlaceNumber                 AS PlaceNumber

             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , Object_To.Id                         AS Toid
             , Object_To.ValueData                  AS ToName

             , Object_Goods.Id                      AS GoodsId
             , Object_Goods.ObjectCode              AS GoodsCode
             , Object_Goods.ValueData               AS GoodsName
             , Object_GoodsKind.Id                  AS GoodsKindId
             , Object_GoodsKind.ValueData           AS GoodsKindName

             , Object_GoodsTypeKind_1.Id        AS GoodsTypeKindId_1
             , Object_GoodsTypeKind_1.ValueData AS GoodsTypeKindName_1
             , Object_GoodsTypeKind_2.Id        AS GoodsTypeKindId_2
             , Object_GoodsTypeKind_2.ValueData AS GoodsTypeKindName_2
             , Object_GoodsTypeKind_3.Id        AS GoodsTypeKindId_3
             , Object_GoodsTypeKind_3.ValueData AS GoodsTypeKindName_3
             , Object_BarCodeBox_1.Id           AS BarCodeBoxId_1
             , Object_BarCodeBox_1.ValueData    AS BarCodeBoxName_1
             , Object_BarCodeBox_2.Id           AS BarCodeBoxId_2
             , Object_BarCodeBox_2.ValueData    AS BarCodeBoxName_2
             , Object_BarCodeBox_3.Id           AS BarCodeBoxId_3
             , Object_BarCodeBox_3.ValueData    AS BarCodeBoxName_3
             , Object_Box1.Id                   AS BoxId_1
             , Object_Box1.ValueData            AS BoxName_1
             , Object_Box2.Id                   AS BoxId_2
             , Object_Box2.ValueData            AS BoxName_2
             , Object_Box3.Id                   AS BoxId_3
             , Object_Box3.ValueData            AS BoxName_3
             
             , Object_User.Id                       AS UserId
             , Object_User.ValueData                AS UserName
       FROM tmpStatus
            INNER JOIN Movement_WeighingProduction AS Movement
                                                   ON Movement.StatusId = tmpStatus.StatusId
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate

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
            LEFT JOIN Object AS Object_BarCodeBox_1 ON Object_BarCodeBox_1.Id = Movement.BarCodeBoxId_1
            LEFT JOIN Object AS Object_BarCodeBox_2 ON Object_BarCodeBox_2.Id = Movement.BarCodeBoxId_2
            LEFT JOIN Object AS Object_BarCodeBox_3 ON Object_BarCodeBox_3.Id = Movement.BarCodeBoxId_3

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
-- SELECT * FROM gpSelect_Movement_WeighingProduction_wms(inStartDate := ('23.05.2019')::TDateTime , inEndDate := ('23.05.2019')::TDateTime , inIsErased := 'True' , inJuridicalBasisId := 9399 ,  inSession := '5');
