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
              , OutcomeAmount TFloat, EndRemainsAmount TFloat
              , ExpirationDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbUnitKey TVarChar;
   DECLARE vbUserUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- Для роли "Кассир аптеки"
     THEN
       
        vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
        IF vbUnitKey = '' THEN
          vbUnitKey := '0';
        END IF;
        vbUserUnitId := vbUnitKey::Integer;
          
        IF COALESCE (vbUserUnitId, 0) = 0
        THEN 
          RAISE EXCEPTION 'Ошибка. Не найдено подразделение сотрудника.';     
        END IF;     
          

        IF COALESCE (inUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
        THEN 
          RAISE EXCEPTION 'Ошибка. Вам разрешено работать только с подразделением <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
        END IF;     
          
     END IF; 
    
     -- Результат
     RETURN QUERY
     WITH ContainerCount AS (SELECT Container.Id, 
                                    Container.Amount, 
                                    Container.ObjectId AS GoodsId,
                                    CLO_Party.ObjectId AS PartyId,
                                    CLO_Unit.ObjectId  AS UnitId
                             FROM Container  
                                  LEFT JOIN Containerlinkobject AS CLO_Unit
                                                                ON CLO_Unit.Containerid = Container.Id
                                                               AND CLO_Unit.descid = zc_ContainerLinkObject_Unit()

                                  JOIN Containerlinkobject AS CLO_Party
                                                           ON CLO_Party.Containerid = Container.Id
                                                          AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                                 
                             WHERE Container.descid = zc_Container_Count() AND 
                               ((CLO_Unit.objectid = inUnitId) or (0 = inUnitId)) AND
                               ((Container.ObjectID = inGoodsId) or (0 = inGoodsId)) AND
                               ((CLO_Party.ObjectID = inPartyId) or (0 = inPartyId))
                             )

       SELECT 
              DD.PartyId
            , Movement.OperDate
            , Movement.InvNumber
            , DD.GoodsId 
            , Object_Goods.ObjectCode
            , Object_Goods.ValueData
            , DD.StartRemainsAmount :: TFloat
            , DD.IncomeAmount       :: TFloat
            , DD.OutcomeAmount      :: TFloat
            , DD.EndRemainsAmount   :: TFloat
            , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) :: TDateTime AS ExpirationDate
       FROM (SELECT SUM(DD.Amount - DD.OperAmount) AS StartRemainsAmount
                  , SUM(DD.IncomeAmount) AS IncomeAmount
                  , SUM(DD.OutcomeAmount) AS OutcomeAmount
                  , SUM(DD.Amount - DD.OperAmount + DD.IncomeAmount - DD.OutcomeAmount) AS EndRemainsAmount
                  , DD.GoodsId 
                  , DD.PartyId
                  , DD.UnitId
             FROM
                  (SELECT ContainerCount.Amount
                        , COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                        , COALESCE (SUM(CASE WHEN (MIContainer.OperDate <= inEndDate) AND (MIContainer.Amount > 0)
                                             THEN MIContainer.Amount
                                             ELSE 0
                                        END)) AS IncomeAmount
                        , COALESCE (SUM(CASE WHEN (MIContainer.OperDate <= inEndDate) AND (MIContainer.Amount < 0)
                                             THEN -1 * MIContainer.Amount
                                             ELSE 0
                                        END)) AS OutcomeAmount

                        , ContainerCount.GoodsId
                        , ContainerCount.PartyId
                        , ContainerCount.UnitId
                   FROM ContainerCount
                        LEFT JOIN MovementItemContainer AS MIContainer 
                                                        ON MIContainer.ContainerId = ContainerCount.Id
                                                       AND MIContainer.OperDate > inStartDate
            
                   GROUP BY ContainerCount.Id
                          , ContainerCount.GoodsId
                          , ContainerCount.Amount
                          , ContainerCount.PartyId
                          , ContainerCount.UnitId
                   ) AS DD
 
             GROUP BY DD.GoodsId
                    , DD.PartyId
                    , DD.UnitId

/*         UNION ALL

             SELECT 0 AS OperAmount, SUM(DD.OperAmount) AS OperSumm, ObjectID 
             FROM
                (SELECT Container.Amount - COALESCE(SUM(MIContainer.Amount), 0) AS OperAmount
                      , Container.Id, ContainerCount.ObjectID 
                 FROM Container 
                   JOIN ContainerCount ON Container.parentid = ContainerCount.Id
                   LEFT JOIN MovementItemContainer AS MIContainer ON MIContainer.ContainerId = Container.Id
                                                            AND MIContainer.OperDate >= '01.05.2015'::TDateTime
                     
                 GROUP BY Container.Id, ContainerCount.ObjectID, Container.Amount
                 ) AS DD
     
             GROUP BY DD.ObjectID */
            ) AS DD

    -- GROUP BY DD.ObjectID
    -- HAVING (SUM(DD.OperAmount) <> 0) OR (SUM(DD.OperSum) <> 0)) AS DD
           LEFT JOIN OBJECT AS Object_Goods ON Object_Goods.Id = DD.GoodsId
           LEFT JOIN OBJECT AS Object_Unit ON Object_Unit.Id = DD.UnitId
           LEFT JOIN OBJECT AS Object_Party ON Object_Party.Id = DD.PartyId
           LEFT JOIN MovementItem ON MovementItem.Id = Object_Party.ObjectCode
           LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
           
           -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                       ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
           -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                      
           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)  --Object_PartionMovementItem.ObjectCode
                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
;

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