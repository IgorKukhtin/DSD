-- Function: gpSelect_Movement_Income_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
   INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- проверка - с каким статусом можно печатать
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

     -- Результат
     OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId   AS GoodsId
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                     )
                     
       -- Результат
       SELECT
             tmpMI.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.Id) AS IdBarCode
           , ObjectString_Article.ValueData AS Article
           , MIString_PartNumber.ValueData  AS PartNumber
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = tmpMI.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
       ORDER BY Object_Goods.ValueData
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
28.09.21          *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId := 432692, inSession:= '5');
