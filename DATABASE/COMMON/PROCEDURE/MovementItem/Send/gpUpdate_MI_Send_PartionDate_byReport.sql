-- Function: gpUpdate_MI_Send_PartionDate_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_PartionDate_byReport (Integer, Integer,Integer,Integer,TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_PartionDate_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа> 
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime , -- Дата партии
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send_PartionDate_byReport());

     IF COALESCE (inMovementItemId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.%Изменение партии возможно в режиме <По документам>.', CHR (13);
     END IF;
     
     -- меняем параметр
     IF inPartionGoodsDate <= '01.01.2010' THEN inPartionGoodsDate:= NULL; END IF;
     
     -- сохранили свойство <Дата партии>
     IF COALESCE (inPartionGoodsDate, zc_DateStart()) <> zc_DateStart() OR EXISTS (SELECT 1 FROM MovementItemDate AS MID WHERE MID.MovementItemId = inMovementItemId AND MID.DescId = zc_MIDate_PartionGoods())
     THEN
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods(), inMovementItemId, inPartionGoodsDate); 
     END IF;

     -- сохранили протокол
     --PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.01.24         *
*/

-- тест
--