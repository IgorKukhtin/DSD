-- Function: gpSetErased_Movement_Service (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Service(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Service());

     --
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав удалять "Главный" документ%Найден документ "Корректировка" № <%> от <%>%в статусе <%>.'
                       , CHR (13)
                       , (SELECT Movement.InvNumber || '/' || (COALESCE (MovementFloat_NPP_corr.ValueData, 0) :: Integer) :: TVarChar
                          FROM Movement
                               LEFT JOIN MovementFloat AS MovementFloat_NPP_corr
                                                       ON MovementFloat_NPP_corr.MovementId = Movement.Id
                                                      AND MovementFloat_NPP_corr.DescId     = zc_MovementFloat_NPP_corr()
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId = zc_Enum_Status_Complete()
                          ORDER BY Movement.Id
                          LIMIT 1
                         )
                       , (SELECT zfConvert_DateToString (Movement.OperDate)
                          FROM Movement
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId = zc_Movement_Service() AND Movement.StatusId = zc_Enum_Status_Complete()
                          ORDER BY Movement.Id
                          LIMIT 1
                         )
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (zc_Enum_Status_Complete())
                        ;
     END IF;


     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.12.13                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_Service (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
