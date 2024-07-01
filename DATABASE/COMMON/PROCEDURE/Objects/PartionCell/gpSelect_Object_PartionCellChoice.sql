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
                             , (Object.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS Name_search
                         FROM Object
                         WHERE Object.DescId = zc_Object_PartionCell()
                           AND Object.isErased = FALSE
                         )
      -- занятые ячейки
     , tmpMILO_PartionCell_all_1 AS (SELECT DISTINCT _tmpPartionCell_mi.ObjectId AS PartionCellId
                                     FROM tmpPartionCell
                                          INNER JOIN _tmpPartionCell_mi ON _tmpPartionCell_mi.ObjectId = tmpPartionCell.Id
                                     WHERE inIsShowFree = FALSE
                                    )
      -- занятые ячейки
     , tmpMILO_PartionCell_all_2 AS (SELECT _tmpPartionCell_mi.*
                                     FROM tmpPartionCell
                                          INNER JOIN _tmpPartionCell_mi ON _tmpPartionCell_mi.ObjectId = tmpPartionCell.Id
                                     WHERE inIsShowFree = TRUE
                                    )

     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.Id IN (SELECT DISTINCT tmpMILO_PartionCell_all_2.MovementItemId FROM tmpMILO_PartionCell_all_2)
                   AND MovementItem.isErased = FALSE 
                 )

      -- занятые ячейки
     , tmpMILO_PartionCell AS (SELECT DISTINCT 
                                      tmp.PartionCellId
                                    , tmp.MovementItemId
                                    , tmp.MovementId
                               FROM (SELECT tmpMILO_PartionCell_all.ObjectId             AS PartionCellId
                                          , MIN (tmpMILO_PartionCell_all.MovementItemId) OVER(PARTITION BY tmpMILO_PartionCell_all.ObjectId) AS MovementItemId
                                          , Movement.Id                                  AS MovementId
                                          , ROW_NUMBER () OVER (PARTITION BY tmpMILO_PartionCell_all.ObjectId ORDER BY Movement.OperDate ASC, Movement.Id ASC) AS Ord  --последний документ
                                     FROM tmpMILO_PartionCell_all_2 AS tmpMILO_PartionCell_all
                                          JOIN tmpMI AS MovementItem ON MovementItem.Id = tmpMILO_PartionCell_all.MovementItemId
      
                                          JOIN Movement ON Movement.Id       = MovementItem.MovementId
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                                       AND Movement.DescId   = zc_Movement_Send()
                               ) AS tmp
                               WHERE tmp.Ord = 1
                               --GROUP BY tmpMILO_PartionCell_all.ObjectId
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
            
            , ObjectFloat_BoxCount.ValueData     ::TFloat  AS BoxCount
            
            , Movement.Id        ::Integer    AS MovementId
            , Movement.OperDate  ::TDateTime  AS OperDate
            , Movement.InvNumber ::TVarChar   AS InvNumber

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

           LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                                 ON ObjectFloat_BoxCount.ObjectId = Object.Id
                                AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_PartionCell_BoxCount()    
   
           --последний документ перемещения                     
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
