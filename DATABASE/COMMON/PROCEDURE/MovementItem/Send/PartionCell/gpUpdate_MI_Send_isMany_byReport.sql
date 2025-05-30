-- Function: gpUpdate_MI_Send_isMany_byReport()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMany_byReport (Integer, Integer,Integer,Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMany_byReport (Integer, Integer,Integer,Integer, Integer,Integer,Integer,TDateTime,Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_isMany_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inMovementItemId        Integer   , -- Ключ объекта <Элемент документа>
    IN inPartionCellNum        Integer   , -- номер ячейки по которой несколько партий
    IN inPartionCellId         Integer   , -- Ячейка для которой вносится значение несколько партий
    IN inUnitId                Integer  , --
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime, --
    IN inisMany                Boolean   , -- Дата партии
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
           vbDescId   Integer;
           vbIsWeighing Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send()); -- zc_Enum_Process_Update_MI_Send_isMany_byReport
     --vbUserId:= lpGetUserBySession (inSession);

    /* IF COALESCE (inMovementItemId,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.%Изменение параметра <Несколько партий> возможно в режиме <По документам>.', CHR (13);
     END IF;
     */
     

     
     IF COALESCE (inMovementItemId,0) <> 0
     THEN

         IF COALESCE (inPartionCellNum,0) = 0
         THEN
             RAISE EXCEPTION 'Ошибка.%Номер ячейки не определен.', CHR (13);
         END IF;

         vbDescId := CASE WHEN inPartionCellNum = 1 THEN zc_MIBoolean_PartionCell_Many_1()
                          WHEN inPartionCellNum = 2 THEN zc_MIBoolean_PartionCell_Many_2()
                          WHEN inPartionCellNum = 3 THEN zc_MIBoolean_PartionCell_Many_3()
                          WHEN inPartionCellNum = 4 THEN zc_MIBoolean_PartionCell_Many_4()
                          WHEN inPartionCellNum = 5 THEN zc_MIBoolean_PartionCell_Many_5()
                          WHEN inPartionCellNum = 6 THEN zc_MIBoolean_PartionCell_Many_6()
                          WHEN inPartionCellNum = 7 THEN zc_MIBoolean_PartionCell_Many_7()
                          WHEN inPartionCellNum = 8 THEN zc_MIBoolean_PartionCell_Many_8()
                          WHEN inPartionCellNum = 9 THEN zc_MIBoolean_PartionCell_Many_9()
                          WHEN inPartionCellNum = 10 THEN zc_MIBoolean_PartionCell_Many_10()
                          WHEN inPartionCellNum = 11 THEN zc_MIBoolean_PartionCell_Many_11()
                          WHEN inPartionCellNum = 12 THEN zc_MIBoolean_PartionCell_Many_12()
                          WHEN inPartionCellNum = 13 THEN zc_MIBoolean_PartionCell_Many_13()
                          WHEN inPartionCellNum = 14 THEN zc_MIBoolean_PartionCell_Many_14()
                          WHEN inPartionCellNum = 15 THEN zc_MIBoolean_PartionCell_Many_15()
                          WHEN inPartionCellNum = 16 THEN zc_MIBoolean_PartionCell_Many_16()
                          WHEN inPartionCellNum = 17 THEN zc_MIBoolean_PartionCell_Many_17()
                          WHEN inPartionCellNum = 18 THEN zc_MIBoolean_PartionCell_Many_18()
                          WHEN inPartionCellNum = 19 THEN zc_MIBoolean_PartionCell_Many_19()
                          WHEN inPartionCellNum = 20 THEN zc_MIBoolean_PartionCell_Many_20()
                          WHEN inPartionCellNum = 21 THEN zc_MIBoolean_PartionCell_Many_21()
                          WHEN inPartionCellNum = 22 THEN zc_MIBoolean_PartionCell_Many_22()
                     END ::Integer;

         -- сохранили
         PERFORM lpInsertUpdate_MovementItemBoolean (vbDescId, inMovementItemId, inisMany);

         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inMovementItemId, vbUserId, FALSE);
     ELSE --для всех строк где есть этот товар и партия
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
            WITH -- для Партия дата
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

                                       -- ограничили Партия дата, если установлена для MI
                                       WHERE MIDate_PartionGoods.ValueData = inPartionGoodsDate
                                         AND MIDate_PartionGoods.DescId    = zc_MIDate_PartionGoods()
                                         -- ограничили видом
                                         AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                                         -- Перемещение + Взвешивание
                                         AND ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId = zc_Enum_Status_Complete())
                                           OR (Movement.DescId = zc_Movement_WeighingProduction() AND Movement.StatusId = zc_Enum_Status_UnComplete() AND vbIsWeighing = TRUE)
                                             )
                                         --ячейка
                                         AND COALESCE (MILO_PartionCell.ObjectId, 0) = inPartionCellId
                                      )

                 -- или документы за период, дата документа = дата партии
               , tmpMovement AS (-- Перемещение
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
                                 -- Взвешивание
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
                                                             AND MovementFloat_MovementDescNumber.ValueData  = 25 -- Перепак
                                                             -- !!!
                                                             AND MovementFloat_BranchCode.ValueData          = 1
                                WHERE Movement.OperDate  = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                                   AND Movement.DescId   = zc_Movement_WeighingProduction()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                   AND vbIsWeighing = TRUE
                                   -- без Перепак
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
                                -- выбрали только с пустой Партия дата
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
                             -- пустая Партия дата
                             AND MIDate_PartionGoods.ValueData IS NULL
                             -- нет в этом списке
                             AND tmpMI_PartionDate.MovementItemId IS NULL
                             --
                             AND COALESCE (MILO_PartionCell.ObjectId, 0) = inPartionCellId
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
                           WHERE tmpMI_PartionDate.PartionCellId = inPartionCellId
                          )

            -- Результат
            SELECT MovementId, MovementItemId, Amount
                   -- текущее значение
                 , DescId_MILO
                 , PartionCellId
                   --
                 , isRePack
            FROM tmpMI
            WHERE tmpMI.PartionCellId = inPartionCellId
             AND isRePack = FALSE
           ;

     --  lpInsertUpdate_MovementItemBoolean (vbDescId, inMovementItemId, inisMany)
     --сохранили свойство
     PERFORM lpInsertUpdate_MovementItemBoolean (_tmpItem_PartionCell.DescId, _tmpItem_PartionCell.MovementItemId, inisMany)
     FROM (SELECT DISTINCT _tmpItem_PartionCell.MovementItemId
                          , CASE WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_1()  THEN zc_MIBoolean_PartionCell_Many_1()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_2()  THEN zc_MIBoolean_PartionCell_Many_2()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_3()  THEN zc_MIBoolean_PartionCell_Many_3()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_4()  THEN zc_MIBoolean_PartionCell_Many_4()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_5()  THEN zc_MIBoolean_PartionCell_Many_5()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_6()  THEN zc_MIBoolean_PartionCell_Many_6()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_7()  THEN zc_MIBoolean_PartionCell_Many_7()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_8()  THEN zc_MIBoolean_PartionCell_Many_8()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_9()  THEN zc_MIBoolean_PartionCell_Many_9()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_10() THEN zc_MIBoolean_PartionCell_Many_10()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_11() THEN zc_MIBoolean_PartionCell_Many_11()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_12() THEN zc_MIBoolean_PartionCell_Many_12()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_13() THEN zc_MIBoolean_PartionCell_Many_13()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_14() THEN zc_MIBoolean_PartionCell_Many_14()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_15() THEN zc_MIBoolean_PartionCell_Many_15()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_16() THEN zc_MIBoolean_PartionCell_Many_16()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_17() THEN zc_MIBoolean_PartionCell_Many_17()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_18() THEN zc_MIBoolean_PartionCell_Many_18()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_19() THEN zc_MIBoolean_PartionCell_Many_19()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_20() THEN zc_MIBoolean_PartionCell_Many_20()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_21() THEN zc_MIBoolean_PartionCell_Many_21()
                                 WHEN _tmpItem_PartionCell.DescId_MILO = zc_MILinkObject_PartionCell_22() THEN zc_MIBoolean_PartionCell_Many_22()
                            END AS DescId

           FROM _tmpItem_PartionCell
           ) AS _tmpItem_PartionCell;

     END IF;


     if vbUserId = 9457
     then
         RAISE EXCEPTION 'Test. Ok';
     end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.25         *
*/

-- тест
--