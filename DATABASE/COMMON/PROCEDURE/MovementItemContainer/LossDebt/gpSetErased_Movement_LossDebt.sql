-- Function: gpSetErased_Movement_LossDebt (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_LossDebt (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_LossDebt(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_LossDebt());

     IF inMovementId = 123096 -- № 15 от 31.12.2013
     OR inMovementId = 19270690 -- № 259 от 28.02.2021
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не может быть удален.';
     END IF;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.14         *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_LossDebt (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
