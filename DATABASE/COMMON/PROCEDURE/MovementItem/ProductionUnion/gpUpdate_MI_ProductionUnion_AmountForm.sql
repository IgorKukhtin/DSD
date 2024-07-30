 -- Function: gpUpdate_MI_ProductionUnion_AmountForm()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountForm (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountForm(
    IN inMovementItemId       Integer   , -- Ключ объекта <>
    IN inAmountForm           TFloat    , -- кол-во формовка+1день,кг
    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountForm());
   
   -- проверка
   IF COALESCE (inMovementItemId, 0) = 0 
   THEN
       RAISE EXCEPTION 'Ошибка.Строка не сохранена.';
   END IF;

   -- сохранили свойство <кол-во формовка+1день,кг>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountForm(), inMovementItemId, inAmountForm);
 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.24         * 
*/

-- тест
-- 