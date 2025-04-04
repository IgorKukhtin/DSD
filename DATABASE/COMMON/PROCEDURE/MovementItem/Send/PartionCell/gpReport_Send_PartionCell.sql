-- Function: gpReport_Send_PartionCell ()

--DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Send_PartionCell (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Send_PartionCell (
    IN inStartDate         TDateTime ,
    IN inEndDate           TDateTime ,
    IN inUnitId            Integer   ,
    IN inIsMovement        Boolean   ,
    IN inIsCell            Boolean   ,
    IN inIsShowAll         Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, OperDate_min TDateTime, OperDate_max TDateTime
             , ItemName TVarChar
             , isRePack Boolean
             , InsertDate TDateTime, InsertName TVarChar
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar

             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , PartionGoodsDate_real_real TDateTime
             , DescId_milo_num Integer
             , PartionCellId_num Integer

             , PartionCellId_1  Integer
             , PartionCellId_2  Integer
             , PartionCellId_3  Integer
             , PartionCellId_4  Integer
             , PartionCellId_5  Integer
             , PartionCellId_6  Integer
             , PartionCellId_7  Integer
             , PartionCellId_8  Integer
             , PartionCellId_9  Integer
             , PartionCellId_10 Integer
             , PartionCellId_11  Integer
             , PartionCellId_12  Integer
             , PartionCellId_13  Integer
             , PartionCellId_14  Integer
             , PartionCellId_15  Integer
             , PartionCellId_16  Integer
             , PartionCellId_17  Integer
             , PartionCellId_18  Integer
             , PartionCellId_19  Integer
             , PartionCellId_20  Integer
             , PartionCellId_21  Integer
             , PartionCellId_22  Integer

             , PartionCellCode_1  Integer
             , PartionCellCode_2  Integer
             , PartionCellCode_3  Integer
             , PartionCellCode_4  Integer
             , PartionCellCode_5  Integer
             , PartionCellCode_6  Integer
             , PartionCellCode_7  Integer
             , PartionCellCode_8  Integer
             , PartionCellCode_9  Integer
             , PartionCellCode_10 Integer
             , PartionCellCode_11  Integer
             , PartionCellCode_12  Integer
             , PartionCellCode_13  Integer
             , PartionCellCode_14  Integer
             , PartionCellCode_15  Integer
             , PartionCellCode_16  Integer
             , PartionCellCode_17  Integer
             , PartionCellCode_18  Integer
             , PartionCellCode_19  Integer
             , PartionCellCode_20 Integer
             , PartionCellCode_21 Integer
             , PartionCellCode_22 Integer


             , PartionCellName_1   TVarChar
             , PartionCellName_2   TVarChar
             , PartionCellName_3   TVarChar
             , PartionCellName_4   TVarChar
             , PartionCellName_5   TVarChar
             , PartionCellName_6   TVarChar
             , PartionCellName_7   TVarChar
             , PartionCellName_8   TVarChar
             , PartionCellName_9   TVarChar
             , PartionCellName_10  TVarChar
             , PartionCellName_11   TVarChar
             , PartionCellName_12   TVarChar
             , PartionCellName_13   TVarChar
             , PartionCellName_14   TVarChar
             , PartionCellName_15   TVarChar
             , PartionCellName_16   TVarChar
             , PartionCellName_17   TVarChar
             , PartionCellName_18   TVarChar
             , PartionCellName_19   TVarChar
             , PartionCellName_20  TVarChar
             , PartionCellName_21  TVarChar
             , PartionCellName_22  TVarChar
             , PartionCellName_ets  TVarChar

             , PartionCellName_srch TVarChar

             , ColorFon_1  Integer
             , ColorFon_2  Integer
             , ColorFon_3  Integer
             , ColorFon_4  Integer
             , ColorFon_5  Integer
             , ColorFon_6  Integer
             , ColorFon_7  Integer
             , ColorFon_8  Integer
             , ColorFon_9  Integer
             , ColorFon_10 Integer
             , ColorFon_11  Integer
             , ColorFon_12  Integer
             , ColorFon_13  Integer
             , ColorFon_14  Integer
             , ColorFon_15  Integer
             , ColorFon_16  Integer
             , ColorFon_17  Integer
             , ColorFon_18  Integer
             , ColorFon_19  Integer
             , ColorFon_20  Integer
             , ColorFon_21  Integer
             , ColorFon_22  Integer

             , Color_1  Integer
             , Color_2  Integer
             , Color_3  Integer
             , Color_4  Integer
             , Color_5  Integer
             , Color_6  Integer
             , Color_7  Integer
             , Color_8  Integer
             , Color_9  Integer
             , Color_10 Integer
             , Color_11  Integer
             , Color_12  Integer
             , Color_13  Integer
             , Color_14  Integer
             , Color_15  Integer
             , Color_16  Integer
             , Color_17  Integer
             , Color_18  Integer
             , Color_19  Integer
             , Color_20  Integer
             , Color_21  Integer
             , Color_22  Integer

               -- есть ли хоть одна закрытая партия
             , isClose_value_min Boolean
               -- Сформированы данные по ячейкам (да/нет)
             , isPartionCell Boolean
             , isPartionCell_min Boolean

             , Amount TFloat, Amount_Weight TFloat

             , NormInDays      Integer
             , NormInDays_real Integer
             , NormInDays_tax  TFloat
             , NormInDays_date TDateTime

             , Color_PartionGoodsDate Integer
             , Color_NormInDays       Integer
             , Marker_NormInDays      Integer

             , AmountRemains TFloat
             , AmountRemains_Weight TFloat

             , Ord Integer
             , ColorFon_ord Integer

             , NPP_ChoiceCell      Integer 
             , ChoiceCellId        Integer
             , ChoiceCellCode      Integer
             , ChoiceCellName      TVarChar
             , ChoiceCellName_shot TVarChar

             , isChoiceCell_mi          Boolean
             , PartionGoodsDate_next    TDateTime
             , InsertDate_ChoiceCell_mi TDateTime

             , isLock_record Boolean
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
 DECLARE vbIsWeighing Boolean;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);


     vbIsWeighing:= TRUE; -- vbUserId = 5;

     IF inStartDate + INTERVAL '8 MONTH' < inEndDate
     THEN
         RAISE EXCEPTION 'Ошибка.Начальная дата = <%>.', inStartDate;
     END IF;


     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!замена!!!
     IF COALESCE (inUnitId,0) = 0
     THEN
         inUnitId := zc_Unit_RK();
     END IF;


     inUnitId := zc_Unit_RK();


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpPartionCell'))
     THEN
         DELETE FROM _tmpPartionCell;
     ELSE
         CREATE TEMP TABLE _tmpPartionCell (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;
    END IF;


   IF inIsShowAll = FALSE
   THEN

     --
     --CREATE TEMP TABLE _tmpPartionCell (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;

     --
     OPEN curPartionCell FOR SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PartionCell() ORDER BY Object.Id;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curPartionCell INTO vbPartionCellId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;

          -- Только заполненные ячейки + отбор
          INSERT INTO _tmpPartionCell (MovementItemId, DescId, ObjectId)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
             -- Результат
             SELECT tmpMILO.MovementItemId, tmpMILO.DescId, tmpMILO.ObjectId
             FROM tmpMILO
             -- Только заполненные
             WHERE tmpMILO.ObjectId > 0
               AND tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
            ;
          --
          -- ANALYZE _tmpPartionCell;

     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


     -- Результат
     RETURN QUERY
     WITH
       -- товары из 2-х групп
       tmpGoods AS (SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect
                   UNION
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1979) AS lfSelect
                   )
    , tmpNormInDays AS (SELECT Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId, Object_GoodsByGoodsKind_View.NormInDays
                        FROM Object_GoodsByGoodsKind_View
                             JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                        WHERE Object_GoodsByGoodsKind_View.NormInDays > 0
                       )

      -- Все документы
    , tmpMovement AS (-- или в Периоде - Send
                      SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND MovementLinkObject_To.ObjectId = inUnitId

                     UNION
                      -- или в Ячейке
                      SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.Id IN (SELECT DISTINCT MovementItem.MovementId
                                            FROM _tmpPartionCell
                                                 JOIN MovementItem ON MovementItem.Id = _tmpPartionCell.MovementItemId
                                            -- Без отбор
                                            WHERE _tmpPartionCell.ObjectId NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                                           )
                        AND Movement.DescId = zc_Movement_Send()
                        AND MovementLinkObject_To.ObjectId = inUnitId

                     UNION
                      -- или в Периоде - WeighingProduction
                      SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                           LEFT JOIN MovementFloat AS MovementFloat_BranchCode
                                                   ON MovementFloat_BranchCode.MovementId = Movement.Id
                                                  AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                           LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                                   ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                                  AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
                                                  AND MovementFloat_MovementDescNumber.ValueData  = 25 -- Перепак
                                                  -- !!!
                                                  AND MovementFloat_BranchCode.ValueData          = 1

                      WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '14 DAY' AND inEndDate + INTERVAL '14 DAY'
                        AND Movement.DescId = zc_Movement_WeighingProduction()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND MovementLinkObject_From.ObjectId IN (zc_Unit_Pack(), zc_Unit_RK_Label())
                        AND MovementLinkObject_To.ObjectId = inUnitId
                        AND vbIsWeighing = TRUE
                        AND (Movement.Id <> 28931444 OR vbUserId = 5)
                        -- без Перепак
                        AND MovementFloat_MovementDescNumber.MovementId IS NULL

                     UNION
                      -- или в Ячейке
                      SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.Id IN (SELECT DISTINCT MovementItem.MovementId
                                            FROM _tmpPartionCell
                                                 JOIN MovementItem ON MovementItem.Id       = _tmpPartionCell.MovementItemId
                                                                  AND MovementItem.isErased = FALSE
                                            -- Без отбор
                                            WHERE _tmpPartionCell.ObjectId NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                                           )
                        AND Movement.DescId = zc_Movement_WeighingProduction()
                        AND Movement.StatusId = zc_Enum_Status_UnComplete()
                        AND MovementLinkObject_From.ObjectId IN (zc_Unit_Pack(), zc_Unit_RK_Label())
                        AND MovementLinkObject_To.ObjectId = inUnitId
                        AND vbIsWeighing = TRUE
                        AND (Movement.Id <> 28931444 OR vbUserId = 5)
                      )

       -- Все MI
     , tmpMI_all AS (SELECT MovementItem.Id         AS MovementItemId
                          , MovementItem.MovementId AS MovementId
                          , MovementItem.ObjectId   AS GoodsId
                          , MovementItem.Amount     AS Amount
                     FROM MovementItem
                          -- ограничили товаром
                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId   = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
                    )
           -- Все MI - или в Периоде или в Ячейке
         , tmpMI AS (SELECT tmpMI_all.MovementItemId
                          , tmpMI_all.MovementId
                          , tmpMI_all.GoodsId
                          , tmpMI_all.Amount
                     FROM tmpMI_all
                          INNER JOIN tmpMovement ON tmpMovement.Id = tmpMI_all.MovementId
                          LEFT JOIN (SELECT DISTINCT _tmpPartionCell.MovementItemId FROM _tmpPartionCell
                                     -- Без отбор
                                     WHERE _tmpPartionCell.ObjectId NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                                    ) AS _tmpPartionCell
                                      ON _tmpPartionCell.MovementItemId = tmpMI_all.MovementItemId
                     WHERE (tmpMovement.OperDate BETWEEN inStartDate AND inEndDate)
                        -- или в Ячейке
                        OR _tmpPartionCell.MovementItemId > 0
                    )

      -- Только заполненные ячейки + отбор
    , tmpMILO_PC AS (SELECT _tmpPartionCell.*
                     FROM _tmpPartionCell
                    )
      -- Только заполненные ячейки + отбор
    , tmpMILO_PC_count AS (SELECT _tmpPartionCell.MovementItemId
                                   -- для пропорционального деления веса
                                 , COUNT (*) AS CountCell
                           FROM _tmpPartionCell
                           GROUP BY _tmpPartionCell.MovementItemId
                          )

     , tmpMovementDate_Insert AS (SELECT MovementDate.*
                          FROM MovementDate
                          WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementDate.DescId = zc_MovementDate_Insert()
                          )
    , tmpMLO_Insert AS (SELECT MovementLinkObject.*
                 FROM MovementLinkObject
                 WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                   AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                 )

    , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                        FROM MovementItemBoolean
                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                           , zc_MIBoolean_PartionCell_Close_2()
                                                           , zc_MIBoolean_PartionCell_Close_3()
                                                           , zc_MIBoolean_PartionCell_Close_4()
                                                           , zc_MIBoolean_PartionCell_Close_5()
                                                           , zc_MIBoolean_PartionCell_Close_6()
                                                           , zc_MIBoolean_PartionCell_Close_7()
                                                           , zc_MIBoolean_PartionCell_Close_8()
                                                           , zc_MIBoolean_PartionCell_Close_9()
                                                           , zc_MIBoolean_PartionCell_Close_10()
                                                           , zc_MIBoolean_PartionCell_Close_11()
                                                           , zc_MIBoolean_PartionCell_Close_12()
                                                           , zc_MIBoolean_PartionCell_Close_13()
                                                           , zc_MIBoolean_PartionCell_Close_14()
                                                           , zc_MIBoolean_PartionCell_Close_15()
                                                           , zc_MIBoolean_PartionCell_Close_16()
                                                           , zc_MIBoolean_PartionCell_Close_17()
                                                           , zc_MIBoolean_PartionCell_Close_18()
                                                           , zc_MIBoolean_PartionCell_Close_19()
                                                           , zc_MIBoolean_PartionCell_Close_20()
                                                           , zc_MIBoolean_PartionCell_Close_21()
                                                           , zc_MIBoolean_PartionCell_Close_22()
                                                            )
                       )

     , tmpMILO_PartionCell AS (SELECT MovementItemLinkObject.*
                                      -- оригинал
                                    , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer AS PartionCellId_real
                                      -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты, для этого потом MAX
                                    , CASE WHEN tmpMI_Boolean.ValueData = TRUE THEN 0 ELSE 1 END AS isClose_value
                               FROM tmpMILO_PC AS MovementItemLinkObject
                                    LEFT JOIN tmpMI_Boolean ON tmpMI_Boolean.MovementItemId = MovementItemLinkObject.MovementItemId
                                                           AND tmpMI_Boolean.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_1()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_2()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_3()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_4()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_5()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_6()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_7()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_8()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_9()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_10()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_11()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_12()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_13()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_14()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_15()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_16()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_17()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_18()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_19()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_20()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_21()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_22()

                                                                                              END
                                    LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                                ON MIF_PartionCell_real.MovementItemId = MovementItemLinkObject.MovementItemId
                                                               -- !!!!
                                                               AND MovementItemLinkObject.ObjectId = zc_PartionCell_RK()
                                                               --
                                                               AND MIF_PartionCell_real.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_1()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_2()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_3()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_4()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_5()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_6()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_7()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_8()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_9()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_10()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_11()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_12()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_13()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_14()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_15()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_16()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_17()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_18()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_19()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_20()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_21()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_22()

                                                                                                         END
                              )
     , tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                             )
     , tmpMI_Date AS (SELECT *
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )

       -- расчет кол-во - мастер
     , tmpData_MI AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                           , CASE WHEN inIsMovement = TRUE THEN Movement.DescId ELSE 0 END                   AS MovementDescId    -- ***
                           , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END               AS InvNumber
                           , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END              AS OperDate
                           , MAX (CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE THEN 1 ELSE 0 END) AS isRePack_Value
                           , MIN (Movement.OperDate)                                                         AS OperDate_min
                           , MAX (Movement.OperDate)                                                         AS OperDate_max
                           , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END                   AS FromId
                           , Movement.ToId                                                                   AS ToId              -- ***
                           , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***

                           , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                             --
                           , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102()
                                   AND 1=0
                                       -- Тушенка
                                       THEN 0
                                  ELSE COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                             END AS GoodsKindId

                             -- ***Дата партии
                           , CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE -- AND vbUserId = 5
                                       THEN zc_DateStart()
                                  ELSE COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                             END :: TDateTime AS PartionGoodsDate

                             -- ***Дата партии
                           , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime AS PartionGoodsDate_real_real

                             -- кол-во
                           , SUM (MovementItem.Amount / CASE WHEN inIsCell = TRUE AND tmpMILO_PC_count.CountCell > 0 THEN tmpMILO_PC_count.CountCell ELSE 1 END) AS Amount

                             -- есть привязка или нет - !!!НЕ!!! выводится двумя строчками
                           , MIN (COALESCE (tmpMILO_PC_count.MovementItemId, 0)) AS isPartionCell_min
                           , MAX (COALESCE (tmpMILO_PC_count.MovementItemId, 0)) AS isPartionCell_max

                             -- если дата партии отличается от даты документа - выделить фон другим цветом
                           , MAX (CASE WHEN Movement.OperDate <> COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                       THEN 1
                                       ELSE 0
                                  END) AS isColor_PartionGoodsDate
                            -- кол-во заполненных
                          , MAX (tmpMILO_PC_count.CountCell) AS CountCell

                            -- по ячейкам - вертикально
                          , CASE WHEN inIsCell = TRUE THEN COALESCE (tmpMILO_PartionCell.ObjectId, 0) ELSE 0 END AS PartionCellId

                      FROM tmpMovement AS Movement
                           INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                           -- Тушенка
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.GoodsId
                                               AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()

                           -- пропорционально
                           LEFT JOIN tmpMILO_PC_count AS tmpMILO_PC_count ON tmpMILO_PC_count.MovementItemId = MovementItem.MovementItemId
                           -- по ячейкам
                           LEFT JOIN tmpMILO_PC AS tmpMILO_PartionCell ON tmpMILO_PartionCell.MovementItemId = MovementItem.MovementItemId
                                                                      AND inIsCell = TRUE

                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()

                           LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                               AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                           LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                      GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.DescId ELSE 0 END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END
                             , Movement.ToId
                             , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END
                             , MovementItem.GoodsId
                             , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_30102()
                                     AND 1=0
                                         -- Тушенка
                                         THEN 0
                                    ELSE COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                               END
                             , CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE -- AND vbUserId = 5
                                         THEN  zc_DateStart()
                                    ELSE COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                               END
                             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)

                             , COALESCE (tmpMILO_PartionCell.ObjectId, 0)
                     )

    -- Развернули по ячейкам - вертикально
  , tmpData_PartionCell_All_All AS (SELECT tmpData_list.MovementId        -- ***
                                         , tmpData_list.MovementDescId    -- ***
                                         , tmpData_list.ToId              -- ***
                                         , tmpData_list.MovementItemId    -- ***
                                         , tmpData_list.GoodsId           -- ***
                                         , tmpData_list.GoodsKindId       -- ***
                                         , tmpData_list.PartionGoodsDate  -- ***
                                           -- группируется по ячейкам
                                         , tmpData_list.DescId_milo
                                         , tmpData_list.PartionCellId
                                           -- информативно
                                         , (tmpData_list.PartionCellId_real) AS PartionCellId_real
                                           -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                                         , MAX (tmpData_list.isClose_value)                                        AS isClose_value_max
                                           -- есть хоть одна закрытая ячейка
                                         , MIN (tmpData_list.isClose_value)                                        AS isClose_value_min

                                           -- № п/п - СКВОЗНОЙ - ВСЕ
                                         , ROW_NUMBER() OVER (ORDER BY tmpData_list.GoodsId ASC) AS Ord_all

                                    FROM -- Расчет нужной ячейки по которой группировать
                                         (SELECT DISTINCT
                                                 CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                                               , CASE WHEN inIsMovement = TRUE THEN Movement.DescId ELSE 0 END                   AS MovementDescId    -- ***
                                               , Movement.ToId                                                                   AS ToId              -- ***
                                               , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                                               , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                                               , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                                                 -- ***
                                               , CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE -- AND vbUserId = 5
                                                           THEN zc_DateStart()
                                                      --WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE
                                                      --     THEN COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) -- zc_DateStart()
                                                      ELSE COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                                 END :: TDateTime AS PartionGoodsDate
                                                 --
                                               , MILinkObject_PartionCell.DescId AS DescId_milo
                                                 -- Расчет нужной ячейки по которой группировать
                                               , CASE WHEN inIsMovement = TRUE
                                                      THEN MILinkObject_PartionCell.ObjectId
                                                      ELSE MILinkObject_PartionCell.ObjectId
                                                 END AS PartionCellId
                                                 -- информативно
                                               , CASE WHEN 1=1 -- vbUserId = 5
                                                      THEN COALESCE (MILinkObject_PartionCell.PartionCellId_real, 0)
                                                      WHEN inIsMovement = TRUE
                                                      THEN COALESCE (MILinkObject_PartionCell.PartionCellId_real, 0)
                                                      ELSE NULL
                                                 END AS PartionCellId_real

                                                 -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                                               , MILinkObject_PartionCell.isClose_value

                                          FROM tmpMovement AS Movement
                                               INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                                               LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                                         ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                                        AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()

                                               LEFT JOIN tmpMI_Date AS MIDate_PartionGoods
                                                                    ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                                                   AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                                               LEFT JOIN tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                               -- Только заполненные ячейки
                                               INNER JOIN tmpMILO_PartionCell AS MILinkObject_PartionCell
                                                                              ON MILinkObject_PartionCell.MovementItemId = MovementItem.MovementItemId

                                         ) AS tmpData_list

                                    GROUP BY tmpData_list.MovementId        -- ***
                                           , tmpData_list.MovementDescId    -- ***
                                           , tmpData_list.ToId              -- ***
                                           , tmpData_list.MovementItemId    -- ***
                                           , tmpData_list.GoodsId           -- ***
                                           , tmpData_list.GoodsKindId       -- ***
                                           , tmpData_list.PartionGoodsDate  -- ***
                                             -- группируется по ячейкам
                                           , tmpData_list.DescId_milo
                                           , tmpData_list.PartionCellId
                                             -- информативно
                                           , (tmpData_list.PartionCellId_real)
                                   )
      -- Только заполненные ячейки - № п/п
    , tmpData_PartionCell_All AS (SELECT tmpData_PartionCell_All_All.MovementId        -- ***
                                       , tmpData_PartionCell_All_All.MovementDescId    -- ***
                                       , tmpData_PartionCell_All_All.ToId              -- ***
                                       , tmpData_PartionCell_All_All.MovementItemId    -- ***
                                       , tmpData_PartionCell_All_All.GoodsId           -- ***
                                       , tmpData_PartionCell_All_All.GoodsKindId       -- ***
                                       , tmpData_PartionCell_All_All.PartionGoodsDate  -- ***

                                         -- для вертикально - в какой ячейке заполнение
                                       , CASE WHEN inIsCell = TRUE
                                              THEN CASE tmpData_PartionCell_All_All.DescId_milo
                                                        WHEN zc_MILinkObject_PartionCell_1() THEN 1
                                                        WHEN zc_MILinkObject_PartionCell_2() THEN 2
                                                        WHEN zc_MILinkObject_PartionCell_3() THEN 3
                                                        WHEN zc_MILinkObject_PartionCell_4() THEN 4
                                                        WHEN zc_MILinkObject_PartionCell_5() THEN 5
                                                        WHEN zc_MILinkObject_PartionCell_6() THEN 6
                                                        WHEN zc_MILinkObject_PartionCell_7() THEN 7
                                                        WHEN zc_MILinkObject_PartionCell_8() THEN 8
                                                        WHEN zc_MILinkObject_PartionCell_9() THEN 9
                                                        WHEN zc_MILinkObject_PartionCell_10() THEN 10
                                                        WHEN zc_MILinkObject_PartionCell_11() THEN 11
                                                        WHEN zc_MILinkObject_PartionCell_12() THEN 12
                                                        WHEN zc_MILinkObject_PartionCell_13() THEN 13
                                                        WHEN zc_MILinkObject_PartionCell_14() THEN 14
                                                        WHEN zc_MILinkObject_PartionCell_15() THEN 15
                                                        WHEN zc_MILinkObject_PartionCell_16() THEN 16
                                                        WHEN zc_MILinkObject_PartionCell_17() THEN 17
                                                        WHEN zc_MILinkObject_PartionCell_18() THEN 18
                                                        WHEN zc_MILinkObject_PartionCell_19() THEN 19
                                                        WHEN zc_MILinkObject_PartionCell_20() THEN 20
                                                        WHEN zc_MILinkObject_PartionCell_21() THEN 21
                                                        WHEN zc_MILinkObject_PartionCell_22() THEN 22
                                                        ELSE - 1
                                                   END
                                              ELSE 0
                                         END AS DescId_milo_num
                                         --
                                       , tmpData_PartionCell_All_All.PartionCellId
                                         --
                                       , Object_PartionCell.ObjectCode AS PartionCellCode
                                       , tmpData_PartionCell_All_All.PartionCellId_real
                                       , COALESCE (Object_PartionCell_real.ValueData, Object_PartionCell.ValueData) AS PartionCellName_calc
                                         -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                                       , tmpData_PartionCell_All_All.isClose_value_max
                                         -- есть хоть одна закрытая ячейка
                                       , tmpData_PartionCell_All_All.isClose_value_min

                                         -- для сортировки - горизонтально
                                       , ROW_NUMBER() OVER (PARTITION BY tmpData_PartionCell_All_All.MovementId        -- ***
                                                                       , tmpData_PartionCell_All_All.ToId              -- ***
                                                                       , tmpData_PartionCell_All_All.MovementItemId    -- ***
                                                                       , tmpData_PartionCell_All_All.GoodsId           -- ***
                                                                       , tmpData_PartionCell_All_All.GoodsKindId       -- ***
                                                                       , tmpData_PartionCell_All_All.PartionGoodsDate  -- ***
                                                                         -- если по ячейкам то все ячейки выводим отдельной строкой
                                                                       , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All_All.Ord_all       ELSE 0 END

                                                            ORDER BY CASE WHEN tmpData_PartionCell_All_All.PartionGoodsDate = zc_DateStart() THEN 1 ELSE 0 END
                                                                 --, CASE WHEN COALESCE (tmpData_PartionCell_All_All.PartionCellId, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err()) THEN 1 ELSE 0 END
                                                                   , COALESCE (tmpData_PartionCell_All_All.DescId_milo, 0)
                                                                   , COALESCE (ObjectFloat_Level.ValueData, 0)
                                                                   , COALESCE (Object_PartionCell_real.ObjectCode, Object_PartionCell.ObjectCode, 0)
                                                           ) AS Ord

                                  FROM tmpData_PartionCell_All_All
                                       LEFT JOIN Object AS Object_PartionCell      ON Object_PartionCell.Id      = tmpData_PartionCell_All_All.PartionCellId
                                       LEFT JOIN Object AS Object_PartionCell_real ON Object_PartionCell_real.Id = tmpData_PartionCell_All_All.PartionCellId_real
                                       LEFT JOIN ObjectFloat AS ObjectFloat_Level
                                                             ON ObjectFloat_Level.ObjectId = COALESCE (Object_PartionCell_real.Id, Object_PartionCell.Id)
                                                            AND ObjectFloat_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
                                 )


      -- Сортировка партий - какую ячейку снимать первой
    , tmpData_npp AS (SELECT tmpData_PartionCell_All.GoodsId, tmpData_PartionCell_All.GoodsKindId, tmpData_PartionCell_All.PartionGoodsDate
                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY tmpData_PartionCell_All.GoodsId, tmpData_PartionCell_All.GoodsKindId
                                                ORDER BY CASE WHEN tmpData_PartionCell_All.PartionGoodsDate = zc_DateStart() THEN 1 ELSE 0 END
                                                       , COALESCE (tmpData_PartionCell_All.PartionGoodsDate, zc_DateEnd()) ASC
                                               ) AS Ord
                      FROM (SELECT DISTINCT
                                   tmpData_PartionCell_All.GoodsId
                                 , tmpData_PartionCell_All.GoodsKindId
                                 , tmpData_PartionCell_All.PartionGoodsDate
                            FROM tmpData_PartionCell_All
                            WHERE tmpData_PartionCell_All.PartionCellId > 0
                              AND tmpData_PartionCell_All.PartionCellId NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                           ) AS tmpData_PartionCell_All
                     )
      -- Развернули по ячейкам - горизонтально
    , tmpData_PartionCell AS (SELECT tmpData_PartionCell_All.MovementId
                                   , tmpData_PartionCell_All.MovementDescId
                                   , tmpData_PartionCell_All.ToId
                                   , tmpData_PartionCell_All.MovementItemId
                                   , tmpData_PartionCell_All.GoodsId
                                   , tmpData_PartionCell_All.GoodsKindId
                                   , tmpData_PartionCell_All.PartionGoodsDate

                                     --
                                   , MAX (tmpData_PartionCell_All.DescId_milo_num) AS DescId_milo_num
                                     -- Номер св-ва для вертикального отображения
                                   , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All.PartionCellId ELSE NULL END AS PartionCellId_num

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_22

                                     -- есть хоть одна закрытая ячейка
                                   , MIN (tmpData_PartionCell_All.isClose_value_min) AS isClose_value_min

                                   , STRING_AGG (DISTINCT CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) > 22  THEN tmpData_PartionCell_All.PartionCellName_calc ELSE '' END, ';') AS PartionCellName_ets

                              FROM tmpData_PartionCell_All

                              GROUP BY tmpData_PartionCell_All.MovementId
                                     , tmpData_PartionCell_All.MovementDescId
                                     , tmpData_PartionCell_All.ToId
                                     , tmpData_PartionCell_All.MovementItemId
                                     , tmpData_PartionCell_All.GoodsId
                                     , tmpData_PartionCell_All.GoodsKindId
                                     , tmpData_PartionCell_All.PartionGoodsDate
                                     , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All.PartionCellId ELSE NULL END
                              )
    , tmpResult AS (
                    -- Результат
                    SELECT tmpData_MI.MovementId
                         , tmpData_MI.InvNumber    :: TVarChar
                         , tmpData_MI.OperDate     :: TDateTime
                         , tmpData_MI.OperDate_min :: TDateTime
                         , tmpData_MI.OperDate_max :: TDateTime
                         , MovementDesc.ItemName         AS ItemName
                         , CASE WHEN tmpData_MI.isRePack_Value = 1 THEN TRUE ELSE FALSE END :: Boolean AS isRePack
                         , MovementDate_Insert.ValueData AS InsertDate
                         , Object_Insert.ValueData       AS InsertName
                         , Object_From.Id                AS FromId
                         , Object_From.ValueData         AS FromName
                         , Object_To.Id                  AS ToId
                         , Object_To.ValueData           AS ToName
                         , tmpData_MI.MovementItemId
                         , Object_Goods.Id                            AS GoodsId
                         , Object_Goods.ObjectCode                    AS GoodsCode
                         , Object_Goods.ValueData                     AS GoodsName
                         , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                         , Object_GoodsGroup.ValueData                AS GoodsGroupName
                         , Object_Measure.ValueData                   AS MeasureName
                         , Object_GoodsKind.Id                        AS GoodsKindId
                         , Object_GoodsKind.ValueData                 AS GoodsKindName
                         , CASE WHEN tmpData_MI.PartionGoodsDate = zc_DateStart() THEN NULL ELSE tmpData_MI.PartionGoodsDate END :: TDateTime AS PartionGoodsDate
                         , tmpData_MI.PartionGoodsDate_real_real
                         , tmpData_MI.PartionGoodsDate AS PartionGoodsDate_real

                         , COALESCE (tmpData_PartionCell.DescId_milo_num, 0)      AS DescId_milo_num
                         , tmpData_PartionCell.PartionCellId_num     :: Integer   AS PartionCellId_num
                         , tmpData_MI.CountCell
                           --
                         , tmpData_PartionCell.PartionCellId_1  :: Integer
                         , tmpData_PartionCell.PartionCellId_2  :: Integer
                         , tmpData_PartionCell.PartionCellId_3  :: Integer
                         , tmpData_PartionCell.PartionCellId_4  :: Integer
                         , tmpData_PartionCell.PartionCellId_5  :: Integer
                         , tmpData_PartionCell.PartionCellId_6  :: Integer
                         , tmpData_PartionCell.PartionCellId_7  :: Integer
                         , tmpData_PartionCell.PartionCellId_8  :: Integer
                         , tmpData_PartionCell.PartionCellId_9  :: Integer
                         , tmpData_PartionCell.PartionCellId_10 :: Integer
                         , tmpData_PartionCell.PartionCellId_11 :: Integer
                         , tmpData_PartionCell.PartionCellId_12 :: Integer
                         , tmpData_PartionCell.PartionCellId_13 :: Integer
                         , tmpData_PartionCell.PartionCellId_14 :: Integer
                         , tmpData_PartionCell.PartionCellId_15 :: Integer
                         , tmpData_PartionCell.PartionCellId_16 :: Integer
                         , tmpData_PartionCell.PartionCellId_17 :: Integer
                         , tmpData_PartionCell.PartionCellId_18 :: Integer
                         , tmpData_PartionCell.PartionCellId_19 :: Integer
                         , tmpData_PartionCell.PartionCellId_20 :: Integer
                         , tmpData_PartionCell.PartionCellId_21 :: Integer
                         , tmpData_PartionCell.PartionCellId_22 :: Integer

                         , tmpData_PartionCell.PartionCellCode_1  :: Integer
                         , tmpData_PartionCell.PartionCellCode_2  :: Integer
                         , tmpData_PartionCell.PartionCellCode_3  :: Integer
                         , tmpData_PartionCell.PartionCellCode_4  :: Integer
                         , tmpData_PartionCell.PartionCellCode_5  :: Integer
                         , tmpData_PartionCell.PartionCellCode_6  :: Integer
                         , tmpData_PartionCell.PartionCellCode_7  :: Integer
                         , tmpData_PartionCell.PartionCellCode_8  :: Integer
                         , tmpData_PartionCell.PartionCellCode_9  :: Integer
                         , tmpData_PartionCell.PartionCellCode_10 :: Integer
                         , tmpData_PartionCell.PartionCellCode_11 :: Integer
                         , tmpData_PartionCell.PartionCellCode_12 :: Integer
                         , tmpData_PartionCell.PartionCellCode_13 :: Integer
                         , tmpData_PartionCell.PartionCellCode_14 :: Integer
                         , tmpData_PartionCell.PartionCellCode_15 :: Integer
                         , tmpData_PartionCell.PartionCellCode_16 :: Integer
                         , tmpData_PartionCell.PartionCellCode_17 :: Integer
                         , tmpData_PartionCell.PartionCellCode_18 :: Integer
                         , tmpData_PartionCell.PartionCellCode_19 :: Integer
                         , tmpData_PartionCell.PartionCellCode_20 :: Integer
                         , tmpData_PartionCell.PartionCellCode_21 :: Integer
                         , tmpData_PartionCell.PartionCellCode_22 :: Integer


                         , tmpData_PartionCell.PartionCellName_1        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_2        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_3        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_4        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_5        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_6        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_7        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_8        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_9        :: TVarChar
                         , tmpData_PartionCell.PartionCellName_10       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_11       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_12       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_13       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_14       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_15       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_16       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_17       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_18       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_19       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_20       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_21       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_22       :: TVarChar
                         , tmpData_PartionCell.PartionCellName_ets      :: TVarChar

                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_1,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_1  END :: Integer   AS  ColorFon_1
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_2,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_2  END :: Integer   AS  ColorFon_2
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_3,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_3  END :: Integer   AS  ColorFon_3
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_4,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_4  END :: Integer   AS  ColorFon_4
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_5,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_5  END :: Integer   AS  ColorFon_5
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_6,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_6  END :: Integer   AS  ColorFon_6
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_7,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_7  END :: Integer   AS  ColorFon_7
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_8,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_8  END :: Integer   AS  ColorFon_8
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_9,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_9  END :: Integer   AS  ColorFon_9
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_10, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_10 END :: Integer   AS  ColorFon_10
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_11, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_11  END :: Integer  AS  ColorFon_11
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_12, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_12  END :: Integer  AS  ColorFon_12
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_13, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_13  END :: Integer  AS  ColorFon_13
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_14, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_14  END :: Integer  AS  ColorFon_14
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_15, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_15  END :: Integer  AS  ColorFon_15
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_16, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_16  END :: Integer  AS  ColorFon_16
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_17, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_17  END :: Integer  AS  ColorFon_17
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_18, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_18  END :: Integer  AS  ColorFon_18
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_19, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_19  END :: Integer  AS  ColorFon_19
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_20 END :: Integer   AS  ColorFon_20
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_21, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_21 END :: Integer   AS  ColorFon_21
                         , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_22, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_22 END :: Integer   AS  ColorFon_22

                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_1,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_1  END :: Integer   AS Color_1
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_2,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_2  END :: Integer   AS Color_2
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_3,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_3  END :: Integer   AS Color_3
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_4,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_4  END :: Integer   AS Color_4
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_5,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_5  END :: Integer   AS Color_5
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_6,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_6  END :: Integer   AS Color_6
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_7,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_7  END :: Integer   AS Color_7
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_8,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_8  END :: Integer   AS Color_8
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_9,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_9  END :: Integer   AS Color_9
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_10, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_10 END :: Integer   AS Color_10
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_11, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_11 END :: Integer   AS Color_11
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_12, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_12 END :: Integer   AS Color_12
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_13, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_13 END :: Integer   AS Color_13
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_14, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_14 END :: Integer   AS Color_14
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_15, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_15 END :: Integer   AS Color_15
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_16, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_16 END :: Integer   AS Color_16
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_17, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_17 END :: Integer   AS Color_17
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_18, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_18 END :: Integer   AS Color_18
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_19, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_19 END :: Integer   AS Color_19
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_20, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_20 END :: Integer   AS Color_20
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_21, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_21 END :: Integer   AS Color_21
                         , CASE WHEN COALESCE (tmpData_PartionCell.Color_22, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_22 END :: Integer   AS Color_22

                           -- есть заполненная ячейка + хоть одна закрытая ячейка
                         , CASE WHEN tmpData_MI.isPartionCell_max > 0 AND tmpData_PartionCell.isClose_value_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isClose_value_min
                           -- Сформированы данные по ячейкам (да/нет)
                         , CASE WHEN tmpData_MI.isPartionCell_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isPartionCell_min
                         , CASE WHEN tmpData_MI.isPartionCell_max > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPartionCell_max

                           -- Кол-во - пропорционально
                         , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData_MI.Amount ELSE 0 END ::TFloat AS Amount
                           -- Вес - пропорционально
                         , (tmpData_MI.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight

                           -- Срок хранения в днях
                         , tmpNormInDays.NormInDays                   :: Integer AS NormInDays

                           -- Расчет остатка в днях для Срока хранения
                         , CASE WHEN tmpData_MI.PartionGoodsDate = zc_DateStart() THEN 0
                                WHEN CURRENT_DATE < (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL)
                                     THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                                ELSE 0
                           END :: Integer AS NormInDays_real

                           -- Расчет остатка дней в % для Срока хранения
                         , CASE WHEN tmpData_MI.PartionGoodsDate = zc_DateStart() THEN 0
                                WHEN tmpNormInDays.NormInDays > 0
                                THEN CAST (100 * CASE WHEN CURRENT_DATE < tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                                                           THEN EXTRACT (DAY FROM (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                                                      ELSE 0
                                                 END
                                         / tmpNormInDays.NormInDays AS NUMERIC (16, 1))
                                ELSE 0
                           END :: TFloat AS NormInDays_tax

                           -- Срок хранения, дата
                         , CASE WHEN tmpData_MI.PartionGoodsDate = zc_DateStart() THEN NULL
                                ELSE (tmpData_MI.PartionGoodsDate + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL)
                           END :: TDateTime AS NormInDays_date

                           -- цвет для Партия дата
                         , CASE WHEN  tmpData_MI.PartionGoodsDate = zc_DateStart() THEN zc_Color_White()
                                WHEN tmpData_MI.isColor_PartionGoodsDate = 1
                                     THEN 8435455
                                     ELSE zc_Color_White()
                           END ::Integer AS Color_PartionGoodsDate

                         , 0 ::TFloat AS AmountRemains
                         , 0 ::TFloat AS AmountRemains_Weight

                           -- № п/п
                         , tmpData_npp.Ord
                       /*, ROW_NUMBER() OVER (PARTITION BY Object_Goods.Id, Object_GoodsKind.Id ORDER BY CASE WHEN COALESCE (tmpData_PartionCell.PartionCellId_1, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_2, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_3, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_4, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_5, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_6, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_7, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_8, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_9, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_10, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_11, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_12, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_13, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_14, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_15, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_16, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_17, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_18, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_19, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_20, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_21, 0) IN (0, zc_PartionCell_RK())
                                                                                                               AND COALESCE (tmpData_PartionCell.PartionCellId_22, 0) IN (0, zc_PartionCell_RK())
                                                                                                                    THEN 999
                                                                                                              ELSE 1
                                                                                                         END
                                                                                                       , CASE WHEN tmpData_MI.isPartionCell = FALSE THEN 999 ELSE 1 END
                                                                                                       , COALESCE (tmpData_MI.PartionGoodsDate, tmpData_MI.PartionGoodsDate, zc_DateStart()) ASC
                                                                                                        ) :: Integer AS Ord*/

                  FROM tmpData_MI -- расчет кол-во - мастер

                       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpData_MI.MovementDescId

                       -- Данные по ячейкам - горизонтально
                       LEFT JOIN tmpData_npp ON tmpData_npp.GoodsId          = tmpData_MI.GoodsId
                                            AND tmpData_npp.GoodsKindId      = tmpData_MI.GoodsKindId
                                            AND tmpData_npp.PartionGoodsDate = tmpData_MI.PartionGoodsDate

                       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData_MI.FromId
                       LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData_MI.ToId

                       LEFT JOIN tmpMovementDate_Insert AS MovementDate_Insert
                                                        ON MovementDate_Insert.MovementId = tmpData_MI.MovementId
                                                       AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       LEFT JOIN tmpMLO_Insert AS MLO_Insert
                                               ON MLO_Insert.MovementId = tmpData_MI.MovementId
                                              AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                       LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                       LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = tmpData_MI.GoodsId
                       LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = tmpData_MI.GoodsKindId
                       LEFT JOIN tmpNormInDays ON tmpNormInDays.GoodsId     = tmpData_MI.GoodsId
                                              AND tmpNormInDays.GoodsKindId = tmpData_MI.GoodsKindId

                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpData_MI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                            ON ObjectLink_Goods_GoodsGroup.ObjectId = tmpData_MI.GoodsId
                                           AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                       LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                       LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                              ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                             AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                       -- Данные по ячейкам - горизонтально
                       LEFT JOIN tmpData_PartionCell ON tmpData_PartionCell.MovementId       = tmpData_MI.MovementId       -- ***
                                                    AND tmpData_PartionCell.ToId             = tmpData_MI.ToId             -- ***
                                                    AND tmpData_PartionCell.MovementItemId   = tmpData_MI.MovementItemId   -- ***
                                                    AND tmpData_PartionCell.GoodsId          = tmpData_MI.GoodsId          -- ***
                                                    AND tmpData_PartionCell.GoodsKindId      = tmpData_MI.GoodsKindId      -- ***
                                                    AND tmpData_PartionCell.PartionGoodsDate = tmpData_MI.PartionGoodsDate -- ***
                                                    -- !!!Сформированы данные по ячейкам!!!
                                                    AND tmpData_MI.isPartionCell_max > 0
                                                  --  AND vbUserId <> 5
                                                    AND (tmpData_PartionCell.PartionCellId_num  = tmpData_MI.PartionCellId -- ***
                                                      OR tmpData_MI.PartionCellId = 0
                                                      OR inIsCell = FALSE
                                                        )
              )

        --ячейки отбора
      , tmpChoiceCell AS (SELECT tmp.*
                               , LEFT (tmp.Name, 1)::TVarChar AS CellName_shot
                               , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId ORDER BY tmp.Code) AS Ord
                          FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS tmp
                          )
          -- если партия - отмечена для снятия с хранения
       ,  tmpChoiceCell_mi AS (SELECT lpSelect.GoodsId, lpSelect.GoodsKindId
                                    , lpSelect.PartionGoodsDate_next
                                    , lpSelect.InsertDate AS InsertDate_ChoiceCell_mi
                                    , ROW_NUMBER() OVER (PARTITION BY lpSelect.GoodsId, lpSelect.GoodsKindId ORDER BY lpSelect.OperDate DESC, lpSelect.MovementItemId DESC, lpSelect.ChoiceCellCode) AS Ord
                               FROM lpSelect_Movement_ChoiceCell_mi (vbUserId) AS lpSelect
                               WHERE lpSelect.Ord = 1
                                 AND lpSelect.InsertDate >= (CASE WHEN EXTRACT (HOUR FROM CURRENT_TIMESTAMP) < 8 THEN CURRENT_DATE - INTERVAL '1 DAY' ELSE CURRENT_DATE END + INTERVAL '8 HOUR')
                              )
   --
   SELECT tmpResult.MovementId
        , tmpResult.InvNumber
        , tmpResult.OperDate
        , tmpResult.OperDate_min
        , tmpResult.OperDate_max
        , tmpResult.ItemName
        , tmpResult.isRePack
        , tmpResult.InsertDate
        , tmpResult.InsertName

        , CASE WHEN vbUserId = 5 AND 1=0 THEN (select count(*) from tmpMILO_PC_count where tmpMILO_PC_count.MovementItemId = 296896881) ELSE tmpResult.FromId END :: Integer AS FromId
        , tmpResult.FromName
        , tmpResult.ToId
        , tmpResult.ToName

        , tmpResult.MovementItemId
        , tmpResult.GoodsId , tmpResult.GoodsCode , tmpResult.GoodsName
        , tmpResult.GoodsGroupNameFull, tmpResult.GoodsGroupName, tmpResult.MeasureName

        , tmpResult.GoodsKindId
        , (tmpResult.GoodsKindName || CASE WHEN vbUserId = 5 AND 1=0 THEN ' *' || COALESCE (tmpResult.CountCell, 0) :: TVarChar ELSE '' END) :: TVarChar AS GoodsKindName
          --
        , tmpResult.PartionGoodsDate
        , tmpResult.PartionGoodsDate_real_real
          --
        , tmpResult.DescId_milo_num :: Integer
        , tmpResult.PartionCellId_num

        , tmpResult.PartionCellId_1
        , tmpResult.PartionCellId_2
        , tmpResult.PartionCellId_3
        , tmpResult.PartionCellId_4
        , tmpResult.PartionCellId_5
        , tmpResult.PartionCellId_6
        , tmpResult.PartionCellId_7
        , tmpResult.PartionCellId_8
        , tmpResult.PartionCellId_9
        , tmpResult.PartionCellId_10
        , tmpResult.PartionCellId_11
        , tmpResult.PartionCellId_12
        , tmpResult.PartionCellId_13
        , tmpResult.PartionCellId_14
        , tmpResult.PartionCellId_15
        , tmpResult.PartionCellId_16
        , tmpResult.PartionCellId_17
        , tmpResult.PartionCellId_18
        , tmpResult.PartionCellId_19
        , tmpResult.PartionCellId_20
        , tmpResult.PartionCellId_21
        , tmpResult.PartionCellId_22

        , tmpResult.PartionCellCode_1
        , tmpResult.PartionCellCode_2
        , tmpResult.PartionCellCode_3
        , tmpResult.PartionCellCode_4
        , tmpResult.PartionCellCode_5
        , tmpResult.PartionCellCode_6
        , tmpResult.PartionCellCode_7
        , tmpResult.PartionCellCode_8
        , tmpResult.PartionCellCode_9
        , tmpResult.PartionCellCode_10
        , tmpResult.PartionCellCode_11
        , tmpResult.PartionCellCode_12
        , tmpResult.PartionCellCode_13
        , tmpResult.PartionCellCode_14
        , tmpResult.PartionCellCode_15
        , tmpResult.PartionCellCode_16
        , tmpResult.PartionCellCode_17
        , tmpResult.PartionCellCode_18
        , tmpResult.PartionCellCode_19
        , tmpResult.PartionCellCode_20
        , tmpResult.PartionCellCode_21
        , tmpResult.PartionCellCode_22

        , tmpResult.PartionCellName_1
        , tmpResult.PartionCellName_2
        , tmpResult.PartionCellName_3
        , tmpResult.PartionCellName_4
        , tmpResult.PartionCellName_5
        , tmpResult.PartionCellName_6
        , tmpResult.PartionCellName_7
        , tmpResult.PartionCellName_8
        , tmpResult.PartionCellName_9
        , tmpResult.PartionCellName_10
        , tmpResult.PartionCellName_11
        , tmpResult.PartionCellName_12
        , tmpResult.PartionCellName_13
        , tmpResult.PartionCellName_14
        , tmpResult.PartionCellName_15
        , tmpResult.PartionCellName_16
        , tmpResult.PartionCellName_17
        , tmpResult.PartionCellName_18
        , tmpResult.PartionCellName_19
        , tmpResult.PartionCellName_20
        , tmpResult.PartionCellName_21
        , tmpResult.PartionCellName_22
        , tmpResult.PartionCellName_ets

        , (COALESCE (tmpResult.PartionCellName_1, '')  ||';'|| COALESCE (tmpResult.PartionCellName_2, '')  ||';'|| COALESCE (tmpResult.PartionCellName_3, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_4, '')  ||';'|| COALESCE (tmpResult.PartionCellName_5, '')  ||';'|| COALESCE (tmpResult.PartionCellName_6, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_7, '')  ||';'|| COALESCE (tmpResult.PartionCellName_8, '')  ||';'|| COALESCE (tmpResult.PartionCellName_9, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_10, '') ||';'|| COALESCE (tmpResult.PartionCellName_11, '') ||';'|| COALESCE (tmpResult.PartionCellName_12, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_13, '') ||';'|| COALESCE (tmpResult.PartionCellName_14, '') ||';'|| COALESCE (tmpResult.PartionCellName_15, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_16, '') ||';'|| COALESCE (tmpResult.PartionCellName_17, '') ||';'|| COALESCE (tmpResult.PartionCellName_18, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_19, '') ||';'|| COALESCE (tmpResult.PartionCellName_20, '') ||';'|| COALESCE (tmpResult.PartionCellName_21, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_22, '') ||';'|| COALESCE (tmpResult.PartionCellName_ets, '')
   ||';'|| REPLACE (
           COALESCE (tmpResult.PartionCellName_1, '')  ||';'|| COALESCE (tmpResult.PartionCellName_2, '')  ||';'|| COALESCE (tmpResult.PartionCellName_3, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_4, '')  ||';'|| COALESCE (tmpResult.PartionCellName_5, '')  ||';'|| COALESCE (tmpResult.PartionCellName_6, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_7, '')  ||';'|| COALESCE (tmpResult.PartionCellName_8, '')  ||';'|| COALESCE (tmpResult.PartionCellName_9, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_10, '') ||';'|| COALESCE (tmpResult.PartionCellName_11, '') ||';'|| COALESCE (tmpResult.PartionCellName_12, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_13, '') ||';'|| COALESCE (tmpResult.PartionCellName_14, '') ||';'|| COALESCE (tmpResult.PartionCellName_15, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_16, '') ||';'|| COALESCE (tmpResult.PartionCellName_17, '') ||';'|| COALESCE (tmpResult.PartionCellName_18, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_19, '') ||';'|| COALESCE (tmpResult.PartionCellName_20, '') ||';'|| COALESCE (tmpResult.PartionCellName_21, '')
   ||';'|| COALESCE (tmpResult.PartionCellName_22, '') ||';'|| COALESCE (tmpResult.PartionCellName_ets, '')
          , '-', '')
          ) :: TVarChar AS PartionCellName_srch

        , tmpResult.ColorFon_1
        , tmpResult.ColorFon_2
        , tmpResult.ColorFon_3
        , tmpResult.ColorFon_4
        , tmpResult.ColorFon_5
        , tmpResult.ColorFon_6
        , tmpResult.ColorFon_7
        , tmpResult.ColorFon_8
        , tmpResult.ColorFon_9
        , tmpResult.ColorFon_10
        , tmpResult.ColorFon_11
        , tmpResult.ColorFon_12
        , tmpResult.ColorFon_13
        , tmpResult.ColorFon_14
        , tmpResult.ColorFon_15
        , tmpResult.ColorFon_16
        , tmpResult.ColorFon_17
        , tmpResult.ColorFon_18
        , tmpResult.ColorFon_19
        , tmpResult.ColorFon_20
        , tmpResult.ColorFon_21
        , tmpResult.ColorFon_22

        , tmpResult.Color_1
        , tmpResult.Color_2
        , tmpResult.Color_3
        , tmpResult.Color_4
        , tmpResult.Color_5
        , tmpResult.Color_6
        , tmpResult.Color_7
        , tmpResult.Color_8
        , tmpResult.Color_9
        , tmpResult.Color_10
        , tmpResult.Color_11
        , tmpResult.Color_12
        , tmpResult.Color_13
        , tmpResult.Color_14
        , tmpResult.Color_15
        , tmpResult.Color_16
        , tmpResult.Color_17
        , tmpResult.Color_18
        , tmpResult.Color_19
        , tmpResult.Color_20
        , tmpResult.Color_21
        , tmpResult.Color_22

        , tmpResult.isClose_value_min
        , tmpResult.isPartionCell_max AS isPartionCell
        , tmpResult.isPartionCell_min AS isPartionCell_min

        , tmpResult.Amount, tmpResult.Amount_Weight

        , tmpResult.NormInDays
        , tmpResult.NormInDays_real
        , tmpResult.NormInDays_tax
        , tmpResult.NormInDays_date

          -- цвет для Партия дата
        , CASE WHEN tmpResult.PartionGoodsDate_real = zc_DateStart() THEN tmpResult.Color_PartionGoodsDate
               WHEN tmpResult.Color_PartionGoodsDate <> zc_Color_White()
                    -- если отличается от даты документа
                    THEN tmpResult.Color_PartionGoodsDate

               WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    -- если надо подсветить
                    THEN zc_Color_Yelow()

               ELSE tmpResult.Color_PartionGoodsDate

          END :: Integer AS Color_PartionGoodsDate

          -- цвет для Остаток в днях и Остаток в %
        , CASE WHEN tmpResult.PartionGoodsDate_real = zc_DateStart() THEN zc_Color_White()
               WHEN tmpResult.NormInDays_tax < 50
                    THEN zc_Color_Red()

               WHEN tmpResult.NormInDays_tax <= 70
                    THEN zc_Color_Orange() -- zc_Color_Aqua()

               WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    -- если надо подсветить
                    THEN zc_Color_Yelow()

               ELSE zc_Color_White()
          END :: Integer AS Color_NormInDays

        , CASE WHEN tmpResult.PartionGoodsDate_real = zc_DateStart() THEN 0
               WHEN tmpResult.NormInDays_tax < 50
                    THEN 2

               WHEN tmpResult.NormInDays_tax <= 70
                    THEN 1

               ELSE 0
          END :: Integer AS Marker_NormInDays


        , tmpResult.AmountRemains
        , tmpResult.AmountRemains_Weight

          -- № п/п для снятия
        , CASE WHEN tmpResult.isPartionCell_max = FALSE THEN NULL ELSE tmpResult.Ord END ::Integer AS Ord
          -- подсвечиваем строчку
        , CASE WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    THEN zc_Color_Yelow()
                    ELSE zc_Color_White()
          END ::Integer AS ColorFon_ord

          -- Место отбора
        , tmpChoiceCell.Code          ::Integer  AS NPP_ChoiceCell
        , tmpChoiceCell.Id            ::Integer  AS ChoiceCellId
        , tmpChoiceCell.Code          ::Integer  AS ChoiceCellCode
        , tmpChoiceCell.Name          ::TVarChar AS ChoiceCellName
        , tmpChoiceCell.CellName_shot ::TVarChar AS ChoiceCellName_shot

        , CASE WHEN tmpResult.isPartionCell_max = FALSE THEN FALSE WHEN tmpResult.Ord = 1 AND tmpChoiceCell_mi.GoodsId > 0 THEN TRUE ELSE FALSE END :: Boolean AS isChoiceCell_mi
        , CASE WHEN tmpResult.isPartionCell_max = FALSE THEN NULL  WHEN tmpResult.Ord = 1 THEN tmpChoiceCell_mi.PartionGoodsDate_next ELSE NULL END ::TDateTime AS PartionGoodsDate_next
        , tmpChoiceCell_mi.InsertDate_ChoiceCell_mi

        , FALSE :: Boolean AS isLock_record

   FROM tmpResult
        -- нашли Место отбора
        LEFT JOIN tmpChoiceCell ON tmpChoiceCell.GoodsId = tmpResult.GoodsId
                               AND COALESCE (tmpChoiceCell.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)
                               AND tmpChoiceCell.Ord = 1
        -- нашли партия - отмечена для снятия с хранения
        LEFT JOIN tmpChoiceCell_mi ON tmpChoiceCell_mi.GoodsId = tmpResult.GoodsId
                                  AND COALESCE (tmpChoiceCell_mi.GoodsKindId,0) = COALESCE (tmpResult.GoodsKindId,0)
                                  AND tmpChoiceCell.Ord = 1
        ;

    ELSE

     --
     --CREATE TEMP TABLE _tmpPartionCell (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;

     --
     OPEN curPartionCell FOR SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PartionCell() ORDER BY Object.Id;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curPartionCell INTO vbPartionCellId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;

          -- Только заполненные ячейки + отбор
          INSERT INTO _tmpPartionCell (MovementItemId, DescId, ObjectId)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
             -- Результат
             SELECT tmpMILO.MovementItemId, tmpMILO.DescId, tmpMILO.ObjectId
             FROM tmpMILO
             -- Только заполненные
             WHERE tmpMILO.ObjectId > 0
               AND tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
            ;
          --
          ANALYZE _tmpPartionCell;

     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMI_Date'))
     THEN
         DELETE FROM _tmpMI_Date;
     ELSE
         CREATE TEMP TABLE _tmpMI_Date (MovementItemId Integer, DescId Integer, ValueData TDateTime) ON COMMIT DROP;
    END IF;
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMILO_GoodsKind'))
     THEN
         DELETE FROM _tmpMILO_GoodsKind;
     ELSE
         CREATE TEMP TABLE _tmpMILO_GoodsKind (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;
    END IF;
    
    --
    INSERT INTO _tmpMI_Date (MovementItemId, DescId, ValueData)
       SELECT MD.MovementItemId, MD.DescId, MD.ValueData
       FROM MovementItemDate AS MD
       WHERE MD.MovementItemId IN (SELECT DISTINCT _tmpPartionCell.MovementItemId FROM _tmpPartionCell)
         AND MD.DescId = zc_MIDate_PartionGoods()
      ;
    --
    ANALYZE _tmpMI_Date;
    --
    INSERT INTO _tmpMILO_GoodsKind (MovementItemId, DescId, ObjectId)
       SELECT MILO.MovementItemId, MILO.DescId, MILO.ObjectId
       FROM MovementItemLinkObject AS MILO
       WHERE MILO.MovementItemId IN (SELECT DISTINCT _tmpPartionCell.MovementItemId FROM _tmpPartionCell)
         AND MILO.DescId = zc_MILinkObject_GoodsKind()
      ;
    ANALYZE _tmpMILO_GoodsKind;


     -- Результат
     RETURN QUERY
     WITH
       -- товары из 2-х групп
       tmpGoods AS (-- "ГП"
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1832) AS lfSelect
                   UNION
                    -- "ТУШЕНКА"
                    SELECT lfSelect.GoodsId
                    FROM lfSelect_Object_Goods_byGoodsGroup (1979) AS lfSelect
                   )

 , tmpRemains_all AS (SELECT Container.ObjectId                                                 AS GoodsId
                           , CASE WHEN CLO_GoodsKind.ObjectId = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (CLO_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                           , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart()) AS PartionGoodsDate
                           , MIN (COALESCE (ObjectLink_PartionCell.ChildObjectId, 0))           AS PartionCellId
                           , SUM (COALESCE (Container.Amount,0))                                AS Amount
                      FROM ContainerLinkObject AS CLO_Unit
                           INNER JOIN Container ON Container.Id = CLO_Unit.ContainerId AND Container.DescId = zc_Container_Count() AND Container.Amount <> 0
                           INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                           LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                         ON CLO_GoodsKind.ContainerId = CLO_Unit.ContainerId
                                                        AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                                      --AND CLO_GoodsKind.ObjectId    > 0
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ObjectId = Container.ObjectId
                                               AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                           LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_Destination
                                                ON ObjectLink_InfoMoney_Destination.ObjectId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                               AND ObjectLink_InfoMoney_Destination.DescId   = zc_ObjectLink_InfoMoney_InfoMoneyDestination()

                           LEFT JOIN ContainerLinkObject AS CLO_Account
                                                         ON CLO_Account.ContainerId = CLO_Unit.ContainerId
                                                        AND CLO_Account.DescId = zc_ContainerLinkObject_Account()
                           LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                         ON CLO_PartionGoods.ContainerId = CLO_Unit.ContainerId
                                                        AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                          -- LEFT JOIN Object AS Object_PartionGoods ON Object_PartionGoods.Id = CLO_PartionGoods.ObjectId


                            LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                 ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                AND ObjectDate_PartionGoods_Value.DescId = zc_ObjectDate_PartionGoods_Value()
                            LEFT JOIN ObjectLink AS ObjectLink_PartionCell
                                                 ON ObjectLink_PartionCell.ObjectId      = CLO_PartionGoods.ObjectId
                                                AND ObjectLink_PartionCell.DescId        = zc_ObjectLink_PartionGoods_PartionCell()

                      WHERE CLO_Unit.ObjectId = inUnitId
                        AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                        AND CLO_Account.ContainerId IS NULL -- !!!т.е. без счета Транзит!!!
                        -- Готовая продукция + Тушенка + Ирна
                        AND ObjectLink_InfoMoney_Destination.ChildObjectId IN (zc_Enum_InfoMoneyDestination_30100(), zc_Enum_InfoMoneyDestination_20900())
                      GROUP BY Container.ObjectId
                           , CASE WHEN CLO_GoodsKind.ObjectId = 0 THEN zc_GoodsKind_Basis() ELSE COALESCE (CLO_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END
                           , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateStart())
                      HAVING SUM (COALESCE (Container.Amount,0)) <> 0
                     )
, tmpRemains_plus AS (SELECT tmpRemains_all.GoodsId
                           , tmpRemains_all.GoodsKindId
                           , tmpRemains_all.PartionGoodsDate
                           , tmpRemains_all.PartionCellId
                           , tmpRemains_all.Amount
                             -- накопительно
                           , SUM (tmpRemains_all.Amount)  OVER (PARTITION BY tmpRemains_all.GoodsId, tmpRemains_all.GoodsKindId ORDER BY CASE WHEN tmpRemains_all.PartionCellId = zc_PartionCell_RK() THEN 0 ELSE 1 END ASC, tmpRemains_all.PartionGoodsDate ASC) AS Amount_sum
                      FROM tmpRemains_all
                      WHERE tmpRemains_all.Amount > 0
                     )
       --
     , tmpRemains AS (SELECT tmpRemains_plus.GoodsId
                           , tmpRemains_plus.GoodsKindId
                           , tmpRemains_plus.PartionGoodsDate
                             -- 
                           , CASE -- если минусов все еще больше
                                  WHEN tmpRemains_plus.Amount_sum <= COALESCE (tmpRemains_minus.Amount, 0)
                                       -- минусуем остаток полностью
                                       THEN 0
                                  -- если плюс уже больше
                                  WHEN tmpRemains_plus.Amount_sum - tmpRemains_plus.Amount >= COALESCE (tmpRemains_minus.Amount, 0)
                                       -- оставляем остаток полностью
                                       THEN tmpRemains_plus.Amount
                                  -- иначе разница
                                  ELSE tmpRemains_plus.Amount_sum - COALESCE (tmpRemains_minus.Amount, 0)

                             END AS Amount

                      FROM tmpRemains_plus
                           -- отрицательный остаток
                           LEFT JOIN (SELECT tmpRemains_all.GoodsId
                                           , tmpRemains_all.GoodsKindId
                                           , -1 * SUM (tmpRemains_all.Amount) AS Amount
                                      FROM tmpRemains_all
                                      WHERE tmpRemains_all.Amount < 0
                                      GROUP BY tmpRemains_all.GoodsId
                                             , tmpRemains_all.GoodsKindId
                                     ) AS tmpRemains_minus
                                       ON tmpRemains_minus.GoodsId     = tmpRemains_plus.GoodsId
                                      AND tmpRemains_minus.GoodsKindId = tmpRemains_plus.GoodsKindId
                      WHERE CASE WHEN tmpRemains_plus.Amount_sum <= COALESCE (tmpRemains_minus.Amount, 0)
                                      THEN 0
                                 WHEN tmpRemains_plus.Amount_sum - tmpRemains_plus.Amount >= COALESCE (tmpRemains_minus.Amount, 0)
                                      THEN tmpRemains_plus.Amount
                                 ELSE tmpRemains_plus.Amount_sum - COALESCE (tmpRemains_minus.Amount, 0)
                            END > 0
                     )


    , tmpNormInDays AS (SELECT Object_GoodsByGoodsKind_View.GoodsId, Object_GoodsByGoodsKind_View.GoodsKindId, Object_GoodsByGoodsKind_View.NormInDays
                        FROM Object_GoodsByGoodsKind_View
                             JOIN tmpGoods ON tmpGoods.GoodsId = Object_GoodsByGoodsKind_View.GoodsId
                        WHERE Object_GoodsByGoodsKind_View.NormInDays > 0
                       )
       -- Только заполненные ячейки + отбор
     , tmpMILO_PC AS (SELECT _tmpPartionCell.*
                      FROM _tmpPartionCell
                     )
      -- Только заполненные ячейки + отбор
    , tmpMILO_PC_count AS (SELECT _tmpPartionCell.MovementItemId
                                   -- для пропорционального деления веса
                                 , COUNT (*) AS CountCell
                           FROM _tmpPartionCell
                           GROUP BY _tmpPartionCell.MovementItemId
                          )
      -- Только заполненные ячейки + отбор
    , tmpMI AS (SELECT MovementItem.Id         AS MovementItemId
                     , MovementItem.MovementId AS MovementId
                     , MovementItem.ObjectId   AS GoodsId
                     , MovementItem.Amount     AS Amount
                FROM MovementItem
                WHERE MovementItem.Id IN (SELECT DISTINCT tmpMILO_PC.MovementItemId FROM tmpMILO_PC)
                  AND MovementItem.isErased = FALSE
                  AND MovementItem.DescId = zc_MI_Master()
                )

    , tmpMovement AS (SELECT Movement.*
                           , MovementLinkObject_From.ObjectId AS FromId
                           , MovementLinkObject_To.ObjectId   AS ToId
                      FROM Movement
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()

                      WHERE Movement.Id IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                        AND Movement.DescId = zc_Movement_Send()
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND MovementLinkObject_To.ObjectId = inUnitId
                      )


    , tmpMovementDate_Insert AS (SELECT MovementDate.*
                                 FROM MovementDate
                                 WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementDate.DescId = zc_MovementDate_Insert()
                                 )
    , tmpMLO_Insert AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          AND MovementLinkObject.DescId = zc_MovementLinkObject_Insert()
                        )

    , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                        FROM MovementItemBoolean
                        WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemBoolean.DescId IN (zc_MIBoolean_PartionCell_Close_1()
                                                           , zc_MIBoolean_PartionCell_Close_2()
                                                           , zc_MIBoolean_PartionCell_Close_3()
                                                           , zc_MIBoolean_PartionCell_Close_4()
                                                           , zc_MIBoolean_PartionCell_Close_5()
                                                           , zc_MIBoolean_PartionCell_Close_6()
                                                           , zc_MIBoolean_PartionCell_Close_7()
                                                           , zc_MIBoolean_PartionCell_Close_8()
                                                           , zc_MIBoolean_PartionCell_Close_9()
                                                           , zc_MIBoolean_PartionCell_Close_10()
                                                           , zc_MIBoolean_PartionCell_Close_11()
                                                           , zc_MIBoolean_PartionCell_Close_12()
                                                           , zc_MIBoolean_PartionCell_Close_13()
                                                           , zc_MIBoolean_PartionCell_Close_14()
                                                           , zc_MIBoolean_PartionCell_Close_15()
                                                           , zc_MIBoolean_PartionCell_Close_16()
                                                           , zc_MIBoolean_PartionCell_Close_17()
                                                           , zc_MIBoolean_PartionCell_Close_18()
                                                           , zc_MIBoolean_PartionCell_Close_19()
                                                           , zc_MIBoolean_PartionCell_Close_20()
                                                           , zc_MIBoolean_PartionCell_Close_21()
                                                           , zc_MIBoolean_PartionCell_Close_22()
                                                            )
                       )

     , tmpMILO_PartionCell AS (SELECT MovementItemLinkObject.*
                                      -- оригинал
                                    , CASE WHEN MIF_PartionCell_real.ValueData > 0 THEN MIF_PartionCell_real.ValueData ELSE NULL END :: Integer AS PartionCellId_real
                                      -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                                    , CASE WHEN tmpMI_Boolean.ValueData = TRUE THEN 0 ELSE 1 END AS isClose_value
                               FROM tmpMILO_PC AS MovementItemLinkObject
                                    LEFT JOIN tmpMI_Boolean ON tmpMI_Boolean.MovementItemId = MovementItemLinkObject.MovementItemId
                                                           AND tmpMI_Boolean.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_1()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_2()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_3()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_4()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_5()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_6()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_7()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_8()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_9()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_10()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_11()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_12()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_13()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_14()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_15()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_16()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_17()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_18()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_19()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_20()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_21()
                                                                                                   WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                        THEN zc_MIBoolean_PartionCell_Close_22()
                                                                                              END
                                    LEFT JOIN MovementItemFloat AS MIF_PartionCell_real
                                                                ON MIF_PartionCell_real.MovementItemId = MovementItemLinkObject.MovementItemId
                                                               AND MIF_PartionCell_real.DescId         = CASE WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_1()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_1()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_2()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_2()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_3()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_3()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_4()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_4()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_5()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_5()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_6()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_6()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_7()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_7()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_8()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_8()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_9()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_9()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_10()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_10()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_11()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_11()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_12()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_12()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_13()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_13()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_14()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_14()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_15()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_15()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_16()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_16()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_17()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_17()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_18()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_18()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_19()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_19()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_20()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_20()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_21()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_21()
                                                                                                              WHEN MovementItemLinkObject.DescId = zc_MILinkObject_PartionCell_22()
                                                                                                                   THEN zc_MIFloat_PartionCell_real_22()

                                                                                                         END
                              )
     /*, tmpMILO_GoodsKind AS (SELECT MovementItemLinkObject.*
                             FROM _tmpMILO_GoodsKind AS MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                               AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                             )
     , tmpMI_Date AS (SELECT *
                      FROM _tmpMI_Date AS MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                        AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                      )*/

       -- расчет кол-во - мастер
     , tmpData_MI AS (SELECT CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                           , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END               AS InvNumber
                           , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END              AS OperDate
                           , MAX (CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE THEN 1 ELSE 0 END) AS isRePack_Value
                           , MIN (Movement.OperDate)                                                         AS OperDate_min
                           , MAX (Movement.OperDate)                                                         AS OperDate_max
                           , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END                   AS FromId
                           , Movement.ToId                                                                   AS ToId              -- ***
                           , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                           , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                           , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                           , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                             -- кол-во
                           , SUM (MovementItem.Amount / CASE WHEN inIsCell = TRUE AND tmpMILO_PC_count.CountCell > 0 THEN tmpMILO_PC_count.CountCell ELSE 1 END) AS Amount

                             -- есть привязка или нет - !!!НЕ!!! выводится двумя строчками
                           , MIN (COALESCE (tmpMILO_PC_count.MovementItemId, 0)) AS isPartionCell_min
                           , MAX (COALESCE (tmpMILO_PC_count.MovementItemId, 0)) AS isPartionCell_max

                             -- если дата партии отличается от даты документа - выделить фон другим цветом
                           , MAX (CASE WHEN Movement.OperDate <> COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                       THEN 1
                                       ELSE 0
                                  END) AS isColor_PartionGoodsDate

                             --
                           , MAX (tmpMILO_PC_count.CountCell) AS CountCell

                             -- по ячейкам
                           , COALESCE (tmpMILO_PartionCell.ObjectId, 0) AS PartionCellId

                             -- есть MovementItem - все в отборе
                           , MAX (CASE WHEN _tmpPartionCell.MovementItemId > 0 THEN 0
                                       WHEN _tmpPartionCell_RK.MovementItemId > 0 THEN 1
                                       ELSE 0
                                  END) AS isPartionCell_RK_max

                             -- есть MovementItem - что-то в ячейке
                           , MIN (CASE WHEN _tmpPartionCell.MovementItemId > 0 THEN 0
                                       ELSE 1
                                  END) AS isPartionCell_RK_min

                      FROM tmpMovement AS Movement
                           INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
                           -- пропорционально - Только заполненные ячейки + отбор
                           LEFT JOIN tmpMILO_PC_count AS tmpMILO_PC_count ON tmpMILO_PC_count.MovementItemId = MovementItem.MovementItemId
                           -- по ячейкам
                           LEFT JOIN tmpMILO_PC AS tmpMILO_PartionCell ON tmpMILO_PartionCell.MovementItemId = MovementItem.MovementItemId
                                                                      AND inIsCell = TRUE
                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()

                           LEFT JOIN (SELECT DISTINCT _tmpPartionCell.MovementItemId FROM _tmpPartionCell
                                      -- Без отбор
                                      WHERE _tmpPartionCell.ObjectId <> zc_PartionCell_RK()
                                        AND _tmpPartionCell.ObjectId <> zc_PartionCell_Err()
                                     ) AS _tmpPartionCell
                                       ON _tmpPartionCell.MovementItemId = MovementItem.MovementItemId
                           LEFT JOIN (SELECT DISTINCT _tmpPartionCell.MovementItemId FROM _tmpPartionCell
                                      -- только отбор
                                      WHERE _tmpPartionCell.ObjectId IN (zc_PartionCell_RK()
                                                                       , zc_PartionCell_Err()
                                                                        )
                                     ) AS _tmpPartionCell_RK
                                       ON _tmpPartionCell_RK.MovementItemId = MovementItem.MovementItemId

                           LEFT JOIN _tmpMI_Date AS MIDate_PartionGoods
                                                 ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                                AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                           LEFT JOIN _tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                       AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                      GROUP BY CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.InvNumber ELSE '' END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.OperDate ELSE NULL END
                             , CASE WHEN inIsMovement = TRUE THEN Movement.FromId ELSE 0 END
                             , Movement.ToId
                             , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END
                             , MovementItem.GoodsId
                             , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                             , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)

                             , CASE WHEN tmpMILO_PC_count.MovementItemId > 0 THEN TRUE ELSE FALSE END
                             , COALESCE (tmpMILO_PartionCell.ObjectId, 0)
                     )

    -- Развернули по ячейкам - вертикально
  , tmpData_PartionCell_All_All AS (SELECT tmpData_list.MovementId        -- ***
                             , tmpData_list.ToId              -- ***
                             , tmpData_list.MovementItemId    -- ***
                             , tmpData_list.GoodsId           -- ***
                             , tmpData_list.GoodsKindId       -- ***
                             , tmpData_list.PartionGoodsDate  -- ***
                               -- группируется по ячейкам
                             , tmpData_list.DescId_milo
                             , tmpData_list.PartionCellId
                               -- информативно
                             , MAX (tmpData_list.PartionCellId_real) AS PartionCellId_real
                               -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                             , MAX (tmpData_list.isClose_value)                                        AS isClose_value_max
                               -- есть хоть одна закрытая ячейка
                             , MIN (tmpData_list.isClose_value)                                        AS isClose_value_min

                               -- № п/п - СКВОЗНОЙ - ВСЕ
                             , ROW_NUMBER() OVER (ORDER BY tmpData_list.GoodsId ASC) AS Ord_all

                        FROM -- Расчет нужной ячейки по которой группировать
                             (SELECT DISTINCT
                                     CASE WHEN inIsMovement = TRUE THEN Movement.Id ELSE 0 END                       AS MovementId        -- ***
                                   , Movement.ToId                                                                   AS ToId              -- ***
                                   , CASE WHEN inIsMovement = TRUE THEN MovementItem.MovementItemId ELSE 0 END       AS MovementItemId    -- ***
                                   , MovementItem.GoodsId                                                            AS GoodsId           -- ***
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId,0)                                    AS GoodsKindId       -- ***
                                   , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime        AS PartionGoodsDate  -- ***
                                     --
                                   , MILinkObject_PartionCell.DescId AS DescId_milo
                                     -- Расчет нужной ячейки по которой группировать
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN MILinkObject_PartionCell.ObjectId
                                          ELSE COALESCE (MILinkObject_PartionCell.PartionCellId_real, MILinkObject_PartionCell.ObjectId)
                                     END AS PartionCellId
                                     -- информативно
                                   , CASE WHEN inIsMovement = TRUE
                                          THEN COALESCE (MILinkObject_PartionCell.PartionCellId_real, 0)
                                          ELSE NULL
                                     END AS PartionCellId_real

                                     -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                                   , MILinkObject_PartionCell.isClose_value

                              FROM tmpMovement AS Movement
                                   INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

                                   LEFT JOIN _tmpMI_Date AS MIDate_PartionGoods
                                                         ON MIDate_PartionGoods.MovementItemId = MovementItem.MovementItemId
                                                        AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

                                   LEFT JOIN _tmpMILO_GoodsKind AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.MovementItemId
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   -- Только заполненные ячейки
                                   INNER JOIN tmpMILO_PartionCell AS MILinkObject_PartionCell
                                                                  ON MILinkObject_PartionCell.MovementItemId = MovementItem.MovementItemId

                             ) AS tmpData_list

                        GROUP BY tmpData_list.MovementId        -- ***
                               , tmpData_list.ToId              -- ***
                               , tmpData_list.MovementItemId    -- ***
                               , tmpData_list.GoodsId           -- ***
                               , tmpData_list.GoodsKindId       -- ***
                               , tmpData_list.PartionGoodsDate  -- ***
                                 -- группируется по ячейкам
                               , tmpData_list.DescId_milo
                               , tmpData_list.PartionCellId
                       )

    , tmpObjectFloat_Level AS (SELECT * FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionCell_Level() AND ObjectFloat.ValueData > 0)
      -- Только заполненные ячейки - № п/п
    , tmpData_PartionCell_All AS (SELECT tmpData_PartionCell_All_All.MovementId        -- ***
                           , tmpData_PartionCell_All_All.ToId              -- ***
                           , tmpData_PartionCell_All_All.MovementItemId    -- ***
                           , tmpData_PartionCell_All_All.GoodsId           -- ***
                           , tmpData_PartionCell_All_All.GoodsKindId       -- ***
                           , tmpData_PartionCell_All_All.PartionGoodsDate  -- ***

                           , tmpData_PartionCell_All_All.PartionCellId
                           , Object_PartionCell.ObjectCode AS PartionCellCode
                           , tmpData_PartionCell_All_All.PartionCellId_real
                           , COALESCE (Object_PartionCell_real.ValueData, Object_PartionCell.ValueData) AS PartionCellName_calc
                             -- если хоть одна партия в ячейке НЕ закрыта - все НЕ закрыты
                           , tmpData_PartionCell_All_All.isClose_value_max
                             -- есть хоть одна закрытая ячейка
                           , tmpData_PartionCell_All_All.isClose_value_min
                             --
                           , ROW_NUMBER() OVER (PARTITION BY tmpData_PartionCell_All_All.MovementId        -- ***
                                                           , tmpData_PartionCell_All_All.ToId              -- ***
                                                           , tmpData_PartionCell_All_All.MovementItemId    -- ***
                                                           , tmpData_PartionCell_All_All.GoodsId           -- ***
                                                           , tmpData_PartionCell_All_All.GoodsKindId       -- ***
                                                           , tmpData_PartionCell_All_All.PartionGoodsDate  -- ***
                                                           , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All_All.PartionCellId ELSE 0 END --если по ячейкам то все ячейки выводим отдельной строкой
                                                           , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All_All.Ord_all       ELSE 0 END

                                                ORDER BY -- CASE WHEN COALESCE (tmpData_PartionCell_All_All.PartionCellId, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err()) THEN 1 ELSE 0 END
                                                         COALESCE (tmpData_PartionCell_All_All.DescId_milo, 0)
                                                       , COALESCE (ObjectFloat_Level.ValueData, ObjectFloat_Level_2.ValueData, 0)
                                                       , COALESCE (Object_PartionCell_real.ObjectCode, Object_PartionCell.ObjectCode, 0)
                                               ) AS Ord
                      FROM tmpData_PartionCell_All_All
                           LEFT JOIN Object AS Object_PartionCell      ON Object_PartionCell.Id      = tmpData_PartionCell_All_All.PartionCellId
                           LEFT JOIN Object AS Object_PartionCell_real ON Object_PartionCell_real.Id = tmpData_PartionCell_All_All.PartionCellId_real
                           LEFT JOIN tmpObjectFloat_Level AS ObjectFloat_Level
                                                          ON ObjectFloat_Level.ObjectId = Object_PartionCell_real.Id
                                                         AND ObjectFloat_Level.DescId   = zc_ObjectFloat_PartionCell_Level()
                           LEFT JOIN tmpObjectFloat_Level AS ObjectFloat_Level_2
                                                          ON ObjectFloat_Level_2.ObjectId = Object_PartionCell.Id
                                                         AND ObjectFloat_Level_2.DescId   = zc_ObjectFloat_PartionCell_Level()
                                                         AND ObjectFloat_Level.ObjectId IS NULL
                     )
      -- Развернули по ячейкам - горизонтально
    , tmpData_PartionCell AS (SELECT tmpData_PartionCell_All.MovementId
                                   , tmpData_PartionCell_All.ToId
                                   , tmpData_PartionCell_All.MovementItemId
                                   , tmpData_PartionCell_All.GoodsId
                                   , tmpData_PartionCell_All.GoodsKindId
                                   , tmpData_PartionCell_All.PartionGoodsDate

                                   , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All.PartionCellId ELSE NULL END AS PartionCellId_num

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN tmpData_PartionCell_All.PartionCellId ELSE 0 END) AS PartionCellId_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN tmpData_PartionCell_All.PartionCellCode ELSE 0 END) AS PartionCellCode_22


                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 THEN zfCalc_PartionCell_IsClose (tmpData_PartionCell_All.PartionCellName_calc, tmpData_PartionCell_All.isClose_value_max = 0) ELSE '' END) AS PartionCellName_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_White() ELSE zc_Color_Cyan() END ELSE 0 END) AS ColorFon_22

                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 1  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_1
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 2  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_2
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 3  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_3
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 4  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_4
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 5  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_5
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 6  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_6
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 7  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_7
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 8  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_8
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 9  AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_9
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 10 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_10
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 11 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_11
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 12 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_12
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 13 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_13
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 14 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_14
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 15 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_15
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 16 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_16
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 17 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_17
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 18 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_18
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 19 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_19
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 20 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_20
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 21 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_21
                                   , MAX (CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) = 22 AND tmpData_PartionCell_All.PartionCellId > 0 THEN CASE WHEN tmpData_PartionCell_All.isClose_value_max = 0 THEN zc_Color_Cyan() ELSE zc_Color_Black() END ELSE 0 END) AS Color_22

                                     -- есть хоть одна закрытая ячейка
                                   , MIN (tmpData_PartionCell_All.isClose_value_min) AS isClose_value_min

                                   , STRING_AGG (DISTINCT CASE WHEN COALESCE (tmpData_PartionCell_All.Ord, 0) > 22  THEN tmpData_PartionCell_All.PartionCellName_calc ELSE '' END, ';') AS PartionCellName_ets

                              FROM tmpData_PartionCell_All

                              GROUP BY tmpData_PartionCell_All.MovementId
                                     , tmpData_PartionCell_All.ToId
                                     , tmpData_PartionCell_All.MovementItemId
                                     , tmpData_PartionCell_All.GoodsId
                                     , tmpData_PartionCell_All.GoodsKindId
                                     , tmpData_PartionCell_All.PartionGoodsDate
                                     , CASE WHEN inIsCell = TRUE THEN tmpData_PartionCell_All.PartionCellId ELSE NULL END
                              )
    -- Результат
    , tmpResult AS (
               SELECT tmpData_MI.MovementId
                    , tmpData_MI.InvNumber    :: TVarChar
                    , tmpData_MI.OperDate     :: TDateTime
                    , tmpData_MI.OperDate_min :: TDateTime
                    , tmpData_MI.OperDate_max :: TDateTime
                    , CASE WHEN tmpData_MI.isRePack_Value = 1 THEN TRUE ELSE FALSE END :: Boolean AS isRePack
                    , MovementDate_Insert.ValueData AS InsertDate
                    , Object_Insert.ValueData       AS InsertName
                    , Object_From.Id                AS FromId
                    , Object_From.ValueData         AS FromName
                    , Object_To.Id                  AS ToId
                    , Object_To.ValueData           AS ToName
                    , tmpData_MI.MovementItemId
                    , Object_Goods.Id                            AS GoodsId
                    , Object_Goods.ObjectCode                    AS GoodsCode
                    , Object_Goods.ValueData                     AS GoodsName
                    , ObjectString_Goods_GroupNameFull.ValueData AS GoodsGroupNameFull
                    , Object_GoodsGroup.ValueData                AS GoodsGroupName
                    , Object_Measure.ValueData                   AS MeasureName
                    , Object_GoodsKind.Id                        AS GoodsKindId
                    , Object_GoodsKind.ValueData                 AS GoodsKindName
                    , CASE WHEN COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) = zc_DateStart()
                                THEN NULL
                           ELSE COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate)
                      END :: TDateTime AS PartionGoodsDate

                    , tmpData_PartionCell.PartionCellId_num     :: Integer   AS PartionCellId_num
                    , tmpData_MI.CountCell

                      --
                    , tmpData_PartionCell.PartionCellId_1  :: Integer
                    , tmpData_PartionCell.PartionCellId_2  :: Integer
                    , tmpData_PartionCell.PartionCellId_3  :: Integer
                    , tmpData_PartionCell.PartionCellId_4  :: Integer
                    , tmpData_PartionCell.PartionCellId_5  :: Integer
                    , tmpData_PartionCell.PartionCellId_6  :: Integer
                    , tmpData_PartionCell.PartionCellId_7  :: Integer
                    , tmpData_PartionCell.PartionCellId_8  :: Integer
                    , tmpData_PartionCell.PartionCellId_9  :: Integer
                    , tmpData_PartionCell.PartionCellId_10 :: Integer
                    , tmpData_PartionCell.PartionCellId_11 :: Integer
                    , tmpData_PartionCell.PartionCellId_12 :: Integer
                    , tmpData_PartionCell.PartionCellId_13 :: Integer
                    , tmpData_PartionCell.PartionCellId_14 :: Integer
                    , tmpData_PartionCell.PartionCellId_15 :: Integer
                    , tmpData_PartionCell.PartionCellId_16 :: Integer
                    , tmpData_PartionCell.PartionCellId_17 :: Integer
                    , tmpData_PartionCell.PartionCellId_18 :: Integer
                    , tmpData_PartionCell.PartionCellId_19 :: Integer
                    , tmpData_PartionCell.PartionCellId_20 :: Integer
                    , tmpData_PartionCell.PartionCellId_21 :: Integer
                    , tmpData_PartionCell.PartionCellId_22 :: Integer

                    , tmpData_PartionCell.PartionCellCode_1  :: Integer
                    , tmpData_PartionCell.PartionCellCode_2  :: Integer
                    , tmpData_PartionCell.PartionCellCode_3  :: Integer
                    , tmpData_PartionCell.PartionCellCode_4  :: Integer
                    , tmpData_PartionCell.PartionCellCode_5  :: Integer
                    , tmpData_PartionCell.PartionCellCode_6  :: Integer
                    , tmpData_PartionCell.PartionCellCode_7  :: Integer
                    , tmpData_PartionCell.PartionCellCode_8  :: Integer
                    , tmpData_PartionCell.PartionCellCode_9  :: Integer
                    , tmpData_PartionCell.PartionCellCode_10 :: Integer
                    , tmpData_PartionCell.PartionCellCode_11 :: Integer
                    , tmpData_PartionCell.PartionCellCode_12 :: Integer
                    , tmpData_PartionCell.PartionCellCode_13 :: Integer
                    , tmpData_PartionCell.PartionCellCode_14 :: Integer
                    , tmpData_PartionCell.PartionCellCode_15 :: Integer
                    , tmpData_PartionCell.PartionCellCode_16 :: Integer
                    , tmpData_PartionCell.PartionCellCode_17 :: Integer
                    , tmpData_PartionCell.PartionCellCode_18 :: Integer
                    , tmpData_PartionCell.PartionCellCode_19 :: Integer
                    , tmpData_PartionCell.PartionCellCode_20 :: Integer
                    , tmpData_PartionCell.PartionCellCode_21 :: Integer
                    , tmpData_PartionCell.PartionCellCode_22 :: Integer

                    , tmpData_PartionCell.PartionCellName_1        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_2        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_3        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_4        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_5        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_6        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_7        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_8        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_9        :: TVarChar
                    , tmpData_PartionCell.PartionCellName_10       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_11       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_12       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_13       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_14       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_15       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_16       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_17       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_18       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_19       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_20       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_21       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_22       :: TVarChar
                    , tmpData_PartionCell.PartionCellName_ets       :: TVarChar

                    , '' :: TVarChar AS PartionCellName_srch

                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_1,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_1  END :: Integer  AS ColorFon_1
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_2,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_2  END :: Integer  AS ColorFon_2
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_3,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_3  END :: Integer  AS ColorFon_3
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_4,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_4  END :: Integer  AS ColorFon_4
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_5,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_5  END :: Integer  AS ColorFon_5
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_6,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_6  END :: Integer  AS ColorFon_6
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_7,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_7  END :: Integer  AS ColorFon_7
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_8,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_8  END :: Integer  AS ColorFon_8
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_9,  0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_9  END :: Integer  AS ColorFon_9
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_10, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_10 END :: Integer  AS ColorFon_10
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_11, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_11  END :: Integer AS ColorFon_11
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_12, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_12  END :: Integer AS ColorFon_12
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_13, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_13  END :: Integer AS ColorFon_13
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_14, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_14  END :: Integer AS ColorFon_14
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_15, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_15  END :: Integer AS ColorFon_15
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_16, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_16  END :: Integer AS ColorFon_16
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_17, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_17  END :: Integer AS ColorFon_17
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_18, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_18  END :: Integer AS ColorFon_18
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_19, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_19  END :: Integer AS ColorFon_19
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_20  END :: Integer AS ColorFon_20
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_21  END :: Integer AS ColorFon_21
                    , CASE WHEN COALESCE (tmpData_PartionCell.ColorFon_20, 0) = 0 THEN zc_Color_White() ELSE tmpData_PartionCell.ColorFon_22  END :: Integer AS ColorFon_22

                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_1,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_1  END :: Integer  AS Color_1
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_2,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_2  END :: Integer  AS Color_2
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_3,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_3  END :: Integer  AS Color_3
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_4,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_4  END :: Integer  AS Color_4
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_5,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_5  END :: Integer  AS Color_5
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_6,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_6  END :: Integer  AS Color_6
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_7,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_7  END :: Integer  AS Color_7
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_8,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_8  END :: Integer  AS Color_8
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_9,  0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_9  END :: Integer  AS Color_9
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_10, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_10 END :: Integer  AS Color_10
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_11, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_11 END :: Integer  AS Color_11
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_12, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_12 END :: Integer  AS Color_12
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_13, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_13 END :: Integer  AS Color_13
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_14, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_14 END :: Integer  AS Color_14
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_15, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_15 END :: Integer  AS Color_15
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_16, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_16 END :: Integer  AS Color_16
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_17, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_17 END :: Integer  AS Color_17
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_18, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_18 END :: Integer  AS Color_18
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_19, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_19 END :: Integer  AS Color_19
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_20, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_20 END :: Integer  AS Color_20
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_21, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_21 END :: Integer  AS Color_21
                    , CASE WHEN COALESCE (tmpData_PartionCell.Color_22, 0) = 0 THEN zc_Color_Black() ELSE tmpData_PartionCell.Color_22 END :: Integer  AS Color_22

                      -- есть хоть одна закрытая ячейка
                    , CASE WHEN tmpData_MI.isPartionCell_max > 0 AND tmpData_PartionCell.isClose_value_min = 0 THEN TRUE ELSE FALSE END :: Boolean AS isClose_value_min
                      -- Сформированы данные по ячейкам (да/нет)
                    , CASE WHEN COALESCE (tmpData_MI.isPartionCell_min, 0) = 0 THEN TRUE ELSE FALSE END :: Boolean  AS isPartionCell_min
                    , CASE WHEN COALESCE (tmpData_MI.isPartionCell_max, 0) > 0 THEN TRUE ELSE FALSE END :: Boolean  AS isPartionCell_max

                      -- Кол-во - пропорционально
                    , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN tmpData_MI.Amount ELSE 0 END ::TFloat AS Amount
                      -- Вес - пропорционально
                    , (tmpData_MI.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight

                      -- Срок хранения в днях
                    , tmpNormInDays.NormInDays                   :: Integer AS NormInDays

                      -- Расчет остатка в днях для Срока хранения
                    , CASE WHEN CURRENT_DATE < COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                                THEN EXTRACT (DAY FROM (COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                           ELSE 0
                      END :: Integer AS NormInDays_real

                      -- Расчет остатка дней в % для Срока хранения
                    , CASE WHEN tmpNormInDays.NormInDays > 0
                           THEN CAST (100 * CASE WHEN CURRENT_DATE < COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                                                      THEN EXTRACT (DAY FROM (COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL) - CURRENT_DATE)
                                                 ELSE 0
                                            END
                                    / tmpNormInDays.NormInDays AS NUMERIC (16, 1))
                           ELSE 0
                      END :: TFloat AS NormInDays_tax

                      -- Срок хранения, дата
                    , CASE WHEN COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) > zc_DateStart()
                               THEN COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate) + ((tmpNormInDays.NormInDays :: Integer) :: TVarChar || 'DAY') :: INTERVAL
                      END :: TDateTime AS NormInDays_date

                      -- цвет для Партия дата
                    , CASE WHEN tmpData_MI.isColor_PartionGoodsDate = 1
                                THEN 8435455
                                ELSE zc_Color_White()
                      END ::Integer AS Color_PartionGoodsDate

                    , CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (tmpRemains.Amount,0) ELSE 0 END ::TFloat AS AmountRemains
                    , (COALESCE (tmpRemains.Amount,0) * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS AmountRemains_Weight

                      -- № п/п
                    , ROW_NUMBER() OVER (PARTITION BY Object_Goods.Id, Object_GoodsKind.Id ORDER BY CASE WHEN COALESCE (tmpData_PartionCell.PartionCellId_1, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_2, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_3, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_4, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_5, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_6, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_7, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_8, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_9, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_10, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_11, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_12, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_13, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_14, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_15, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_16, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_17, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_18, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_19, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_20, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_21, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                          AND COALESCE (tmpData_PartionCell.PartionCellId_22, 0) IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                                                                                         THEN 999
                                                                                                         ELSE 1
                                                                                                    END
                                                                                                  , CASE WHEN tmpData_MI.isPartionCell_max > 0 THEN 999 ELSE 1 END
                                                                                                  , COALESCE (tmpData_MI.PartionGoodsDate, tmpRemains.PartionGoodsDate, zc_DateStart()) ASC
                                        ) :: Integer AS Ord

             FROM tmpData_MI -- расчет кол-во - мастер
                  FULL JOIN tmpRemains ON tmpRemains.GoodsId          = tmpData_MI.GoodsId
                                      AND tmpRemains.GoodsKindId      = tmpData_MI.GoodsKindId
                                      AND tmpRemains.PartionGoodsDate = tmpData_MI.PartionGoodsDate

                  LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData_MI.FromId
                  LEFT JOIN Object AS Object_To   ON Object_To.Id   = tmpData_MI.ToId

                  LEFT JOIN tmpMovementDate_Insert AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = tmpData_MI.MovementId
                                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                  LEFT JOIN tmpMLO_Insert AS MLO_Insert
                                          ON MLO_Insert.MovementId = tmpData_MI.MovementId
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                  LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                  LEFT JOIN Object AS Object_Goods         ON Object_Goods.Id         = COALESCE (tmpData_MI.GoodsId, tmpRemains.GoodsId)
                  LEFT JOIN Object AS Object_GoodsKind     ON Object_GoodsKind.Id     = COALESCE (tmpData_MI.GoodsKindId, tmpRemains.GoodsKindId)
                  LEFT JOIN tmpNormInDays ON tmpNormInDays.GoodsId     = COALESCE (tmpData_MI.GoodsId, tmpRemains.GoodsId)
                                         AND tmpNormInDays.GoodsKindId = COALESCE (tmpData_MI.GoodsKindId,tmpRemains.GoodsKindId)

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                       ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                  LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                       ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_GoodsGroup.DescId   = zc_ObjectLink_Goods_GoodsGroup()
                  LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                  LEFT JOIN ObjectString AS ObjectString_Goods_GroupNameFull
                                         ON ObjectString_Goods_GroupNameFull.ObjectId = Object_Goods.Id
                                        AND ObjectString_Goods_GroupNameFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                  LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                        ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                       AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                  -- Данные по ячейкам - горизонтально
                  LEFT JOIN tmpData_PartionCell ON tmpData_PartionCell.MovementId       = tmpData_MI.MovementId       -- ***
                                               AND tmpData_PartionCell.ToId             = tmpData_MI.ToId             -- ***
                                               AND tmpData_PartionCell.MovementItemId   = tmpData_MI.MovementItemId   -- ***
                                               AND tmpData_PartionCell.GoodsId          = tmpData_MI.GoodsId          -- ***
                                               AND tmpData_PartionCell.GoodsKindId      = tmpData_MI.GoodsKindId      -- ***
                                               AND tmpData_PartionCell.PartionGoodsDate = tmpData_MI.PartionGoodsDate -- ***
                                               -- !!!Сформированы данные по ячейкам!!!
                                               AND tmpData_MI.isPartionCell_max > 0
                                             --  AND vbUserId <> 5
                                               AND (tmpData_PartionCell.PartionCellId_num  = tmpData_MI.PartionCellId -- ***
                                                 OR tmpData_MI.PartionCellId = 0
                                                 OR inIsCell = FALSE
                                                   )
            WHERE COALESCE (tmpRemains.Amount, 0) <> 0
              -- есть MovementItem - все в отборе
              OR COALESCE (tmpData_MI.isPartionCell_RK_max, 0) = 0
              -- есть MovementItem - что-то в ячейке
              OR COALESCE (tmpData_MI.isPartionCell_RK_min, 0) = 0
           )

   --
   SELECT tmpResult.MovementId
        , tmpResult.InvNumber
        , tmpResult.OperDate
        , tmpResult.OperDate_min
        , tmpResult.OperDate_max
        , '' :: TVarChar AS ItemName
        , tmpResult.isRePack
        , tmpResult.InsertDate
        , tmpResult.InsertName
        , tmpResult.FromId
        , tmpResult.FromName
        , tmpResult.ToId
        , tmpResult.ToName

        , tmpResult.MovementItemId
        , tmpResult.GoodsId , tmpResult.GoodsCode , tmpResult.GoodsName
        , tmpResult.GoodsGroupNameFull, tmpResult.GoodsGroupName, tmpResult.MeasureName
        , tmpResult.GoodsKindId , tmpResult.GoodsKindName
        , tmpResult.PartionGoodsDate
        , tmpResult.PartionGoodsDate AS PartionGoodsDate_real_real
          --
        , CASE WHEN inIsCell = TRUE THEN -1 ELSE 0 END :: Integer AS DescId_milo_num
          -- 23
        , 0 :: Integer AS PartionCellId_num

        , tmpResult.PartionCellId_1
        , tmpResult.PartionCellId_2
        , tmpResult.PartionCellId_3
        , tmpResult.PartionCellId_4
        , tmpResult.PartionCellId_5
        , tmpResult.PartionCellId_6
        , tmpResult.PartionCellId_7
        , tmpResult.PartionCellId_8
        , tmpResult.PartionCellId_9
        , tmpResult.PartionCellId_10
        , tmpResult.PartionCellId_11
        , tmpResult.PartionCellId_12
        , tmpResult.PartionCellId_13
        , tmpResult.PartionCellId_14
        , tmpResult.PartionCellId_15
        , tmpResult.PartionCellId_16
        , tmpResult.PartionCellId_17
        , tmpResult.PartionCellId_18
        , tmpResult.PartionCellId_19
        , tmpResult.PartionCellId_20
        , tmpResult.PartionCellId_21
        , tmpResult.PartionCellId_22

        , tmpResult.PartionCellCode_1
        , tmpResult.PartionCellCode_2
        , tmpResult.PartionCellCode_3
        , tmpResult.PartionCellCode_4
        , tmpResult.PartionCellCode_5
        , tmpResult.PartionCellCode_6
        , tmpResult.PartionCellCode_7
        , tmpResult.PartionCellCode_8
        , tmpResult.PartionCellCode_9
        , tmpResult.PartionCellCode_10
        , tmpResult.PartionCellCode_11
        , tmpResult.PartionCellCode_12
        , tmpResult.PartionCellCode_13
        , tmpResult.PartionCellCode_14
        , tmpResult.PartionCellCode_15
        , tmpResult.PartionCellCode_16
        , tmpResult.PartionCellCode_17
        , tmpResult.PartionCellCode_18
        , tmpResult.PartionCellCode_19
        , tmpResult.PartionCellCode_20
        , tmpResult.PartionCellCode_21
        , tmpResult.PartionCellCode_22

        , tmpResult.PartionCellName_1
        , tmpResult.PartionCellName_2
        , tmpResult.PartionCellName_3
        , tmpResult.PartionCellName_4
        , tmpResult.PartionCellName_5
        , tmpResult.PartionCellName_6
        , tmpResult.PartionCellName_7
        , tmpResult.PartionCellName_8
        , tmpResult.PartionCellName_9
        , tmpResult.PartionCellName_10
        , tmpResult.PartionCellName_11
        , tmpResult.PartionCellName_12
        , tmpResult.PartionCellName_13
        , tmpResult.PartionCellName_14
        , tmpResult.PartionCellName_15
        , tmpResult.PartionCellName_16
        , tmpResult.PartionCellName_17
        , tmpResult.PartionCellName_18
        , tmpResult.PartionCellName_19
        , tmpResult.PartionCellName_20
        , tmpResult.PartionCellName_21
        , tmpResult.PartionCellName_22
        , tmpResult.PartionCellName_ets

        , '' :: TVarChar AS PartionCellName_srch

        , tmpResult.ColorFon_1
        , tmpResult.ColorFon_2
        , tmpResult.ColorFon_3
        , tmpResult.ColorFon_4
        , tmpResult.ColorFon_5
        , tmpResult.ColorFon_6
        , tmpResult.ColorFon_7
        , tmpResult.ColorFon_8
        , tmpResult.ColorFon_9
        , tmpResult.ColorFon_10
        , tmpResult.ColorFon_11
        , tmpResult.ColorFon_12
        , tmpResult.ColorFon_13
        , tmpResult.ColorFon_14
        , tmpResult.ColorFon_15
        , tmpResult.ColorFon_16
        , tmpResult.ColorFon_17
        , tmpResult.ColorFon_18
        , tmpResult.ColorFon_19
        , tmpResult.ColorFon_20
        , tmpResult.ColorFon_21
        , tmpResult.ColorFon_22

        , tmpResult.Color_1
        , tmpResult.Color_2
        , tmpResult.Color_3
        , tmpResult.Color_4
        , tmpResult.Color_5
        , tmpResult.Color_6
        , tmpResult.Color_7
        , tmpResult.Color_8
        , tmpResult.Color_9
        , tmpResult.Color_10
        , tmpResult.Color_11
        , tmpResult.Color_12
        , tmpResult.Color_13
        , tmpResult.Color_14
        , tmpResult.Color_15
        , tmpResult.Color_16
        , tmpResult.Color_17
        , tmpResult.Color_18
        , tmpResult.Color_19
        , tmpResult.Color_20
        , tmpResult.Color_21
        , tmpResult.Color_22

        , tmpResult.isClose_value_min
        , tmpResult.isPartionCell_max :: Boolean AS isPartionCell
        , tmpResult.isPartionCell_min :: Boolean AS isPartionCell_min

        , tmpResult.Amount, tmpResult.Amount_Weight

        , tmpResult.NormInDays
        , tmpResult.NormInDays_real
        , tmpResult.NormInDays_tax
        , tmpResult.NormInDays_date

          -- цвет для Партия дата
        , CASE WHEN tmpResult.Color_PartionGoodsDate <> zc_Color_White()
                    THEN tmpResult.Color_PartionGoodsDate
               WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    THEN zc_Color_Yelow()
               ELSE tmpResult.Color_PartionGoodsDate
          END :: Integer AS Color_PartionGoodsDate

          -- цвет для Остаток в днях и Остаток в %
        , CASE WHEN tmpResult.NormInDays_tax < 50
                AND tmpResult.PartionGoodsDate > zc_DateStart()
                    THEN zc_Color_Red()

               WHEN tmpResult.NormInDays_tax <= 70
                AND tmpResult.PartionGoodsDate > zc_DateStart()
                    THEN zc_Color_Orange() -- zc_Color_Aqua()

                    -- если надо подсветить
               WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
              --AND tmpResult.PartionGoodsDate > zc_DateStart()
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    THEN zc_Color_Yelow()

               ELSE zc_Color_White()
          END :: Integer AS Color_NormInDays

        , CASE WHEN tmpResult.NormInDays_tax < 50
                AND tmpResult.PartionGoodsDate > zc_DateStart()
                    THEN 2

               WHEN tmpResult.NormInDays_tax <= 70
                AND tmpResult.PartionGoodsDate > zc_DateStart()
                    THEN 1

               ELSE 0
          END :: Integer AS Marker_NormInDays

        , tmpResult.AmountRemains
        , tmpResult.AmountRemains_Weight

        , CASE WHEN tmpResult.isPartionCell_max = FALSE THEN NULL ELSE tmpResult.Ord END ::Integer AS Ord

        , CASE WHEN tmpResult.isPartionCell_max = TRUE AND tmpResult.Ord = 1
                AND (tmpResult.PartionCellId_1  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_2  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_3  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_4  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_5  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_6  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_7  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_8  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_9  NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_10 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_11 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_12 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_13 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_14 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_15 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_16 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_17 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_18 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_19 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_20 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_21 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                  OR tmpResult.PartionCellId_22 NOT IN (zc_PartionCell_RK(), zc_PartionCell_Err())
                    )
                    THEN zc_Color_Yelow()
                    ELSE zc_Color_White()
          END ::Integer AS ColorFon_ord

        --ячейки отбора
        , 0     ::Integer  AS NPP_ChoiceCell 
        , 0     ::Integer  AS ChoiceCellId
        , NULL  ::Integer  AS ChoiceCellCode
        , NULL  ::TVarChar AS ChoiceCellName
        , NULL  ::TVarChar AS ChoiceCellName_shot

        , isChoiceCell_mi :: Boolean   AS isChoiceCell_mi
        , NULL            :: TDateTime AS PartionGoodsDate_next
        , NULL            :: TDateTime AS InsertDate_ChoiceCell_mi

        , FALSE :: Boolean AS isLock_record

   FROM tmpResult
  ;

    END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.07.24         *
 28.06.24
 04.01.24         *
*/

-- тест
-- SELECT * FROM gpReport_Send_PartionCell (inStartDate:= '04.02.2024', inEndDate:= '04.02.2024', inUnitId:= 8451, inIsMovement:= false, inIsShowAll := true, inSession:= zfCalc_UserAdmin()); -- Склад Реализации
/*
zc_ObjectFloat_StickerProperty_Value5 -  кількість діб
zc_ObjectFloat_StickerProperty_Value10 - кількість діб - второй срок

zc_ObjectFloat_GoodsByGoodsKind_NormInDays -  срок годности в днях

zc_ObjectFloat_OrderType_TermProduction

*/

-- SELECT * FROM gpReport_Send_PartionCell (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE, inUnitId:= 8459, inIsMovement:= FALSE, inIsCell:= FALSE, inIsShowAll:= FALSE, inSession := '9457') --where GoodsCode = 41;
