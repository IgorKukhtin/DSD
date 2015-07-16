-- Function: gpUpdate_MovementItem_Inventory_Summ (Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Inventory_Summ (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Inventory_Summ(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inSumm                TFloat    , -- Сумма
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Inventory_Summ());

     IF inId <> 0
     THEN
          -- сохранили свойство <Сумма>
          PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), inId, inSumm);

          -- пересчитали Итоговые суммы по накладной
          PERFORM lpInsertUpdate_MovementFloat_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inId));

          -- сохранили протокол
          PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.07.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_MovementItem_Inventory_Summ
