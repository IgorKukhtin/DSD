-- Function: gpReComplete_Movement_SalePromoGoods(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_SalePromoGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_SalePromoGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SalePromoGoods());
    vbUserId := inSession;


	-- только если документ проведен
	IF EXISTS(
	            SELECT 1
	            FROM Movement
	            WHERE
	                Id = inMovementId
	                AND
	                StatusId = zc_Enum_Status_Complete()
	         )
	THEN
	    --распроводим документ
	    PERFORM gpUpdate_Status_SalePromoGoods(inMovementId := inMovementId,
	                                      inStatusCode := zc_Enum_StatusCode_UnComplete(),
	                                      inSession    := inSession);
	    --Проводим документ
	    PERFORM gpUpdate_Status_SalePromoGoods(inMovementId := inMovementId,
	                                      inStatusCode := zc_Enum_StatusCode_Complete(),
	                                      inSession    := inSession);
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/
