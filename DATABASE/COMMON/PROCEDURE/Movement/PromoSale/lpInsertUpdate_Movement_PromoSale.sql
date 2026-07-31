-- Function: lpInsertUpdate_Movement_PromoSale()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoSale (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, TVarChar, Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoSale(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inPriceListId           Integer    , -- Прайс лист
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    IN inStartSale             TDateTime  , -- Дата начала отгрузки по акционной цене
    IN inEndSale               TDateTime  , -- Дата окончания отгрузки по акционной цене
    IN inOperDateStart         TDateTime  , -- Дата начала расч. продаж до акции
    IN inOperDateEnd           TDateTime  , -- Дата окончания расч. продаж до акции
    IN inIsNotBudgPromo        Boolean    , -- Вне бюджета(да/нет)
    IN inComment               TVarChar   , -- Примечание
    IN inPersonalTradeId       Integer    , -- Ответственный представитель коммерческого отдела
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела 
    IN inNotBudgPromoId        Integer    , -- Классификатор Вне бюджета
    IN inUserId                Integer      -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты документа <%>.', inOperDate;
    END IF;
    -- проверка
    IF inStartSale <> DATE_TRUNC ('DAY', inStartSale)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат начала отгрузки по акционной цене <%>.', inStartSale;
    END IF;
    -- проверка
    IF inEndSale <> DATE_TRUNC ('DAY', inEndSale)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат окончания отгрузки по акционной цене <%>.', inEndSale;
    END IF;
       
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoSale(), inInvNumber, inOperDate, NULL, 0);
   
    -- 
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION 'Ошибка.Ключ <%> <= 0. <%> № <%> от <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_PromoSale())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;
 
    -- Прайс лист
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);

    -- Дата начала акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- Дата окончания акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    -- Дата начала отгрузки по акционной цене
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- Дата окончания отгрузки по акционной цене
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);
    -- Дата начала расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- Дата окончания расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
    
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotBudgPromo(), ioId, inIsNotBudgPromo);
         
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- Ответственный представитель коммерческого отдела
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, inPersonalTradeId);
    -- Ответственный представитель маркетингового отдела
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
    -- сохранили свойство <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_NotBudgPromo(), ioId, inNotBudgPromoId); 

    IF vbIsInsert = TRUE
    THEN
        -- сохранили свойство <Дата создания> - при загрузке с моб устр., здесь дата загрузки
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
        -- сохранили связь с <Пользователь>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    END IF;

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.26         *
*/