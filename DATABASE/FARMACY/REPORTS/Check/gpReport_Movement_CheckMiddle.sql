-- Function:  gpReport_Movement_CheckMiddle()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckMiddle(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inisDay            Boolean,    -- по дням
    IN inValue1           TFloat ,
    IN inValue2           TFloat ,
    IN inValue3           TFloat ,
    IN inValue4           TFloat ,
    IN inValue5           TFloat ,
    IN inValue6           TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  OperDate       TDateTime,
  UnitName       TVarChar,

  Amount                TFloat,      -- кол-во чеков за день (шт)
  AmountPeriod          Tfloat,      -- кол-во чеков за период (шт)
  
  SummaSale             TFloat,      -- сумма продажи за день
  SummaMiddle           Tfloat,      -- средний чек за день (кол-во чеков за день (шт)/сумма продажи за день (грн))
  
  SummaSalePeriod       TFloat,      -- сумма чеков за период (грн) 
  SummaMiddlePeriod     TFloat,      -- средний чек за период (кол-во чеков за период (шт)/сумма чеков за период (грн))

  Amount1                TFloat,
  SummaSale1             TFloat,
  SummaMiddle1           Tfloat,
  Amount2                TFloat,
  SummaSale2             TFloat,
  SummaMiddle2           Tfloat,
  Amount3                TFloat,
  SummaSale3             TFloat,
  SummaMiddle3           Tfloat,
  Amount4                TFloat,
  SummaSale4             TFloat,
  SummaMiddle4           Tfloat,
  Amount5                TFloat,
  SummaSale5             TFloat,
  SummaMiddle5           Tfloat,
  Amount6                TFloat,
  SummaSale6             TFloat,
  SummaMiddle6           Tfloat,
  Amount7                TFloat,
  SummaSale7             TFloat,
  SummaMiddle7           Tfloat,
  
  Color_Amount       Integer,
  Color_Summa        Integer,
  Color_SummaSale    Integer

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
          WITH tmpMI AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                              , Movement_Check.Id
                              , CASE WHEN inisDAy = True THEN date_trunc('day', Movement_Check.OperDate) ELSE NULL END ::TDateTime  AS OperDate
                              , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId=0)
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
                           AND date_trunc('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY Movement_Check.Id
                                , MovementLinkObject_Unit.ObjectId
                                , CASE WHEN inisDAy = True THEN date_trunc('day', Movement_Check.OperDate) ELSE NULL END
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                        )

          /*, tmpData AS (select tmpMI.Unitid
                             , tmpMI.OperDate 
                             , count(*)  AS Amount        ---колво документов за день
                             , sum (tmpMI.SummaSale)  AS SummaSale -- сумма чеков
                        FROM  tmpMI
                        group by tmpMI.Unitid, tmpMI.OperDate
                        )
*/
          , tmpPeriod AS (select tmpMI.Unitid
                               , count(*)  AS AmountPeriod    -- колво документов за весь период
                               , sum (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                          from  tmpMI
                          group by tmpMI.Unitid
                          )
                          
       , tmpData   AS  ( SELECT tmpMI.Unitid
                              , tmpMI.OperDate

                              , SUM (1 ) AS Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)<inValue1 THEN 1 ELSE 0 END ) AS Amount1
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)<inValue1 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale1
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue1 and COALESCE (tmpMI.SummaSale, 0)<inValue2 THEN 1 ELSE 0 END ) AS Amount2
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue1 and COALESCE (tmpMI.SummaSale, 0)<inValue2 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale2
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue2 and COALESCE (tmpMI.SummaSale, 0)<inValue3 THEN 1 ELSE 0 END ) AS Amount3
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue2 and COALESCE (tmpMI.SummaSale, 0)<inValue3 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale3
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue3 and COALESCE (tmpMI.SummaSale, 0)<inValue4 THEN 1 ELSE 0 END ) AS Amount4
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue3 and COALESCE (tmpMI.SummaSale, 0)<inValue4 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale4
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue4 and COALESCE (tmpMI.SummaSale, 0)<inValue5 THEN 1 ELSE 0 END ) AS Amount5
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue4 and COALESCE (tmpMI.SummaSale, 0)<inValue5 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale5
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue5 and COALESCE (tmpMI.SummaSale, 0)<inValue6 THEN 1 ELSE 0 END ) AS Amount6
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue5 and COALESCE (tmpMI.SummaSale, 0)<inValue6 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale6
                              
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue6 THEN 1 ELSE 0 END ) AS Amount7
                              , SUM (CASE WHEN COALESCE (tmpMI.SummaSale, 0)>=inValue6 THEN tmpMI.SummaSale ELSE 0 END ) AS SummaSale7

                           FROM tmpMI
                           GROUP BY tmpMI.Unitid
                                  , tmpMI.OperDate     
                          )




      
        SELECT tmpData.OperDate  ::TDateTime
             , Object_Unit.ValueData                 AS UnitName
            
            , tmpData.Amount               :: TFloat AS Amount
            , tmpPeriod.AmountPeriod       :: TFloat AS AmountPeriod
            
            , tmpData.SummaSale            :: TFloat AS SummaSale
            , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle

            , tmpPeriod.SummaSalePeriod    :: TFloat AS SummaSalePeriod
            , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END   :: TFloat AS SummaMiddlePeriod

            , tmpData.Amount1               :: TFloat AS Amount1
            , tmpData.SummaSale1            :: TFloat AS SummaSale1
            , CASE WHEN tmpData.Amount1 <> 0 THEN tmpData.SummaSale1 / tmpData.Amount1 ELSE 0 END   :: TFloat AS SummaMiddle1
            
            , tmpData.Amount2               :: TFloat AS Amount2
            , tmpData.SummaSale2            :: TFloat AS SummaSale2
            , CASE WHEN tmpData.Amount2 <> 0 THEN tmpData.SummaSale2 / tmpData.Amount2 ELSE 0 END   :: TFloat AS SummaMiddle2

            , tmpData.Amount3               :: TFloat AS Amount3
            , tmpData.SummaSale3            :: TFloat AS SummaSale3
            , CASE WHEN tmpData.Amount3 <> 0 THEN tmpData.SummaSale3 / tmpData.Amount3 ELSE 0 END   :: TFloat AS SummaMiddle3

            , tmpData.Amount4               :: TFloat AS Amount4
            , tmpData.SummaSale4            :: TFloat AS SummaSale4
            , CASE WHEN tmpData.Amount4 <> 0 THEN tmpData.SummaSale4 / tmpData.Amount4 ELSE 0 END   :: TFloat AS SummaMiddle4

            , tmpData.Amount5               :: TFloat AS Amount5
            , tmpData.SummaSale5            :: TFloat AS SummaSale5
            , CASE WHEN tmpData.Amount5 <> 0 THEN tmpData.SummaSale5 / tmpData.Amount5 ELSE 0 END   :: TFloat AS SummaMiddle5

            , tmpData.Amount6               :: TFloat AS Amount6
            , tmpData.SummaSale6            :: TFloat AS SummaSale6
            , CASE WHEN tmpData.Amount6 <> 0 THEN tmpData.SummaSale6 / tmpData.Amount6 ELSE 0 END   :: TFloat AS SummaMiddle6

            , tmpData.Amount7               :: TFloat AS Amount7
            , tmpData.SummaSale7            :: TFloat AS SummaSale7
            , CASE WHEN tmpData.Amount7 <> 0 THEN tmpData.SummaSale7 / tmpData.Amount7 ELSE 0 END   :: TFloat AS SummaMiddle7

            , 14941410  :: Integer  AS Color_Amount            --нежно сал.14941410  -- 
            , 16777158  :: Integer  AS Color_Summa           -- желтый 8978431
            , 8978431   :: Integer  AS Color_SummaSale       --голубой 16380671
           
        FROM  tmpData
             LEFT JOIN tmpPeriod On tmpPeriod.UnitId = tmpData.UnitId 
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 

        ORDER BY 2, 1 ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.04.16         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_CheckMiddle(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateEnd := ('29.02.2016')::TDateTime , inSession := '3');
