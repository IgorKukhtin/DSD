-- Function: gpInsertUpdate_Movement_PromoTrade()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ продажи>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inContractId            Integer    , -- договор
 INOUT ioPaidKindId            Integer   , -- Виды форм оплаты
   OUT outPaidKindName         TVarChar   , -- Виды форм оплаты
    IN inPromoItemId           Integer    , -- Статья затрат
    IN inPromoKindId           Integer    , -- Вид акции
    IN inStartPromo            TDateTime  , -- Дата начала акции
    IN inEndPromo              TDateTime  , -- Дата окончания акции
    --IN inCostPromo             TFloat     , -- Стоимость участия в акции
    IN inComment               TVarChar   , -- Примечание
   OUT outPriceListName        TVarChar ,
   OUT outPersonalTradetName   TVarChar ,
   OUT outChangePercent        TFloat   ,
   OUT outCostPromo            TFloat   ,
   OUT outOperDateStart        TDateTime ,
   OUT outOperDateEnd          TDateTime ,
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
     --если ФО не определена берем из договора
     IF COALESCE (ioPaidKindId,0) = 0
     THEN
         ioPaidKindId := 0;/*(SELECT ObjectLink_Contract_PaidKind.ChildObjectId
                          FROM ObjectLink AS ObjectLink_Contract_PaidKind
                          WHERE ObjectLink_Contract_PaidKind.ObjectId = inContractId
                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                          );*/
     END IF;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement_PromoTrade (ioId             := ioId
                                               , inInvNumber      := inInvNumber
                                               , inOperDate       := inOperDate
                                               , inContractId     := inContractId
                                               , inPaidKindId     := ioPaidKindId
                                               , inPromoItemId    := inPromoItemId
                                               , inPromoKindId    := inPromoKindId     --Вид акции
                                               , inStartPromo     := inStartPromo      --Дата начала акции
                                               , inEndPromo       := inEndPromo        --Дата окончания акции
                                               --, inCostPromo      := inCostPromo       --Стоимость участия в акции
                                               , inComment        := inComment         --Примечание
                                               , inUserId         := vbUserId
                                               ) AS tmp;

     outPriceListName      := (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PriceList() AND MLO.MovementId = ioId)     ::TVarChar;
     outPersonalTradetName := (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PersonalTrade() AND MLO.MovementId = ioId) ::TVarChar;
     outChangePercent      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_ChangePercent() AND MF.MovementId = ioId) ::TFloat;
     outCostPromo          := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_CostPromo() AND MF.MovementId = ioId) ::TFloat;

     outOperDateEnd := inOperDate - INTERVAL '1 Day';
     outOperDateStart := outOperDateEnd - INTERVAL '3 Month' + INTERVAL '1 Day';

     outPaidKindName := lfGet_Object_ValueData_sh (ioPaidKindId) ::TVarChar;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/