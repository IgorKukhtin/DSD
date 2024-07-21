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

    IN inUserId                Integer
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbCount_begin Integer;
   DECLARE vbCount_start Integer;
   DECLARE vbLimit_1     Integer;
   DECLARE vbLimit_2     Integer;
BEGIN
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
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementId Integer, MovementItemId Integer, Amount TFloat, DescId_MILO Integer, PartionCellId Integer) ON COMMIT DROP;

     END IF;


     INSERT INTO _tmpItem_PartionCell (MovementId, MovementItemId, Amount, DescId_MILO, PartionCellId)
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

                                       INNER JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                          AND Movement.DescId   = zc_Movement_Send()
                                                          AND Movement.StatusId = zc_Enum_Status_Complete()
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
                                                                                                              )
                                                                       -- !!!
                                                                       -- AND 1=0

                                  -- ограничили ѕарти€ дата, если установлена дл€ MI
                                  WHERE MIDate_PartionGoods.ValueData = inPartionGoodsDate
                                    AND MIDate_PartionGoods.DescId    = zc_MIDate_PartionGoods()
                                    -- ограничили видом
                                    AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                                 )

            -- или документы за период, дата документа = дата партии
          , tmpMovement AS (SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                            WHERE Movement.OperDate = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )

          , tmpMI AS (SELECT MovementItem.MovementId        AS MovementId
                           , MovementItem.Id                AS MovementItemId
                           , MovementItem.Amount            AS Amount
                             -- текущее значение
                           , COALESCE (MILO_PartionCell.DescId, 0)    AS DescId_MILO
                           , COALESCE (MILO_PartionCell.ObjectId, 0)  AS PartionCellId

                      FROM MovementItem
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

                      FROM tmpMI_PartionDate
                     )
       -- –езультат
       SELECT MovementId, MovementItemId, Amount
              -- текущее значение
            , DescId_MILO
            , PartionCellId

       FROM tmpMI
      ;

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
     IF vbCount_begin > 12
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
             outIsClose_1:= outPartionCellId_1 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_1_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_1, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-1.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_1 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_1, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_2:= outPartionCellId_2 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_2_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_2, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-2.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_2 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_2, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_2 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_2, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_2 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_2, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_3:= outPartionCellId_3 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_3_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_3, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-3.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_3 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_3, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_3 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_3, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_3 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_3, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_4:= outPartionCellId_4 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_4_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_4, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-4.';
             END IF;


             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_4 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_4, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_4 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_4, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_4 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_4, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_5:= outPartionCellId_5 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_5_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_5, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-5.';
             END IF;


             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_5_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_5 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_5, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_5 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_5, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_5 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_5, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_6:= outPartionCellId_6 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_6_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_6, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-6.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_6(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_6_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_6 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_6, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_6(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_6 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_6, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_6(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_6 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_6, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_7:= outPartionCellId_7 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_7_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_7, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-7.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_7(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_7_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_7 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_7, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_7(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_7 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_7, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_7(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_7 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_7, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_8:= outPartionCellId_8 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_8_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_8, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-8.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_8(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_8_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_8 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_8, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_8(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_8 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_8, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_8(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_8 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_8, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_9:= outPartionCellId_9 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_9_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_9, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-9.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_9(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_9_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_9 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_9, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_9(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_9 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_9, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_9(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_9 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_9, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_10:= outPartionCellId_10 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_10_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_10, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-10.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_10(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_10_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_10 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_10, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_10(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_10 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_10, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_10(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_10 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_10, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_11:= outPartionCellId_11 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_11_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_11, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-11.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_11(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_11_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_11 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_11, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_11(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_11 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_11, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_11(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_11 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_11, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
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
             outIsClose_12:= outPartionCellId_12 > 0;

     -- реальна€ €чейка
     ELSEIF inPartionCellId_12_new > 0
     THEN
             -- проверка
             IF COALESCE (inPartionCellId_12, 0) = 0
                AND NOT EXISTS (SELECT 1 FROM _tmpItem_PartionCell WHERE _tmpItem_PartionCell.PartionCellId = 0)
             THEN
                 RAISE EXCEPTION 'ќшибка-11.Ќе найдена строка дл€ прив€зки ячейки-12.';
             END IF;

             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_12(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_12_new)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_12 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_12, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_12(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_12 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_12, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_12(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM (-- все
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE inPartionCellId_12 > 0
                  UNION 
                   -- только пустые
                   SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell WHERE COALESCE (inPartionCellId_12, 0) = 0 AND _tmpItem_PartionCell.PartionCellId = 0
                  ) AS _tmpItem_PartionCell
            ;

             -- вернули
             outPartionCellId_12:= inPartionCellId_12_new;
             outIsClose_12:= FALSE;

     END IF;


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (tmpItem.MovementItemId, inUserId, FALSE)
     FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell
          ) AS tmpItem
    ;

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
