-- Function: gpSelect_wms_MI_WeighingProduction()

DROP FUNCTION IF EXISTS gpSelect_wms_MI_WeighingProduction (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_wms_MI_WeighingProduction (BigInt, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_wms_MI_WeighingProduction (
    IN inMovementId  BigInt       , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
          -- , Id BigInt
             , MovementId_Parent Integer, InvNumber_Parent TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar
             , BoxId Integer, BoxName TVarChar
             , WmsCode TVarChar
             , LineCode Integer
             , Amount TFloat, RealWeight TFloat
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_wms_MI_WeighingProduction());

     RETURN QUERY 
       SELECT
             MovementItem.Id :: Integer
           , Movement_Parent.Id                   AS MovementId_Parent
           , Movement_Parent.InvNumber ::TVarChar AS InvNumber_Parent
           , Object_GoodsTypeKind.Id              AS GoodsTypeKindId
           , Object_GoodsTypeKind.ValueData       AS GoodsTypeKindName
           , Object_BarCodeBox.Id                 AS BarCodeBoxId
           , Object_BarCodeBox.ValueData          AS BarCodeBoxName
           , Object_Box.Id                        AS BoxId
           , Object_Box.ValueData                 AS BoxName
           , MovementItem.WmsCode
           , MovementItem.LineCode
           , COALESCE (MovementItem.Amount, 1) :: TFloat AS Amount
           , MovementItem.RealWeight           :: TFloat
           , MovementItem.InsertDate
           , MovementItem.UpdateDate
           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN wms_MI_WeighingProduction AS MovementItem 
                                                 ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Movement AS Movement_Parent      ON Movement_Parent.Id      = MovementItem.ParentId
            LEFT JOIN Object   AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = MovementItem.GoodsTypeKindId
            LEFT JOIN Object   AS Object_BarCodeBox    ON Object_BarCodeBox.Id    = MovementItem.BarCodeBoxId

            LEFT JOIN ObjectLink AS ObjectLink_BarCodeBox_Box
                                 ON ObjectLink_BarCodeBox_Box.ObjectId = MovementItem.BarCodeBoxId
                                AND ObjectLink_BarCodeBox_Box.DescId = zc_ObjectLink_BarCodeBox_Box()
            LEFT JOIN Object AS Object_Box ON Object_Box.Id = ObjectLink_BarCodeBox_Box.ChildObjectId
;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.05.19         *
*/

-- тест
-- SELECT * FROM gpSelect_wms_MI_WeighingProduction (inMovementId:= 0, inIsErased:= FALSE, inSession:= '5');
