-- Function: gpInsertUpdate_Movement_Cost()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Cost (Integer, TVarChar, TDateTime, Integer, Tfloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Cost(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inParentId            Integer   , -- От кого (в документе)
    IN inMovementId          Tfloat    , -- 
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDescId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Income());

     vbDescId := (SELECT CASE WHEN Movement.DescId = zc_Movement_Service() THEN zc_Movement_CostService() 
                              WHEN Movement.DescId = zc_Movement_Transport() THEN zc_Movement_CostTransport()
                         END 
                  FROM Movement WHERE Movement.Id = inMovementId);
   
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, vbDescId, inInvNumber, inOperDate, inParentId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, inMovementId);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
   
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.04.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_Cost (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inParentId:= 0, inMovementId:= 0, inComment:= 'xfdf', inSession:= '2')
