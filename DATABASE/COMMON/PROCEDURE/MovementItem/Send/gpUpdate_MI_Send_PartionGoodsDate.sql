-- Function: gpUpdate_MI_Send_PartionGoodsDate()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_PartionGoodsDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_PartionGoodsDate(
    IN inId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inPartionGoodsDate         TDateTime , -- Дата партии
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inId,0) = 0
     THEN
         RETURN;
     END IF;
     
     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.1900' THEN inPartionGoodsDate:= NULL; END IF;
     
     -- сохранили свойство <Дата партии>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inId, inPartionGoodsDate); 
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.23         *
*/

-- тест
--