-- Function: lpUpdate_MI_Send_byReport_all()

DROP FUNCTION IF EXISTS lpUpdate_MI_Send_byReport_all (Integer, TDateTime, TDateTime, Integer, Integer, TDateTime
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
                                                     , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
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
    IN inUserId                Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbCount_begin Integer;
   DECLARE vbCount_start Integer;
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
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementId Integer, MovementItemId Integer, Amount TFloat
                                               , DescId_MILO Integer, DescId_MIF_real Integer, DescId_Boolean Integer
                                               , PartionCellId Integer, PartionCellId_real Integer) ON COMMIT DROP;

     END IF;


     INSERT INTO _tmpItem_PartionCell (MovementId, MovementItemId, Amount, DescId_MILO, DescId_MIF_real, DescId_Boolean, PartionCellId, PartionCellId_real)
       WITH tmpMovement AS (SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                           )

          , tmpMI AS (SELECT MovementItem.MovementId        AS MovementId
                           , MovementItem.Id                AS MovementItemId
                           , MovementItem.Amount            AS Amount
                           , MILO_PartionCell.DescId         AS DescId_MILO
                         --, MILO_PartionCell.ObjectId       AS PartionCellId
                             -- –асчет нужной €чейки по которой группировать
                           , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData :: Integer ELSE MILO_PartionCell.ObjectId END AS PartionCellId
                           , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer  AS PartionCellId_real
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                            ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                           AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                           AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                 , zc_MILinkObject_PartionCell_2()
                                                                                                 , zc_MILinkObject_PartionCell_3()
                                                                                                 , zc_MILinkObject_PartionCell_4()
                                                                                                 , zc_MILinkObject_PartionCell_5()
                                                                                                  )
                           LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                       ON MIF_PartionCell_real.MovementItemId = MovementItem.Id
                                                      AND MIF_PartionCell_real.DescId         = CASE WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                          THEN zc_MIFloat_PartionCell_real_1()
                                                                                                     WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                          THEN zc_MIFloat_PartionCell_real_2()
                                                                                                     WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                          THEN zc_MIFloat_PartionCell_real_3()
                                                                                                     WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                          THEN zc_MIFloat_PartionCell_real_4()
                                                                                                     WHEN MILO_PartionCell.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                          THEN zc_MIFloat_PartionCell_real_5()
                                                                                                END
                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItem.DescId   = zc_MI_Master()
                        AND MovementItem.isErased = FALSE
                        -- ограничили товаром
                        AND MovementItem.ObjectId = inGoodsId
                        -- ограничили видом
                        AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                     )
       -- –езультат
       SELECT MovementId, MovementItemId, Amount
            , DescId_MILO
            , CASE WHEN DescId_MILO = zc_MILinkObject_PartionCell_1() THEN zc_MIFloat_PartionCell_real_1()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_2() THEN zc_MIFloat_PartionCell_real_2()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_3() THEN zc_MIFloat_PartionCell_real_3()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_4() THEN zc_MIFloat_PartionCell_real_4()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_5() THEN zc_MIFloat_PartionCell_real_5()
              END AS DescId_MIF_real
            , CASE WHEN DescId_MILO = zc_MILinkObject_PartionCell_1() THEN zc_MIBoolean_PartionCell_Close_1()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_2() THEN zc_MIBoolean_PartionCell_Close_2()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_3() THEN zc_MIBoolean_PartionCell_Close_3()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_4() THEN zc_MIBoolean_PartionCell_Close_4()
                   WHEN DescId_MILO = zc_MILinkObject_PartionCell_5() THEN zc_MIBoolean_PartionCell_Close_5()
              END AS DescId_Boolean
            , PartionCellId, PartionCellId_real
       FROM tmpMI
      ;

     -- сколько €чеек надо заполнить
     vbCount_begin:= 0;
     --
     IF COALESCE (inPartionCellId_1, 0)  <> COALESCE (inPartionCellId_1_new, 0) AND COALESCE (inPartionCellId_1_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_2, 0)  <> COALESCE (inPartionCellId_2_new, 0) AND COALESCE (inPartionCellId_2_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_3, 0)  <> COALESCE (inPartionCellId_3_new, 0) AND COALESCE (inPartionCellId_3_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_4, 0)  <> COALESCE (inPartionCellId_4_new, 0) AND COALESCE (inPartionCellId_4_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_5, 0)  <> COALESCE (inPartionCellId_5_new, 0) AND COALESCE (inPartionCellId_5_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_6, 0)  <> COALESCE (inPartionCellId_6_new, 0) AND COALESCE (inPartionCellId_6_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_7, 0)  <> COALESCE (inPartionCellId_7_new, 0) AND COALESCE (inPartionCellId_7_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_8, 0)  <> COALESCE (inPartionCellId_8_new, 0) AND COALESCE (inPartionCellId_8_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_9, 0)  <> COALESCE (inPartionCellId_9_new, 0) AND COALESCE (inPartionCellId_9_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;
     --
     IF COALESCE (inPartionCellId_10, 0)  <> COALESCE (inPartionCellId_10_new, 0) AND COALESCE (inPartionCellId_10_new, 0) NOT IN (0, zc_PartionCell_RK())
     THEN vbCount_begin:= vbCount_begin + 1; END IF;


     -- ѕроверка, в одном документе может быть только 5 €чеек
     IF vbCount_begin > 5 AND (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementId FROM _tmpItem_PartionCell) AS tmpItem_PartionCell) <= 1
     THEN
         RAISE EXCEPTION 'ќшибка.¬ одном документе заполнение возможно только дл€ 5 €чеек.';
     END IF;



     -- 1.1. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_1, 0)  <> COALESCE (inPartionCellId_1_new, 0) AND COALESCE (inPartionCellId_1_new, 0) = 0
     THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (DescId_Boolean, _tmpItem_PartionCell.MovementItemId, FALSE);

             -- 1.2.обнулили €чейку - DescId_MILO
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_1;


             -- 1.3.обнулили €чейку - DescId_MIF_real
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_1;

     END IF;

     -- 1.2. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_2, 0)  <> COALESCE (inPartionCellId_2_new, 0) AND COALESCE (inPartionCellId_2_new, 0) = 0
     THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (DescId_Boolean, _tmpItem_PartionCell.MovementItemId, FALSE);

             -- 1.2.обнулили €чейку - DescId_MILO
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_2;


             -- 1.3.обнулили €чейку - DescId_MIF_real
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_2;

     END IF;

     -- 1.3. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_3, 0)  <> COALESCE (inPartionCellId_3_new, 0) AND COALESCE (inPartionCellId_3_new, 0) = 0
     THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (DescId_Boolean, _tmpItem_PartionCell.MovementItemId, FALSE);

             -- 1.2.обнулили €чейку - DescId_MILO
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_3;


             -- 1.3.обнулили €чейку - DescId_MIF_real
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_3;

     END IF;


     -- 1.4. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_4, 0)  <> COALESCE (inPartionCellId_4_new, 0) AND COALESCE (inPartionCellId_4_new, 0) = 0
     THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (DescId_Boolean, _tmpItem_PartionCell.MovementItemId, FALSE);

             -- 1.2.обнулили €чейку - DescId_MILO
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_4;


             -- 1.3.обнулили €чейку - DescId_MIF_real
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_4;

     END IF;

     -- 1.5. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_5, 0)  <> COALESCE (inPartionCellId_5_new, 0) AND COALESCE (inPartionCellId_5_new, 0) = 0
     THEN
             -- 1.1.открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (DescId_Boolean, _tmpItem_PartionCell.MovementItemId, FALSE);

             -- 1.2.обнулили €чейку - DescId_MILO
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_5;


             -- 1.3.обнулили €чейку - DescId_MIF_real
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_5;

     END IF;


     -- 2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     -- 2.1. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_1_new = zc_PartionCell_RK()
     THEN
             -- 2.2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_1
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_1
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_1
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;

     -- 2.2. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_2_new = zc_PartionCell_RK()
     THEN
             -- 2.2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_2
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_2
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_2
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;


     -- 2.3. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_3_new = zc_PartionCell_RK()
     THEN
             -- 2.2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_3
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_3
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_3
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;


     -- 2.2. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_4_new = zc_PartionCell_RK()
     THEN
             -- 2.2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_4
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_4
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 2.4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_4
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;



     -- 3 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

     vbCount_start:= 0;

     IF vbCount_begin <= 5
     THEN
           -- 3.1.следующа€
           IF inPartionCellId_1_new > 0 THEN vbCount_start:= vbCount_start + 1; END IF;

           -- 3.1. если выполн€етс€ назначить €чейку
           IF inPartionCellId_1_new > 0 AND inPartionCellId_1_new <> zc_PartionCell_RK()
           THEN
                   -- 3.1.прив€зали €чейку
                   PERFORM lpInsertUpdate_MovementItemLinkObject (CASE WHEN vbCount_start = 1 THEN zc_MILinkObject_PartionCell_1()
                                                                       WHEN vbCount_start = 2 THEN zc_MILinkObject_PartionCell_2()
                                                                       WHEN vbCount_start = 3 THEN zc_MILinkObject_PartionCell_3()
                                                                       WHEN vbCount_start = 4 THEN zc_MILinkObject_PartionCell_4()
                                                                       WHEN vbCount_start = 5 THEN zc_MILinkObject_PartionCell_5()
                                                                  END
                                                               , _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_1, 0)
                  ;

                   -- 3.2.обнулили оригинал
                   PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN vbCount_start = 1 THEN zc_MIFloat_PartionCell_real_1()
                                                                  WHEN vbCount_start = 2 THEN zc_MIFloat_PartionCell_real_2()
                                                                  WHEN vbCount_start = 3 THEN zc_MIFloat_PartionCell_real_3()
                                                                  WHEN vbCount_start = 4 THEN zc_MIFloat_PartionCell_real_4()
                                                                  WHEN vbCount_start = 5 THEN zc_MIFloat_PartionCell_real_5()
                                                              END
                                                           , _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_1, 0)
                  ;

                   -- 3.3.открыли
                   PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN vbCount_start = 1 THEN zc_MIBoolean_PartionCell_Close_1()
                                                                    WHEN vbCount_start = 2 THEN zc_MIBoolean_PartionCell_Close_2()
                                                                    WHEN vbCount_start = 3 THEN zc_MIBoolean_PartionCell_Close_3()
                                                                    WHEN vbCount_start = 4 THEN zc_MIBoolean_PartionCell_Close_4()
                                                                    WHEN vbCount_start = 5 THEN zc_MIBoolean_PartionCell_Close_5()
                                                               END
                                                             , _tmpItem_PartionCell.MovementItemId, FALSE)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_1, 0)
                  ;

           END IF;


           -- 3.2.следующа€
           IF inPartionCellId_2_new > 0 THEN vbCount_start:= vbCount_start + 1; END IF;

           -- 3.2. если выполн€етс€ назначить €чейку
           IF inPartionCellId_2_new > 0 AND inPartionCellId_2_new <> zc_PartionCell_RK()
           THEN
                   -- 3.1.прив€зали €чейку
                   PERFORM lpInsertUpdate_MovementItemLinkObject (CASE WHEN vbCount_start = 1 THEN zc_MILinkObject_PartionCell_1()
                                                                       WHEN vbCount_start = 2 THEN zc_MILinkObject_PartionCell_2()
                                                                       WHEN vbCount_start = 3 THEN zc_MILinkObject_PartionCell_3()
                                                                       WHEN vbCount_start = 4 THEN zc_MILinkObject_PartionCell_4()
                                                                       WHEN vbCount_start = 5 THEN zc_MILinkObject_PartionCell_5()
                                                                  END
                                                               , _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_2, 0)
                  ;

                   -- 3.2.обнулили оригинал
                   PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN vbCount_start = 1 THEN zc_MIFloat_PartionCell_real_1()
                                                                  WHEN vbCount_start = 2 THEN zc_MIFloat_PartionCell_real_2()
                                                                  WHEN vbCount_start = 3 THEN zc_MIFloat_PartionCell_real_3()
                                                                  WHEN vbCount_start = 4 THEN zc_MIFloat_PartionCell_real_4()
                                                                  WHEN vbCount_start = 5 THEN zc_MIFloat_PartionCell_real_5()
                                                              END
                                                           , _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_2, 0)
                  ;

                   -- 3.3.открыли
                   PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN vbCount_start = 1 THEN zc_MIBoolean_PartionCell_Close_1()
                                                                    WHEN vbCount_start = 2 THEN zc_MIBoolean_PartionCell_Close_2()
                                                                    WHEN vbCount_start = 3 THEN zc_MIBoolean_PartionCell_Close_3()
                                                                    WHEN vbCount_start = 4 THEN zc_MIBoolean_PartionCell_Close_4()
                                                                    WHEN vbCount_start = 5 THEN zc_MIBoolean_PartionCell_Close_5()
                                                               END
                                                             , _tmpItem_PartionCell.MovementItemId, FALSE)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_2, 0)
                  ;

           END IF;


           -- 3.3.следующа€
           IF inPartionCellId_2_new > 0 THEN vbCount_start:= vbCount_start + 1; END IF;

           -- 3.3. если выполн€етс€ назначить €чейку
           IF inPartionCellId_3_new > 0 AND inPartionCellId_3_new <> zc_PartionCell_RK()
           THEN
                   -- 3.1.прив€зали €чейку
                   PERFORM lpInsertUpdate_MovementItemLinkObject (CASE WHEN vbCount_start = 1 THEN zc_MILinkObject_PartionCell_1()
                                                                       WHEN vbCount_start = 2 THEN zc_MILinkObject_PartionCell_2()
                                                                       WHEN vbCount_start = 3 THEN zc_MILinkObject_PartionCell_3()
                                                                       WHEN vbCount_start = 4 THEN zc_MILinkObject_PartionCell_4()
                                                                       WHEN vbCount_start = 5 THEN zc_MILinkObject_PartionCell_5()
                                                                  END
                                                               , _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_3, 0)
                  ;

                   -- 3.2.обнулили оригинал
                   PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN vbCount_start = 1 THEN zc_MIFloat_PartionCell_real_1()
                                                                  WHEN vbCount_start = 2 THEN zc_MIFloat_PartionCell_real_2()
                                                                  WHEN vbCount_start = 3 THEN zc_MIFloat_PartionCell_real_3()
                                                                  WHEN vbCount_start = 4 THEN zc_MIFloat_PartionCell_real_4()
                                                                  WHEN vbCount_start = 5 THEN zc_MIFloat_PartionCell_real_5()
                                                              END
                                                           , _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_3, 0)
                  ;

                   -- 3.3.открыли
                   PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN vbCount_start = 1 THEN zc_MIBoolean_PartionCell_Close_1()
                                                                    WHEN vbCount_start = 2 THEN zc_MIBoolean_PartionCell_Close_2()
                                                                    WHEN vbCount_start = 3 THEN zc_MIBoolean_PartionCell_Close_3()
                                                                    WHEN vbCount_start = 4 THEN zc_MIBoolean_PartionCell_Close_4()
                                                                    WHEN vbCount_start = 5 THEN zc_MIBoolean_PartionCell_Close_5()
                                                               END
                                                             , _tmpItem_PartionCell.MovementItemId, FALSE)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_3, 0)
                  ;

           END IF;


           -- 3.4.следующа€
           IF inPartionCellId_4_new > 0 THEN vbCount_start:= vbCount_start + 1; END IF;

           -- 3.4. если выполн€етс€ назначить €чейку
           IF inPartionCellId_4_new > 0 AND inPartionCellId_4_new <> zc_PartionCell_RK()
           THEN
                   -- 3.1.прив€зали €чейку
                   PERFORM lpInsertUpdate_MovementItemLinkObject (CASE WHEN vbCount_start = 1 THEN zc_MILinkObject_PartionCell_1()
                                                                       WHEN vbCount_start = 2 THEN zc_MILinkObject_PartionCell_2()
                                                                       WHEN vbCount_start = 3 THEN zc_MILinkObject_PartionCell_3()
                                                                       WHEN vbCount_start = 4 THEN zc_MILinkObject_PartionCell_4()
                                                                       WHEN vbCount_start = 5 THEN zc_MILinkObject_PartionCell_5()
                                                                  END
                                                               , _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_4, 0)
                  ;

                   -- 3.2.обнулили оригинал
                   PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN vbCount_start = 1 THEN zc_MIFloat_PartionCell_real_1()
                                                                  WHEN vbCount_start = 2 THEN zc_MIFloat_PartionCell_real_2()
                                                                  WHEN vbCount_start = 3 THEN zc_MIFloat_PartionCell_real_3()
                                                                  WHEN vbCount_start = 4 THEN zc_MIFloat_PartionCell_real_4()
                                                                  WHEN vbCount_start = 5 THEN zc_MIFloat_PartionCell_real_5()
                                                              END
                                                           , _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_4, 0)
                  ;

                   -- 3.3.открыли
                   PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN vbCount_start = 1 THEN zc_MIBoolean_PartionCell_Close_1()
                                                                    WHEN vbCount_start = 2 THEN zc_MIBoolean_PartionCell_Close_2()
                                                                    WHEN vbCount_start = 3 THEN zc_MIBoolean_PartionCell_Close_3()
                                                                    WHEN vbCount_start = 4 THEN zc_MIBoolean_PartionCell_Close_4()
                                                                    WHEN vbCount_start = 5 THEN zc_MIBoolean_PartionCell_Close_5()
                                                               END
                                                             , _tmpItem_PartionCell.MovementItemId, FALSE)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_4, 0)
                  ;

           END IF;

           -- 3.5.следующа€
           IF inPartionCellId_5_new > 0 THEN vbCount_start:= vbCount_start + 1; END IF;

           -- 3.5. если выполн€етс€ назначить €чейку
           IF inPartionCellId_5_new > 0 AND inPartionCellId_5_new <> zc_PartionCell_RK()
           THEN
                   -- 3.1.прив€зали €чейку
                   PERFORM lpInsertUpdate_MovementItemLinkObject (CASE WHEN vbCount_start = 1 THEN zc_MILinkObject_PartionCell_1()
                                                                       WHEN vbCount_start = 2 THEN zc_MILinkObject_PartionCell_2()
                                                                       WHEN vbCount_start = 3 THEN zc_MILinkObject_PartionCell_3()
                                                                       WHEN vbCount_start = 4 THEN zc_MILinkObject_PartionCell_4()
                                                                       WHEN vbCount_start = 5 THEN zc_MILinkObject_PartionCell_5()
                                                                  END
                                                               , _tmpItem_PartionCell.MovementItemId, inPartionCellId_5_new)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_5, 0)
                  ;

                   -- 3.2.обнулили оригинал
                   PERFORM lpInsertUpdate_MovementItemFloat (CASE WHEN vbCount_start = 1 THEN zc_MIFloat_PartionCell_real_1()
                                                                  WHEN vbCount_start = 2 THEN zc_MIFloat_PartionCell_real_2()
                                                                  WHEN vbCount_start = 3 THEN zc_MIFloat_PartionCell_real_3()
                                                                  WHEN vbCount_start = 4 THEN zc_MIFloat_PartionCell_real_4()
                                                                  WHEN vbCount_start = 5 THEN zc_MIFloat_PartionCell_real_5()
                                                              END
                                                           , _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_5, 0)
                  ;

                   -- 3.3.открыли
                   PERFORM lpInsertUpdate_MovementItemBoolean (CASE WHEN vbCount_start = 1 THEN zc_MIBoolean_PartionCell_Close_1()
                                                                    WHEN vbCount_start = 2 THEN zc_MIBoolean_PartionCell_Close_2()
                                                                    WHEN vbCount_start = 3 THEN zc_MIBoolean_PartionCell_Close_3()
                                                                    WHEN vbCount_start = 4 THEN zc_MIBoolean_PartionCell_Close_4()
                                                                    WHEN vbCount_start = 5 THEN zc_MIBoolean_PartionCell_Close_5()
                                                               END
                                                             , _tmpItem_PartionCell.MovementItemId, FALSE)
                   FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId FROM _tmpItem_PartionCell) AS _tmpItem_PartionCell
                   --WHERE COALESCE (_tmpItem_PartionCell.PartionCellId, 0) = COALESCE (inPartionCellId_5, 0)
                  ;

           END IF;

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
