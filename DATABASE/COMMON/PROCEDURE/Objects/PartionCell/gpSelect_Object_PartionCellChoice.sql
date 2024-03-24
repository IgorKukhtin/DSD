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
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());

      RETURN QUERY
      WITH
      tmpPartionCell AS (SELECT
                               Object.Id         AS Id
                             , Object.ObjectCode AS Code
                             , Object.ValueData  AS Name
                             , (Object.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
                         FROM Object
                         WHERE Object.DescId = zc_Object_PartionCell()
                           AND Object.isErased = FALSE
                         )
      -- занятые ячейки
     , tmpMILO_PartionCell_all_1 AS (SELECT DISTINCT MovementItemLinkObject.ObjectId AS PartionCellId
                                     FROM tmpPartionCell
                                          INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.ObjectId = tmpPartionCell.Id
                                     WHERE inIsShowFree = FALSE
                                    )
      -- занятые ячейки
     , tmpMILO_PartionCell_all_2 AS (SELECT MovementItemLinkObject.*
                                     FROM tmpPartionCell
                                          INNER JOIN MovementItemLinkObject ON MovementItemLinkObject.ObjectId = tmpPartionCell.Id
                                     WHERE inIsShowFree = TRUE
                                    )
      -- занятые ячейки
     , tmpMILO_PartionCell AS (SELECT tmpMILO_PartionCell_all.ObjectId             AS PartionCellId
                                    , MIN (tmpMILO_PartionCell_all.MovementItemId) AS MovementItemId
                               FROM tmpMILO_PartionCell_all_2 AS tmpMILO_PartionCell_all
                                    JOIN MovementItem ON MovementItem.Id       = tmpMILO_PartionCell_all.MovementItemId
                                                     AND MovementItem.isErased = FALSE
                                    JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                                 AND Movement.DescId   = zc_Enum_Status_Complete()
                               WHERE tmpMILO_PartionCell_all.DescId IN (zc_MILinkObject_PartionCell_1()
                                                                      , zc_MILinkObject_PartionCell_2()
                                                                      , zc_MILinkObject_PartionCell_3()
                                                                      , zc_MILinkObject_PartionCell_4()
                                                                      , zc_MILinkObject_PartionCell_5()
                                                                       )
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
                   ELSE CASE WHEN tmpMILO_PartionCell.PartionCellId > 0 THEN 'Занято' ELSE 'Свободно' END
              END :: TVarChar AS Status

            , tmpMILO_PartionCell.MovementItemId :: Integer
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName

            , MIDate_PartionGoods.ValueData AS PartionGoodsDate

       FROM tmpPartionCell AS Object
           LEFT JOIN tmpMILO_PartionCell_all_1 ON tmpMILO_PartionCell_all_1.PartionCellId = Object.Id
           LEFT JOIN tmpMILO_PartionCell ON tmpMILO_PartionCell.PartionCellId = Object.Id
           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                      ON MIDate_PartionGoods.MovementItemId =  tmpMILO_PartionCell.MovementItemId
                                     AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

           LEFT JOIN MovementItem ON MovementItem.Id = tmpMILO_PartionCell.MovementItemId
           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = tmpMILO_PartionCell.MovementItemId
                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = MovementItem.ObjectId
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
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
