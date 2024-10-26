-- Function: gpUpdate_Scale_MI_Income_PricePartner()

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_Income_PricePartner (Integer, Integer, TFloat, TFloat, Boolean, Boolean, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_Income_PricePartner(
    IN inMovementDescId        Integer   , -- Ключ объекта <Документ>
    IN inBranchCode            Integer   , --
    IN inMovementItemId        Integer   , -- Ключ
    IN inPricePartner          TFloat    , -- цена поставщика - из накладной - ввод в контроле
    IN inAmountPartnerSecond   TFloat    , -- Кол-во поставщика - из накладной
    IN inIsAmountPartnerSecond Boolean   , -- без оплаты да/нет - Кол-во поставщика
    IN inIsPriceWithVAT        Boolean   , -- Цена с НДС да/нет - для цена поставщика
    IN inOperDate_ReturnOut    TDateTime , -- Дата для цены возврат поставщику
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbContractId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- Проверка
     IF COALESCE (inMovementItemId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент <Взвешивание> не сформирован.';
     END IF;



     -- Обновляются
     IF inMovementDescId = zc_Movement_Income()
     THEN
         -- цена поставщика для Сырья - из накладной
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inMovementItemId, inPricePartner);
         -- Количество у поставщика - из накладной
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), inMovementItemId, inAmountPartnerSecond);

         -- без оплаты да/нет - Кол-во поставщика
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inMovementItemId, inIsAmountPartnerSecond);

         -- Цена с НДС да/нет - для цена поставщика
         PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), inMovementItemId, inIsPriceWithVAT);

     ELSEIF inMovementDescId = zc_Movement_Income()
     THEN
         -- Дата для цены возврат поставщику
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PriceRetOut(), inMovementItemId, inOperDate_ReturnOut);

     ELSE

         RAISE EXCEPTION 'Ошибка.gpUpdate_Scale_MI_Income_PricePartner.';

     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 25.10.24                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_MI_Income_PricePartner (inMovementId:= 29547683, inBranchCode:= 201, inIsUpdate:= TRUE, inSession:= '5')
