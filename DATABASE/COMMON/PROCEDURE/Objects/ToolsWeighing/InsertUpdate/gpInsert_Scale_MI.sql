-- Function: gpInsert_Scale_MI()

-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TFloat, TFloat, TFloat, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                         , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                         , TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar
                                         , Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean
                                         , TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);*/
/*DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                         , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                         , Integer, Integer, TDateTime, TDateTime, TFloat, TFloat
                                         , TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar
                                         , Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean
                                         , TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);*/
DROP FUNCTION IF EXISTS gpInsert_Scale_MI (Integer, Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat
                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                         , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                         , Integer, Integer, TDateTime, TDateTime, TFloat, TFloat
                                         , TFloat, TFloat, TFloat, TFloat, Integer, TFloat, TFloat, TFloat, Integer, TVarChar
                                         , Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean
                                         , TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Scale_MI(
    IN inId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inGoodsKindId           Integer   , -- Виды товаров
    IN inPartionGoodsDate      TDateTime , -- Партия товара (дата)
    IN inIsPartionGoodsDate    Boolean   , --
    IN inRealWeight            TFloat    , -- Реальный вес (без учета: минус тара и % скидки для кол-ва)
    IN inChangePercentAmount   TFloat    , -- % скидки для кол-ва
    IN inCountTare             TFloat    , -- Количество тары
    IN inWeightTare            TFloat    , -- Вес 1-ой тары

    IN inCountTare1            TFloat    , -- Количество ящ. вида1
    IN inWeightTare1           TFloat    , -- Вес ящ. вида1
    IN inCountTare2            TFloat    , -- Количество ящ. вида2
    IN inWeightTare2           TFloat    , -- Вес ящ. вида2
    IN inCountTare3            TFloat    , -- Количество ящ. вида3
    IN inWeightTare3           TFloat    , -- Вес ящ. вида3
    IN inCountTare4            TFloat    , -- Количество ящ. вида4
    IN inWeightTare4           TFloat    , -- Вес ящ. вида4
    IN inCountTare5            TFloat    , -- Количество ящ. вида5
    IN inWeightTare5           TFloat    , -- Вес ящ. вида5
    IN inCountTare6            TFloat    , -- Количество ящ. вида6
    IN inWeightTare6           TFloat    , -- Вес ящ. вида6
    IN inCountTare7            TFloat    , -- Количество ящ. вида7
    IN inWeightTare7           TFloat    , -- Вес ящ. вида7
    IN inCountTare8            TFloat    , -- Количество ящ. вида8
    IN inWeightTare8           TFloat    , -- Вес ящ. вида8
    IN inCountTare9            TFloat    , -- Количество ящ. вида9
    IN inWeightTare9           TFloat    , -- Вес ящ. вида9
    IN inCountTare10           TFloat    , -- Количество ящ. вида10
    IN inWeightTare10          TFloat    , -- Вес ящ. вида10

    IN inTareId_1              Integer   , --
    IN inTareId_2              Integer   , --
    IN inTareId_3              Integer   , --
    IN inTareId_4              Integer   , --
    IN inTareId_5              Integer   , --
    IN inTareId_6              Integer   , --
    IN inTareId_7              Integer   , --
    IN inTareId_8              Integer   , --
    IN inTareId_9              Integer   , --
    IN inTareId_10             Integer   , --

    IN inPartionCellId         Integer   , --
    IN inSubjectDocId          Integer   , --

    -- Партия-Пересорт
    IN inGoodsId_out           Integer   , --
    IN inGoodsKindId_out       Integer   , --
    IN inPartionDate_out       TDateTime , --
    IN inPartionDate_in        TDateTime , --
    IN inAmount_in_calc        TFloat    , --
    IN inAmount_out_calc       TFloat    , --

    IN inPrice                 TFloat    , -- Цена
    IN inPrice_Return          TFloat    , -- Цена или !!!Цена по спецификации!!!
    IN inCountForPrice         TFloat    , -- Цена за количество или !!!Количество у поставщика!!!
    IN inCountForPrice_Return  TFloat    , -- Цена за количество
    IN inDayPrior_PriceReturn  Integer,
    IN inCount                 TFloat    , -- Количество пакетов или Количество батонов или Кол-во втулок (склад Специй) или Кол-во для Печати ЭТИКЕТОК
    IN inHeadCount             TFloat    , --
    IN inBoxCount              TFloat    , -- !!!или Цена поставщика
    IN inBoxCode               Integer   , --
    IN inPartionGoods          TVarChar  , -- Партия
    IN inPriceListId           Integer   , --
    IN inBranchCode            Integer   , --
    IN inMovementId_Promo      Integer   , --
    IN inReasonId              Integer   , --
    IN inAssetId               Integer   , --
    IN inIsReason              Boolean   , -- Причина возврата / перемещения или !!!без оплаты - Кол-во контрагента!!!
    IN inIsAsset               Boolean   , -- Выработка на оборудовании или !!!Расчет цены с НДС или без!!!
    IN inIsBarCode             Boolean   , --

    IN inIsAmountPartnerSecond Boolean   , -- без оплаты да/нет - Кол-во поставщика
    IN inIsPriceWithVAT        Boolean   , -- Цена с НДС да/нет - для цена поставщика
    IN inOperDate_ReturnOut    TDateTime , -- Дата для цены возврат поставщику
    IN inPricePartner          TFloat    , -- цена поставщика - из накладной - ввод в контроле
    IN inPriceIncome           TFloat    , -- цена по спецификации
    IN inAmountPartnerSecond   TFloat    , -- Кол-во поставщика - из накладной
    IN inSummPartner           TFloat    , -- Сумма поставщика - из накладной
    IN inIsDocPartner          Boolean   , -- Приход от поставщика - документ поставщика

    IN inIP                    TVarChar,

    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id          Integer
             , TotalSumm   TFloat
             , TotalSummPartner TFloat
             , MessageText Text
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId        Integer;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbMovementDescId   Integer;
   DECLARE vbMovementId_order Integer;
   DECLARE vbBoxId     Integer;
   DECLARE vbTotalSumm TFloat;
   DECLARE vbTotalSummPartner TFloat;
   DECLARE vbRetailId  Integer;
   DECLARE vbToId      Integer;
   DECLARE vbContactId Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbGoodsPropertyId Integer;
   DECLARE vbMeasureId Integer;

   DECLARE vbWeightTotal    TFloat;
   DECLARE vbWeightPack     TFloat;
   DECLARE vbAmount_byPack  TFloat;
   DECLARE vbRealWeight_get TFloat;

   DECLARE vbPriceListId_Dnepr Integer;
   DECLARE vbOperDate_Dnepr    TDateTime;

   DECLARE vbPricePromo            TFloat;
   DECLARE vbIsChangePercent_Promo Boolean;
   DECLARE vbChangePercent         TFloat;

   DECLARE vbMovementId_Income_find Integer;

   DECLARE vbRemainsCount_check TFloat;

   DECLARE vbPrice_301                 TFloat; -- !!!цена для Специй или для Сырья - цена ввод в контроле или по спецификации!!!
   DECLARE vbPrice_301_check           TFloat; -- !!!цена для Сырья - по спецификации!!!
   DECLARE vbPrice_301_notVat_check    TFloat; -- !!!цена для Сырья - по спецификации!!!
   DECLARE vbPrice_301_addVat_check    TFloat; -- !!!цена для Сырья - по спецификации!!!

   DECLARE vbWeight_goods              TFloat;
   DECLARE vbWeightTare_goods          TFloat;
   DECLARE vbCountForWeight_goods      TFloat;
   DECLARE vbAmount_byWeightTare_goods TFloat;

   DECLARE vbOperDate_StartBegin TDateTime;
   DECLARE vbMessageText         Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Scale_MI());
     vbUserId:= lpGetUserBySession (inSession);


-- IF inBranchCode BETWEEN 201 AND 210 AND COALESCE (inBoxCount, 0) = 0 THEN inBoxCount:= 1; END IF;

     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- проверка
     IF inRealWeight > 1000000 AND inBranchCode NOT IN (301, 302, 303) -- Склад специй ...
     THEN
         RAISE EXCEPTION 'Ошибка Вес <%>.', inRealWeight;
     END IF;


     -- !!!замена, приходит вес - из него получаем м. или шт.
     /*IF EXISTS (SELECT FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId NOT IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
     THEN
         inOperCount:= (WITH tmpWeight AS (SELECT OF_Weight.ValueData FROM ObjectFloat AS OF_Weight WHERE OF_Weight.ObjectId = inGoodsId AND OF_Weight.DescId = zc_ObjectFloat_Goods_Weight())
                        SELECT CASE WHEN tmpWeight.ValueData > 0 THEN tmp.OperCount / tmpWeight.ValueData ELSE tmp.OperCount
                        FROM (SELECT inOperCount AS OperCount) AS tmp
                             CROSS JOIN tmpWeight ON tmpWeight
                       );
     END IF;*/


      -- проверка, т.к. несколько записей
      IF 1 < (SELECT COUNT(*) FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure())
      THEN
         RAISE EXCEPTION 'Ошибка.Записей у <%> для Ед.измерения = <%>.'
                       , lfGet_Object_ValueData (inGoodsId)
                       , (SELECT COUNT(*) FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure())
                        ;
      END IF;
      -- определили
      vbMeasureId:= (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure());

     -- определили
     SELECT Movement.OperDate, MovementFloat.ValueData :: Integer, COALESCE (MLM_Order.MovementChildId, 0)
          , ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
          , MovementLinkObject_From.ObjectId          AS UnitId
          , MovementLinkObject_To.ObjectId            AS ToId
          , MovementLinkObject_Contract.ObjectId       AS ContactId
            INTO vbOperDate, vbMovementDescId, vbMovementId_order, vbRetailId, vbUnitId, vbToId, vbContactId
     FROM Movement
          LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDesc()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId      = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId      = zc_MovementLinkObject_To()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_To.ObjectId
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
     WHERE Movement.Id = inMovementId;


     -- проверка
     IF inIsReason = TRUE AND (vbMovementDescId = zc_Movement_ReturnIn()
                                -- Склады База + Реализации + Возвраты общие
                             OR (vbMovementDescId = zc_Movement_SendOnPrice() AND inBranchCode = 1 AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId IN (8457, 8460) AND OL.DescId = zc_ObjectLink_Unit_Parent() AND OL.ChildObjectId = vbToId))
                              )
        AND COALESCE (inReasonId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Причина возврат>.';
     END IF;


     -- проверка
     IF COALESCE (inHeadCount, 0) = 0 AND vbMovementDescId = zc_Movement_Income()
        AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inGoodsId AND OB.DescId = zc_ObjectBoolean_Goods_HeadCount() AND OB.ValueData = TRUE)
        AND inIsDocPartner = FALSE
     THEN
         RAISE EXCEPTION 'Ошибка.Не определено значение <Кол-во голов>.';
     END IF;


     -- проверка
     IF vbUnitId = 8451 -- ЦЕХ упаковки
        AND vbToId = 8459 -- Розподільчий комплекс
        AND inGoodsKindId = zc_GoodsKind_Basis()
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав для перемещения вида <%>.', lfGet_Object_ValueData_sh (inGoodsKindId);
     END IF;


     -- если склад Специй + Кол-во втулок - меняем Значение
     IF inBranchCode BETWEEN 301 AND 310 AND 1=0
     THEN
         -- вес для перевода из веса в метры или что-то еще
         vbWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_Weight());
         --
         IF vbWeight_goods > 0
         THEN
             -- Кол. для Веса
             vbCountForWeight_goods:= (SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_CountForWeight());
             IF COALESCE (vbCountForWeight_goods, 0) = 0 THEN vbCountForWeight_goods:= 1; END IF;
             -- вес втулки
             vbWeightTare_goods:= COALESCE ((SELECT O_F.ValueData FROM ObjectFloat AS O_F WHERE O_F.ObjectId = inGoodsId AND O_F.DescId = zc_ObjectFloat_Goods_WeightTare()), 0);

             -- Проверка
             IF 1=0 AND vbWeightTare_goods > 0 AND COALESCE (inCount, 0) = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Не введено кол-во втулок с весом <%>', zfConvert_FloatToString (vbWeightTare_goods);
             END IF;
             -- если все-таки втулки нет
             IF inCount < 0 THEN inCount:= 0; END IF;

             IF vbMeasureId IN (zc_Measure_Sht() -- шт.
                               )
             THEN
                 -- меняем Значение - перевод из веса в метры или что-то еще ... и вычитаем втулки
                 vbAmount_byWeightTare_goods:= ROUND (vbCountForWeight_goods * (inRealWeight - vbWeightTare_goods * inCount) / vbWeight_goods);
             ELSE
                 -- меняем Значение - перевод из веса в метры или что-то еще ... и вычитаем втулки
                 vbAmount_byWeightTare_goods:= vbCountForWeight_goods * (inRealWeight - vbWeightTare_goods * inCount) / vbWeight_goods;
             END IF;

             -- Проверка
             IF vbAmount_byWeightTare_goods <= 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Расчетное кол-во за вычетом веса втулок = <%> Не может быть <= 0.', zfConvert_FloatToString (vbAmount_byWeightTare_goods);
             END IF;

         ELSE
             -- обнулили Кол-во втулок
             inCount:= 0;
         END IF;

     END IF;

     -- если Тара - меняем Значение на 0
     IF inChangePercentAmount <> 0
        AND inBranchCode < 1000
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
        AND inBranchCode < 1000
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
        AND (inBranchCode BETWEEN 301 AND 310 -- Dnepr-SPEC-Zapch
            )
        AND inPricePartner > 0
     THEN
         -- цена
         IF inPriceIncome > 0
         THEN
             -- цена по спецификации
             vbPrice_301:= inPriceIncome; -- inPricePartner;
         ELSE
             -- из накладной - ввод в контроле
             vbPrice_301:= CASE COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()), FALSE)
                                WHEN inIsPriceWithVAT THEN inPricePartner
                                WHEN FALSE AND inIsPriceWithVAT = TRUE  THEN inPricePartner / (1 + COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId =  inMovementId AND MF.DescId = zc_MovementFloat_VATPercent()), 0) / 100)
                                WHEN TRUE  AND inIsPriceWithVAT = FALSE THEN inPricePartner * (1 + COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId =  inMovementId AND MF.DescId = zc_MovementFloat_VATPercent()), 0) / 100)
                           END;
         END IF;
     ELSE

     -- определили !!!только для OBV!!!
     IF vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
        AND (inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
            )
     THEN
         -- цена по спецификации
         vbPrice_301:= inPriceIncome;
         
         -- поиск цена по спецификации - для проверки
         SELECT CASE WHEN inIsPriceWithVAT = TRUE AND vbMovementDescId = zc_Movement_Income()
                     -- 1.1. цена с НДС
                     THEN lpGet.ValuePrice_addVat

                     WHEN inIsPriceWithVAT = FALSE AND vbMovementDescId = zc_Movement_Income()
                     -- 1.1. цена без НДС
                     THEN lpGet.ValuePrice_notVat

                     WHEN lpGet.isPriceWithVAT = TRUE AND vbMovementDescId = zc_Movement_ReturnOut()
                     -- 2.1. цена с НДС
                     THEN lpGet.ValuePrice_addVat

                     WHEN lpGet.isPriceWithVAT = FALSE AND vbMovementDescId = zc_Movement_ReturnOut()
                     -- 2.1. цена без НДС
                     THEN lpGet.ValuePrice_notVat

                     WHEN FALSE = COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT()), FALSE)
                     -- 3.цена без НДС
                     THEN lpGet.ValuePrice_notVat
                     -- 4.цена с НДС
                     ELSE lpGet.ValuePrice_addVat
                END

              , lpGet.ValuePrice_notVat
              , lpGet.ValuePrice_addVat
                --
              , CASE WHEN vbMovementDescId = zc_Movement_ReturnOut()
                      -- замена
                      THEN lpGet.isPriceWithVAT
                      -- нет замены
                      ELSE inIsPriceWithVAT
                END


                INTO vbPrice_301_check
                   , vbPrice_301_notVat_check
                   , vbPrice_301_addVat_check
                     -- замена или нет
                   , inIsPriceWithVAT

         FROM lpGet_MovementItem_ContractGoods (inOperDate    := CASE WHEN vbMovementDescId = zc_Movement_ReturnOut() THEN inOperDate_ReturnOut ELSE vbOperDate END
                                              , inJuridicalId := 0
                                              , inPartnerId   := 0
                                              , inContractId  := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                              , inGoodsId     := 0
                                              , inUserId      := vbUserId
                                               ) AS lpGet
         WHERE lpGet.GoodsId = inGoodsId
         ORDER BY COALESCE (lpGet.ValuePrice_notVat, 0) DESC
         LIMIT 1
         ;


         -- замена, т.к. в гриде не считается на дату
         IF vbMovementDescId IN (zc_Movement_ReturnOut())
         THEN
             vbPrice_301:= CASE WHEN inIsPriceWithVAT = TRUE THEN vbPrice_301_addVat_check ELSE vbPrice_301_notVat_check END;
         END IF;

                         

         -- Проверка - 1
         IF (vbPrice_301 <> vbPrice_301_notVat_check AND vbPrice_301 <> vbPrice_301_addVat_check AND vbPrice_301_check > 0)
            -- не Документ поставщика
            AND COALESCE (inPricePartner, 0) = 0
            --
            -- AND vbUserId IN (5)
            -- AND 1=0
         THEN
             RAISE EXCEPTION 'Ошибка.Цена документа = <%> не соответствует цене по спецификации = <%> или <%>.%Договор = <%>(%).%Дата = <%>.%с НДС = <%> + <%>'
                            , zfConvert_FloatToString (vbPrice_301)
                            , zfConvert_FloatToString (vbPrice_301_notVat_check)
                            , zfConvert_FloatToString (vbPrice_301_addVat_check)
                            , CHR (13)
                            , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract()))
                            , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                            , CHR (13)
                            , zfConvert_DateToString (CASE WHEN vbMovementDescId = zc_Movement_ReturnOut() THEN inOperDate_ReturnOut ELSE vbOperDate END)
                            , CHR (13)
                            , inIsPriceWithVAT
                            , (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                             ;
         END IF;

         -- Проверка - 2
         IF (vbPrice_301 <> vbPrice_301_check AND vbPrice_301_check > 0) 
            -- ДА Документ поставщика
            AND inPricePartner <> 0
            --
            -- AND vbUserId IN (5)
            -- AND 1=0
         THEN
             RAISE EXCEPTION 'Ошибка.Цена документа = <%> не соответствует цене по спецификации = <%>.%Договор = <%>(%).%Дата = <%>.%с НДС = <%>'
                            , zfConvert_FloatToString (vbPrice_301)
                            , zfConvert_FloatToString (vbPrice_301_check)
                            , CHR (13)
                            , lfGet_Object_ValueData ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract()))
                            , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                            , CHR (13)
                            , zfConvert_DateToString (vbOperDate)
                            , CHR (13)
                            , (SELECT MB.ValueData FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_PriceWithVAT())
                             ;
         END IF;

         -- Проверка
         IF COALESCE (inPriceIncome, 0) <= 0 AND vbMovementDescId = zc_Movement_Income()
            -- Отменили проверку
            AND 1=0
            --
            AND NOT EXISTS (SELECT 1
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
             RAISE EXCEPTION 'Ошибка.Цена по спецификации = 0.';
         END IF;

     ELSE
     -- определили !!!только для Днепра!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
        AND (inBranchCode = 1                 -- Dnepr
          OR inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
          OR inBranchCode BETWEEN 301 AND 310 -- иногда Dnepr-SPEC-Zapch
            )
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
                                                   , inOperDatePartner:= CASE WHEN 1=0 AND inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
                                                                                   THEN (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                              WHEN vbMovementId_order <> 0
                                                                                   THEN NULL
                                                                              ELSE (SELECT tmpOperDate.OperDate FROM gpGet_Scale_OperDate (inIsCeh:= FALSE, inBranchCode:= inBranchCode, inSession:= inSession) AS tmpOperDate)
                                                                         END
                                                   , inDayPrior_PriceReturn:= inDayPrior_PriceReturn
                                                   , inIsPrior        := FALSE -- !!!отказались от старых цен!!!
                                                   , inOperDatePartner_order:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_order AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                    ) AS tmp;
     END IF;
     END IF;
     END IF;
     END IF;


     -- только для ReturnIn ВСЕГДА - определили (-)% Скидки (+)% Наценки
     vbChangePercent:= CASE WHEN COALESCE (vbIsChangePercent_Promo, TRUE) = TRUE AND vbMovementDescId = zc_Movement_ReturnIn()
                                 THEN COALESCE ((SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.MovementId = inMovementId AND MF.DescId = zc_MovementFloat_ChangePercent()), 0)
                            ELSE 0
                       END;

     -- определили
     -- vbBoxId:= CASE WHEN inBoxCode > 0 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBoxCode AND Object.DescId = zc_Object_Box()) ELSE 0 END;
     --
     IF NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO WHERE MLO.DescId = inMovementId AND MLO.DescId = zc_MovementLinkObject_GoodsProperty() AND MLO.ObjectId > 0)
     THEN
         -- нашли
         vbGoodsPropertyId:= zfCalc_GoodsPropertyId ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                                   , (SELECT OL_Juridical.ChildObjectId FROM MovementLinkObject AS MLO LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical() WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                   , (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                                    );
         -- !!!записали св-во
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_GoodsProperty(), inMovementId, vbGoodsPropertyId);

     ELSE
         vbGoodsPropertyId:= (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = inMovementId AND MLO.DescId = zc_MovementLinkObject_GoodsProperty());
     END IF;
     -- определили
     vbBoxId:= (SELECT ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                FROM ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId      = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId        = zc_ObjectLink_GoodsPropertyValue_Goods()
                                          AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId      = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId = inGoodsKindId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                           ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                          AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                WHERE ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
                  AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId        = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
               );


     -- определили Вес 1 ед. продукции + упаковка AND Вес упаковки для 1-ой ед. продукции
     SELECT ObjectFloat_WeightPackage.ValueData

          , CASE WHEN inBranchCode > 1000
                      -- не нужно значение
                      THEN 0
                 ELSE ObjectFloat_WeightTotal.ValueData
            END

          , CASE WHEN ObjectFloat_WeightTotal.ValueData   <> 0
                  AND ObjectFloat_WeightPackage.ValueData <> 0
                  AND ObjectFloat_WeightTotal.ValueData   > ObjectFloat_WeightPackage.ValueData

                      THEN CASE WHEN inBranchCode > 1000
                                      -- не нужно значение
                                      THEN 0
                                 ELSE (inRealWeight
                                     - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                      ) 
                                    / (1 - ObjectFloat_WeightPackage.ValueData / ObjectFloat_WeightTotal.ValueData)
                            END
                                    

                 ELSE CASE WHEN inBranchCode > 1000
                                -- не нужно значение
                                THEN 0
                           ELSE (inRealWeight
                               - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                )
                      END
            END AS Amount_byPack

            INTO vbWeightPack, vbWeightTotal, vbAmount_byPack

     FROM Object_GoodsByGoodsKind_View
          -- Вес одной упаковки
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
          --
          LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                               AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
     WHERE Object_GoodsByGoodsKind_View.GoodsId     = inGoodsId
       AND Object_GoodsByGoodsKind_View.GoodsKindId = CASE WHEN inBranchCode > 1000
                                                            AND vbMeasureId = zc_Measure_Kg()
                                                                -- !!!Замена для Этикетка + Kg
                                                                THEN inPriceListId 
                                                           ELSE inGoodsKindId
                                                      END
    ;

     -- Замена для Этикетки
     IF inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg()
     THEN
         inCountTare := 1;
          -- Вес одной упаковки
         inWeightTare:= COALESCE (vbWeightPack, 0);
         -- замена, т.к. здесь вес
         vbRealWeight_get:= inChangePercentAmount;
         -- замена
         inChangePercentAmount:= 0;

     ELSEIF inBranchCode > 1000
     THEN
         -- замена - для ШТ. не нужен вес
         inChangePercentAmount:= 0;
     END IF;
     
     IF vbUserId = 5 AND 1=0
     THEN
         RAISE EXCEPTION 'Ошибка.%  %   %   %   %', vbWeightPack, vbWeightTotal, vbAmount_byPack, inGoodsId, inGoodsKindId;
     END IF;


     -- проверка, т.к. несколько записей
     IF 1 < (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inGoodsKindId:= inGoodsKindId
                                                                   , inSession    := inSession
                                                                    ) AS tmp) THEN
        RAISE EXCEPTION 'Ошибка.Записей у <%> <%> <%> <%> <%> <%> для Цена = <%>.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId), lfGet_Object_ValueData (vbPriceListId_Dnepr), lfGet_Object_ValueData (inPriceListId), DATE (vbOperDate_Dnepr), DATE (vbOperDate)
          , (SELECT COUNT(*) FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                   , inPriceListId:= vbPriceListId_Dnepr
                                                                   , inGoodsId    := inGoodsId
                                                                   , inGoodsKindId:= inGoodsKindId
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


     -- проверка кол-во
      IF (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                   THEN vbAmount_byWeightTare_goods

              -- Для Этикетка + Kg
              WHEN inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg() AND vbRealWeight_get > 0
                   THEN vbRealWeight_get - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10

              -- Для Этикетка
              WHEN inBranchCode > 1000 
                   THEN inRealWeight

              WHEN inIsBarCode = TRUE AND vbMeasureId = zc_Measure_Kg()
               AND vbAmount_byPack <> 0
                   THEN vbAmount_byPack

              ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10

         END) < 0
     OR (CASE -- !!!только Для Сканирования Метро!!!
              WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                   THEN vbAmount_byWeightTare_goods

              -- Для Этикетка + Kg
              WHEN inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg() AND vbRealWeight_get > 0
                   THEN vbRealWeight_get - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10

              -- Для Этикетка
              WHEN inBranchCode > 1000 
                   THEN inRealWeight

              WHEN inIsBarCode = TRUE
                   THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)

              WHEN inChangePercentAmount = 0
                   THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)

              WHEN vbRetailId IN (341640, 310854, 310855) -- Фоззі + Фозі + Варус
                   THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                            * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))

              ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                       * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
         END) < 0
     THEN
         RAISE EXCEPTION 'Ошибка.С учетом минуса тары, получился отицательный вес <%> <%>'
                        , zfConvert_FloatToString 
                         (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                    THEN vbAmount_byWeightTare_goods

                               -- Для Этикетка + Kg
                               WHEN inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg()
                                    THEN vbRealWeight_get - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10

                               -- Для Этикетка
                               WHEN inBranchCode > 1000 
                                    THEN inRealWeight

                               WHEN inIsBarCode = TRUE AND vbMeasureId = zc_Measure_Kg()
                                AND vbAmount_byPack <> 0
                                    THEN vbAmount_byPack

                               ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                          END)
                        , zfConvert_FloatToString 
                         (CASE -- !!!только Для Сканирования Метро!!!
                               WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                    THEN vbAmount_byWeightTare_goods

                               -- Для Этикетка + Kg
                               WHEN inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg()
                                    THEN vbRealWeight_get - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                 
                               -- Для Этикетка
                               WHEN inBranchCode > 1000 
                                    THEN inRealWeight

                               WHEN inIsBarCode = TRUE
                                    THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)

                               WHEN inChangePercentAmount = 0
                                    THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)

                               WHEN vbRetailId IN (341640, 310854, 310855) -- Фоззі + Фозі + Варус
                                    THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                             * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))

                               ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                        * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
                          END)
                         ;
     END IF;


     -- старт
     vbMessageText:= '';

     -- проверка
     IF (vbMovementDescId = zc_Movement_Sale()
         OR (vbMovementDescId = zc_Movement_SendOnPrice()
             AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId IN (8457, 8460) AND OL.DescId = zc_ObjectLink_Unit_Parent() AND OL.ChildObjectId = vbUnitId)
            )
        )
        AND inBranchCode IN (1)
        AND (zfCheck_Time_ExceptionOn_Remains() = TRUE
         OR vbUserId = 5
            )
        AND vbUserId <> 5
     THEN
         -- Нашли остаток
         vbRemainsCount_check:= (SELECT SUM (Container.Amount)
                                 FROM Container
                                      LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                    ON CLO_GoodsKind.ContainerId = Container.Id
                                                                   AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                 WHERE Container.DescId                     = zc_Container_Count()
                                   AND Container.ObjectId                   = inGoodsId
                                   AND Container.WhereObjectId              = vbUnitId
                                   AND COALESCE (CLO_GoodsKind.ObjectId, 0) = inGoodsKindId
                                );

         IF vbRemainsCount_check < (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                              THEN vbAmount_byWeightTare_goods
                                         WHEN inIsBarCode = TRUE AND vbMeasureId = zc_Measure_Kg()
                                          AND vbAmount_byPack <> 0
                                              THEN vbAmount_byPack
                                         ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                    END)

         THEN
             -- Результат
             vbMessageText:=       'Ошибка.Нельзя провести кол-во = '
                           ||'<' || zfConvert_FloatToString (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                       THEN vbAmount_byWeightTare_goods
                                                                  WHEN inIsBarCode = TRUE AND vbMeasureId = zc_Measure_Kg()
                                                                   AND vbAmount_byPack <> 0
                                                                       THEN vbAmount_byPack
                                                                  ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                                             END)
                                                             || '>'
                                 || CHR (13)
                                 || 'Остаток'
                                 || ' = ' || zfConvert_FloatToString (CASE WHEN vbRemainsCount_check < 0 THEN 0 ELSE vbRemainsCount_check END)
                                          || lfGet_Object_ValueData_sh (vbMeasureId)
                                 || CHR (13)
                                 || 'на подразделении <'  || lfGet_Object_ValueData_sh (vbUnitId) || '>'
                                  ;

             /*RAISE EXCEPTION 'Ошибка.Нельзя провести кол-во = <%>.%Остаток на подразделении <%> = <%>%.'
                                 , zfConvert_FloatToString (CASE WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                       THEN vbAmount_byWeightTare_goods
                                                                  WHEN inIsBarCode = TRUE AND zc_Measure_Kg() = (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure())
                                                                   AND vbAmount_byPack <> 0
                                                                       THEN vbAmount_byPack
                                                                  ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                                             END)
                                 , CHR (13)
                                 , lfGet_Object_ValueData_sh (vbUnitId)
                                 , zfConvert_FloatToString (CASE WHEN vbRemainsCount_check < 0 THEN 0 ELSE vbRemainsCount_check END)
                                 , lfGet_Object_ValueData_sh ((SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND DescId = zc_ObjectLink_Goods_Measure()))
                                  ;*/

         END IF;
     END IF;


     -- Нашли цену из прихода
     IF vbMovementDescId IN (zc_Movement_ReturnOut())
        AND (inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
          OR inBranchCode BETWEEN 301 AND 310 -- Dnepr-SPEC
            )
         -- Нагорная Я.Г. + Баранченко И.И.
        AND vbUserId IN (5, 343013, 80372)
     THEN
         --
         vbMovementId_Income_find:= (SELECT Movement.Id
                                     FROM Movement
                                         INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                                      AND MovementLinkObject_Contract.DescId     = zc_MovementLinkObject_Contract()
                                                                      -- Приход по єтому договору
                                                                      AND MovementLinkObject_Contract.ObjectId   = vbContactId
                                         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                                      -- Приход от этого поставщика
                                                                      AND MovementLinkObject_From.ObjectId   = vbToId

                                     WHERE Movement.OperDate = inOperDate_ReturnOut
                                       AND Movement.DescId   = zc_Movement_Income()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    );

         -- проверка
         IF COALESCE (vbMovementId_Income_find, 0) = 0
         THEN
            RAISE EXCEPTION 'Ошибка.Не найден документ поставщика %<%> %от <%> %договор <%>.'
                          , CHR (13)
                          , lfGet_Object_ValueData_sh (vbToId)
                          , CHR (13)
                          , zfConvert_DateToString (inOperDate_ReturnOut)
                          , CHR (13)
                          , lfGet_Object_ValueData_sh (vbContactId)
                           ;
         END IF;


         -- Нашли цену из прихода
         SELECT MIF_Price.ValueData, CASE WHEN MIF_CountForPrice.ValueData > 0 THEN MIF_CountForPrice.ValueData ELSE 1 END
                INTO vbPrice_301, inCountForPrice
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                               ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                              AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
              -- цена поставщика
              INNER JOIN MovementItemFloat AS MIF_Price
                                           ON MIF_Price.MovementItemId = MovementItem.Id
                                          AND MIF_Price.DescId         = zc_MIFloat_Price()
                                          AND MIF_Price.ValueData      > 0

              LEFT JOIN MovementItemFloat AS MIF_CountForPrice
                                          ON MIF_CountForPrice.MovementItemId = MovementItem.Id
                                         AND MIF_CountForPrice.DescId         = zc_MIFloat_CountForPrice()

         WHERE MovementItem.MovementId = vbMovementId_Income_find
           AND MovementItem.DescId     = zc_MI_Master()
           AND MovementItem.isErased   = FALSE
           AND MovementItem.ObjectId   = inGoodsId
           AND COALESCE (MILO_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId, 0)
        ;


         -- проверка
         IF COALESCE (vbPrice_301, 0) = 0
         THEN
            RAISE EXCEPTION 'Ошибка.Не найден цена для поставщика %<%> %в документе №<%> от <%> %Товар = <%>%.'
                          , CHR (13)
                          , lfGet_Object_ValueData_sh (vbToId)
                          , CHR (13)
                          , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = vbMovementId_Income_find)
                          , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = vbMovementId_Income_find)
                          , CHR (13)
                          , lfGet_Object_ValueData (inGoodsId)
                          , CASE WHEN inGoodsKindId > 0 THEN ' вид = <' || lfGet_Object_ValueData_sh (inGoodsKindId) ||'>' ELSE '' END
                           ;
         END IF;

     END IF;



     -- НЕ Партия-Пересорт
     IF inGoodsId_out > 0 AND inBranchCode = 1 AND inAmount_in_calc > 0 AND vbMovementDescId <> zc_Movement_ProductionUnion()
     THEN
         inGoodsId_out     := 0;
         inAmount_in_calc  := 0;
         inGoodsId_out     := 0;
         inGoodsKindId_out := 0;
         inPartionDate_out := NULL;
         inAmount_out_calc := 0;
     END IF;


     IF vbMessageText = ''
     THEN
         -- сохранили
         vbId:= gpInsertUpdate_MovementItem_WeighingPartner (ioId                  := 0
                                                           , inMovementId          := inMovementId
                                                           , inGoodsId             := inGoodsId
                                                           , inAmount              := CASE WHEN inGoodsId_out > 0 AND inBranchCode = 1
                                                                                                -- Партия-Пересорт
                                                                                                THEN inAmount_in_calc

                                                                                           WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                                                THEN vbAmount_byWeightTare_goods

                                                                                           -- Для Этикетка
                                                                                           WHEN inBranchCode > 1000
                                                                                                THEN inRealWeight

                                                                                           WHEN inIsBarCode = TRUE AND vbMeasureId = zc_Measure_Kg()
                                                                                            AND vbAmount_byPack <> 0
                                                                                                THEN vbAmount_byPack

                                                                                           ELSE inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10
                                                                                      END
                                                           , inAmountPartner       := CASE -- !!!только Для Сканирования Метро!!!
                                                                                           /*WHEN vbRetailId IN (310828) -- Метро
                                                                                                THEN CEIL ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10) * 100) / 100
                                                                                           */
                                                                                           WHEN inGoodsId_out > 0 AND inBranchCode = 1
                                                                                                -- Партия-Пересорт
                                                                                                THEN inAmount_in_calc

                                                                                           WHEN inBranchCode BETWEEN 301 AND 310 AND vbAmount_byWeightTare_goods > 0
                                                                                                THEN vbAmount_byWeightTare_goods

                                                                                           -- Для Этикетка
                                                                                           WHEN inBranchCode > 1000
                                                                                                THEN inRealWeight

                                                                                           -- на филиалах при сканировании, на приход ставим расчетное значение
                                                                                           WHEN inIsBarCode = TRUE AND vbMovementDescId = zc_Movement_SendOnPrice()
                                                                                            AND vbAmount_byPack <> 0
                                                                                                THEN vbAmount_byPack
                                                                                           WHEN inIsBarCode = TRUE
                                                                                                THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                                                                           WHEN inChangePercentAmount = 0
                                                                                                THEN (inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                                                                         --WHEN vbRetailId IN (341640, 310854, 310855) -- Фоззі + Фозі + Варус
                                                                                           WHEN 3 = COALESCE ((SELECT OFl.ValueData FROM ObjectFloat AS OFl WHERE OFl.ObjectId = vbRetailId AND OFl.DescId = zc_ObjectFloat_Retail_RoundWeight()), 0)
                                                                                                THEN CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                                                                                         * (1 - inChangePercentAmount/100) AS NUMERIC (16, 3))
	                                                                                           ELSE CAST ((inRealWeight - inCountTare * inWeightTare - inCountTare1 * inWeightTare1 - inCountTare2 * inWeightTare2 - inCountTare3 * inWeightTare3 - inCountTare4 * inWeightTare4 - inCountTare5 * inWeightTare5 - inCountTare6 * inWeightTare6 - inCountTare7 * inWeightTare7 - inCountTare8 * inWeightTare8 - inCountTare9 * inWeightTare9 - inCountTare10 * inWeightTare10)
                                                                                                    * (1 - inChangePercentAmount/100) AS NUMERIC (16, 2))
                                                                                      END
                                                           , inRealWeight          := CASE WHEN inBranchCode > 1000 AND vbMeasureId = zc_Measure_Kg()
                                                                                                -- Для Этикетка + Kg
                                                                                                THEN vbRealWeight_get
                                                                                           ELSE inRealWeight
                                                                                      END
                                                           , inChangePercentAmount := CASE WHEN inIsBarCode = TRUE
                                                                                                THEN 0
                                                                                           ELSE inChangePercentAmount
                                                                                      END
                                                           , inCountTare           := inCountTare
                                                           , inWeightTare          := inWeightTare
                                                           , inCountTare1          := inCountTare1
                                                           , inWeightTare1         := inWeightTare1
                                                           , inCountTare2          := inCountTare2
                                                           , inWeightTare2         := inWeightTare2
                                                           , inCountTare3          := inCountTare3
                                                           , inWeightTare3         := inWeightTare3
                                                           , inCountTare4          := inCountTare4
                                                           , inWeightTare4         := inWeightTare4
                                                           , inCountTare5          := inCountTare5
                                                           , inWeightTare5         := inWeightTare5
                                                           , inCountTare6          := inCountTare6
                                                           , inWeightTare6         := inWeightTare6
                                                           , inCountTare7          := inCountTare7
                                                           , inWeightTare7         := inWeightTare7
                                                           , inCountTare8          := inCountTare8
                                                           , inWeightTare8         := inWeightTare8
                                                           , inCountTare9          := inCountTare9
                                                           , inWeightTare9         := inWeightTare9
                                                           , inCountTare10         := inCountTare10
                                                           , inWeightTare10        := inWeightTare10

                                                           , inTareId_1            := inTareId_1
                                                           , inTareId_2            := inTareId_2
                                                           , inTareId_3            := inTareId_3
                                                           , inTareId_4            := inTareId_4
                                                           , inTareId_5            := inTareId_5
                                                           , inTareId_6            := inTareId_6
                                                           , inTareId_7            := inTareId_7
                                                           , inTareId_8            := inTareId_8
                                                           , inTareId_9            := inTareId_9
                                                           , inTareId_10           := inTareId_10

                                                           , inPartionCellId       := inPartionCellId

                                                             -- Партия-Пересорт
                                                           , inGoodsId_out         := inGoodsId_out
                                                           , inGoodsKindId_out     := inGoodsKindId_out
                                                           , inPartionDate_out     := inPartionDate_out
                                                           , inAmount_out_calc     := inAmount_out_calc

                                                           , inCountPack           := CASE WHEN inIsBarCode = TRUE AND vbWeightTotal <> 0
                                                                                                THEN vbAmount_byPack / vbWeightTotal
                                                                                           ELSE inCount
                                                                                      END
                                                           , inHeadCount           := inHeadCount
                                                           , inBoxCount            := CASE WHEN inIsBarCode = TRUE THEN 1 WHEN vbUserId IN (5, 602817) AND vbBoxId > 0 THEN 1 ELSE 0 END -- inBoxCount
                                                           , inBoxNumber           := CASE WHEN vbMovementDescId <> zc_Movement_Sale() THEN 0 ELSE  1 + COALESCE ((SELECT MAX (MovementItemFloat.ValueData) FROM MovementItem INNER JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id AND MovementItemFloat.DescId = zc_MIFloat_BoxNumber() WHERE MovementItem.MovementId = inMovementId AND MovementItem.isErased = FALSE), 0) END
                                                           , inLevelNumber         := 0
                                                           , inPrice               := CASE -- для isSticker = TRUE
                                                                                           WHEN inBranchCode > 1000
                                                                                                -- !!!здесь № печати!!!
                                                                                                THEN inPrice

                                                                                           -- цена для Специй
                                                                                           WHEN (inBranchCode BETWEEN 301 AND 310
                                                                                              OR inBranchCode BETWEEN 201 AND 210
                                                                                                )
                                                                                            AND vbPrice_301 > 0 AND vbMovementDescId IN (zc_Movement_Income(), zc_Movement_ReturnOut())
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
                                                                                                                                                                            , inGoodsKindId:= inGoodsKindId
                                                                                                                                                                            , inSession    := inSession
                                                                                                                                                                             ) AS tmp
                                                                                                                WHERE tmp.ValuePrice <> 0
                                                                                                               )
                                                                                                              ,(SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := vbOperDate_Dnepr
                                                                                                                                                                            , inPriceListId:= vbPriceListId_Dnepr
                                                                                                                                                                            , inGoodsId    := inGoodsId
                                                                                                                                                                            , inGoodsKindId:= NULL
                                                                                                                                                                            , inSession    := inSession
                                                                                                                                                                             ) AS tmp
                                                                                                                WHERE tmp.ValuePrice <> 0
                                                                                                               )
                                                                                                              , 0)
                                                                                           -- если Возврат
                                                                                           WHEN vbMovementDescId = zc_Movement_ReturnIn()
                                                                                                THEN inPrice_Return
                                                                                           WHEN vbMovementDescId = zc_Movement_Sale()
                                                                                                AND vbMovementId_order = 0 -- !!!если НЕ по заявке!!!
                                                                                                THEN COALESCE ((SELECT tmp.ValuePrice FROM gpGet_ObjectHistory_PriceListItem (inOperDate   := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbOperDate_Dnepr    ELSE vbOperDate    END
                                                                                                                                                                            , inPriceListId:= CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                                                                                                                                            , inGoodsId    := inGoodsId
                                                                                                                                                                            , inGoodsKindId:= inGoodsKindId
                                                                                                                                                                            , inSession    := inSession
                                                                                                                                                                             ) AS tmp), 0)
                                                                                           -- иначе из грида
                                                                                           ELSE inPrice
                                                                                      END
                                                           , inCountForPrice       := CASE WHEN vbMovementDescId = zc_Movement_ReturnIn() THEN inCountForPrice_Return ELSE inCountForPrice END
                                                                                      -- (-)% Скидки (+)% Наценки
                                                           , inChangePercent       := vbChangePercent
                                                           , inPartionGoods        := inPartionGoods
                                                           , inPartionGoodsDate    := CASE WHEN inGoodsId_out > 0 AND inBranchCode = 1
                                                                                                -- Партия-Пересорт
                                                                                                THEN inPartionDate_in

                                                                                           WHEN inIsPartionGoodsDate = TRUE
                                                                                                THEN inPartionGoodsDate

                                                                                           ELSE NULL
                                                                                      END

                                                           , inGoodsKindId         := CASE WHEN inBranchCode > 1000
                                                                                                -- !!!здесь StickerPack!!!
                                                                                                THEN inGoodsKindId

                                                                                           WHEN (SELECT View_InfoMoney.InfoMoneyDestinationId
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
                                                           , inPriceListId         := CASE WHEN inBranchCode > 1000
                                                                                                -- !!!здесь GoodsKindId - из StickerProperty!!!
                                                                                                THEN inPriceListId

                                                                                           WHEN vbPriceListId_Dnepr <> 0
                                                                                                THEN vbPriceListId_Dnepr
                                                                                           ELSE inPriceListId
                                                                                      END

                                                           , inBoxId               := CASE WHEN inIsBarCode = TRUE AND vbBoxId > 0 THEN vbBoxId
                                                                                           WHEN vbUserId IN (5, 602817) AND vbBoxId > 0 THEN vbBoxId
                                                                                           WHEN inIsBarCode = TRUE THEN CASE WHEN inBoxCode > 0 THEN (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inBoxCode AND Object.DescId = zc_Object_Box() AND inBoxCode > 0 ORDER BY 1 LIMIT 1) ELSE 0 END
                                                                                           ELSE 0
                                                                                      END
                                                           , inMovementId_Promo    := COALESCE (inMovementId_Promo, 0)
                                                           , inIsBarCode           := inIsBarCode -- CASE WHEN vbUserId = 5 THEN TRUE ELSE inIsBarCode END
                                                           , inBranchCode          := inBranchCode
                                                           , inSession             := inSession
                                                            );

         -- дописали св-во 
         IF inSubjectDocId > 0
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SubjectDoc(), vbId, inSubjectDocId);
         END IF;


         -- дописали св-во для SPEC
         IF vbMovementDescId IN (zc_Movement_Income())
            AND (inBranchCode BETWEEN 301 AND 310 -- Dnepr-SPEC
                )
         THEN
             -- Количество у поставщика - из накладной
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), vbId, inAmountPartnerSecond);
             -- без оплаты да/нет - Кол-во поставщика
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), vbId, inIsAmountPartnerSecond);

             -- цена поставщика для Сырья - из накладной
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), vbId, inPricePartner);
             -- Цена с НДС да/нет - для цена поставщика
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), vbId, inIsPriceWithVAT);

             IF inSummPartner > 0
             THEN
                 -- Сумма у поставщика - из накладной
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPartner(), vbId, inSummPartner);
             END IF;

             -- сохранили протокол
             PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, FALSE);

         -- дописали св-во для OBV
         ELSEIF vbMovementDescId IN (zc_Movement_ReturnOut())
            AND (inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
                )
         THEN
             -- Цена с НДС да/нет - для цена поставщика
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), vbId, inIsPriceWithVAT);
         END IF;


         -- дописали св-во для OBV - Sale
         IF vbMovementDescId IN (zc_Movement_Sale())
            AND inBranchCode BETWEEN 201 AND 204 -- Dnepr-OBV
         THEN
             -- IP
             PERFORM lpInsertUpdate_MovementItemString (zc_MIString_IP(), vbId, inIP);
             -- сохранили протокол
             PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, FALSE);
         END IF;


         -- дописали св-во для OBV
         IF vbMovementDescId IN (zc_Movement_Income())
            AND inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
         THEN
             -- Количество у поставщика - из накладной
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartnerSecond(), vbId, inAmountPartnerSecond);
             -- без оплаты да/нет - Кол-во поставщика
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_AmountPartnerSecond(), vbId, inIsAmountPartnerSecond);

             -- цена поставщика для Сырья - из накладной
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PricePartner(), vbId, inPricePartner);
             -- Цена с НДС да/нет - для цена поставщика
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PriceWithVAT(), vbId, inIsPriceWithVAT);

             IF inSummPartner > 0
             THEN
                 -- Сумма у поставщика - из накладной
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPartner(), vbId, inSummPartner);
             END IF;

             -- сохранили протокол
             PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, FALSE);

         END IF;

         -- дописали св-во для DOC
         IF inIsDocPartner = TRUE AND NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner() AND MB.ValueData = FALSE)
         THEN
             -- сохранили свойство <Документ поставщика (да/нет)>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DocPartner(), inMovementId, FALSE);

             -- сохранили протокол
             PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

         ELSEIF inIsDocPartner = FALSE AND EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_DocPartner())
         THEN
             -- !!!УДАЛЕНИЕ
             DELETE FROM MovementBoolean WHERE MovementBoolean.MovementId = inMovementId AND MovementBoolean.DescId = zc_MovementBoolean_DocPartner();

         END IF;

         IF vbMovementDescId IN (zc_Movement_ReturnOut())
            AND (inBranchCode BETWEEN 201 AND 210 -- Dnepr-OBV
                )
         THEN
             -- Дата для цены возврат поставщику
             PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PriceRetOut(), vbId, inOperDate_ReturnOut);
             -- сохранили протокол
             PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, FALSE);

         END IF;


         --
         vbTotalSumm:= (SELECT ValueData FROM MovementFloat WHERE MovementId = inMovementId AND DescId = zc_MovementFloat_TotalSumm());

         -- Итого Сумма с ндс - поставщика - Dnepr-OBV
         IF vbMovementDescId IN (zc_Movement_Income()) AND (inBranchCode BETWEEN 201 AND 210)
         THEN
             vbTotalSummPartner:= (WITH tmpMI AS (SELECT SUM (COALESCE (MIF_AmountPartnerSecond.ValueData, 0))AS AmountPartner
                                                       , SUM (COALESCE (MIFloat_SummPartner.ValueData, 0))    AS SummPartner
                                                       , COALESCE (MIF_PricePartner.ValueData, 0)             AS PricePartner
                                                       , COALESCE (MIB_PriceWithVAT.ValueData, FALSE)         AS isPriceWithVAT
                                                       , MovementItem.ObjectId                                AS GoodsId
                                                       , COALESCE (MILO_GoodsKind.ObjectId, 0)                AS GoodsKindId
                                                  FROM MovementItem
                                                       LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                                        ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                                       AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                                       -- цена поставщика для Сырья - из накладной
                                                       LEFT JOIN MovementItemFloat AS MIF_PricePartner
                                                                                   ON MIF_PricePartner.MovementItemId = MovementItem.Id
                                                                                  AND MIF_PricePartner.DescId         = zc_MIFloat_PricePartner()
                                                       -- Количество у поставщика - из накладной
                                                       LEFT JOIN MovementItemFloat AS MIF_AmountPartnerSecond
                                                                                   ON MIF_AmountPartnerSecond.MovementItemId = MovementItem.Id
                                                                                  AND MIF_AmountPartnerSecond.DescId         = zc_MIFloat_AmountPartnerSecond()

                                                       -- Цена с НДС да/нет - для цена поставщика
                                                       LEFT JOIN MovementItemBoolean AS MIB_PriceWithVAT
                                                                                     ON MIB_PriceWithVAT.MovementItemId = MovementItem.Id
                                                                                    AND MIB_PriceWithVAT.DescId         = zc_MIBoolean_PriceWithVAT()
                                                       --  Сумма Поставщика
                                                       LEFT JOIN MovementItemFloat AS MIFloat_SummPartner
                                                                                   ON MIFloat_SummPartner.MovementItemId = MovementItem.Id
                                                                                  AND MIFloat_SummPartner.DescId         = zc_MIFloat_SummPartner()

                                                  WHERE MovementItem.MovementId = inMovementId
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                                                  GROUP BY COALESCE (MIF_PricePartner.ValueData, 0)
                                                         , COALESCE (MIB_PriceWithVAT.ValueData, FALSE)
                                                         , MovementItem.ObjectId
                                                         , COALESCE (MILO_GoodsKind.ObjectId, 0)
                                                 )
                                 , tmpMI_summ AS (SELECT CASE WHEN tmpMI.SummPartner <> 0 THEN tmpMI.SummPartner
                                                              ELSE CAST (tmpMI.AmountPartner * tmpMI.PricePartner AS NUMERIC (16, 2))
                                                         END AS Summ_notVat
                                                       , 0 AS Summ_addVat
                                                  FROM tmpMI
                                                  WHERE NOT EXISTS (SELECT 1 FROM tmpMI WHERE tmpMI.isPriceWithVAT = TRUE)

                                                 UNION
                                                  SELECT 0 AS Summ_notVat
                                                       , CASE WHEN tmpMI.SummPartner <> 0 THEN tmpMI.SummPartner
                                                              ELSE CAST (CAST (tmpMI.AmountPartner * tmpMI.PricePartner AS NUMERIC (16, 2))
                                                                       * CASE WHEN tmpMI.isPriceWithVAT = FALSE THEN 1.2 ELSE 1 END
                                                                         AS NUMERIC (16, 2)
                                                                        )
                                                         END AS Summ_addVat
                                                  FROM tmpMI
                                                  WHERE EXISTS (SELECT 1 FROM tmpMI WHERE tmpMI.isPriceWithVAT = TRUE)
                                                 )
                                   --
                                   SELECT -- если все без НДС, здесь добавим
                                          CAST (SUM (tmpMI_summ.Summ_notVat) * 1.2 AS NUMERIC (16, 2))
                                          -- если все с НДС
                                        + SUM (tmpMI_summ.Summ_addVat)
                                   FROM tmpMI_summ
                                  );
         END IF;



         -- дописали св-во <Причина возврата >
         IF inIsReason = TRUE AND (vbMovementDescId = zc_Movement_ReturnIn()
                                   -- Склады База + Реализации + Возвраты общие
                                OR (vbMovementDescId = zc_Movement_SendOnPrice() AND inBranchCode = 1 AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId IN (8457, 8460) AND OL.DescId = zc_ObjectLink_Unit_Parent() AND OL.ChildObjectId = vbToId))
                                  )
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Reason(), vbId, inReasonId);
         END IF;

         -- дописали св-во <Asset >
         IF inIsAsset = TRUE
         THEN
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbId, inAssetId);
         END IF;


         -- дописали св-во <Протокол Дата/время начало>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), vbId, vbOperDate_StartBegin);
         -- дописали св-во <Протокол Дата/время завершение>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), vbId, CLOCK_TIMESTAMP());


         -- !!! ВРЕМЕННО !!!
         IF vbUserId = 5 AND 1=0 -- AND inBranchCode < 1000
         THEN
             RAISE EXCEPTION 'Admin - Test = OK  Amount = <%> Price = <%> HeadCount = <%>'
                           , (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = vbId)
                           , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId AND MIF.DescId = zc_MIFloat_Price())
                           , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = vbId AND MIF.DescId = zc_MIFloat_HeadCount())
                            ;
             -- RAISE EXCEPTION 'Повторите действие через 3 мин.';
         END IF;

     END IF; -- if vbMessageText = ''

     -- Результат
     RETURN QUERY
       SELECT vbId, vbTotalSumm, COALESCE (vbTotalSummPartner, 0) :: TFloat, vbMessageText :: Text MessageText;

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
