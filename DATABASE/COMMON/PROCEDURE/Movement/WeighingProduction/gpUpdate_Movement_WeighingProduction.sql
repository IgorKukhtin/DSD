-- Function: gpUpdate_Movement_WeighingProduction()

DROP FUNCTION IF EXISTS gpUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_WeighingProduction(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Код операции (взвешивание)
    IN inWeighingNumber      Integer   , -- Номер взвешивания
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inDocumentKindId      Integer   , -- Тип документа
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN InvNumber_Parent      TVarChar  , -- № гл. документа
    IN inIsProductionIn      Boolean   , -- Приход или расход с производства
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber TVarChar;
   DECLARE vbParentId Integer;
   DECLARE vbStartWeighing TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_WeighingProduction());
     --vbUserId:= lpGetUserBySession (inSession);

     -- определяем ключ доступа
     -- vbAccessKeyId:= ...;

     SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = inId;

     IF COALESCE (InvNumber_Parent, '') = '' 
        THEN
            vbParentId:= (SELECT CAST (Null AS Integer)) ;
     END IF;

     -- сохранили <Документ>
     inId := lpInsertUpdate_Movement (inId, zc_Movement_WeighingProduction(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), inId, inIsProductionIn);

     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), inId, inMovementDescId);
     -- сохранили свойство <Код операции (взвешивание)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), inId, inMovementDescNumber);
     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), inId, inWeighingNumber);
 
     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), inId, inPartionGoods);

     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), inId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inId, inToId);
     -- сохранили связь с <Тип документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), inId, inDocumentKindId);


     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.11.16         *
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_WeighingProduction (inId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
