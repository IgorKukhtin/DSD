-- Function: gpInsert_RemainsOLAPTable_peresort (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsert_RemainsOLAPTable_peresort (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_RemainsOLAPTable_peresort(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    --
    IN inSession            TVarChar 
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_RemainsOLAPTable());
   
     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE ('_tmpReport'))
     THEN
          DELETE FROM _tmpReport;
     ELSE
          -- выбираем данные из отчета
          CREATE TEMP TABLE _tmpReport (OperDate    TDateTime
                                      , UnitId      Integer
                                      , GoodsId     Integer
                                      , GoodsKindId Integer
                                      , AmountStart TFloat
                                       );
     END IF;
    

        WITH tmpContainer AS (SELECT Container.Id                         AS ContainerId
                                   , Container.ObjectId                   AS GoodsId
                                   , COALESCE (CLO_GoodsKind.ObjectId, 0) AS GoodsKindId
                                   , CLO_Unit.ObjectId                    AS UnitId
                                   , Container.Amount                     AS Amount
                              FROM Container
                                   INNER JOIN ContainerLinkObject AS CLO_Unit
                                                                  ON CLO_Unit.ContainerId = Container.Id
                                                                 AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                                                                 AND CLO_Unit.ObjectId    = inUnitId
                                   LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                                 ON CLO_GoodsKind.ContainerId = Container.Id
                                                                AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                                   LEFT JOIN ContainerLinkObject AS CLO_Account
                                                                 ON CLO_Account.ContainerId = Container.Id
                                                                AND CLO_Account.DescId      = zc_ContainerLinkObject_Account()
                              WHERE Container.DescId = zc_Container_Count()
                                -- без Товар в пути
                                AND CLO_Account.ObjectId IS NULL
                             )                       
         , tmpMIContainer AS (SELECT tmpContainer.ContainerId
                                   , tmpContainer.GoodsId
                                   , tmpContainer.GoodsKindId
                                   , tmpContainer.UnitId
                                   , tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) AS Amount
                              FROM tmpContainer
                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                                  AND MIContainer.DescId      = zc_MIContainer_Count()
                                                                  AND MIContainer.OperDate    >= inStartDate
                              GROUP BY tmpContainer.ContainerId
                                     , tmpContainer.GoodsId
                                     , tmpContainer.GoodsKindId
                                     , tmpContainer.UnitId
                                     , tmpContainer.Amount
                              HAVING tmpContainer.Amount - COALESCE (SUM (COALESCE (MIContainer.Amount, 0)), 0) <> 0
                             )
      --
      INSERT INTO _tmpReport (OperDate, UnitId, GoodsId, GoodsKindId, AmountStart)
          SELECT inStartDate
               , tmpMIContainer.UnitId
               , tmpMIContainer.GoodsId
               , tmpMIContainer.GoodsKindId
               , SUM (tmpMIContainer.Amount)
          FROM tmpMIContainer
          GROUP BY tmpMIContainer.UnitId
                 , tmpMIContainer.GoodsId
                 , tmpMIContainer.GoodsKindId
         ;


     -- удаляем 
     DELETE FROM RemainsOLAPTable
     WHERE RemainsOLAPTable.UnitId      = inUnitId
       AND RemainsOLAPTable.OperDate    = inStartDate
       AND RemainsOLAPTable.GoodsId     IN (SELECT RemainsOLAPTable.GoodsId
                                            FROM RemainsOLAPTable
                                                 LEFT JOIN _tmpReport
                                                        ON _tmpReport.GoodsId     = RemainsOLAPTable.GoodsId
                                                       AND _tmpReport.GoodsKindId = RemainsOLAPTable.GoodsKindId
                                                       AND _tmpReport.UnitId      = RemainsOLAPTable.UnitId
                                                       AND _tmpReport.OperDate    = RemainsOLAPTable.OperDate
                                            WHERE RemainsOLAPTable.OperDate = inStartDate
                                              AND _tmpReport.GoodsId IS NULL
                                           );

     -- Обновляем то что уже есть
     UPDATE RemainsOLAPTable SET AmountStart = _tmpReport.AmountStart
     FROM _tmpReport
     WHERE _tmpReport.GoodsId     = RemainsOLAPTable.GoodsId
       AND _tmpReport.GoodsKindId = RemainsOLAPTable.GoodsKindId
       AND _tmpReport.UnitId      = RemainsOLAPTable.UnitId
       AND _tmpReport.OperDate    = RemainsOLAPTable.OperDate
      ;
     
     -- добавляем новые
     INSERT INTO RemainsOLAPTable (OperDate, UnitId, GoodsId, GoodsKindId, AmountStart)
      SELECT _tmpReport.OperDate
           , _tmpReport.UnitId
           , _tmpReport.GoodsId
           , _tmpReport.GoodsKindId
           , _tmpReport.AmountStart
      FROM _tmpReport
           LEFT JOIN RemainsOLAPTable ON _tmpReport.GoodsId     = RemainsOLAPTable.GoodsId
                                     AND _tmpReport.GoodsKindId = RemainsOLAPTable.GoodsKindId
                                     AND _tmpReport.UnitId      = RemainsOLAPTable.UnitId
                                     AND _tmpReport.OperDate    = RemainsOLAPTable.OperDate
      WHERE RemainsOLAPTable.GoodsId IS NULL
     ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.08.19         *
*/

-- тест
-- SELECT *, gpInsert_RemainsOLAPTable_peresort('01.02.2023', '01.02.2023', ObjectId, '5') FROM (SELECT OL.ObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Branch() AND OL.ChildObjectId <> zc_Branch_Basis() AND OL.ChildObjectId > 0 UNION SELECT 8459 AS ObjectId) AS tmp
