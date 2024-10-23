-- Function: gpUpdate_MI_Income_PartnerParam()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_PartnerParam (Integer, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_PartnerParam(
    IN inId                   Integer  , -- ключ строка    
    IN inPricePartner         TFloat ,
    IN inAmountPartnerSecond  TFloat   ,
    IN inSession              TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_PricePartner());

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), inId, inPricePartner);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), inId, inAmountPartnerSecond);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.10.24         *
*/

-- тест
--