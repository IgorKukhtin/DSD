
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
             , Amount       TFloat
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbPartionCellName TVarChar;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     vbPartionCellName = (SELECT Object.ValueData FROM Object WHERE Object.Id = inPartionCellId );
        
     IF inPartionCellId IN (zc_PartionCell_RK(), zc_PartionCell_Err() )
     THEN
         RAISE EXCEPTION 'Ошибка.Выбрана ячейка - <%>', vbPartionCellName;
     END IF;


     RETURN QUERY
     WITH
     tmpObject_GoodsKind AS (SELECT * FROM Object AS Object_GoodsKind WHERE Object_GoodsKind.DescId = zc_Object_GoodsKind())
   , tmpProtocol AS (SELECT *
                          , Object_GoodsKind.Id   ::Integer AS GoodsKindId
                           -- № п/п
                          --, ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName ORDER BY tmp.OperDate desc) AS Ord
                     FROM (
                           SELECT REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                                , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Объект"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')             AS GoodsName
                                , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')             AS GoodsKindName
                                , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS Amount
                                , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS AmountPartner
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

                                , MovementItemProtocol.MovementItemId
                                , MovementItemProtocol.OperDate
                                , MovementItemProtocol.UserId
                           FROM (
                                 SELECT *
                                 FROM MovementItemProtocol
                                 WHERE  MovementItemProtocol.OperDate >= inStartDate AND MovementItemProtocol.OperDate <= inEndDate
                                 
                                 ) AS MovementItemProtocol
                           WHERE position( vbPartionCellName in MovementItemProtocol.ProtocolData) > 0 ---%||||%'  --'%Пол-60%' --vbPartionCellName  --
                          ) AS tmp
                          LEFT JOIN tmpObject_GoodsKind AS Object_GoodsKind ON Object_GoodsKind.ValueData = tmp.GoodsKindName
                     )

   , tmpMI AS (SELECT MovementItem.Id
                    , Movement.OperDate
                    ,('№ '||Movement.InvNumber||' от '|| Movement.OperDate) ::TVarChar AS InvNumber_full
                    , Movement.Id AS MovementId
                    , CASE WHEN COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()) = zc_DateStart() THEN Movement.OperDate ELSE MIDate_PartionGoods.ValueData END ::TDateTime AS PartionGoodsDate
               FROM (SELECT DISTINCT tmpProtocol.MovementItemId FROM tmpProtocol) AS tmp
                    INNER JOIN MovementItem ON MovementItem.Id = tmp.MovementItemId
                                           AND MovementItem.isErased = FALSE
                    INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                       AND Movement.DescId = zc_Movement_Send()                   
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
                WHERE COALESCE (MovementBoolean_isRePack.ValueData,FALSE) = inIsRePack
                )
    --протокол + данные из документа
   , tmpProtocol_All AS (SELECT tmpProtocol_All.MovementItemId 
                              , tmpMI.MovementId
                              , tmpMI.InvNumber_full
                              , tmpProtocol_All.OperDate
                              , tmpProtocol_All.UserId
                              , tmpMI.PartionGoodsDate
                              , tmpProtocol_All.GoodsId
                              , tmpProtocol_All.GoodsName
                              , tmpProtocol_All.GoodsKindId
                              , tmpProtocol_All.GoodsKindName
                              , tmpProtocol_All.Amount
                              , tmpProtocol_All.AmountPartner
                              , tmpProtocol_All.PartionCell_1
                              , tmpProtocol_All.PartionCell_2
                              , tmpProtocol_All.PartionCell_3
                              , tmpProtocol_All.PartionCell_4
                              , tmpProtocol_All.PartionCell_5
                              , tmpProtocol_All.PartionCell_6
                              , tmpProtocol_All.PartionCell_7
                              , tmpProtocol_All.PartionCell_8
                              , tmpProtocol_All.PartionCell_9
                              , tmpProtocol_All.PartionCell_10
                              , tmpProtocol_All.PartionCell_11
                              , tmpProtocol_All.PartionCell_12
                              , tmpProtocol_All.PartionCell_13
                              , tmpProtocol_All.PartionCell_14
                              , tmpProtocol_All.PartionCell_15
                              , tmpProtocol_All.PartionCell_16
                              , tmpProtocol_All.PartionCell_17
                              , tmpProtocol_All.PartionCell_18
                              , tmpProtocol_All.PartionCell_19
                              , tmpProtocol_All.PartionCell_20
                              , tmpProtocol_All.PartionCell_21
                              , tmpProtocol_All.PartionCell_22
                         FROM tmpProtocol AS tmpProtocol_All
                             INNER JOIN tmpMI ON tmpMI.Id = tmpProtocol_All.MovementItemId
                         )

   , tmpCell_All AS (SELECT *
                 FROM (
                       SELECT DISTINCT
                              ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                            , 1 AS CellNum
                            , tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName
                            , CASE WHEN COALESCE (tmp.PartionCell_1, '') = '' OR COALESCE (tmp.PartionCell_1, '') = '"NULL"'
                                        THEN ''
                                   ELSE tmp.PartionCell_1
                              END AS PartionCellName
                            , tmp.OperDate, tmp.MovementItemId, tmp.UserId
                            , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate
                            , tmp.Amount
                       FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_1 = vbPartionCellName

             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 2 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_2, '') = '' OR COALESCE (tmp.PartionCell_2, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_2 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_2 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 3 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_3, '') = '' OR COALESCE (tmp.PartionCell_3, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_3 END AS PartionCellName,tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_3 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 4 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_4, '') = '' OR COALESCE (tmp.PartionCell_4, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_4 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_4 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 5 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_5, '') = '' OR COALESCE (tmp.PartionCell_5, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_5 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_5 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 6 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_6, '') = '' OR COALESCE (tmp.PartionCell_6, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_6 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_6 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 7 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_7, '') = '' OR COALESCE (tmp.PartionCell_7, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_7 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_7 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 8 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_8, '') = '' OR COALESCE (tmp.PartionCell_8, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_8 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_8 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 9 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_9, '') = '' OR COALESCE (tmp.PartionCell_9, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_9 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_9 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 10 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_10, '') = '' OR COALESCE (tmp.PartionCell_10, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_10 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_10 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 11 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_11, '') = '' OR COALESCE (tmp.PartionCell_11, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_11 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_11 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 12 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_12, '') = '' OR COALESCE (tmp.PartionCell_12, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_12 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_12 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 13 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_13, '') = '' OR COALESCE (tmp.PartionCell_13, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_3 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_13 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 14 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_14, '') = '' OR COALESCE (tmp.PartionCell_14, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_4 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_14 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 15 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_15, '') = '' OR COALESCE (tmp.PartionCell_15, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_5 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId 
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_15 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 16 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_16, '') = '' OR COALESCE (tmp.PartionCell_16, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_6 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_16 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 17 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_17, '') = '' OR COALESCE (tmp.PartionCell_17, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_7 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_17 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 18 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_18, '') = '' OR COALESCE (tmp.PartionCell_18, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_8 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_18 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 19 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_19, '') = '' OR COALESCE (tmp.PartionCell_19, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_9 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_19 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 20 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_20, '') = '' OR COALESCE (tmp.PartionCell_20, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_10 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_20 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 21 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_21, '') = '' OR COALESCE (tmp.PartionCell_21, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_11 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount 
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_21 = vbPartionCellName
             UNION SELECT DISTINCT ROW_NUMBER() OVER (PARTITION BY tmp.MovementItemId, tmp.GoodsId, tmp.GoodsKindName, tmp.PartionGoodsDate ORDER BY tmp.OperDate ASC) AS Ord
                        , 22 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindId, tmp.GoodsKindName, CASE WHEN COALESCE (tmp.PartionCell_22, '') = '' OR COALESCE (tmp.PartionCell_22, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_12 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId
                        , tmp.MovementId, tmp.InvNumber_full, tmp.PartionGoodsDate, tmp.Amount
                   FROM tmpProtocol_All AS tmp --WHERE tmp.PartionCell_22 = vbPartionCellName
                   ) AS tmp
                 --   WHERE tmp.Ord = 1
                  )

   , tmpCell AS (SELECT tmp1.*
                      , MIN (tmp1.OperDate) OVER (PARTITION BY tmp1.MovementItemId, tmp1.CellNum, tmp1.PartionCellName) AS OperDate_start
                 FROM tmpCell_All AS tmp1
                     LEFT JOIN tmpCell_All AS tmp2 ON tmp2.MovementItemId = tmp1.MovementItemId
                                          AND tmp2.Ord-1 = tmp1.Ord
                                          AND tmp2.CellNum = tmp1.CellNum
                 WHERE tmp1.PartionCellName = vbPartionCellName
                   AND tmp1.PartionCellName <> COALESCE (tmp2.PartionCellName,'')
                 )

   , tmpCell_history AS (SELECT tmp1.*
                              , tmp2.MovementItemId
                              , tmp2.PartionCellCode_new
                              , tmp2.PartionCellName_new
                              , tmp2.OperDate_new
                              , tmp2.UserName_new
                              , tmp2.CellNum
                         FROM (--берем только уникальные, чтоб не считать по несколько раз 
                               SELECT DISTINCT tmpCell.PartionGoodsDate, tmpCell.GoodsId, tmpCell.GoodsKindId, tmpCell.GoodsKindName
                               FROM tmpCell
                               ) AS tmp1
                               LEFT JOIN gpReport_PartionCell_history(tmp1.PartionGoodsDate::TDateTime
                                                                    , tmp1.GoodsId
                                                                    , COALESCE (tmp1.GoodsKindId,0)
                                                                    , inUnitId
                                                                    , TRUE --inisDetail  --всегда , чтоб привязать по строкам, а потом при необходимости свернуть
                                                                    , inIsRePack
                                                                    , inSession
                                                                      ) AS tmp2 ON tmp2.PartionGoodsDate = tmp1.PartionGoodsDate
                                                                               AND tmp2.PartionCellName_old = vbPartionCellName
                                                                               AND tmp2.GoodsId = tmp1.GoodsId
                                                                               AND COALESCE (tmp2.GoodsKindName,'') = COALESCE (tmp1.GoodsKindName,'')
                         )

   , tmpCell_full AS (SELECT DISTINCT
                             tmp.OperDate_start AS OperDate
                           , CASE WHEN inisDetail = TRUE THEN tmp.MovementItemId ELSE 0 END AS MovementItemId
                           , CASE WHEN inisDetail = TRUE THEN tmp.MovementId ELSE 0 END AS MovementId
                           , CASE WHEN inisDetail = TRUE THEN tmp.InvNumber_full ELSE '' END ::TVarChar AS InvNumber_full
                           , tmp.UserId
                           , tmp.GoodsId
                           , tmp.GoodsName
                           , tmp.GoodsKindId
                           , tmp.GoodsKindName
                           , tmp.PartionGoodsDate
                           , tmp.CellNum
                           , tmp.PartionCellCode_new
                           , tmp.PartionCellName_new
                           , tmp.OperDate_new ::TDateTime
                           , tmp.UserName_new ::TVarChar
                           , CAST (tmp.Amount AS TFloat) AS Amount
                      FROM (SELECT *
                            FROM (SELECT tmp1.*
                                       , tmp2.PartionCellCode_new
                                       , tmp2.PartionCellName_new
                                       , tmp2.OperDate_new
                                       , tmp2.UserName_new
                                       , ROW_NUMBER () OVER (PARTITION BY tmp1.MovementItemId, tmp1.CellNum, tmp1.GoodsId, tmp1.GoodsKindName, tmp1.PartionGoodsDate ORDER BY tmp2.OperDate_new DESC) AS Ord_new  
                                  FROM tmpCell AS tmp1
                                       LEFT JOIN tmpCell_history AS tmp2 ON tmp2.MovementItemId = tmp1.MovementItemId
                                                                AND tmp2.PartionGoodsDate = tmp1.PartionGoodsDate
                                                                AND tmp2.GoodsId = tmp1.GoodsId
                                                                AND COALESCE (tmp2.GoodsKindName,'') = COALESCE (tmp1.GoodsKindName,'')
                                                                AND tmp2.CellNum = tmp1.CellNum
                                                                AND tmp2.OperDate_new > tmp1.OperDate_start
                                 ) AS tmp
                            WHERE tmp.Ord_new = 1
                            ) AS tmp
                     )

    ---
    SELECT DISTINCT tmpCell.OperDate ::TDateTime AS OperDate
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
                  , SUM (COALESCE (tmpCell.Amount,0)) ::TFloat AS Amount
    FROM  tmpCell_full AS tmpCell
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpCell.GoodsId
         LEFT JOIN Object AS Object_User ON Object_User.Id = tmpCell.UserId
         LEFT JOIN tmpMI ON tmpMI.Id = tmpCell.MovementItemId
  --  WHERE tmpCell.PartionCellName = vbPartionCellName
  --    AND tmpCell.Ord = 1
    GROUP BY tmpCell.OperDate 
                  , tmpCell.MovementItemId
                  , tmpCell.MovementId
                  , tmpCell.InvNumber_full
                  , Object_User.ValueData
                  , tmpCell.GoodsId
                  , Object_Goods.ObjectCode
                  , tmpCell.GoodsName
                  , tmpCell.GoodsKindId
                  , tmpCell.GoodsKindName
                  , tmpCell.PartionGoodsDate
                  , tmpCell.CellNum 
                  , tmpCell.PartionCellCode_new
                  , tmpCell.PartionCellName_new
                  , tmpCell.OperDate_new
                  , tmpCell.UserName_new

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
--select * from gpReport_PartionCell_GoodsHistory (inStartDate := ('30.12.2024')::TDateTime, inEndDate := ('12.02.2025')::TDateTime, inPartionCellId := 11328932, inUnitId := 8459, inisDetail := false, inIsRePack := 'False' ,  inSession := '9457');