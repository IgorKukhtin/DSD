-- Function: gpGet_MI_SendDebt_AmountCurrency (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_MI_SendDebt_AmountCurrency (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_SendDebt_AmountCurrency(
    IN inCurrencyId_From       Integer   , --
    IN inCurrencyId_To         Integer   , --
    IN inAmount                TFloat, -- 
    IN inCurrencyValue_From    TFloat, -- 
    IN inParValue_From         TFloat, --
    IN inCurrencyValue_To      TFloat, --
    IN inParValue_To           TFloat, --
   OUT outAmountCurrencyFrom   TFloat, --
   OUT outAmountCurrencyTo     TFloat, --
    IN inSession               TVarChar   -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SendDebt());
     vbUserId:= lpGetUserBySession (inSession);

    -- дебет
    IF inAmount <> 0 THEN
        IF inCurrencyId_From <> zc_Enum_Currency_Basis()
        THEN
             -- сумма в валюте
             outAmountCurrencyFrom := CASE WHEN inCurrencyValue_From <> 0 THEN CAST (inAmount / inCurrencyValue_From * inParValue_From AS NUMERIC (16, 2)) ELSE 0 END;
        ELSE
             outAmountCurrencyFrom := inAmount;
        END IF;
    
        -- кредит
        IF inCurrencyId_To <> zc_Enum_Currency_Basis()
        THEN
             -- сумма в валюте
             outAmountCurrencyTo := CASE WHEN inCurrencyValue_To <> 0 THEN CAST (inAmount / inCurrencyValue_To * inParValue_To AS NUMERIC (16, 2)) ELSE 0 END;
        ELSE
             outAmountCurrencyTo := inAmount;
        END IF;
    ELSE 
        outAmountCurrencyFrom := 0;
        outAmountCurrencyTo := 0;
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.19         *
*/

-- тест
-- SELECT * FROM gpGet_MI_SendDebt_AmountCurrency 
