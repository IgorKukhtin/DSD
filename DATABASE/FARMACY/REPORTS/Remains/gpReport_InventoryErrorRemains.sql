-- Function:  gpReport_InventoryErrorRemains()

DROP FUNCTION IF EXISTS gpReport_InventoryErrorRemains (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_InventoryErrorRemains(
    IN inDateStart         TDateTime,  -- Дата начала
    IN inDateFinal         TDateTime,  -- Двта конца
    IN inUnitID            Integer,    -- Подразделение
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     CREATE TEMP TABLE tmpMovementItemAll ON COMMIT DROP AS

     (WITH tmpInventory AS (SELECT Movement.Id
                                 , Movement.OperDate
                                 , MovementLinkObject_Unit.ObjectId AS UnitId
                                 , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS isFullInvent
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                 LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                                 ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                                AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                            WHERE Movement.OperDate BETWEEN inDateStart AND inDateFinal
                              AND Movement.DescId = zc_Movement_Inventory()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND (MovementLinkObject_Unit.ObjectId = inUnitID OR inUnitID = 0)
                            ),
           tmpInventoryList AS (SELECT Movement.Id
                                     , Movement.OperDate
                                     , Movement.UnitId
                                     , MovementItem.ID           AS MovementItemID
                                     , MovementItem.ObjectId     AS GoodsId
                                     , MovementItem.Amount
                                FROM tmpInventory AS Movement
                                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                WHERE MovementItem.isErased = FALSE
                                  AND MovementItem.DescId = zc_MI_Master()
                                ),
           tmpRemansAll AS (SELECT tmpInventoryList.MovementItemID
                                 , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                            FROM tmpInventoryList
                                 INNER JOIN Container ON Container.ObjectId = tmpInventoryList.GoodsId
                                                     AND Container.WhereObjectId = tmpInventoryList.UnitID
                                                     AND Container.DescID = zc_Container_Count()

                                 LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                      AND MovementItemContainer.Operdate >= tmpInventoryList.OperDate + INTERVAL '1 DAY'
                            GROUP BY Container.ID, tmpInventoryList.MovementItemID
                            HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                            UNION ALL
                            -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                            SELECT
                                 tmpInventoryList.MovementItemID
                               , -1 * SUM (MovementItemContainer.Amount) AS Amount
                            FROM tmpInventoryList
                                 INNER JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = tmpInventoryList.MovementItemID
                                                                 AND MovementItemContainer.DescID = zc_MIContainer_Count()
                            GROUP BY tmpInventoryList.MovementItemID
                           ),
           tmpRemans AS (SELECT tmpRemansAll.MovementItemID
                              , SUM (tmpRemansAll.Amount) AS Amount
                         FROM tmpRemansAll
                         GROUP BY tmpRemansAll.MovementItemID
                         HAVING SUM (tmpRemansAll.Amount) <> 0),
           tmpRemansAllFull AS (SELECT tmpInventory.ID
                                 , Container.ID AS ContainerID
                                 , Container.ObjectId
                                 , Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0.0) AS Amount
                            FROM tmpInventory
                                 INNER JOIN Container ON Container.WhereObjectId = tmpInventory.UnitID
                                                     AND Container.DescID = zc_Container_Count()

                                 LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                      AND MovementItemContainer.Operdate >= tmpInventory.OperDate + INTERVAL '1 DAY'
                            WHERE tmpInventory.isFullInvent = True
                            GROUP BY tmpInventory.ID
                                 , Container.ID
                                 , Container.ObjectId
                                 , Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MovementItemContainer.Amount), 0) <> 0

                            UNION ALL
                            -- надо минуснуть то что в проводках (тогда получим расчетный остаток, при этом фактический - это тот что вводит пользователь)
                            SELECT
                                 tmpInventory.ID
                               , Container.ID AS ContainerID
                               , Container.ObjectId
                               , -1 * SUM (MovementItemContainer.Amount) AS Amount
                            FROM tmpInventory
                                 INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = tmpInventory.ID
                                                                 AND MovementItemContainer.DescID = zc_MIContainer_Count()
                                 INNER JOIN Container ON Container.ID = MovementItemContainer.ContainerID
                            GROUP BY tmpInventory.ID
                                   , Container.ID
                                   , Container.ObjectId
                           ),
           tmpRemansFull AS (SELECT tmpRemansAllFull.ID
                              , tmpRemansAllFull.ObjectId
                              , SUM (tmpRemansAllFull.Amount) AS Amount
                         FROM tmpRemansAllFull
                         GROUP BY tmpRemansAllFull.ID
                                , tmpRemansAllFull.ObjectId
                         HAVING SUM (tmpRemansAllFull.Amount) <> 0
                         )

       SELECT tmpInventoryList.Id
            , tmpInventoryList.OperDate
            , tmpInventoryList.UnitId
            , tmpInventoryList.MovementItemID
            , tmpInventoryList.GoodsId
            , tmpInventoryList.Amount
            , tmpRemans.Amount            AS Remains
            , MIFloat_Remains.ValueData   AS RemainsSave
            , Null::TFloat                AS Price
       FROM tmpInventoryList
            INNER JOIN MovementItemFloat AS MIFloat_Remains
                                         ON MIFloat_Remains.MovementItemId = tmpInventoryList.MovementItemId
                                        AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
            LEFT JOIN tmpRemans ON tmpRemans.MovementItemID = tmpInventoryList.MovementItemID
       WHERE MIFloat_Remains.ValueData <> COALESCE(tmpRemans.Amount, 0)
         AND tmpInventoryList.Id IN (SELECT tmpInventory.Id FROM tmpInventory WHERE tmpInventory.isFullInvent = False)
       UNION ALL 
       SELECT tmpInventory.Id
            , tmpInventory.OperDate
            , tmpInventory.UnitId
            , tmpInventoryList.MovementItemID
            , COALESCE(tmpRemansFull.ObjectId, tmpInventoryList.GoodsId) AS GoodsId
            , tmpInventoryList.Amount
            , tmpRemansFull.Amount            AS Remains
            , MIFloat_Remains.ValueData   AS RemainsSave
            , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
       FROM tmpRemansFull 
                   
            FULL JOIN tmpInventoryList ON tmpInventoryList.Id = tmpRemansFull.Id
                                      AND tmpInventoryList.GoodsId = tmpRemansFull.ObjectId
            
            LEFT JOIN tmpInventory ON tmpInventory.Id = COALESCE (tmpRemansFull.Id, tmpInventoryList.Id)

            LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                        ON MIFloat_Remains.MovementItemId = tmpInventoryList.MovementItemId
                                       AND MIFloat_Remains.DescId = zc_MIFloat_Remains()
                                       
            INNER JOIN ObjectLink AS ObjectLink_Price_Unit 
                                  ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                 AND ObjectLink_Price_Unit.ChildObjectId = tmpInventory.UnitId
            
            INNER JOIN ObjectLink AS Price_Goods
                                  ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Goods.ChildObjectId = COALESCE(tmpRemansFull.ObjectId, tmpInventoryList.GoodsId)
                                 AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
            LEFT JOIN ObjectFloat AS Price_Value
                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                 AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                                       
                                       
       WHERE tmpInventory.isFullInvent = True
         AND COALESCE(MIFloat_Remains.ValueData, 0) <> COALESCE(tmpRemansFull.Amount, 0)
            );


     OPEN cur1 FOR
     WITH tmpMovement_calc AS (SELECT Movement.Id
                                    , SUM (MovementItemContainer.Amount) AS Diff
                                    , SUM (CASE WHEN MovementItemContainer.Amount < 0 THEN -1 * MovementItemContainer.Amount * COALESCE (MovementItemFloat.ValueData, 0) ELSE 0 END) AS DeficitSumm
                                    , SUM (CASE WHEN MovementItemContainer.Amount > 0 THEN  1 * MovementItemContainer.Amount * COALESCE (MovementItemFloat.ValueData, 0) ELSE 0 END) AS ProficitSumm
                               FROM Movement
                                    INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                                                    AND MovementItemContainer.DescId     = zc_MIContainer_Count()
                                    LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItemContainer.MovementItemId
                                                               AND MovementItemFloat.DescId         = zc_MIFloat_Price()
                               WHERE Movement.OperDate BETWEEN inDateStart AND inDateFinal
                                 AND Movement.DescId = zc_Movement_Inventory()
                               GROUP BY Movement.Id
                              )
       -- Результат
       SELECT
             Movement.Id                                          AS Id
           , Movement.InvNumber                                   AS InvNumber
           , Movement.OperDate                                    AS OperDate
           , MovementFloat_DeficitSumm.ValueData                  AS DeficitSumm
           , MovementFloat_ProficitSumm.ValueData                 AS ProficitSumm
           , MovementFloat_Diff.ValueData                         AS Diff
           , MovementFloat_DiffSumm.ValueData                     AS DiffSumm
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName
           , COALESCE(MovementBoolean_FullInvent.ValueData,False) AS FullInvent

           , tmpMovement_calc.Diff         :: TFloat AS Diff_calc
           , tmpMovement_calc.DeficitSumm  :: TFloat AS DeficitSumm_calc
           , tmpMovement_calc.ProficitSumm :: TFloat AS ProficitSumm_calc
           , (tmpMovement_calc.ProficitSumm - tmpMovement_calc.DeficitSumm) :: TFloat AS DiffSumm_calc
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       FROM (SELECT DISTINCT tmpMovementItemAll.Id
                  , tmpMovementItemAll.OperDate
                  , tmpMovementItemAll.UnitId
             FROM tmpMovementItemAll
            ) AS tmpMovement
            LEFT JOIN tmpMovement_calc ON tmpMovement_calc.Id = tmpMovement.Id
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId

            LEFT OUTER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                            ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                           AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()

            LEFT OUTER JOIN MovementFloat AS MovementFloat_DeficitSumm
                                          ON MovementFloat_DeficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_DeficitSumm.DescId = zc_MovementFloat_TotalDeficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProficitSumm
                                          ON MovementFloat_ProficitSumm.MovementId = Movement.Id
                                         AND MovementFloat_ProficitSumm.DescId = zc_MovementFloat_TotalProficitSumm()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Diff
                                          ON MovementFloat_Diff.MovementId = Movement.Id
                                         AND MovementFloat_Diff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_DiffSumm
                                          ON MovementFloat_DiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_DiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
