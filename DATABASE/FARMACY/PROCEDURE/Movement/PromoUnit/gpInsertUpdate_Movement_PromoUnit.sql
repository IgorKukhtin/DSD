-- Function: gpInsertUpdate_Movement_PromoUnit()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoUnit (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoUnit(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ Перемещение>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inPersonalId          Integer   , -- Ответственный представитель маркетингового отдела
    IN inUnitCategoryId      Integer   , -- Категория подразделения
    IN inComment             TVarChar  , -- комментарий
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoUnit());
    vbUserId := lpGetUserBySession (inSession);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('movement_PromoUnit_seq'))::TVarChar;
    END IF;
    
    -- дата док всегда первое число 
    inOperDate := date_trunc('month', inOperDate);

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoUnit(), inInvNumber, inOperDate, NULL);

    -- сохранили связь с <Подразделения>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UnitCategory(), ioId, inUnitCategoryId);
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.05.18                                                                     *
 04.02.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_PromoUnit (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
