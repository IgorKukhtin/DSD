-- Function: gpInsert_Scale_MI()

DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_MI(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inGoodsKindId           Integer   , -- Виды товаров
    IN inRealWeight            TFloat    , -- Реальный вес (без учета: минус тара и % скидки для кол-ва)
    IN inChangePercentAmount   TFloat    , -- % скидки для кол-ва
    IN inCountTare             TFloat    , -- Количество тары
    IN inWeightTare            TFloat    , -- Вес 1-ой тары
    IN inPrice                 TFloat    , -- Цена
    IN inPrice_Return          TFloat    , -- Цена
    IN inCountForPrice         TFloat    , -- Цена за количество
    IN inCountForPrice_Return  TFloat    , -- Цена за количество
    IN inDayPrior_PriceReturn  Integer,
    IN inCount                 TFloat    , -- Количество пакетов или Количество батонов или Кол-во для Печати ЭТИКЕТОК
    IN inHeadCount             TFloat    , --
    IN inBoxCount              TFloat    , --
    IN inBoxCode               Integer   , --
    IN inPartionGoods          TVarChar  , -- Партия
    IN inPriceListId           Integer   , --
    IN inBranchCode            Integer   , --
    IN inMovementId_Promo      Integer   , --
    IN inIsBarCode             Boolean   , --
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id        Integer
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMovementDescId Integer;
   DECLARE vbMovementId_order Integer;
   DECLARE vbBoxId Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbRetailId Integer;

   DECLARE vbWeightTotal   TFloat;
   DECLARE vbWeightPack    TFloat;
   DECLARE vbAmount_byPack TFloat;

   DECLARE vbPriceListId_Dnepr Integer;
   DECLARE vbOperDate_Dnepr    TDateTime;

   DECLARE vbPricePromo            TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbChangePercent         TFloat;
            
   DECLARE vbPrice_301 TFloat; -- !!!цена для Специй!!!

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Scale_MI());
     vbUserId:= lpGetUserBySession (inSession);


     -- проверка
     IF inRealWeight > 1000000
     THEN
         RAISE EXCEPTION 'Ошибка Вес <%>.', inRealWeight;
     END IF;


     -- определили
     SELECT Movement.OperDate, MovementFloat.ValueData :: Integer, COALESCE (MLM_Order.MovementChildId, 0)
          , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
            INTO vbOperDate, vbMovementDescId, vbMovementId_order, vbRetailId
     FROM Movement
          LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDesc()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;


     -- если Тара - меняем Значение на 0
     IF inChangePercentAmount <> 0
        AND EXISTS (SELECT 1
                    FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                         JOIN Object_InfoMoney_View AS View_InfoMoney
                                                    ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                   AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                               , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                                )
                    WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                   )
     THEN
         inChangePercentAmount:= 0;
     -- если надо - меняем Значение                 \
     ELSEIF inChangePercentAmount = 0
        AND vbMovementDescId = zc_Movement_Sale()
        AND EXISTS (SELECT 1
                    FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                         LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                              ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                             AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                         INNER JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                               ON ObjectFloat_ChangePercentAmount.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                              AND ObjectFloat_ChangePercentAmount.DescId    = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                              AND ObjectFloat_ChangePercentAmount.ValueData <> 0
                         JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                         ON ObjectLink_Goods_InfoMoney.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                         JOIN Object_InfoMoney_View AS View_InfoMoney
                                                    ON View_InfoMoney.InfoMoneyId            = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                   AND View_InfoMoney.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                    WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                      AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())  = inGoodsKindId
                   )
     THEN
         inChangePercentAmount:= (SELECT ObjectFloat_ChangePercentAmount.ValueData
                                  FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                            ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                           AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                       INNER JOIN ObjectFloat AS ObjectFloat_ChangePercentAmount
                                                             ON ObjectFloat_ChangePercentAmount.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectFloat_ChangePercentAmount.DescId    = zc_ObjectFloat_GoodsByGoodsKind_ChangePercentAmount()
                                  WHERE ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                                    AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, zc_GoodsKind_Basis())  = inGoodsKindId
                                  LIMIT 1 -- !!!вдруг будет и с пустым значение и с zc_GoodsKind_Basis!!!
                                 );

     END IF;

     -- определили !!!только для Возвратов - поиск акций!!!
     IF vbMovementDescId IN (zc_Movement_ReturnIn())
     THEN
         SELECT tmp.MovementId
              , CASE WHEN /*tmp.TaxPromo <> 0 AND*/ (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()) = TRUE
                          THEN tmp.PriceWithVAT
                     WHEN /*tmp.TaxPromo <> 0 AND*/ 1=1
                          THEN tmp.PriceWithOutVAT
                     ELSE 0 -- ???может надо будет взять из прайса когда была акция ИЛИ любой продажи под эту акцию???
                END
              , tmp.isChangePercent
                INTO inMovementId_Promo, vbPricePromo, vbIsChangePercent_Promo
         FROM lpGet_Movement_Promo_Data_all (inOperDate     := (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                           , inPartnerId    := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                           , inContractId   := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                           , inUnitId       := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                           , inGoodsId      := inGoodsId
                                           , inGoodsKindId  := inGoodsKindId
                                           , inIsReturn     := TRUE
                                            ) AS tmp;
     END IF;



     -- !!!теперь будет для ВСЕХ - если Возврат + Акция!!!
     IF vbMovementDescId = zc_Movement_ReturnIn() AND inMovementId_Promo > 0
     THEN
         -- !!!замена!!!
         inPrice_Return:= vbPricePromo;

     ELSE
     -- определили !!!только для SPEC!!!
     IF vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
        AND inBranchCode IN (301) -- Dnepr + Dnepr-OBV + иногда Dnepr-SPEC
        AND inBoxCount > 0
     THEN
         -- !!!т.к. Криво - передаем цену через этот параметр!!!
         vbPrice_301:= inBoxCount;
         inBoxCount:= 0;
     ELSE
     -- определили !!!только для Днепра!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
        AND inBranchCode IN (1, 201, 301) -- Dnepr + Dnepr-OBV + иногда Dnepr-SPEC
     THEN
         -- !!!замена!!!
         SELECT tmp.PriceListId, tmp.OperDate
               INTO vbPriceListId_Dnepr, vbOperDate_Dnepr
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , inPartnerId      := CASE WHEN vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                   THEN (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                                              ELSE (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_From())
                                                                         END
                                                   , inMovementDescId := vbMovementDescId
                                                   , inOperDate_order := CASE WHEN vbMovementId_order <> 0
                                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                              ELSE NULL
                                                                         END
                                                   , inOperDatePartner:= CASE WHEN 1=0 AND inBranchCode = 201 -- Dnepr-OBV
                                                                                   THEN (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                              WHEN vbMovementId_order <> 0
                                                                                   THEN NULL
                                                                              ELSE (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                         END
                                                   , inDayPrior_PriceReturn:= inDayPrior_PriceReturn
                                                   , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                    ) AS tmp;
     END IF;
     END IF;
     END IF;


     -- только для ReturnIn ВСЕГДА - определили (-)% Скидки (+)% Наценки
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE AND vbMovementDescId = zc_Movement_ReturnIn()
                                 THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                            ELSE 0
                       END;

     -- определили
     vbBoxId:= CASE WHEN inBoxCode > 0 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBoxCode AND Object.DescId = zc_Object_Box()) ELSE 0 END;
     -- определили Вес 1 ед. продукции + упаковка AND Вес упаковки для 1-ой ед. продукции
     SELECT ObjectFloat_WeightPackage.ValueData, ObjectFloat_WeightTotal.ValueData
          , CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0 AND ObjectFloat_WeightPackage.ValueData <> 0 AND ObjectFloat_WeightTotal.ValueData > ObjectFloat_WeightPackage.ValueData
                      THEN (inRealWeight - inCountTare * inWeightTare) / (1 - ObjectFloat_WeightPackage.ValueData / ObjectFloat_WeightTotal.ValueData)
                 ELSE (inRealWeight - inCountTare * inWeightTare)
            END
            INTO vbWeightPack, vbWeightTotal, vbAmount_byPack
     FROM Object_GoodsByGoodsKind_View
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
     WHERE Object_GoodsByGoodsKind_View.GoodsId = inGoodsId
       AND Object_GoodsByGoodsKind_View.GoodsKindId = inGoodsKindId;


     -- проверка, т.к. несколько записей
     IF 1 < (SELECT COUNT(*) FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure()) THEN
        RAISE EXCEPTION 'Ошибка.Записей у <%> для Ед.измерения = <%>.', lfGet_Object_ValueData (inGoodsId)
          , (SELECT COUNT(*) FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure());
     END IF;
     -- проверка, т.к. несколько записей
     IF 1 < (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inSession    := inSession
                                                                    ) AS tmp) THEN
        RAISE EXCEPTION 'Ошибка.Записей у <%> <%> <%> <%> <%> для Цена = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (vbPriceListId_Dnepr), lfGet_Object_ValueData (inPriceListId), DATE (vbOperDate_Dnepr), DATE (vbOperDate)
          , (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inSession    := inSession
                                                                    ) AS tmp);
     END IF;
     -- проверка, т.к. несколько записей
     IF 1 < (SELECT COUNT(*) FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()) THEN
        RAISE EXCEPTION 'Ошибка.Записей у <%> для УП = <%>.', lfGet_Object_ValueData (inGoodsId)
          , (SELECT COUNT(*) FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney());
     END IF;

                                                                                            
     -- сохранили
     vbId:= gpInsertUpdate_MovementItem_WeighingPartner (ioId                  := 0
                                                       , inMovementId          := inMovementId
                                                       , inGoodsId             := inGoodsId
                                                       , inAmount              := CASE WHEN inIsBarCode = TRUE AND zc_Measure_Kg() = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure())
                                                                                        AND vbAmount_byPack <> 0
                                                                                            THEN vbAmount_byPack
                                                                                       ELSE inRealWeight - inCountTare * inWeightTare
                                                                                  END
                                                       , inAmountPartner       := CASE -- !!!только Для Сканирования Метро!!!
                                                                                       /*WHEN vbRetailId IN (310828) -- Метро
                                                                                            THEN CEIL ((inRealWeight - inCountTare * inWeightTare) * 100) / 100
                                                                                       */
                                                                                       WHEN inIsBarCode = TRUE
                                                                                            THEN (inRealWeight - inCountTare * inWeightTare)
                                                                                       WHEN inChangePercentAmount = 0
                                                                                            THEN (inRealWeight - inCountTare * inWeightTare)
                                                                                       WHEN vbRetailId IN (341640, 310854, 310855) -- Фоззі + Фозі + Варус
                                                                                            THEN CAST ((inRealWeight - inCountTare * inWeightTare) * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
                                                                                       ELSE CAST ((inRealWeight - inCountTare * inWeightTare) * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
                                                                                  END
                                                       , inRealWeight          := inRealWeight
                                                       , inChangePercentAmount := CASE WHEN inIsBarCode = TRUE
                                                                                            THEN 0
                                                                                       ELSE inChangePercentAmount
                                                                                  END
                                                       , inCountTare           := inCountTare
                                                       , inWeightTare          := inWeightTare
                                                       , inCountPack           := CASE WHEN inIsBarCode = TRUE AND vbWeightTotal <> 0
                                                                                            THEN vbAmount_byPack / vbWeightTotal
                                                                                       ELSE inCount
                                                                                  END
                                                       , inHeadCount           := inHeadCount
                                                       , inBoxCount            := inBoxCount
                                                       , inBoxNumber           := CASE WHEN vbMovementDescId <> zc_Movement_Sale() THEN 0 ELSE  1 + COALESCE ((SELECT MAX (MovementItemFloat.ValueData) FROM MovementItem INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id AND MovementItemFloat.DescId = zc_MIFloat_BoxNumber() WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE), 0) END
                                                       , inLevelNumber         := 0
                                                       , inPrice               := CASE -- цена для Специй
                                                                                       WHEN inBranchCode = 301 AND vbPrice_301 > 0 AND vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                            THEN vbPrice_301
                                                                                       -- в первую очередь - если Возврат + Акция
                                                                                       WHEN vbMovementDescId = zc_Movement_ReturnIn() AND inMovementId_Promo > 0
                                                                                            THEN vbPricePromo
                                                                                       -- ?когда схема для Днепра будет как у филиала? - т.е. при продаже - цена из заявки
                                                                                       WHEN vbMovementDescId IN (/**/zc_Movement_Sale(), /**/zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                                                                            AND vbPriceListId_Dnepr <> 0
                                                                                            AND COALESCE (inMovementId_Promo, 0) = 0
                                                                                            THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                                                                                                                        , inPriceListId:= vbPriceListId_Dnepr
                                                                                                                                                                        , inGoodsId    := inGoodsId
                                                                                                                                                                        , inSession    := inSession
                                                                                                                                                                         ) AS tmp), 0)
                                                                                       -- если Возврат
                                                                                       WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                                                            THEN inPrice_Return
                                                                                       WHEN vbMovementDescId = zc_Movement_Sale()
                                                                                            AND vbMovementId_order = 0 -- !!!если НЕ по заявке!!!
                                                                                            THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbOperDate_Dnepr    ELSE vbOperDate    END
                                                                                                                                                                        , inPriceListId:= CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                                                                                                                                        , inGoodsId    := inGoodsId
                                                                                                                                                                        , inSession    := inSession
                                                                                                                                                                         ) AS tmp), 0)
                                                                                       -- иначе из грида
                                                                                       ELSE inPrice
                                                                                  END
                                                       , inCountForPrice       := CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN inCountForPrice_Return ELSE inCountForPrice END
                                                                                  -- (-)% Скидки (+)% Наценки
                                                       , inChangePercent       := vbChangePercent
                                                       , inPartionGoods        := inPartionGoods
                                                       , inPartionGoodsDate    := NULL
                                                       , inGoodsKindId         := CASE WHEN (SELECT View_InfoMoney.InfoMoneyDestinationId
                                                                                             FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                                                  LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                                             WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                                                                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                                                            ) IN (zc_Enum_InfoMoneyDestination_20500() -- Общефирменные + Оборотная тара
                                                                                                , zc_Enum_InfoMoneyDestination_20600() -- Общефирменные + Прочие материалы
                                                                                                 )
                                                                                            THEN 0
                                                                                       ELSE inGoodsKindId
                                                                                  END
                                                       , inPriceListId         := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                       , inBoxId               := vbBoxId
                                                       , inMovementId_Promo    := COALESCE (inMovementId_Promo, 0)
                                                       , inIsBarCode           := CASE WHEN inSession = '5' THEN TRUE ELSE inIsBarCode END
                                                       , inSession             := inSession
                                                        );

     --
     vbTotalSumm:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_TotalSumm());

-- !!! ВРЕМЕННО !!!
if inSession = '5' AND 1=1
then
    RAISE EXCEPTION 'Admin - Test = OK  Amount = <%> Price = <%>'
                  , (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = vbId)
                  , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId AND MIF.DescId = zc_MIFloat_Price())
                   ;
    -- 'Повторите действие через 3 мин.'
end if;

     -- Результат
     RETURN QUERY
       SELECT vbId, vbTotalSumm;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.11.15                                        *
 10.05.15                                        * all
 13.10.14                                        * all
 13.03.14         *
*/

-- тест
-- SELECT * FROM gpInsert_Scale_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
