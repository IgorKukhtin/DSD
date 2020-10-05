-- Function: gpInsertUpdate_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoyaltyPresent (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoyaltyPresent(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inRetailID              Integer    , -- Торговая сеть
    IN inStartSale             TDateTime  , -- Дата начала погашения
    IN inEndSale               TDateTime  , -- Дата окончания погашения
    IN inMonthCount            Integer    , -- Количество месяцев погашения
    IN inComment               TVarChar   , -- Примечание
    IN inisElectron            Boolean    , -- для Сайта
    IN inSummRepay             Tfloat     , -- Погашать от суммы чека
    IN inAmountPresent         Tfloat     , -- Количество подарка в чек
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
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inMonthCount    := inMonthCount                                       
                                           , inComment       := inComment
                                           , inisElectron    := inisElectron
                                           , inSummRepay     := inSummRepay
                                           , inAmountPresent := inAmountPresent
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