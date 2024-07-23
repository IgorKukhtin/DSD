-- Function: gpReport_PartionCell_history ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_history (TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PartionCell_history (TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_history (
    IN inPartionGoodsDate         TDateTime ,
    IN inGoodsId                  Integer   ,
    IN inGoodsKindId              Integer   ,
    IN inUnitId                   Integer   , 
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate_old TDateTime, OperDate_new TDateTime
             , MovementItemId Integer  
             , UserName_old TVarChar, UserName_new TVarChar
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , PartionCellCode_old   Integer
             , PartionCellName_old   TVarChar
             , PartionCellCode_new   Integer
             , PartionCellName_new   TVarChar
             , Amount TFloat
             , Ord Integer
             , CellNum Integer
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbGoodsKindName TVarChar;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

     vbGoodsKindName = (SELECT Object.ValueData FROM Object WHERE Object.Id = inGoodsKindId );

RETURN QUERY 
WITH 
tmpMI AS (SELECT DISTINCT tmp.Id
          FROM (
                --запрос по партии сохр. в документе
                SELECT MovementItem.Id
                FROM MovementItemDate  
                     INNER JOIN MovementItem ON MovementItem.Id = MovementItemDate.MovementItemId
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE  
                                           -- AND MovementItem.MovementId = 28742039
                     INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                        AND Movement.DescId = zc_Movement_Send()    
                                      --  AND Movement.Id = 28742039     
                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                 AND MovementLinkObject_To.ObjectId = inUnitId

                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE MovementItemDate.ValueData = inPartionGoodsDate --'2024-07-15'
                  AND MovementItemDate.DescId = zc_MIDate_PartionGoods()
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)
              UNION
                -- запрос по док. Перемещения - партия  = дата документа
                SELECT MovementItem.Id
                FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                  AND MovementLinkObject_To.ObjectId = inUnitId
       
                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE
                                            AND MovementItem.ObjectId = inGoodsId
       
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                WHERE Movement.DescId = zc_Movement_Send()
                  AND Movement.OperDate = inPartionGoodsDate
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)
              UNION
                --запрос по партиям из проводок    
                SELECT DISTINCT MIContainer.MovementItemId AS Id
                FROM ObjectDate AS ObjectDate_Value
                     INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                                    ON CLO_PartionGoods.ObjectId = ObjectDate_Value.ObjectId --CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                                   AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
                     INNER JOIN MovementItemContainer AS MIContainer
                                                      ON MIContainer.ContainerId = CLO_PartionGoods.ContainerId 
                                                     AND MIContainer.DescId = zc_MIContainer_Count() 
                                                     AND MIContainer.ObjectId_Analyzer = inGoodsId
                                                     AND MIContainer.WhereObjectId_analyzer = inUnitId
                     LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                   ON CLO_GoodsKind.ContainerId = CLO_PartionGoods.ContainerId
                                                  AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()                                              
                     INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                        AND Movement.DescId = zc_Movement_Send() 
                                      --  AND Movement.Id = 28742039 
                WHERE --ObjectDate_Value.ObjectId = Object_PartionGoods.Id
                      ObjectDate_Value.ValueData = inPartionGoodsDate  --'2024-07-15'
                  AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                  AND COALESCE (CLO_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)
              ) AS tmp 
         )
         
      , tmpProtocol_All AS (SELECT *
                            FROM (SELECT 
                                   -- № п/п
                                  ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate desc) AS Ord
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Объект"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS GoodsName
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS GoodsKindName
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS Amount
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS AmountPartner
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Цена"]                    /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')     AS Price
                                 , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ячейка-1"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_1
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
     
                                 --, REPLACE(REPLACE(CAST (XPATH ('/XML/Field[12]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS PartionCell_88
     
                                 , MovementItemProtocol.MovementItemId
                                 , MovementItemProtocol.OperDate
                                 , MovementItemProtocol.UserId
     
                             FROM MovementItemProtocol
                             WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             ) AS tmp                    
                     --      WHERE tmp.GoodsId = inGoodsId AND COALESCE (tmp.GoodsKindName, '') = COALESCE (vbGoodsKindName,'')
                            )
                             
, tmpCell_1 AS (SELECT DISTINCT tmp.Ord,  1 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_1, '') = '' OR COALESCE (tmp.PartionCell_1, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_1 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  2 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_2, '') = '' OR COALESCE (tmp.PartionCell_2, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_2 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  3 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_3, '') = '' OR COALESCE (tmp.PartionCell_3, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_3 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  4 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_4, '') = '' OR COALESCE (tmp.PartionCell_4, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_4 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  5 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_5, '') = '' OR COALESCE (tmp.PartionCell_5, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_5 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  6 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_6, '') = '' OR COALESCE (tmp.PartionCell_6, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_6 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  7 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_7, '') = '' OR COALESCE (tmp.PartionCell_7, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_7 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  8 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_8, '') = '' OR COALESCE (tmp.PartionCell_8, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_8 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  9 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_9, '') = '' OR COALESCE (tmp.PartionCell_9, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_9 END AS PartionCellName,  tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 10 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_10, '') = '' OR COALESCE (tmp.PartionCell_10, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_10 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 11 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_11, '') = '' OR COALESCE (tmp.PartionCell_11, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_11 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 12 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, CASE WHEN COALESCE (tmp.PartionCell_12, '') = '' OR COALESCE (tmp.PartionCell_12, '') = '"NULL"' THEN '' ELSE tmp.PartionCell_12 END AS PartionCellName, tmp.OperDate, tmp.MovementItemId, tmp.UserId  FROM tmpProtocol_All AS tmp                
                )

    SELECT DISTINCT tmpCell_old.OperDate AS OperDate_old
                  , tmpCell_new.OperDate AS OperDate_new
                  , tmpCell_old.MovementItemId 
                  , Object_User_old.ValueData AS UserName_old
                  , Object_User_new.ValueData AS UserName_new
                  , tmpCell_old.GoodsId
                  , tmpCell_old.GoodsName     ::TVarChar
                  , tmpCell_old.GoodsKindName ::TVarChar
                  , inPartionGoodsDate        AS PartionGoodsDate     
                  , Object_PartionCell_old.ObjectCode          AS PartionCellCode_old
                  , tmpCell_old.PartionCellName ::TVarChar     AS PartionCellName_old
                  , Object_PartionCell_new.ObjectCode          AS PartionCellCode_new
                  , tmpCell_new.PartionCellName ::TVarChar     AS PartionCellName_new
                  , tmpCell_old.Amount        ::TFloat
                  , ROW_NUMBER() OVER (PARTITION BY tmpCell_old.CellNum, tmpCell_old.MovementItemId ORDER BY tmpCell_old.OperDate ) ::Integer AS Ord --tmpCell_old.ord           ::Integer
                  , tmpCell_old.CellNum       ::Integer
    FROM tmpCell_1 AS tmpCell_old
         LEFT JOIN tmpCell_1 AS tmpCell_new ON tmpCell_old.GoodsId = tmpCell_new.GoodsId
                                           AND COALESCE (tmpCell_old.GoodsKindName,'') = COALESCE (tmpCell_new.GoodsKindName, '') 
                                           AND tmpCell_old.CellNum = tmpCell_new.CellNum
                                           AND tmpCell_old.Ord = tmpCell_new.Ord+1    -- and 1=0
                                           AND tmpCell_old.MovementItemId = tmpCell_new.MovementItemId   
         LEFT JOIN Object AS Object_PartionCell_old ON TRIM (Object_PartionCell_old.ValueData) = tmpCell_old.PartionCellName  
                         AND Object_PartionCell_old.DescId = zc_Object_PartionCell()

         LEFT JOIN Object AS Object_PartionCell_new ON TRIM (Object_PartionCell_new.ValueData) = tmpCell_new.PartionCellName  
                         AND Object_PartionCell_new.DescId = zc_Object_PartionCell()
        
         LEFT JOIN Object AS Object_User_old ON Object_User_old.Id = tmpCell_old.UserId
         LEFT JOIN Object AS Object_User_new ON Object_User_new.Id = tmpCell_new.UserId
         
    Where (tmpCell_new.PartionCellName <> tmpCell_old.PartionCellName OR tmpCell_new.GoodsId IS NULL)
        AND (COALESCE (tmpCell_new.PartionCellName, '') <> '' OR COALESCE (tmpCell_old.PartionCellName,'')<>'')

    ;
--select * from tmpCell_1


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.24         *
*/

-- тест
--select * from gpReport_PartionCell_history(inPartionGoodsDate := ('16.07.2024')::TDateTime , inGoodsId := 2116 , inGoodsKindId := 8346 ,  inSession := '9457');
--select * from gpReport_PartionCell_history(inPartionGoodsDate := ('17.07.2024')::TDateTime , inGoodsId := 2116 , inGoodsKindId := 8346 , inUnitId:= zc_Unit_RK(), inSession := '9457');
