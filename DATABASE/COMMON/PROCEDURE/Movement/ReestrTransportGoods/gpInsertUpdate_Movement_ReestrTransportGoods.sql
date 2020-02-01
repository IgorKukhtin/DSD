-- Function: gpInsertUpdate_Movement_ReestrTransportGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReestrTransportGoods (Integer, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReestrTransportGoods(
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReestrTransportGoods());
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

     -- Проверка - кроме админа ? - не меняются основные параметры
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = ioId AND Movement.InvNumber = inInvNumber AND Movement.OperDate = inOperDate AND  Movement.DescId = zc_Movement_ReestrTransportGoods())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять дату документа <%> <%> <%>.', zfConvert_DateToString (inOperDate), inInvNumber, ioId;
     END IF;

     -- сохранили <Документ>,
     ioId:= lpInsertUpdate_Movement_ReestrTransportGoods (ioId               := ioId
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
 31.01.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ReestrTransportGoods (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inSession:= '2')
