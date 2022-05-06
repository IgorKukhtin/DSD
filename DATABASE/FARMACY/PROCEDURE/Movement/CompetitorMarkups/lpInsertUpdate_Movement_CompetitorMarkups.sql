-- Function: lpInsertUpdate_Movement_CompetitorMarkups()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_CompetitorMarkups (Integer, TVarChar, TDateTime, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_CompetitorMarkups(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inUserId                Integer      -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    inOperDate:= DATE_TRUNC ('DAY', inOperDate);
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_CompetitorMarkups(), inInvNumber, inOperDate, NULL, 0);
        
    
    -- !!!протокол через свойства конкретного объекта!!!
     IF vbIsInsert = FALSE
     THEN
         -- сохранили свойство <Дата корректировки>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <Пользователь (корректировка)>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     ELSE
         IF vbIsInsert = TRUE
         THEN
             -- сохранили свойство <Дата создания>
             PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
             -- сохранили свойство <Пользователь (создание)>
             PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
         END IF;
         
         IF NOT EXISTS(SELECT MovementItem.Id
                       FROM MovementItem
                       WHERE MovementItem.MovementId = ioId
                         AND MovementItem.DescId = zc_MI_Second()
                         AND MovementItem.isErased = False)
         THEN
           PERFORM gpInsertUpdate_MovementItem_PriceSubgroups(ioId := 0, inMovementId := ioId, inPrice := MovementItem.Amount,  inSession := inUserId::TVarChar)
           FROM MovementItem
           WHERE MovementItem.MovementId = (SELECT MAX(Movement.Id)
                                            FROM Movement
                                            WHERE Movement.Id <> ioId
                                              AND Movement.StatusId <> zc_Enum_Status_Erased() 
                                              AND Movement.DescId = zc_Movement_CompetitorMarkups())
             AND MovementItem.DescId = zc_MI_Second()
             AND MovementItem.isErased = False;
         END IF;
     END IF;
     
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.22                                                        *
*/
--
