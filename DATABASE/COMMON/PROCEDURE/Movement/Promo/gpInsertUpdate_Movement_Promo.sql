-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- Ключ объекта <Документ продажи>
    TVarChar   , -- Номер документа
    TDateTime  , -- Дата документа
    Integer    , -- Вид акции
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
    TVarChar     -- сессия пользователя

);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- Ключ объекта <Документ продажи>
    TVarChar   , -- Номер документа
    TDateTime  , -- Дата документа
    Integer    , -- Вид акции
    Integer    , -- Прайс Лист
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
    TVarChar     -- сессия пользователя

);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- Ключ объекта <Документ продажи>
    TVarChar   , -- Номер документа
    TDateTime  , -- Дата документа
    Integer    , -- Вид акции
    Integer    , -- Прайс Лист
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
    TVarChar     -- сессия пользователя

);


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
    IN inOperDateStart         TDateTime  , -- Дата начала расч. продаж до акции
    IN inOperDateEnd           TDateTime  , -- Дата окончания расч. продаж до акции
    IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
    IN inCommentMain           TVarChar   , -- Примечание (Общее)
    IN inUnitId                Integer    , -- Подразделение
    IN inPersonalTradeId       Integer    , -- Ответственный представитель коммерческого отдела
    IN inPersonalId            Integer    , -- Ответственный представитель маркетингового отдела	
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement_Promo (ioId            := ioId
                                        , inInvNumber      := inInvNumber
                                        , inOperDate       := inOperDate
                                        , inPromoKindId    := inPromoKindId     --Вид акции
                                        , inPriceListId    := inPriceListId     --Прайс лист
                                        , inStartPromo     := inStartPromo      --Дата начала акции
                                        , inEndPromo       := inEndPromo        --Дата окончания акции
                                        , inStartSale      := inStartSale       --Дата начала отгрузки по акционной цене
                                        , inEndSale        := inEndSale         --Дата окончания отгрузки по акционной цене
                                        , inOperDateStart  := inOperDateStart   --Дата начала расч. продаж до акции
                                        , inOperDateEnd    := inOperDateEnd     --Дата окончания расч. продаж до акции
                                        , inCostPromo      := inCostPromo       --Стоимость участия в акции
                                        , inComment        := inComment         --Примечание
                                        , inCommentMain    := inCommentMain     --Примечание (Общее)
                                        , inUnitId         := inUnitId          --Подразделение
                                        , inPersonalTradeId:= inPersonalTradeId --Ответственный представитель коммерческого отдела
                                        , inPersonalId     := inPersonalId      --Ответственный представитель маркетингового отдела	
                                        , inUserId         := vbUserId
                                        );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.  Воробкало А.А.
 31.10.15                                                                    *
*/