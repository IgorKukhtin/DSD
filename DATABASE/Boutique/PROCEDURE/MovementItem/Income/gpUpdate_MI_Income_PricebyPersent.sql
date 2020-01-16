-- Function: gpUpdate_MI_Income_PricebyPersent (TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_PricebyPersent (TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_PricebyPersent(
    IN inPersent      TFloat,
    IN inPriceJur     TFloat,
   OUT outOperPrice   TFloat,
    IN insession      TVarChar
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());

     -- Результат
     outOperPrice := CASE WHEN zc_Enum_GlobalConst_isTerry() = TRUE
                               THEN inPriceJur + (inPriceJur / 100 * inPersent)
                          ELSE inPriceJur
                     END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.19         *
*/