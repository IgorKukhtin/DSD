-- Function: gpInsertUpdate_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoyaltyPresent (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoyaltyPresent(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inStartSale             TDateTime  , -- Дата начала погашения
    IN inEndSale               TDateTime  , -- Дата окончания погашения
    IN inStartSummCash         TFloat     , -- Вылавать от суммы чека
    IN inMonthCount            Integer    , -- Количество месяцев погашения
    IN inDayCount              Integer    , -- Промокодов в день для аптеки
    IN inSummLimit             TFloat     , -- Лимит суммы скидки в день для аптеки
    IN inComment               TVarChar   , -- Примечание
    IN inChangePercent         TFloat     , -- Процент от реализации для выдачи скидки
    IN inisBeginning           Boolean    , -- Генерация скидак с начало акции
    IN inisElectron            Boolean    , -- для Сайта
    IN inSummRepay             Tfloat     , -- Погашать от суммы чека
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_LoyaltyPresent (ioId            := ioId
                                           , inInvNumber     := inInvNumber
                                           , inOperDate      := inOperDate
                                           , inRetailID      := inRetailID
                                           , inStartPromo    := inStartPromo
                                           , inEndPromo      := inEndPromo
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inStartSummCash := inStartSummCash  
                                           , inMonthCount    := inMonthCount                                       
                                           , inDayCount      := inDayCount                                       
                                           , inSummLimit     := inSummLimit                                       
                                           , inComment       := inComment
                                           , inChangePercent := inChangePercent
                                           , inisBeginning   := inisBeginning
                                           , inisElectron    := inisElectron
                                           , inSummRepay     := inSummRepay
                                           , inUserId        := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Шаблий О.В.
 28.09.20                                                       *
*/