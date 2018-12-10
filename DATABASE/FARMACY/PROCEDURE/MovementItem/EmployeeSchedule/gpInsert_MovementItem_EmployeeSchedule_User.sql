-- Function: gpInsert_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeSchedule_User(INTEGER, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeSchedule_User(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inUserId              Integer   , -- Сотрудник
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbComingValueDay TVarChar;

   DECLARE vbValue INTEGER;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка прав пользователя на вызов процедуры
    IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;

    vbId := 0;

    -- сохранили
    PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := 0                 -- Ключ объекта <Элемент документа>
                                                        , inMovementId          := inMovementId      -- ключ Документа
                                                        , inUserId              := inUserId          -- сотрудник
                                                        , ioValue               := ''::TVarChar      -- Приходы на работу по дням
                                                        , ioTypeId              := 0                 -- Приходы на работу по дням
                                                        , inSession             := inSession         -- пользователь
                                                         );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
10.12.18                                                        *

*/
