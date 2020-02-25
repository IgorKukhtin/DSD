 -- Function: gpReport_JuridicalSales()
-- реализ. за год 
DROP FUNCTION IF EXISTS gpReport_JuridicalSales (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalSales(
    IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inJuridicalId      Integer  ,  -- Юр.лицо
    IN inStartDate        TDateTime,  -- Дата c
    IN inEndDate          TDateTime,  -- Дата по
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (JuridicalId Integer, JuridicalName TVarChar
             , Amount TFloat
             , Summa TFloat
             , SummaWithVAT TFloat
             , SummaSale TFloat
             , SummaProfit TFloat
             , PersentProfit TFloat
             , SummaProfitWithVAT TFloat
             , PersentProfitWithVAT TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH
          tmpUnit AS (SELECT ObjectLink_Unit_Juridical.ObjectId      AS UnitId
                           , ObjectLink_Unit_Juridical.ChildObjectId AS JuridicalId
                      FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                      WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        AND (ObjectLink_Unit_Juridical.ChildObjectId = inJuridicalId OR inJuridicalId = 0)
                      )

        -- данные из проводок
        , tmpData_ContainerAll AS (SELECT MIContainer.MovementItemId                      AS MI_Id
                                        , MIContainer.MovementId                          AS MovementId
                                        , COALESCE (MIContainer.AnalyzerId,0) :: Integer  AS MovementItemId
                                        , MIContainer.WhereObjectId_analyzer              AS UnitId
                                        , SUM (COALESCE (-1 * MIContainer.Amount, 0))     AS Amount
                                        , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                                   FROM MovementItemContainer AS MIContainer
                                   WHERE MIContainer.DescId = zc_MIContainer_Count()
                                     AND MIContainer.MovementDescId = zc_Movement_Check()
                                     AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + interval '1 day'
                                   GROUP BY COALESCE (MIContainer.AnalyzerId,0)
                                          , MIContainer.MovementItemId
                                          , MIContainer.WhereObjectId_analyzer
                                          , MIContainer.MovementId
                                   --HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                  )
        , tmpData_Container AS (SELECT tmpData_ContainerAll.*
                                     , tmpUnit.JuridicalId
                                FROM tmpData_ContainerAll
                                     INNER JOIN tmpUnit ON tmpUnit.UnitId = tmpData_ContainerAll.UnitId
                                WHERE tmpData_ContainerAll.Amount <> 0
                               )

        -- находим ИД док.прихода
       , tmpData_all AS (SELECT COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , tmpData_Container.JuridicalId

                              , SUM (COALESCE (tmpData_Container.Amount, 0))        AS Amount
                              , SUM (COALESCE (tmpData_Container.SummaSale, 0))     AS SummaSale

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

                                , tmpData_Container.JuridicalId
                         )

       , tmpData AS (SELECT  tmpData_all.JuridicalId
                          , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))         AS Summa
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
                          -- Поставшик, для элемента прихода от поставщика (или NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                       ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                          -- Вид НДС, для элемента прихода от поставщика (или NULL)
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind_Income
                                                       ON MovementLinkObject_NDSKind_Income.MovementId = tmpData_all.MovementId
                                                      AND MovementLinkObject_NDSKind_Income.DescId = zc_MovementLinkObject_NDSKind()

                     GROUP BY tmpData_all.JuridicalId
                    )
                        
       , tmpData_Full AS (SELECT tmpData.JuridicalId
                               , SUM(tmpData.Amount)       AS Amount
                               , SUM(tmpData.Summa)        AS Summa
                               , SUM(tmpData.SummaSale)    AS SummaSale
                               , SUM(tmpData.SummaWithVAT) AS SummaWithVAT
                          FROM tmpData
                          GROUP BY tmpData.JuridicalId
                          )

     -- результат  
        SELECT Object_Juridical.Id        AS JuridicalId
             , Object_Juridical.ValueData AS JuridicalName
             , tmp.Amount                              :: TFloat AS Amount
             , tmp.Summa                               :: TFloat AS Summa
             , tmp.SummaWithVAT                        :: TFloat AS SummaWithVAT
             , tmp.SummaSale                           :: TFloat AS SummaSale
             , (tmp.SummaSale - tmp.Summa)             :: TFloat AS SummaProfit
             , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.Summa/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))   :: TFloat AS PersentProfit
  
             , (tmp.SummaSale - tmp.SummaWithVAT)      :: TFloat AS SummaProfitWithVAT   --сумма дохода без уч.корректировки
             , CAST (CASE WHEN tmp.SummaSale <> 0 THEN (100-tmp.SummaWithVAT/tmp.SummaSale*100) ELSE 0 END AS NUMERIC (16, 2))  :: TFloat AS PersentProfitWithVAT
        FROM tmpData_Full AS tmp
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmp.JuridicalId
       ;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. Шаблий О.В.
 25.02.20         *
*/

-- тест
-- SELECT * FROM gpReport_JuridicalSales( inRetailId := 0, inJuridicalId  :=393038 , inStartDate := '01.01.2019' ::TDateTime, inEndDate := '01.01.2020' ::TDateTime, inSession := '3'::TVarChar )
