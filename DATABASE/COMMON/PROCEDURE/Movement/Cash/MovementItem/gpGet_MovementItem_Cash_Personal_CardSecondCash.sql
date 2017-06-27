-- Function: gpGet_MovementItem_Cash_Personal_CardSecondCash()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_CardSecondCash (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Cash_Personal_CardSecondCash (
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioAmount              TFloat    , -- к выплате 
 INOUT ioSummCardSecondCash  TFloat    , -- Сумма бн (касса) 2ф
   OUT outIsCalculated       Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- установили новые значения
     ioAmount:= COALESCE (ioAmount, 0) + COALESCE (ioSummCardSecondCash, 0);
     ioSummCardSecondCash:= 0;
     
     -- расчет
     outIsCalculated:= CASE WHEN ioAmount > 0 THEN TRUE ELSE FALSE END;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.06.17         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Cash_Personal_CardSecondCash (ioId:= 0, ioAmount:= 0, ioCardSecondCash:= 0, inSession:= '2')
