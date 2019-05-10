-- Function: gpInsertUpdate_Movement_OrderInternal()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderInternal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderInternal(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inUnitId              Integer   , -- Подразделения
    IN inOrderKindId         Integer   , -- Подразделения
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0; 

    --Проверить что бы в 1 дне не было 2 неподписаных заказа
    IF EXISTS(  SELECT Movement.Id
                FROM Movement
                    JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                WHERE 
                    Movement.StatusId = zc_Enum_Status_UnComplete() 
                    AND 
                    Movement.DescId = zc_Movement_OrderInternal() 
                    AND 
                    Movement.OperDate = inOperDate 
                    AND 
                    Movement.Id <> COALESCE(ioId,0)
                    AND
                    MovementLinkObject_Unit.ObjectId = inUnitId
             )
    THEN
        RAISE EXCEPTION 'Ошибка. В одном дне <%> может быть только одна неподписанная заявка на подразделение <%>.', inOperDate, (Select ValueData from Object Where Id = inUnitId);
    END IF;
     
    IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('movement_OrderInternal_seq'))::TVarChar;
    END IF;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternal(), inInvNumber, inOperDate, NULL);

    -- сохранили связь с <Подразделения>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);

    -- сохранили связь с Тип заказа>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_OrderKind(), ioId, inOrderKindId);

    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (создание)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.19         *
 09.12.14                         * add InvNumber
 04.12.14                         *
 11.09.14                         *
 03.07.14                                                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_OrderInternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
