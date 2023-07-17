-- Function: gpSelect_Movement_LossAsset_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_LossAsset_Print (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LossAsset_Print(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inisItem                     Boolean  , -- не сворачивать по MovementItem да / нет
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

    OPEN Cursor1 FOR
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                     :: TVarChar AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName
           , Object_ArticleLoss.Id                              AS ArticleLossId
           , Object_ArticleLoss.ValueData                       AS ArticleLossName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_ArticleLoss
                                         ON MovementLinkObject_ArticleLoss.MovementId = Movement.Id
                                        AND MovementLinkObject_ArticleLoss.DescId = zc_MovementLinkObject_ArticleLoss()
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = MovementLinkObject_ArticleLoss.ObjectId

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_LossAsset()
      ;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       SELECT
             MovementItem.Id         AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , Asset_AssetGroup.ValueData         AS GoodsGroupNameFull

           , MovementItem.Amount                 AS Amount

           , Object_Maker.Id             AS MakerId
           , Object_Maker.ObjectCode     AS MakerCode
           , Object_Maker.ValueData      AS MakerName

           , Object_Car.Id               AS CarId
           , Object_Car.ObjectCode       AS CarCode
           , Object_Car.ValueData        AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , COALESCE (ObjectDate_Release.ValueData,CAST (CURRENT_DATE as TDateTime)) AS Release
           , ObjectString_InvNumber.ValueData      AS InvNumber
           , ObjectString_SerialNumber.ValueData   AS SerialNumber
           , ObjectString_PassportNumber.ValueData AS PassportNumber
           , ObjectFloat_PeriodUse.ValueData  AS PeriodUse

       FROM MovementItem

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
             
            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Asset_AssetGroup
                                 ON ObjectLink_Asset_AssetGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Asset_AssetGroup.DescId = zc_ObjectLink_Asset_AssetGroup()
            LEFT JOIN Object AS Asset_AssetGroup ON Asset_AssetGroup.Id = ObjectLink_Asset_AssetGroup.ChildObjectId

            ---
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Maker
                                 ON ObjectLink_Asset_Maker.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Asset_Maker.DescId = zc_ObjectLink_Asset_Maker()
            LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Asset_Maker.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Asset_Car
                                 ON ObjectLink_Asset_Car.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Asset_Car.DescId = zc_ObjectLink_Asset_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_Asset_Car.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId =  Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId
              
            LEFT JOIN ObjectDate AS ObjectDate_Release
                                 ON ObjectDate_Release.ObjectId = MovementItem.ObjectId
                                AND ObjectDate_Release.DescId = zc_ObjectDate_Asset_Release()
  
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()
  
            LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                   ON ObjectString_SerialNumber.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_Asset_SerialNumber()
  
            LEFT JOIN ObjectString AS ObjectString_PassportNumber
                                   ON ObjectString_PassportNumber.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_PassportNumber.DescId = zc_ObjectString_Asset_PassportNumber()
  
            LEFT JOIN ObjectFloat AS ObjectFloat_PeriodUse
                                  ON ObjectFloat_PeriodUse.ObjectId = MovementItem.ObjectId
                                 AND ObjectFloat_PeriodUse.DescId = zc_ObjectFloat_Asset_PeriodUse()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
        ;


    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_LossAsset_Print (Integer, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.03.20         *
*/

-- SELECT * FROM gpSelect_Movement_LossAsset_Print (inMovementId := 570596, inisItem:= false, inSession:= '5');