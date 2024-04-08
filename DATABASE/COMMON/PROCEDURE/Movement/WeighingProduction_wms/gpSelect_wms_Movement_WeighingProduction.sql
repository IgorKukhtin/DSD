-- Function: gpSelect_wms_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_wms_Movement_WeighingProduction (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_wms_Movement_WeighingProduction (
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

             , MovementId_parent Integer
             , OperDate_parent TDateTime
             , InvNumber_parent TVarChar
             , WeighingNumber_parent TFloat
             , OperDate_parent_main TDateTime
             , InvNumber_parent_main TVarChar

             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar

             , GoodsTypeKindName TVarChar
             , BarCodeBoxName TVarChar
             , BoxName TVarChar
             , sku_id TVarChar
             , sku_code TVarChar
             , StatusCode_wms Integer
             , StatusName_wms TVarChar

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
             , SubjectDocId Integer, SubjectDocName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY

       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
              , tmpMI AS (SELECT DISTINCT
                                 MovementItem.MovementId, MovementItem.ParentId, MovementItem.GoodsTypeKindId, MovementItem.BarCodeBoxId, MovementItem.StatusId_wms
                               , Movement.GoodsId, Movement.GoodsKindId
                          FROM tmpStatus
                               INNER JOIN wms_Movement_WeighingProduction AS Movement
                                                                          ON Movement.StatusId = tmpStatus.StatusId
                                                                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               INNER JOIN wms_MI_WeighingProduction AS MovementItem
                                                                    ON MovementItem.MovementId = Movement.Id
                                                                   AND MovementItem.isErased   = FALSE
                         )
      , tmpGoods_list AS (SELECT DISTINCT tmpMI.GoodsId, tmpMI.GoodsKindId
                          FROM tmpMI
                         )
   , tmpGoods_wms_all AS (SELECT tmp.*
                          FROM wms_Object_GoodsByGoodsKind AS tmp
                               JOIN tmpGoods_list ON tmpGoods_list.GoodsId     = tmp.GoodsId
                                                 AND tmpGoods_list.GoodsKindId     = tmp.GoodsKindId
                         )
       , tmpGoods_wms AS (SELECT tmp.*
                          FROM wms_Object_GoodsByGoodsKind AS tmp
                               JOIN tmpGoods_list ON tmpGoods_list.GoodsId     = tmp.GoodsId
                                                 AND tmpGoods_list.GoodsKindId = tmp.GoodsKindId
                         )
               , tmpGoods AS (-- Штучный
                              SELECT tmpGoods_all.sku_id_Sh           AS sku_id
                                   , tmpGoods_all.sku_code_Sh         AS sku_code
                                   , tmpGoods_all.GoodsTypeKindId_Sh  AS GoodsTypeKindId
                                   , tmpGoods_all.GoodsId             AS GoodsId
                                   , tmpGoods_all.GoodsKindId         AS GoodsKindId
                              FROM tmpGoods_wms_all AS tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Sh  = zc_Enum_GoodsTypeKind_Sh()
                             UNION ALL
                              -- Номинальный
                              SELECT tmpGoods_all.sku_id_Nom          AS sku_id
                                   , tmpGoods_all.sku_code_Nom        AS sku_code
                                   , tmpGoods_all.GoodsTypeKindId_Nom AS GoodsTypeKindId
                                   , tmpGoods_all.GoodsId             AS GoodsId
                                   , tmpGoods_all.GoodsKindId         AS GoodsKindId
                              FROM tmpGoods_wms_all AS tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Nom = zc_Enum_GoodsTypeKind_Nom()
                             UNION ALL
                              -- Весовой
                              SELECT tmpGoods_all.sku_id_Ves          AS sku_id
                                   , tmpGoods_all.sku_code_Ves        AS sku_code
                                   , tmpGoods_all.GoodsTypeKindId_Ves AS GoodsTypeKindId
                                   , tmpGoods_all.GoodsId             AS GoodsId
                                   , tmpGoods_all.GoodsKindId         AS GoodsKindId
                              FROM tmpGoods_wms_all AS tmpGoods_all WHERE tmpGoods_all.GoodsTypeKindId_Ves = zc_Enum_GoodsTypeKind_Ves()
                             )
       -- Результат
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

             , Movement_Parent.Id                   AS MovementId_parent
             , Movement_Parent.OperDate             AS OperDate_parent
             , CASE WHEN Movement_Parent.StatusId = zc_Enum_Status_Complete()
                         THEN Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Parent.InvNumber
                    WHEN Movement_Parent.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Parent.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumber_parent
             , MovementFloat_WeighingNumber_parent.ValueData AS WeighingNumber_parent

             , Movement_Parent_main.OperDate          AS OperDate_parent_main
             , CASE WHEN Movement_Parent_main.StatusId = zc_Enum_Status_Complete()
                         THEN Movement_Parent_main.InvNumber
                    WHEN Movement_Parent_main.StatusId = zc_Enum_Status_UnComplete()
                         THEN '***' || Movement_Parent_main.InvNumber
                    WHEN Movement_Parent_main.StatusId = zc_Enum_Status_Erased()
                         THEN '*' || Movement_Parent_main.InvNumber
                    ELSE ''
               END :: TVarChar AS InvNumber_parent_main

             , Object_From.Id                       AS FromId
             , Object_From.ValueData                AS FromName
             , Object_To.Id                         AS Toid
             , Object_To.ValueData                  AS ToName

             , Object_Goods.Id                      AS GoodsId
             , Object_Goods.ObjectCode              AS GoodsCode
             , Object_Goods.ValueData               AS GoodsName
             , Object_GoodsKind.Id                  AS GoodsKindId
             , Object_GoodsKind.ValueData           AS GoodsKindName
             , Object_GoodsTypeKind.ValueData       AS GoodsTypeKindName
             , Object_BarCodeBox.ValueData          AS BarCodeBoxName
             , Object_Box.ValueData                 AS BoxName
             , tmpGoods.sku_id          :: TVarChar AS sku_id
             , tmpGoods.sku_code                    AS sku_code
             , Object_Status_wms.ObjectCode         AS StatusCode_wms
             , Object_Status_wms.ValueData          AS StatusName_wms

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

             , Object_User.Id                   AS UserId
             , Object_User.ValueData            AS UserName

             , Object_SubjectDoc.Id             AS SubjectDocId
             , Object_SubjectDoc.ValueData      AS SubjectDocName
       FROM tmpStatus
            INNER JOIN wms_Movement_WeighingProduction AS Movement
                                                       ON Movement.StatusId = tmpStatus.StatusId
                                                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id
            LEFT JOIN Object AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = tmpMI.GoodsTypeKindId
            LEFT JOIN Object AS Object_BarCodeBox    ON Object_BarCodeBox.Id    = tmpMI.BarCodeBoxId
            LEFT JOIN Object AS Object_Status_wms    ON Object_Status_wms.Id    = tmpMI.StatusId_wms
            LEFT JOIN tmpGoods ON tmpGoods.GoodsTypeKindId = tmpMI.GoodsTypeKindId
                              AND tmpGoods.GoodsId         = tmpMI.GoodsId
                              AND tmpGoods.GoodsKindId     = tmpMI.GoodsKindId
            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box
                                 ON ObjectLink_BarCodeBox_Box.ObjectId = tmpMI.BarCodeBoxId
                                AND ObjectLink_BarCodeBox_Box.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_BarCodeBox_Box.ChildObjectId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.MovementDescId

            LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = tmpMI.ParentId
            LEFT JOIN MovementFloat AS MovementFloat_WeighingNumber_Parent
                                    ON MovementFloat_WeighingNumber_Parent.MovementId =  Movement_Parent.Id
                                   AND MovementFloat_WeighingNumber_Parent.DescId = zc_MovementFloat_WeighingNumber()
            LEFT JOIN Movement AS Movement_Parent_main ON Movement_Parent_main.Id = Movement_Parent.ParentId

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SubjectDoc
                                         ON MovementLinkObject_SubjectDoc.MovementId = Movement.Id
                                        AND MovementLinkObject_SubjectDoc.DescId = zc_MovementLinkObject_SubjectDoc()
            LEFT JOIN Object AS Object_SubjectDoc ON Object_SubjectDoc.Id = MovementLinkObject_SubjectDoc.ObjectId
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
-- SELECT * FROM gpSelect_wms_Movement_WeighingProduction(inStartDate := ('23.05.2019')::TDateTime , inEndDate := ('23.05.2019')::TDateTime , inIsErased := 'True' , inJuridicalBasisId := 9399 ,  inSession := '5');
