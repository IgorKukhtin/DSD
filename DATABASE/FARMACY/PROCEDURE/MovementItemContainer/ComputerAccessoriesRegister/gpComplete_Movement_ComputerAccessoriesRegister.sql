-- Function: gpComplete_Movement_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpComplete_Movement_ComputerAccessoriesRegister  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ComputerAccessoriesRegister(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION 'Разрешено только системному администратору';
    END IF;
           
    -- проверка
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. Нет данных для проведения.';
    END IF;

         
    -- Провели документ
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ComputerAccessoriesRegister()
                               , inUserId     := vbUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
 */

-- тест
-- select * from gpUpdate_Status_ComputerAccessoriesRegister(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

