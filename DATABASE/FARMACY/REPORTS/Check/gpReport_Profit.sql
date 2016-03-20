-- Function:  gpReport_Profit()

DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TFloat,TFloat, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Profit(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridical1Id     Integer,    -- поставщик оптима 
    IN inJuridical2Id     Integer,    -- поставщик фармпланета
    IN inTax1             TFloat ,
    IN inTax2             TFloat ,
    --IN inQuasiSchedule    Boolean,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalMainCode     Integer, 
  JuridicalMainName     TVarChar,
  UnitCode              Integer, 
  UnitName              TVarChar,
  Summa                 TFloat,
  SummaSale             TFloat,
  SummaProfit           TFloat,
  PersentProfit         TFloat,
  
  SummaFree             TFloat,
  SummaSaleFree         TFloat,
  SummaProfitFree       TFloat,

  Summa1                TFloat,
  SummaSale1            TFloat,
  SummaProfit1          TFloat,
  SummaProfitTax1       TFloat,
  
  Summa2                TFloat,
  SummaSale2            TFloat,
  SummaProfit2          TFloat,
  SummaProfitTax2       TFloat,

  SummaProfitAll        TFloat,
  CorrectPersentProfit  TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
          WITH tmpMI AS (SELECT MIContainer.ContainerId
                              , MI_Check.ObjectId AS GoodsId
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                              
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                          -- AND MovementLinkObject_Unit.ObjectId = inUnitId
                              INNER JOIN MovementItem AS MI_Check
                                                      ON MI_Check.MovementId = Movement_Check.Id
                                                     AND MI_Check.DescId = zc_MI_Master()
                                                     AND MI_Check.isErased = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                              LEFT JOIN MovementItemContainer AS MIContainer
                                                              ON MIContainer.MovementItemId = MI_Check.Id
                                                             AND MIContainer.DescId = zc_MIContainer_Count() 
                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                                , MIContainer.ContainerId
                                , MovementLinkObject_Unit.ObjectId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
       , tmpData_all AS (SELECT MI_Income.MovementId AS MovementId_Income
                              , COALESCE (Movement_Income.DescId, 0) AS MovementDescId
                              , Movement_Income.OperDate AS OperDate_Income
                              , Object_PartionMovementItem.ObjectCode AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , tmpMI.UnitId 
                              , SUM (tmpMI.Amount)    AS Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem 
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = MI_Income.MovementId
                         GROUP BY MI_Income.MovementId
                                , COALESCE (Movement_Income.DescId, 0)
                                , Movement_Income.OperDate
                                , Object_PartionMovementItem.ObjectCode
                                , tmpMI.GoodsId
                                , tmpMI.UnitId
                        )
    , tmpIncome_find AS (SELECT DISTINCT
                                tmpData_all.MovementItemId_Income
                              , tmpData_all.OperDate_Income
                              , tmpData_all.GoodsId
                              , tmpData_all.UnitId
                         FROM tmpData_all
                         WHERE tmpData_all.MovementDescId = zc_Movement_Inventory()
                        )
     , tmpIncome_all AS (SELECT *
                         FROM
                        (SELECT Movement.Id AS MovementId
                              , MI.Id       AS MovementItemId
                              , tmpIncome_find.MovementItemId_Income
                              , tmpIncome_find.GoodsId
                              , tmpIncome_find.UnitId
                              , ROW_NUMBER() OVER (PARTITION BY tmpIncome_find.MovementItemId_Income, tmpIncome_find.GoodsId ORDER BY CASE WHEN Movement.OperDate >= tmpIncome_find.OperDate_Income THEN Movement.OperDate - tmpIncome_find.OperDate_Income ELSE tmpIncome_find.OperDate_Income - Movement.OperDate END, Movement.OperDate) AS myRow
                         FROM tmpIncome_find
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_Income() AND Movement.StatusId = zc_Enum_Status_Complete()
                              INNER JOIN MovementItem AS MI
                                                      ON MI.MovementId = Movement.Id
                                                     AND MI.DescId = zc_MI_Master()
                                                     AND MI.isErased = FALSE
                                                     AND MI.ObjectId = tmpIncome_find.GoodsId
                                                     AND MI.Amount <> 0
                        ) AS tmp
                         WHERE tmp.myRow = 1
                        )
         , tmpIncome AS (SELECT tmpIncome_all.MovementId
                              , tmpIncome_all.MovementItemId_Income
                              , tmpIncome_all.GoodsId
                              , tmpIncome_all.UnitId
                              , MovementLinkObject_From_Income.ObjectId      AS JuridicalId_Income
                              , MovementLinkObject_NDSKind_Income.ObjectId   AS NDSKindId_Income
                              , COALESCE (MIFloat_Income_Price.ValueData, 0) AS Price_original
                              , COALESCE (MIFloat_Income_Price.ValueData, 0) * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END AS Price
                         FROM tmpIncome_all
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpIncome_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId = zc_MovementLinkObject_From()

                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpIncome_all.MovementId
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpIncome_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDS_Income
                                                    ON ObjectFloat_NDS_Income.ObjectId = MovementLinkObject_NDSKind_Income.ObjectId
                                                   AND ObjectFloat_NDS_Income.DescId = zc_ObjectFloat_NDSKind_NDS()
                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpIncome_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
                        )
           , tmpData AS (SELECT COALESCE (tmpIncome.JuridicalId_Income, MovementLinkObject_From_Income.ObjectId)    AS JuridicalId_Income     -- поставщик
                              , tmpData_all.UnitId
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                              , SUM (tmpData_all.Amount * COALESCE (tmpIncome.Price_original, COALESCE (MIFloat_Income_Price.ValueData, 0))) AS Summa_original
                              , SUM (tmpData_all.Amount * COALESCE (tmpIncome.Price, COALESCE (MIFloat_Income_Price.ValueData, 0)
                                                                                   * CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN 1 ELSE 1 + COALESCE (ObjectFloat_NDS_Income.ValueData, 0) / 100 END)
                                    ) AS Summa
                         FROM tmpData_all
                              LEFT JOIN tmpIncome ON tmpIncome.MovementItemId_Income = tmpData_all.MovementItemId_Income
                                                 AND tmpIncome.GoodsId               = tmpData_all.GoodsId
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId_Income
                                                          AND MovementLinkObject_From_Income.DescId = zc_MovementLinkObject_From()
                                                          AND tmpData_all.MovementDescId = zc_Movement_Income() 

                              LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                        ON MovementBoolean_PriceWithVAT.MovementId = tmpData_all.MovementId_Income
                                                       AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                                                       AND tmpData_all.MovementDescId = zc_Movement_Income() 

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId_Income
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()
                                                          AND tmpData_all.MovementDescId = zc_Movement_Income() 
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDS_Income
                                                    ON ObjectFloat_NDS_Income.ObjectId = MovementLinkObject_NDSKind_Income.ObjectId
                                                   AND ObjectFloat_NDS_Income.DescId = zc_ObjectFloat_NDSKind_NDS()

                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 
                                                         AND tmpData_all.MovementDescId = zc_Movement_Income() 
                         GROUP BY COALESCE (tmpIncome.JuridicalId_Income, MovementLinkObject_From_Income.ObjectId)
                                , tmpData_all.UnitId
                        )

        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmp.Summa                               :: TFloat AS Summa
           , tmp.SummaSale                           :: TFloat AS SummaSale
           , (tmp.SummaSale - tmp.Summa)             :: TFloat AS SummaProfit
           , (100-tmp.Summa/tmp.SummaSale*100)       :: TFloat AS PersentProfit
         
           , tmp.SummaFree                           :: TFloat AS SummaFree
           , tmp.SummaSaleFree                       :: TFloat AS SummaSaleFree
           , (tmp.SummaSaleFree - tmp.SummaFree)     :: TFloat AS SummaProfitFree

           , tmp.Summa1                              :: TFloat AS Summa1
           , tmp.SummaSale1                          :: TFloat AS SummaSale1
           , tmp.SummaProfit1                        :: TFloat AS SummaProfit1
           , (tmp.SummaProfit1 + (tmp.SummaProfit1/100 * inTax1))  :: TFloat AS SummaProfitTax1

           , tmp.Summa2                              :: TFloat AS Summa2
           , tmp.SummaSale2                          :: TFloat AS SummaSale2
           , tmp.SummaProfit2                        :: TFloat AS SummaProfit2
           , (tmp.SummaProfit2 + (tmp.SummaProfit2/100 * inTax2))  :: TFloat AS SummaProfitTax2

           , (tmp.SummaProfit1 + (tmp.SummaProfit1/100 * inTax1) + tmp.SummaProfit2 + (tmp.SummaProfit2/100 * inTax2) + (tmp.SummaSaleFree - tmp.SummaFree))     :: TFloat AS SummaProfitAll

           , ((tmp.SummaProfit1 + (tmp.SummaProfit1/100 * inTax1) + tmp.SummaProfit2 + (tmp.SummaProfit2/100 * inTax2) + (tmp.SummaSaleFree - tmp.SummaFree))/ tmp.SummaSale * 100)  :: TFloat AS CorrectPersentProfit

       FROM (SELECT tmpData.UnitId
                  , SUM(tmpData.Summa)       AS Summa
                  , SUM(tmpData.SummaSale)   AS SummaSale

                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.Summa END)     AS SummaFree
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.SummaSale END) AS SummaSaleFree
                  
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.Summa ELSE 0 END)     AS Summa1
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale1
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit1
                  
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.Summa ELSE 0 END)     AS Summa2
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale2
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit2
             FROM tmpData
             GROUP BY tmpData.UnitId) AS tmp
             
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId

                LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                     ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                LEFT JOIN Object AS Object_JuridicalMain ON Object_JuridicalMain.Id = ObjectLink_Unit_Juridical.ChildObjectId
    

        ORDER BY Object_JuridicalMain.ValueData 
               , Object_Unit.ValueData 
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 20.03.16         *
*/
-- тест
-- SELECT * FROM gpReport_Profit (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
