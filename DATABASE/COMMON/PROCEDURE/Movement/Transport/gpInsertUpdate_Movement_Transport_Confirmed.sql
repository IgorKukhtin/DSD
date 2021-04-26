-- Function: gpInsertUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport_Confirmed(
    IN inId           Integer   , -- Ключ объекта <Документ>
    IN inisConfirmed  Boolean   , -- Подтвердить / Отменить
    IN inSession      TVarChar    -- сессия пользователя

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMemberId_user Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());
     -- определяем ключ доступа
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());

     -- Определяется <Физическое лицо> 
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;

     -- определяем - если Автомобиль изменился, надо в конце пересчитать Child - Заправка авто
     IF inisConfirmed = TRUE
     THEN 
       -- сохранили <подтвердить>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inId, CURRENT_TIMESTAMP);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inId, vbMemberId_user); 
     ELSE
       -- сохранили <подтвердить>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inId, Null);
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inId, 0); 
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.04.21         *
*/

-- тест
--