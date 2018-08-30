-- Function: gpInsertUpdate_Movement_MarginCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MarginCategory(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartSale             TDateTime  , -- Дата начала отгрузки по акционной цене
    IN inEndSale               TDateTime  , -- Дата окончания отгрузки по акционной цене
    IN inOperDateStart         TDateTime  , -- Дата начала расч. продаж до акции
    IN inOperDateEnd           TDateTime  , -- Дата окончания расч. продаж до акции
    IN inComment               TVarChar   , -- Примечание
    IN inAmount                TFloat     , --
    IN inChangePercent         TFloat     , --
    IN inDayCount              TFloat     , --
    IN inPriceMin              TFloat,     --
    IN inPriceMax              TFloat,     --
    IN inUnitId                Integer    , -- Подразделение
   OUT outMessageText          Text       , -- вернули, если есть ошибка
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbPeriodCount  Integer;
   DECLARE vbOperDateStart TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- проверка
    IF COALESCE (inDayCount, 0) = 0 
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбрано кол-во дней периода для анализа.';
    END IF;

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MarginCategory(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- Дата начала
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- Дата окончания
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);
    -- Дата начала
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- Дата окончания
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
 
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceMin(), ioId, inPriceMin);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceMax(), ioId, inPriceMax);
           
    -- 
    IF vbIsInsert = TRUE
    THEN
       -- сохранили свойство <Дата создания>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (создание)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
    ELSE
       -- сохранили свойство <Дата корректировки>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (создание)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
    END IF;
    
  
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);
    
    -- проверка даты начала периода для анализа
    vbPeriodCount := (CEIL( (date_part('DAY', inEndSale - inStartSale) / inDayCount) ::TFloat)) :: Integer;
    --должно быть мин. 2 периода для анализа
    IF vbPeriodCount < 2 THEN vbPeriodCount := 2; END IF;
    vbOperDateStart := (inEndSale - ('' ||(vbPeriodCount * inDayCount)-1 || 'DAY ')  :: interval ) TDateTime;

    IF vbOperDateStart <> inStartSale
    THEN
        outMessageText:= 'Ошибка.Кол-во дней периода не кратно периоду для анализа.Рекомендуемая нач.дата '|| vbOperDateStart || ;
    END IF; 
    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 19.11.17         *
*/