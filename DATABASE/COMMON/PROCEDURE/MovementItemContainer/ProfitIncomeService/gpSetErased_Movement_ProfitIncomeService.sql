-- Function: gpSetErased_Movement_ProfitIncomeService (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ProfitIncomeService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ProfitIncomeService(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_ProfitIncomeService());

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_ProfitIncomeService (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
