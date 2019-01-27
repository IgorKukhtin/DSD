-- Function: gpInsertUpdate_MovementItem_SendOnPrice_Branch()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Branch (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Branch (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendOnPrice_Branch (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, Boolean, Boolean, TFloat, TFloat, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendOnPrice_Branch(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
 INOUT ioAmount              TFloat    , -- Кол-во (расход)

 INOUT ioAmountPartner           TFloat    , -- Количество у контрагента
   OUT outAmountChangePercent    TFloat    , -- Количество c учетом % скидки (!!!расчет!!!)
    IN inChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
 INOUT ioChangePercentAmount     TFloat    , -- % скидки для кол-ва (!!!из грида!!!)
    IN inIsChangePercentAmount   Boolean   , -- Признак - будет ли использоваться из контрола <% скидки для кол-ва>
    IN inIsCalcAmountPartner     Boolean   , -- Признак - будет ли расчитано <Количество у контрагента>

    IN inPrice               TFloat    , -- Цена
 INOUT ioCountForPrice       TFloat    , -- Цена за количество
   OUT outAmountSumm         TFloat    , -- Сумма расчетная
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inUnitId              Integer   , -- Подразделение

   OUT outWeightPack         TFloat    ,
   OUT outWeightTotal        TFloat    ,
   OUT outCountPack          TFloat    ,

    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsProcess_BranchIn Boolean;
   DECLARE vbIsBarCode Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendOnPrice_Branch());


     -- Важный параметр - Приход на филиала или расход с филиала (в первом случае вводится только "Кол-во (приход)")
     vbIsProcess_BranchIn:= EXISTS (SELECT Id FROM Object_Unit_View WHERE Id = (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_To()) AND BranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId))
                           ;

     -- получили значение
     vbIsBarCode:= COALESCE ((SELECT MIBoolean.ValueData FROM MovementItemBoolean AS MIBoolean WHERE MIBoolean.MovementItemId = ioId AND MIBoolean.DescId = zc_MIBoolean_BarCode()), FALSE);

     -- !!!скидка - вес упаковки!!!
     IF vbIsBarCode = TRUE
     THEN
         -- проверка: если вводится кол склад надо сообщить что оно расчетное, вводить нельзя
         IF ioId <> 0 AND EXISTS (SELECT 1 FROM MovementItemFloat AS MIFloat WHERE MIFloat.MovementItemId = ioId AND MIFloat.DescId = zc_MIFloat_AmountPartner() AND MIFloat.ValueData = ioAmountPartner)
                      AND NOT EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.Id = ioId AND MI.DescId = zc_MI_Master() AND MI.Amount = ioAmount)
         THEN
             RAISE EXCEPTION 'Ошибка.Ввод запрещен, т.к. <Кол-во склад> является расчетным если установлен признак <Скидка скан. упак.>.';
         END IF;

         -- получили значения для упаковки
         SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
                INTO outWeightPack, outWeightTotal
         FROM Object_GoodsByGoodsKind_View
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                    ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
              LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                    ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                   AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
         WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
           AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;
         -- расчет кол-во шт. упаковки (пока округление до 4-х знаков)
         outCountPack:= CASE WHEN outWeightTotal <> 0 AND outWeightPack <> 0 AND outWeightTotal > outWeightPack
                                  THEN CAST (CAST (ioAmountPartner / (1 - outWeightPack / outWeightTotal) AS NUMERIC (16, 4)) / outWeightTotal AS NUMERIC (16, 4))
                             ELSE 0
                        END;

         -- !!!только в этом слуаче расчет "кол-во склад"!!!
         ioAmount:= ioAmountPartner + CAST (outCountPack * COALESCE (outWeightPack, 0) AS NUMERIC (16, 4));
         -- !!!обнуление "других" скидок!!!
         ioChangePercentAmount:= 0;
         inIsChangePercentAmount:= FALSE;
         -- !!!расчет!!! - Количество c учетом % скидки
         outAmountChangePercent:= ioAmountPartner;

     ELSE
         -- !!!из контрола!!! - % скидки для кол-ва
         /*IF inIsChangePercentAmount = TRUE
         THEN
             IF EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Measure_Kg())
             THEN ioChangePercentAmount:= inChangePercentAmount; -- !!!из контрола!!!
             ELSE ioChangePercentAmount:= 0;
             END IF;
         END IF;*/

         -- !!!для филиала!!!
         ioChangePercentAmount:= 0;

         -- !!!расчет!!! - Количество c учетом % скидки
         IF ioChangePercentAmount <> 0
         THEN outAmountChangePercent:= CAST (ioAmount * (1 - COALESCE (ioChangePercentAmount, 0) / 100) AS NUMERIC (16, 3));
         ELSE outAmountChangePercent:= ioAmount;
         END IF;

     END IF;

     IF inIsCalcAmountPartner = TRUE
     THEN
         ioAmountPartner:= outAmountChangePercent;
     END IF;


     -- 
     IF vbIsProcess_BranchIn = FALSE
     THEN
         ioAmountPartner:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_AmountPartner()), 0);
     END IF;

     -- сохранили
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_SendOnPrice
                                           (ioId                 := ioId
                                          , inMovementId         := inMovementId
                                          , inGoodsId            := inGoodsId
                                          , inAmount             := CASE WHEN vbIsProcess_BranchIn = FALSE
                                                                              THEN ioAmount
                                                                         ELSE COALESCE ((SELECT Amount FROM MovementItem WHERE Id = ioId), 0)
                                                                    END
                                          , inAmountPartner      := CASE WHEN vbIsProcess_BranchIn = TRUE
                                                                             THEN ioAmountPartner
                                                                         ELSE ioAmountPartner -- COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountPartner()), 0)
                                                                    END
                                          , inAmountChangePercent:= outAmountChangePercent    --COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_AmountChangePercent()), 0)
                                          , inChangePercentAmount:= inChangePercentAmount     --COALESCE ((SELECT ValueData FROM MovementItemFloat WHERE MovementItemId = ioId AND DescId = zc_MIFloat_ChangePercentAmount()), 0)
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
                                          , inUnitId             := (SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = ioId AND DescId = zc_MILinkObject_Unit())

                                          , inCountPack          := COALESCE (outCountPack, 0)
                                          , inWeightTotal        := COALESCE (outWeightTotal, 0)
                                          , inWeightPack         := COALESCE (outWeightPack, 0)
                                          , inIsBarCode          := vbIsBarCode

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
