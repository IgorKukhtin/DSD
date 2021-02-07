-- Function: gpInsertUpdate_Movement_WeighingProduction()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_WeighingProduction (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_WeighingProduction(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inOperDate            TDateTime , -- Дата документа
    IN inMovementDescId      Integer   , -- Вид документа
    IN inMovementDescNumber  Integer   , -- Код операции (взвешивание)
    IN inWeighingNumber      Integer   , -- Номер взвешивания
    IN inFromId              Integer   , -- От кого (в документе)
    IN inToId                Integer   , -- Кому (в документе)
    IN inDocumentKindId      Integer   , -- Тип документа
    IN inSubjectDocId        Integer   , --
    IN inPersonalGroupId     Integer   , --
    IN inMovementId_Order    Integer   , -- ключ Документа заявка
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inIsProductionIn      Boolean   , --
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_WeighingProduction());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяем ключ доступа
     -- vbAccessKeyId:= ...;

     IF COALESCE (ioId, 0) = 0
     THEN
         vbInvNumber:= CAST (NEXTVAL ('Movement_WeighingProduction_seq') AS TVarChar);
         vbParentId:= NULL;
         vbStartWeighing:= CURRENT_TIMESTAMP;
     ELSE
         SELECT InvNumber, ParentId INTO vbInvNumber, vbParentId FROM Movement WHERE Id = ioId;
     END IF;


     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_WeighingProduction(), vbInvNumber, inOperDate, vbParentId, vbAccessKeyId);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Протокол начало взвешивания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartWeighing(), ioId, vbStartWeighing);
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isIncome(), ioId, inIsProductionIn);

     -- сохранили свойство <Вид документа>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDesc(), ioId, inMovementDescId);
     -- сохранили свойство <Код операции (взвешивание)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementDescNumber(), ioId, inMovementDescNumber);
     -- сохранили свойство <Номер взвешивания>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_WeighingNumber(), ioId, inWeighingNumber);

     -- сохранили свойство <Партия товара>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_PartionGoods(), ioId, inPartionGoods);
     -- сохранили свойство <Comment>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);


     -- сохранили связь с <От кого (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- сохранили связь с <Тип документа>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentKind(), ioId, inDocumentKindId);

     -- сохранили связь с <Основание для перемещения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

     -- сохранили связь с <Основание для перемещения>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), ioId, inPersonalGroupId);

     -- сохранили связь с документом <Заявки сторонние>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Order(), ioId, inMovementId_Order);

     -- !!!только при создании!!!
     IF vbIsInsert = TRUE
     THEN
       -- сохранили связь с <Пользователь>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_User(), ioId, vbUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.06.15                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_WeighingProduction (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', , inSession:= '2')
