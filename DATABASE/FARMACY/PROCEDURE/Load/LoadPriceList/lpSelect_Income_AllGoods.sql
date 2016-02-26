DROP FUNCTION IF EXISTS lpSelect_Income_AllGoods (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Income_AllGoods(
    IN inUnitId      Integer      , -- ключ Документа
    --IN inObjectId    Integer      , 
    IN inUserId      Integer        -- сессия пользователя
)

RETURNS TABLE (
    GoodsId            integer,
    GoodsCode          integer,
    GoodsName          TVarChar,
    IncomeCount        TFloat
   
)

AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    RETURN QUERY
    WITH 
    tmpIncome AS
       (SELECT Container.ObjectId -- здесь товар "сети"
             , SUM(COALESCE(MIContainer.Amount,0)) AS IncomeCount
        FROM Container
            JOIN MovementItemContainer AS MIContainer
                                       ON MIContainer.ContainerId = Container.Id
                                      AND MIContainer.Amount > 0 
                                      AND MIContainer.OperDate = CURRENT_DATE
        WHERE Container.DescId = zc_Container_Count()
          AND Container.WhereObjectId = inUnitId
        GROUP BY Container.ObjectId
        HAVING SUM(MIContainer.Amount) > 0
       )

    Select
        Object.Id              AS GoodsId,
        Object.ObjectCode    AS GoodsCode,
        Object.ValueData     AS GoodsName,
        tmpIncome.IncomeCount ::TFloat

    from tmpIncome
        LEFT JOIN Object ON Object.Id = tmpIncome.ObjectId
      
    ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION lpSelect_Income_AllGoods (Integer, Integer, Integer) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 26.02.16         * add
*/
-- SELECT * FROM lpSelect_Income_AllGoods (183293, 4, 3)