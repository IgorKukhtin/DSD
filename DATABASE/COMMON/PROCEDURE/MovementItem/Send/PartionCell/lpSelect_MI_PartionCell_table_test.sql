-- Function: lpSelect_MI_PartionCell_table_test()

DROP FUNCTION IF EXISTS lpSelect_MI_PartionCell_table_test (TVarChar);

CREATE OR REPLACE FUNCTION lpSelect_MI_PartionCell_table_test(
    IN inSession  TVarChar
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Status TVarChar, DescId_MILO Integer
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , MovementId Integer
             , ItemName   TVarChar
             , OperDate TDateTime
             , InvNumber TVarChar
             , Amount TFloat
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
                         FROM Object
                         WHERE Object.DescId = zc_Object_PartionCell()
                           AND Object.isErased = FALSE
                        )
             -- занятые ячейки - показать MovementItem
           , tmpMILO_PartionCell AS (SELECT _tmpPartionCell_mi.*, Movement.Id AS MovementId, MovementItem.ObjectId AS GoodsId, MovementItem.Amount
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
                                     WHERE _tmpPartionCell_mi.ObjectId NOT IN  (zc_PartionCell_RK(), zc_PartionCell_Err())
                                        AND ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId <> zc_Enum_Status_Erased())
                                          OR (Movement.DescId   = zc_Movement_WeighingProduction()
                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                             )
                                            )
                                    )

       --
       SELECT
              Object.Id
            , Object.Code
            , Object.Name
            , CASE WHEN tmpMILO_PartionCell.ObjectId > 0
                        THEN 'Занято'
                   ELSE 'Свободно'
              END :: TVarChar AS Status
            , tmpMILO_PartionCell.DescId AS DescId_MILO

            , tmpMILO_PartionCell.MovementItemId :: Integer
            , Object_Goods.Id                      AS GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , Object_Goods.ValueData               AS GoodsName
            , Object_GoodsKind.Id                  AS GoodsKindId
            , Object_GoodsKind.ValueData           AS GoodsKindName

            , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate

            , Movement.Id        ::Integer    AS MovementId
            , MovementDesc.ItemName           AS ItemName
            , Movement.OperDate  ::TDateTime  AS OperDate
            , Movement.InvNumber ::TVarChar   AS InvNumber
            , tmpMILO_PartionCell.Amount      AS Amount
            
       FROM tmpPartionCell AS Object
           -- занятые ячейки - показать MovementItem
           JOIN tmpMILO_PartionCell ON tmpMILO_PartionCell.ObjectId = Object.Id

           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                      ON MIDate_PartionGoods.MovementItemId =  tmpMILO_PartionCell.MovementItemId
                                     AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()

           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                            ON MILinkObject_GoodsKind.MovementItemId = tmpMILO_PartionCell.MovementItemId
                                           AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()

           LEFT JOIN Object AS Object_Goods     ON Object_Goods.Id     = tmpMILO_PartionCell.GoodsId
           LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

           -- документ
           LEFT JOIN Movement ON Movement.Id         = tmpMILO_PartionCell.MovementId
           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.26                                        *
*/

-- тест
-- SELECT * FROM lpSelect_MI_PartionCell_table_test(inSession := '5');
