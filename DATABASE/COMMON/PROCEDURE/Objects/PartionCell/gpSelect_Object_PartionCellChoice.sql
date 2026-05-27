-- Function: gpSelect_Object_PartionCellChoice()

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
         -- занятые ячейки
       , tmpMILO_PartionCell_all AS (SELECT MI_PartionCell.PartionCellId, MI_PartionCell.MovementItemId, MI_PartionCell.MovementId
                                          , Movement.OperDate
                                          , Movement.InvNumber
                                          , MovementItem.ObjectId AS GoodsId
                                          , MovementItem.Amount
                                     FROM MI_PartionCell
                                          INNER JOIN MovementItem ON MovementItem.Id       = MI_PartionCell.MovementItemId
                                                                 AND MovementItem.isErased = FALSE
                                          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                          -- RK
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                        ON MovementLinkObject_To.MovementId = Movement.Id
                                                                       AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                                       AND MovementLinkObject_To.ObjectId   = zc_Unit_RK()
                                     WHERE MI_PartionCell.PartionCellId NOT IN (0, zc_PartionCell_RK(), zc_PartionCell_Err())
                                       AND ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId <> zc_Enum_Status_Erased())
                                         OR (Movement.DescId   = zc_Movement_WeighingProduction()
                                         AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                           ))
                                            
                                    )
       -- занятые ячейки - Ord = 1
     , tmpMILO_PartionCell AS (SELECT *
                               FROM (SELECT tmpMILO_PartionCell_all.*
                                            -- первый документ
                                          , ROW_NUMBER () OVER (PARTITION BY tmpMILO_PartionCell_all.PartionCellId ORDER BY tmpMILO_PartionCell_all.OperDate ASC, tmpMILO_PartionCell_all.MovementId ASC) AS Ord
                                     FROM tmpMILO_PartionCell_all
                                     WHERE inIsShowFree = FALSE
                                    ) AS tmp
                               -- первый документ
                               WHERE tmp.Ord = 1
                              )
      -- занятые ячейки - показать ВСЕ MovementItem
    , tmpMILO_PartionCell_detail AS (SELECT tmpMILO_PartionCell_all.*
                                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                                          , COALESCE (MIDate_PartionGoods.ValueData, tmpMILO_PartionCell_all.OperDate, zc_DateStart()) :: TDateTime AS PartionGoodsDate
                                            -- первый документ
                                          , ROW_NUMBER () OVER (PARTITION BY tmpMILO_PartionCell_all.PartionCellId ORDER BY tmpMILO_PartionCell_all.OperDate ASC, tmpMILO_PartionCell_all.MovementId ASC) AS Ord
                                     FROM tmpMILO_PartionCell_all
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = tmpMILO_PartionCell_all.MovementItemId
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                     ON MIDate_PartionGoods.MovementItemId = tmpMILO_PartionCell_all.MovementItemId
                                                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                     WHERE inIsShowFree = TRUE
                              )
       -- занятые ячейки - показать MovementItem
     , tmpMILO_PartionCell_check AS (SELECT tmpMILO_PartionCell_all.PartionCellId AS PartionCellId
                                          , MIN (tmpMILO_PartionCell_all.GoodsId) AS GoodsId_min
                                          , MAX (tmpMILO_PartionCell_all.GoodsId) AS GoodsId_max
                                          , MIN (COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS GoodsKindId_min
                                          , MAX (COALESCE (MILinkObject_GoodsKind.ObjectId, 0)) AS GoodsKindId_max
                                          , MIN (COALESCE (MIDate_PartionGoods.ValueData, tmpMILO_PartionCell_all.OperDate, zc_DateStart())) AS PartionDate_min
                                          , MAX (COALESCE (MIDate_PartionGoods.ValueData, tmpMILO_PartionCell_all.OperDate, zc_DateStart())) AS PartionDate_max
                                            -- первый документ
                                     FROM tmpMILO_PartionCell_all
                                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                           ON MILinkObject_GoodsKind.MovementItemId = tmpMILO_PartionCell_all.MovementItemId
                                                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                                     ON MIDate_PartionGoods.MovementItemId = tmpMILO_PartionCell_all.MovementItemId
                                                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                                     WHERE inIsShowFree = TRUE
                                     GROUP BY tmpMILO_PartionCell_all.PartionCellId
                                    )

       --
       SELECT
              Object.Id
            , Object.Code
            , Object.Name
            , Object.Name_search
            , (CASE WHEN COALESCE (tmpMILO_PartionCell.PartionCellId, tmpMILO_PartionCell_detail.PartionCellId) > 0 THEN 'Занято' ELSE 'Свободно' END
            || CASE WHEN vbUserId = 5 AND 1=0 AND tmpMILO_PartionCell.PartionCellId > 0
                         THEN '(' || COALESCE (tmpMILO_PartionCell.PartionCellId, tmpMILO_PartionCell_detail.PartionCellId) :: TVarChar || ')'
                    ELSE ''
               END
              ) :: TVarChar AS Status

            , COALESCE (tmpMILO_PartionCell.PartionCellId, tmpMILO_PartionCell_detail.PartionCellId) :: Integer
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName

            , tmpMILO_PartionCell_detail.PartionGoodsDate

            , ObjectFloat_BoxCount.ValueData     ::TFloat  AS BoxCount

            , tmpMILO_PartionCell_detail.MovementId
            , tmpMILO_PartionCell_detail.OperDate
            , tmpMILO_PartionCell_detail.InvNumber
            , tmpMILO_PartionCell_detail.Amount
            
            , CASE WHEN tmpMILO_PartionCell_check.GoodsId_min     <> tmpMILO_PartionCell_check.GoodsId_max
                     OR tmpMILO_PartionCell_check.GoodsKindId_min <> tmpMILO_PartionCell_check.GoodsKindId_max
                     OR tmpMILO_PartionCell_check.PartionDate_min <> tmpMILO_PartionCell_check.PartionDate_max
                        THEN TRUE
                   ELSE FALSE
              END :: Boolean AS isPartionCell_check

            , CASE WHEN COALESCE (tmpMILO_PartionCell.PartionCellId, tmpMILO_PartionCell_detail.PartionCellId) > 0 THEN zc_Color_Cyan() ELSE zc_Color_White() END :: Integer AS ColorFon

       FROM tmpPartionCell AS Object
           -- err
           LEFT JOIN tmpMILO_PartionCell_check ON tmpMILO_PartionCell_check.PartionCellId = Object.Id

           -- занятые ячейки - Ord = 1
           LEFT JOIN tmpMILO_PartionCell ON tmpMILO_PartionCell.PartionCellId = Object.Id

           -- занятые ячейки - показать ВСЕ MovementItem
           LEFT JOIN tmpMILO_PartionCell_detail ON tmpMILO_PartionCell_detail.PartionCellId = Object.Id

           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMILO_PartionCell_detail.GoodsId
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpMILO_PartionCell_detail.GoodsKindId

           LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                 ON ObjectFloat_BoxCount.ObjectId = Object.Id
                                AND ObjectFloat_BoxCount.DescId   = zc_ObjectFloat_PartionCell_BoxCount()
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
