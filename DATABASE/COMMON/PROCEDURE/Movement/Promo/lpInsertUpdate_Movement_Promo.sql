-- Function: lpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer);

/*DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer); */

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);

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
    IN inEndReturn             TDateTime  , -- Дата окончания возвратов по акционной цене
    IN inOperDateStart         TDateTime  , -- Дата начала расч. продаж до акции
    IN inOperDateEnd           TDateTime  , -- Дата окончания расч. продаж до акции
 INOUT ioMonthPromo            TDateTime  , -- Месяц акции
    IN inCheckDate             TDateTime  , -- Дата согласования
    IN inChecked               Boolean    , -- Согласовано
    IN inIsPromo               Boolean    , -- Акция   
    IN inisCost                Boolean    , -- Затраты
    IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
    IN inCommentMain           TVarChar   , -- Примечание (Общее)
    IN inUnitId                Integer    , -- Подразделение
    IN inPersonalTradeId       Integer    , -- Ответственный представитель коммерческого отдела
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела 
    IN inPaidKindId            Integer    , 
--    IN inSignInternalId        Integer    , 
    IN inUserId                Integer      -- пользователь
)
RETURNS RECORD AS
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
    -- проверка
    IF inEndReturn <> DATE_TRUNC ('DAY', inEndReturn)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат окончания возвратов по акционной цене <%>.', inEndReturn;
    END IF;
    -- проверка
    IF COALESCE (inEndReturn, zc_DateStart()) < COALESCE (inEndSale, zc_DateEnd())
    THEN
        RAISE EXCEPTION 'Ошибка.Дата окончания возвратов по акционной цене <%> НЕ может быть раньше чем Дата окончания отгрузки по акционной цене <%>.', DATE (inEndReturn), DATE (inEndSale);
    END IF;

    
    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), inInvNumber, inOperDate, NULL, 0);
   
    -- 
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION 'Ошибка.Ключ <%> <= 0. <%> № <%> от <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Promo())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;
 
    -- сохранили связь с <От кого (подразделение)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- Вид акции
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- Прайс лист
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, inPriceListId);
    -- ФО
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

    -- Дата начала акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- Дата окончания акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    -- Дата начала отгрузки по акционной цене
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- Дата окончания отгрузки по акционной цене
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);
    -- Дата окончания возвратов по акционной цене
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndReturn(), ioId, inEndReturn);
    -- Дата начала расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- Дата окончания расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
    
    --если Акция = TRUE определяем месяц
    IF inIsPromo = TRUE
    THEN
      -- было ... месяц акции определяем в зависимости от zc_MovementDate_EndSale (если дата 10,11, и до конца мес, тогда это тек. месяц, если с 1 по 9, тогда брать пред месяц) --06.07.2020
      ioMonthPromo:=(CASE WHEN inEndSale >= '01.06.2022' THEN DATE_TRUNC ('MONTH', inEndSale) WHEN EXTRACT (DAY FROM inEndSale) BETWEEN 1 AND 9 THEN DATE_TRUNC ('MONTH', (inEndSale - INTERVAL '1 Month') ) ELSE DATE_TRUNC ('MONTH', inEndSale) END) :: TDateTime;
    END IF;
    
    -- месяц акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Month(), ioId, ioMonthPromo);
    
    -- дату согласования сохраняем только когда  inChecked = TRUE
    IF inChecked = TRUE
    THEN
        -- дата согласования 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), ioId, inCheckDate);
    ELSE 
        -- дата согласования 
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Check(), ioId, NULL);
    END IF;
    
    -- сохранили свойство <Согласовано>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), ioId, inChecked);
    -- сохранили свойство <Акция>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo(), ioId, inIsPromo);
    -- сохранили свойство <Затраты>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Cost(), ioId, inIsCost);
         
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
    -- модель подписи
    --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), ioId, inSignInternalId);
        
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 06.07.20         *
 01.08.17         *
 25.07.17         *
 31.10.15                                                                       *
*/