-- Function: gpInsertUpdate_Movement_Reestr()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Reestr (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Reestr(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inCarId                Integer   , -- Автомобиль
    IN inPersonalDriverId     Integer   , -- Сотрудник (водитель)
    IN inMemberId             Integer   , -- Физические лица(экспедитор)
    IN inMovementId_Transport Integer   , -- Путевой лист/Начисления наемный транспорт
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
                                              

     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF ioId                           = 0
        AND inCarId                    = 0
        AND inPersonalDriverId         = 0
        AND inMemberId                 = 0
        AND inMovementId_Transport     = 0
        AND TRIM (inInvNumber)         = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;


     -- Проверка
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен черезе Ш/К <Путевой лист>.';
     END IF;


     -- Проверка - кроме админа ?
     IF COALESCE (inMovementId_Transport, 0) = 0 AND (COALESCE (inCarId ,0) = 0 OR COALESCE (inPersonalDriverId, 0) = 0)
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         IF COALESCE (inMovementId_Transport, 0) = 0 AND COALESCE (inCarId ,0) = 0 AND COALESCE (inPersonalDriverId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не определен документ <Путевой лист>.';
         ELSEIF COALESCE (inCarId ,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не определен <№ автомобиля>.';
         ELSEIF COALESCE (inPersonalDriverId, 0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.Не определено <ФИО> водителя.';
         END IF;
     END IF;


     -- Проверка - кроме админа ? - не меняются основные параметры
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_Reestr())
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять дату документа <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- Проверка - кроме админа ? - не меняется Путевой лист
     IF NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = ioId AND MLM.DescId = zc_MovementLinkMovement_Transport() AND COALESCE (MLM.MovementChildId, 0) = COALESCE (inMovementId_Transport, 0))
     THEN
         -- RAISE EXCEPTION 'Ошибка.Нет прав менять <Путевой лист>.';
         PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Reestr_Transport());   
     END IF;


     -- Проверка - кроме админа ? - не меняется Автомобиль или Сотрудник (водитель) если установлен Путевой лист
     IF inMovementId_Transport > 0
        AND (NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_Car()            AND COALESCE (MLO.ObjectId, 0) = COALESCE (inCarId, 0))
          OR NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_PersonalDriver() AND COALESCE (MLO.ObjectId, 0) = COALESCE (inPersonalDriverId, 0))
            )
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         -- RAISE EXCEPTION 'Ошибка.Нет прав менять <Автомобиль> или <Сотрудник (водитель)>.';
         PERFORM lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Reestr_Transport());   
     END IF;


     -- только в этом случае - ничего не делаем
     /*IF ioId = 0
        AND inCarId  = 0
        AND inPersonalDriverId = 0
        AND inMemberId          = 0
        AND inMovementId_Transport  = 0
     THEN
         RETURN; -- !!!выход!!!
     END IF;*/


     -- сохранили <Документ>, т.е. изменился ТОЛЬКО <Экспедитор> или Автомобиль или Сотрудник (водитель) но ТОЛЬУО для пустого Путевой лист
     ioId:= lpInsertUpdate_Movement_Reestr (ioId               := ioId
                                          , inInvNumber        := inInvNumber
                                          , inOperDate         := inOperDate
                                          , inCarId            := inCarId
                                          , inPersonalDriverId := inPersonalDriverId
                                          , inMemberId         := inMemberId
                                          , inMovementId_Transport := inMovementId_Transport
                                          , inUserId           := vbUserId
                                          );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 20.10.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Reestr (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePercent:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
