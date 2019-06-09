-- Function: gpSelect_MI_WeighingProduction_wms()

DROP FUNCTION IF EXISTS gpSelect_MI_WeighingProduction_wms (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_WeighingProduction_wms (BigInt, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_WeighingProduction_wms (
    IN inMovementId  BigInt       , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
          -- , Id BigInt
             , MovementId_Parent Integer, InvNumber_Parent TVarChar
             , GoodsTypeKindId Integer, GoodsTypeKindName TVarChar
             , BarCodeBoxId Integer, BarCodeBoxName TVarChar
             , WmsCode TVarChar
             , LineCode Integer
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_WeighingProduction());

     RETURN QUERY 
       SELECT
             MovementItem.Id :: Integer
           , Movement_Parent.Id                   AS MovementId_Parent
           , Movement_Parent.InvNumber ::TVarChar AS InvNumber_Parent
           , Object_GoodsTypeKind.Id              AS GoodsTypeKindId
           , Object_GoodsTypeKind.ValueData       AS GoodsTypeKindName
           , Object_BarCodeBox.Id                 AS BarCodeBoxId
           , Object_BarCodeBox.ValueData          AS BarCodeBoxName
           , MovementItem.WmsCode
           , MovementItem.LineCode
           , MovementItem.InsertDate
           , MovementItem.UpdateDate
           , MovementItem.isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            INNER JOIN MI_WeighingProduction AS MovementItem 
                                             ON MovementItem.MovementId = inMovementId
                                            AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Movement AS Movement_Parent      ON Movement_Parent.Id      = MovementItem.ParentId
            LEFT JOIN Object   AS Object_GoodsTypeKind ON Object_GoodsTypeKind.Id = MovementItem.GoodsTypeKindId
            LEFT JOIN Object   AS Object_BarCodeBox    ON Object_BarCodeBox.Id    = MovementItem.BarCodeBoxId
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
-- SELECT * FROM gpSelect_MI_WeighingProduction_wms (inMovementId:= 0, inIsErased:= FALSE, inSession:= '5');
