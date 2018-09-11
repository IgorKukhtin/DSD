-- Function: gpInsertUpdate_Movement_MarginCategoryUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategoryUnit (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MarginCategoryUnit(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ>
    IN inParentId              Integer    , -- главый документ категоии наценки сауц
    IN inObjectId              Integer    , -- аптека / юр.лицо
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbIsInsert  Boolean;
   DECLARE vbOperdate  Tdatetime;
   DECLARE vbInvnumber Tvarchar;   
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
       
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    SELECT Movement.Operdate
         , Movement.Invnumber
         INTO vbOperdate, vbInvnumber
    FROM Movement
    WHERE Movement.Id = inParentId;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MarginCategoryUnit(), vbInvnumber, vbOperdate, inParentId);
    
    -- сохранили связь с <Поставщик>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Object(), ioId, inObjectId);
    
   
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.09.18         *
*/