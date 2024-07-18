-- Function: gpReport_PartionCell_history ()

DROP FUNCTION IF EXISTS gpReport_PartionCell_history (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, TVarChar);

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

             , PartionCellName   TVarChar
             , Amount TFloat
             , Ord Integer
             , CellNum Integer
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
BEGIN
     vbUserId:= lpGetUserBySession (inSession);

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
              INNER JOIN Movement ON Movement.Id = MIContainer.MovementId
                                 AND Movement.DescId = zc_Movement_Send() 
                               --  AND Movement.Id = 28742039 
         WHERE --ObjectDate_Value.ObjectId = Object_PartionGoods.Id
               ObjectDate_Value.ValueData = inPartionGoodsDate  --'2024-07-15'
           AND ObjectDate_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
         )
         
      , tmpProtocol_All AS ( SELECT
                              -- № п/п
                             ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate asc) AS Ord
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Ключ объекта"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','') ::integer   AS GoodsId
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Объект"]                  /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')    AS GoodsName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Виды товаров"]            /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS GoodsKindName
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Значение"]                /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Amount
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Количество у контрагента"]/@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS AmountPartner
                            , REPLACE(REPLACE(CAST (XPATH ('/XML/Field[@FieldName = "Цена"]                    /@FieldValue', MovementItemProtocol.ProtocolData :: XML) AS TEXT), '{', ''), '}','')   AS Price
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
                             )
                             
, tmpCell_1 AS (SELECT tmp.Ord,  1 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_1,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  2 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_2,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  3 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_3,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  4 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_4,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  5 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_5,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  6 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_6,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  7 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_7,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  8 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_8,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord,  9 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_9,  tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord, 10 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_10, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord, 11 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_11, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp
          UNION SELECT tmp.Ord, 12 AS CellNum, tmp.GoodsId, tmp.GoodsName, tmp.GoodsKindName, tmp.Amount, tmp.PartionCell_12, tmp.OperDate, tmp.MovementItemId FROM tmpProtocol_All AS tmp                
                )

    SELECT tmpCell_old.OperDate
         , tmpCell_old.MovementItemId
         , tmpCell_old.GoodsId
         , tmpCell_old.GoodsName     ::TVarChar
         , tmpCell_old.GoodsKindName ::TVarChar
         , inPartionGoodsDate        AS PartionGoodsDate 
         , tmpCell_old.PartionCell_1 ::TVarChar AS PartionCellName
         , tmpCell_old.Amount        ::TFloat
         , tmpCell_old.ord           ::Integer
         , tmpCell_old.CellNum       ::Integer
    FROM tmpCell_1 AS tmpCell_old
         LEFT JOIN tmpCell_1 AS tmpCell_new ON tmpCell_old.GoodsId = tmpCell_new.GoodsId
                                           AND COALESCE (tmpCell_old.GoodsKindName,'') = COALESCE (tmpCell_new.GoodsKindName, '') 
                                           AND tmpCell_old.CellNum = tmpCell_new.CellNum
                                           AND tmpCell_old.Ord-1 = tmpCell_new.Ord    -- and 1=0
    Where (tmpCell_new.PartionCell_1 <> tmpCell_old.PartionCell_1 OR tmpCell_new.GoodsId IS NULL)
        AND (COALESCE (tmpCell_new.PartionCell_1, '') <> '' OR COALESCE (tmpCell_old.PartionCell_1,'')<>'')

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
--SELECT * FROM gpReport_PartionCell_history (inPartionGoodsDate:= '07.07.2024'::TDateTime, inGoodsId:= 0, inGoodsKindId := 0, inSession:= zfCalc_UserAdmin()); -- Склад Реализации