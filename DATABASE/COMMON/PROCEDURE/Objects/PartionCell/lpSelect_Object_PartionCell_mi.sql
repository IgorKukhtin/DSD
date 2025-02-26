-- Function: lpSelect_Object_PartionCell_mi()

DROP FUNCTION IF EXISTS lpSelect_Object_PartionCell_mi (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_PartionCell_mi(
    IN inGoodsId     Integer,
    IN inGoodsKindId Integer
)
RETURNS TABLE (MovementId     Integer
             , MovementDescId Integer
             , OperDate       TDateTime

             , PartionCellId   Integer
             , PartionCellCode Integer
             , PartionCellName TVarChar

             , MovementItemId   Integer
             , GoodsId          Integer
             , GoodsKindId      Integer
             , Amount           TFloat
             , PartionGoodsDate TDateTime
              )
AS
$BODY$
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
BEGIN

     -- ВСЕ заполненные места хранения - ячейки + ячейка "Отбор"
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpPartionCell_mi')
     THEN
         DELETE FROM _tmpPartionCell_mi;
     ELSE
         CREATE TEMP TABLE _tmpPartionCell_mi (MovementId Integer, MovementDescId Integer, OperDate TDateTime
                                             , PartionCellId Integer
                                             , MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, Amount TFloat, PartionGoodsDate TDateTime
                                              ) ON COMMIT DROP;
     END IF;


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

          -- ВСЕ заполненные места хранения - ячейки + ячейка "Отбор"
             WITH -- нашли где заполнена одна ячейка
                  tmpMILO AS (SELECT MovementItem.*
                                   , MILO.ObjectId AS PartionCellId
                              FROM MovementItemLinkObject AS MILO
                                   INNER JOIN MovementItem ON MovementItem.Id       = MILO.MovementItemId
                                                          AND MovementItem.isErased = FALSE
                                                          -- для этого товара
                                                          AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                              WHERE MILO.ObjectId = vbPartionCellId
                                AND MILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
                             )
                  -- нашли MovementItem
                , tmpMI AS (SELECT DISTINCT
                                   MovementItem.PartionCellId AS PartionCellId
                                 , Movement.DescId            AS MovementDescId
                                 , Movement.OperDate          AS OperDate
                                 , MovementItem.Id            AS MovementItemId
                                 , MovementItem.MovementId    AS MovementId
                                 , MovementItem.ObjectId      AS GoodsId
                                 , MovementItem.Amount        AS Amount
                                 , COALESCE (MILO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                 , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate
                            FROM tmpMILO AS MovementItem
                                 INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                    AND ((Movement.DescId = zc_Movement_Send()
                                                          -- ВСЕ статусы?
                                                          --AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                         )
                                                      OR (Movement.DescId = zc_Movement_WeighingProduction()
                                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                                         )
                                                        )
                                 -- RK
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                 -- ПЕРЕПАК
                                 LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                           ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                          AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
                                                          AND MovementBoolean_isRePack.ValueData  = TRUE
                                 LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                  ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                 LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                            ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                           AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                            -- Только заполненные
                            WHERE MovementItem.PartionCellId > 0
                              -- без ПЕРЕПАК
                              AND MovementBoolean_isRePack.MovementId IS NULL
                              -- для этого Вида товара
                              AND (COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId OR inGoodsKindId = 0)
                           )
        -- ВСЕ заполненные места хранения - ячейки + ячейка "Отбор"
        INSERT INTO _tmpPartionCell_mi (MovementId, MovementDescId, OperDate, PartionCellId, MovementItemId, GoodsId, GoodsKindId, Amount, PartionGoodsDate)
          -- Результат
          SELECT tmpMI.MovementId, tmpMI.MovementDescId, tmpMI.OperDate, tmpMI.PartionCellId, tmpMI.MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Amount, tmpMI.PartionGoodsDate
          FROM tmpMI
          -- партия = ячейке Хранения
          WHERE tmpMI.PartionCellId <> zc_PartionCell_RK()

         UNION
          SELECT tmpMI.MovementId, tmpMI.MovementDescId, tmpMI.OperDate, tmpMI.PartionCellId, tmpMI.MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Amount, tmpMI.PartionGoodsDate
          FROM (SELECT tmpMI.MovementId, tmpMI.MovementDescId, tmpMI.OperDate, tmpMI.PartionCellId, tmpMI.MovementItemId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.Amount, tmpMI.PartionGoodsDate
                       -- № п/п
                     , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                FROM tmpMI
                -- партия = ячейка Отбор
                WHERE tmpMI.PartionCellId = zc_PartionCell_RK()
               ) AS tmpMI
          WHERE tmpMI.Ord = 1
         ;
          --
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


     RETURN QUERY
       SELECT
              _tmpPartionCell_mi.MovementId
            , _tmpPartionCell_mi.MovementDescId
            , _tmpPartionCell_mi.OperDate

            , Object_PartionCell.Id         AS PartionCellId
            , Object_PartionCell.ObjectCode AS PartionCellCode
            , Object_PartionCell.ValueData  AS PartionCellName

            , _tmpPartionCell_mi.MovementItemId
            , _tmpPartionCell_mi.GoodsId
            , _tmpPartionCell_mi.GoodsKindId
            , _tmpPartionCell_mi.Amount
            , _tmpPartionCell_mi.PartionGoodsDate
       FROM _tmpPartionCell_mi
            LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = _tmpPartionCell_mi.PartionCellId
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.08.24                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Object_PartionCell_mi (inGoodsId:= 2160, inGoodsKindId:= 0)
