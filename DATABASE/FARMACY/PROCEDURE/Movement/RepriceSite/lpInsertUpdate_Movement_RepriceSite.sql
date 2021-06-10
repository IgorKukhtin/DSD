-- Function: lpInsertUpdate_Movement_RepriceSite()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_RepriceSite (Integer, TVarChar, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_RepriceSite(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inGUID                  TVarChar   , -- GUID для определения текущей переоценки
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_RepriceSite(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили <GUID>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inGUID);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

   -- !!!протокол через свойства конкретного объекта!!!
   IF vbIsInsert=True 
   THEN
       -- сохранили свойство <Дата создания>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (создание)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
10.06.21                                                       *  
*/