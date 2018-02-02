-- Function: gpInsertUpdate_Movement_ReestrReturn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrReturn (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrReturn(
 INOUT ioId                   Integer   , -- Ключ объекта <Документ>
    IN inInvNumber            TVarChar  , -- Номер документа
    IN inOperDate             TDateTime , -- Дата документа
    IN inSession              TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrReturn());
   --  vbUserId:= lpGetUserBySession (inSession);                                              

     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF ioId = 0 AND TRIM (inInvNumber) = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;

     -- Проверка
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен.';
     END IF;

/*
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
*/

     -- Проверка - кроме админа ? - не меняются основные параметры
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrReturn())
        -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять дату документа <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- Проверка - кроме админа ? - не меняется Путевой лист
 /*    IF NOT EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = ioId AND MLM.DescId = zc_MovementLinkMovement_Transport() AND COALESCE (MLM.MovementChildId, 0) = COALESCE (inMovementId_Transport, 0))
       -- AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять <Путевой лист>.';
     END IF;*/

     -- сохранили <Документ>,
     ioId:= lpInsertUpdate_Movement_ReestrReturn (ioId               := ioId
                                                , inInvNumber        := inInvNumber
                                                , inOperDate         := inOperDate
                                                , inUserId           := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReestrReturn (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
