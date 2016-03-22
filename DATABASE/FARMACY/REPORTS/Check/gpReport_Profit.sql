-- Function:  gpReport_Profit()

DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Profit(
    IN indatestart        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inJuridical1Id     Integer,    -- поставщик оптима 
    IN inJuridical2Id     Integer,    -- поставщик фармпланета
 --   IN inTax1             TFloat ,
 --   IN inTax2             TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalMainCode     Integer, 
  JuridicalMainName     TVarChar,
  UnitCode              Integer, 
  UnitName              TVarChar,
  Summa                 TFloat,
  SummaWithVAT          TFloat,
  SummaSale             TFloat,
  SummaProfit           TFloat,
  PersentProfit         TFloat,

  SummaProfitWithVAT    TFloat,
  PersentProfitWithVAT  TFloat,
  
  SummaFree             TFloat,
  SummaSaleFree         TFloat,
  SummaProfitFree       TFloat,

  Summa1                TFloat, 
  SummaWithVAT1         TFloat,
  SummaSale1            TFloat,
  SummaProfit1          TFloat,
  Tax1                  TFloat,
  
  Summa2                TFloat,
  SummaWithVAT2         TFloat,
  SummaSale2            TFloat,
  SummaProfit2          TFloat,
  Tax2                  TFloat

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
                              , MI_Check.ObjectId                  AS GoodsId
                              , MovementLinkObject_Unit.ObjectId   AS UnitId
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           --AND MovementLinkObject_Unit.ObjectId = inUnitId
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
                           AND Movement_Check.OperDate >= indatestart AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY MI_Check.ObjectId
                                , MIContainer.ContainerId
                                , MovementLinkObject_Unit.ObjectId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )
       , tmpData_all AS (SELECT MI_Income.MovementId      AS MovementId_Income
                              , MI_Income_find.MovementId AS MovementId_find
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , tmpMI.GoodsId
                              , tmpMI.UnitId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpMI
                              -- нашли партию
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = tmpMI.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId

                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                        )
           , tmpData AS (SELECT MovementLinkObject_From_Income.ObjectId                                    AS JuridicalId_Income  -- ПОСТАВЩИК
                              , tmpData_all.GoodsId
                              , tmpData_all.UnitId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))         AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_Income_Price.ValueData, 0))           AS Summa_original
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPriceWithVAT.ValueData, 0))  AS SummaWithVAT
                      
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (и % корректировки наценки zc_Object_Juridical) (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена с учетом НДС, для элемента прихода от поставщика (без % корректировки)(или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPriceWithVAT
                                                          ON MIFloat_JuridicalPriceWithVAT.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- цена "оригинал", для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 

                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                              -- Вид НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                           ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()

                         GROUP BY MovementLinkObject_From_Income.ObjectId
                                , tmpData_all.GoodsId
                                , tmpData_all.UnitId
                        )
      
               

        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmp.Summa                               :: TFloat AS Summa
           , tmp.SummaWithVAT                        :: TFloat AS SummaWithVAT
           , tmp.SummaSale                           :: TFloat AS SummaSale
           , (tmp.SummaSale - tmp.Summa)             :: TFloat AS SummaProfit
           , CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.Summa/tmp.SummaSale*100) ELSE 0 END    :: TFloat AS PersentProfit

           , (tmp.SummaSale - tmp.SummaWithVAT)      :: TFloat AS SummaProfitWithVAT   --сумма дохода без уч.корректировки
           , CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.SummaWithVAT/tmp.SummaSale*100) ELSE 0 END :: TFloat AS PersentProfitWithVAT
         
           , tmp.SummaFree                           :: TFloat AS SummaFree
           , tmp.SummaSaleFree                       :: TFloat AS SummaSaleFree
           , (tmp.SummaSaleFree - tmp.SummaFree)     :: TFloat AS SummaProfitFree

           , tmp.Summa1                              :: TFloat AS Summa1
           , tmp.SummaWithVAT1                       :: TFloat AS SummaWithVAT1
           , tmp.SummaSale1                          :: TFloat AS SummaSale1
           , tmp.SummaProfit1                        :: TFloat AS SummaProfit1
           , CASE WHEN tmp.Summa1 <> 0 THEN ((tmp.SummaWithVAT1-tmp.Summa1)*100 / tmp.Summa1) ELSE 0 END  :: TFloat AS Tax1

           , tmp.Summa2                              :: TFloat AS Summa2
           , tmp.SummaWithVAT2                       :: TFloat AS SummaWithVAT2
           , tmp.SummaSale2                          :: TFloat AS SummaSale2
           , tmp.SummaProfit2                        :: TFloat AS SummaProfit2
           , CASE WHEN tmp.Summa2 <> 0 THEN ((tmp.SummaWithVAT2-tmp.Summa2)*100 / tmp.Summa2) ELSE 0 END :: TFloat AS Tax2
           
       FROM (SELECT tmpData.UnitId
                  , SUM(tmpData.Summa)        AS Summa
                  , SUM(tmpData.SummaSale)    AS SummaSale
                  , SUM(tmpData.SummaWithVAT) AS SummaWithVAT
                  
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.Summa END)     AS SummaFree
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id OR tmpData.JuridicalId_Income = inJuridical2Id THEN 0 ELSE tmpData.SummaSale END) AS SummaSaleFree
                  
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.Summa ELSE 0 END)     AS Summa1
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale1
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit1
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical1Id THEN tmpData.SummaWithVAT ELSE 0 END)     AS SummaWithVAT1
                  
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.Summa ELSE 0 END)     AS Summa2
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale ELSE 0 END) AS SummaSale2
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaSale-tmpData.Summa ELSE 0 END) AS SummaProfit2
                  , SUM(CASE WHEN tmpData.JuridicalId_Income = inJuridical2Id THEN tmpData.SummaWithVAT ELSE 0 END)     AS SummaWithVAT2
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
-- SELECT * FROM gpReport_Profit (inUnitId:= 0, indatestart:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
--lect * from gpReport_Profit(inStartDate := ('01.01.2016')::TDateTime , inEndDate := ('02.01.2016')::TDateTime , inJuridical1Id := 59611::Integer , inJuridical2Id := 0 ::Integer, inTax1 := 5::TFloat , inTax2 := 3.35 ::TFloat,  inSession := '3'::TVarChar);