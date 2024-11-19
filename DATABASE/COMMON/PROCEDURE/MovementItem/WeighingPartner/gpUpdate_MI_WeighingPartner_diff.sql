-- Function: gpUpdate_MI_WeighingPartner_diff()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, Boolean, Boolean, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_diff (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_diff(
    IN inId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inChangePercentAmount    TFloat    , -- % скидки для кол-ва 
    IN inAmountPartnerSecond    TFloat    , 
    IN inAmountPartner_income   TFloat    ,
    IN inPricePartnerWVAT       TFloat    ,
    IN inPricePartnerNoVAT      TFloat    , 
   OUT outAmountPartner_calc    TFloat    , 
   OUT outSummPartnerWVAT       TFloat    ,
   OUT outSummPartnerNoVAT      TFloat    ,
   OUT outAmount_diff           TFloat    ,
   OUT outPrice_diff            TFloat    ,
    IN inisAmountPartnerSecond  Boolean   ,
    IN inisReturnOut            Boolean   , --   
    IN inComment                TVarChar  , -- 
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство <% скидки для кол-ва>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercentAmount(), inId, inChangePercentAmount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), inId, inisAmountPartnerSecond);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ReturnOut(), inId, inisReturnOut);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), inId, inComment);

     outAmountPartner_calc := (inAmountPartnerSecond * (1 - inChangePercentAmount / 100))::TFloat;
     outSummPartnerNoVAT   := (outAmountPartner_calc * inPricePartnerNoVAT);
     outSummPartnerWVAT    := (outAmountPartner_calc * inPricePartnerWVAT); 
     outAmount_diff        := (COALESCE (outAmountPartner_calc, 0) - COALESCE (inAmountPartner_income, 0));
     
     --RAISE EXCEPTION 'Ошибка.<%>   <%>   <%>  <%>  .', outAmountPartner_calc, outSummPartnerNoVAT, outSummPartnerWVAT, outAmount_diff;

     IF vbUserId = 9457
     THEN
          RAISE EXCEPTION 'Ошибка.Тест ОК.';
     END IF;

     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.11.24         *
*/

-- тест
--