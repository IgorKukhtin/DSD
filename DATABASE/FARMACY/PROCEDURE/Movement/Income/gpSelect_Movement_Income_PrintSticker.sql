-- Function: gpSelect_Movement_Income_PrintSticker()

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId                 Integer  , -- ключ Документа
    IN inSession                    TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
  
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId
          , Movement.StatusId
          , MovementLinkObject_To.ObjectId  
       INTO vbDescId, vbStatusId, vbUnitId
     FROM Movement
        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
      RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
    END IF;
     --

    OPEN Cursor1 FOR
      SELECT
             zfFormat_BarCode(zc_BarCodePref_Object(), Object_Price_View.Id) AS IdBarCode
           , Object_Goods.ValueData                                          AS GoodsName
           , COALESCE(MIFloat_PriceSale.ValueData,0)::TFloat                 AS SalePrice
          
       FROM  MovementItem 
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                        ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT OUTER JOIN Object_Price_View ON Object_Price_View.GoodsId = MovementItem.ObjectId
                                             AND Object_Price_View.UnitId = vbUnitId

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
        ORDER BY Object_Goods.ValueData;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 12.12.16         *
*/
-- тест
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
--select * from gpSelect_Movement_Income_PrintSticker(inMovementId := 2229064 ,  inSession := '3');

 