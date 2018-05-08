-- Function: gpComplete_Movement_Sale()

DROP FUNCTION IF EXISTS gpComplete_Movement_Sale_User (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Sale_User(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Вот они Роли + Пользователи: с проверкой прав = НЕЛЬЗЯ
     IF EXISTS (SELECT 1
                FROM Object_RoleAccessKey_View
                WHERE Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_AccessKey_Check()
                  AND Object_RoleAccessKey_View.UserId      = vbUserId
               )
     THEN
         -- проверка прав пользователя на вызов процедуры - Ругнемся, т.к. права "забрали"
         vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Sale());
     END IF;


     -- !!!Меняем только для Подразделения!!! - Дата док. должна соответствовать Дате Проведения
     UPDATE Movement SET OperDate = CURRENT_DATE WHERE Movement.Id = inMovementId;
     -- сохранили свойство <Дата создания> - по Дате Проведения
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), inMovementId, CURRENT_TIMESTAMP);
     -- сохранили свойство <Пользователь (создание)> - по Пользователю Проведения
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), inMovementId, vbUserId);


     -- создаются временные таблицы - для формирование данных по проводкам
     PERFORM lpComplete_Movement_Sale_CreateTemp();

     -- собственно проводки
     PERFORM lpComplete_Movement_Sale (inMovementId  -- Документ
                                     , vbUserId);    -- Пользователь

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 26.02.18         *
 */

-- тест
-- SELECT * FROM gpComplete_Movement_Sale (inMovementId:= 0, inSession:= zfCalc_UserAdmin())
