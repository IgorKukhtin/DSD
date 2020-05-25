-- Function: gpSelect_wms_Movement_WeighingProduction_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_wms_Movement_WeighingProduction_PrintSticker (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_wms_Movement_WeighingProduction_PrintSticker (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_wms_Movement_WeighingProduction_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inId                Integer   ,   -- строка
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_wms_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT zc_Movement_WeighingProduction(), Movement.StatusId, Movement.OperDate
            INTO vbDescId, vbStatusId
     FROM wms_Movement_WeighingProduction AS Movement
     WHERE Movement.Id = inMovementId;

    -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName || ' (ВМС)' FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM wms_Movement_WeighingProduction WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM wms_Movement_WeighingProduction WHERE Id = inMovementId);
        END IF;
        /*IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName || ' (ВМС)'  FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM wms_Movement_WeighingProduction WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM wms_Movement_WeighingProduction WHERE Id = inMovementId);
        END IF;*/
    END IF;

     -- Результат
     OPEN Cursor1 FOR

       -- Результат -- для 1-ой строки
       SELECT MovementItem.Id
            , MovementItem.WmsCode AS IdBarCode
       FROM wms_MI_WeighingProduction AS MovementItem 
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.Id         = inId
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
08.07.19          *
*/

-- тест
-- SELECT * FROM gpSelect_wms_Movement_WeighingProduction_PrintSticker (inMovementId := 432692, inId:= 177, inSession:= '5');
