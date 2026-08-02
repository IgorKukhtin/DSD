-- Function: gpInsert_Movement_PromoSaleMask()

DROP FUNCTION IF EXISTS gpInsert_Movement_PromoSale_Mask (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PromoSale_Mask(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ >
    IN inOperDate            TDateTime , -- Дата документа
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoSale());

           -- сохранили <Документ>
     vbInvNumber := CAST (NEXTVAL ('Movement_PromoSale_seq') AS TVarChar);
     vbMovementId := lpInsertUpdate_Movement (0, zc_Movement_PromoSale(), vbInvNumber, inOperDate, NULL, 0);

     PERFORM lpInsertUpdate_Movement_PromoSale( ioId             := vbMovementId
                                          , inInvNumber      := vbInvNumber
                                          , inOperDate       := tmp.OperDate
                                          , inPriceListId    := tmp.PriceListId
                                          , inStartPromo     := tmp.StartPromo
                                          , inEndPromo       := tmp.EndPromo
                                          , inStartSale      := tmp.StartSale
                                          , inEndSale        := tmp.EndSale
                                          , inOperDateStart  := tmp.OperDateStart
                                          , inOperDateEnd    := tmp.OperDateEnd
                                          , inIsNotBudgPromo := tmp.IsNotBudgPromo  -- Вне бюджета(да/нет)
                                          , inComment        := '' ::TVarChar
                                          , inPersonalTradeId:= tmp.PersonalTradeId
                                          , inPersonalId     := tmp.PersonalId 
                                          , inPaidKindId     := tmp.PaidKindId 
                                          , inNotBudgPromoId := tmp.NotBudgPromoId  --Классификатор Вне бюджета
                                          , inUserId         := vbUserId
                                           )
     FROM gpGet_Movement_PromoSale (ioId, inOperDate, 'False', inSession) AS tmp;

   -- записываем строки PromoGoods документа
   PERFORM lpInsertUpdate_MovementItem_PromoGoods (ioId                 := 0
                                                 , inMovementId         := vbMovementId
                                                 , inGoodsId            := tmp.GoodsId
                                                 , inAmount             := COALESCE (tmp.Amount, 0)        ::  TFloat
                                                 , inPrice              := COALESCE (tmp.Price, 0)         ::  TFloat
                                                 , inOperPriceList      := COALESCE (tmp.OperPriceList, 0) ::  TFloat
                                                 , inPriceSale          := COALESCE (tmp.PriceSale,0)      ::  TFloat
                                                 , inPriceWithOutVAT    := COALESCE (tmp.PriceWithOutVAT,0)::  TFloat     -- Цена отгрузки без учета НДС, с учетом скидки, грн
                                                 , inPriceWithVAT       := COALESCE (tmp.PriceWithVAT,0)   ::  TFloat     -- Цена отгрузки с учетом НДС, с учетом скидки, грн
                                                 , inPriceTender        := COALESCE (tmp.PriceTender,0)    ::  TFloat     -- Цена Тендер без учета НДС, с учетом скидки, грн
                                                 , inCountForPrice      := COALESCE (tmp.CountForPrice,1)  ::  TFloat     -- относится ко всем ценам
                                                 , inAmountReal         := COALESCE (tmp.AmountReal,0)     ::  TFloat     -- Объем продаж в аналогичный период, кг
                                                 , inAmountPlanMin      := COALESCE (tmp.AmountPlanMin,0)  ::  TFloat     -- Минимум планируемого объема продаж на акционный период (в кг)
                                                 , inAmountPlanMax      := COALESCE (tmp.AmountPlanMax,0)  ::  TFloat     -- Максимум планируемого объема продаж на акционный период (в кг)
                                                 , inTaxRetIn           := COALESCE (tmp.TaxRetIn,0)       ::  TFloat     -- % возврата
                                                 , inGoodsKindId        := COALESCE (tmp.GoodsKindId,0)    ::  Integer    --ИД обьекта <Вид товара>
                                                 , inGoodsKindCompleteId:= COALESCE (tmp.GoodsKindCompleteId,0)::  Integer--ИД обьекта <Вид товара (примечание)>
                                                 , inComment            := ''                              ::  TVarChar   --Комментарий
                                                 , inUserId             := vbUserId
                                                  ) 
   FROM gpSelect_MovementItem_PromoGoods (ioId, 'False', inSession)  AS tmp;

   PERFORM gpInsertUpdate_Movement_PromoSalePartner(ioId              := 0                  ::Integer     -- Ключ объекта <партнер для документа акции>
                                              , inParentId        := vbMovementId       ::Integer     -- Ключ родительского объекта <Документ акции>
                                              , inPartnerId       := tmp.PartnerId      ::Integer     -- Ключ объекта <Контрагент / Юр лицо / Торговая Сеть>
                                              , inContractId      := tmp.ContractId     ::Integer     -- Ключ объекта <Контракт>
                                              , inComment         := ''                 ::TVarChar    -- Примечание
                                              , inRetailName_inf  := tmp.RetailName_inf ::TVarChar    -- торг.сеть доп.
                                              , inSession         := inSession          ::TVarChar    -- сессия пользователя
                                              )
   FROM gpSelect_Movement_PromoSalePartner (ioId, FALSE ,inSession)  AS tmp;

   -- записываем строки PromoPartner документа
   PERFORM lpInsertUpdate_MovementItem_PromoPartner (ioId         := 0
                                                   , inMovementId := tmpPP.Id
                                                   , inPartnerId  := tmp.PartnerId
                                                   , inContractId := tmp.ContractId
                                                   , inUserId     := vbUserId
                                                    ) 
   FROM gpSelect_MovementItem_PromoPartner (ioId, inSession)  AS tmp
        -- связываем с уже записанными строками Movement_PromoSalePartner
        INNER JOIN (SELECT tmp.Id
                    FROM gpSelect_Movement_PromoSalePartner (vbMovementId, FALSE ,inSession) AS tmp limit 1 ) AS tmpPP ON 1=1
        ;

   -- записываем строки документа
   ioid := vbMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  27.07.26        *
*/

-- тест
--