
-- Function: gpReport_PartionCell_GoodsHistory ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_GoodsHistory (TDateTime, TDateTime, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_GoodsHistory (
    IN inStartDate       TDateTime ,
    IN inEndDate         TDateTime ,
    IN inPartionCellId   Integer   ,
    IN inUnitId          Integer   ,
    IN inisDetail        Boolean   , -- отображать  по строкам 
    IN inIsRePack        Boolean   , -- Перепак  Да / Нет
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , MovementItemId Integer
             , MovementId Integer
             , InvNumber_full TVarChar
             , UserName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , CellNum Integer
             , Ord Integer 
             , PartionCellCode_new Integer
             , PartionCellName_new TVarChar
             , OperDate_new        TDateTime
             , UserName_new TVarChar
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbPartionCellName TVarChar;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     vbPartionCellName = (SELECT Object.ValueData FROM Object WHERE Object.Id = inPartionCellId );
        
     IF vbPartionCellName LIKE '%отбор%'
     THEN
         RAISE EXCEPTION 'Ошибка.ВЫбрана ячейке отбора <%>', vbPartionCellName;
     END IF;



     RETURN QUERY
     WITH
      tmpMI AS (SELECT MovementItem.Id
                     , Movement.OperDate
                     ,('№ '||Movement.InvNumber||' от '|| Movement.InvNumber) ::TVarChar AS InvNumber_full
                     , Movement.Id AS MovementId
                     , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) ::TDateTime AS PartionGoodsDate
                FROM MovementItemLinkObject AS MILinkObject_PartionCell_1
                    
                     INNER JOIN MovementItem ON MovementItem.Id = MILinkObject_PartionCell_1.MovementItemId 
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE                    

                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                        AND Movement.StatusId = zc_Enum_Status_Complete()

                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                  AND (MovementLinkObject_To.ObjectId = inUnitId OR inUnitId = 0)

                     LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                               ON MovementBoolean_isRePack.MovementId = Movement.Id
                                              AND MovementBoolean_isRePack.DescId = zc_MovementBoolean_isRePack()

                     LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                               AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

               WHERE MILinkObject_PartionCell_1.ObjectId  = inPartionCellId               --11347398 --10456344 --"R-1-4-2"
                 AND MILinkObject_PartionCell_1.DescId IN (zc_MILinkObject_PartionCell_1()
                                                          ,zc_MILinkObject_PartionCell_2()
                                                          ,zc_MILinkObject_PartionCell_3()
                                                          ,zc_MILinkObject_PartionCell_4()
                                                          ,zc_MILinkObject_PartionCell_5()
                                                          ,zc_MILinkObject_PartionCell_6()
                                                          ,zc_MILinkObject_PartionCell_7()
                                                          ,zc_MILinkObject_PartionCell_8()
                                                          ,zc_MILinkObject_PartionCell_9()
                                                          ,zc_MILinkObject_PartionCell_10()
                                                          ,zc_MILinkObject_PartionCell_11()
                                                          ,zc_MILinkObject_PartionCell_12()
                                                          ,zc_MILinkObject_PartionCell_13()
                                                          ,zc_MILinkObject_PartionCell_14()
                                                          ,zc_MILinkObject_PartionCell_15()
                                                          ,zc_MILinkObject_PartionCell_16()
                                                          ,zc_MILinkObject_PartionCell_17()
                                                          ,zc_MILinkObject_PartionCell_18()
                                                          ,zc_MILinkObject_PartionCell_19()
                                                          ,zc_MILinkObject_PartionCell_20()
                                                          ,zc_MILinkObject_PartionCell_21()
                                                          ,zc_MILinkObject_PartionCell_22()
                                                          )
                  AND COALESCE (MovementBoolean_isRePack.ValueData, FALSE) = inIsRePack
                )

      , tmpProtocol_All AS (SELECT *
                                 , Object_GoodsKind.Id   ::Integer AS GoodsKindId
                                  -- № п/п
                                 --, ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName ORDER BY tmp.OperDate desc) AS Ord
                            FROM (SELECT
                                         REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Объект"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')             AS GoodsName
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')             AS GoodsKindName
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
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-13"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_13
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-14"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_14
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-15"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_15
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-16"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_16
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-17"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_17
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-18"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_18
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-19"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_19
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-20"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_20
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-21"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_21
                                       , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-22"] /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_22
                                       , CASE WHEN inisDetail = TRUE THEN MovementItemProtocol.MovementItemId ELSE 0 END AS MovementItemId
                                       , MovementItemProtocol.OperDate
                                       , MovementItemProtocol.UserId
                                       , tmpMI.PartionGoodsDate
                                       , CASE WHEN inisDetail = TRUE THEN tmpMI.MovementId ELSE 0 END      AS MovementId
                                       , CASE WHEN inisDetail = TRUE THEN tmpMI.InvNumber_full ELSE '' END AS InvNumber_full
                                  FROM MovementItemProtocol
                                       INNER JOIN tmpMI ON tmpMI.Id = MovementItemProtocol.MovementItemId
                                  WHERE MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate <= inEndDate
                                  ) AS tmp
                                 LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.ValueData = tmp.GoodsKindName 
                            WHERE tmp.PartionCell_1  = vbPartionCellName
                               OR tmp.PartionCell_2  = vbPartionCellName
                               OR tmp.PartionCell_3  = vbPartionCellName
                               OR tmp.PartionCell_4  = vbPartionCellName
                               OR tmp.PartionCell_5  = vbPartionCellName
                               OR tmp.PartionCell_6  = vbPartionCellName
                               OR tmp.PartionCell_7  = vbPartionCellName
                               OR tmp.PartionCell_8  = vbPartionCellName
                               OR tmp.PartionCell_9  = vbPartionCellName
                               OR tmp.PartionCell_10 = vbPartionCellName
                               OR tmp.PartionCell_11 = vbPartionCellName
                               OR tmp.PartionCell_12 = vbPartionCellName
                               OR tmp.PartionCell_13 = vbPartionCellName
                               OR tmp.PartionCell_14 = vbPartionCellName
                               OR tmp.PartionCell_15 = vbPartionCellName
                               OR tmp.PartionCell_16 = vbPartionCellName
                               OR tmp.PartionCell_17 = vbPartionCellName
                               OR tmp.PartionCell_18 = vbPartionCellName
                               OR tmp.PartionCell_19 = vbPartionCellName
                               OR tmp.PartionCell_20 = vbPartionCellName
                               OR tmp.PartionCell_21 = vbPartionCellName
                               OR tmp.PartionCell_22 = vbPartionCellName
                            )

      , tmpCell AS (SELECT DISTINCT
                          ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 1 AS CellNum
                        , tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName
                        , CASE WHEN COALESCE (tmp.PartionCell_1, '') = '' OR COALESCE (tmp.PartionCell_1, '') = '"NULL"'
                                    THEN ''
                               ELSE tmp.PartionCell_1
                          END AS PartionCellName
                        , tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate
   
                   FROM tmpProtocol_All AS tmp

             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 2 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_2, '') = '' OR COALESCE (tmp.PartionCell_2, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_2 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 3 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_3, '') = '' OR COALESCE (tmp.PartionCell_3, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_3 END AS PartionCellName,tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 4 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_4, '') = '' OR COALESCE (tmp.PartionCell_4, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_4 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 5 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_5, '') = '' OR COALESCE (tmp.PartionCell_5, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_5 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 6 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_6, '') = '' OR COALESCE (tmp.PartionCell_6, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_6 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 7 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_7, '') = '' OR COALESCE (tmp.PartionCell_7, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_7 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 8 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_8, '') = '' OR COALESCE (tmp.PartionCell_8, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_8 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 9 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_9, '') = '' OR COALESCE (tmp.PartionCell_9, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_9 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 10 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_10, '') = '' OR COALESCE (tmp.PartionCell_10, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_10 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 11 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_11, '') = '' OR COALESCE (tmp.PartionCell_11, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_11 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 12 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_12, '') = '' OR COALESCE (tmp.PartionCell_12, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_12 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 13 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_13, '') = '' OR COALESCE (tmp.PartionCell_13, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_3 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 14 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_14, '') = '' OR COALESCE (tmp.PartionCell_14, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_4 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 15 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_15, '') = '' OR COALESCE (tmp.PartionCell_15, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_5 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId 
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 16 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_16, '') = '' OR COALESCE (tmp.PartionCell_16, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_6 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 17 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_17, '') = '' OR COALESCE (tmp.PartionCell_17, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_7 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 18 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_18, '') = '' OR COALESCE (tmp.PartionCell_18, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_8 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 19 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_19, '') = '' OR COALESCE (tmp.PartionCell_19, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_9 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 20 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_20, '') = '' OR COALESCE (tmp.PartionCell_20, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_10 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 21 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_21, '') = '' OR COALESCE (tmp.PartionCell_21, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_11 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 22 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_22, '') = '' OR COALESCE (tmp.PartionCell_22, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_12 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate FROM tmpProtocol_All AS tmp
                   )

    --
    , tmpCell_full AS (SELECT *
                       FROM (SELECT tmp1.*
                                  , tmp2.PartionCellCode_new
                                  , tmp2.PartionCellName_new
                                  , tmp2.OperDate_new
                                  , tmp2.UserName_new
                                  , ROW_NUMBER () OVER (PARTITION BY tmp1.MovementItemId, tmp1.MovementId, tmp1.GoodsId, tmp1.GoodsKindId ORDER BY tmp2.OperDate_new ASC) AS Ord_new
                             FROM tmpCell AS tmp1
                                  LEFT JOIN gpReport_PartionCell_history(tmp1.PartionGoodsDate::TDateTime
                                                                             , tmp1.GoodsId
                                                                             , tmp1.GoodsKindId
                                                                             , inUnitId
                                                                             , inisDetail
                                                                             , inIsRePack
                                                                             , inSession) AS tmp2 ON tmp2.PartionGoodsDate = tmp1.PartionGoodsDate
                                                                                                 AND tmp2.PartionCellName_old = vbPartionCellName
                                                                                                 AND tmp2.GoodsId = tmp1.GoodsId
                                                                                                 AND tmp2.GoodsKindName = tmp1.GoodsKindName
                             WHERE tmp1.PartionCellName = vbPartionCellName
                               AND tmp1.Ord = 1
                               --AND 1=0
                              ) AS tmp
                       WHERE tmp.Ord_new = 1
                      )


    SELECT DISTINCT tmpCell.OperDate AS OperDate
                  , tmpCell.MovementItemId
                  , tmpCell.MovementId
                  , tmpCell.InvNumber_full ::TVarChar
                  , Object_User.ValueData AS UserName
                  , tmpCell.GoodsId
                  , Object_Goods.ObjectCode ::Integer AS GoodsCode
                  , tmpCell.GoodsName      ::TVarChar
                  , tmpCell.GoodsKindId    ::Integer  AS GoodsKindId
                  , tmpCell.GoodsKindName  ::TVarChar
                  , tmpCell.PartionGoodsDate ::TDateTime
                  , tmpCell.CellNum       ::Integer
                  , ROW_NUMBER() OVER (ORDER BY tmpCell.OperDate ASC) ::Integer   AS Ord
                  , tmpCell.PartionCellCode_new
                  , tmpCell.PartionCellName_new
                  , tmpCell.OperDate_new ::TDateTime
                  , tmpCell.UserName_new ::TVarChar
    FROM  tmpCell_full AS tmpCell
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpCell.GoodsId
         LEFT JOIN Object AS Object_User ON Object_User.Id = tmpCell.UserId
         LEFT JOIN tmpMI ON tmpMI.Id = tmpCell.MovementItemId
  --  WHERE tmpCell.PartionCellName = vbPartionCellName
  --    AND tmpCell.Ord = 1

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.01.25         *
*/

-- тест
-- select * from gpReport_PartionCell_GoodsHistory (inStartDate := ('30.11.2024')::TDateTime, inEndDate := ('30.03.2025')::TDateTime, inPartionCellId := 11347398, inUnitId := 8459, inisDetail := False, inIsRePack := 'False' ,  inSession := '9457');


--vbPartionCellName = (SELECT Object.ValueData FROM Object WHERE Object.Id = 11347398 );
--select * from gpReport_PartionCell_GoodsHistory (inStartDate := ('30.11.2024')::TDateTime, inEndDate := ('30.03.2025')::TDateTime, inPartionCellId := 11347398, inUnitId := 8459, inisDetail := False, inIsRePack := 'False' ,  inSession := '9457');


