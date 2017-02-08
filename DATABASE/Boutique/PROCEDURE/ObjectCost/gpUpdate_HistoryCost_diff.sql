-- Function: gpUpdate_HistoryCost_diff()

DROP FUNCTION IF EXISTS gpUpdate_HistoryCost_diff (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_HistoryCost_diff(
    IN inStartDate       TDateTime , --
    IN inEndDate         TDateTime , --
    IN inIsUpdate        Boolean   , --
    IN inSession         TVarChar    -- сессия пользователя
)                              
--  RETURNS VOID
  RETURNS TABLE (OperDate TDateTime, ContainerId Integer, MovementItemId Integer, Amount TFloat, Amount_diff TFloat)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_InsertUpdate_HistoryCost());

     RETURN; 
     -- IF inIsUpdate = TRUE THEN RETURN; END IF;

     -- таблица - Список
     CREATE TEMP TABLE _tmpDiff (OperDate TDateTime, ContainerId Integer, MovementItemId Integer, Amount TFloat, Amount_diff TFloat) ON COMMIT DROP;

     -- заполняем таблицу
        WITH tmpContainerSumm AS (-- остатки по Сумме
                                  SELECT Container_Summ.Id AS ContainerId, Container_Summ.ParentId, Container_Summ.ObjectId
                                       , Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount_end
                                  FROM Container AS Container_Summ
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container_Summ.Id
                                                                      AND MIContainer.OperDate > inEndDate
                                  WHERE Container_Summ.DescId = zc_Container_Summ()
                                    AND Container_Summ.ParentId > 0
                                    AND Container_Summ.ObjectId <> zc_Enum_Account_110101() -- Транзит + товар в пути
                                  GROUP BY Container_Summ.Id, Container_Summ.ParentId, Container_Summ.Amount, Container_Summ.ObjectId
                                  HAVING Container_Summ.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                                 )
          , tmpContainerCount AS (-- остатки по Кол-ву = 0
                                  SELECT Container.Id AS ContainerId
                                  FROM (SELECT tmpContainerSumm.ParentId AS ContainerId FROM tmpContainerSumm GROUP BY tmpContainerSumm.ParentId) AS tmp
                                       INNER JOIN Container ON Container.Id = tmp.ContainerId
                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = tmp.ContainerId
                                                                      AND MIContainer.OperDate > inEndDate
                                  GROUP BY Container.Id, Container.Amount
                                  HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) = 0
                                 )
       , tmpContainer_all AS (-- остатки по сумме <> 0 AND Кол-ву = 0, т.е. "зависшие" копейки
                              SELECT tmpContainerCount.ContainerId AS ContainerId_count, tmpContainerSumm.ContainerId, tmpContainerSumm.Amount_end AS Amount_diff
                              FROM tmpContainerCount
                                   INNER JOIN tmpContainerSumm ON tmpContainerSumm.ParentId = tmpContainerCount.ContainerId
                             )
           , tmpContainer AS (SELECT DISTINCT tmpContainer_all.ContainerId_count FROM tmpContainer_all
                             )
             , tmpListAll AS (-- 
                              SELECT tmpContainer.ContainerId_count, MIContainer.Id, MIContainer.MovementDescId, MIContainer.Amount
                              FROM tmpContainer
                                   INNER JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.ContainerId = tmpContainer.ContainerId_count
                                                                   AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                                                                   AND (MIContainer.isActive = FALSE OR MIContainer.MovementDescId = zc_Movement_Inventory())
                                                                   -- AND ABS (MIContainer.Amount) >= tmpContainer.Amount_diff
                             )
      , tmpList_Summ_sale AS (-- 
                              SELECT tmpListAll.ContainerId_count
                                   , MAX (ABS (tmpListAll.Amount)) AS Amount
                              FROM tmpListAll
                              WHERE tmpListAll.MovementDescId IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_ReturnOut())
                              GROUP BY tmpListAll.ContainerId_count
                             )
         , tmpListMI_sale AS (-- 
                              SELECT tmpListAll.ContainerId_count, MAX (tmpListAll.Id) AS Id
                              FROM tmpList_Summ_sale
                                   INNER JOIN tmpListAll ON tmpListAll.ContainerId_count  = tmpList_Summ_sale.ContainerId_count
                                                        AND ABS (tmpListAll.Amount) = ABS (tmpList_Summ_sale.Amount)
                                                        AND tmpListAll.MovementDescId IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_ReturnOut())
                              GROUP BY tmpListAll.ContainerId_count
                             )

       , tmpList_Summ_all AS (-- 
                              SELECT tmpListAll.ContainerId_count
                                   , MAX (ABS (tmpListAll.Amount)) AS Amount
                              FROM tmpListAll
                              WHERE tmpListAll.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_Inventory(), zc_Movement_ReturnOut())
                              GROUP BY tmpListAll.ContainerId_count
                             )
          , tmpListMI_all AS (-- 
                              SELECT tmpListAll.ContainerId_count, MAX (tmpListAll.Id) AS Id
                              FROM tmpList_Summ_all
                                   INNER JOIN tmpListAll ON tmpListAll.ContainerId_count  = tmpList_Summ_all.ContainerId_count
                                                        AND ABS (tmpListAll.Amount) = ABS (tmpList_Summ_all.Amount)
                                                        AND tmpListAll.MovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_Loss(), zc_Movement_Inventory(), zc_Movement_ReturnOut())
                              GROUP BY tmpListAll.ContainerId_count
                             )

       , tmpList_Summ_inv AS (-- 
                              SELECT tmpListAll.ContainerId_count
                                   , MAX (ABS (tmpListAll.Amount)) AS Amount
                              FROM tmpListAll
                              WHERE tmpListAll.MovementDescId IN (zc_Movement_Inventory())
                              GROUP BY tmpListAll.ContainerId_count
                             )
          , tmpListMI_inv AS (-- 
                              SELECT tmpListAll.ContainerId_count, MAX (tmpListAll.Id) AS Id
                              FROM tmpList_Summ_inv
                                   INNER JOIN tmpListAll ON tmpListAll.ContainerId_count  = tmpList_Summ_inv.ContainerId_count
                                                        AND ABS (tmpListAll.Amount) = ABS (tmpList_Summ_inv.Amount)
                                                        AND tmpListAll.MovementDescId IN (zc_Movement_Inventory())
                              GROUP BY tmpListAll.ContainerId_count
                             )

     -- Результат
         INSERT INTO _tmpDiff (OperDate, ContainerId, MovementItemId, Amount, Amount_diff)
            SELECT MIContainer.OperDate, tmpContainer_all.ContainerId, MIContainer.MovementItemId, MIContainer_summ.Amount, tmpContainer_all.Amount_diff
            FROM tmpContainer_all
                 LEFT JOIN tmpListMI_sale ON tmpListMI_sale.ContainerId_count = tmpContainer_all.ContainerId_count
                 LEFT JOIN tmpListMI_inv  ON tmpListMI_inv.ContainerId_count  = tmpContainer_all.ContainerId_count
                 LEFT JOIN tmpListMI_all  ON tmpListMI_all.ContainerId_count  = tmpContainer_all.ContainerId_count
                 LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.Id = COALESCE (tmpListMI_sale.Id, COALESCE (tmpListMI_inv.Id, tmpListMI_all.Id))
                 LEFT JOIN MovementItemContainer AS MIContainer_summ ON MIContainer_summ.MovementItemId = MIContainer.MovementItemId
                                                                    AND MIContainer_summ.MovementId = MIContainer.MovementId
                                                                    AND MIContainer_summ.ContainerId = tmpContainer_all.ContainerId
                                                                    AND inIsUpdate = FALSE
       ;

     IF inIsUpdate = TRUE
     THEN
          -- Обнулили
          UPDATE HistoryCost SET MovementItemId_diff = NULL
                               , Summ_diff           = NULL
          WHERE inStartDate >= HistoryCost.StartDate AND inEndDate <= HistoryCost.EndDate
            AND Summ_diff <> 0
            ;
          -- Сохранили
          UPDATE HistoryCost SET MovementItemId_diff = _tmpDiff.MovementItemId
                               , Summ_diff           = _tmpDiff.Amount_diff
          FROM _tmpDiff
          WHERE HistoryCost.ContainerId = _tmpDiff.ContainerId
           AND _tmpDiff.OperDate BETWEEN HistoryCost.StartDate AND HistoryCost.EndDate
            ;
          -- Результат
          /*RETURN QUERY
             SELECT * FROM _tmpDiff
            ;*/
     ELSE
          -- Результат
          RETURN QUERY
             SELECT * FROM _tmpDiff
            ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.15                                        *
*/

-- SELECT MovementDesc.Code, Count(*), SUM (Summ_diff) FROM HistoryCost
--               LEFT JOIN MovementItem ON MovementItem.Id = MovementItemId_diff LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE StartDate= '01.08.2015' GROUP BY MovementDesc.Code
-- SELECT MovementDesc.Code, Count(*), SUM (Amount_diff) FROM gpUpdate_HistoryCost_diff (inStartDate:= '01.07.2015', inEndDate:= '31.07.2015', inIsUpdate:= FALSE, inSession:= zfCalc_UserAdmin()) AS a
--               LEFT JOIN MovementItem ON MovementItem.Id = MovementItemId LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId GROUP BY MovementDesc.Code
-- SELECT * FROM gpUpdate_HistoryCost_diff (inStartDate:= '01.07.2015', inEndDate:= '31.07.2015', inIsUpdate:= FALSE, inSession:= zfCalc_UserAdmin()) AS a
-- WHERE ContainerId in (179397, 156105)
