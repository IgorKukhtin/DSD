-- Function: gpUpdate_MI_Inventory_PartionGoods (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MI_Inventory_PartionGoods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Inventory_PartionGoods(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inPartionGoodsId      Integer   , -- Партия
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());

     IF inId <> 0
     THEN
          -- сохранили связь с <партия товаров>
          PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionGoods(), inId, inPartionGoodsId);

          -- сохранили протокол
          PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.12.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_MI_Inventory_PartionGoods
