-- Function: gpUpdate_MI_Income_PricebyPersent (tfloat, tfloat, tvarchar)

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_PricebyPersent (tfloat, tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_PricebyPersent(
    IN inPersent      tfloat,
    IN inPriceJur     tfloat,
   OUT outOperPrice   tfloat,
    IN insession      tvarchar
)
  RETURNS tfloat AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());

     outOperPrice := inPriceJur + (inPriceJur / 100 * inPersent);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.19         *
*/