-- Function: gpUpdate_Movement_Check_Update_CommentChecking()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Update_CommentChecking(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Update_CommentChecking(
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inCommentChecking           TVarChar  , -- Примечание для проверяющей
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     AND vbUserId <> 9383066 
  THEN
    RAISE EXCEPTION 'Изменение <Примечание для проверяющей> вам запрещено.';
  END IF;
      
  --Меняем Получено бухгалтерией
  PERFORM lpInsertUpdate_MovementString(zc_MovementString_CommentChecking(), inMovementId, inCommentChecking);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест

select * from gpUpdate_Movement_Check_Update_CommentChecking(inMovementId := 24368435 , inCommentChecking := '645745768' ,  inSession := '3');