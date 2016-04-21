-- Function:  gpReport_Movement_CheckMiddle()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckMiddle(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
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
  SummaMiddlePeriod     TFloat      -- средний чек за период (кол-во чеков за период (шт)/сумма чеков за период (грн))
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
                              , date_trunc('day', Movement_Check.OperDate)   AS OperDate
                              , SUM (COALESCE (MI_Check.Amount,0) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
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

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND date_trunc('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                         GROUP BY Movement_Check.Id
                                , MovementLinkObject_Unit.ObjectId
                                , date_trunc('day', Movement_Check.OperDate)
                         HAVING SUM (COALESCE (MI_Check.Amount,0)) <> 0
                        )


          , tmpData AS (select tmpMI.Unitid
                             , tmpMI.OperDate 
                             , count(*)  AS Amount        ---колво документов за день
                             , sum (tmpMI.SummaSale)  AS SummaSale -- сумма чеков
                        FROM  tmpMI
                        group by tmpMI.Unitid, tmpMI.OperDate
                        )

          , tmpPeriod AS (select tmpMI.Unitid
                               , count(*)  AS AmountPeriod    -- колво документов за весь период
                               , sum (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                          from  tmpMI
                          group by tmpMI.Unitid
                          )


      
        SELECT tmpData.OperDate  ::TDateTime
             , Object_Unit.ValueData                 AS UnitName
            
            , tmpData.Amount               :: TFloat AS Amount
            , tmpPeriod.AmountPeriod       :: TFloat AS AmountPeriod
            
            , tmpData.SummaSale            :: TFloat AS SummaSale
            , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle

            , tmpPeriod.SummaSalePeriod    :: TFloat AS SummaSalePeriod
            , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END   :: TFloat AS SummaMiddlePeriod
        
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
