-- Function: gpInsert_Movement_Sale_byReturnIn()

DROP FUNCTION IF EXISTS gpInsert_Movement_Sale_byReturnIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Sale_byReturnIn(
    IN inMovementId_ReturnIn       Integer  ,  -- ключ Документа возврат
   OUT outMovementId               Integer  ,
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- проверка может ли смотреть любой магазин, или только свой
     --PERFORM lpCheckUnit_byUser (inUnitId_by:= inFromId, inUserId:= vbUserId);


     -- определяется уникальный № док.
     vbInvNumber:= CAST (NEXTVAL ('Movement_Sale_seq') AS TVarChar);

     -- сохранили <Документ>
     outMovementId := lpInsertUpdate_Movement_Sale (ioId                := 0
                                                  , inInvNumber         := vbInvNumber
                                                  , inOperDate          := CURRENT_DATE
                                                  , inFromId            := MovementLinkObject_To.ObjectId
                                                  , inToId              := MovementLinkObject_From.ObjectId
                                                  , inComment           := ''    ::TVarChar
                                                  , inisOffer           := FALSE ::Boolean
                                                  , inUserId            := vbUserId
                                                   )
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                      ON MovementLinkObject_To.MovementId = Movement.Id
                                     AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

     WHERE Movement.Id = inMovementId_ReturnIn
       AND Movement.DescId = zc_Movement_ReturnIn();
     
     
     -- строки док.
     PERFORM gpInsertUpdate_MovementItem_SalePodium(ioId                 := 0               :: Integer  -- Ключ объекта <Элемент документа>
                                                  , inMovementId         := outMovementId   :: Integer  -- Ключ объекта <Документ>
                                                  , ioGoodsId            := MI_Master.ObjectId  :: Integer  -- *** - Товар
                                                  , inPartionId          := MI_Master.PartionId :: Integer  -- Партия
                                                  , ioDiscountSaleKindId := 0                   :: Integer  -- *** - Вид скидки при продаже
                                                  , inIsPay              := FALSE               :: Boolean  -- добавить с оплатой
                                                  , ioAmount             := MIFloat_AmountPartner.ValueData :: TFloat   -- Количество
                                                  , ioChangePercent      := 0                   :: TFloat    -- *** - % Скидки
                                                  , ioChangePercentNext  := 0                   :: TFloat    -- *** - % Скидки
                                                  , ioSummChangePercent  := 0                   :: TFloat    -- *** - Дополнительная скидка в продаже ГРН
                                                  , ioSummChangePercent_curr := 0               :: TFloat    -- *** - Дополнительная скидка в продаже в валюте***
                                                  , ioOperPriceList      := MIFloat_OperPriceList.ValueData :: TFloat  -- *** - Цена факт ГРН
                                                  , inBarCode_partner    := ''                  :: TVarChar   -- Штрих-код поставщика
                                                  , inBarCode_old        := ''                  :: TVarChar   -- Штрих-код из верхнего грида - old
                                                  , inComment            := ''                  :: TVarChar   -- примечание
                                                  , inSession            := inSession       :: TVarChar
                                                  )
     FROM MovementItem AS MI_Master
          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                       ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                      AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                      ON MIFloat_OperPriceList.MovementItemId = MI_Master.Id
                                     AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
     WHERE MI_Master.MovementId = inMovementId_ReturnIn
       AND MI_Master.DescId = zc_MI_Master()
       AND MI_Master.isErased = FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.05.17         *
 */

-- тест
-- SELECT * FROM gpInsert_Movement_Sale_byReturnIn 