-- Function: gpSelect_Object_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_Object_PartionCellChoice (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_PartionCellChoice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartionCellChoice(
    IN inIsShowFree         Boolean   ,
    IN inSession            TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, Name_search TVarChar
             , Status TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , BoxCount TFloat
             , MovementId Integer
             , OperDate TDateTime
             , InvNumber TVarChar
             , Amount TFloat
             , isPartionCell_check Boolean
             , ColorFon Integer
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());
     vbUserId:= lpGetUserBySession (inSession);


     -- ВСЕ заполненные места хранения - ячейки + отбор
     CREATE TEMP TABLE _tmpPartionCell_mi (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;

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

          --
          INSERT INTO _tmpPartionCell_mi (MovementItemId, DescId, ObjectId)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
             -- Результат
             SELECT tmpMILO.MovementItemId, tmpMILO.DescId, tmpMILO.ObjectId
             FROM tmpMILO
             WHERE tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


      RETURN QUERY
      WITH
      tmpPartionCell AS (SELECT
                               Object.Id         AS Id
                             , Object.ObjectCode AS Code
                             , Object.ValueData  AS Name
                             , (Object.ValueData ||';'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
                         FROM Object
                         WHERE Object.DescId = zc_Object_PartionCell()
                           AND Object.isErased = FALSE
                         )
       -- занятые ячейки - показать да/нет
     , tmpMILO_PartionCell_all_1 AS (SELECT _tmpPartionCell_mi.ObjectId AS PartionCellId, MAX (_tmpPartionCell_mi.MovementItemId) AS MovementItemId_max, MIN (_tmpPartionCell_mi.MovementItemId) AS MovementItemId_min
                                     FROM tmpPartionCell
                                          INNER JOIN _tmpPartionCell_mi ON _tmpPartionCell_mi.ObjectId = tmpPartionCell.Id
                                          INNER JOIN MovementItem ON MovementItem.Id = _tmpPartionCell_mi.MovementItemId
                                                                 AND MovementItem.isErased = FALSE
                                          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                          -- RK
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                     WHERE inIsShowFree = FALSE
                                        AND (Movement.DescId = zc_Movement_Send()
                                          OR (Movement.DescId   = zc_Movement_WeighingProduction()
                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             )
                                            )
                                     GROUP BY _tmpPartionCell_mi.ObjectId
                                    )
       -- занятые ячейки - показать MovementItem
     , tmpMILO_PartionCell_all_2 AS (SELECT _tmpPartionCell_mi.*
                                     FROM tmpPartionCell
                                          INNER JOIN _tmpPartionCell_mi ON _tmpPartionCell_mi.ObjectId = tmpPartionCell.Id
                                          INNER JOIN MovementItem ON MovementItem.Id = _tmpPartionCell_mi.MovementItemId
                                                                 AND MovementItem.isErased = FALSE
                                          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                          -- RK
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                     WHERE inIsShowFree = TRUE
                                       AND _tmpPartionCell_mi.ObjectId <> zc_PartionCell_RK()
                                        AND (Movement.DescId = zc_Movement_Send()
                                          OR (Movement.DescId   = zc_Movement_WeighingProduction()
                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             )
                                            )
                                    )
       -- занятые ячейки - показать MovementItem
     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.Id IN (SELECT DISTINCT tmpMILO_PartionCell_all_2.MovementItemId FROM tmpMILO_PartionCell_all_2)
                   AND MovementItem.isErased = FALSE
                )

       -- занятые ячейки - показать MovementItem
     , tmpMILO_PartionCell AS (SELECT DISTINCT
                                      tmp.PartionCellId
                                    , tmp.MovementItemId
                                    , tmp.MovementId
                                    , tmp.Ord
                               FROM (SELECT tmpMILO_PartionCell_all.ObjectId        AS PartionCellId
                                          , tmpMILO_PartionCell_all.MovementItemId
                                          , MovementItem.MovementId
                                            -- первый документ
                                          , ROW_NUMBER () OVER (PARTITION BY tmpMILO_PartionCell_all.ObjectId ORDER BY Movement.OperDate ASC, Movement.Id ASC) AS Ord
                                     FROM tmpMILO_PartionCell_all_2 AS tmpMILO_PartionCell_all
                                          JOIN tmpMI AS MovementItem ON MovementItem.Id = tmpMILO_PartionCell_all.MovementItemId

                                          JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                     --AND Movement.StatusId = zc_Enum_Status_Complete()
                                                     --AND Movement.DescId   = zc_Movement_Send()
                                          -- RK
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                     WHERE ((Movement.DescId   = zc_Movement_Send()
                                         AND Movement.StatusId = zc_Enum_Status_Complete()
                                            )
                                         OR (Movement.DescId   = zc_Movement_WeighingProduction()
                                         AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                            )
                                           )

                               ) AS tmp
                               -- первый документ
                               -- WHERE tmp.Ord = 1
                              )
       -- занятые ячейки - показать MovementItem
     , tmpMILO_PartionCell_check AS (SELECT tmpMILO_PartionCell_all.ObjectId        AS PartionCellId
                                          , MIN (MovementItem.ObjectId) AS GoodsId_min
                                          , MAX (MovementItem.ObjectId) AS GoodsId_max
                                          , MIN (COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS GoodsKindId_min
                                          , MAX (COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS GoodsKindId_max
                                          , MIN (COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate, zc_DateStart())) AS PartionDate_min
                                          , MAX (COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate, zc_DateStart())) AS PartionDate_max
                                            -- первый документ
                                     FROM tmpMILO_PartionCell_all_2 AS tmpMILO_PartionCell_all
                                          JOIN tmpMI AS MovementItem ON MovementItem.Id = tmpMILO_PartionCell_all.MovementItemId

                                          JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement.DescId   = zc_Movement_Send()
                                          -- RK
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()

                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                     GROUP BY tmpMILO_PartionCell_all.ObjectId
                                    )

       --
       SELECT
              Object.Id
            , Object.Code
            , Object.Name
            , Object.Name_search
            , CASE WHEN inIsShowFree = FALSE
                        THEN CASE WHEN tmpMILO_PartionCell_all_1.PartionCellId > 0 THEN 'Занято' ELSE 'Свободно' END
                          || CASE WHEN vbUserId = 5 AND 1=0 AND tmpMILO_PartionCell_all_1.PartionCellId > 0
                                       THEN '(' || tmpMILO_PartionCell_all_1.MovementItemId_min :: TVarChar || ')'
                                         || '(' || tmpMILO_PartionCell_all_1.MovementItemId_max :: TVarChar || ')'
                                  ELSE ''
                             END
                   ELSE CASE WHEN tmpMILO_PartionCell.PartionCellId > 0 THEN 'Занято' ELSE 'Свободно' END
              END :: TVarChar AS Status

            , tmpMILO_PartionCell.MovementItemId :: Integer
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName

            , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate

            , ObjectFloat_BoxCount.ValueData     ::TFloat  AS BoxCount

            , Movement.Id        ::Integer    AS MovementId
            , Movement.OperDate  ::TDateTime  AS OperDate
            , Movement.InvNumber ::TVarChar   AS InvNumber
            , MovementItem.Amount             AS Amount
            
            , CASE WHEN tmpMILO_PartionCell_check.GoodsId_min     <> tmpMILO_PartionCell_check.GoodsId_max
                     OR tmpMILO_PartionCell_check.GoodsKindId_min <> tmpMILO_PartionCell_check.GoodsKindId_max
                     OR tmpMILO_PartionCell_check.PartionDate_min <> tmpMILO_PartionCell_check.PartionDate_max
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isPartionCell_check

            , CASE WHEN inIsShowFree = FALSE
                        THEN CASE WHEN tmpMILO_PartionCell_all_1.PartionCellId > 0 THEN zc_Color_Cyan() ELSE zc_Color_White() END
                   ELSE CASE WHEN tmpMILO_PartionCell.PartionCellId > 0 THEN zc_Color_Cyan() ELSE zc_Color_White() END
              END :: Integer AS ColorFon

       FROM tmpPartionCell AS Object
           -- err
           LEFT JOIN tmpMILO_PartionCell_check ON tmpMILO_PartionCell_check.PartionCellId = Object.Id

           -- занятые ячейки - показать да/нет
           LEFT JOIN tmpMILO_PartionCell_all_1 ON tmpMILO_PartionCell_all_1.PartionCellId = Object.Id
           -- занятые ячейки - показать MovementItem
           LEFT JOIN tmpMILO_PartionCell ON tmpMILO_PartionCell.PartionCellId = Object.Id
                                        AND (tmpMILO_PartionCell.Ord = 1
                                          OR tmpMILO_PartionCell_check.PartionCellId > 0
                                            )


           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                      ON MIDate_PartionGoods.MovementItemId =  tmpMILO_PartionCell.MovementItemId
                                     AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

           LEFT JOIN MovementItem ON MovementItem.Id = tmpMILO_PartionCell.MovementItemId
           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = tmpMILO_PartionCell.MovementItemId
                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MovementItem.ObjectId
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                 ON ObjectFloat_BoxCount.ObjectId = Object.Id
                                AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_PartionCell_BoxCount()

           -- последний документ перемещения
           LEFT JOIN Movement ON Movement.Id       = tmpMILO_PartionCell.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.DescId   = zc_Movement_Send()
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.23         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartionCellChoice (FALSE, zfCalc_UserAdmin())
