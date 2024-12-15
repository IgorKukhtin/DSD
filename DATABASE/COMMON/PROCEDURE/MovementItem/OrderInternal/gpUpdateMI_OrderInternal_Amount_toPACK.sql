-- Function: gpUpdateMI_OrderInternal_Amount_toPACK()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK_NEW (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderInternal_Amount_toPACK (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderInternal_Amount_toPACK(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inNumber              Integer   , -- Количество - итераций
    IN inIsClear             Boolean   , --
    IN inIsPack              Boolean   , --
    IN inIsPackSecond        Boolean   , --
    IN inIsPackNext          Boolean   , --
    IN inIsPackNextSecond    Boolean   , --
    IN inIsByDay             Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId  Integer;

   DECLARE vbSessionId Integer;

   DECLARE vbOperDate  TDateTime;
   DECLARE vbDayCount  Integer;
   DECLARE vbWeekCount Integer;

   DECLARE vbNumber   TFloat;
   DECLARE vbdaycount_GoodsKind_8333 Integer;
   DECLARE vbdaycount_GoodsKind_8333_3 Integer;

   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_OrderInternal_toPACK());
    vbUserId:= lpGetUserBySession (inSession);


/*
-- if inSession = '5'
if 1=1
then

perform gpUpdateMI_OrderInternal_Amount_toPACK_NEW(
    inMovementId          , -- Ключ объекта <Документ>
    inId                  , -- Ключ объекта <Элемент документа>
    inNumber              , -- Количество - итераций
    inIsClear             , --
    inIsPack              , --
    inIsPackSecond        , --
    inIsPackNext          , --
    inIsPackNextSecond    , --
    inIsByDay             , --
    inSession             );

else*/


IF vbUserId = 5 AND inIsByDay = TRUE
   AND 1=0
THEN
    /*RAISE EXCEPTION 'Ошибка.test ok <%>  <%>  <%> <%> <%>  '
             , (SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = 310035796    AND MIB.DescId = zc_MIBoolean_Calculated())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796   AND MIF.DescId = zc_MIFloat_AmountPack())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackSecond())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackNext())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackNextSecond())
              ;*/

    perform lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), 310035796, 0);
