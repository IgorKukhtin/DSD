-- Function: gpGet_MovementItem_Cash_Personal_Amount()

-- DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_Amount (Integer, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MovementItem_Cash_Personal_Amount (Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Cash_Personal_Amount (
 INOUT ioId                   Integer   , -- Ключ объекта <Элемент документа>
 INOUT ioAmount               TFloat    , -- Сумма
 INOUT ioSummRemains          TFloat    , -- Остаток к выплате
    IN inSummRemains_diff_F2  TFloat    , -- сначала взяли из грида
   OUT outSummRemains_diff_F2 TFloat    , -- вернули в грид для сохранения
   OUT outIsCalculated        Boolean   , --
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- установили новые значения
     ioAmount:= COALESCE (ioAmount, 0) + COALESCE (ioSummRemains, 0);
     ioSummRemains:= 0;
     outSummRemains_diff_F2:= inSummRemains_diff_F2;

     -- расчет
     outIsCalculated:= FALSE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.04.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpGet_MovementItem_Cash_Personal_Amount (ioId := 11967866, ioAmount:= 8, ioSummRemains:= 450, inSummRemains_diff_F2:= 10, inSession:= '5');
