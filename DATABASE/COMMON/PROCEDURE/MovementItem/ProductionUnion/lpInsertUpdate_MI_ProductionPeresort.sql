-- Function: lpInsertUpdate_MI_ProductionPeresort

-- DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ProductionPeresort (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ProductionPeresort(
    INOUT ioId                  Integer,
    IN inMovementId             Integer,
    IN inGoodsId                Integer,
    IN inGoodsId_child          Integer,
    IN inGoodsKindId            Integer,
    IN inGoodsKindId_Complete   Integer   , -- Виды товаров
    IN inGoodsKindId_child      Integer,
    IN inGoodsKindId_Complete_child  Integer   , -- Виды товаров
    IN inAmount                 TFloat,
    IN inAmount_child           TFloat,
    IN inPartionGoods           TVarChar,
    IN inPartionGoods_child     TVarChar,
    IN inPartionGoodsDate       TDateTime,
    IN inPartionGoodsDate_child TDateTime, 
    IN inStorageId              Integer   , -- Место хранения
    IN inStorageId_child        Integer   , -- Место хранения
    IN inPartNumber             TVarChar  , -- № по тех паспорту
    IN inPartNumber_child       TVarChar  , -- № по тех паспорту 
    IN inModel                  TVarChar  , -- Model
    IN inModel_child            TVarChar  , -- Model
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId_child Integer;
BEGIN
   -- поиск
   IF COALESCE (ioId, 0) <> 0
   THEN
      IF 1 < (SELECT COUNT(*) FROM MovementItem WHERE MovementId = inMovementId AND ParentId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE)
      THEN
          vbId_child := (SELECT Id
                         FROM MovementItem
                              LEFT JOIN MovementItemBoolean AS MIBoolean_Etiketka
                                                            ON MIBoolean_Etiketka.MovementItemId = MovementItem.Id
                                                           AND MIBoolean_Etiketka.DescId         = zc_MIBoolean_Etiketka()
                                                           AND MIBoolean_Etiketka.ValueData      = TRUE
                                                               
                         WHERE MovementItem.MovementId = inMovementId AND MovementItem.ParentId = ioId AND MovementItem.DescId = zc_MI_Child() AND MovementItem.isErased = FALSE
                           AND MIBoolean_Etiketka.MovementItemId IS NULL
                        );
      ELSE
          vbId_child := (SELECT MovementItem.Id FROM MovementItem WHERE MovementId = inMovementId AND ParentId = ioId AND DescId = zc_MI_Child() AND isErased = FALSE);
      END IF;

   END IF;

   -- сохранили <Master>
   ioId:= lpInsertUpdate_MI_ProductionUnion_Master (ioId               := ioId
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId
                                                  , inAmount           := inAmount
                                                  , inCount            := 0
                                                  , inCuterWeight      := 0
                                                  , inPartionGoodsDate := inPartionGoodsDate
                                                  , inPartionGoods     := inPartionGoods
                                                  , inPartNumber       := inPartNumber
                                                  , inModel            := inModel
                                                  , inGoodsKindId      := inGoodsKindId
                                                  , inGoodsKindId_Complete := inGoodsKindId_Complete
                                                  , inStorageId        := inStorageId
                                                  , inUserId           := inUserId
                                                   );

   -- сохранили <Child>
   PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId               := vbId_child
                                                  , inMovementId       := inMovementId
                                                  , inGoodsId          := inGoodsId_child
                                                  , inAmount           := inAmount_child
                                                  , inParentId         := ioId
                                                  , inPartionGoodsDate := inPartionGoodsDate_child
                                                  , inPartionGoods     := inPartionGoods_child
                                                  , inPartNumber       := inPartNumber_child 
                                                  , inModel            := inModel_child
                                                  , inGoodsKindId      := inGoodsKindId_child
                                                  , inGoodsKindCompleteId := inGoodsKindId_Complete_child
                                                  , inStorageId        := inStorageId_child
                                                  , inCount_onCount    := 0
                                                  , inUserId           := inUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.05.23         *
 17.07.15                                        * all
 29.06.15         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_ProductionPeresort (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPartionClose:= FALSE, inComment:= '', inCount:= 1, inRealWeight:= 1, inCuterCount:= 0, inReceiptId:= 0, inSession:= '2')
