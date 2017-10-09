-- Function:  gpReport_Movement_CheckMiddle()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, Boolean, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckMiddle(
    IN inUnitId           Integer,
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inisDay            Boolean,    -- по дням
    IN inMonth            TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbDateStart TDateTime;  
   DECLARE vbDateEnd   TDateTime;
   
   DECLARE Cursor1 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    vbDateStart:= DATE_TRUNC('month', inDateStart) - ( (''|| inMonth ||' MONTH') :: Interval );
    vbDateEnd:= DATE_TRUNC('month', inDateStart);                         --  Interval '1 Day';

    OPEN Cursor1 FOR
     
          WITH
          -- все подразделения торговой сети
          tmpUnit  AS  (SELECT inUnitHistoryId AS UnitId
                        WHERE inUnitHistoryId <> 0
                       UNION
                        SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId =  vbObjectId
                        WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND inUnitHistoryId = 0
                       )
        , tmpMovementCheck AS (SELECT Movement_Check.Id
                                    --, DATE_TRUNC('Month', Movement_Check.OperDate)   AS OperDate
                                    , CASE WHEN inisDay = TRUE THEN DATE_TRUNC('Day', Movement_Check.OperDate) ELSE DATE_TRUNC('Month', Movement_Check.OperDate) END   AS OperDate
                               FROM Movement AS Movement_Check
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
           
                               WHERE Movement_Check.DescId = zc_Movement_Check()
                                 AND Movement_Check.OperDate >= vbDateStart AND Movement_Check.OperDate < vbDateEnd    ---inDateEnd + interval '1 day'--
                                 AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                               GROUP BY Movement_Check.Id
                                      --, DATE_TRUNC('Month', Movement_Check.OperDate) 
                                      , CASE WHEN inisDay = TRUE THEN DATE_TRUNC('Day', Movement_Check.OperDate) ELSE DATE_TRUNC('Month', Movement_Check.OperDate) END
                              )
        -- док. соц проекта, если заполнен № рецепта
        , tmpMovSP AS (SELECT DISTINCT MovementString_InvNumberSP.MovementId
                       FROM MovementString AS MovementString_InvNumberSP
                       WHERE MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                         AND MovementString_InvNumberSP.ValueData <> ''
                         AND MovementString_InvNumberSP.MovementId IN (SELECT DISTINCT tmpMovementCheck.Id FROM tmpMovementCheck)
                       )
                                
        , tmpMLO_SPKind AS (SELECT MovementLinkObject_SPKind.*
                            FROM MovementLinkObject AS MovementLinkObject_SPKind
                            WHERE MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                              AND MovementLinkObject_SPKind.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                            )
        -- ИТОГО сумма скидки
        , tmpMF_TotalSummChangePercent AS (SELECT MovementFloat_TotalSummChangePercent.*
                                           FROM MovementFloat AS MovementFloat_TotalSummChangePercent
                                           WHERE MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
                                             AND MovementFloat_TotalSummChangePercent.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                                          )
                                       
        , tmpCheck AS (SELECT Movement_Check.Id
                            --, DATE_TRUNC('Month', Movement_Check.OperDate)      
                            , CASE WHEN inisDay = TRUE THEN DATE_TRUNC('Day', Movement_Check.OperDate) ELSE DATE_TRUNC('Month', Movement_Check.OperDate) END                                                            AS OperDate
                            , SUM (CASE WHEN COALESCE (tmpMovSP.MovementId, 0) <> 0 THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END)                     AS SummChangePercent_SP
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummSale_1303
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END)                  AS Count_1303
                       FROM tmpMovementCheck AS Movement_Check
                            LEFT JOIN tmpMLO_SPKind AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                            
                            LEFT JOIN tmpMovSP ON tmpMovSP.MovementId = Movement_Check.Id
                            
                            -- ИТОГО сумма скидки
                            LEFT JOIN tmpMF_TotalSummChangePercent AS MovementFloat_TotalSummChangePercent
                                                                   ON MovementFloat_TotalSummChangePercent.MovementId = Movement_Check.Id
                       GROUP BY Movement_Check.Id
                              , CASE WHEN inisDay = TRUE THEN DATE_TRUNC('Day', Movement_Check.OperDate) ELSE DATE_TRUNC('Month', Movement_Check.OperDate) END
                      )

        , tmpMI AS (SELECT Movement_Check.OperDate
                         , Movement_Check.Id
                         , SUM (COALESCE (MI_Check.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0))   AS SummaSale
                    FROM tmpCheck AS Movement_Check
                         INNER JOIN MovementItem AS MI_Check
                                                 ON MI_Check.MovementId = Movement_Check.Id
                                                AND MI_Check.DescId = zc_MI_Master()
                                                AND MI_Check.isErased = FALSE
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MI_Check.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                    GROUP BY Movement_Check.OperDate
                           , Movement_Check.Id
                   )
                   
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate             AS OperDate
                                , SUM (COALESCE (MI_Sale.Amount, 0) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                                , Count (DISTINCT Movement_Sale.Id)  AS Count_1303   
                           FROM (SELECT --DATE_TRUNC('Month', Movement_Sale.OperDate)  AS OperDate
                                        CASE WHEN inisDay = TRUE THEN DATE_TRUNC('Day', Movement_Sale.OperDate) ELSE DATE_TRUNC('Month', Movement_Sale.OperDate) END AS OperDate
                                      , MovementLinkObject_Unit.ObjectId             AS UnitId
                                      , Movement_Sale.Id                             AS Id
                                      , 1                                            AS Count_1303
                                 FROM Movement AS Movement_Sale
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                      INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                      
                                      LEFT JOIN MovementString AS MovementString_InvNumberSP
                                             ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                            AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()

                                 WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                   AND Movement_Sale.OperDate >= vbDateStart AND Movement_Sale.OperDate < vbDateEnd  -- inDateEnd + interval '1 day' --
                                   AND (COALESCE (MovementString_InvNumberSP.ValueData,'') <> '')
                                   AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                 ) AS Movement_Sale
                                 INNER JOIN MovementItem AS MI_Sale
                                                         ON MI_Sale.MovementId = Movement_Sale.Id
                                                        AND MI_Sale.DescId = zc_MI_Master()
                                                        AND MI_Sale.isErased = FALSE
                            
                                 LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                             ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                            AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
   
                           GROUP BY Movement_Sale.OperDate
                           ) 
                       
          , tmpPeriod AS (SELECT tmpMI.OperDate
                               , COUNT(*)  AS AmountPeriod    -- колво документов за весь период
                               , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                          FROM tmpMI
                          GROUP BY tmpMI.OperDate
                          )
                          
          , tmpData AS ( SELECT tmpMI.OperDate
                              , SUM (1 ) AS Amount
                              , SUM (tmpMI.SummaSale) AS SummaSale
                              
                              , SUM (tmpMI.SummChangePercent_SP) AS SummSale_SP
                              , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                              , SUM (tmpMI.Count_1303)           AS Count_1303
                              
                           FROM (SELECT tmpMI.OperDate
                                      , tmpMI.SummChangePercent_SP
                                      , tmpMI.SummaSale
                                      , COALESCE (tmpMI.SummSale_1303, 0) + COALESCE (tmpSale_1303.SummSale_1303, 0)  AS SummSale_1303
                                      , COALESCE (tmpMI.Count_1303, 0) + COALESCE (tmpSale_1303.Count_1303, 0)        AS Count_1303
                                 FROM (SELECT tmpCheck.OperDate
                                            , SUM (tmpCheck.SummChangePercent_SP)  AS SummChangePercent_SP
                                            , SUM (tmpMI.SummaSale)                AS SummaSale
                                            , SUM (tmpCheck.SummSale_1303)         AS SummSale_1303
                                            , SUM (tmpCheck.Count_1303)            AS Count_1303
                                       FROM tmpCheck
                                            LEFT JOIN tmpMI ON tmpMI.Id = tmpCheck.Id
                                       GROUP BY tmpCheck.OperDate
                                       ) AS tmpMI
                                      LEFT JOIN tmpSale_1303 ON tmpSale_1303.OperDate = tmpMI.OperDate
                                 ) AS tmpMI
                           GROUP BY tmpMI.OperDate     
                          )
                          
          , DataResult AS (SELECT tmpData.OperDate
                                
                                , tmpData.Amount                AS Amount
                                , tmpPeriod.AmountPeriod        AS AmountPeriod
                                
                                , tmpData.SummaSale             AS SummaSale
                                , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END  AS SummaMiddle
                    
                                , tmpPeriod.SummaSalePeriod     AS SummaSalePeriod
                                , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END  AS SummaMiddlePeriod
                    
                                , tmpData.SummSale_SP           AS SummSale_SP
                                , tmpData.SummSale_1303         AS SummSale_1303
                                , tmpData.Count_1303            AS Count_1303
                                
                                , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  AS SummaSaleWithSP
                                , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpPeriod.AmountPeriod  ELSE 0 END  AS SummaMiddleWithSP
                                
                                , (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))                                                              AS AmountWith_1303
                                 
                                , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0))                            AS SummaSaleAll
                                , CASE WHEN (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0)) <> 0 
                                       THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) / (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))
                                       ELSE 0 
                                  END          AS SummaMiddleAll
                             
                           FROM tmpData
                                LEFT JOIN tmpPeriod On tmpPeriod.OperDate = tmpData.OperDate
                           ) 

        -- результат      
        SELECT tmpData.OperDate  ::TDateTime
             
             , tmpData.Amount               :: TFloat AS Amount
             , tmpData.AmountPeriod         :: TFloat AS AmountPeriod
             
             , tmpData.SummaSale            :: TFloat AS SummaSale
             , tmpData.SummaMiddle          :: TFloat AS SummaMiddle
 
             , tmpData.SummaSalePeriod      :: TFloat AS SummaSalePeriod
             , tmpData.SummaMiddlePeriod    :: TFloat AS SummaMiddlePeriod
 
             , tmpData.SummSale_SP          :: TFloat AS SummSale_SP
             , tmpData.SummSale_1303        :: TFloat AS SummSale_1303
             , tmpData.Count_1303           :: TFloat AS Count_1303
             
             , tmpData.SummaSaleWithSP      :: TFloat AS SummaSaleWithSP
             , tmpData.SummaMiddleWithSP    :: TFloat AS SummaMiddleWithSP
             
             , tmpData.AmountWith_1303      :: TFloat AS AmountWith_1303
              
             , tmpData.SummaSaleAll         :: TFloat AS SummaSaleAll
             , tmpData.SummaMiddleAll       :: TFloat AS SummaMiddleAll
             
             , CAST (CASE WHEN tmpData.SummaMiddleAll <> 0 THEN (tmpData.SummaMiddleAll * 100 / DataResult.SummaMiddleAll) - 100  ELSE 0 END  AS NUMERIC (16.2)) AS PersentMiddle
          
        FROM DataResult AS tmpData
             LEFT JOIN DataResult ON DataResult.OperDate + interval '1 month' = tmpData.OperDate
        ORDER BY 1 ;
    RETURN NEXT Cursor1;
             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

   
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 09.10.17         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_CheckMiddle(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateEnd := ('29.02.2016')::TDateTime , inSession := '3');
--select * from gpReport_Movement_CheckMiddle(inUnitId := '183294,375626,389328'::TVarChar , inUnitHistoryId:= 389328, inDateStart := ('01.07.2017')::TDateTime , inDateEnd := ('31.07.2017')::TDateTime , inisDay := 'False' ::Boolean, inValue1 := 100 ::TFloat, inValue2 := 200 ::TFloat, inValue3 := 300::TFloat , inValue4 := 400::TFloat , inValue5 := 500 ::TFloat, inValue6 := 1000 ::TFloat,  inSession := '3'::TVarChar);
-- FETCH ALL "<unnamed portal 7>";----