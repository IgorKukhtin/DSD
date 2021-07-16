-- Function:  gpReport_CheckMiddle_Detail()

DROP FUNCTION IF EXISTS gpReport_CheckMiddle_Detail (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_CheckMiddle_Detail (Integer, Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_CheckMiddle_Detail(
    IN inUnitId           Integer,
    IN inRetailId         Integer,
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inisDay            Boolean,    -- по дням
    IN inisMonth          Boolean,    -- по дням
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   --DECLARE vbObjectId Integer;
   DECLARE vbDateStart TDateTime;  
   DECLARE vbDateEnd   TDateTime;
   DECLARE vbDays Integer;
      
   DECLARE Cursor1 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Контролшь использования подразделения
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

    -- определяется <Торговая сеть>
    --vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- кол-во дней периода
    vbDays := (SELECT DATE_PART('DAY', (inDateEnd - inDateStart )) + 1);

    OPEN Cursor1 FOR
     
          WITH
          -- все подразделения торговой сети
          tmpUnit  AS  (SELECT inUnitId AS UnitId
                        WHERE inUnitId <> 0
                       UNION
                        SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)   --vbObjectId
                        WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                          AND inUnitId = 0
                       )
        , tmpMovementCheck AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                         , Movement_Check.Id
                         , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement_Check.OperDate) 
                                WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Check.OperDate) 
                                ELSE NULL END              ::TDateTime  AS OperDate
                        FROM Movement AS Movement_Check
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         -- если пользователь выбрал подразделения другой торг.сети
                         -- или inUnitId=0,
                         -- делаем доп.ограничение подразделениями текущей торг.сети
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                    WHERE Movement_Check.DescId = zc_Movement_Check()
                      AND DATE_TRUNC('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                      AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                    GROUP BY Movement_Check.Id
                           , MovementLinkObject_Unit.ObjectId
                           , CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Check.OperDate) 
                                  WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Check.OperDate)
                                  ELSE NULL END
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
        
        , tmpMF_TotalSummChangePercent AS (SELECT MovementFloat_TotalSummChangePercent.*
                                           FROM  MovementFloat AS MovementFloat_TotalSummChangePercent
                                           WHERE MovementFloat_TotalSummChangePercent.DescId =  zc_MovementFloat_TotalSummChangePercent()
                                             AND MovementFloat_TotalSummChangePercent.MovementId IN (SELECT tmpMovementCheck.Id FROM tmpMovementCheck)
                                          )

        , tmpCheck AS (SELECT Movement_Check.UnitId
                            , Movement_Check.Id
                            , Movement_Check.OperDate
                            , SUM (CASE WHEN COALESCE (tmpMovSP.MovementId, 0) <> 0 AND MovementLinkObject_SPKind.ObjectId <> zc_Enum_SPKind_1303()
                                        THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0)
                                        ELSE 0
                                   END) AS SummChangePercent_SP
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()
                                        THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) 
                                        ELSE 0 
                                   END) AS SummSale_1303
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END) AS Count_1303
                       FROM tmpMovementCheck AS Movement_Check
                            LEFT JOIN tmpMLO_SPKind AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                            -- док. соц. проекта                        
                            LEFT JOIN tmpMovSP ON tmpMovSP.MovementId = Movement_Check.Id
                            -- ИТОГО сумма скидки
                            LEFT JOIN tmpMF_TotalSummChangePercent AS MovementFloat_TotalSummChangePercent
                                                                   ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                     
                       GROUP BY Movement_Check.Id
                              , Movement_Check.UnitId
                              , Movement_Check.OperDate
                      )
                   
        , tmpMI_All AS (SELECT Movement_Check.UnitId
                             , Movement_Check.OperDate
                             , Movement_Check.Id
                             , (COALESCE (Movement_Check.SummChangePercent_SP, 0))   AS SummChangePercent_SP
                             , (COALESCE (Movement_Check.SummSale_1303, 0))          AS SummSale_1303
                             , (COALESCE (Movement_Check.Count_1303, 0))             AS Count_1303
                             , MI_Check.Id             AS MI_Id
                             , MI_Check.Amount
                        FROM tmpCheck AS Movement_Check
                             INNER JOIN MovementItem AS MI_Check
                                                     ON MI_Check.MovementId = Movement_Check.Id
                                                    AND MI_Check.DescId = zc_MI_Master()
                                                    AND MI_Check.isErased = FALSE
                       )
        , tmpMIF_Price AS (SELECT MIFloat_Price.*
                           FROM MovementItemFloat AS MIFloat_Price
                           WHERE MIFloat_Price.DescId = zc_MIFloat_Price()
                             AND MIFloat_Price.MovementItemId IN (SELECT tmpMI_All.MI_Id FROM tmpMI_All)
                           )
        , tmpMIContainer AS (SELECT MIContainer.*
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.DescId = zc_MIContainer_Count() 
                               AND MIContainer.MovementItemId IN (SELECT tmpMI_All.MI_Id FROM tmpMI_All)
                             )
                                    
        , tmpMI AS (SELECT MI_Check.UnitId
                         , MI_Check.OperDate
                         , COALESCE (MI_Check.SummChangePercent_SP, 0)    AS SummChangePercent_SP
                         , COALESCE (MI_Check.SummSale_1303, 0)           AS SummSale_1303
                         , COALESCE (MI_Check.Count_1303, 0)              AS Count_1303
                         , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0))   AS SummaSale
                    FROM tmpMI_All AS MI_Check
                         LEFT JOIN tmpMIF_Price AS MIFloat_Price
                                                ON MIFloat_Price.MovementItemId = MI_Check.MI_Id
                                  
                         LEFT JOIN tmpMIContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.MI_Id
                    GROUP BY MI_Check.UnitId
                           , MI_Check.OperDate
                           , MI_Check.Id
                           , (COALESCE (MI_Check.SummChangePercent_SP, 0))
                           , (COALESCE (MI_Check.SummSale_1303, 0))
                           , (COALESCE (MI_Check.Count_1303, 0))
                    HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0 
                   )                                                               
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpMovement_Sale AS (SELECT CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Sale.OperDate)
                                           WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement_Sale.OperDate)
                                           ELSE NULL END              ::TDateTime  AS OperDate
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
                                 AND Movement_Sale.OperDate >= inDateStart AND Movement_Sale.OperDate < inDateEnd + INTERVAL '1 DAY'
                                 AND ( COALESCE (MovementString_InvNumberSP.ValueData,'') <> ''
                                     )
                                 AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                               )

        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate      AS OperDate
                                , Movement_Sale.UnitId        AS UnitId
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                               -- , SUM (Movement_Sale.Count_1303)  AS Count_1303
                                , Count (DISTINCT Movement_Sale.Id)          AS Count_1303
                           FROM tmpMovement_Sale AS Movement_Sale
                                INNER JOIN MovementItem AS MI_Sale
                                                        ON MI_Sale.MovementId = Movement_Sale.Id
                                                       AND MI_Sale.DescId = zc_MI_Master()
                                                       AND MI_Sale.isErased = FALSE
                           
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MI_Sale.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
  
                                LEFT JOIN MovementItemContainer AS MIContainer
                                                                ON MIContainer.MovementItemId = MI_Sale.Id
                                                               AND MIContainer.DescId = zc_MIContainer_Count() 
                           GROUP BY Movement_Sale.OperDate
                                  , Movement_Sale.UnitId
                           ) 
       , tmpDiscount AS (SELECT MovementLinkObject_Unit.ObjectId                                                 AS UnitID
                              , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement.OperDate) 
                                WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement.OperDate) 
                                ELSE NULL END              ::TDateTime                                           AS OperDate   
                              , sum(MovementFloat_TotalSummChangePercent.ValueData)                              AS SummChange
                         FROM Movement

                              INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                            ON MovementLinkObject_DiscountCard.MovementID = Movement.ID
                                                           AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
                                                           AND MovementLinkObject_DiscountCard.ObjectId <> 0

                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementID = Movement.ID
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                                       ON MovementFloat_TotalSummChangePercent.MovementID = Movement.ID
                                                      AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                              LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                                      ON MovementFloat_TotalSummSale.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

                         WHERE Movement.OperDate >= inDateStart
                           AND Movement.OperDate < inDateEnd + INTERVAL '1 DAY'
                           AND Movement.DescId = zc_Movement_Check()
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement.OperDate) 
                                       WHEN inisMonth = TRUE THEN DATE_TRUNC('Month', Movement.OperDate) 
                                       ELSE NULL END, MovementLinkObject_Unit.ObjectId)
                       
        , tmpPeriod AS (SELECT tmpMI.Unitid
                             , tmpMI.OperDate
                             , COUNT(*)  AS AmountPeriod    -- колво документов за весь период
                             , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                        FROM  tmpMI
                        GROUP BY tmpMI.Unitid
                               , tmpMI.OperDate
                        )

       , tmpData AS (SELECT tmpMI.Unitid
                           , tmpMI.OperDate

                           , SUM (tmpMI.Amount) AS Amount
                           , SUM (tmpMI.SummaSale) AS SummaSale
                           
                           , SUM (tmpMI.SummChangePercent_SP) AS SummSale_SP
                           , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                           , SUM (tmpMI.Count_1303)           AS Count_1303
                           , SUM (tmpMI.SummDiscount)         AS SummDiscount
                           
                      FROM (SELECT COALESCE (tmpMI.Unitid, tmpSale_1303.Unitid)     AS UnitId
                                   , COALESCE (tmpMI.OperDate, tmpSale_1303.OperDate) AS OperDate
                                   , COALESCE (tmpMI.Amount, 0)                       AS Amount
                                   , COALESCE (tmpMI.SummChangePercent_SP, 0)         AS SummChangePercent_SP
                                   , COALESCE (tmpMI.SummaSale,0)                     AS SummaSale
                                   , COALESCE (tmpMI.SummSale_1303, 0) + COALESCE (tmpSale_1303.SummSale_1303, 0)  AS SummSale_1303
                                   , COALESCE (tmpSale_1303.Count_1303, 0)            AS Count_1303      
                                   , COALESCE (tmpDiscount.SummChange, 0)             AS SummDiscount
                            FROM
                                (SELECT tmpMI.Unitid
                                      , tmpMI.OperDate
                                      , SUM (1 )                         AS Amount
                                      , SUM (tmpMI.SummaSale)            AS SummaSale
                                      , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                                      , SUM (tmpMI.SummChangePercent_SP) AS SummChangePercent_SP
                                 FROM tmpMI
                                 GROUP BY tmpMI.Unitid
                                        , tmpMI.OperDate 
                                 ) AS tmpMI
                                   FULL JOIN tmpSale_1303 ON tmpSale_1303.Unitid = tmpMI.Unitid
                                                         AND (COALESCE (tmpSale_1303.OperDate, Null) = COALESCE (tmpMI.OperDate, Null) OR (inisMonth = FALSE AND inisDay = FALSE))
                                   LEFT JOIN tmpDiscount  ON tmpDiscount.UnitId = COALESCE (tmpMI.Unitid, tmpSale_1303.Unitid)
                                                         AND (inisMonth = FALSE AND inisDay = FALSE OR tmpDiscount.OperDate = COALESCE (tmpMI.OperDate, tmpSale_1303.OperDate))
                            ) AS tmpMI
                            GROUP BY tmpMI.Unitid
                                   , tmpMI.OperDate 
                      )

        , DataResult AS(SELECT tmpData.OperDate
                             , tmpData.UnitId
                             
                             , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.AmountPeriod / vbDays ELSE tmpData.Amount END             :: TFloat AS Amount
                             --, tmpData.Amount                :: TFloat AS Amount
                             , tmpPeriod.AmountPeriod        :: TFloat AS AmountPeriod
                             
                             , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.SummaSalePeriod / vbDays ELSE tmpData.SummaSale END       :: TFloat AS SummaSale
                             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle
                 
                             , tmpPeriod.SummaSalePeriod     :: TFloat AS SummaSalePeriod
                             , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END   :: TFloat AS SummaMiddlePeriod
                 
                             , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
                             , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
                             , tmpData.Count_1303            :: TFloat AS Count_1303
                             , tmpData.SummDiscount          :: TFloat AS SummDiscount
                             
                             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  :: TFloat AS SummaSaleWithSP
                             , CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddleWithSP
                             , (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))                                                              :: TFloat AS AmountWith_1303 
                             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) + COALESCE (tmpData.SummDiscount, 0)) :: TFloat AS SummaSaleAll
                             , CASE WHEN (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0)) <> 0 
                                    THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) + COALESCE (tmpData.SummDiscount, 0)) / (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))
                                    ELSE 0 
                               END       :: TFloat   AS SummaMiddleAll

                        FROM tmpData
                             LEFT JOIN tmpPeriod ON tmpPeriod.UnitId = tmpData.UnitId 
                                                AND ((COALESCE(tmpPeriod.OperDate, NULL) = COALESCE(tmpData.OperDate, NULL)) 
                                                  OR (inisMonth = FALSE AND inisDay = FALSE))
                       )

        -- находим кол-во чеков и сумму текущего и прошлого месяцев
        , tmpLast AS (SELECT tmp.OperDate
                           , tmp.UnitId
                           , CASE WHEN COALESCE (tmp.Amount_PeriodLast, 0) <> 0         THEN (tmp.AmountWith_1303 / tmp.Amount_PeriodLast         * 100) - 100 ELSE 0 END AS Persent_AmountLast
                           , CASE WHEN COALESCE (tmp.SummaMiddleAll_PeriodLast, 0) <> 0 THEN (tmp.SummaMiddleAll  / tmp.SummaMiddleAll_PeriodLast * 100) - 100 ELSE 0 END AS Persent_SummaLast
                      FROM (SELECT t1.OperDate
                                 , t1.UnitId
                                 , t1.AmountWith_1303
                                 , t1.SummaMiddleAll
                                 , t2.AmountWith_1303     AS Amount_PeriodLast
                                 , t2.SummaMiddleAll      AS SummaMiddleAll_PeriodLast
                            FROM DataResult AS t1
                                 LEFT JOIN DataResult AS t2 
                                                      ON t2.Unitid = t1.Unitid
                                                     AND t2.OperDate = t1.OperDate - INTERVAL '1 Month'
                            WHERE inisMonth = TRUE
                           ) AS tmp
                     )
        

        -- результат      
        SELECT tmpData.OperDate            ::TDateTime AS OperDate
             , Object_Unit.ValueData                   AS UnitName
             , Object_Retail.ValueData                 AS RetailName 
             , Object_Juridical.ValueData              AS JuridicalName
             , tmpData.Amount                :: TFloat AS Amount
             , tmpData.AmountPeriod          :: TFloat AS AmountPeriod
             
             , tmpData.SummaSale             :: TFloat AS SummaSale
             , tmpData.SummaMiddle           :: TFloat AS SummaMiddle
 
             , tmpData.SummaSalePeriod       :: TFloat AS SummaSalePeriod
             , tmpData.SummaMiddlePeriod     :: TFloat AS SummaMiddlePeriod
 
             , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
             , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
             , tmpData.Count_1303            :: TFloat AS Count_1303
             , tmpData.SummDiscount          :: TFloat AS SummDiscount
             
             , tmpData.SummaSaleWithSP       :: TFloat AS SummaSaleWithSP
             , tmpData.SummaMiddleWithSP     :: TFloat AS SummaMiddleWithSP
             , tmpData.AmountWith_1303       :: TFloat AS AmountWith_1303 
             , tmpData.SummaSaleAll          :: TFloat AS SummaSaleAll
             , tmpData.SummaMiddleAll        :: TFloat AS SummaMiddleAll
 
             , COALESCE (CAST (CASE WHEN tmpData.SummaMiddleAll <> 0 THEN (tmpData.SummaMiddleAll * 100 / DataResult.SummaMiddleAll) - 100  ELSE 0 END  AS NUMERIC (16,2)), 0) :: TFloat AS PersentMiddle
             
             , COALESCE (CAST (tmpLast.Persent_AmountLast AS NUMERIC (16,2)), 0) :: TFloat AS Persent_AmountLast
             , COALESCE (CAST (tmpLast.Persent_SummaLast  AS NUMERIC (16,2)), 0) :: TFloat AS Persent_SummaLast
        FROM DataResult AS tmpData
             LEFT JOIN DataResult ON DataResult.UnitId = tmpData.UnitId
                                 AND ((DataResult.OperDate + interval '1 month' = tmpData.OperDate AND inisMonth = TRUE) 
                                   OR (DataResult.OperDate + interval '1 day' = tmpData.OperDate AND inisDay = TRUE)
                                   OR (inisMonth = FALSE AND inisDay = FALSE))

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
             
             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
             
             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

             LEFT JOIN tmpLast ON tmpLast.UnitId   = tmpData.UnitId
                              AND tmpLast.OperDate = tmpData.OperDate
                     
        ORDER BY 2, 1 ;

    RETURN NEXT Cursor1;
             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

   
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 09.04.19         * из Суммы реимбурсации убираем суммы по пост.1303
 21.06.18                                                                                     *
 24.01.18         *
 09.10.17         *
*/

-- тест
--select * from gpReport_CheckMiddle_Detail(inUnitId := 183292, inRetailId:=0, inDateStart := ('01.01.2016')::TDateTime , inDateEnd := ('31.03.2016')::TDateTime , inisDay := 'FALSE' ::boolean , inisMonth:= 'TRUE' ::boolean , inSession := '3' ::TVarChar);
-- FETCH ALL "<unnamed portal 18>";

select * from gpReport_CheckMiddle_Detail(13338606 , 0 , ('01.06.2021')::TDateTime , ('30.06.2021')::TDateTime , 'False' , 'False' ,  '3');