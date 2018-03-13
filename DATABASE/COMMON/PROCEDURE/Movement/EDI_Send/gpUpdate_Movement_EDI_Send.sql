-- Function: gpUpdate_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_Send (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_Send(
    IN inId                    Integer    , -- Ключ объекта <Документ для отправки в EDI>
    IN inComment               TVarChar   , --
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF COALESCE (inId, 0) = 0 THEN
         RAISE EXCEPTION 'Ошибка.Неверно значение inId  = <%>.', inId;
     END IF;



     IF inComment <> ''
     THEN
         -- вернули статус, Не проведен - значит Не отправлен
         UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inId AND StatusId <> zc_Enum_Status_UnComplete();

         -- сохранили свойство
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);
         

     ELSE
         -- установили статус, Проведен - значит отправлен
         UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inId;

         -- сохранили свойство <Дата/Время когда отправили>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), inId, CURRENT_TIMESTAMP);

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.02.18                                        *

*/
-- тест
-- SELECT * FROM gpUpdate_Movement_EDI_Send (inId:= 0, inComment:= '-1', inSession:= '2')
