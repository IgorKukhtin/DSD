-- Function: gpUpdate_Scale_Movement()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement (Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement(
    IN inId                   Integer   , -- Ключ объекта <Документ>
    IN inMovementDescId       Integer   , -- Вид документа
    IN inFromId               Integer   , -- От кого (в документе)
    IN inToId                 Integer   , -- Кому (в документе)
    IN inContractId           Integer   , -- Договор
    IN inPaidKindId           Integer   , -- Форма оплаты
    IN inMovementDescNumber   Integer   , -- Код операции (взвешивание)
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inId)
     THEN
         RAISE EXCEPTION 'Ошибка. В Документе нет товаров.';
     END IF;


     -- Проверка
     IF NOT EXISTS (SELECT 1 FROM gpGet_Movement_WeighingPartner (inMovementId:= inId, inSession:= inSession) AS tmp WHERE tmp.MovementDescId = inMovementDescId)
     THEN
         RAISE EXCEPTION 'Ошибка. Документ не найден <%>', inId;
     END IF;


     -- Изменения - только Склад
     IF inMovementDescId = zc_Movement_Sale()
     THEN
         -- сохранили связь с <От кого (в документе)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);

     ELSEIF inMovementDescId = zc_Movement_ReturnIn()
     THEN
          -- сохранили связь с <Кому (в документе)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);

     ELSEIF inMovementDescId = zc_Movement_Income()
     THEN
          -- сохранили связь с <От кого (в документе)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
          -- сохранили связь с <Договор>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inId, inContractId);
          -- сохранили связь с <Форма оплаты>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), inId, inPaidKindId);

          -- сохранили свойство <Вид документа>
          -- PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
          -- сохранили свойство <Код операции (взвешивание)>
          PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);

     ELSE
         RAISE EXCEPTION 'Ошибка. Нет прав изменять Вид документа <%>', (SELECT MovementDesc.ItemName  FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.08.16                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement (inId:= 0, inAssetId:= 0, inSession:= '2')
