-- Function: lpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (
Integer    , -- Ключ объекта <Документ продажи>
    TVarChar   , -- Номер документа
    TDateTime  , -- Дата документа
    Integer    , -- Вид акции
    Integer    , -- Прайс лист
    TDateTime  , -- Дата начала акции
    TDateTime  , -- Дата окончания акции
    TDateTime  , -- Дата начала отгрузки по акционной цене
    TDateTime  , -- Дата окончания отгрузки по акционной цене
    TDateTime  , -- Дата начала расч. продаж до акции
    TDateTime  , -- Дата окончания расч. продаж до акции
    TFloat     , -- Стоимость участия в акции
    TVarChar   , -- Примечание
    Integer    , -- Рекламная поддержка
    Integer    , -- Подразделение
    Integer    , -- Ответственный представитель коммерческого отдела
    Integer    , -- Ответственный представитель маркетингового отдела	
    Integer );  -- пользователь
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (
Integer    , -- Ключ объекта <Документ продажи>
    TVarChar   , -- Номер документа
    TDateTime  , -- Дата документа
    Integer    , -- Вид акции
    Integer    , -- Прайс лист
    TDateTime  , -- Дата начала акции
    TDateTime  , -- Дата окончания акции
    TDateTime  , -- Дата начала отгрузки по акционной цене
    TDateTime  , -- Дата окончания отгрузки по акционной цене
    TDateTime  , -- Дата начала расч. продаж до акции
    TDateTime  , -- Дата окончания расч. продаж до акции
    TFloat     , -- Стоимость участия в акции
    TVarChar   , -- Примечание
    TVarChar   , -- Примечание (Общее)
    Integer    , -- Подразделение
    Integer    , -- Ответственный представитель коммерческого отдела
    Integer    , -- Ответственный представитель маркетингового отдела	
    Integer );  -- пользователь
    
CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inPromoKindId           Integer    , -- Вид акции
    IN inPriceListId           Integer    , -- Прайс лист
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    IN inStartSale             TDateTime  , -- Дата начала отгрузки по акционной цене
    IN inEndSale               TDateTime  , -- Дата окончания отгрузки по акционной цене
    IN inOperDateStart         TDateTime  , -- Дата начала расч. продаж до акции
    IN inOperDateEnd           TDateTime  , -- Дата окончания расч. продаж до акции
    IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
    IN inCommentMain           TVarChar   , -- Примечание (Общее)
    IN inUnitId                Integer    , -- Подразделение
    IN inPersonalTradeId       Integer    , -- Ответственный представитель коммерческого отдела
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела
    IN inUserId                Integer      -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты.';
    END IF;
    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <От кого (подразделение)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- Вид акции
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
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
    -- Стоимость участия в акции
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo);
    -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- Примечание (Общее)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentMain(), ioId, inCommentMain);
    -- Подразделение
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- Ответственный представитель коммерческого отдела
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, inPersonalTradeId);
    -- Ответственный представитель маркетингового отдела
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 31.10.15                                                                       *
*/