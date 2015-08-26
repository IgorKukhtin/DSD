-- Function:  gpReport_Movement_Check()

DROP FUNCTION IF EXISTS gpReport_Movement_Check (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_Check(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId       integer, 
  GoodsCode     Integer, 
  GoodsName     TVarChar, 
  Amount        TFloat,
  Price         TFloat,
  PriceSale     TFloat,
  Summa         TFloat,
  SummaSale     TFloat,
  SummaMargin   TFloat)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
        SELECT
            Object_Goods.Id                                                 AS GoodsId
           ,Object_Goods.ObjectCode::Integer                                AS GoodsCode
           ,Object_Goods.ValueData                                          AS GoodsName
           ,SUM(-MIContainer.Amount)::TFloat                                    AS Amount
           ,(SUM(-MIContainer.Amount*MIFloat_Income_Price.ValueData)
             / SUM(-MIContainer.Amount))::TFloat                                AS Price
           ,(SUM(-MIContainer.Amount*MIFloat_Price.ValueData)
             / SUM(-MIContainer.Amount))::TFloat                                AS PriceSale
           ,SUM(-MIContainer.Amount*MIFloat_Income_Price.ValueData)::TFloat     AS Summa
           ,SUM(-MIContainer.Amount*MIFloat_Price.ValueData)::TFloat            AS SummaSale
           ,(SUM(-MIContainer.Amount*MIFloat_Price.ValueData)
             - SUM(-MIContainer.Amount*MIFloat_Income_Price.ValueData))::TFloat AS SummaMargin
        FROM
            Movement AS Movement_Check
            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = inUnitId
            INNER JOIN MovementItem AS MI_Check
                                    ON MI_Check.MovementId = Movement_Check.Id
                                   AND MI_Check.DescId = zc_MI_Master()
                                   AND MI_Check.isErased = FALSE
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MI_Check.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                 AND MIContainer.DescId = zc_Container_Count() 
            LEFT OUTER JOIN Container ON MIContainer.ContainerId = Container.Id
                                     AND Container.DescId = zc_Container_Count()
            LEFT OUTER JOIN containerlinkobject AS ContainerLinkObject_MovementItem 
                                                ON ContainerLinkObject_MovementItem.containerid = Container.Id
                                               AND ContainerLinkObject_MovementItem.descid = zc_ContainerLinkObject_PartionMovementItem()
            LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem 
                                   ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
            LEFT OUTER JOIN MovementItem AS MI_Income
                                         ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
            LEFT OUTER JOIN MovementItemFloat AS MIFloat_Income_Price 
                                              ON MIFloat_Income_Price.MovementItemId = MI_Income.Id
                                             AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
            LEFT OUTER JOIN Object AS Object_Goods
                                   ON Object_Goods.Id = MI_Check.ObjectId
        WHERE
            Movement_Check.DescId = zc_Movement_Check()
            AND
            date_trunc('day', Movement_Check.OperDate) between inDateStart AND inDateFinal
            AND
            Movement_Check.StatusId = zc_Enum_Status_Complete()
        GROUP BY
            Object_Goods.Id
           ,Object_Goods.ObjectCode
           ,Object_Goods.ValueData
        HAVING
           SUM(MI_Check.Amount) <> 0 
        ORDER BY
            GoodsName;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION  gpReport_Movement_Check (Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 11.08.15                                                                       *

*/

-- тест
-- SELECT * FROM gpReport_Movement_Check (inUnitId := 0, inDateStart = '20150801'::TDateTime, inDateFinal := '20150810'::TDateTime, inWithPartionGoods := FALSE, inSession := '3')