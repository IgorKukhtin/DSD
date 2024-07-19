-- Function: gpReport_PartionCell_history ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_history (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_history (
    IN inPartionGoodsDate         TDateTime ,
    IN inGoodsId                  Integer   ,
    IN inGoodsKindId              Integer   , 
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , MovementItemId Integer
             , GoodsId Integer, GoodsName TVarChar
             , GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , PartionCellCode   Integer
             , PartionCellName   TVarChar
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
tmpMI AS (
        /* SELECT MovementItem.Id
         FROM MovementItemDate  
              INNER JOIN MovementItem ON MovementItem.Id = MovementItemDate.MovementItemId
                                     AND MovementItem.DescId = zc_MI_Master()
                                     AND MovementItem.isErased = FALSE  
                                    -- AND MovementItem.MovementId = 28742039
              INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                 AND Movement.DescId = zc_Movement_Send()    
                               --  AND Movement.Id = 28742039 
         WHERE MovementItemDate.ValueData = inPartionGoodsDate --'2024-07-15'
           AND MovementItemDate.DescId = zc_MIDate_PartionGoods()   
           */
           
         SELECT DISTINCT MIContainer.MovementItemId AS Id
         FROM ObjectDate AS ObjectDate_Value
              INNER JOIN ContainerLinkObject AS CLO_PartionGoods
                                             ON CLO_PartionGoods.ObjectId = ObjectDate_Value.ObjectId --CLO_PartionGoods.ContainerId = MIContainer.ContainerId
                                            AND CLO_PartionGoods.DescId      = zc_ContainerLinkObject_PartionGoods()
              INNER JOIN MovementItemContainer AS MIContainer
                                               ON MIContainer.ContainerId = CLO_PartionGoods.ContainerId 
                                              AND MIContainer.DescId = zc_MIContainer_Count() 
                                              AND MIContainer.ObjectId_Analyzer = inGoodsId
              LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                            ON CLO_GoodsKind.ContainerId = CLO_PartionGoods.ContainerId
                                           AND CLO_GoodsKind.DescId = zc_ContainerLinkObject_GoodsKind()                                              
              INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                 AND Movement.DescId = zc_Movement_Send() 
                               --  AND Movement.Id = 28742039 
         WHERE --ObjectDate_Value.ObjectId = Object_PartionGoods.Id
               ObjectDate_Value.ValueData = inPartionGoodsDate  --'2024-07-15'
           AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
         --  AND COALESCE (CLO_GoodsKind.ObjectId,0) = COALESCE (inGoodsKindId,0)
         )
         
      , tmpProtocol_All AS (SELECT *
                            FROM (SELECT 
                                   -- № п/п
                                  ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate asc) AS Ord
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
     
                             FROM MovementItemProtocol
                             WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             ) AS tmp                    
                     --      WHERE tmp.GoodsId = inGoodsId AND COALESCE (tmp.GoodsKindName, '') = COALESCE (vbGoodsKindName,'')
                            )
                             
, tmpCell_1 AS (SELECT DISTINCT tmp.Ord,  1 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_1 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  2 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_2 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  3 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_3 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  4 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_4 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  5 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_5 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  6 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_6 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  7 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_7 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  8 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_8 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord,  9 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_9 AS PartionCellName,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 10 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_10 AS PartionCellName, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 11 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_11 AS PartionCellName, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT DISTINCT tmp.Ord, 12 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_12 AS PartionCellName, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp                
                )

    SELECT DISTINCT tmpCell_old.OperDate
         , tmpCell_old.MovementItemId
         , tmpCell_old.GoodsId
         , tmpCell_old.GoodsName     ::TVarChar
         , tmpCell_old.GoodsKindName ::TVarChar
         , inPartionGoodsDate        AS PartionGoodsDate     
         , Object_PartionCell.ObjectCode              AS PartionCellCode
         , tmpCell_old.PartionCellName ::TVarChar
         , tmpCell_old.Amount        ::TFloat
         , tmpCell_old.ord           ::Integer
         , tmpCell_old.CellNum       ::Integer
    FROM tmpCell_1 AS tmpCell_old
         LEFT JOIN tmpCell_1 AS tmpCell_new ON tmpCell_old.GoodsId = tmpCell_new.GoodsId
                                           AND COALESCE (tmpCell_old.GoodsKindName,'') = COALESCE (tmpCell_new.GoodsKindName, '') 
                                           AND tmpCell_old.CellNum = tmpCell_new.CellNum
                                           AND tmpCell_old.Ord-1 = tmpCell_new.Ord    -- and 1=0  
         LEFT JOIN Object AS Object_PartionCell ON TRIM (Object_PartionCell.ValueData) = tmpCell_old.PartionCellName  
                         AND Object_PartionCell.DescId = zc_Object_PartionCell()
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
--select * from gpReport_PartionCell_history(inPartionGoodsDate := ('17.07.2024')::TDateTime , inGoodsId := 2116 , inGoodsKindId := 8346 ,  inSession := '9457');