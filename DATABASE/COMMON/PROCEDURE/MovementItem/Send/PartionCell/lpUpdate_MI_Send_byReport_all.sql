-- Function: lpUpdate_MI_Send_byReport_all()

/*DROP FUNCTION IF EXISTS lpUpdate_MI_Send_byReport_all (Integer, TDateTime, TDateTime, Integer, Integer, TDateTime
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer
                                                      );*/

DROP FUNCTION IF EXISTS lpUpdate_MI_Send_byReport_all (Integer, TDateTime, TDateTime, Integer, Integer, TDateTime
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer
                                                      );

CREATE OR REPLACE FUNCTION lpUpdate_MI_Send_byReport_all(
    IN inUnitId                Integer  , --
    IN inStartDate             TDateTime,
    IN inEndDate               TDateTime,
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime, --
    IN inPartionCellId_1       Integer  , --
    IN inPartionCellId_2       Integer  ,
    IN inPartionCellId_3       Integer  ,
    IN inPartionCellId_4       Integer  ,
    IN inPartionCellId_5       Integer  ,
    IN inPartionCellId_6       Integer  , --
    IN inPartionCellId_7       Integer  ,
    IN inPartionCellId_8       Integer  ,
    IN inPartionCellId_9       Integer  ,
    IN inPartionCellId_10      Integer  ,
    IN inPartionCellId_11      Integer  ,
    IN inPartionCellId_12      Integer  ,
    IN inPartionCellId_13      Integer  ,
    IN inPartionCellId_14      Integer  ,
    IN inPartionCellId_15      Integer  ,
    IN inPartionCellId_16      Integer  , --
    IN inPartionCellId_17      Integer  ,
    IN inPartionCellId_18      Integer  ,
    IN inPartionCellId_19      Integer  ,
    IN inPartionCellId_20      Integer  ,
    IN inPartionCellId_21      Integer  ,
    IN inPartionCellId_22      Integer  ,

    IN inPartionCellId_1_new   Integer  , --
    IN inPartionCellId_2_new   Integer  ,
    IN inPartionCellId_3_new   Integer  ,
    IN inPartionCellId_4_new   Integer  ,
    IN inPartionCellId_5_new   Integer  ,
    IN inPartionCellId_6_new   Integer  , --
    IN inPartionCellId_7_new   Integer  ,
    IN inPartionCellId_8_new   Integer  ,
    IN inPartionCellId_9_new   Integer  ,
    IN inPartionCellId_10_new  Integer  ,
    IN inPartionCellId_11_new  Integer  ,
    IN inPartionCellId_12_new  Integer  ,
    IN inPartionCellId_13_new  Integer  ,
    IN inPartionCellId_14_new  Integer  ,
    IN inPartionCellId_15_new  Integer  ,
    IN inPartionCellId_16_new  Integer  , --
    IN inPartionCellId_17_new  Integer  ,
    IN inPartionCellId_18_new  Integer  ,
    IN inPartionCellId_19_new  Integer  ,
    IN inPartionCellId_20_new  Integer  ,
    IN inPartionCellId_21_new  Integer  ,
    IN inPartionCellId_22_new  Integer  ,

   OUT outPartionCellId_1      Integer  , --
   OUT outPartionCellId_2      Integer  ,
   OUT outPartionCellId_3      Integer  ,
   OUT outPartionCellId_4      Integer  ,
   OUT outPartionCellId_5      Integer  ,
   OUT outPartionCellId_6      Integer  , --
   OUT outPartionCellId_7      Integer  ,
   OUT outPartionCellId_8      Integer  ,
   OUT outPartionCellId_9      Integer  ,
   OUT outPartionCellId_10     Integer  ,
   OUT outPartionCellId_11     Integer  ,
   OUT outPartionCellId_12     Integer  ,
   OUT outPartionCellId_13     Integer  ,
   OUT outPartionCellId_14     Integer  ,
   OUT outPartionCellId_15     Integer  ,
   OUT outPartionCellId_16     Integer  , --
   OUT outPartionCellId_17     Integer  ,
   OUT outPartionCellId_18     Integer  ,
   OUT outPartionCellId_19     Integer  ,
   OUT outPartionCellId_20     Integer  ,
   OUT outPartionCellId_21     Integer  ,
   OUT outPartionCellId_22     Integer  ,

   OUT outIsClose_1            Boolean  ,
   OUT outIsClose_2            Boolean  ,
   OUT outIsClose_3            Boolean  ,
   OUT outIsClose_4            Boolean  ,
   OUT outIsClose_5            Boolean  ,
   OUT outIsClose_6            Boolean  ,
   OUT outIsClose_7            Boolean  ,
   OUT outIsClose_8            Boolean  ,
   OUT outIsClose_9            Boolean  ,
   OUT outIsClose_10           Boolean  ,
   OUT outIsClose_11           Boolean  ,
   OUT outIsClose_12           Boolean  ,
   OUT outIsClose_13           Boolean  ,
   OUT outIsClose_14           Boolean  ,
   OUT outIsClose_15           Boolean  ,
   OUT outIsClose_16           Boolean  ,
   OUT outIsClose_17           Boolean  ,
   OUT outIsClose_18           Boolean  ,
   OUT outIsClose_19           Boolean  ,
   OUT outIsClose_20           Boolean  ,
   OUT outIsClose_21           Boolean  ,
   OUT outIsClose_22           Boolean  ,

    IN inUserId                Integer
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbCount_begin Integer;
   DECLARE vbCount_start Integer;
   DECLARE vbLimit_1     Integer;
   DECLARE vbLimit_2     Integer;
   DECLARE vbIsWeighing Boolean;
BEGIN

     vbIsWeighing:= TRUE; -- inUserId = 5;

     -- !!!замена!!!
     IF COALESCE (inUnitId,0) = 0
     THEN
         inUnitId := zc_Unit_RK();
     END IF;


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_PartionCell')
     THEN
         DELETE FROM _tmpItem_PartionCell;
     ELSE
         -- таблица - элементы
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementId Integer, MovementItemId Integer, Amount TFloat, DescId_MILO Integer, PartionCellId Integer, isRePack Boolean) ON COMMIT DROP;
     END IF;


     INSERT INTO _tmpItem_PartionCell (MovementId, MovementItemId, Amount, DescId_MILO, PartionCellId, isRePack)
       WITH -- дл€ ѕарти€ дата
            tmpMI_PartionDate AS (SELECT MovementItem.MovementId                  AS MovementId
                                       , MovementItem.Id                          AS MovementItemId
                                       , MovementItem.Amount                      AS Amount
                                         -- текущее значение
                                       , COALESCE (MILO_PartionCell.DescId, 0)    AS DescId_MILO
                                       , COALESCE (MILO_PartionCell.ObjectId, 0)  AS PartionCellId

                                  FROM MovementItemDate AS MIDate_PartionGoods
                                       INNER JOIN MovementItem ON MovementItem.Id       = MIDate_PartionGoods.MovementItemId
                                                              AND MovementItem.DescId   = zc_MI_Master()
                                                              AND MovementItem.isErased = FALSE
                                                              -- ограничили товаром
                                                              AND MovementItem.ObjectId = inGoodsId

                                       LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                                       LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                        ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                       AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

                                       LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                        ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                       AND MILO_PartionCell.ObjectId       > 0
                                                                       AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                             , zc_MILinkObject_PartionCell_2()
                                                                                                             , zc_MILinkObject_PartionCell_3()
                                                                                                             , zc_MILinkObject_PartionCell_4()
                                                                                                             , zc_MILinkObject_PartionCell_5()
                                                                                                             , zc_MILinkObject_PartionCell_6()
                                                                                                             , zc_MILinkObject_PartionCell_7()
                                                                                                             , zc_MILinkObject_PartionCell_8()
                                                                                                             , zc_MILinkObject_PartionCell_9()
                                                                                                             , zc_MILinkObject_PartionCell_10()
                                                                                                             , zc_MILinkObject_PartionCell_11()
                                                                                                             , zc_MILinkObject_PartionCell_12()
                                                                                                             , zc_MILinkObject_PartionCell_13()
                                                                                                             , zc_MILinkObject_PartionCell_14()
                                                                                                             , zc_MILinkObject_PartionCell_15()
                                                                                                             , zc_MILinkObject_PartionCell_16()
                                                                                                             , zc_MILinkObject_PartionCell_17()
                                                                                                             , zc_MILinkObject_PartionCell_18()
                                                                                                             , zc_MILinkObject_PartionCell_19()
                                                                                                             , zc_MILinkObject_PartionCell_20()
                                                                                                             , zc_MILinkObject_PartionCell_21()
                                                                                                             , zc_MILinkObject_PartionCell_22()
                                                                                                              )
                                                                       -- !!!
                                                                       -- AND 1=0

                                  -- ограничили ѕарти€ дата, если установлена дл€ MI
                                  WHERE MIDate_PartionGoods.ValueData = inPartionGoodsDate
                                    AND MIDate_PartionGoods.DescId    = zc_MIDate_PartionGoods()
                                    -- ограничили видом
                                    AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                                    -- ѕеремещение + ¬звешивание
                                    AND ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId = zc_Enum_Status_Complete())
                                      OR (Movement.DescId = zc_Movement_WeighingProduction() AND Movement.StatusId = zc_Enum_Status_UnComplete() AND vbIsWeighing = TRUE)
                                        )
                                 )

            -- или документы за период, дата документа = дата партии
          , tmpMovement AS (-- ѕеремещение
                            SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                            WHERE Movement.OperDate = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
 
                           UNION ALL
                            -- ¬звешивание
                            SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From.ObjectId   IN (zc_Unit_Pack(), zc_Unit_RK_Label())
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                                 LEFT JOIN MovementFloat AS MovementFloat_BranchCode
                                                         ON MovementFloat_BranchCode.MovementId = Movement.Id
                                                        AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                 LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                                         ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                                        AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
                                                        AND MovementFloat_MovementDescNumber.ValueData  = 25 -- ѕерепак
                                                        -- !!!
                                                        AND MovementFloat_BranchCode.ValueData          = 1
                           WHERE Movement.OperDate  = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_WeighingProduction()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND vbIsWeighing = TRUE
                              -- без ѕерепак
                              AND MovementFloat_MovementDescNumber.MovementId IS NULL
                           )

          , tmpMI AS (SELECT MovementItem.MovementId        AS MovementId
                           , MovementItem.Id                AS MovementItemId
                           , MovementItem.Amount            AS Amount
                             -- текущее значение
                           , COALESCE (MILO_PartionCell.DescId, 0)    AS DescId_MILO
                           , COALESCE (MILO_PartionCell.ObjectId, 0)  AS PartionCellId
                             --
                           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) AS isRePack

                      FROM MovementItem
                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = MovementItem.MovementId
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()

                           LEFT JOIN tmpMI_PartionDate ON tmpMI_PartionDate.MovementItemId = MovementItem.Id
                           -- выбрали только с пустой ѕарти€ дата
                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                            ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                           AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                           AND MILO_PartionCell.ObjectId       > 0
                                                           AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                 , zc_MILinkObject_PartionCell_2()
                                                                                                 , zc_MILinkObject_PartionCell_3()
                                                                                                 , zc_MILinkObject_PartionCell_4()
                                                                                                 , zc_MILinkObject_PartionCell_5()
                                                                                                 , zc_MILinkObject_PartionCell_6()
                                                                                                 , zc_MILinkObject_PartionCell_7()
                                                                                                 , zc_MILinkObject_PartionCell_8()
                                                                                                 , zc_MILinkObject_PartionCell_9()
                                                                                                 , zc_MILinkObject_PartionCell_10()
                                                                                                 , zc_MILinkObject_PartionCell_11()
                                                                                                 , zc_MILinkObject_PartionCell_12()
                                                                                                 , zc_MILinkObject_PartionCell_13()
                                                                                                 , zc_MILinkObject_PartionCell_14()
                                                                                                 , zc_MILinkObject_PartionCell_15()
                                                                                                 , zc_MILinkObject_PartionCell_16()
                                                                                                 , zc_MILinkObject_PartionCell_17()
                                                                                                 , zc_MILinkObject_PartionCell_18()
                                                                                                 , zc_MILinkObject_PartionCell_19()
                                                                                                 , zc_MILinkObject_PartionCell_20()
                                                                                                 , zc_MILinkObject_PartionCell_21()
                                                                                                 , zc_MILinkObject_PartionCell_22()
                                                                                                  )
                                                           -- !!!
                                                           -- AND 1=0

                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItem.DescId   = zc_MI_Master()
                        AND MovementItem.isErased = FALSE
                        -- ограничили товаром
                        AND MovementItem.ObjectId = inGoodsId
                        -- ограничили видом
                        AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                        -- пуста€ ѕарти€ дата
                        AND MIDate_PartionGoods.ValueData IS NULL
                        -- нет в этом списке
                        AND tmpMI_PartionDate.MovementItemId IS NULL

                     UNION ALL
                      SELECT tmpMI_PartionDate.MovementId
                           , tmpMI_PartionDate.MovementItemId
                           , tmpMI_PartionDate.Amount
                             -- текущее значение
                           , tmpMI_PartionDate.DescId_MILO
                           , tmpMI_PartionDate.PartionCellId
                             --
                           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) AS isRePack

                      FROM tmpMI_PartionDate
                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = tmpMI_PartionDate.MovementId
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
                     )
       -- –езультат
       SELECT MovementId, MovementItemId, Amount
              -- текущее значение
            , DescId_MILO
            , PartionCellId
              -- 
            , isRePack

       FROM tmpMI
      ;


