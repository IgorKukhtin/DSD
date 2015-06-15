-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpSelect_GoodsPartionMove (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionMove(
    IN inPartyId          Integer  ,  -- Партия
    IN inGoodsId          Integer  ,  -- Товар
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала периода
    IN inEndDate          TDateTime,  -- Дата окончания периода
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE ( PartyId Integer, OperDate TDateTime, InvNumber TVarChar
              , GoodsId integer, GoodsCode Integer, GoodsName TVarChar
              , StartRemainsAmount TFloat, IncomeAmount TFloat
              , OutcomeAmount TFloat, EndRemainsAmount TFloat)--, Price TFloat, OperSum TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH containerCount AS (SELECT container.Id, 
                                container.Amount, 
                                container.ObjectId AS GoodsId,
                                CLO_Party.ObjectId AS PartyId,
                                CLO_Unit.ObjectId  AS UnitId

                              FROM container  
                          LEFT JOIN containerlinkobject AS CLO_Unit
                                 ON CLO_Unit.containerid = container.id AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()

                               JOIN containerlinkobject AS CLO_Party
                                 ON CLO_Party.containerid = container.id AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                                 
              WHERE container.descid = zc_container_count() AND 
                ((CLO_Unit.objectid = inUnitId) or (0 = inUnitId)) AND
                ((container.ObjectID = inGoodsId) or (0 = inGoodsId)) AND
                ((CLO_Party.ObjectID = inPartyId) or (0 = inPartyId))
                            )

       SELECT 
              DD.PartyId
            , Movement.OperDate
            , Movement.InvNumber
            , DD.GoodsId 
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , DD.StartRemainsAmount::TFloat
            , DD.IncomeAmount::TFloat
            , DD.OutcomeAmount::TFloat
            , DD.EndRemainsAmount::TFloat
         FROM-- (
--         SELECT SUM(DD.OperAmount) AS OperAmount, SUM(DD.OperSum) AS OperSum, ObjectId
  --         FROM
               (SELECT SUM(DD.Amount - DD.OperAmount) AS StartRemainsAmount
                     , SUM(DD.IncomeAmount) AS IncomeAmount
                     , SUM(DD.OutcomeAmount) AS OutcomeAmount
                     , SUM(DD.Amount - DD.OperAmount + DD.IncomeAmount - DD.OutcomeAmount) AS EndRemainsAmount
                     , DD.GoodsId 
                     , DD.PartyId
                     , DD.UnitId
                  FROM
                  (SELECT containerCount.Amount, COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount,
                          COALESCE(SUM(CASE 
                                      WHEN (MIContainer.OperDate <= inEndDate) AND (MIContainer.Amount > 0)
                                         THEN MIContainer.Amount
                                         ELSE 0
                                      END)) AS IncomeAmount, 
                          COALESCE(SUM(CASE 
                                      WHEN (MIContainer.OperDate <= inEndDate) AND (MIContainer.Amount < 0)
                                         THEN MIContainer.Amount
                                         ELSE 0
                                      END)) AS OutcomeAmount    

                        , containerCount.GoodsId 
                        , containerCount.PartyID 
                        , containerCount.UnitID 
                     FROM containerCount
      
                LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = containerCount.Id
                                               AND MIContainer.OperDate > inStartDate
                 
                 GROUP BY containerCount.Id, containerCount.GoodsId, 
                      containerCount.Amount, containerCount.PartyID, containerCount.UnitID) AS DD
 
         GROUP BY DD.GoodsId, DD.PartyID, DD.UnitID

/*         UNION ALL

         SELECT 0 AS OperAmount, SUM(DD.OperAmount) AS OperSumm, ObjectID 
           FROM
            (SELECT container.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                  , container.Id, containerCount.ObjectID 
               FROM Container 
               JOIN containerCount ON Container.parentid = containerCount.Id
          LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = container.Id
                                                        AND MIContainer.OperDate >= '01.05.2015'::TDateTime
                 
           GROUP BY container.Id, containerCount.ObjectID, container.Amount) AS DD
 
         GROUP BY DD.ObjectID */ ) AS DD

    -- GROUP BY DD.ObjectID
    -- HAVING (SUM(DD.OperAmount) <> 0) OR (SUM(DD.OperSum) <> 0)) AS DD
           LEFT JOIN OBJECT AS Object_Goods ON Object_Goods.Id = DD.GoodsId
           LEFT JOIN OBJECT AS Object_Unit ON Object_Unit.Id = DD.UnitId
           LEFT JOIN OBJECT AS Object_Party ON Object_Party.Id = DD.PartyId
           LEFT JOIN MovementItem ON MovementItem.Id = Object_Party.ObjectCode
           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsPartionMove (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.06.15                        *

*/

-- тест
-- SELECT * FROM gpSelect_CashRemains (inSession:= '2')