-- Function: gpInsertUpdate_Movement_PromoTrade()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа  
    IN inContractId            Integer    , -- договор  
    IN inPromoItemId           Integer    , -- Статья затрат
    IN inPromoKindId           Integer    , -- Вид акции
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание 
   OUT outPriceListName        TVarChar ,
   OUT outPersonalTradetName   TVarChar ,
   OUT outChangePercent        TFloat   ,
    IN inSession               TVarChar     -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= ioId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

     -- сохранили <Документ>
     ioId := PERFORM lpInsertUpdate_Movement_PromoTrade (ioId             := ioId
                                                       , inInvNumber      := inInvNumber
                                                       , inOperDate       := inOperDate 
                                                       , inContractId     := inContractId
                                                       , inPromoItemId    := inPromoItemId
                                                       , inPromoKindId    := inPromoKindId     --Вид акции
                                                       , inStartPromo     := inStartPromo      --Дата начала акции
                                                       , inEndPromo       := inEndPromo        --Дата окончания акции
                                                       , inCostPromo      := inCostPromo       --Стоимость участия в акции
                                                       , inComment        := inComment         --Примечание
                                                       , inUserId         := vbUserId
                                                       ) AS tmp;  

     outPriceListName      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PriceList() AND MLO.MovementId = ioId);
     outPersonalTradetName := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PersonalTrade() AND MLO.MovementId = ioId);
     outChangePercent      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_ChangePercent() AND MF.MovementId = ioId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/