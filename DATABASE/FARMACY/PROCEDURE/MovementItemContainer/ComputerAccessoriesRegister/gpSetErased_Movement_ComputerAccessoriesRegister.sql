-- Function: gpSetErased_Movement_ComputerAccessoriesRegister (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_ComputerAccessoriesRegister (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_ComputerAccessoriesRegister(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;

    -- Удаляем Документ
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_ComputerAccessoriesRegister (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