end if;


    -- на сколько дней делаем вид НАРЕЗКА
    vbdaycount_GoodsKind_8333  := 5;
    vbdaycount_GoodsKind_8333_3:= 3;

    -- !!!на сколько дней!!!
    inNumber:= 400;


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpGoods_delik')
    THEN
        -- таблица - элементы продаж для распределения Затрат по накладным
        CREATE TEMP TABLE _tmpGoods_delik ON COMMIT DROP
           AS SELECT lfSelect.GoodsId
              FROM Object
                   CROSS JOIN lfSelect_Object_Goods_byGoodsGroup (Object.Id) AS lfSelect
              WHERE Object.DescId = zc_Object_GoodsGroup()
                AND Object.ValueData ILIKE 'Дел%'
             ;
    END IF;



    -- !!!Временно 2 РАЗА - 2 Алгоритма - что б сравнить!!!
    IF inIsByDay = TRUE
    THEN
        PERFORM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= inMovementId, inId:= inId, inNumber:= inNumber, inIsClear:= inIsClear
                                                      , inIsPack:= inIsPack, inIsPackSecond:= inIsPackSecond, inIsPackNext:= inIsPackNext, inIsPackNextSecond:= inIsPackNextSecond, inIsByDay:= FALSE, inSession:= inSession);
        -- RETURN;
    END IF;
    -- !!!Временно 2 РАЗА - 2 Алгоритма - что б сравнить!!!


    IF inIsClear = TRUE
    THEN
        -- пересчитали Итоговые суммы по накладной
        PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

    ELSE
        -- если № п/п уже рассчитан
        IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId =zc_MovementBoolean_NPP_calc() AND MB.ValueData = TRUE)
        THEN
            -- найдем его
            vbSessionId:= COALESCE ((SELECT MAX (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail()), 1) :: Integer;
        ELSE
            -- определяется
            vbSessionId:= (1 + COALESCE ((SELECT MAX (MovementItem.Amount) FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Detail()), 0)) :: Integer;
        END IF;

        -- определяется
        SELECT Movement.OperDate
             ,  1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))      AS DayCount
             , (1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData) - zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData)))) / 7 AS WeekCount
               INTO vbOperDate, vbDayCount, vbWeekCount
        FROM Movement
             LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                    ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                   AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
             LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                    ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                   AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
        WHERE Movement.Id = inMovementId;

        -- Проверка
        IF COALESCE (vbDayCount, 0) <= 1 THEN
            RAISE EXCEPTION 'vbDayCount <%>', vbDayCount;
        END IF;
        -- Проверка
        IF COALESCE (vbWeekCount, 0) <= 1 THEN
            RAISE EXCEPTION 'vbWeekCount <%>', vbWeekCount;
        END IF;


        -- Данные - master
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI_master'))
        THEN
            DELETE FROM _tmpMI_master;
        ELSE
            CREATE TEMP TABLE _tmpMI_master (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, AmountSecond TFloat, AmountNext TFloat, AmountNextSecond TFloat) ON COMMIT DROP;
        END IF;
        -- Данные - master
        INSERT INTO _tmpMI_master (MovementItemId, GoodsId, GoodsKindId, Amount, AmountSecond, AmountNext, AmountNextSecond)
           SELECT MovementItem.Id                                    AS MovementItemId
                , MovementItem.ObjectId                              AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)      AS GoodsKindId
                , MovementItem.Amount                                AS Amount
                , COALESCE (MIFloat_AmountSecond.ValueData, 0)       AS AmountSecond
                , COALESCE (MIFloat_AmountNext.ValueData, 0)         AS AmountNext
                , COALESCE (MIFloat_AmountNextSecond.ValueData, 0)   AS AmountNextSecond
           FROM MovementItem
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                 ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountNext
                                            ON MIFloat_AmountNext.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountNext.DescId = zc_MIFloat_AmountNext()
                LEFT JOIN MovementItemFloat AS MIFloat_AmountNextSecond
                                            ON MIFloat_AmountNextSecond.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountNextSecond.DescId = zc_MIFloat_AmountNextSecond()

                LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                            ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                           AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                      ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                     AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                     ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                    AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE
             AND COALESCE (MILinkObject_GoodsComplete.ObjectId, 0) = 0 -- т.е. НЕ упакованный
             AND COALESCE (MIFloat_ContainerId.ValueData, 0)       = 0 -- отбросили остатки на ПР-ВЕ
             AND (MovementItem.Amount > 0 OR MIFloat_AmountSecond.ValueData > 0 OR MIFloat_AmountNext.ValueData > 0 OR MIFloat_AmountNextSecond.ValueData > 0)
          ;


        -- Данные - Child
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI_Child'))
        THEN
            DELETE FROM _tmpMI_Child;
        ELSE
            CREATE TEMP TABLE _tmpMI_Child (MovementItemId Integer, GoodsId_complete Integer, GoodsKindId_complete Integer, GoodsId Integer, GoodsKindId Integer
                                          , RemainsStart TFloat
                                          , AmountPartnerNext TFloat, AmountPartnerNextPromo TFloat
                                          , CountForecast TFloat
                                          , Plan1 TFloat, Plan2 TFloat, Plan3 TFloat, Plan4 TFloat, Plan5 TFloat, Plan6 TFloat, Plan7 TFloat
                                          , AmountResult TFloat, AmountSecondResult TFloat
                                          , AmountNextResult TFloat, AmountNextSecondResult TFloat
                                          , isCalculated Boolean
                                           ) ON COMMIT DROP;
        END IF;
        -- Данные - Child
        INSERT INTO _tmpMI_Child (MovementItemId, GoodsId_complete, GoodsKindId_complete, GoodsId, GoodsKindId
                                , RemainsStart
                                , AmountPartnerNext, AmountPartnerNextPromo
                                , CountForecast
                                , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                , AmountResult
                                , AmountSecondResult
                                , AmountNextResult
                                , AmountNextSecondResult
                                , isCalculated
                                 )
            WITH -- заменяем товары на "Главный Товар в планировании прихода с упаковки"
                 tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
                                              , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId     AS GoodsKindId
                                              , ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId     AS GoodsId_pack
                                              , ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId AS GoodsKindId_pack
                                         FROM Object AS Object_GoodsByGoodsKind
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                                    ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId          = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_Goods.DescId            = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                                   AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId     > 0
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0

                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsPack
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsPack.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsPack.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsPack()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsPack.ChildObjectId > 0
                                              INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindPack
                                                                    ON ObjectLink_GoodsByGoodsKind_GoodsKindPack.ObjectId      = Object_GoodsByGoodsKind.Id
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKindPack.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKindPack()
                                                                   AND ObjectLink_GoodsByGoodsKind_GoodsKindPack.ChildObjectId > 0
                                         WHERE Object_GoodsByGoodsKind.DescId   = zc_Object_GoodsByGoodsKind()
                                           AND Object_GoodsByGoodsKind.isErased = FALSE
                                        )
                 -- то что в Мастере (факт Расход на упаковку)
               , tmpMI_master AS (SELECT _tmpMI_master.GoodsId, _tmpMI_master.GoodsKindId, SUM (_tmpMI_master.Amount) AS Amount, SUM (_tmpMI_master.AmountNext) AS AmountNext
                                  FROM _tmpMI_master
                                  GROUP BY _tmpMI_master.GoodsId, _tmpMI_master.GoodsKindId
                                 )
             --
           , tmpMI_Detail_all AS (SELECT MovementItem.ParentId
                                       , MovementItem.Amount AS NPP
                                         -- Вот он, БУДЕТ РЕЗУЛЬТАТ + !!!ЗДЕСЬ УЖЕ ВЕС!!!
                                       , COALESCE (MIFloat_AmountPack.ValueData, 0)           AS AmountResult
                                       , COALESCE (MIFloat_AmountPackSecond.ValueData, 0)     AS AmountSecondResult
                                       , COALESCE (MIFloat_AmountPackNext.ValueData, 0)       AS AmountNextResult_two
                                       , COALESCE (MIFloat_AmountPackNextSecond.ValueData, 0) AS AmountNextSecondResult_two
                                  FROM MovementItem
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                                        ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                                    ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPack.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPack() ELSE zc_MIFloat_AmountPack_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                                    ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackSecond() ELSE zc_MIFloat_AmountPackSecond_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                                    ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackNext.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNext() ELSE zc_MIFloat_AmountPackNext_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                                    ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackNextSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNextSecond() ELSE zc_MIFloat_AmountPackNextSecond_calc() END

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.isErased   = FALSE
                                 )
             --
           , tmpMI_Detail AS (SELECT tmpMI_Detail_all.ParentId
                                   , tmpMI_Detail_all.AmountResult
                                   , tmpMI_Detail_all.AmountSecondResult
                                   , tmpMI_Detail_all.AmountNextResult_two
                                   , tmpMI_Detail_all.AmountNextSecondResult_two
                              FROM (SELECT MAX (tmpMI_Detail_all.NPP) AS NPP FROM tmpMI_Detail_all) AS tmp_max
                                   JOIN tmpMI_Detail_all ON tmpMI_Detail_all.NPP = tmp_max.NPP - CASE WHEN inIsByDay = TRUE THEN 1 ELSE 0 END
                             )
            -- Не упаковывать
          , tmpGoodsByGoodsKind_not AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId          AS GoodsId
                                             , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId      AS GoodsKindId
                                        FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                             JOIN Object AS Object_GoodsByGoodsKind
                                                         ON Object_GoodsByGoodsKind.Id       = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                        AND Object_GoodsByGoodsKind.isErased = FALSE
                                             JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                             ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                            AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                             JOIN ObjectBoolean AS ObjectBoolean_NotPack
                                                                ON ObjectBoolean_NotPack.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                               AND ObjectBoolean_NotPack.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()
                                                               AND ObjectBoolean_NotPack.ValueData = TRUE
                                        WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                        --AND 1=0
                                       )
           -- Результат
           SELECT tmpMI.MovementItemId
                , tmpMI.GoodsId_complete
                , tmpMI.GoodsKindId_complete
                , tmpMI.GoodsId
                , tmpMI.GoodsKindId

                  -- <Нач остаток> МИНУС <то что в Мастере (факт Расход на упаковку)>
                , (CASE WHEN tmpMI.AmountRemains > 0
                             THEN tmpMI.AmountRemains
                        ELSE 0
                   END

                   -- МИНУС <неотгруж. заявка (итого)>
                 - tmpMI.AmountPartnerPrior - tmpMI.AmountPartnerPriorPromo

                    -- МИНУС <сегодня заявка (итого)> - !!!НО НЕ только если строится ЗАКАЗ2 !!!
                 - CASE WHEN inIsPackNext       = TRUE
                          OR inIsPackNextSecond = TRUE
                          OR 1=1
                             THEN tmpMI.AmountPartner + tmpMI.AmountPartnerPromo
                        ELSE 0
                   END
                   -- ВЕРНУЛИ заказ покупателя ВЕСЬ, завтра - !!!НО НЕ только если ПЛАНИРУЕМ по ДНЯМ + ЗАКАЗ2!!!
                 + CASE WHEN inIsByDay = TRUE
                         AND (inIsPackNext       = TRUE
                           OR inIsPackNextSecond = TRUE
                           OR 1=1
                             )
                             THEN tmpMI.AmountPartnerNext + tmpMI.AmountPartnerNextPromo
                        ELSE 0
                   END

                  )
                  AS RemainsStart

                  -- "информативно" заказ покупателя БЕЗ акций, завтра
                , tmpMI.AmountPartnerNext
                  -- "информативно" заказ покупателя ТОЛЬКО Акции, завтра
                , tmpMI.AmountPartnerNextPromo

                  -- <Прогн 1д>
                , CASE WHEN tmpMI.AmountForecast > 0
                            THEN tmpMI.AmountForecast      / vbDayCount
                            ELSE tmpMI.AmountForecastOrder / vbDayCount
                  END AS CountForecast

                  -- "средняя" но для 1 дня - используется "информативно", если оно окажется БОЛЬШЕ
                , CASE WHEN tmpMI.AmountPartnerNext + tmpMI.AmountPartnerNextPromo > tmpMI.Plan1
                            THEN tmpMI.AmountPartnerNext + tmpMI.AmountPartnerNextPromo
                  -- "средняя" за 1 день - продажа ИЛИ заявка
                       WHEN vbWeekCount <> 0 THEN tmpMI.Plan1 / vbWeekCount ELSE 0 END AS Plan1
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan2 / vbWeekCount ELSE 0 END AS Plan2
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan3 / vbWeekCount ELSE 0 END AS Plan3
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan4 / vbWeekCount ELSE 0 END AS Plan4
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan5 / vbWeekCount ELSE 0 END AS Plan5
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan6 / vbWeekCount ELSE 0 END AS Plan6
                , CASE WHEN vbWeekCount <> 0 THEN tmpMI.Plan7 / vbWeekCount ELSE 0 END AS Plan7

                  -- Вот он, БУДЕТ РЕЗУЛЬТАТ
                , CASE WHEN inIsPack       = TRUE THEN COALESCE (tmpMI_Detail.AmountResult, 0)       ELSE tmpMI.AmountResult                  END AS AmountResult
                , CASE WHEN inIsPackSecond = TRUE THEN COALESCE (tmpMI_Detail.AmountSecondResult, 0) ELSE tmpMI.AmountSecondResult            END AS AmountSecondResult
                , CASE WHEN inIsPack       = TRUE THEN COALESCE (tmpMI_Detail.AmountNextResult_two, 0)       WHEN tmpMI.isCalculated = FALSE THEN tmpMI.AmountNextResult_two       ELSE COALESCE (tmpMI_Detail.AmountNextResult_two, 0)       /*tmpMI.AmountNextResult*/        END AS AmountNextResult
                , CASE WHEN inIsPackSecond = TRUE THEN COALESCE (tmpMI_Detail.AmountNextSecondResult_two, 0) WHEN tmpMI.isCalculated = FALSE THEN tmpMI.AmountNextSecondResult_two ELSE COALESCE (tmpMI_Detail.AmountNextSecondResult_two, 0) /*tmpMI.AmountNextSecondResult*/  END AS AmountNextSecondResult

                , tmpMI.isCalculated

           FROM (SELECT MovementItem.Id                                AS MovementItemId
                      , CASE WHEN MILinkObject_GoodsComplete.ObjectId     > 0 THEN MILinkObject_GoodsComplete.ObjectId     ELSE MovementItem.ObjectId                         END AS GoodsId_complete
                      , CASE WHEN MILinkObject_GoodsKindComplete.ObjectId > 0 THEN MILinkObject_GoodsKindComplete.ObjectId ELSE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) END AS GoodsKindId_complete
                      , MovementItem.ObjectId                          AS GoodsId
                      , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  AS GoodsKindId

                        -- <Нач остаток> МИНУС <то что в Мастере (факт Расход на упаковку)>
                      , SUM ((COALESCE (MIFloat_AmountRemains.ValueData, 0) - COALESCE (tmpMI_master.Amount, 0) - COALESCE (tmpMI_master.AmountNext, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountRemains

                        -- <неотгруж. заявка (итого)>
                      , SUM (COALESCE (MIFloat_AmountPartnerPrior.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartnerPrior
                      , SUM (COALESCE (MIFloat_AmountPartnerPriorPromo.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartnerPriorPromo

                        -- <сегодня заявка (итого)>
                      , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartner
                      , SUM (COALESCE (MIFloat_AmountPartnerPromo.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartnerPromo


                        -- "информативно" заказ покупателя БЕЗ акций, завтра + !!!ПЕРЕВОДИМ В ВЕС!!!
                      , SUM (COALESCE (MIFloat_AmountPartnerNext.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartnerNext
                        -- "информативно" заказ покупателя ТОЛЬКО Акции, завтра + !!!ПЕРЕВОДИМ В ВЕС!!!
                      , SUM (COALESCE (MIFloat_AmountPartnerNextPromo.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountPartnerNextPromo

                        -- <Прогн 1д> + !!!ПЕРЕВОДИМ В ВЕС!!!
                      , SUM (COALESCE (MIFloat_AmountForecast.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountForecast
                        -- <Прогн 1д> + !!!ПЕРЕВОДИМ В ВЕС!!!
                      , SUM (COALESCE (MIFloat_AmountForecastOrder.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountForecastOrder

                        -- "средняя" за 1 день - продажа ИЛИ заявка + !!!ПЕРЕВОДИМ В ВЕС!!!
                      , SUM ((COALESCE (MIFloat_Plan1.ValueData, 0) + COALESCE (MIFloat_Promo1.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan1
                      , SUM ((COALESCE (MIFloat_Plan2.ValueData, 0) + COALESCE (MIFloat_Promo2.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan2
                      , SUM ((COALESCE (MIFloat_Plan3.ValueData, 0) + COALESCE (MIFloat_Promo3.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan3
                      , SUM ((COALESCE (MIFloat_Plan4.ValueData, 0) + COALESCE (MIFloat_Promo4.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan4
                      , SUM ((COALESCE (MIFloat_Plan5.ValueData, 0) + COALESCE (MIFloat_Promo5.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan5
                      , SUM ((COALESCE (MIFloat_Plan6.ValueData, 0) + COALESCE (MIFloat_Promo6.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan6
                      , SUM ((COALESCE (MIFloat_Plan7.ValueData, 0) + COALESCE (MIFloat_Promo7.ValueData, 0)) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END)
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS Plan7


                        -- Вот он, БУДЕТ РЕЗУЛЬТАТ + !!!ЗДЕСЬ УЖЕ ВЕС!!!
                      , SUM (COALESCE (MIFloat_AmountPack.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountResult
                      , SUM (COALESCE (MIFloat_AmountPackSecond.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountSecondResult
                      , SUM (COALESCE (MIFloat_AmountPack.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountNextResult
                      , SUM (COALESCE (MIFloat_AmountPackSecond.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountNextSecondResult

                      , SUM (COALESCE (MIFloat_AmountPackNext.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountNextResult_two
                      , SUM (COALESCE (MIFloat_AmountPackNextSecond.ValueData, 0))
                            OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                  ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END ASC
                                         , MovementItem.Id ASC
                                 ) AS AmountNextSecondResult_two


                        --  № п/п
                      , ROW_NUMBER() OVER (PARTITION BY COALESCE (tmpGoodsByGoodsKind.GoodsId_pack, MovementItem.ObjectId) :: TVarChar  || '_' || COALESCE (tmpGoodsByGoodsKind.GoodsKindId_pack, COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) :: TVarChar
                                           ORDER BY CASE WHEN tmpGoodsByGoodsKind.GoodsId_pack > 0 THEN 0 ELSE MovementItem.Id END DESC
                                                  , MovementItem.Id DESC
                                          ) AS Ord

                      , COALESCE (MIBoolean_Calculated.ValueData, TRUE) AS isCalculated

                 FROM MovementItem
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                       ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                       ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                      LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                       ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()

                      LEFT JOIN tmpMI_master ON tmpMI_master.GoodsId     = MovementItem.ObjectId
                                            AND tmpMI_master.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                      LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = MovementItem.ObjectId
                                                   AND tmpGoodsByGoodsKind.GoodsKindId = MILinkObject_GoodsKind.ObjectId

                      LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                  ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                 AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountRemains
                                                  ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountRemains.DescId         = zc_MIFloat_AmountRemains()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                  ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPack.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPack() ELSE zc_MIFloat_AmountPack_calc() END
                                                 -- AND MIFloat_AmountPack.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPack_calc() ELSE zc_MIFloat_AmountPack() END
                                                 -- AND MIFloat_AmountPack.DescId         = zc_MIFloat_AmountPack()
                                                 -- AND MIFloat_AmountPack.DescId         = zc_MIFloat_AmountPack_calc()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                  ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPackSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackSecond() ELSE zc_MIFloat_AmountPackSecond_calc() END
                                                 -- AND MIFloat_AmountPackSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackSecond_calc() ELSE zc_MIFloat_AmountPackSecond() END
                                                 -- AND MIFloat_AmountPackSecond.DescId         = zc_MIFloat_AmountPackSecond()
                                                 -- AND MIFloat_AmountPackSecond.DescId         = zc_MIFloat_AmountPackSecond_calc()

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                  ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPackNext.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNext() ELSE zc_MIFloat_AmountPackNext_calc() END
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                  ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPackNextSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNextSecond() ELSE zc_MIFloat_AmountPackNextSecond_calc() END

                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerNext
                                                  ON MIFloat_AmountPartnerNext.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartnerNext.DescId         = zc_MIFloat_AmountPartnerNext()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerNextPromo
                                                  ON MIFloat_AmountPartnerNextPromo.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartnerNextPromo.DescId         = zc_MIFloat_AmountPartnerNextPromo()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPrior
                                                  ON MIFloat_AmountPartnerPrior.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartnerPrior.DescId         = zc_MIFloat_AmountPartnerPrior()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountForecast
                                                  ON MIFloat_AmountForecast.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountForecast.DescId         = zc_MIFloat_AmountForecast()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrder
                                                  ON MIFloat_AmountForecastOrder.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountForecastOrder.DescId         = zc_MIFloat_AmountForecastOrder()
                      --
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPromo
                                                  ON MIFloat_AmountPartnerPromo.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartnerPromo.DescId         = zc_MIFloat_AmountPartnerPromo()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountPartnerPriorPromo
                                                  ON MIFloat_AmountPartnerPriorPromo.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountPartnerPriorPromo.DescId         = zc_MIFloat_AmountPartnerPriorPromo()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastPromo
                                                  ON MIFloat_AmountForecastPromo.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountForecastPromo.DescId         = zc_MIFloat_AmountForecastPromo()
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountForecastOrderPromo
                                                  ON MIFloat_AmountForecastOrderPromo.MovementItemId = MovementItem.Id
                                                 AND MIFloat_AmountForecastOrderPromo.DescId         = zc_MIFloat_AmountForecastOrderPromo()

                      LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                                  ON MIFloat_Plan1.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan1.DescId         = zc_MIFloat_Plan1()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                                  ON MIFloat_Plan2.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan2.DescId         = zc_MIFloat_Plan2()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                                  ON MIFloat_Plan3.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan3.DescId         = zc_MIFloat_Plan3()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                                  ON MIFloat_Plan4.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan4.DescId         = zc_MIFloat_Plan4()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                                  ON MIFloat_Plan5.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan5.DescId         = zc_MIFloat_Plan5()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                                  ON MIFloat_Plan6.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan6.DescId         = zc_MIFloat_Plan6()
                      LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                                  ON MIFloat_Plan7.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Plan7.DescId         = zc_MIFloat_Plan7()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo1
                                                  ON MIFloat_Promo1.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo1.DescId         = zc_MIFloat_Promo1()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo2
                                                  ON MIFloat_Promo2.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo2.DescId         = zc_MIFloat_Promo2()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo3
                                                  ON MIFloat_Promo3.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo3.DescId         = zc_MIFloat_Promo3()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo4
                                                  ON MIFloat_Promo4.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo4.DescId         = zc_MIFloat_Promo4()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo5
                                                  ON MIFloat_Promo5.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo5.DescId         = zc_MIFloat_Promo5()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo6
                                                  ON MIFloat_Promo6.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo6.DescId         = zc_MIFloat_Promo6()
                      LEFT JOIN MovementItemFloat AS MIFloat_Promo7
                                                  ON MIFloat_Promo7.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Promo7.DescId         = zc_MIFloat_Promo7()

                      LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                            ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                           AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                           ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                          AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()

                      LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                    ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                   -- !!! отключил
                                                   AND 1=0

                      -- Не упаковывать
                      LEFT JOIN tmpGoodsByGoodsKind_not ON tmpGoodsByGoodsKind_not.GoodsId     = MovementItem.ObjectId
                                                       AND tmpGoodsByGoodsKind_not.GoodsKindId = MILinkObject_GoodsKind.ObjectId

                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                   AND COALESCE (MIFloat_ContainerId.ValueData, 0) = 0 -- отбросили остатки на ПР-ВЕ
                   AND tmpGoodsByGoodsKind_not.GoodsId IS NULL         -- отбросили Не упаковывать

                  -- AND MIBoolean_Calculated.MovementItemId IS NULL

                ) AS tmpMI
                LEFT JOIN tmpMI_Detail ON tmpMI_Detail.ParentId = tmpMI.MovementItemId

           WHERE tmpMI.Ord = 1
          ;


-- TEST
IF vbUserId = 5 AND inIsByDay = TRUE
AND 1=0
THEN
    RAISE EXCEPTION 'Ошибка. <%>  <%>'
    , (select _tmpMI_Child.AmountResult from _tmpMI_Child where _tmpMI_Child.MovementItemId = 224364726 )

, ( with tmpMI_Detail_all AS (SELECT MovementItem.ParentId
                                       , MovementItem.Amount AS NPP
                                         -- Вот он, БУДЕТ РЕЗУЛЬТАТ + !!!ЗДЕСЬ УЖЕ ВЕС!!!
                                       , COALESCE (MIFloat_AmountPack.ValueData, 0)           AS AmountResult
                                       , COALESCE (MIFloat_AmountPackSecond.ValueData, 0)     AS AmountSecondResult
                                       , COALESCE (MIFloat_AmountPackNext.ValueData, 0)       AS AmountNextResult_two
                                       , COALESCE (MIFloat_AmountPackNextSecond.ValueData, 0) AS AmountNextSecondResult_two
                                  FROM MovementItem
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                                        ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                                    ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPack.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPack() ELSE zc_MIFloat_AmountPack_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                                    ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackSecond() ELSE zc_MIFloat_AmountPackSecond_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                                    ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackNext.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNext() ELSE zc_MIFloat_AmountPackNext_calc() END
                                        LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                                    ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                                   AND MIFloat_AmountPackNextSecond.DescId         = CASE WHEN inIsByDay = TRUE THEN zc_MIFloat_AmountPackNextSecond() ELSE zc_MIFloat_AmountPackNextSecond_calc() END

                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Detail()
                                    AND MovementItem.isErased   = FALSE
                                 )
             --
           , tmpMI_Detail AS (SELECT tmpMI_Detail_all.ParentId
                                   , tmpMI_Detail_all.AmountResult
                                   , tmpMI_Detail_all.AmountSecondResult
                                   , tmpMI_Detail_all.AmountNextResult_two
                                   , tmpMI_Detail_all.AmountNextSecondResult_two
                              FROM (SELECT MAX (tmpMI_Detail_all.NPP) AS NPP FROM tmpMI_Detail_all) AS tmp_max
                                   JOIN tmpMI_Detail_all ON tmpMI_Detail_all.NPP = tmp_max.NPP
                             )
select tmpMI_Detail.AmountResult from tmpMI_Detail where tmpMI_Detail.ParentId = 224364726 
)

/*
        INSERT INTO _tmpMI_Child (MovementItemId, GoodsId_complete, GoodsKindId_complete, GoodsId, GoodsKindId
                                , RemainsStart
                                , AmountPartnerNext, AmountPartnerNextPromo
                                , CountForecast
                                , Plan1, Plan2, Plan3, Plan4, Plan5, Plan6, Plan7
                                , AmountResult
                                , AmountSecondResult
                                , AmountNextResult
                                , AmountNextSecondResult
                                , isCalculated
                                 )
*/
    ;
end if;


         -- Первый
         IF inIsPack = TRUE
         THEN
             vbNumber:= 0;
             WHILE vbNumber <= inNumber
             LOOP
                 UPDATE _tmpMI_Child SET AmountResult = _tmpMI_Child.AmountResult + tmpResult.Amount_result
                 FROM (WITH -- разрешено расписывать план на производство в цехе упак больше чем 5 дней
                            tmpGoods_PackOrder_noLimit AS (--SELECT 3458129 AS GoodsId -- 991 - ШИЙКА LA PARMA с/в в/ґ ТМ Алан
                                                           SELECT DISTINCT
                                                                  ObjectLink_Goods.ChildObjectId AS GoodsId
                                                           FROM ObjectBoolean AS ObjectBoolean_PackOrder
                                                                INNER JOIN Object ON Object.Id       = ObjectBoolean_PackOrder.ObjectId
                                                                                 AND Object.isErased = FALSE
                                                                INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                                      ON ObjectLink_Goods.ObjectId = Object.Id
                                                                                     AND ObjectLink_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()

                                                           WHERE ObjectBoolean_PackOrder.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_PackOrder()
                                                             AND ObjectBoolean_PackOrder.ValueData = TRUE
                                                          )
                            -- разрешено расписывать план на такое ко-во дней
                          , tmpGoods_PackLimit AS (SELECT DISTINCT
                                                          ObjectLink_Goods.ChildObjectId     AS GoodsId
                                                        , ObjectLink_GoodsKind.ChildObjectId AS GoodsKindId
                                                        , COALESCE (ObjectFloat_PackLimit.ValueData, 0) + CASE WHEN vbUserId = 5 then 0 else 0 end AS DayLimit
                                                   FROM ObjectBoolean AS ObjectBoolean_PackLimit
                                                        INNER JOIN Object ON Object.Id       = ObjectBoolean_PackLimit.ObjectId
                                                                         AND Object.isErased = FALSE
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                              ON ObjectLink_Goods.ObjectId = Object.Id
                                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                        INNER JOIN ObjectLink AS ObjectLink_GoodsKind
                                                                              ON ObjectLink_GoodsKind.ObjectId = Object.Id
                                                                             AND ObjectLink_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                        LEFT JOIN ObjectFloat AS ObjectFloat_PackLimit
                                                                              ON ObjectFloat_PackLimit.ObjectId  = Object.Id
                                                                             AND ObjectFloat_PackLimit.DescId    = zc_ObjectFloat_GoodsByGoodsKind_PackLimit()

                                                   WHERE ObjectBoolean_PackLimit.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_PackLimit()
                                                     AND ObjectBoolean_PackLimit.ValueData = TRUE
                                                     --AND vbUserId = 5
                                                  )
                            -- сумма - сколько уже распределили
                          , tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete     AS GoodsId_master
                                                , _tmpMI_Child.GoodsKindId_complete AS GoodsKindId_master
                                                , SUM (_tmpMI_Child.AmountResult)   AS AmountResult
                                           FROM _tmpMI_Child
                                           WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0 OR _tmpMI_Child.AmountNextResult <> 0 OR _tmpMI_Child.AmountNextSecondResult <> 0
                                           GROUP BY _tmpMI_Child.GoodsId_complete
                                                  , _tmpMI_Child.GoodsKindId_complete
                                         )
                            -- объединили Master и Child
                          , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                               , _tmpMI_master.GoodsId     AS GoodsId_master
                                               , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                                 -- сколько осталось для распределения
                                               , _tmpMI_master.Amount - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master

                                                 -- сколько надо на vbNumber ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                      WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                      WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                      WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                      WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                      WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                      WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                      WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      ELSE 0
                                                 END
                                                 -- МИНУС остаток + сколько уже распределили
                                               - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)
                                                 AS Amount_result

                                                 -- сколько надо на DayLimit ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE THEN tmpGoods_PackLimit.DayLimit * _tmpMI_Child.CountForecast ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 0  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 1  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 2  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 3  THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 4  THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 5  THEN 1 * _tmpMI_Child.Plan6 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 6  THEN 1 * _tmpMI_Child.Plan7 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 7  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 8  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 9  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 10 THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 11 THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 12 THEN (tmpGoods_PackLimit.DayLimit - 12) * _tmpMI_Child.CountForecast ELSE 0 END
                                                 AS Amount_result_DayLimit

                                                 -- остаток + сколько уже распределили
                                               , _tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult
                                                 AS Amount_result_old
                                                 --
                                               , tmpGoods_PackLimit.GoodsId AS GoodsId_DayLimit

                                          FROM _tmpMI_master
                                               INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                      AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                               LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                    AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
                                               LEFT JOIN _tmpGoods_delik ON _tmpGoods_delik.GoodsId = _tmpMI_master.GoodsId
                                               LEFT JOIN tmpGoods_PackOrder_noLimit ON tmpGoods_PackOrder_noLimit.GoodsId = _tmpMI_Child.GoodsId
                                               LEFT JOIN tmpGoods_PackLimit ON tmpGoods_PackLimit.GoodsId     = _tmpMI_Child.GoodsId
                                                                           AND tmpGoods_PackLimit.GoodsKindId = _tmpMI_Child.GoodsKindId

                                          WHERE -- если есть что распределять
                                                _tmpMI_master.Amount - COALESCE (tmpMI_summ.AmountResult, 0) > 0
                                                -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                            AND 0 < CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                         WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                         WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                         WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                         WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                         WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                         WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                         WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         ELSE 0
                                                    END
                                                    -- МИНУС остаток + сколько уже распределили
                                                  - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)

                                            -- !!!отбросили НАРЕЗКУ!!!
                                          /*AND (vbNumber <= vbdaycount_GoodsKind_8333
                                              OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333    -- НАР
                                                                                              , 6899005 -- нар. 200
                                                                                              , 9027592 -- т/ф газ нар 0,1
                                                                                              , 8988926 -- т/ф газ нар 0,2
                                                                                              , 8988924 -- изопак скин нар 0,08
                                                                                              , 8988925 -- изопак скин нар 0,1
                                                                                               )
                                                )*/

                                            -- !!!отбросили НАРЕЗКУ!!!
                                            AND ((vbNumber <= vbdaycount_GoodsKind_8333_3
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (6899005) -- нар. 200
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333)    -- нар.
                                               OR _tmpGoods_delik.GoodsId IS NULL
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (--6899005 -- нар. 200
                                                                                                 9027592 -- т/ф газ нар 0,1
                                                                                               , 8988926 -- т/ф газ нар 0,2
                                                                                               , 8988924 -- изопак скин нар 0,08
                                                                                               , 8988925 -- изопак скин нар 0,1
                                                                                                )
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )

                                             AND (tmpGoods_PackLimit.DayLimit >= vbNumber
                                               OR tmpGoods_PackLimit.GoodsId IS NULL
                                               OR vbUserId = 5
                                                 )
                                                )
                                         )

                            -- ИТОГО по Child для ПРОПОРЦИИ
                          , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                    , tmpMI_all.GoodsKindId_master
                                                    , SUM (tmpMI_all.Amount_result) AS Amount_result
                                               FROM tmpMI_all
                                               GROUP BY tmpMI_all.GoodsId_master
                                                      , tmpMI_all.GoodsKindId_master
                                              )
                       -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                       SELECT tmpMI_all.MovementItemId
                            , CASE -- если в Master больше чем ИТОГО по Child
                                   WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                        -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                        THEN ROUND (tmpMI_all.Amount_result, 1)
                                   ELSE -- иначе Распределяем
                                        ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                        -- tmpMI_all.Amount_result
                                        -- tmpMI_all.Amount_master

                              END AS Amount_result

                            , tmpMI_all.Amount_result_DayLimit
                            , tmpMI_all.Amount_result_old
                            , tmpMI_all.GoodsId_DayLimit
                       FROM tmpMI_all
                            INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                     AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                      ) AS tmpResult
                 WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId
                   -- если есть условие в днях, проверяем
                   AND (tmpResult.Amount_result_old + tmpResult.Amount_result <= tmpResult.Amount_result_DayLimit
                     OR tmpResult.GoodsId_DayLimit IS NULL
                       )
                ;

                 -- теперь следуюющий
                 vbNumber := vbNumber + 0.1;

             END LOOP;


             IF inIsByDay = TRUE -- AND 1=0
             THEN
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(),      MovementItem.Id, 0)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack(),_tmpMI_Child.MovementItemId, _tmpMI_Child.AmountResult)
                       FROM _tmpMI_Child
                       WHERE _tmpMI_Child.AmountResult <> 0
                      ) AS tmp
                ;

             ELSE
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack_calc(), MovementItem.Id, 0)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPack_calc(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountResult)
                       FROM _tmpMI_Child
                       WHERE _tmpMI_Child.AmountResult <> 0
                      ) AS tmp
                ;

             END IF;


         END IF;


         -- ВТОРОЙ
         IF inIsPackSecond = TRUE
         THEN
             vbNumber:= 0;
             WHILE vbNumber <= inNumber
             LOOP
                 UPDATE _tmpMI_Child SET AmountSecondResult = _tmpMI_Child.AmountSecondResult + tmpResult.Amount_result
                 FROM (WITH -- разрешено расписывать план на производство в цехе упак больше чем 5 дней
                            tmpGoods_PackOrder_noLimit AS (SELECT 3458129 AS GoodsId -- 991 - ШИЙКА LA PARMA с/в в/ґ ТМ Алан
                                                          )
                            -- разрешено расписывать план на такое ко-во дней
                          , tmpGoods_PackLimit AS (SELECT DISTINCT
                                                          ObjectLink_Goods.ChildObjectId     AS GoodsId
                                                        , ObjectLink_GoodsKind.ChildObjectId AS GoodsKindId
                                                        , COALESCE (ObjectFloat_PackLimit.ValueData, 0)  + CASE WHEN vbUserId = 0 then 1 else 0 end AS DayLimit
                                                   FROM ObjectBoolean AS ObjectBoolean_PackLimit
                                                        INNER JOIN Object ON Object.Id       = ObjectBoolean_PackLimit.ObjectId
                                                                         AND Object.isErased = FALSE
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                              ON ObjectLink_Goods.ObjectId = Object.Id
                                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                        INNER JOIN ObjectLink AS ObjectLink_GoodsKind
                                                                              ON ObjectLink_GoodsKind.ObjectId = Object.Id
                                                                             AND ObjectLink_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                        LEFT JOIN ObjectFloat AS ObjectFloat_PackLimit
                                                                              ON ObjectFloat_PackLimit.ObjectId  = Object.Id
                                                                             AND ObjectFloat_PackLimit.DescId    = zc_ObjectFloat_GoodsByGoodsKind_PackLimit()

                                                   WHERE ObjectBoolean_PackLimit.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_PackLimit()
                                                     AND ObjectBoolean_PackLimit.ValueData = TRUE
                                                     --AND vbUserId = 5
                                                  )
                            -- сумма - сколько уже распределили
                          , tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete         AS GoodsId_master
                                                , _tmpMI_Child.GoodsKindId_complete     AS GoodsKindId_master
                                                , SUM (_tmpMI_Child.AmountSecondResult) AS AmountResult
                                           FROM _tmpMI_Child
                                           WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0 OR _tmpMI_Child.AmountNextResult <> 0 OR _tmpMI_Child.AmountNextSecondResult <> 0
                                           GROUP BY _tmpMI_Child.GoodsId_complete
                                                  , _tmpMI_Child.GoodsKindId_complete
                                         )
                            -- объединили Master и Child
                          , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                               , _tmpMI_master.GoodsId     AS GoodsId_master
                                               , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                                 -- сколько осталось для распределения
                                               , _tmpMI_master.AmountSecond - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master

                                                 -- сколько надо на vbNumber ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                      WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                      WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                      WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                      WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                      WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                      WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                      WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      ELSE 0
                                                 END
                                                 -- МИНУС остаток + сколько уже распределили
                                               - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)
                                                 AS Amount_result

                                                 -- сколько надо на DayLimit ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE THEN tmpGoods_PackLimit.DayLimit * _tmpMI_Child.CountForecast ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 0  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 1  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 2  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 3  THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 4  THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 5  THEN 1 * _tmpMI_Child.Plan6 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 6  THEN 1 * _tmpMI_Child.Plan7 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 7  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 8  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 9  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 10 THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 11 THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 12 THEN (tmpGoods_PackLimit.DayLimit - 12) * _tmpMI_Child.CountForecast ELSE 0 END
                                                 AS Amount_result_DayLimit

                                                 -- остаток + сколько уже распределили
                                               , _tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult
                                                 AS Amount_result_old
                                                 --
                                               , tmpGoods_PackLimit.GoodsId AS GoodsId_DayLimit

                                          FROM _tmpMI_master
                                               INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                      AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                               LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                    AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
                                               LEFT JOIN _tmpGoods_delik ON _tmpGoods_delik.GoodsId = _tmpMI_master.GoodsId
                                               LEFT JOIN tmpGoods_PackOrder_noLimit ON tmpGoods_PackOrder_noLimit.GoodsId = _tmpMI_Child.GoodsId
                                               LEFT JOIN tmpGoods_PackLimit ON tmpGoods_PackLimit.GoodsId     = _tmpMI_Child.GoodsId
                                                                           AND tmpGoods_PackLimit.GoodsKindId = _tmpMI_Child.GoodsKindId

                                          WHERE -- если есть что распределять
                                                _tmpMI_master.AmountSecond - COALESCE (tmpMI_summ.AmountResult, 0) > 0 -- если есть что распределять
                                                -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                            AND 0 < CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                         WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                         WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                         WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                         WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                         WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                         WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                         WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         ELSE 0
                                                    END
                                                    -- МИНУС остаток + сколько уже распределили
                                                  - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)

                                            -- !!!отбросили НАРЕЗКУ!!!
                                          /*AND (vbNumber <= vbdaycount_GoodsKind_8333
                                              OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333    -- НАР
                                                                                              , 6899005 -- нар. 200
                                                                                               )
                                                )*/

                                            -- !!!отбросили НАРЕЗКУ!!!
                                            AND ((vbNumber <= vbdaycount_GoodsKind_8333_3
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (6899005) -- нар. 200
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333)    -- нар.
                                               OR _tmpGoods_delik.GoodsId IS NULL
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (--6899005 -- нар. 200
                                                                                                 9027592 -- т/ф газ нар 0,1
                                                                                               , 8988926 -- т/ф газ нар 0,2
                                                                                               , 8988924 -- изопак скин нар 0,08
                                                                                               , 8988925 -- изопак скин нар 0,1
                                                                                                )
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )

                                             AND (tmpGoods_PackLimit.DayLimit >= vbNumber
                                               OR tmpGoods_PackLimit.GoodsId IS NULL
                                               OR vbUserId = 5
                                                 )
                                                )

                                         )
                            -- ИТОГО по Child для ПРОПОРЦИИ
                          , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                    , tmpMI_all.GoodsKindId_master
                                                    , SUM (tmpMI_all.Amount_result) AS Amount_result
                                               FROM tmpMI_all
                                               GROUP BY tmpMI_all.GoodsId_master
                                                      , tmpMI_all.GoodsKindId_master
                                              )
                       -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                       SELECT tmpMI_all.MovementItemId
                            , CASE -- если в Master больше чем ИТОГО по Child
                                   WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                        -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                        THEN ROUND (tmpMI_all.Amount_result, 1)
                                   ELSE -- иначе Распределяем
                                        ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                        -- tmpMI_all.Amount_result
                                        -- tmpMI_all.Amount_master

                              END AS Amount_result

                            , tmpMI_all.Amount_result_DayLimit
                            , tmpMI_all.Amount_result_old
                            , tmpMI_all.GoodsId_DayLimit
                       FROM tmpMI_all
                            INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                     AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                      ) AS tmpResult
                 WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId
                   -- если есть условие в днях, проверяем
                   AND (tmpResult.Amount_result_old + tmpResult.Amount_result <= tmpResult.Amount_result_DayLimit
                     OR tmpResult.GoodsId_DayLimit IS NULL
                       )
                ;

                 -- теперь следуюющий
                 vbNumber := vbNumber + 0.1;

             END LOOP;


             IF inIsByDay = TRUE -- AND 1=0
             THEN
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(),      MovementItem.Id, 0)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountSecondResult)
                       FROM _tmpMI_Child
                       WHERE _tmpMI_Child.AmountSecondResult <> 0
                      ) AS tmp
                ;

             ELSE
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond_calc(), MovementItem.Id, 0)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackSecond_calc(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountSecondResult)
                       FROM _tmpMI_Child
                       WHERE _tmpMI_Child.AmountSecondResult <> 0
                      ) AS tmp
                ;

             END IF;

         END IF;


         -- ТРЕТИЙ
         IF inIsPackNext = TRUE
         THEN
             vbNumber:= 0;
             WHILE vbNumber <= inNumber
             LOOP
                 UPDATE _tmpMI_Child SET AmountNextResult = _tmpMI_Child.AmountNextResult + tmpResult.Amount_result
                 FROM (WITH -- разрешено расписывать план на производство в цехе упак больше чем 5 дней
                            tmpGoods_PackOrder_noLimit AS (SELECT 3458129 AS GoodsId -- 991 - ШИЙКА LA PARMA с/в в/ґ ТМ Алан
                                                          )
                            -- разрешено расписывать план на такое ко-во дней
                          , tmpGoods_PackLimit AS (SELECT DISTINCT
                                                          ObjectLink_Goods.ChildObjectId     AS GoodsId
                                                        , ObjectLink_GoodsKind.ChildObjectId AS GoodsKindId
                                                        , COALESCE (ObjectFloat_PackLimit.ValueData, 0) AS DayLimit
                                                   FROM ObjectBoolean AS ObjectBoolean_PackLimit
                                                        INNER JOIN Object ON Object.Id       = ObjectBoolean_PackLimit.ObjectId
                                                                         AND Object.isErased = FALSE
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                              ON ObjectLink_Goods.ObjectId = Object.Id
                                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                        INNER JOIN ObjectLink AS ObjectLink_GoodsKind
                                                                              ON ObjectLink_GoodsKind.ObjectId = Object.Id
                                                                             AND ObjectLink_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                        LEFT JOIN ObjectFloat AS ObjectFloat_PackLimit
                                                                              ON ObjectFloat_PackLimit.ObjectId  = Object.Id
                                                                             AND ObjectFloat_PackLimit.DescId    = zc_ObjectFloat_GoodsByGoodsKind_PackLimit()

                                                   WHERE ObjectBoolean_PackLimit.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_PackLimit()
                                                     AND ObjectBoolean_PackLimit.ValueData = TRUE
                                                     --AND vbUserId = 5
                                                  )
                            -- сумма - сколько уже распределили
                          , tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete         AS GoodsId_master
                                                , _tmpMI_Child.GoodsKindId_complete     AS GoodsKindId_master
                                                , SUM (_tmpMI_Child.AmountNextResult)   AS AmountResult
                                           FROM _tmpMI_Child
                                           WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0 OR _tmpMI_Child.AmountNextResult <> 0 OR _tmpMI_Child.AmountNextSecondResult <> 0
                                           GROUP BY _tmpMI_Child.GoodsId_complete
                                                  , _tmpMI_Child.GoodsKindId_complete
                                         )
                            -- объединили Master и Child
                          , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                               , _tmpMI_master.GoodsId     AS GoodsId_master
                                               , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                                 -- сколько осталось для распределения
                                               , _tmpMI_master.AmountNext - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master

                                                 -- сколько надо на vbNumber ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                      WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                      WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                      WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                      WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                      WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                      WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                      WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      ELSE 0
                                                 END
                                                 -- МИНУС остаток + сколько уже распределили
                                               - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)
                                                 AS Amount_result

                                                 -- сколько надо на DayLimit ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE THEN tmpGoods_PackLimit.DayLimit * _tmpMI_Child.CountForecast ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 0  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 1  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 2  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 3  THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 4  THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 5  THEN 1 * _tmpMI_Child.Plan6 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 6  THEN 1 * _tmpMI_Child.Plan7 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 7  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 8  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 9  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 10 THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 11 THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 12 THEN (tmpGoods_PackLimit.DayLimit - 12) * _tmpMI_Child.CountForecast ELSE 0 END
                                                 AS Amount_result_DayLimit

                                                 -- остаток + сколько уже распределили
                                               , _tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult
                                                 AS Amount_result_old
                                                 --
                                               , tmpGoods_PackLimit.GoodsId AS GoodsId_DayLimit


                                          FROM _tmpMI_master
                                               INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                      AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                               LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                    AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
                                               LEFT JOIN _tmpGoods_delik ON _tmpGoods_delik.GoodsId = _tmpMI_master.GoodsId
                                               LEFT JOIN tmpGoods_PackOrder_noLimit ON tmpGoods_PackOrder_noLimit.GoodsId = _tmpMI_Child.GoodsId
                                               LEFT JOIN tmpGoods_PackLimit ON tmpGoods_PackLimit.GoodsId     = _tmpMI_Child.GoodsId
                                                                           AND tmpGoods_PackLimit.GoodsKindId = _tmpMI_Child.GoodsKindId

                                          WHERE -- если есть что распределять
                                                _tmpMI_master.AmountNext - COALESCE (tmpMI_summ.AmountResult, 0) > 0 -- если есть что распределять
                                                -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                            AND 0 < CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                         WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                         WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                         WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                         WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                         WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                         WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                         WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         ELSE 0
                                                    END
                                                    -- МИНУС остаток + сколько уже распределили
                                                  - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)

                                            -- !!!отбросили НАРЕЗКУ!!!
                                          /*AND (vbNumber <= vbdaycount_GoodsKind_8333
                                              OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333    -- НАР
                                                                                              , 6899005 -- нар. 200
                                                                                               )
                                                )*/
                                            -- !!!отбросили НАРЕЗКУ!!!
                                            AND ((vbNumber <= vbdaycount_GoodsKind_8333_3
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (6899005) -- нар. 200
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333)    -- нар.
                                               OR _tmpGoods_delik.GoodsId IS NULL
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (--6899005 -- нар. 200
                                                                                                 9027592 -- т/ф газ нар 0,1
                                                                                               , 8988926 -- т/ф газ нар 0,2
                                                                                               , 8988924 -- изопак скин нар 0,08
                                                                                               , 8988925 -- изопак скин нар 0,1
                                                                                                )
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )

                                             AND (tmpGoods_PackLimit.DayLimit >= vbNumber
                                               OR tmpGoods_PackLimit.GoodsId IS NULL
                                               OR vbUserId = 5
                                                 )
                                                )
                                         )
                            -- ИТОГО по Child для ПРОПОРЦИИ
                          , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                    , tmpMI_all.GoodsKindId_master
                                                    , SUM (tmpMI_all.Amount_result) AS Amount_result
                                               FROM tmpMI_all
                                               GROUP BY tmpMI_all.GoodsId_master
                                                      , tmpMI_all.GoodsKindId_master
                                              )
                       -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                       SELECT tmpMI_all.MovementItemId
                            , CASE -- если в Master больше чем ИТОГО по Child
                                   WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                        -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                        THEN ROUND (tmpMI_all.Amount_result, 1)
                                   ELSE -- иначе Распределяем
                                        ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                        -- tmpMI_all.Amount_result
                                        -- tmpMI_all.Amount_master

                              END AS Amount_result

                            , tmpMI_all.Amount_result_DayLimit
                            , tmpMI_all.Amount_result_old
                            , tmpMI_all.GoodsId_DayLimit
                       FROM tmpMI_all
                            INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                     AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                      ) AS tmpResult
                 WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId
                   -- если есть условие в днях, проверяем
                   AND (tmpResult.Amount_result_old + tmpResult.Amount_result <= tmpResult.Amount_result_DayLimit
                     OR tmpResult.GoodsId_DayLimit IS NULL
                       )
                ;

                 -- теперь следуюющий
                 vbNumber := vbNumber + 0.1;

             END LOOP;


             IF inIsByDay = TRUE -- AND 1=0
             THEN
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(),      MovementItem.Id, 0)
                 FROM MovementItem
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                    ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                   AND MIBoolean_Calculated.ValueData      = FALSE
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                   -- !!! отключил
                   --AND MIBoolean_Calculated.MovementItemId IS NULL
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext(),_tmpMI_Child.MovementItemId, _tmpMI_Child.AmountNextResult)
                       FROM _tmpMI_Child
                            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                          ON MIBoolean_Calculated.MovementItemId = _tmpMI_Child.MovementItemId
                                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                         AND MIBoolean_Calculated.ValueData      = FALSE
                       WHERE _tmpMI_Child.AmountNextResult <> 0
                         -- !!! отключил
                         --AND MIBoolean_Calculated.MovementItemId IS NULL
                      ) AS tmp
                ;

             ELSE
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext_calc(), MovementItem.Id, 0)
                 FROM MovementItem
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                    ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                   AND MIBoolean_Calculated.ValueData      = FALSE
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                   -- !!! отключил
                   --AND MIBoolean_Calculated.MovementItemId IS NULL
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNext_calc(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountNextResult)
                       FROM _tmpMI_Child
                            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                          ON MIBoolean_Calculated.MovementItemId = _tmpMI_Child.MovementItemId
                                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                         AND MIBoolean_Calculated.ValueData      = FALSE
                       WHERE _tmpMI_Child.AmountNextResult <> 0
                         -- !!! отключил
                         -- AND MIBoolean_Calculated.MovementItemId IS NULL
                      ) AS tmp
                ;

             END IF;

         END IF;


         -- ЧЕТВЕРТЫЙ
         IF inIsPackNextSecond = TRUE
         THEN
             vbNumber:= 0;
             WHILE vbNumber <= inNumber
             LOOP
                 UPDATE _tmpMI_Child SET AmountNextSecondResult = CASE WHEN _tmpMI_Child.isCalculated = TRUE
                                                                            THEN _tmpMI_Child.AmountNextSecondResult + tmpResult.Amount_result
                                                                       ELSE _tmpMI_Child.AmountNextSecondResult
                                                                  END
                 FROM (WITH -- разрешено расписывать план на производство в цехе упак больше чем 5 дней
                            tmpGoods_PackOrder_noLimit AS (SELECT 3458129 AS GoodsId -- 991 - ШИЙКА LA PARMA с/в в/ґ ТМ Алан
                                                          )
                            -- разрешено расписывать план на такое ко-во дней
                          , tmpGoods_PackLimit AS (SELECT DISTINCT
                                                          ObjectLink_Goods.ChildObjectId     AS GoodsId
                                                        , ObjectLink_GoodsKind.ChildObjectId AS GoodsKindId
                                                        , COALESCE (ObjectFloat_PackLimit.ValueData, 0) AS DayLimit
                                                   FROM ObjectBoolean AS ObjectBoolean_PackLimit
                                                        INNER JOIN Object ON Object.Id       = ObjectBoolean_PackLimit.ObjectId
                                                                         AND Object.isErased = FALSE
                                                        INNER JOIN ObjectLink AS ObjectLink_Goods
                                                                              ON ObjectLink_Goods.ObjectId = Object.Id
                                                                             AND ObjectLink_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                                        INNER JOIN ObjectLink AS ObjectLink_GoodsKind
                                                                              ON ObjectLink_GoodsKind.ObjectId = Object.Id
                                                                             AND ObjectLink_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                        LEFT JOIN ObjectFloat AS ObjectFloat_PackLimit
                                                                              ON ObjectFloat_PackLimit.ObjectId  = Object.Id
                                                                             AND ObjectFloat_PackLimit.DescId    = zc_ObjectFloat_GoodsByGoodsKind_PackLimit()

                                                   WHERE ObjectBoolean_PackLimit.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_PackLimit()
                                                     AND ObjectBoolean_PackLimit.ValueData = TRUE
                                                     --AND vbUserId = 5
                                                  )
                            -- сумма - сколько уже распределили
                          , tmpMI_summ AS (SELECT _tmpMI_Child.GoodsId_complete             AS GoodsId_master
                                                , _tmpMI_Child.GoodsKindId_complete         AS GoodsKindId_master
                                                , SUM (_tmpMI_Child.AmountNextSecondResult) AS AmountResult
                                           FROM _tmpMI_Child
                                           WHERE _tmpMI_Child.AmountResult <> 0 OR _tmpMI_Child.AmountSecondResult <> 0 OR _tmpMI_Child.AmountNextResult <> 0 OR _tmpMI_Child.AmountNextSecondResult <> 0
                                           GROUP BY _tmpMI_Child.GoodsId_complete
                                                  , _tmpMI_Child.GoodsKindId_complete
                                         )
                            -- объединили Master и Child
                          , tmpMI_all AS (SELECT _tmpMI_Child.MovementItemId
                                               , _tmpMI_master.GoodsId     AS GoodsId_master
                                               , _tmpMI_master.GoodsKindId AS GoodsKindId_master
                                                 -- сколько осталось для распределения
                                               , _tmpMI_master.AmountNextSecond - COALESCE (tmpMI_summ.AmountResult, 0) AS Amount_master

                                                 -- сколько надо на vbNumber ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                      WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                      WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                      WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                      WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                      WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                      WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                      WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                      ELSE 0
                                                 END
                                                 -- МИНУС остаток + сколько уже распределили
                                               - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)
                                                 AS Amount_result

                                                 -- сколько надо на DayLimit ДНЕЙ
                                               , CASE WHEN inIsByDay = FALSE THEN tmpGoods_PackLimit.DayLimit * _tmpMI_Child.CountForecast ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 0  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 1  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 2  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 3  THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 4  THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 5  THEN 1 * _tmpMI_Child.Plan6 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 6  THEN 1 * _tmpMI_Child.Plan7 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 7  THEN 1 * _tmpMI_Child.Plan1 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 8  THEN 1 * _tmpMI_Child.Plan2 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 9  THEN 1 * _tmpMI_Child.Plan3 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 10 THEN 1 * _tmpMI_Child.Plan4 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 11 THEN 1 * _tmpMI_Child.Plan5 ELSE 0 END
                                               + CASE WHEN inIsByDay = TRUE AND tmpGoods_PackLimit.DayLimit > 12 THEN (tmpGoods_PackLimit.DayLimit - 12) * _tmpMI_Child.CountForecast ELSE 0 END
                                                 AS Amount_result_DayLimit

                                                 -- остаток + сколько уже распределили
                                               , _tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult
                                                 AS Amount_result_old
                                                 --
                                               , tmpGoods_PackLimit.GoodsId AS GoodsId_DayLimit


                                          FROM _tmpMI_master
                                               INNER JOIN _tmpMI_Child ON _tmpMI_Child.GoodsId_complete     = _tmpMI_master.GoodsId
                                                                      AND _tmpMI_Child.GoodsKindId_complete = _tmpMI_master.GoodsKindId
                                               LEFT JOIN tmpMI_summ  ON tmpMI_summ.GoodsId_master     = _tmpMI_master.GoodsId
                                                                    AND tmpMI_summ.GoodsKindId_master = _tmpMI_master.GoodsKindId
                                               LEFT JOIN _tmpGoods_delik ON _tmpGoods_delik.GoodsId = _tmpMI_master.GoodsId
                                               LEFT JOIN tmpGoods_PackOrder_noLimit ON tmpGoods_PackOrder_noLimit.GoodsId = _tmpMI_Child.GoodsId
                                               LEFT JOIN tmpGoods_PackLimit ON tmpGoods_PackLimit.GoodsId     = _tmpMI_Child.GoodsId
                                                                           AND tmpGoods_PackLimit.GoodsKindId = _tmpMI_Child.GoodsKindId

                                          WHERE -- если есть что распределять
                                                _tmpMI_master.AmountNextSecond - COALESCE (tmpMI_summ.AmountResult, 0) > 0 -- если есть что распределять
                                                -- если на vbNumber ДНЕЙ ЕСТЬ ПОТРЕБНОСТЬ
                                            AND 0 < CASE WHEN inIsByDay = FALSE OR vbNumber > 12 THEN vbNumber * _tmpMI_Child.CountForecast
                                                         WHEN vbNumber > 0  AND vbNumber <= 1  THEN vbNumber * _tmpMI_Child.Plan1
                                                         WHEN vbNumber > 1  AND vbNumber <= 2  THEN _tmpMI_Child.Plan1 + (vbNumber - 1) * _tmpMI_Child.Plan2
                                                         WHEN vbNumber > 2  AND vbNumber <= 3  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + (vbNumber - 2) * _tmpMI_Child.Plan3
                                                         WHEN vbNumber > 3  AND vbNumber <= 4  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + (vbNumber - 3) * _tmpMI_Child.Plan4
                                                         WHEN vbNumber > 4  AND vbNumber <= 5  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + (vbNumber - 4) * _tmpMI_Child.Plan5
                                                         WHEN vbNumber > 5  AND vbNumber <= 6  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + (vbNumber - 5) * _tmpMI_Child.Plan6
                                                         WHEN vbNumber > 6  AND vbNumber <= 7  THEN _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + (vbNumber - 6) * _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 7  AND vbNumber <= 8  THEN 1 * _tmpMI_Child.Plan1 + (vbNumber - 7) * _tmpMI_Child.Plan1 + _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 8  AND vbNumber <= 9  THEN 2 * _tmpMI_Child.Plan1 + (vbNumber - 8) * _tmpMI_Child.Plan2 + _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 9  AND vbNumber <= 10 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + (vbNumber - 9) * _tmpMI_Child.Plan3 + _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 10 AND vbNumber <= 11 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + (vbNumber - 10) * _tmpMI_Child.Plan4 + _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         WHEN vbNumber > 11 AND vbNumber <= 12 THEN 2 * _tmpMI_Child.Plan1 + 2 * _tmpMI_Child.Plan2 + 2 * _tmpMI_Child.Plan3 + 2 * _tmpMI_Child.Plan4 + (vbNumber - 11) * _tmpMI_Child.Plan5 + _tmpMI_Child.Plan6 + _tmpMI_Child.Plan7
                                                         ELSE 0
                                                    END
                                                    -- МИНУС остаток + сколько уже распределили
                                                  - (_tmpMI_Child.RemainsStart + _tmpMI_Child.AmountResult + _tmpMI_Child.AmountSecondResult + _tmpMI_Child.AmountNextResult + _tmpMI_Child.AmountNextSecondResult)

                                            -- !!!отбросили НАРЕЗКУ!!!
                                          /*AND (vbNumber <= vbdaycount_GoodsKind_8333
                                              OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333    -- НАР
                                                                                              , 6899005 -- нар. 200
                                                                                               )
                                                )*/
                                            -- !!!отбросили НАРЕЗКУ!!!
                                            AND ((vbNumber <= vbdaycount_GoodsKind_8333_3
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (6899005) -- нар. 200
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (8333)    -- нар.
                                               OR _tmpGoods_delik.GoodsId IS NULL
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )
                                             AND (vbNumber <= vbdaycount_GoodsKind_8333
                                               OR COALESCE (_tmpMI_Child.GoodsKindId, 0) NOT IN (--6899005 -- нар. 200
                                                                                                 9027592 -- т/ф газ нар 0,1
                                                                                               , 8988926 -- т/ф газ нар 0,2
                                                                                               , 8988924 -- изопак скин нар 0,08
                                                                                               , 8988925 -- изопак скин нар 0,1
                                                                                                )
                                               OR tmpGoods_PackOrder_noLimit.GoodsId > 0
                                               OR (tmpGoods_PackLimit.DayLimit >= vbNumber AND tmpGoods_PackLimit.DayLimit > 0)
                                                 )

                                             AND (tmpGoods_PackLimit.DayLimit >= vbNumber
                                               OR tmpGoods_PackLimit.GoodsId IS NULL
                                               OR vbUserId = 5
                                                 )
                                                )
                                         )
                            -- ИТОГО по Child для ПРОПОРЦИИ
                          , tmpMI_all_summ AS (SELECT tmpMI_all.GoodsId_master
                                                    , tmpMI_all.GoodsKindId_master
                                                    , SUM (tmpMI_all.Amount_result) AS Amount_result
                                               FROM tmpMI_all
                                               GROUP BY tmpMI_all.GoodsId_master
                                                      , tmpMI_all.GoodsKindId_master
                                              )
                       -- Результат - здесь распределяем, НО ТОЛЬКО ЕСЛИ НАДО
                       SELECT tmpMI_all.MovementItemId
                            , CASE -- если в Master больше чем ИТОГО по Child
                                   WHEN tmpMI_all_summ.Amount_result <= tmpMI_all.Amount_master
                                        -- тогда сколько надо на vbNumber ДНЕЙ, т.е. НЕ распределяем
                                        THEN ROUND (tmpMI_all.Amount_result, 1)
                                   ELSE -- иначе Распределяем
                                        ROUND (tmpMI_all.Amount_master * tmpMI_all.Amount_result / tmpMI_all_summ.Amount_result, 1)
                                        -- tmpMI_all.Amount_result
                                        -- tmpMI_all.Amount_master

                              END AS Amount_result

                            , tmpMI_all.Amount_result_DayLimit
                            , tmpMI_all.Amount_result_old
                            , tmpMI_all.GoodsId_DayLimit
                       FROM tmpMI_all
                            INNER JOIN tmpMI_all_summ ON tmpMI_all_summ.GoodsId_master     = tmpMI_all.GoodsId_master
                                                     AND tmpMI_all_summ.GoodsKindId_master = tmpMI_all.GoodsKindId_master
                      ) AS tmpResult
                 WHERE tmpResult.MovementItemId = _tmpMI_Child.MovementItemId
                   -- если есть условие в днях, проверяем
                   AND (tmpResult.Amount_result_old + tmpResult.Amount_result <= tmpResult.Amount_result_DayLimit
                     OR tmpResult.GoodsId_DayLimit IS NULL
                       )
                ;

                 -- теперь следуюющий
                 vbNumber := vbNumber + 0.1;

             END LOOP;


             IF inIsByDay = TRUE -- AND 1=0
             THEN
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(),      MovementItem.Id, 0)
                 FROM MovementItem
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                    ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                   AND MIBoolean_Calculated.ValueData      = FALSE
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                   -- !!! отключил
                   --AND MIBoolean_Calculated.MovementItemId IS NULL
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountNextSecondResult)
                       FROM _tmpMI_Child
                            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                          ON MIBoolean_Calculated.MovementItemId = _tmpMI_Child.MovementItemId
                                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                         AND MIBoolean_Calculated.ValueData      = FALSE
                       WHERE _tmpMI_Child.AmountNextSecondResult <> 0
                         -- !!! отключил
                         --AND MIBoolean_Calculated.MovementItemId IS NULL
                      ) AS tmp
                ;

             ELSE
                 -- ОБНУЛИЛИ
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond_calc(), MovementItem.Id, 0)
                 FROM MovementItem
                      LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                    ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                   AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                   AND MIBoolean_Calculated.ValueData      = FALSE
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.ObjectId   NOT IN (489150 -- select * from object where Id = 489150 -- 2293 - Нар. АССОРТИ 300 г/шт
                                                      )
                   -- !!! отключил
                   --AND MIBoolean_Calculated.MovementItemId IS NULL
                ;
                 -- сохранили протокол
                 PERFORM lpInsert_MovementItemProtocol (tmp.MovementItemId, vbUserId, FALSE)
                 FROM (-- СОХРАНИЛИ
                       SELECT _tmpMI_Child.MovementItemId
                            , lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPackNextSecond_calc(), _tmpMI_Child.MovementItemId, _tmpMI_Child.AmountNextSecondResult)
                       FROM _tmpMI_Child
                            LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                          ON MIBoolean_Calculated.MovementItemId = _tmpMI_Child.MovementItemId
                                                         AND MIBoolean_Calculated.DescId         = zc_MIBoolean_Calculated()
                                                         AND MIBoolean_Calculated.ValueData      = FALSE
                       WHERE _tmpMI_Child.AmountNextSecondResult <> 0
                         -- !!! отключил
                         --AND MIBoolean_Calculated.MovementItemId IS NULL
                      ) AS tmp
                ;

             END IF;

         END IF;


        -- сохранили новый расчет
        PERFORM lpInsert_MovementItemProtocol (tmpMI.MovementItemId_new, vbUserId, tmpMI.isInsert)

        FROM (SELECT tmpMI.MovementItemId_new, tmpMI.isInsert
                     -- сохранили св-во
                   , lpInsertUpdate_MovementItemFloat (tmpMI.DescId_1, tmpMI.MovementItemId_new, COALESCE (tmpMI.Amount_1, 0))
                     -- сохранили св-во
                   , lpInsertUpdate_MovementItemFloat (tmpMI.DescId_2, tmpMI.MovementItemId_new, COALESCE (tmpMI.Amount_2, 0))
                     -- сохранили св-во
                   , lpInsertUpdate_MovementItemFloat (tmpMI.DescId_3, tmpMI.MovementItemId_new, COALESCE (tmpMI.Amount_3, 0))
                     -- сохранили св-во
                   , lpInsertUpdate_MovementItemFloat (tmpMI.DescId_4, tmpMI.MovementItemId_new, COALESCE (tmpMI.Amount_4, 0))
                     -- сохранили св-во
                   , lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), tmpMI.MovementItemId_new, tmpMI.isCalculated)
                     -- сохранили протокол
                   , CASE WHEN tmpMI.DescId_date = zc_MIDate_Insert() OR inIsByDay = FALSE THEN lpInsertUpdate_MovementItemDate (tmpMI.DescId_date, tmpMI.MovementItemId_new, CURRENT_TIMESTAMP) END
                     -- сохранили протокол
                   , CASE WHEN tmpMI.DescId_user > 0 AND inIsByDay = FALSE THEN lpInsertUpdate_MovementItemLinkObject (tmpMI.DescId_user, tmpMI.MovementItemId_new, vbUserId) END

              FROM (SELECT  tmpMI.DescId_1, tmpMI.Amount_1
                          , tmpMI.DescId_2, tmpMI.Amount_2
                          , tmpMI.DescId_3, tmpMI.Amount_3
                          , tmpMI.DescId_4, tmpMI.Amount_4
                          , tmpMI.isCalculated
                            --
                          , CASE WHEN tmpMI.MovementItemId > 0 THEN zc_MIDate_Update()       ELSE zc_MIDate_Insert() END AS DescId_date
                          , CASE WHEN tmpMI.MovementItemId > 0 THEN zc_MILinkObject_Update() ELSE NULL               END AS DescId_user
                          , CASE WHEN tmpMI.MovementItemId > 0 THEN FALSE                    ELSE TRUE               END AS isInsert
                            -- сохранили элемент
                          , lpInsertUpdate_MovementItem (ioId          := tmpMI.MovementItemId
                                                       , inDescId      := zc_MI_Detail()
                                                       , inObjectId    := CASE WHEN tmpMI.MovementItemId > 0 THEN tmpMI.UserId ELSE vbUserId END
                                                       , inMovementId  := inMovementId
                                                       , inAmount      := vbSessionId
                                                       , inParentId    := tmpMI.ParentId
                                                       , inUserId      := vbUserId
                                                        ) AS MovementItemId_new
                    FROM (WITH tmpMI_detail AS (SELECT MovementItem.Id AS MovementItemId, MovementItem.ParentId, MovementItem.ObjectId AS UserId
                                                FROM MovementItem
                                                WHERE MovementItem.MovementId =  inMovementId
                                                  AND MovementItem.DescId     =  zc_MI_Detail()
                                                  -- с этим № п/п
                                                  AND MovementItem.Amount     =  vbSessionId
                                                  -- временно
                                                  AND MovementItem.isErased   =  FALSE
                                               )
                         , tmpMI_detail_all AS (SELECT DISTINCT MovementItem.ParentId
                                                FROM MovementItem
                                                WHERE MovementItem.MovementId =  inMovementId
                                                  AND MovementItem.DescId     =  zc_MI_Detail()
                                                  -- временно
                                                  AND MovementItem.isErased   =  FALSE
                                               )
                          --
                          SELECT tmpMI_detail.MovementItemId
                               , COALESCE (_tmpMI_Child.MovementItemId, tmpMI_detail.ParentId) AS ParentId
                               , COALESCE (_tmpMI_Child.isCalculated, TRUE) AS isCalculated
                               , tmpMI_detail.UserId
                                 -- 1
                               , CASE WHEN inIsByDay = TRUE
                                      THEN zc_MIFloat_AmountPack()
                                      ELSE zc_MIFloat_AmountPack_calc()
                                 END AS DescId_1
                                 --
                               , _tmpMI_Child.AmountResult AS Amount_1

                                 -- 2
                               , CASE WHEN inIsByDay = TRUE
                                      THEN zc_MIFloat_AmountPackSecond()
                                      ELSE zc_MIFloat_AmountPackSecond_calc()
                                 END AS DescId_2
                                 --
                               , _tmpMI_Child.AmountSecondResult AS Amount_2

                                 -- 3
                               , CASE WHEN inIsByDay = TRUE
                                      THEN zc_MIFloat_AmountPackNext()
                                      ELSE zc_MIFloat_AmountPackNext_calc()
                                 END AS DescId_3
                                 --
                               , _tmpMI_Child.AmountNextResult AS Amount_3

                                 -- 4
                               , CASE WHEN inIsByDay = TRUE
                                          THEN zc_MIFloat_AmountPackNextSecond()
                                      ELSE zc_MIFloat_AmountPackNextSecond_calc()
                                 END AS DescId_4
                                 -- 4
                               , _tmpMI_Child.AmountNextSecondResult AS Amount_4

                          FROM (SELECT *
                                FROM _tmpMI_Child
                                     LEFT JOIN tmpMI_detail_all ON tmpMI_detail_all.ParentId = _tmpMI_Child.MovementItemId
                                WHERE _tmpMI_Child.AmountResult           <> 0
                                   OR _tmpMI_Child.AmountSecondResult     <> 0
                                   OR _tmpMI_Child.AmountNextResult       <> 0
                                   OR _tmpMI_Child.AmountNextSecondResult <> 0
                                   OR tmpMI_detail_all.ParentId            > 0
                               ) AS _tmpMI_Child
                               FULL JOIN tmpMI_detail ON tmpMI_detail.ParentId = _tmpMI_Child.MovementItemId
                         ) AS tmpMI
                   ) AS tmpMI

             ) AS tmpMI;


        -- только для этого режима
        IF inIsByDay = FALSE
        THEN
             -- сохранили свойство <последний расчет>
             PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId, TRUE);
        END IF;



    END IF;-- ELSE IF inIsClear = TRUE


     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , vbOperDate_Begin1
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpUpdateMI_OrderInternal_Amount_toPACK'
               -- ProtocolData
             , inMovementId :: TVarChar
    || ', ' || COALESCE (inId, 0) :: TVarChar
    || ', ' || inNumber :: TVarChar
    || ', ' || CASE WHEN inIsClear          = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || CASE WHEN inIsPack           = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || CASE WHEN inIsPackSecond     = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || CASE WHEN inIsPackNext       = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || CASE WHEN inIsPackNextSecond = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || CASE WHEN inIsByDay          = TRUE THEN 'TRUE' ELSE 'FALSE' END
    || ', ' || inSession
              ;

IF vbUserId = 5 AND inIsByDay = TRUE
   AND 1=1
THEN
    RAISE EXCEPTION 'Ошибка.test ok <%>  <%>  <%> <%> <%>    <%>   <%>'
             , (SELECT MIB.ValueData FROM MovementItemBoolean AS MIB WHERE MIB.MovementItemId = 310035796    AND MIB.DescId = zc_MIBoolean_Calculated())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796   AND MIF.DescId = zc_MIFloat_AmountPack())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackSecond())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackNext())
             , (SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = 310035796    AND MIF.DescId = zc_MIFloat_AmountPackNextSecond())
             , (SELECT _tmpMI_Child.AmountResult FROM _tmpMI_Child WHERE _tmpMI_Child.MovementItemId = 310035796)
             , (SELECT _tmpMI_Child.AmountNextSecondResult FROM _tmpMI_Child WHERE _tmpMI_Child.MovementItemId = 310035796)
              ;
END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.11.17                                        *
*/
-- select * from ResourseProtocol where ProcName ilike 'gpUpdateMI_OrderInternal_Amount_toPACK' order by id desc limit 4
-- тест
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7463900, inId:= 0, inNumber:= 100, inIsClear:= FALSE, inIsPack:= TRUE, inIsPackSecond:= TRUE, inIsByDay:= TRUE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7463854, inId:= 0, inNumber:= 100, inIsClear:= FALSE, inIsPack:= TRUE, inIsPackSecond:= TRUE, inIsByDay:= TRUE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7483996, inId:= 0, inNumber:= 100, inIsClear:= FALSE, inIsPack:= TRUE, inIsPackSecond:= TRUE, inIsByDay:= TRUE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpUpdateMI_OrderInternal_Amount_toPACK (inMovementId:= 7487127, inId:= 0, inNumber:= 100, inIsClear:= FALSE, inIsPack:= TRUE, inIsPackSecond:= TRUE, inIsByDay:= TRUE, inSession:= zfCalc_UserAdmin());
