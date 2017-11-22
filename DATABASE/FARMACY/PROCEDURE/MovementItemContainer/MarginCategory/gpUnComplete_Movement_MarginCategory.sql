-- Function: gpUnComplete_Movement_MarginCategory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_MarginCategory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := inSession; 

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.11.17         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_MarginCategory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
