-- Function:  gpReport_Profit()

DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TFloat,TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Profit (TDateTime, TDateTime, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Profit(
    IN inStartDate        TDateTime,  -- Дата начала
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
   DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
          
    WITH
          tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId =  vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )
 -- данные из проводок
 , tmpData_ContainerAll AS (SELECT COALESCE (MIContainer.AnalyzerId,0) :: Integer  AS MovementItemId
                              , COALESCE (MIContainer.WhereObjectId_analyzer,0) AS UnitId
                              , MIContainer.ObjectId_analyzer                   AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0))     AS Amount
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                        -- AND MIContainer.OperDate >= '03.10.2016' AND MIContainer.OperDate < '01.12.2016'
                         GROUP BY COALESCE (MIContainer.WhereObjectId_analyzer,0)
                                , MIContainer.ObjectId_analyzer    
                                , COALESCE (MIContainer.AnalyzerId,0)
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                        )
 , tmpData_Container AS (SELECT tmpData_ContainerAll.*
                         FROM tmpData_ContainerAll
                              INNER JOIN tmpUnit ON  tmpUnit.UnitId = tmpData_ContainerAll.UnitId
                        )

       -- находим ИД док.прихода
       , tmpData_all AS (SELECT COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
 
                              , tmpData_Container.GoodsId
                              , tmpData_Container.UnitId
                              , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                              , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                         FROM tmpData_Container
                               -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpData_Container.MovementItemId

                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                        GROUP BY COALESCE (MI_Income_find.Id,         MI_Income.Id)
                               , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)  
                               , tmpData_Container.GoodsId
                               , tmpData_Container.UnitId
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
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.Summa/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))   :: TFloat AS PersentProfit

           , (tmp.SummaSale - tmp.SummaWithVAT)      :: TFloat AS SummaProfitWithVAT   --сумма дохода без уч.корректировки
           , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.SummaWithVAT/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))  :: TFloat AS PersentProfitWithVAT
         
           , tmp.SummaFree                           :: TFloat AS SummaFree
           , tmp.SummaSaleFree                       :: TFloat AS SummaSaleFree
           , (tmp.SummaSaleFree - tmp.SummaFree)     :: TFloat AS SummaProfitFree

           , tmp.Summa1                              :: TFloat AS Summa1
           , tmp.SummaWithVAT1                       :: TFloat AS SummaWithVAT1
           , tmp.SummaSale1                          :: TFloat AS SummaSale1
           , tmp.SummaProfit1                        :: TFloat AS SummaProfit1
           , CAST (CASE WHEN tmp.Summa1 <> 0 THEN ((tmp.SummaWithVAT1-tmp.Summa1)*100 / tmp.Summa1) ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS Tax1

           , tmp.Summa2                              :: TFloat AS Summa2
           , tmp.SummaWithVAT2                       :: TFloat AS SummaWithVAT2
           , tmp.SummaSale2                          :: TFloat AS SummaSale2
           , tmp.SummaProfit2                        :: TFloat AS SummaProfit2
           , CAST (CASE WHEN tmp.Summa2 <> 0 THEN ((tmp.SummaWithVAT2-tmp.Summa2)*100 / tmp.Summa2) ELSE 0 END AS NUMERIC (16, 2)) :: TFloat AS Tax2
           
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
 25.01.17         * ограничение по торговой сети
                    оптимизация, строим отчет на проводках
 20.03.16         *
*/
-- тест
-- SELECT * FROM gpReport_Profit (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
-- SELECT * from gpReport_Profit(inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('05.11.2016')::TDateTime , inJuridical1Id := 59610 ::Integer , inJuridical2Id := 59612  ::Integer,  inSession := '3'::TVarChar);