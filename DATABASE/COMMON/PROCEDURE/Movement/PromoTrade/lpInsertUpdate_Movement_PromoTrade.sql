-- Function: lpInsertUpdate_Movement_PromoTrade()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inContractId            Integer    , -- договор  
    IN inPaidKindId            Integer    , 
    IN inPromoItemId           Integer    , -- Статья затрат
    IN inPromoKindId           Integer    , -- Вид акции
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    --IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
    IN inUserId                Integer      -- пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert      Boolean;
   DECLARE vbOperDateStart TDateTime;
   DECLARE vbOperDateEnd   TDateTime;
BEGIN
    -- проверка
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION 'Ошибка.Неверный формат даты документа <%>.', inOperDate;
    END IF;

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoTrade(), inInvNumber, inOperDate, NULL, 0);

    --
    IF ioId <=0 -- OR inUserId = 5
    THEN
        RAISE EXCEPTION 'Ошибка.Ключ <%> <= 0. <%> № <%> от <%>.'
                      , ioId
                      , (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_PromoTrade())
                      , inInvNumber
                      , zfConvert_DateToString (inOperDate)
                       ;
    END IF;

    --определяем даты расчпета продаж
    --vbOperDateEnd := inStartPromo - INTERVAL '1 Day';
    --vbOperDateStart := vbOperDateEnd - INTERVAL '3 Month';
    vbOperDateEnd := inOperDate - INTERVAL '1 Day';
    vbOperDateStart := vbOperDateEnd - INTERVAL '3 Month' + INTERVAL '1 Day';

    -- сохранили связь с <договор>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), ioId, (SELECT lfGet.PriceListId
                                                                                         FROM lfGet_Object_Partner_PriceList_onDate (inContractId            := inContractId
                                                                                                                                   , inPartnerId             := NULL
                                                                                                                                   , inMovementDescId        := zc_Movement_Sale()
                                                                                                                                   , inOperDate_order        := inOperDate
                                                                                                                                   , inOperDatePartner       := inOperDate
                                                                                                                                   , inDayPrior_PriceReturn  := NULL
                                                                                                                                   , inIsPrior               := NULL
                                                                                                                                   , inOperDatePartner_order := inOperDate
                                                                                                                                    ) AS lfGet
                                                                                        ))
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalTrade(), ioId, OL_Personal.ChildObjectId)
          , lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ContractConditionKind(), ioId, tmpCC.ContractConditionKindId)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, tmpCC.ChangePercent)
          , lpInsertUpdate_MovementFloat (zc_MovementFloat_DelayDay(), ioId, (COALESCE (tmpCC.DayCalendar,0) + COALESCE (tmpCC.DayBank,0))::TFloat )
    FROM Object AS Object_Contract
         LEFT JOIN (WITH tmpContractCondition_Value_all
                             AS (SELECT *
                                 FROM Object_ContractCondition_ValueView AS View_ContractCondition_Value
                                 WHERE inOperDate BETWEEN View_ContractCondition_Value.StartDate AND View_ContractCondition_Value.EndDate
                                )
                    SELECT tmpContractCondition_Value_all.ContractId
                         , MAX (tmpContractCondition_Value_all.ChangePercent)        :: TFloat AS ChangePercent

                         , MAX (tmpContractCondition_Value_all.DayCalendar) :: TFloat AS DayCalendar
                         , MAX (tmpContractCondition_Value_all.DayBank)     :: TFloat AS DayBank

                         , CASE WHEN 0 <> MAX (tmpContractCondition_Value_all.DayCalendar)
                                    THEN (MAX (zc_Enum_ContractConditionKind_DelayDayCalendar()) :: Integer)
                                WHEN 0 <> MAX (tmpContractCondition_Value_all.DayBank)
                                    THEN MAX(zc_Enum_ContractConditionKind_DelayDayBank()      :: Integer)
                                ELSE 0
                           END :: Integer  AS ContractConditionKindId

                         , MAX (tmpContractCondition_Value_all.StartDate) :: TDateTime AS StartDate
                         , MAX (tmpContractCondition_Value_all.EndDate)   :: TDateTime AS EndDate
                    FROM tmpContractCondition_Value_all
                    GROUP BY tmpContractCondition_Value_all.ContractId
                   ) AS tmpCC
                     ON tmpCC.ContractId = Object_Contract.Id
         -- Ответственный сотрудник
         LEFT JOIN ObjectLink AS OL_Personal
                              ON OL_Personal.ObjectId = Object_Contract.Id
                             AND OL_Personal.DescId   = zc_ObjectLink_Contract_Personal()
    WHERE Object_Contract.Id     = inContractId
      AND Object_Contract.DescId = zc_Object_Contract();

    -- Вид акции
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoKind(), ioId, inPromoKindId);
    -- статья затрат
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoItem(), ioId, inPromoItemId);
    -- ФО
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);
    
    -- Дата начала акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- Дата окончания акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- Дата начала расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, vbOperDateStart);
    -- Дата окончания расч. продаж до акции
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, vbOperDateEnd);

    --Стоимость участия в акции
    --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), ioId, inCostPromo);

     -- Примечание
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- модель подписи
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SignInternal(), ioId, (SELECT DISTINCT tmp.SignInternalId
                                                                                            FROM lpSelect_Object_SignInternalItem ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = ioId AND MLO.DescId = zc_MovementLinkObject_SignInternal())
                                                                                                                                 , (SELECT Movement.DescId FROM Movement WHERE Movement.Id = ioId)
                                                                                                                                 , 0, 0) AS tmp
                                                                                           )
                                              );

     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <Дата создания> - при загрузке с моб устр., здесь дата загрузки
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили связь с <Пользователь>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovemenTFloat_TotalSumm (ioId);

    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/