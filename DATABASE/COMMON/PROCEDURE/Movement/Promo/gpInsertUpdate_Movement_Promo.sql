-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);  */
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Promo(
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
    IN inPaidKindId            Integer    , --
    --IN inSignInternalId        Integer    , -- модель подписи
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

    -- проверка
    IF 1=0 AND COALESCE (inisCost,FALSE) = TRUE AND COALESCE (inIsPromo,FALSE) = TRUE
    THEN
        RAISE EXCEPTION 'Ошибка.Параметры <Акция> и <Затраты> не могут быть включены одновременно.';
    END IF; 

    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= ioId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

     -- сохранили <Документ>
     SELECT tmp.ioId, tmp.ioMonthPromo
  INTO ioId, ioMonthPromo
     FROM  lpInsertUpdate_Movement_Promo (ioId             := ioId
                                        , inInvNumber      := inInvNumber
                                        , inOperDate       := inOperDate
                                        , inPromoKindId    := inPromoKindId     --Вид акции
                                        , inPriceListId    := inPriceListId     --Прайс лист
                                        , inStartPromo     := inStartPromo      --Дата начала акции
                                        , inEndPromo       := inEndPromo        --Дата окончания акции
                                        , inStartSale      := inStartSale       --Дата начала отгрузки по акционной цене
                                        , inEndSale        := inEndSale         --Дата окончания отгрузки по акционной цене
                                        , inEndReturn      := inEndReturn       --Дата окончания возвратов по акционной цене
                                        , inOperDateStart  := inOperDateStart   --Дата начала расч. продаж до акции
                                        , inOperDateEnd    := inOperDateEnd     --Дата окончания расч. продаж до акции
                                        , ioMonthPromo     := ioMonthPromo      --месяц акции
                                        , inCheckDate      := inCheckDate       --Дата согласования
                                        , inChecked        := inChecked         --Согласовано
                                        , inIsPromo        := inIsPromo	        --акция          
                                        , inisCost         := inisCost          --Затраты
                                        , inCostPromo      := inCostPromo       --Стоимость участия в акции
                                        , inComment        := inComment         --Примечание
                                        , inCommentMain    := inCommentMain     --Примечание (Общее)
                                        , inUnitId         := inUnitId          --Подразделение
                                        , inPersonalTradeId:= inPersonalTradeId --Ответственный представитель коммерческого отдела
                                        , inPersonalId     := inPersonalId      --Ответственный представитель маркетингового отдела   
                                        , inPaidKindId     := inPaidKindId
                                        --, inSignInternalId := inSignInternalId  -- модель подписи
                                        , inUserId         := vbUserId
                                        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
-- 09.04.20         * inSignInternalId
 01.08.17         * add inCheckDate
 27.07.17         *
 31.10.15                                                                    *
*/
