
-- Function: gpReport_PartionCell_PasportPrint_list

DROP FUNCTION IF EXISTS gpReport_PartionCell_PasportPrint_list (Integer, Integer, Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PartionCell_PasportPrint_list (Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_PasportPrint_list(
    IN inMovementItemId    Integer  ,
    IN inPartionCellId     Integer  , --
    IN inGoodsId           Integer  , --
    IN inGoodsKindId       Integer  , -- 
    IN inPartionGoodsDate  TDateTime ,
    IN inIsCell            Boolean  ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , PartionGoodsDate TDateTime 
             , PartionCellName TVarChar
             , StoreKeeper TVarChar
             , ChoiceCellCode      Integer
             , ChoiceCellName      TVarChar
             , ChoiceCellName_shot TVarChar
              )
AS                      
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE curPartionCell refcursor;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     --выбираем все ячейки
     CREATE TEMP TABLE _tmpPartionCell (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;

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
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор
     
          
  -- Результат
  RETURN QUERY
    WITH
    tmpPartionCell AS (
                       SELECT tmp.*
                       FROM (SELECT DISTINCT
                                    curPartionCell.MovementItemId
                                  , curPartionCell.DescId
                                  , curPartionCell.ObjectId AS PartionCellId
                                  , MovementItem.ObjectId   AS GoodsId
                                  , COALESCE (MILinkObject_GoodsKind.ObjectId,0) AS GoodsKindId
                                  
                                 , CASE WHEN COALESCE (MovementBoolean_isRePack.ValueData, FALSE)  = TRUE -- AND vbUserId = 5
                                             THEN zc_DateStart()
                                        ELSE COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate)
                                   END ::TDateTime AS PartionGoodsDate
                             FROM _tmpPartionCell AS curPartionCell
                                 INNER JOIN MovementItem ON MovementItem.Id = curPartionCell.MovementItemId
                                                        AND MovementItem.ObjectId = inGoodsId
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE 
                                 INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
      
                                 LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                           ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                          AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
      
                                 LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                            ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                           AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
      
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
      
                             WHERE ((curPartionCell.ObjectId = inPartionCellId AND inIsCell = TRUE) OR inIsCell = FALSE) 
                                AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)  
                                AND ((COALESCE (inMovementItemId,0) <> 0 AND curPartionCell.MovementItemId = inMovementItemId) OR COALESCE (inMovementItemId,0) = 0 )
                             ) AS tmp
                       WHERE tmp.PartionGoodsDate = inPartionGoodsDate    
                      ) 

 , tmpPartionCell_gr AS (
                       SELECT DISTINCT
                                    tmpPartionCell.DescId
                                  , tmpPartionCell.PartionCellId
                                  , tmpPartionCell.GoodsId
                                  , tmpPartionCell.GoodsKindId
                                  , tmpPartionCell.PartionGoodsDate
                       FROM tmpPartionCell
                       )

  , tmpProtocolMI AS (SELECT *
                      FROM (SELECT MovementItemProtocol.MovementItemId
                           , MovementItemProtocol.UserId
                           , MovementItemProtocol.OperDate
                           , ROW_NUMBER () OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS ord
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-1"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_1
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-2"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_2
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-3"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_3
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-4"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_4
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-5"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_5
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-6"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_6
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-7"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_7
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-8"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_8
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-9"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_9
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-10"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_10
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-11"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_11
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-12"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_12
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-13"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_13
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-14"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_14
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-15"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_15
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-16"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_16
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-17"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_17
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-18"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_18
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-19"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_19
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-20"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_20
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-21"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_21
                           , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-22"]  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_22 
                      FROM MovementItemProtocol
                      WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpPartionCell.MovementItemId FROM tmpPartionCell) 
                      ) AS tmp
                      )  

  , tmpProtocolCell AS (SELECT tmp.*
                                , ROW_NUMBER() OVER (PARTITION BY  tmp.DescId, tmp.PartionCellName ORDER BY tmp.OperDate desc) AS Ord  --tmp.MovementItemId,
                           FROM 
                           (SELECT DISTINCT zc_MILinkObject_PartionCell_1()  AS DescId, tmp.PartionCell_1  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_1, '') <> '' AND COALESCE (tmp.PartionCell_1, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_1, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_2()  AS DescId, tmp.PartionCell_2  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_2, '') <> '' AND COALESCE (tmp.PartionCell_2, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_2, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_3()  AS DescId, tmp.PartionCell_3  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_3, '') <> '' AND COALESCE (tmp.PartionCell_3, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_3, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_4()  AS DescId, tmp.PartionCell_4  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_4, '') <> '' AND COALESCE (tmp.PartionCell_4, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_4, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_5()  AS DescId, tmp.PartionCell_5  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_5, '') <> '' AND COALESCE (tmp.PartionCell_5, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_5, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_6()  AS DescId, tmp.PartionCell_6  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_6, '') <> '' AND COALESCE (tmp.PartionCell_6, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_6, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_7()  AS DescId, tmp.PartionCell_7  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_7, '') <> '' AND COALESCE (tmp.PartionCell_7, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_7, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_8()  AS DescId, tmp.PartionCell_8  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_8, '') <> '' AND COALESCE (tmp.PartionCell_8, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_8, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_9()  AS DescId, tmp.PartionCell_9  AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_9, '') <> '' AND COALESCE (tmp.PartionCell_9, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_9, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_10() AS DescId, tmp.PartionCell_10 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_10, '') <> '' AND COALESCE (tmp.PartionCell_10, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_10, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_11() AS DescId, tmp.PartionCell_11 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_11, '') <> '' AND COALESCE (tmp.PartionCell_11, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_11, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_12() AS DescId, tmp.PartionCell_12 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_12, '') <> '' AND COALESCE (tmp.PartionCell_12, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_12, '') <> '"Ячейка отбора"' 
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_13() AS DescId, tmp.PartionCell_13 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_13, '') <> '' AND COALESCE (tmp.PartionCell_13, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_13, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_14() AS DescId, tmp.PartionCell_14 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_14, '') <> '' AND COALESCE (tmp.PartionCell_14, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_14, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_15() AS DescId, tmp.PartionCell_15 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_15, '') <> '' AND COALESCE (tmp.PartionCell_15, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_15, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_16() AS DescId, tmp.PartionCell_16 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_16, '') <> '' AND COALESCE (tmp.PartionCell_16, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_16, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_17() AS DescId, tmp.PartionCell_17 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_17, '') <> '' AND COALESCE (tmp.PartionCell_17, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_17, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_18() AS DescId, tmp.PartionCell_18 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_18, '') <> '' AND COALESCE (tmp.PartionCell_18, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_18, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_19() AS DescId, tmp.PartionCell_19 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_19, '') <> '' AND COALESCE (tmp.PartionCell_19, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_19, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_20() AS DescId, tmp.PartionCell_20 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_20, '') <> '' AND COALESCE (tmp.PartionCell_20, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_20, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_21() AS DescId, tmp.PartionCell_21 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_21, '') <> '' AND COALESCE (tmp.PartionCell_21, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_21, '') <> '"Ячейка отбора"'
                      UNION SELECT DISTINCT zc_MILinkObject_PartionCell_22() AS DescId, tmp.PartionCell_22 AS PartionCellName, tmp.OperDate, tmp.UserId  FROM tmpProtocolMI AS tmp WHERE COALESCE (tmp.PartionCell_22, '') <> '' AND COALESCE (tmp.PartionCell_22, '') <> '"NULL"' AND COALESCE (tmp.PartionCell_22, '') <> '"Ячейка отбора"'            
                             ) AS tmp
                           )

        --ячейки отбора               
      , tmpChoiceCell AS (SELECT tmp.*
                               , LEFT (tmp.Name, 1)::TVarChar AS CellName_shot
                               , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId ORDER BY tmp.NPP) AS Ord
                          FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS tmp
                          WHERE tmp.GoodsId = inGoodsId
                            AND COALESCE (tmp.GoodsKindId,0) = COALESCE (inGoodsKindId,0)
                          )


     --
     SELECT Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName 
          , tmp.PartionGoodsDate :: TDateTime  AS PartionGoodsDate
          , Object_PartionCell.ValueData       AS PartionCellName
          , Object_Member.ValueData ::TVarChar AS StoreKeeper
          --ячейка отбора
          , tmpChoiceCell.Code          ::Integer  AS ChoiceCellCode
          , tmpChoiceCell.Name          ::TVarChar AS ChoiceCellName
          , tmpChoiceCell.CellName_shot ::TVarChar AS ChoiceCellName_shot
     FROM tmpPartionCell_gr AS tmp
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
   
          INNER JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = tmp.PartionCellId AND Object_PartionCell.ObjectCode <> 0

          LEFT JOIN tmpProtocolCell ON tmpProtocolCell.DescId = tmp.DescId
                                   AND tmpProtocolCell.PartionCellName = Object_PartionCell.ValueData
                                   AND tmpProtocolCell.ord = 1
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpProtocolCell.UserId
          
          LEFT JOIN tmpChoiceCell ON tmpChoiceCell.GoodsId = tmp.GoodsId
                                 AND COALESCE (tmpChoiceCell.GoodsKindId,0) = COALESCE (tmp.GoodsKindId,0)
                                 AND tmpChoiceCell.Ord = 1
     ORDER BY tmp.DescId
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.08.24         *
*/

-- тест
--  select * from gpReport_PartionCell_PasportPrint_list(inMovementItemId := 0, inPartionCellId := 10239461 ::Integer, inGoodsId := 112643 ::Integer , inGoodsKindId := 8346 ::Integer, inPartionGoodsDate := ('01.08.2024')::TDateTime  , inisCell := 'false'::Boolean ,  inSession := '9457' ::TVarChar)
-- select * from gpReport_PartionCell_PasportPrint_list(inMovementItemId := 297395802 , inPartionCellId := 0 , inGoodsId := 10442608 , inGoodsKindId := 5808945 , inPartionGoodsDate := ('27.07.2024')::TDateTime , inIsCell := 'True' ,  inSession := '9457');