-- Function: gpInsertUpdate_Movement_ReestrIncome()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrIncome (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrIncome(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrIncome());
                                              

     -- только в этом случае - ничего не делаем, т.к. из дельфи вызывается "лишний" раз
     IF ioId                           = 0
        AND TRIM (inInvNumber)         = ''
     THEN
         RETURN; -- !!!выход!!!
     END IF;


     -- Проверка
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохранен черезе Ш/К <Путевой лист>.';
     END IF;


     -- Проверка - кроме админа ? - не меняются основные параметры
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrIncome())
        AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId IN (zc_Enum_Role_Admin()) AND UserId = vbUserId)
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять дату документа <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- сохранили <Документ>,
     ioId:= lpInsertUpdate_Movement_ReestrIncome (ioId               := ioId
                                                , inInvNumber        := inInvNumber
                                                , inOperDate         := inOperDate
                                                , inUserId           := vbUserId
                                                );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.12.20         *
 20.10.16         *
*/

-- тест
--