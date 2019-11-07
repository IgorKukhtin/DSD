-- Function: gpInsertUpdate_Movement_Loyalty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loyalty (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Tfloat, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loyalty(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartPromo            TDateTime  , -- Дата начала контракта
    IN inEndPromo              TDateTime  , -- Дата окончания контракта
    IN inStartSale             TDateTime  , -- Дата начала погашения
    IN inEndSale               TDateTime  , -- Дата окончания погашения
    IN inStartSummCash         Tfloat     , -- Вылавать от суммы чека
    IN inMonthCount            Integer    , -- Количество месяцев погашения
    IN inDayCount              Integer    , -- Промокодов в день для аптеки
    IN inSummLimit             Tfloat     , -- Лимит суммы скидки в день для аптеки
    IN inComment               TVarChar   , -- Примечание
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
    ioId := lpInsertUpdate_Movement_Loyalty (ioId            := ioId
                                           , inInvNumber     := inInvNumber
                                           , inOperDate      := inOperDate
                                           , inStartPromo    := inStartPromo
                                           , inEndPromo      := inEndPromo
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inStartSummCash := inStartSummCash  
                                           , inMonthCount    := inMonthCount                                       
                                           , inDayCount      := inDayCount                                       
                                           , inSummLimit     := inSummLimit                                       
                                           , inComment       := inComment
                                           , inUserId        := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Шаблий О.В.
 15.11.19                                                                  *
*/