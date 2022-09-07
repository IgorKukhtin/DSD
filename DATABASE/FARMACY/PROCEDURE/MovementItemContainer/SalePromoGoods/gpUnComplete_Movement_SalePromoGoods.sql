-- Function: gpUnComplete_Movement_SalePromoGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_SalePromoGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_SalePromoGoods(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_SalePromoGoods());
    vbUserId:= lpGetUserBySession (inSession);

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.09.22                                                       *
*/