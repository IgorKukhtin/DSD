-- Function: gpReComplete_Movement_PromoTrade(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_PromoTrade(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoTrade());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_PromoTrade())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement_PromoTrade (inMovementId := inMovementId
                                                   , inUserId     := vbUserId);
     END IF;

     -- Проводим Документ
     PERFORM lpComplete_Movement_PromoTrade (inMovementId     := inMovementId
                                             , inUserId         := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
*/

-- тест
-- 