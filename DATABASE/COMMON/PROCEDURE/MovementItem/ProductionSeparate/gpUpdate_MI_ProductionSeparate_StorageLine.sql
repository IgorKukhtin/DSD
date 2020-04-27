-- Function: gpInsertUpdate_MI_ProductionSeparate_Master()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionSeparate_StorageLine (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionSeparate_StorageLine(
    IN inMovementId          Integer   , -- Id документа
    IN inMovementItemId      Integer   , --
    IN inGoodsId             Integer   , -- товар
    IN inGoodsKindId         Integer   , -- вид товара
    IN inStorageLineId       Integer   , -- линия пр-ва
 INOUT ioStorageLineId_old   Integer   , -- линия пр-ва сохраненное значение
    IN inIsDescMaster        Boolean   , -- Для какого грида
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionSeparate_StorageLine());

   vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

   -- сохранили <линию пр-ва>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StorageLine(), inMovementItemId, inStorageLineId);
   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);

   -- сохранили связь с <Виды товаров>
   PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), inMovementItemId, inGoodsKindId);


   IF vbStatusId = zc_Enum_Status_Complete()
   THEN
       -- Распроводим Документ - БЕЗ Проверки Прав
       PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                    , inUserId     := vbUserId);

       -- и проводим - БЕЗ Проверки Прав

       -- создаются временные таблицы - для формирование данных для проводок
       PERFORM lpComplete_Movement_ProductionSeparate_CreateTemp();

       -- Проводим
       PERFORM lpComplete_Movement_ProductionSeparate (inMovementId:= inMovementId
                                                     , inUserId    := vbUserId
                                                      );
   END IF;


/*   -- выбираем строки куда записываем значение линии пр-ва
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
     AND ((MovementItem.DescId = zc_MI_Master() AND inIsDescMaster = TRUE)
       OR (MovementItem.DescId = zc_MI_Child() AND inIsDescMaster = FALSE)
         )
     AND MovementItem.isErased   = FALSE
     AND MovementItem.ObjectId = inGoodsId
     AND COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = inGoodsKindId
     AND COALESCE (MILinkObject_StorageLine.ObjectId,0) = ioStorageLineId_old
     ;*/

   --
   ioStorageLineId_old:= inStorageLineId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.18         * add inMovementItemId
 25.01.18         * add inIsDescMaster
 14.08.17         *
*/

-- тест
-- select * from gpUpdate_MI_ProductionSeparate_StorageLine(inMovementId := 5268188 , inGoodsId := 5246 , inGoodsKindId := 0 , inStorageLineId := 0 , ioStorageLineId_old := 0 , inIsDescMaster := 'TRUE' ,  inSession := '5');
-- select * from gpUpdate_MI_ProductionSeparate_StorageLine(inMovementId := 5268188 , inGoodsId := 5246 , inGoodsKindId := 0 , inStorageLineId := 1005633 , inIsDescMaster := 'TRUE' ,  inSession := '5');

