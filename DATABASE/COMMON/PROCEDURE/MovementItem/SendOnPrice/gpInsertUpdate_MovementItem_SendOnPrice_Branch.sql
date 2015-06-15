-- Function: gpInsertUpdate_MovementItem_SendOnPrice_Branch()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Branch (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Branch (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendOnPrice_Branch(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Кол-во (расход)
    IN inAmountPartner       TFloat    , -- Кол-во (приход)
    IN inAmountChangePercent TFloat    , -- Количество c учетом % скидки
    IN inChangePercentAmount TFloat    , -- % скидки для кол-ва
    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUnitId              Integer   , -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsProcess_BranchIn Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice_Branch());


     -- Важный параметр - Прихрд на филиала или расход с филиала (в первом случае вводится только "Кол-во (приход)")
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

     -- сохранили
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                           (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := CASE WHEN vbIsProcess_BranchIn = FALSE
                                                                              THEN inAmount
                                                                         ELSE COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId), 0)
                                                                    END
                                          , inAmountPartner      := CASE WHEN vbIsProcess_BranchIn = TRUE
                                                                              THEN inAmountPartner
                                                                         ELSE COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountPartner()), 0)
                                                                    END
                                          , inAmountChangePercent:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountChangePercent()), 0)
                                          , inChangePercentAmount:= COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_ChangePercentAmount()), 0)
                                          , inPrice              := CASE WHEN vbIsProcess_BranchIn = FALSE
                                                                           OR 0 = COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId), 0)
                                                                              THEN inPrice
                                                                         ELSE COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_Price()), 0)
                                                                    END
                                          , ioCountForPrice      := CASE WHEN vbIsProcess_BranchIn = FALSE
                                                                           OR 0 = COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId), 0)
                                                                              THEN ioCountForPrice
                                                                         ELSE COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_CountForPrice()), 1)
                                                                    END
                                          , inPartionGoods       := inPartionGoods
                                          , inGoodsKindId        := CASE WHEN vbIsProcess_BranchIn = FALSE
                                                                           OR 0 = COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId), 0)
                                                                              THEN inGoodsKindId
                                                                         ELSE (SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_GoodsKind())
                                                                    END
                                          , inUnitId             := inUnitId
                                          , inUserId             := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.06.15         * add inUnitId
 04.11.13                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_SendOnPrice_Branch (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
