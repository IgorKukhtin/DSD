-- Function: gpInsertUpdate_Movement_PromoSale()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoSale (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoSale(
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
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoSale());

     -- сохранили <Документ>
     SELECT tmp.ioId
  INTO ioId
     FROM lpInsertUpdate_Movement_PromoSale (ioId             := ioId
                                           , inInvNumber      := inInvNumber
                                           , inOperDate       := inOperDate
                                           , inPriceListId    := inPriceListId     --Прайс лист
                                           , inStartPromo     := inStartPromo      --Дата начала акции
                                           , inEndPromo       := inEndPromo        --Дата окончания акции
                                           , inStartSale      := inStartSale       --Дата начала отгрузки по акционной цене
                                           , inEndSale        := inEndSale         --Дата окончания отгрузки по акционной цене
                                           , inOperDateStart  := inOperDateStart   --Дата начала расч. продаж до акции
                                           , inOperDateEnd    := inOperDateEnd     --Дата окончания расч. продаж до акции
                                           , inIsNotBudgPromo := inIsNotBudgPromo  --Вне бюджета(да/нет)
                                           , inComment        := inComment         --Примечание
                                           , inPersonalTradeId:= inPersonalTradeId --Ответственный представитель коммерческого отдела
                                           , inPersonalId     := inPersonalId      --Ответственный представитель маркетингового отдела   
                                           , inNotBudgPromoId := inNotBudgPromoId  --Классификатор Вне бюджета
                                           , inUserId         := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.07.26         *
*/
