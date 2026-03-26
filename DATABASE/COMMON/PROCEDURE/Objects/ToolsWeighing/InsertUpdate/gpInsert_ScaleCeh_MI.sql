-- Function: gpInsert_ScaleCeh_MI()

-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar, Integer, TVarChar);
/*DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat
                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                            , TDateTime, TVarChar, TVarChar, Integer, TVarChar
                                             );*/
/*DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat
                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                            , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                            , TDateTime, TVarChar, TVarChar, Integer, TVarChar
                                             );*/
DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_MI (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat
                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                            , TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat
                                            , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                            , TDateTime, TVarChar, TVarChar, Integer, TVarChar
                                             );

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_MI(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inGoodsKindId         Integer   , -- Виды товаров
    IN inStorageLineId       Integer   , -- Линия пр-ва
    IN inPersonalId_KVK      Integer   , --
    IN inAssetId             Integer   , --
    IN inAssetId_two         Integer   , --
    IN inIsStartWeighing     Boolean   , -- Режим начала взвешивания
    IN inIsPartionGoodsDate  Boolean   , --
    IN inIsAsset             Boolean   , --
    IN inOperCount           TFloat    , -- Количество
    IN inRealWeight          TFloat    , -- Реальный вес (без учета % скидки для кол-ва)
    IN inWeightTare          TFloat    , -- Вес тары
    IN inLiveWeight          TFloat    , -- Живой вес
    IN inHeadCount           TFloat    , -- Количество голов
    IN inCount               TFloat    , -- Количество батонов
    IN inCountPack           TFloat    , -- Количество упаковок
    IN inWeightPack          TFloat    , -- Вес 1-ой упаковки
    IN inCountSkewer1        TFloat    , -- Количество шпажек/крючков вида1
    IN inWeightSkewer1       TFloat    , -- Вес одной шпажки/крючка вида1
    IN inCountSkewer2        TFloat    , -- Количество шпажек вида2
    IN inWeightSkewer2       TFloat    , -- Вес одной шпажки вида2
    IN inWeightOther         TFloat    , -- Вес, прочее

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

    IN inPartionGoodsDate    TDateTime , -- Партия товара (дата)
    IN inPartionGoods        TVarChar  , -- Партия товара
    IN inNumberKVK           TVarChar  , -- № КВК
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- сессия пользователя
)

RETURNS TABLE (Id        Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbId             Integer;
   DECLARE vbDocumentKindId Integer;
   DECLARE vbToId           Integer;
   DECLARE vbUnitId         Integer;
   DECLARE vbMovementDescId Integer;
   DECLARE vbOperDate       TDateTime;
   DECLARE vbMI_Id_check    Integer;

   DECLARE vbWeight_goods              TFloat;
   DECLARE vbWeightTare_goods          TFloat;
   DECLARE vbCountForWeight_goods      TFloat;

   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_ScaleCeh_MI());
     vbUserId:= lpGetUserBySession (inSession);


