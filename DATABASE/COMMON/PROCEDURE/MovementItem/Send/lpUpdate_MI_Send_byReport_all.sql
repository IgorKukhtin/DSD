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
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementId Integer, MovementItemId Integer, Amount TFloat
                                               , DescId_MILO Integer, DescId_MIF_real Integer, DescId_Boolean Integer
                                               , PartionCellId Integer, PartionCellId_real Integer, PartionCellId_old Integer) ON COMMIT DROP;

     END IF;


     INSERT INTO _tmpItem_PartionCell (MovementId, MovementItemId, Amount, DescId_MILO, DescId_MIF_real, DescId_Boolean, PartionCellId, PartionCellId_real, PartionCellId_old)
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
                           , MILO_PartionCell.DescId        AS DescId_MILO

                             -- текущее значение
                           , MILO_PartionCell.ObjectId      AS PartionCellId_old
                             -- –асчет нужной €чейки по которой группировать
                           , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData :: Integer ELSE MILO_PartionCell.ObjectId END AS PartionCellId
                             -- если была реальна€ €чейка
                           , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer AS PartionCellId_real
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
              -- –асчет нужной €чейки по которой группировать
            , PartionCellId
              -- если была реальна€ €чейка
            , PartionCellId_real
              -- текущее значение
            , PartionCellId_old

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


     -- ѕроверка, в одном документе может быть только 5 €чеек
     IF vbCount_begin > 5 AND (SELECT COUNT(*) FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementId FROM _tmpItem_PartionCell) AS tmpItem_PartionCell) <= 1
     THEN
         RAISE EXCEPTION 'ќшибка.¬ одном документе заполнение возможно только дл€ 5 €чеек.';
     END IF;


     -- 1.1. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_1_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell;

     END IF;

     -- 1.2. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_2_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell;

     END IF;

     -- 1.3. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_3_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell;

     END IF;


     -- 1.4. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_4_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell;

     END IF;

     -- 1.5. если выполн€етс€ "обнулили €чейку"
     IF COALESCE (inPartionCellId_5_new, 0) = 0
     THEN
             -- открыли
             -- PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             -- FROM _tmpItem_PartionCell;

             -- 1.2.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, NULL)
             FROM _tmpItem_PartionCell;


             -- 1.3.обнулили €чейку
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell;

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
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_1(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_1_new)
             FROM _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_1(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_1(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM _tmpItem_PartionCell
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
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_2(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_2_new)
             FROM _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_2(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_2(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM _tmpItem_PartionCell
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
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_3(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_3_new)
             FROM _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_3(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_3(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM _tmpItem_PartionCell
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
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_4(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_4_new)
             FROM _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_4(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_4(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM _tmpItem_PartionCell
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
             -- прив€зали €чейку
             PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionCell_5(), _tmpItem_PartionCell.MovementItemId, inPartionCellId_5_new)
             FROM _tmpItem_PartionCell
            ;
             -- обнулили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PartionCell_real_5(), _tmpItem_PartionCell.MovementItemId, 0 :: TFloat)
             FROM _tmpItem_PartionCell
            ;
             -- открыли
             PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PartionCell_Close_5(), _tmpItem_PartionCell.MovementItemId, FALSE)
             FROM _tmpItem_PartionCell
            ;
            
             -- вернули
             outPartionCellId_5:= inPartionCellId_5_new;
             outIsClose_5:= FALSE;

     END IF;

     -- 2.6. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_6_new = zc_PartionCell_RK()
     THEN
             RAISE EXCEPTION 'ќшибка.ячейка є 6 только дл€ просмотра.';

             -- 1. закрыли
             outIsClose_6:= TRUE;
             -- 1.вернем айди какой был
             IF COALESCE (inPartionCellId_6 IN (0, zc_PartionCell_RK()))
             THEN outPartionCellId_6:= (SELECT DISTINCT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_6:= inPartionCellId_6;
             END IF;

             -- 2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_6
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_6_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_6
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_6
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;


     -- 2.7. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_7_new = zc_PartionCell_RK()
     THEN
             RAISE EXCEPTION 'ќшибка.ячейка є 7 только дл€ просмотра.';

             -- 1. закрыли
             outIsClose_7:= TRUE;
             -- 1.вернем айди какой был
             IF COALESCE (inPartionCellId_7 IN (0, zc_PartionCell_RK()))
             THEN outPartionCellId_7:= (SELECT DISTINCT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_7:= inPartionCellId_7;
             END IF;

             -- 2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_7
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_7_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_7
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_7
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;


     -- 2.8. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_8_new = zc_PartionCell_RK()
     THEN
             RAISE EXCEPTION 'ќшибка.ячейка є 8 только дл€ просмотра.';

             -- 1. закрыли
             outIsClose_8:= TRUE;
             -- 1.вернем айди какой был
             IF COALESCE (inPartionCellId_8 IN (0, zc_PartionCell_RK()))
             THEN outPartionCellId_8:= (SELECT DISTINCT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_8:= inPartionCellId_8;
             END IF;

             -- 2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_8
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_8_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_8
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_8
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;


     -- 2.9. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_9_new = zc_PartionCell_RK()
     THEN
             RAISE EXCEPTION 'ќшибка.ячейка є 9 только дл€ просмотра.';

             -- 1. закрыли
             outIsClose_9:= TRUE;
             -- 1.вернем айди какой был
             IF COALESCE (inPartionCellId_9 IN (0, zc_PartionCell_RK()))
             THEN outPartionCellId_9:= (SELECT DISTINCT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_9:= inPartionCellId_9;
             END IF;

             -- 2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_9
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_9_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_9
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_9
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

     END IF;

     -- 2.10. если выполн€етс€ поставить €чейку ¬ ќ“Ѕќ– - zc_PartionCell_RK
     IF inPartionCellId_10_new = zc_PartionCell_RK()
     THEN
             RAISE EXCEPTION 'ќшибка.ячейка є 10 только дл€ просмотра.';

             -- 1. закрыли
             outIsClose_10:= TRUE;
             -- 1.вернем айди какой был
             IF COALESCE (inPartionCellId_10 IN (0, zc_PartionCell_RK()))
             THEN outPartionCellId_10:= (SELECT DISTINCT PartionCellId FROM _tmpItem_PartionCell);
             ELSE outPartionCellId_10:= inPartionCellId_10;
             END IF;

             -- 2.если была реальна€ €чейка - сохранили оригинал
             PERFORM lpInsertUpdate_MovementItemFloat (_tmpItem_PartionCell.DescId_MIF_real, _tmpItem_PartionCell.MovementItemId, _tmpItem_PartionCell.PartionCellId :: TFloat)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_10
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 3.прив€зали €чейку - виртуальную
             PERFORM lpInsertUpdate_MovementItemLinkObject (_tmpItem_PartionCell.DescId_MILO, _tmpItem_PartionCell.MovementItemId, inPartionCellId_10_new)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_10
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

             -- 4.закрыли
             PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId_Boolean, _tmpItem_PartionCell.MovementItemId, TRUE)
             FROM _tmpItem_PartionCell
             WHERE _tmpItem_PartionCell.PartionCellId = inPartionCellId_10
               AND _tmpItem_PartionCell.PartionCellId <> zc_PartionCell_RK()
            ;

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