--    RAISE EXCEPTION 'ќшибка. <%>', (select count(*) from _tmpItem_PartionCell);


     -- сколько €чеек надо заполнить
     vbCount_begin:= 0;
     --
     -- IF COALESCE (inPartionCellId_1, 0)  <> COALESCE (inPartionCellId_1_new, 0) AND COALESCE (inPartionCellId_1_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_1_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_2, 0)  <> COALESCE (inPartionCellId_2_new, 0) AND COALESCE (inPartionCellId_2_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_2_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_3, 0)  <> COALESCE (inPartionCellId_3_new, 0) AND COALESCE (inPartionCellId_3_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_3_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_4, 0)  <> COALESCE (inPartionCellId_4_new, 0) AND COALESCE (inPartionCellId_4_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_4_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_5, 0)  <> COALESCE (inPartionCellId_5_new, 0) AND COALESCE (inPartionCellId_5_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_5_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_6, 0)  <> COALESCE (inPartionCellId_6_new, 0) AND COALESCE (inPartionCellId_6_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_6_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_7, 0)  <> COALESCE (inPartionCellId_7_new, 0) AND COALESCE (inPartionCellId_7_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_7_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_8, 0)  <> COALESCE (inPartionCellId_8_new, 0) AND COALESCE (inPartionCellId_8_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_8_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_9, 0)  <> COALESCE (inPartionCellId_9_new, 0) AND COALESCE (inPartionCellId_9_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_9_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     --IF COALESCE (inPartionCellId_10, 0)  <> COALESCE (inPartionCellId_10_new, 0) AND COALESCE (inPartionCellId_10_new, 0) NOT IN (0, zc_PartionCell_RK())
     IF COALESCE (inPartionCellId_10_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;

     IF COALESCE (inPartionCellId_11_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;

     IF COALESCE (inPartionCellId_12_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;

     -- ѕроверка, в одном документе может быть только 5 €чеек
     IF vbCount_begin > 24
     THEN
         RAISE EXCEPTION 'ќшибка.¬ одном документе заполнение возможно только дл€ 12 €чеек.';
     END IF;


     -- 1.1. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_1_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;

     -- 1.2. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_2_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;

     -- 1.3. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_3_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.4. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_4_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;

     -- 1.5. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_5_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.6. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_6_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;

     -- 1.7. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_7_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.8. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_8_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.9. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_9_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.10. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_10_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.11. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_11_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.12. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_12_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.13. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_13_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;

     -- 1.14. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_14_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.15. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_15_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.16. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_16_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.17. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_17_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.18. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_18_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.19. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_19_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.20. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_20_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.21. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_21_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 1.22. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_22_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell;

     END IF;


     -- 2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 2.1. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_1_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_1, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_1:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_1:= inPartionCellId_1;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_1 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_1)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_1:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_1()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );

             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_1:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_1, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_1() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_1, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-1 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_1_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE /*WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                   */
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE /*WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                   */
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE /*WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                   */
                  ) AS _tmpItem_PartionCell
            ;
             -- вернули
             outPartionCellId_1:= inPartionCellId_1_new;
             outIsClose_1:= FALSE;

     END IF;

     -- 2.2. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_2_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_2, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_2:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_2:= inPartionCellId_2;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_2 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_2)
                 FROM _tmpItem_PartionCell 
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_2:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_2()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_2:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_2, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_2() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_2, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-2 не определено.%Ќельз€ поставить в отбор.% <%>', CHR (13), CHR (13)
                             , (SELECT DISTINCT lfGet_Object_ValueData_sh (MIF.ValueData :: Integer)
                                FROM _tmpItem_PartionCell
                                     INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_2()
                               )
                               ;
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_2_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_2:= inPartionCellId_2_new;
             outIsClose_2:= FALSE;

     END IF;

     -- 2.3. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_3_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_3, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_3:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_3:= inPartionCellId_3;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_3 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_3)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_3:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_3()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_3:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_3, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_3() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_3, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-3 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_3_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_3:= inPartionCellId_3_new;
             outIsClose_3:= FALSE;

     END IF;

     -- 2.4. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_4_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_4, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_4:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_4:= inPartionCellId_4;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_4 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_4)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_4:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_4()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_4:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_4, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_4() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_4, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-4 не определено.%Ќельз€ поставить в отбор.%(%) (%)', CHR (13), CHR (13), inPartionCellId_4, lfGet_Object_ValueData_sh (inPartionCellId_4);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_4_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_4:= inPartionCellId_4_new;
             outIsClose_4:= FALSE;

     END IF;

     -- 2.5. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_5_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_5, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_5:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_5:= inPartionCellId_5;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_5 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_5)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_5:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_5()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_5_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_5:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_5, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_5() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_5, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-5 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_5_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_5_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_5:= inPartionCellId_5_new;
             outIsClose_5:= FALSE;

     END IF;


     -- 2.6. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_6_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_6, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_6:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_6:= inPartionCellId_6;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_6 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_6)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_6:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_6()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_6_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_6:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_6, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_6() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_6, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-6 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_6_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_6_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_6:= inPartionCellId_6_new;
             outIsClose_6:= FALSE;

     END IF;


     -- 2.7. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_7_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_7, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_7:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_7:= inPartionCellId_7;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_7 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_7)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_7:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_7()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_7_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_7:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_7, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_7() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_7, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-7 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_7_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_7_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_7:= inPartionCellId_7_new;
             outIsClose_7:= FALSE;

     END IF;


     -- 2.8. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_8_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_8, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_8:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_8:= inPartionCellId_8;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_8 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_8)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_8:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_8()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_8_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_8:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_8, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_8() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_8, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-8 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_8_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_8_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_8:= inPartionCellId_8_new;
             outIsClose_8:= FALSE;

     END IF;


     -- 2.9. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_9_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_9, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_9:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_9:= inPartionCellId_9;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_9 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_9)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_9:= (SELECT MIF.ValueData :: Integer
                                       FROM _tmpItem_PartionCell
                                            INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                               AND MIF.DescId = zc_MIFloat_PartionCell_real_9()
                                       ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                       LIMIT 1
                                      );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_9_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_9:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_9, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_9() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_9, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-9 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_9_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_9_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_9:= inPartionCellId_9_new;
             outIsClose_9:= FALSE;

     END IF;


     -- 2.10. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_10_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_10, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_10:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_10:= inPartionCellId_10;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_10 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_10)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_10:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_10()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_10_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_10:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_10, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_10() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_10, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-10 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_10_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_10_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_10:= inPartionCellId_10_new;
             outIsClose_10:= FALSE;

     END IF;


     -- 2.11. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_11_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_11, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_11:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_11:= inPartionCellId_11;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_11 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_11)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_11:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_11()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_11_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_11:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_11, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_11() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_11, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-11 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_11_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_11_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_11:= inPartionCellId_11_new;
             outIsClose_11:= FALSE;

     END IF;


     -- 2.12. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_12_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_12, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_12:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_12:= inPartionCellId_12;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_12 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_12)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_12:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_12()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_12_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_12:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_12, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_12() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_12, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-12 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_12_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_12_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_12:= inPartionCellId_12_new;
             outIsClose_12:= FALSE;

     END IF;

     -- 2.13. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_13_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_13, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_13:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_13:= inPartionCellId_13;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_13 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_13)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_13:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_13()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_13_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_13:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_13, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_13() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_13, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-13 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_13_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_13(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_13_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_13(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_13(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_13:= inPartionCellId_13_new;
             outIsClose_13:= FALSE;

     END IF;

     -- 2.14. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_14_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_14, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_14:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_14:= inPartionCellId_14;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_14 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_14)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_14:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_14()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_14_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_14:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_14, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_14() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_14, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-14 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_14_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_14(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_14_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_14(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_14(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_14:= inPartionCellId_14_new;
             outIsClose_14:= FALSE;

     END IF;

     -- 2.15. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_15_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_15, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_15:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_15:= inPartionCellId_15;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_15 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_15)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_15:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_15()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_15_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_15:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_15, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_15() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_15, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-15 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_15_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_15(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_15_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_15(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_15(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_15:= inPartionCellId_15_new;
             outIsClose_15:= FALSE;

     END IF;

     -- 2.16. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_16_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_16, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_16:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_16:= inPartionCellId_16;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_16 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_16)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_16:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_16()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_16_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_16:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_16, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_16() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_16, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-16 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_16_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_16(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_16_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_16(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_16(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_16:= inPartionCellId_16_new;
             outIsClose_16:= FALSE;

     END IF;

     -- 2.17. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_17_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_17, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_17:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_17:= inPartionCellId_17;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_17 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_17)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_17:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_17()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_17_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_17:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_17, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_17() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_17, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-17 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_17_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_17(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_17_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_17(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_17(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_17:= inPartionCellId_17_new;
             outIsClose_17:= FALSE;

     END IF;

     -- 2.18. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_18_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_18, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_18:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_18:= inPartionCellId_18;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_18 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_18)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_18:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_18()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_18_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_18:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_18, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_18() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_18, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-18 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_18_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_18(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_18_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_18(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_18(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_18:= inPartionCellId_18_new;
             outIsClose_18:= FALSE;

     END IF;

     -- 2.19. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_19_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_19, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_19:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_19:= inPartionCellId_19;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_19 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_19)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_19:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_19()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_19_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_19:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_19, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_19() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_19, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-19 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_19_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_19(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_19_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_19(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_19(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_19:= inPartionCellId_19_new;
             outIsClose_19:= FALSE;

     END IF;

     -- 2.20. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_20_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_20, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_20:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_20:= inPartionCellId_20;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_20 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_20)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_20:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_20()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_20_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_20:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_20, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_20() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_20, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-20 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_20_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_20(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_20_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_20(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_20(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_20:= inPartionCellId_20_new;
             outIsClose_20:= FALSE;

     END IF;

     -- 2.21. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_21_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_21, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_21:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_21:= inPartionCellId_21;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_21 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_21)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_21:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_21()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_21_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_21:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_21, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_21() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_21, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-21 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_21_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_21(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_21_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_21(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_21(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_21:= inPartionCellId_21_new;
             outIsClose_21:= FALSE;

     END IF;

     -- 2.22. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_22_new = zc_PartionCell_RK()
     THEN
             -- 1. вернем айди какой был - реальна€ €чейка
             IF COALESCE (inPartionCellId_22, 0) IN (0, zc_PartionCell_RK())
             THEN outPartionCellId_22:= NULL; --(SELECT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_22:= inPartionCellId_22;
             END IF;

             -- 2.если была реальна€ €чейка
             IF outPartionCellId_22 > 0
             THEN
                 -- сохранили оригинал
                 PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), _tmpItem_PartionCell.MovementItemId, outPartionCellId_22)
                 FROM _tmpItem_PartionCell
                ;
             ELSE
                 -- нашли предыдущую
                 outPartionCellId_22:= (SELECT MIF.ValueData :: Integer
                                        FROM _tmpItem_PartionCell
                                             INNER JOIN MovementItemFloat AS MIF ON MIF.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                                                                AND MIF.DescId = zc_MIFloat_PartionCell_real_22()
                                        ORDER BY CASE WHEN MIF.ValueData IN (zc_PartionCell_RK(), 0) THEN 1 ELSE 0 END
                                        LIMIT 1
                                       );
             END IF;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_22_new)
             FROM _tmpItem_PartionCell
            ;

             -- 4.1.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
            ;

             -- 4.2. вернули
             outIsClose_22:= TRUE;

             -- если старое значение не нашли
             IF COALESCE (outPartionCellId_22, 0) = 0 AND 1=1
                -- если Ќ≈ был zc_PartionCell_RK
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell AS tmp WHERE tmp.DescId_MILO = zc_MILinkObject_PartionCell_22() AND tmp.PartionCellId > 0)
                AND COALESCE (inPartionCellId_22, 0) = 0
             THEN
                 RAISE EXCEPTION 'ќшибка.ћесто хранение-22 не определено.%Ќельз€ поставить в отбор.', CHR (13);
             END IF;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_22_new > 0
     THEN
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_22(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_22_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_22(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_22(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.isRePack = FALSE
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_22:= inPartionCellId_22_new;
             outIsClose_22:= FALSE;

     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (tmpItem.MovementItemId, inUserId, FALSE)
     FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell
          ) AS tmpItem
    ;
    
    
    IF inUserId = 5 AND 1=1
    THEN
        RAISE EXCEPTION 'ќшибка.test = ok.';
    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».
 02.04.24                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_MI_Send_byReport_all (inUnitId:= 8459, inStartDate:= '29.02.2024', inEndDate:= '29.02.2024', inGoodsId:= 2272 ,inGoodsKindId:= 8348, inPartionGoodsDate:= '29.02.2024', inPartionCellId_1:= 0, inPartionCellId_2 := 0 , inPartionCellId_3 := 0 , inPartionCellId_4 := 0 , inPartionCellId_5 := 0 , inPartionCellId_6 := 0 , inPartionCellId_7 := 0 , inPartionCellId_8 := 0 , inPartionCellId_9 := 0 , inPartionCellId_10 := 0 , inPartionCellId_1_new := 10239266, inPartionCellId_2_new := 0 , inPartionCellId_3_new := 0 , inPartionCellId_4_new := 0 , inPartionCellId_5_new := 0 , inPartionCellId_6_new := 0 , inPartionCellId_7_new := 0 , inPartionCellId_8_new := 0 , inPartionCellId_9_new := 0 , inPartionCellId_10_new := 0 , inUserId:= zfCalc_UserAdmin() :: Integer);
