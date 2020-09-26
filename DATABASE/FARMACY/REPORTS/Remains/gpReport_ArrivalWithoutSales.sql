 -- Function: gpReport_ArrivalWithoutSales()

DROP FUNCTION IF EXISTS gpReport_ArrivalWithoutSales (TDateTime, TDateTime, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ArrivalWithoutSales(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inMinSale             TFloat   ,  -- Продано меньше или равно
    IN inPriceIn             TFloat   ,  -- Цена закупки больше или равна
    IN inConsecutiveParishes Boolean  ,  -- Подряд приходы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    inStartDate := date_trunc('day', inStartDate);
    inEndDate := date_trunc('day', inEndDate);

    CREATE TEMP TABLE tmpData ON COMMIT DROP AS
    (
    WITH tmpIncome AS (SELECT MovementItemContainer.ContainerID
                            , MovementItemContainer.ObjectId_Analyzer       AS GoodsId
                            , MovementItemContainer.WhereObjectId_Analyzer  AS UnitId
                            , MovementItemContainer.OperDate
                            , MovementItemContainer.Amount                   AS AmountIn
                            , MIFloat_PriceWithVAT.ValueData                 AS PriceIn
                            , ROW_NUMBER() OVER (PARTITION BY MovementItemContainer.WhereObjectId_Analyzer, MovementItemContainer.ObjectId_Analyzer
                                                 ORDER BY MovementItemContainer.OperDate DESC, MovementItemContainer.ContainerID) AS Ord
                       FROM MovementItemContainer

                            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                  ON ObjectLink_Unit_Juridical.ObjectId = MovementItemContainer.WhereObjectId_Analyzer
                                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()

                            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 4

                            LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                        ON MIFloat_PriceWithVAT.MovementItemId = MovementItemContainer.MovementItemId
                                                       AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

                       WHERE MovementItemContainer.MovementDescId = zc_Movement_Income()
                         AND MovementItemContainer.OperDate BETWEEN inStartDate AND inEndDate
                         AND COALESCE ( MIFloat_PriceWithVAT.ValueData, 0) > COALESCE ( inPriceIn, 0)),

         tmpRemains AS (SELECT tmpIncome.GoodsId                          AS GoodsId
                             , tmpIncome.UnitId                           AS UnitId
                             , Sum(tmpIncome.AmountIn)::TFloat            AS AmountIn
                             , Sum(Container.Amount)::TFloat              AS Amount
                             , MAX(tmpIncome.OperDate)                    AS OperDate
                             , Count(*)                                   AS CountIn
                        FROM tmpIncome

                             INNER JOIN Container ON Container.ID = tmpIncome.ContainerID
                                                 AND Container.DescId = zc_Container_Count()
                                                 AND Container.Amount > 0

                        GROUP BY tmpIncome.GoodsId
                               , tmpIncome.UnitId),
         tmpSales AS (SELECT AnalysisContainerItem.GoodsId
                           , AnalysisContainerItem.UnitId
                           , sum(AnalysisContainerItem.AmountCheck)::TFloat    AS AmountCheck
                           , sum(AnalysisContainerItem.AmountCheckSum)::TFloat AS AmountCheckSum
                           , MIN(AnalysisContainerItem.OperDate)               AS OperDate
                      FROM AnalysisContainerItem
                      WHERE AnalysisContainerItem.AmountCheck > 0
                        AND AnalysisContainerItem.OperDate BETWEEN inStartDate AND inEndDate
                      GROUP BY AnalysisContainerItem.GoodsId, AnalysisContainerItem.UnitId)

    SELECT tmpRemains.UnitId               AS UnitId
         , tmpRemains.GoodsId              AS GoodsId
         , tmpRemains.AmountIn             AS AmountIn
         , tmpRemains.Amount               AS Amount
         , tmpSales.AmountCheck            AS AmountCheck
         , CASE WHEN COALESCE (tmpSales.AmountCheck, 0) <> 0 THEN
           Round(tmpSales.AmountCheckSum / tmpSales.AmountCheck, 2) END::TFloat  AS Price
         , tmpSales.AmountCheckSum         AS CheckSum
         , tmpIncome.OperDate              AS OperDateInLast
         , tmpIncome.AmountIn              AS AmountInLast
         , tmpIncome.PriceIn               AS PriceInLast
    FROM tmpRemains

         LEFT JOIN tmpSales ON tmpSales.GoodsId = tmpRemains.GoodsId
                           AND tmpSales.UnitId = tmpRemains.UnitId

         LEFT JOIN tmpIncome ON tmpIncome.GoodsId = tmpRemains.GoodsId
                            AND tmpIncome.UnitId = tmpRemains.UnitId
                            AND tmpIncome.Ord = 1

    WHERE COALESCE (tmpSales.AmountCheck, 0) <= inMinSale
      AND (COALESCE (inConsecutiveParishes, False) = False OR tmpRemains.CountIn > 1 AND tmpRemains.OperDate >= COALESCE(tmpSales.OperDate, tmpRemains.OperDate))
    );

  raise notice 'Value 05: %', (select count(*) from tmpData);

  OPEN cur1 FOR
  SELECT tmpData.UnitId
       , Object_Unit.ObjectCode          AS UnitCode
       , Object_Unit.ValueData           AS UnitName
       , SUM(tmpData.AmountIn)           AS AmountIn
       , SUM(tmpData.Amount)             AS Amount
       , SUM(tmpData.AmountCheck)        AS AmountCheck
       , SUM(tmpData.CheckSum)           AS CheckSum
  FROM tmpData

       LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = tmpData.UnitId

  GROUP BY tmpData.UnitId
       , Object_Unit.ObjectCode
       , Object_Unit.ValueData
  ORDER BY 4 DESC;
  RETURN NEXT cur1;

  OPEN cur2 FOR
  SELECT tmpData.UnitId
       , tmpData.GoodsId
       , Object_Goods.ObjectCode         AS GoodsCode
       , Object_Goods.ValueData          AS GoodsName
       , tmpData.AmountIn                AS AmountIn
       , tmpData.Amount                  AS Amount
       , tmpData.AmountCheck             AS AmountCheck
       , tmpData.Price                   AS Price
       , tmpData.CheckSum                AS CheckSum
       , tmpData.OperDateInLast          AS OperDateInLast
       , tmpData.AmountInLast            AS AmountInLast
       , tmpData.PriceInLast             AS PriceInLast
  FROM tmpData

       LEFT JOIN Object AS Object_Goods ON Object_Goods.ID = tmpData.GoodsId;

  RETURN NEXT cur2;

  raise notice 'Value 05: %', (select count(*) from tmpData);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.09.20                                                       *
*/

-- тест
--
select * from gpReport_ArrivalWithoutSales (inStartDate := ('01.08.2020')::TDateTime , inEndDate := ('31.08.2020')::TDateTime , inMinSale := 0.0 , inPriceIn := 0.20,  inConsecutiveParishes := True,  inSession := '3');