-- Function: lpUpdate_MI_ReturnIn_Total()

DROP FUNCTION IF EXISTS lpUpdate_MI_ReturnIn_Total (Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MI_ReturnIn_Total(
    IN inMovementItemId      Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbTotalPayOth  TFloat;
BEGIN

     vbTotalPayOth := 0;
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPayOth(), inMovementItemId, vbTotalPayOth);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.17         *
*/

-- тест
-- 