--            WHERE MovementFloat_Diff.ValueData  <> tmpMovement_calc.Diff
            ;
     RETURN NEXT cur1;

     OPEN cur2 FOR
/*       WITH tmpPrice AS (SELECT tmpMovementItemAll.GoodsId              AS GoodsId
                              , tmpMovementItemAll.UnitId               AS UnitId
                              , ROUND(Price_Value.ValueData,2)::TFloat  AS Price
                         FROM tmpMovementItemAll
                              INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                    ON ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                                                   AND ObjectLink_Price_Unit.ChildObjectId = tmpMovementItemAll.UnitId
                              INNER JOIN ObjectLink AS Price_Goods
                                      ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                     AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                     AND Price_Goods.ChildObjectId = tmpMovementItemAll.GoodsId
                              LEFT JOIN ObjectFloat AS Price_Value
                                     ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                    AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                        )
*/
       SELECT tmpMovementItemAll.Id                AS MovementID
            , tmpMovementItemAll.MovementItemID    AS Id
            , tmpMovementItemAll.GoodsId
            , Object_Goods.ObjectCode              AS GoodsCode
            , (CASE WHEN tmpMovementItemAll.MovementItemID > 0 THEN '' ELSE '***' END || Object_Goods.ValueData) :: TVarChar AS GoodsName
            , tmpMovementItemAll.Amount
            , tmpMovementItemAll.Remains
            , tmpMovementItemAll.RemainsSave
            , MIFloat_Price.ValueData              AS Price
            , (COALESCE(tmpMovementItemAll.Remains, 0)
              - COALESCE(tmpMovementItemAll.RemainsSave, 0))::TFloat AS RemainsDiff
            , ((COALESCE(tmpMovementItemAll.Remains, 0)
              - COALESCE(tmpMovementItemAll.RemainsSave, 0)) * 
              CASE WHEN tmpMovementItemAll.MovementItemID > 0 THEN MIFloat_Price.ValueData ELSE tmpMovementItemAll.Price END
              )::TFloat AS RemainsDiff_Summa
       FROM tmpMovementItemAll
            INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMovementItemAll.GoodsId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMovementItemAll.MovementItemID
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

/*            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpMovementItemAll.GoodsId
                              AND tmpPrice.UnitId = tmpMovementItemAll.UnitId
*/       ;
     RETURN NEXT cur2;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.01.20                                                       *

*/

-- тест
-- SELECT * FROM gpReport_InventoryErrorRemains (inDateStart:= '01.01.2020'::TDateTime, inDateFinal:= '31.01.2020'::TDateTime, inUnitID := 8393158, inSession:= zfCalc_UserAdmin())


select * from gpReport_InventoryErrorRemains(inDateStart := ('15.09.2023')::TDateTime , inDateFinal := ('20.09.2023')::TDateTime , inUnitId := 9771036 ,  inSession := '3');