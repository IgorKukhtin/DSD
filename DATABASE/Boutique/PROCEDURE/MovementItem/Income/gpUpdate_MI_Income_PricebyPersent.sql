-- Function: gpUpdate_PriceWithoutPersent()

DROP FUNCTION IF EXISTS gpUpdate_PriceWithoutPersent (TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_PriceWithoutPersent(
    IN inPersent             TFloat    , -- Цена
    IN inOperPrice           TFloat    , -- Цена
   OUT outOperPrice          TFloat    , -- Цена по прайсу
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Income_Price());

     outOperPrice := inOperPrice - (inOperPrice/100*inPersent);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.02.19         *
*/

-- тест
-- 