-- !!!!!!!!!!
-- !!!!!!!!!!
-- IF inGoodsKindId IN (196608, 1869768455) THEN inGoodsKindId:= 0; END IF;
-- !!!!!!!!!!
-- !!!!!!!!!!


     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_StartBegin:= CLOCK_TIMESTAMP();


     -- определили Дату
     vbOperDate:= (SELECT gpGet_Scale_OperDate (inIsCeh       := TRUE
                                              , inBranchCode  := inBranchCode
                                              , inSession     := inSession
                                               ));
     -- заменили Дату
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate = vbOperDate)
        AND inBranchCode < 200
     THEN
         UPDATE Movement SET OperDate = vbOperDate WHERE Movement.Id = inMovementId;
         -- сохранили протокол
         PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);
     END IF;


     -- определили
     SELECT MovementLinkObject_From.ObjectId                AS UnitId
          , MovementLinkObject_To.ObjectId                  AS ToId
          , MovementFloat_MovementDesc.ValueData :: Integer AS MovementDescId
            INTO vbUnitId, vbToId, vbMovementDescId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId      = zc_MovementLinkObject_To()
          LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                  ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                 AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
     WHERE Movement.Id = inMovementId;


     -- проверка
     IF vbUnitId = 8451 -- ЦЕХ упаковки
        AND vbToId = 8459 -- Розподільчий комплекс
        AND inGoodsKindId = zc_GoodsKind_Basis()
        AND EXISTS (SELECT 1 FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
        AND vbUserId <> 5
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав для перемещения вида <%>.', lfGet_Object_ValueData_sh (inGoodsKindId);
     END IF;

     -- проверка
     IF inBranchCode = 101
        -- Реальный вес
        AND inRealWeight > 20
        -- Вес тары
        AND COALESCE (inWeightTare, 0) = 0
          -- Вес шпаг
        AND COALESCE (inCountSkewer1 * inWeightSkewer1, 0) = 0
        AND COALESCE (inCountSkewer2 * inWeightSkewer2, 0) = 0
        -- Прочий вес
        AND COALESCE (inWeightOther, 0) = 0
      --AND vbUserId = 5
     THEN
         RAISE EXCEPTION 'Ошибка.Не введено значение <Вес тары> или <Вес шпаг> или <Прочий вес>.';
     END IF;


     -- !!!замена, приходит вес - из него получаем м. или шт.
     IF 1=1 AND EXISTS (SELECT 1 FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId NOT IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
        AND NOT EXISTS (SELECT 1
                        FROM ObjectLink AS ObjectLink_Goods_InfoMoney
                             INNER JOIN Object_InfoMoney_View AS View_InfoMoney
                                                              ON View_InfoMoney.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                             AND View_InfoMoney.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                                                                                         , zc_Enum_InfoMoneyDestination_20600() -- Прочие материалы
                                                                                                          )
                        WHERE ObjectLink_Goods_InfoMoney.ObjectId = inGoodsId
                          AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                       )
        -- !!!
        AND vbMovementDescId <> zc_Movement_Loss()

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

             IF (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inGoodsId AND OL.DescId = zc_ObjectLink_Goods_Measure())
                IN (zc_Measure_Sht() -- шт.
                   )
             THEN
                 -- меняем Значение - перевод из веса в метры или что-то еще ... и вычитаем втулки
                 inOperCount:= ROUND (vbCountForWeight_goods * (inRealWeight - inWeightTare - vbWeightTare_goods * inCount) / vbWeight_goods);
             ELSE
                 -- меняем Значение - перевод из веса в метры или что-то еще ... и вычитаем втулки
                 inOperCount:= vbCountForWeight_goods * (inRealWeight - inWeightTare - vbWeightTare_goods * inCount) / vbWeight_goods;
             END IF;

             -- Проверка
             IF inOperCount <= 0
             THEN
                 RAISE EXCEPTION 'Ошибка.Расчетное кол-во за вычетом веса втулок = <%> Не может быть <= 0.', zfConvert_FloatToString (inOperCount);
             END IF;

         ELSE
             -- обнулили Кол-во втулок
             inCount:= 0;
         END IF;

     END IF;


     -- определили <Тип документа>
     vbDocumentKindId:= (SELECT CASE WHEN TRIM (tmp.RetV) = '' THEN '0' ELSE TRIM (tmp.RetV) END :: Integer
                         FROM (SELECT gpGet_ToolsWeighing_Value (inLevel1      := 'ScaleCeh_' || inBranchCode
                                                               , inLevel2      := 'Movement'
                                                               , inLevel3      := 'MovementDesc_' || CASE WHEN MovementFloat.ValueData < 10 THEN '0' ELSE '' END || (MovementFloat.ValueData :: Integer) :: TVarChar
                                                               , inItemName    := 'DocumentKindId'
                                                               , inDefaultValue:= '0'
                                                               , inSession     := inSession
                                                                ) AS RetV
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId = inMovementId
                                 AND MovementFloat.DescId = zc_MovementFloat_MovementDescNumber()
                                 AND MovementFloat.ValueData > 0
                              ) AS tmp
                        );
     -- проверка
     IF vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg()
                           , zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()
                            )
     THEN IF zfConvert_StringToNumber (inPartionGoods) = 0
          THEN
              RAISE EXCEPTION 'Ошибка.Партия прозводства ПФ-ГП не определена. <%>', inPartionGoods;
          END IF;
     END IF;
     -- проверка
     IF vbDocumentKindId IN (zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom())
     THEN IF COALESCE (inCount, 0) <= 0
          THEN
              RAISE EXCEPTION 'Ошибка.Кол-во батонов не введено.';
          END IF;
     END IF;
     
     -- проверка
     IF inPartionCellId > 0
     THEN
         vbMI_Id_check:= lpCheck_MI_Send_PartionCell_mi (inPartionCellId   := inPartionCellId
                                                       , inMovementItemId  := 0
                                                       , inGoodsId         := inGoodsId
                                                       , inGoodsKindId     := inGoodsKindId
                                                       , inPartionGoodsDate:= CASE WHEN inIsPartionGoodsDate = TRUE AND COALESCE (vbDocumentKindId, 0) = 0
                                                                                        THEN inPartionGoodsDate
                                                                                   WHEN EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inGoodsId AND OB.DescId = zc_ObjectBoolean_Goods_PLM() AND OB.ValueData = TRUE)
                                                                                        THEN inPartionGoodsDate
                                                                                   ELSE vbOperDate
                                                                              END
                                                       , inUserId          := vbUserId
                                                        );
         IF vbMI_Id_check > 0
         THEN
             RAISE EXCEPTION 'Ошибка.Для ячейки <%> %уже установлена партия <%> % <%> <%> <%>% <%> <%>.%(%)'
                           , lfGet_Object_ValueData (inPartionCellId)
                           , CHR (13)
                           , zfConvert_DateToString ((SELECT COALESCE (MIDate.ValueData, Movement.OperDate)
                                                      FROM MovementItem
                                                           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                           LEFT JOIN MovementItemDate AS MIDate ON MIDate.MovementItemId = vbMI_Id_check AND MIDate.DescId = zc_MIDate_PartionGoods()
                                                      WHERE MovementItem.Id = vbMI_Id_check
                                                     ))
                           , CHR (13)
                           , (SELECT  Movement.InvNumber FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  zfConvert_DateToString (Movement.OperDate) FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId WHERE MI.Id = vbMI_Id_check)
                           , (SELECT  MovementDesc.ItemName FROM MovementItem AS MI JOIN Movement ON Movement.Id = MI.MovementId JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE MI.Id = vbMI_Id_check)
                           , CHR (13)
                           , (SELECT lfGet_Object_ValueData (MI.ObjectId) FROM MovementItem AS MI WHERE MI.Id = vbMI_Id_check)
                           , (SELECT lfGet_Object_ValueData_sh (MILO.Objectid) FROM MovementItemLinkObject AS MILO WHERE MILO.MovementItemId = vbMI_Id_check AND MILO.DescId = zc_MILinkObject_GoodsKind())
                           , CHR (13)
                           , vbMI_Id_check
                            ;
         END IF;

     END IF;

     -- сохранили
     vbId:= gpInsertUpdate_MovementItem_WeighingProduction (ioId                  := 0
                                                          , inMovementId          := inMovementId
                                                          , inGoodsId             := inGoodsId
                                                          , inAmount              := inOperCount
                                                          , inIsStartWeighing     := inIsStartWeighing
                                                          , inRealWeight          := inRealWeight
                                                          , inWeightTare          := inWeightTare
                                                          , inLiveWeight          := inLiveWeight
                                                          , inHeadCount           := inHeadCount
                                                          , inCount               := inCount
                                                          , inCountPack           := inCountPack
                                                          , inWeightPack          := inWeightPack
                                                          , inCountSkewer1        := inCountSkewer1
                                                          , inWeightSkewer1       := inWeightSkewer1
                                                          , inCountSkewer2        := inCountSkewer2
                                                          , inWeightSkewer2       := inWeightSkewer2
                                                          , inWeightOther         := inWeightOther

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

                                                          , inPartionGoodsDate            := CASE WHEN inIsPartionGoodsDate = TRUE AND COALESCE (vbDocumentKindId, 0) = 0
                                                                                                       THEN inPartionGoodsDate
                                                                                                  WHEN inPartionCellId > 0 AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inGoodsId AND OB.DescId = zc_ObjectBoolean_Goods_PLM() AND OB.ValueData = TRUE)
                                                                                                       THEN inPartionGoodsDate
                                                                                                  ELSE NULL
                                                                                             END :: TDateTime

                                                          , inPartionGoodsDate_PartionCell:= CASE WHEN inIsPartionGoodsDate = TRUE AND COALESCE (vbDocumentKindId, 0) = 0
                                                                                                       THEN inPartionGoodsDate
                                                                                                  WHEN inPartionCellId > 0 AND EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inGoodsId AND OB.DescId = zc_ObjectBoolean_Goods_PLM() AND OB.ValueData = TRUE)
                                                                                                       THEN inPartionGoodsDate
                                                                                                  ELSE vbOperDate
                                                                                             END :: TDateTime

                                                          , inPartionGoods        := CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg()
                                                                                                                  , zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()
                                                                                                                   )
                                                                                           AND zfConvert_StringToNumber (inPartionGoods) > 0
                                                                                          THEN ''
                                                                                          ELSE inPartionGoods
                                                                                     END
                                                          , inNumberKVK           := inNumberKVK
                                                          , inMovementItemId      := CASE WHEN vbDocumentKindId IN (zc_Enum_DocumentKind_CuterWeight(), zc_Enum_DocumentKind_RealWeight(), zc_Enum_DocumentKind_RealDelicShp(), zc_Enum_DocumentKind_RealDelicMsg()
                                                                                                                  , zc_Enum_DocumentKind_LakTo(), zc_Enum_DocumentKind_LakFrom()
                                                                                                                   )
                                                                                           AND zfConvert_StringToNumber (inPartionGoods) > 0
                                                                                          THEN zfConvert_StringToNumber (inPartionGoods)
                                                                                          ELSE 0
                                                                                     END
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
                                                          , inStorageLineId       := inStorageLineId
                                                          , inPersonalId_KVK      := inPersonalId_KVK
                                                          , inSession             := inSession
                                                           );

     -- дописали св-во <Asset>
     IF inIsAsset = TRUE
     THEN
         IF inBranchCode IN (1, 101)
        AND vbUnitId = 8451
        AND vbToId  IN (8459, 8458) -- Розподільчий комплекс + Склад База ГП
        AND COALESCE (inAssetId, 0) = 0
        AND EXISTS (SELECT 1 FROM ObjectLink AS OL_Measure WHERE OL_Measure.ChildObjectId IN (zc_Measure_Kg(), zc_Measure_Sh()) AND OL_Measure.ObjectId = inGoodsId AND OL_Measure.DescId = zc_ObjectLink_Goods_Measure())
         THEN
             RAISE EXCEPTION 'Ошибка.Не определено значение <Оборудование - 1>.';
         END IF;

         --
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbId, inAssetId);
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset_two(), vbId, inAssetId_two);

     -- Розподільчий комплекс
     ELSEIF vbMovementDescId = zc_Movement_Inventory() AND vbUnitId = zc_Unit_RK()
        AND inAssetId > 0
        -- AND vbUserId = 5 -- !!!tmp
     THEN
         -- Проверка
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         /*INNER JOIN MovementItemLinkObject AS MILO_Asset
                                                           ON MILO_Asset.MovementItemId = MovementItem.Id
                                                          AND MILO_Asset.DescId         = zc_MILinkObject_Asset()
                                                          AND MILO_Asset.ObjectId       = inAssetId*/
                         INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                      ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                     AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                     AND MIFloat_PartionCell.ValueData      = inAssetId :: TFloat
                         LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                          ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                         LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                    ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                   AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Id         <> COALESCE (vbId, 0)
                      -- если другая партия или товар в этой ячейке
                      AND (MovementItem.ObjectId <> inGoodsId
                        OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                        OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                          )
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.Для Ячейки <%> %может быть сохранена только партия% <%> %с датой <%>.'
                           , lfGet_Object_ValueData (inAssetId)
                           , CHR (13)
                           , CHR (13)
                           , (SELECT DISTINCT lfGet_Object_ValueData (MovementItem.ObjectId) || '> <' || lfGet_Object_ValueData_sh (MILO_GoodsKind.ObjectId)
                              FROM MovementItem
                                   /*INNER JOIN MovementItemLinkObject AS MILO_Asset
                                                                     ON MILO_Asset.MovementItemId = MovementItem.Id
                                                                    AND MILO_Asset.DescId         = zc_MILinkObject_Asset()
                                                                    AND MILO_Asset.ObjectId       = inAssetId*/
                                   INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                                ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                               AND MIFloat_PartionCell.ValueData      = inAssetId :: TFloat
                                   LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                    ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                   LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                              ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                             AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.Id         <> COALESCE (vbId, 0)
                                -- если другая партия или товар в этой ячейке
                                AND (MovementItem.ObjectId <> inGoodsId
                                  OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                                  OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                    )
                             )
                           , CHR (13)
                           , (SELECT DISTINCT zfConvert_DateToString (MID_PartionGoodsDate.ValueData)
                              FROM MovementItem
                                   /*INNER JOIN MovementItemLinkObject AS MILO_Asset
                                                                     ON MILO_Asset.MovementItemId = MovementItem.Id
                                                                    AND MILO_Asset.DescId         = zc_MILinkObject_Asset()
                                                                    AND MILO_Asset.ObjectId       = inAssetId*/
                                   INNER JOIN MovementItemFloat AS MIFloat_PartionCell
                                                                ON MIFloat_PartionCell.MovementItemId = MovementItem.Id
                                                               AND MIFloat_PartionCell.DescId         = zc_MIFloat_PartionCell()
                                                               AND MIFloat_PartionCell.ValueData      = inAssetId :: TFloat
                                   LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                    ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          
                                   LEFT JOIN MovementItemDate AS MID_PartionGoodsDate
                                                              ON MID_PartionGoodsDate.MovementItemId = MovementItem.Id
                                                             AND MID_PartionGoodsDate.DescId         = zc_MIDate_PartionGoods()
                              WHERE MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.Id         <> COALESCE (vbId, 0)
                                -- если другая партия или товар в этой ячейке
                                AND (MovementItem.ObjectId <> inGoodsId
                                  OR COALESCE (MILO_GoodsKind.ObjectId, 0) <> COALESCE (inGoodsKindId, 0)
                                  OR COALESCE (MID_PartionGoodsDate.ValueData, zc_DateStart()) <> COALESCE (inPartionGoodsDate, zc_DateStart())
                                    )
                             )
                            ;
         END IF;

         -- дописали св-во <Asset>
         -- PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Asset(), vbId, inAssetId);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell(), vbId, inAssetId :: TFloat);

     END IF;

     -- дописали св-во <Протокол Дата/время начало>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_StartBegin(), vbId, vbOperDate_StartBegin);
     -- дописали св-во <Протокол Дата/время завершение>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EndBegin(), vbId, CLOCK_TIMESTAMP());


     -- Результат
     RETURN QUERY
       SELECT vbId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.15                                        *
*/

-- тест
-- SELECT * FROM gpInsert_ScaleCeh_MI (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
