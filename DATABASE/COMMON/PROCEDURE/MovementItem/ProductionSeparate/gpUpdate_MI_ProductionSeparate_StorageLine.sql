-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionSeparate_StorageLine(
    IN inMovementId          Integer   , -- Id документа
    IN inGoodsId             Integer   , -- товар
    IN inGoodsKindId         Integer   , -- вид товара
    IN inStorageLineId       Integer   , -- линия пр-ва
 INOUT ioStorageLineId_old   Integer   , -- линия пр-ва сохраненное значение
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionSeparate_StorageLine());

   -- выбираем строки куда записываем значение линии пр-ва
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), MovementItem.Id, inStorageLineId)  -- сохранили <линию пр-ва>
         , lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)                                         -- сохранили протокол
   FROM MovementItem 
        LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
        LEFT JOIN MovementItemLinkObject AS MILinkObject_StorageLine
                                         ON MILinkObject_StorageLine.MovementItemId = MovementItem.Id
                                        AND MILinkObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
   WHERE MovementItem.MovementId = inMovementId
     AND MovementItem.DescId     = zc_MI_Master()
     AND MovementItem.isErased   = FALSE
     AND MovementItem.ObjectId = inGoodsId
     AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = inGoodsKindId
     AND COALESCE (MILinkObject_StorageLine.ObjectId,0) = ioStorageLineId_old
   ;
   
   --
   ioStorageLineId_old:= inStorageLineId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MI_ProductionSeparate_Master(inId := 71587375 , inStorageLineId := 0 , inSession := '5');
