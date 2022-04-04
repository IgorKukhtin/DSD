-- Function: gpSelect_Movement_Loss_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss_Print(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
     vbUserId:= lpGetUserBySession (inSession);

    OPEN Cursor1 FOR
--     WITH tmpObject_GoodsPropertyValue AS


       SELECT
             Movement.Id                                        AS Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) AS IdBarCode
           , Movement.InvNumber                                 AS InvNumber
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
         AND Movement.DescId = zc_Movement_Loss();
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
       SELECT
             MovementItem.Id                    AS Id
           , Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
           , MovementItem.Amount                AS Amount
           , MIFloat_Count.ValueData            AS Count
           , MIFloat_HeadCount.ValueData        AS HeadCount
           , MIDate_PartionGoods.ValueData      AS PartionGoodsDate
           , MIString_PartionGoods.ValueData    AS PartionGoods
           , Object_GoodsKind.Id                AS GoodsKindId
           , (TRIM (COALESCE (Object_GoodsKind.ValueData, '') || ' ' || COALESCE (Object_Asset.ValueData, ''))) :: TVarChar AS GoodsKindName
           , Object_Asset.Id                    AS AssetId
           , Object_Asset.ValueData             AS AssetName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyName

           , Object_PartionGoods.Id             AS PartionGoodsId
           , Object_PartionGoods.ValueData      AS PartionGoodsName
           , ObjectDate_Value.ValueData         AS PartionGoodsOperDate
           , ObjectFloat_Price.ValueData        AS Price
           , Object_Storage_Partion.ValueData   AS StorageName_Partion
           , Object_Unit.ValueData              AS UnitName
           
           , Object_Measure.ValueData           AS MeasureName
           , CAST ((MovementItem.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Kg() THEN 1 ELSE COALESCE (ObjectFloat_Weight.ValueData, 0) END )) AS TFloat) AS Amount_Weight


       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                 ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionGoods
                                             ON MILinkObject_PartionGoods.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionGoods.DescId = zc_MILinkObject_PartionGoods()
            LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = MILinkObject_PartionGoods.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Price ON ObjectFloat_Price.ObjectId = Object_PartionGoods.Id                      -- цена
                                                      AND ObjectFloat_Price.DescId = zc_ObjectFloat_PartionGoods_Price()
            LEFT JOIN ObjectLink AS ObjectLink_Storage ON ObjectLink_Storage.ObjectId = Object_PartionGoods.Id 		        -- склад
                                                      AND ObjectLink_Storage.DescId = zc_ObjectLink_PartionGoods_Storage()
            LEFT JOIN Object AS Object_Storage_Partion ON Object_Storage_Partion.Id = ObjectLink_Storage.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit ON ObjectLink_Unit.ObjectId = Object_PartionGoods.Id		        -- подразделение
                                                   AND ObjectLink_Unit.DescId = zc_ObjectLink_PartionGoods_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

            LEFT JOIN ObjectDate as objectdate_value ON objectdate_value.ObjectId = Object_PartionGoods.Id                    -- дата
                                                    AND objectdate_value.DescId = zc_ObjectDate_PartionGoods_Value()
                                                    
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                 
            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND MovementItem.isErased   = False
            ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Loss_Print (Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.10.18         * IdBarCode
 19.11.14                                                       *
*/

-- SELECT * FROM gpSelect_Movement_Loss_Print (inMovementId := 570596, inSession:= '5'); -- FETCH ALL "<unnamed portal 1>";
