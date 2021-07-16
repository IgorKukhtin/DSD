-- Function:  gpReport_Movement_CheckMiddle()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (TVarChar, Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (TVarChar, Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION  gpReport_Movement_CheckMiddle(
    IN inUnitId           TVarChar,--Integer  ,  -- Подразделение
    IN inUnitHistoryId    Integer,
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateEnd          TDateTime,  -- Дата окончания
    IN inisDay            Boolean,    -- по дням
    IN inValue1           TFloat ,
    IN inValue2           TFloat ,
    IN inValue3           TFloat ,
    IN inValue4           TFloat ,
    IN inValue5           TFloat ,
    IN inValue6           TFloat ,
    IN inMonth            TFloat ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbObjectId Integer;
   
   DECLARE vbDateStart TDateTime;  
   DECLARE vbDateEnd   TDateTime;
   
   DECLARE vbDays Integer;
   
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    --vbDateStart:= DATE_TRUNC('month', inDateStart) -  Interval '5 MONTH';
    vbDateStart:= DATE_TRUNC('month', inDateStart) - ( (''|| inMonth ||' MONTH') :: Interval );
    vbDateEnd:= DATE_TRUNC('month', inDateStart);                         --  Interval '1 Day';


    -- таблица
    CREATE TEMP TABLE _tmpUnit_List (UnitId Integer) ON COMMIT DROP;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnit_List (UnitId) SELECT SPLIT_PART (inUnitId, ',', vbIndex) :: Integer;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;
    
    -- кол-во дней периода
    vbDays := (SELECT DATE_PART('DAY', (inDateEnd - inDateStart )) + 1);
    
    -- 
    OPEN Cursor1 FOR
     
    -- Результат
          WITH
          -- все подразделения торговой сети
          tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId =  vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )
        , tmpMovementCheck AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                         , Movement_Check.Id
                         , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement_Check.OperDate) ELSE NULL END              ::TDateTime  AS OperDate
                        -- , SUM (COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0))                                            AS SummChangePercent_SP
                        -- , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummSale_1303
                        -- , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END)                  AS Count_1303
                    FROM Movement AS Movement_Check
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         INNER JOIN _tmpUnit_List ON (_tmpUnit_List.UnitId = MovementLinkObject_Unit.ObjectId OR COALESCE(inUnitId,'0') = '0')
                         -- если пользователь выбрал подразделения другой торг.сети
                         -- или inUnitId=0,
                         -- делаем доп.ограничение подразделениями текущей торг.сети
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                    WHERE Movement_Check.DescId = zc_Movement_Check()
                      AND DATE_TRUNC('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                      AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                    GROUP BY Movement_Check.Id
                           , MovementLinkObject_Unit.ObjectId
                           , CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Check.OperDate) ELSE NULL END
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
                                   END)                                                                                    AS SummSale_1303
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
        , tmpMovement_Sale AS (SELECT CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Sale.OperDate) ELSE NULL END ::TDateTime  AS OperDate
                                    , MovementLinkObject_Unit.ObjectId             AS UnitId
                                    , Movement_Sale.Id                             AS Id
                                    , 1                                            AS Count_1303
                               FROM Movement AS Movement_Sale
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                            ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN _tmpUnit_List ON (_tmpUnit_List.UnitId = MovementLinkObject_Unit.ObjectId OR COALESCE(inUnitId,'0') = '0')
                                    -- доп. огрн. по подразд. сети
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
                              , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement.OperDate) ELSE NULL END AS OperDate   
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
                         GROUP BY CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement.OperDate) ELSE NULL END, MovementLinkObject_Unit.ObjectId)
                       
        , tmpPeriod AS (SELECT tmpMI.Unitid
                             , COUNT(*)  AS AmountPeriod    -- колво документов за весь период
                             , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                        FROM  tmpMI
                        GROUP BY tmpMI.Unitid
                        )
                          
        , tmpData_Case AS (SELECT tmpMI.Unitid
                                , tmpMI.OperDate
     
                                , SUM (1 ) AS Amount
                                , SUM (tmpMI.SummaSale) AS SummaSale
                                
                                , SUM (tmpMI.SummChangePercent_SP) AS SummSale_SP
                                , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                               -- , SUM (tmpMI.Count_1303)           AS Count_1303
                                
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
        , tmpData AS (SELECT tmpData_Case.Unitid
                           , tmpData_Case.OperDate

                           , SUM (tmpData_Case.Amount)        AS Amount
                           , SUM (tmpData_Case.SummaSale)     AS SummaSale
                           
                           , SUM (tmpData_Case.SummSale_SP)   AS SummSale_SP
                           , SUM (tmpData_Case.SummSale_1303) AS SummSale_1303
                           , SUM (tmpData_Case.Count_1303)    AS Count_1303
                           , SUM (tmpData_Case.SummDiscount)  AS SummDiscount
                           
                           , SUM (tmpData_Case.Amount1)       AS Amount1
                           , SUM (tmpData_Case.SummaSale1)    AS SummaSale1
                           , SUM (tmpData_Case.Amount2)       AS Amount2
                           , SUM (tmpData_Case.SummaSale2)    AS SummaSale2
                           , SUM (tmpData_Case.Amount3)       AS Amount3
                           , SUM (tmpData_Case.SummaSale3)    AS SummaSale3
                           , SUM (tmpData_Case.Amount4)       AS Amount4
                           , SUM (tmpData_Case.SummaSale4)    AS SummaSale4
                           , SUM (tmpData_Case.Amount5)       AS Amount5
                           , SUM (tmpData_Case.SummaSale5)    AS SummaSale5
                           , SUM (tmpData_Case.Amount6)       AS Amount6
                           , SUM (tmpData_Case.SummaSale6)    AS SummaSale6                            
                           , SUM (tmpData_Case.Amount7)       AS Amount7
                           , SUM (tmpData_Case.SummaSale7)    AS SummaSale7    
     
                      FROM (SELECT COALESCE (tmpData_Case.Unitid, tmpSale_1303.Unitid)     AS UnitId
                                 , COALESCE (tmpData_Case.OperDate, tmpSale_1303.OperDate) AS OperDate
                                 , COALESCE (tmpData_Case.Amount, 0)                       AS Amount
                                 , COALESCE (tmpData_Case.SummSale_SP, 0)                  AS SummSale_SP
                                 , COALESCE (tmpData_Case.SummaSale,0)                     AS SummaSale
                                 , COALESCE (tmpData_Case.SummSale_1303, 0) + COALESCE (tmpSale_1303.SummSale_1303, 0)  AS SummSale_1303
                                 , COALESCE (tmpSale_1303.Count_1303, 0)                   AS Count_1303        -- COALESCE (tmpMI.Count_1303, 0) +
                                 , COALESCE (tmpDiscount.SummChange, 0)                    AS SummDiscount
                                 
                                 , COALESCE (tmpData_Case.Amount1, 0)    AS Amount1
                                 , COALESCE (tmpData_Case.SummaSale1, 0) AS SummaSale1
                                 , COALESCE (tmpData_Case.Amount2, 0)    AS Amount2
                                 , COALESCE (tmpData_Case.SummaSale2, 0) AS SummaSale2
                                 , COALESCE (tmpData_Case.Amount3, 0)    AS Amount3
                                 , COALESCE (tmpData_Case.SummaSale3, 0) AS SummaSale3
                                 , COALESCE (tmpData_Case.Amount4, 0)    AS Amount4
                                 , COALESCE (tmpData_Case.SummaSale4, 0) AS SummaSale4
                                 , COALESCE (tmpData_Case.Amount5, 0)    AS Amount5
                                 , COALESCE (tmpData_Case.SummaSale5, 0) AS SummaSale5
                                 , COALESCE (tmpData_Case.Amount6, 0)    AS Amount6
                                 , COALESCE (tmpData_Case.SummaSale6, 0) AS SummaSale6                            
                                 , COALESCE (tmpData_Case.Amount7, 0)    AS Amount7
                                 , COALESCE (tmpData_Case.SummaSale7, 0) AS SummaSale7                                        
                            FROM tmpData_Case 
                                 FULL JOIN tmpSale_1303 ON tmpSale_1303.Unitid = tmpData_Case.Unitid
                                                       AND (inisDAy = False OR tmpSale_1303.OperDate = tmpData_Case.OperDate)
                                 LEFT JOIN tmpDiscount  ON tmpDiscount.UnitId = COALESCE (tmpData_Case.Unitid, tmpSale_1303.Unitid)
                                                       AND (inisDAy = False OR tmpDiscount.OperDate = COALESCE (tmpData_Case.OperDate, tmpSale_1303.OperDate))
                                 
                            ) AS tmpData_Case
                      GROUP BY tmpData_Case.Unitid
                             , tmpData_Case.OperDate     
                     )                      
                            
                       
                       
        -- определяем лучшую и худшую аптеки по ср.чеку
        , tmpBestBad AS (SELECT tmp.*
                         FROM (SELECT tmp.*
                                    , Row_Number() OVER (ORDER BY SummaMiddleAll Asc)  AS Ord_Bad
                                    , Row_Number() OVER (ORDER BY SummaMiddleAll DESC) AS Ord_Best
                               FROM (SELECT tmpData.OperDate             
                                          , tmpData.UnitId
                                          , CASE WHEN (tmpData.Amount + COALESCE (tmpData.Count_1303, 0)) <> 0 
                                                 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) + COALESCE (tmpData.SummDiscount, 0)) / (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))
                                                 ELSE 0 
                                            END                           AS SummaMiddleAll                    
                                     FROM tmpData
                                    ) as tmp
                               ) as tmp
                         WHERE tmp.Ord_Best IN (1,2,3) OR tmp.Ord_Bad IN (1,2,3)
                         ) 

        -- результат      
        SELECT tmpData.OperDate  ::TDateTime
             , Object_Unit.ValueData                 AS UnitName
            
            , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.AmountPeriod / vbDays ELSE tmpData.Amount END             :: TFloat AS Amount
            --, tmpData.Amount                :: TFloat AS Amount
            , tmpPeriod.AmountPeriod        :: TFloat AS AmountPeriod
            
            , CASE WHEN inisDay = FALSE AND vbDays <> 0 THEN tmpPeriod.SummaSalePeriod / vbDays ELSE tmpData.SummaSale END       :: TFloat AS SummaSale
            , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle

            , tmpPeriod.SummaSalePeriod     :: TFloat AS SummaSalePeriod
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
            
            , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
            , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
            , tmpData.Count_1303            :: TFloat AS Count_1303
            , tmpData.SummDiscount          :: TFloat AS SummDiscount
            
            , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  :: TFloat AS SummaSaleWithSP
            , CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddleWithSP
            , (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))                                                              :: TFloat AS AmountWith_1303 
            , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) + COALESCE (tmpData.SummDiscount, 0))                            :: TFloat AS SummaSaleAll
            , CASE WHEN (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0)) <> 0 
                   THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0) + COALESCE (tmpData.SummDiscount, 0)) / (tmpPeriod.AmountPeriod + COALESCE (tmpData.Count_1303, 0))
                   ELSE 0 
              END       :: TFloat   AS SummaMiddleAll
            
            , 14941410  :: Integer  AS Color_Amount          --нежно сал.14941410  -- 
            , 16777158  :: Integer  AS Color_Summa           -- желтый 8978431
            , 8978431   :: Integer  AS Color_SummaSale       --голубой 16380671
           
            , CASE WHEN tmpBestBad.Ord_Best IN (1,2,3) THEN 8716164 
                   WHEN tmpBestBad.Ord_Bad  IN (1,2,3) THEN 10917116 
                   ELSE zc_Color_White()
              END   AS Color_Best        -- зеленый лучший   -- красный худший
  
        FROM  tmpData
             LEFT JOIN tmpPeriod On tmpPeriod.UnitId = tmpData.UnitId 
             
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId 
             
             LEFT JOIN tmpBestBad ON tmpBestBad.UnitId = tmpData.UnitId
                                 AND (CASE WHEN inisDay = TRUE THEN COALESCE (tmpBestBad.OperDate, Null) = COALESCE (tmpData.OperDate, Null) ELSE 1 = 1 END)

        ORDER BY 2, 1 ;
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
     
    -- Результат

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
                                    , DATE_TRUNC('Month', Movement_Check.OperDate)   AS OperDate
                               FROM Movement AS Movement_Check
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                    INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
           
                               WHERE Movement_Check.DescId = zc_Movement_Check()
                                 AND Movement_Check.OperDate >= vbDateStart AND Movement_Check.OperDate < vbDateEnd    ---inDateEnd + interval '1 day'--
                                 AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                               GROUP BY Movement_Check.Id
                                      , DATE_TRUNC('Month', Movement_Check.OperDate) 
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
                            , DATE_TRUNC('Month', Movement_Check.OperDate) AS OperDate
                            , SUM (CASE WHEN COALESCE (tmpMovSP.MovementId, 0) <> 0 AND MovementLinkObject_SPKind.ObjectId <> zc_Enum_SPKind_1303()
                                        THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0)
                                        ELSE 0
                                   END) AS SummChangePercent_SP

                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummSale_1303
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END) AS Count_1303
                       FROM tmpMovementCheck AS Movement_Check
                            LEFT JOIN tmpMLO_SPKind AS MovementLinkObject_SPKind
                                                    ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                            
                            LEFT JOIN tmpMovSP ON tmpMovSP.MovementId = Movement_Check.Id
                            
                            -- ИТОГО сумма скидки
                            LEFT JOIN tmpMF_TotalSummChangePercent AS MovementFloat_TotalSummChangePercent
                                                                   ON MovementFloat_TotalSummChangePercent.MovementId = Movement_Check.Id
                       GROUP BY Movement_Check.Id
                              , DATE_TRUNC('Month', Movement_Check.OperDate) 
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
                           FROM (SELECT DATE_TRUNC('Month', Movement_Sale.OperDate)  AS OperDate
                                      , MovementLinkObject_Unit.ObjectId             AS UnitId
                                      , Movement_Sale.Id                             AS Id
                                      , 1                                            AS Count_1303
                                 FROM Movement AS Movement_Sale
                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                              ON MovementLinkObject_Unit.MovementId = Movement_Sale.Id
                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                      --INNER JOIN _tmpUnit_List ON (_tmpUnit_List.UnitId = MovementLinkObject_Unit.ObjectId OR COALESCE(inUnitId,'0') = '0')
                                      -- доп. огрн. по подразд. сети
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
             
             , CAST (CASE WHEN tmpData.SummaMiddleAll <> 0 THEN (tmpData.SummaMiddleAll * 100 / DataResult.SummaMiddleAll) - 100  ELSE 0 END AS NUMERIC (16,1)) AS  PersentMiddle
          
        FROM DataResult AS tmpData
             LEFT JOIN DataResult ON DataResult.OperDate + interval '1 month' = tmpData.OperDate
        ORDER BY 1 ;
    RETURN NEXT Cursor2;
             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

   
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 09.04.19         * из Суммы реимбурсации убираем суммы по пост.1303
 09.10.17         *
 01.09.17         *
 25.04.17         * 
 21.04.16         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_CheckMiddle(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateEnd := ('29.02.2016')::TDateTime , inSession := '3');
--select * from gpReport_Movement_CheckMiddle(inUnitId := '183294,375626,389328'::TVarChar , inUnitHistoryId:= 389328, inDateStart := ('01.07.2017')::TDateTime , inDateEnd := ('31.07.2017')::TDateTime , inisDay := 'False' ::Boolean, inValue1 := 100 ::TFloat, inValue2 := 200 ::TFloat, inValue3 := 300::TFloat , inValue4 := 400::TFloat , inValue5 := 500 ::TFloat, inValue6 := 1000 ::TFloat,  inSession := '3'::TVarChar);
-- FETCH ALL "<unnamed portal 7>";----

select * from gpReport_Movement_CheckMiddle('5120968' , 0 , ('01.06.2021')::TDateTime , ('30.06.2021')::TDateTime , 'False' , 50 , 100 , 200 , 300 , 500 , 1000 , 5 ,  '3');