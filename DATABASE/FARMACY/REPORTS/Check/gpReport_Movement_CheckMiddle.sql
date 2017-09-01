-- Function:  gpReport_Movement_CheckMiddle()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (TVarChar, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_CheckMiddle (TVarChar, Integer, TDateTime, TDateTime, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);


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
   
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    vbDateStart:= DATE_TRUNC('month', inDateStart) -  Interval '5 MONTH';
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
        , tmpCheck AS (SELECT MovementLinkObject_Unit.ObjectId AS UnitId
                         , Movement_Check.Id
                         , CASE WHEN inisDay = True THEN DATE_TRUNC('day', Movement_Check.OperDate) ELSE NULL END              ::TDateTime  AS OperDate
                         , SUM (COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0))                                            AS SummChangePercent_SP
                         , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummSale_1303
                         , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END)                  AS Count_1303
                    FROM Movement AS Movement_Check
                         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         INNER JOIN _tmpUnit_List ON (_tmpUnit_List.UnitId = MovementLinkObject_Unit.ObjectId OR COALESCE(inUnitId,'0') = '0')
                         -- если пользователь выбрал подразделения другой торг.сети
                         -- или inUnitId=0,
                         -- делаем доп.ограничение подразделениями текущей торг.сети
                         INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                         -- 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                      ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                     AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                    -- AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()

                         -- ИТОГО сумма скидки
                         LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                     ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

                    WHERE Movement_Check.DescId = zc_Movement_Check()
                      AND DATE_TRUNC('day', Movement_Check.OperDate) BETWEEN inDateStart AND inDateEnd
                      AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                    GROUP BY Movement_Check.Id
                           , MovementLinkObject_Unit.ObjectId
                           , CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Check.OperDate) ELSE NULL END
                   )

        , tmpMI AS (SELECT Movement_Check.UnitId
                         , Movement_Check.OperDate
                         , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0))   AS SummaSale
                         , SUM (COALESCE (Movement_Check.SummChangePercent_SP, 0))                                             AS SummChangePercent_SP
                         , SUM (COALESCE (Movement_Check.SummSale_1303, 0))                                                    AS SummSale_1303
                         , SUM (COALESCE (Movement_Check.Count_1303, 0))                                                       AS Count_1303
                    FROM tmpCheck AS Movement_Check
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
                         AND 1=0
                    GROUP BY Movement_Check.UnitId
                           , Movement_Check.OperDate
                           , Movement_Check.Id
                    HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                   )
                   
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate      AS OperDate
                                , Movement_Sale.UnitId        AS UnitId
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                                , SUM (Movement_Sale.Count_1303)  AS Count_1303
                           FROM (SELECT CASE WHEN inisDAy = True THEN DATE_TRUNC('day', Movement_Sale.OperDate) ELSE NULL END ::TDateTime  AS OperDate
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
                                      
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                             ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                                   
                                      LEFT JOIN MovementString AS MovementString_InvNumberSP
                                             ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                            AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
        
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                             ON MovementLinkObject_MedicSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                                      
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                             ON MovementLinkObject_MemberSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                                      
                                      LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                           ON MovementDate_OperDateSP.MovementId = Movement_Sale.Id
                                          AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
        
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                             ON MovementLinkObject_GroupMemberSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()

                                 WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                   AND Movement_Sale.OperDate >= inDateStart AND Movement_Sale.OperDate < inDateEnd + INTERVAL '1 DAY'
                                   AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                                         COALESCE (MovementLinkObject_GroupMemberSP.ObjectId ,0) <> 0 OR
                                         COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                                         COALESCE (MovementLinkObject_MedicSP.ObjectId,0) <> 0 OR
                                         COALESCE (MovementLinkObject_MemberSP.ObjectId,0) <> 0
                                       )
                                   AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                 ) AS Movement_Sale
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
                       
        , tmpPeriod AS (SELECT tmpMI.Unitid
                             , COUNT(*)  AS AmountPeriod    -- колво документов за весь период
                             , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                        FROM  tmpMI
                        GROUP BY tmpMI.Unitid
                        )
                          
        , tmpData AS (SELECT tmpMI.Unitid
                           , tmpMI.OperDate

                           , SUM (1 ) AS Amount
                           , SUM (tmpMI.SummaSale) AS SummaSale
                           
                           , SUM (tmpMI.SummChangePercent_SP) AS SummSale_SP
                           , SUM (tmpMI.SummSale_1303)        AS SummSale_1303
                           , SUM (tmpMI.Count_1303)           AS Count_1303
                           
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

                        FROM (SELECT tmpMI.Unitid
                                   , tmpMI.OperDate
                                   , tmpMI.SummChangePercent_SP
                                   , tmpMI.SummaSale
                                   , COALESCE (tmpMI.SummSale_1303, 0) + COALESCE (tmpSale_1303.SummSale_1303, 0)  AS SummSale_1303
                                   , COALESCE (tmpMI.Count_1303, 0) + COALESCE (tmpSale_1303.Count_1303, 0)        AS Count_1303
                              FROM tmpMI
                                   LEFT JOIN tmpSale_1303 ON tmpSale_1303.Unitid   = tmpMI.Unitid
                                                         AND tmpSale_1303.OperDate = tmpMI.OperDate
                              ) AS tmpMI
                        GROUP BY tmpMI.Unitid
                               , tmpMI.OperDate     
                       )
        -- определяем лучшую и худшую аптеки по ср.чеку
        , tmpBestBad AS (SELECT tmp.*
                         FROM (SELECT tmp.*
                                    , Row_Number() OVER (ORDER BY SummaMiddleAll Asc)  AS Ord_Bad
                                    , Row_Number() OVER (ORDER BY SummaMiddleAll DESC) AS Ord_Best
                               FROM (SELECT tmpData.OperDate             
                                          , tmpData.UnitId
                                          , CASE WHEN (tmpData.Amount + COALESCE (tmpData.Count_1303, 0)) <> 0 
                                                 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) / (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))
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
            
            , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
            , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
            , tmpData.Count_1303            :: TFloat AS Count_1303
            
            , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  :: TFloat AS SummaSaleWithSP
            , CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddleWithSP
            , (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))                                                                      :: TFloat AS AmountWith_1303 
            , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0))                            :: TFloat AS SummaSaleAll
            , CASE WHEN (tmpData.Amount + COALESCE (tmpData.Count_1303, 0)) <> 0 
                   THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) / (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))
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
             
             LEFT JOIN tmpBestBad ON tmpBestBad.UnitId   = tmpData.UnitId

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
        , tmpCheck AS (SELECT Movement_Check.Id
                            , DATE_TRUNC('Month', Movement_Check.OperDate)                                                                  AS OperDate
                            , SUM (COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0))                                            AS SummChangePercent_SP
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE 0 END) AS SummSale_1303
                            , SUM (CASE WHEN MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303() THEN 1 ELSE 0 END)                  AS Count_1303
                       FROM Movement AS Movement_Check
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                            INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                            -- 
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                                         ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                                       -- AND MovementLinkObject_SPKind.ObjectId = zc_Enum_SPKind_1303()
                            -- ИТОГО сумма скидки
                            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                        ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                       AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()
   
                       WHERE Movement_Check.DescId = zc_Movement_Check()
                         AND Movement_Check.OperDate >= vbDateStart AND Movement_Check.OperDate < vbDateEnd
                         AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                       GROUP BY Movement_Check.Id
                              , DATE_TRUNC('Month', Movement_Check.OperDate) 
                      )

        , tmpMI AS (SELECT Movement_Check.OperDate
                         , SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount) * COALESCE (MIFloat_Price.ValueData, 0))   AS SummaSale
                         , SUM (COALESCE (Movement_Check.SummChangePercent_SP, 0))                                             AS SummChangePercent_SP
                         , SUM (COALESCE (Movement_Check.SummSale_1303, 0))                                                    AS SummSale_1303
                         , SUM (COALESCE (Movement_Check.Count_1303, 0))                                                       AS Count_1303
                         
                    FROM tmpCheck AS Movement_Check
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
                         AND 1=0
                    GROUP BY Movement_Check.OperDate
                           , Movement_Check.Id
                    HAVING SUM (COALESCE (-1 * MIContainer.Amount, MI_Check.Amount)) <> 0
                   )
                   
        -- выбираем продажи по товарам соц.проекта 1303
        , tmpSale_1303 AS (SELECT Movement_Sale.OperDate      AS OperDate
                                , SUM (COALESCE (-1 * MIContainer.Amount, MI_Sale.Amount) * COALESCE (MIFloat_PriceSale.ValueData, 0)) AS SummSale_1303
                                , SUM (Movement_Sale.Count_1303)  AS Count_1303
                           FROM (SELECT DATE_TRUNC('Month', Movement_Sale.OperDate)  AS OperDate
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
                                      
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                             ON MovementLinkObject_PartnerMedical.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                                                                   
                                      LEFT JOIN MovementString AS MovementString_InvNumberSP
                                             ON MovementString_InvNumberSP.MovementId = Movement_Sale.Id
                                            AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
        
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_MedicSP
                                             ON MovementLinkObject_MedicSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_MedicSP.DescId = zc_MovementLinkObject_MedicSP()
                                      
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                             ON MovementLinkObject_MemberSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
                                      
                                      LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                           ON MovementDate_OperDateSP.MovementId = Movement_Sale.Id
                                          AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()
        
                                      LEFT JOIN MovementLinkObject AS MovementLinkObject_GroupMemberSP
                                             ON MovementLinkObject_GroupMemberSP.MovementId = Movement_Sale.Id
                                            AND MovementLinkObject_GroupMemberSP.DescId = zc_MovementLinkObject_GroupMemberSP()

                                 WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                   AND Movement_Sale.OperDate >= vbDateStart AND Movement_Sale.OperDate < vbDateEnd
                                   AND ( COALESCE (MovementLinkObject_PartnerMedical.ObjectId,0) <> 0 OR
                                         COALESCE (MovementLinkObject_GroupMemberSP.ObjectId ,0) <> 0 OR
                                         COALESCE (MovementString_InvNumberSP.ValueData,'') <> '' OR
                                         COALESCE (MovementLinkObject_MedicSP.ObjectId,0) <> 0 OR
                                         COALESCE (MovementLinkObject_MemberSP.ObjectId,0) <> 0
                                       )
                                   AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                 ) AS Movement_Sale
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
                                                                and 1=0
                           GROUP BY Movement_Sale.OperDate
                           ) 
                       
          , tmpPeriod AS (SELECT tmpMI.OperDate
                               , COUNT(*)  AS AmountPeriod    -- колво документов за весь период
                               , SUM (tmpMI.SummaSale)  AS SummaSalePeriod-- сумма чеков за весь период
                          FROM  tmpMI
                          GROUP BY tmpMI.OperDate
                          )
                          
       , tmpData   AS  ( SELECT tmpMI.OperDate

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
                                 FROM tmpMI
                                      LEFT JOIN tmpSale_1303 ON tmpSale_1303.OperDate = tmpMI.OperDate
                                 ) AS tmpMI
                           GROUP BY tmpMI.OperDate     
                          )

        -- результат      
        SELECT tmpData.OperDate  ::TDateTime
             
             , tmpData.Amount               :: TFloat AS Amount
             , tmpPeriod.AmountPeriod       :: TFloat AS AmountPeriod
             
             , tmpData.SummaSale            :: TFloat AS SummaSale
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddle
 
             , tmpPeriod.SummaSalePeriod    :: TFloat AS SummaSalePeriod
             , CASE WHEN tmpPeriod.AmountPeriod <> 0 THEN tmpPeriod.SummaSalePeriod / tmpPeriod.AmountPeriod ELSE 0 END   :: TFloat AS SummaMiddlePeriod
 
             , tmpData.SummSale_SP           :: TFloat AS SummSale_SP
             , tmpData.SummSale_1303         :: TFloat AS SummSale_1303
             , tmpData.Count_1303            :: TFloat AS Count_1303
             
             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0))                                                                  :: TFloat AS SummaSaleWithSP
             , CASE WHEN tmpData.Amount <> 0 THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0)) / tmpData.Amount ELSE 0 END   :: TFloat AS SummaMiddleWithSP
             , (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))                                                                      :: TFloat AS AmountWith_1303 
             , (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0))                            :: TFloat AS SummaSaleAll
             , CASE WHEN (tmpData.Amount + COALESCE (tmpData.Count_1303, 0)) <> 0 
                    THEN (tmpData.SummaSale + COALESCE (tmpData.SummSale_SP, 0) + COALESCE (tmpData.SummSale_1303, 0)) / (tmpData.Amount + COALESCE (tmpData.Count_1303, 0))
                    ELSE 0 
               END       :: TFloat   AS SummaMiddleAll
          
        FROM tmpData
             LEFT JOIN tmpPeriod On tmpPeriod.OperDate = tmpData.OperDate 
        ORDER BY 1 ;
    RETURN NEXT Cursor2;
             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 01.09.17         *
 25.04.17         * 
 21.04.16         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_CheckMiddle(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateEnd := ('29.02.2016')::TDateTime , inSession := '3');
--select * from gpReport_Movement_CheckMiddle(inUnitId := '183294,375626,389328' , inDateStart := ('01.01.2016')::TDateTime , inDateFinal := ('27.01.2016')::TDateTime , inisDay := 'False' , inValue1 := 100 , inValue2 := 200 , inValue3 := 300 , inValue4 := 400 , inValue5 := 500 , inValue6 := 1000 ,  inSession := '3');