-- Function:  gpReport_PriceIntervention()


DROP FUNCTION IF EXISTS gpReport_PriceIntervention (TDateTime, TDateTime, TFloat,TFloat, TFloat,TFloat, TFloat,TFloat, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_PriceIntervention(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inPrice1           TFloat ,
    IN inPrice2           TFloat ,
    IN inPrice3           TFloat ,
    IN inPrice4           TFloat ,
    IN inPrice5           TFloat ,
    IN inPrice6           TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  JuridicalMainCode  Integer, 
  JuridicalMainName  TVarChar,
  UnitCode           Integer, 
  UnitName           TVarChar,

  Amount            TFloat,
  Summa             TFloat,
  SummaSale         TFloat,
  
  Amount1            TFloat,
  Summa1             TFloat,
  SummaSale1         TFloat,
  
  Amount2            TFloat,
  Summa2             TFloat,
  SummaSale2         TFloat,
  
  Amount3            TFloat,
  Summa3             TFloat,
  SummaSale3         TFloat,
  
  Amount4            TFloat,
  Summa4             TFloat,
  SummaSale4         TFloat,
  
  Amount5            TFloat,
  Summa5             TFloat,
  SummaSale5         TFloat,

  Amount6            TFloat,
  Summa6             TFloat,
  SummaSale6         TFloat,

  Amount7            TFloat,
  Summa7             TFloat,
  SummaSale7         TFloat
    
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
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
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
                              , tmpData_all.UnitId
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              --, SUM (tmpData_all.Amount * COALESCE (MIFloat_Income_Price.ValueData,    0)) AS Summa_original
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.Amount ELSE 0 END ) AS Amount1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale1
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice1 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa1
                              
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.Amount ELSE 0 END ) AS Amount2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale2
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice1 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice2 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa2

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.Amount ELSE 0 END ) AS Amount3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale3
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice2 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice3 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa3

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.Amount ELSE 0 END ) AS Amount4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale4
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice3 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice4 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa4

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.Amount ELSE 0 END ) AS Amount5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale5
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice4 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice5 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa5

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale6
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice5 and COALESCE (MIFloat_JuridicalPrice.ValueData, 0)<=inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa6

                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.Amount ELSE 0 END ) AS Amount7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.SummaSale ELSE 0 END ) AS SummaSale7
                              , SUM (CASE WHEN COALESCE (MIFloat_JuridicalPrice.ValueData, 0)>inPrice6 THEN tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0) ELSE 0 END ) AS Summa7
                         FROM tmpData_all
                              -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- цена "оригинал", для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_Income_Price
                                                          ON MIFloat_Income_Price.MovementItemId = tmpData_all.MovementItemId
                                                         AND MIFloat_Income_Price.DescId = zc_MIFloat_Price() 

                              -- Поставшик, для элемента прихода от поставщика (или NULL)
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                           ON MovementLinkObject_From_Income.MovementId = tmpData_all.MovementId
                                                          AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                          
                         GROUP BY MovementLinkObject_From_Income.ObjectId
                                , tmpData_all.UnitId
                        )
      
               

        SELECT
             Object_JuridicalMain.ObjectCode         AS JuridicalMainCode
           , Object_JuridicalMain.ValueData          AS JuridicalMainName
           , Object_Unit.ObjectCode                  AS UnitCode
           , Object_Unit.ValueData                   AS UnitName

           , tmp.Amount    ::TFloat AS Amount
           , tmp.Summa     ::TFloat AS Summa
           , tmp.SummaSale ::TFloat AS SummaSale

           , tmp.Amount1    ::TFloat AS Amount1
           , tmp.Summa1     ::TFloat AS Summa1
           , tmp.SummaSale1 ::TFloat AS SummaSale1

           , tmp.Amount2    ::TFloat AS Amount2
           , tmp.Summa2     ::TFloat AS Summa2
           , tmp.SummaSale2 ::TFloat AS SummaSale2

           , tmp.Amount3    ::TFloat AS Amount3
           , tmp.Summa3     ::TFloat AS Summa3
           , tmp.SummaSale3 ::TFloat AS SummaSale3

           , tmp.Amount4    ::TFloat AS Amount4
           , tmp.Summa4     ::TFloat AS Summa4
           , tmp.SummaSale4 ::TFloat AS SummaSale4

           , tmp.Amount5    ::TFloat AS Amount5
           , tmp.Summa5     ::TFloat AS Summa5
           , tmp.SummaSale5 ::TFloat AS SummaSale5

           , tmp.Amount6    ::TFloat AS Amount6
           , tmp.Summa6     ::TFloat AS Summa6
           , tmp.SummaSale6 ::TFloat AS SummaSale6

           , tmp.Amount7    ::TFloat AS Amount7
           , tmp.Summa7     ::TFloat AS Summa7
           , tmp.SummaSale7 ::TFloat AS SummaSale7
           
       FROM (SELECT tmpData.UnitId
                  , SUM(tmpData.Amount)      AS Amount
                  , SUM(tmpData.Summa)       AS Summa
                  , SUM(tmpData.SummaSale)   AS SummaSale

                  , SUM(tmpData.Amount1)      AS Amount1
                  , SUM(tmpData.Summa1)       AS Summa1
                  , SUM(tmpData.SummaSale1)   AS SummaSale1

                  , SUM(tmpData.Amount2)      AS Amount2
                  , SUM(tmpData.Summa2)       AS Summa2
                  , SUM(tmpData.SummaSale2)   AS SummaSale2

                  , SUM(tmpData.Amount3)      AS Amount3
                  , SUM(tmpData.Summa3)       AS Summa3
                  , SUM(tmpData.SummaSale3)   AS SummaSale3

                  , SUM(tmpData.Amount4)      AS Amount4
                  , SUM(tmpData.Summa4)       AS Summa4
                  , SUM(tmpData.SummaSale4)   AS SummaSale4

                  , SUM(tmpData.Amount5)      AS Amount5
                  , SUM(tmpData.Summa5)       AS Summa5
                  , SUM(tmpData.SummaSale5)   AS SummaSale5

                  , SUM(tmpData.Amount6)      AS Amount6
                  , SUM(tmpData.Summa6)       AS Summa6
                  , SUM(tmpData.SummaSale6)   AS SummaSale6

                  , SUM(tmpData.Amount7)      AS Amount7
                  , SUM(tmpData.Summa7)       AS Summa7
                  , SUM(tmpData.SummaSale7)   AS SummaSale7

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
 21.03.16         *
*/
-- тест
-- SELECT * FROM gpReport_PriceIntervention (inUnitId:= 0, inStartDate:= '20150801'::TDateTime, inEndDate:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
