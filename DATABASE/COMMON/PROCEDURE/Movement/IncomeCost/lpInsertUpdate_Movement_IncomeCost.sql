-- Function: lpInsertUpdate_Movement_IncomeCost()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_IncomeCost (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_IncomeCost(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- док приход
    IN inMovementId          Integer   , -- док услуг
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbDescId   Integer;
BEGIN

     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     vbDescId := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);

     -- сохранили <Документ>
     IF COALESCE (ioId, 0) = 0
     THEN
         -- создается новый
         ioId := lpInsertUpdate_Movement (ioId
                                        , zc_Movement_IncomeCost()
                                        , CAST (NEXTVAL ('Movement_IncomeCost_seq') AS TVarChar)
                                        , (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inParentId)
                                        , inParentId
                                         );

     ELSE
         -- обновляем существующий
         ioId := lpInsertUpdate_Movement (ioId
                                        , zc_Movement_IncomeCost()
                                        , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId)
                                        , CURRENT_DATE
                                        , inParentId
                                         );
     END IF;

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementId(), ioId, inMovementId);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- сохраняем для нач. услуг приход в список док. затрат
     IF vbDescId = zc_Movement_Service()
     THEN
         PERFORM lpInsertUpdate_MovementString (zc_MovementString_MovementId(), inMovementId, CASE WHEN COALESCE (MovementString.ValueData,'') = ''  THEN inParentId :: TVarChar ELSE MovementString.ValueData|| ','||inParentId END :: TVarChar) 
         FROM Movement
              LEFT JOIN MovementString ON MovementString.MovementId = Movement.Id
                                      AND MovementString.DescId = zc_MovementString_MovementId()              
         WHERE Movement.Id = inMovementId;
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 29.04.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_Movement_IncomeCost (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inParentId:= 0, inMovementId:= 0, inComment:= 'xfdf', inSession:= '2')
