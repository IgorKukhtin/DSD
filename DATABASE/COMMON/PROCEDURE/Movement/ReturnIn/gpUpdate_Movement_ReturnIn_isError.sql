-- Function: gpUpdate_Movement_ReturnIn_isError()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_isError (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_isError(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outMessageText      Text                  , --
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS Text
AS
$BODY$
  DECLARE vbUserId        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnIn());


     IF zc_Movement_ReturnIn() <> (SELECT DescId FROM Movement WHERE Id = inMovementId)
     THEN
         RAISE EXCEPTION ' zc_Movement_ReturnIn() <> (SELECT DescId FROM Movement WHERE Id = <%>) ', inMovementId;
     END IF;



     IF zc_Enum_PaidKind_SecondForm() = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_PaidKind())
     THEN
         -- автоматом сформировалась строчная часть - zc_MI_Child
         outMessageText:= lpUpdate_Movement_ReturnIn_Auto (inStartDateSale := DATE_TRUNC ('MONTH', (SELECT OperDate FROM Movement WHERE Id = inMovementId)) - INTERVAL '6 MONTH'
                                                         , inEndDateSale   := NULL
                                                         , inMovementId    := inMovementId
                                                         , inUserId        := zc_Enum_Process_Auto_ReturnIn()
                                                          );

         -- автоматом 
         DROP TABLE _tmpItem;
         -- автоматом 
         PERFORM gpReComplete_Movement_ReturnIn (inMovementId, NULL, FALSE, zc_Enum_Process_Auto_ReturnIn() :: TVarChar);

     ELSE
         -- !!!вернули ОШИБКУ, если есть!!!
         outMessageText:= lpCheck_Movement_ReturnIn_Auto (inMovementId    := inMovementId
                                                        , inUserId        := zc_Enum_Process_Auto_ReturnIn()
                                                         );
         -- пересчитали Итоговые суммы по накладной
         PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (inMovementId);
     END IF;


     -- сохранили свойство <Ошибка>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Error(), inMovementId, CASE WHEN outMessageText <> '' THEN TRUE ELSE FALSE END);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, zc_Enum_Process_Auto_ReturnIn(), FALSE);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.09.16                                        *
*/

-- тест
-- SELECT gpUpdate_Movement_ReturnIn_isError (inMovementId:= Movement.Id, inUserId:= zfCalc_UserAdmin() :: Integer), Movement.* FROM Movement WHERE Movement.Id = 1
