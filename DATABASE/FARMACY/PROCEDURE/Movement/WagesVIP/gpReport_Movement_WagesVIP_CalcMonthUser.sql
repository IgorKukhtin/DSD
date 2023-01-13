-- Function: gpReport_Movement_WagesVIP_CalcMonthUser()

DROP FUNCTION IF EXISTS gpReport_Movement_WagesVIP_CalcMonthUser (TDateTime,  TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_WagesVIP_CalcMonthUser(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             , PayrollTypeVIPID Integer
             , PayrollTypeVIPCode Integer
             , PayrollTypeVIPName TVarChar
             , HoursWork TFloat
             
             , HoursWorkDay  TFloat
             
             , AmountAccrued  TFloat
             , ApplicationAward  TFloat
             , TotalAmount  TFloat

             , SummPhone TFloat
             , SummSale TFloat
             , SummNP TFloat

             , TotalSummPhone TFloat
             , TotalSummSale TFloat
             , TotalSummNP TFloat
             )

AS
$BODY$
   DECLARE vbUserId      Integer;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpEmployeeScheduleVIP'))
    THEN
      DROP TABLE tmpEmployeeScheduleVIP;
    END IF;
        
    -- Отработано сотрудниками
    CREATE TEMP TABLE tmpEmployeeScheduleVIP ON COMMIT DROP AS
       (SELECT MovementItem.ObjectId                                                                            AS UserId
             , (DATE_TRUNC ('MONTH', inOperDate) + 
               (((MovementItemChild.Amount - 1)::Integer)::tvarchar||' DAY')::INTERVAL)::TDateTime              AS OperDate
             , MovementItemChild.ObjectId                                                                       AS PayrollTypeVIPID
             , (date_part('HOUR', MIDate_End.ValueData - MIDate_Start.ValueData) +
                   (date_part('MINUTE', MIDate_End.ValueData - MIDate_Start.ValueData)) / 60)::TFloat           AS HoursWork
        FROM Movement

             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                    AND MovementItem.DescId = zc_MI_Master()

             INNER JOIN MovementItem AS MovementItemChild
                                     ON MovementItemChild.MovementId = Movement.Id
                                    AND MovementItemChild.DescId = zc_MI_Child()
                                    AND MovementItemChild.ParentId = MovementItem.ID

             LEFT JOIN MovementItemDate AS MIDate_Start
                                        ON MIDate_Start.MovementItemId = MovementItemChild.Id
                                       AND MIDate_Start.DescId = zc_MIDate_Start()

             LEFT JOIN MovementItemDate AS MIDate_End
                                        ON MIDate_End.MovementItemId = MovementItemChild.Id
                                       AND MIDate_End.DescId = zc_MIDate_End()

        WHERE Movement.ID = (SELECT Movement.ID
                             FROM Movement
                             WHERE Movement.DescId = zc_Movement_EmployeeScheduleVIP()
                               AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate))
          AND MovementItem.IsErased = FALSE);
          
    ANALYSE tmpEmployeeScheduleVIP;

    IF NOT EXISTS(SELECT * FROM tmpEmployeeScheduleVIP)
    THEN
      RAISE EXCEPTION 'Ошибка. Не найден график работы VIP менеджеров.';
    END IF;    

    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpCalcMonthSum'))
    THEN
      DROP TABLE tmpCalcMonthSum;
    END IF;

    -- База за месяц
    CREATE TEMP TABLE tmpCalcMonthSum ON COMMIT DROP AS
    (select * from gpReport_Movement_WagesVIP_CalcMonth(inOperDate := inOperDate,  inSession := inSession));

    ANALYSE tmpCalcMonthSum;
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpUserReferals'))
    THEN
      DROP TABLE tmpUserReferals;
    END IF;

    CREATE TEMP TABLE tmpUserReferals ON COMMIT DROP AS
    (WITH tmpUserReferals AS (SELECT Movement.OperDate
                                    , MLO_UserReferals.ObjectId                           AS UserId
                                    , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                    , MovementFloat_ApplicationAward.ValueData            AS ApplicationAward
                               FROM Movement
                                   
                                    INNER JOIN MovementLinkObject AS MLO_UserReferals
                                                                  ON MLO_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
                                                                 AND MLO_UserReferals.MovementId = Movement.Id
                                                                 AND COALESCE (MLO_UserReferals.ObjectId, 0) > 0

                                    INNER JOIN MovementBoolean AS MovementBoolean_MobileFirstOrder
                                                               ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                                              AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                                              AND MovementBoolean_MobileFirstOrder.ValueData = True

                                    LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                            ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                           AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                    LEFT JOIN MovementFloat AS MovementFloat_ApplicationAward
                                                            ON MovementFloat_ApplicationAward.MovementId =  Movement.Id
                                                           AND MovementFloat_ApplicationAward.DescId = zc_MovementFloat_ApplicationAward()
                                                                                                                                                                 
                                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()  

                               WHERE Movement.DescId = zc_Movement_Check()
                                 AND Movement.OperDate >= DATE_TRUNC ('MONTH', inOperDate)
                                 AND Movement.OperDate < DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH'
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                                 AND COALESCE(MovementFloat_ApplicationAward.ValueData, 0) > 0)
                                   
     SELECT tmpUserReferals.OperDate
          , tmpUserReferals.UserId
          , SUM(tmpUserReferals.ApplicationAward)::TFloat     AS ApplicationAward
     FROM tmpUserReferals
     GROUP BY tmpUserReferals.OperDate
            , tmpUserReferals.UserId);

    ANALYSE tmpUserReferals;   
    

    -- Результат
    RETURN QUERY      
    WITH tmpHoursWorkDay AS (SELECT tmpEmployeeScheduleVIP.OperDate
                                  , SUM(tmpEmployeeScheduleVIP.HoursWork)::TFloat  AS HoursWorkDay
                                  , COUNT(*)                                       AS CountUser  
                             FROM tmpEmployeeScheduleVIP
                             GROUP BY tmpEmployeeScheduleVIP.OperDate)
       , tmpTotalSum AS (SELECT SUM(tmpCalcMonthSum.SummPhone)::TFloat AS TotalSummPhone  
                              , SUM(tmpCalcMonthSum.SummSale)::TFloat  AS TotalSummSale
                              , SUM(tmpCalcMonthSum.SummNP)::TFloat    AS TotalSummNP
                              , SUM(tmpCalcMonthSum.SummTotal)::TFloat AS TotalSummTotal
                              , SUM(tmpCalcMonthSum.SummCalc)::TFloat  AS TotalSummCalc

                         FROM tmpCalcMonthSum
                         WHERE tmpCalcMonthSum.OperDate in (SELECT DISTINCT tmpHoursWorkDay.OperDate FROM tmpHoursWorkDay))
    
    SELECT tmpEmployeeScheduleVIP.OperDate
         , tmpEmployeeScheduleVIP.UserId
         , Object_User.ObjectCode                      AS UserCode
         , Object_User.ValueData                       AS UserName
         , tmpEmployeeScheduleVIP.PayrollTypeVIPID
         , Object_PayrollTypeVIP.ObjectCode            AS PayrollTypeVIPCode
         , Object_PayrollTypeVIP.ValueData             AS PayrollTypeVIPName

         , tmpEmployeeScheduleVIP.HoursWork
         , tmpHoursWorkDay.HoursWorkDay
         
         , ROUND(CASE WHEN COALESCE (ObjectFloat_Rate.ValueData, 0) > 0 AND
                            ROUND(COALESCE(tmpCalcMonthSum.SummPhone * ObjectFloat_PercentOther.ValueData / 100, 0) +
                                  COALESCE(tmpCalcMonthSum.SummSale * ObjectFloat_PercentOther.ValueData / 100, 0) +
                                  COALESCE(tmpCalcMonthSum.SummNP * ObjectFloat_PercentPhone.ValueData / 100, 0), 2) < ObjectFloat_Rate.ValueData 
                      THEN ObjectFloat_Rate.ValueData / tmpHoursWorkDay.CountUser
                      ELSE (COALESCE(tmpCalcMonthSum.SummPhone * ObjectFloat_PercentOther.ValueData / 100, 0) +
                            COALESCE(tmpCalcMonthSum.SummSale * ObjectFloat_PercentOther.ValueData / 100, 0) +
                            COALESCE(tmpCalcMonthSum.SummNP * ObjectFloat_PercentPhone.ValueData / 100, 0)) * 
                            tmpEmployeeScheduleVIP.HoursWork / tmpHoursWorkDay.HoursWorkDay END, 2)::TFloat AS AmountAccrued
         , tmpUserReferals.ApplicationAward
         
         
         , (ROUND(CASE WHEN COALESCE (ObjectFloat_Rate.ValueData, 0) > 0 AND
                            ROUND(COALESCE(tmpCalcMonthSum.SummPhone * ObjectFloat_PercentOther.ValueData / 100, 0) +
                                  COALESCE(tmpCalcMonthSum.SummSale * ObjectFloat_PercentOther.ValueData / 100, 0) +
                                  COALESCE(tmpCalcMonthSum.SummNP * ObjectFloat_PercentPhone.ValueData / 100, 0), 2) < ObjectFloat_Rate.ValueData 
                      THEN ObjectFloat_Rate.ValueData / tmpHoursWorkDay.CountUser
                      ELSE (COALESCE(tmpCalcMonthSum.SummPhone * ObjectFloat_PercentOther.ValueData / 100, 0) +
                            COALESCE(tmpCalcMonthSum.SummSale * ObjectFloat_PercentOther.ValueData / 100, 0) +
                            COALESCE(tmpCalcMonthSum.SummNP * ObjectFloat_PercentPhone.ValueData / 100, 0)) * 
                            tmpEmployeeScheduleVIP.HoursWork / tmpHoursWorkDay.HoursWorkDay END, 2)::TFloat +
           COALESCE(tmpUserReferals.ApplicationAward, 0))::TFloat AS TotalAmount

         , tmpCalcMonthSum.SummPhone
         , tmpCalcMonthSum.SummSale
         , tmpCalcMonthSum.SummNP

         , tmpTotalSum.TotalSummPhone
         , tmpTotalSum.TotalSummSale
         , tmpTotalSum.TotalSummNP

    FROM tmpEmployeeScheduleVIP
    
         LEFT JOIN tmpCalcMonthSum ON tmpCalcMonthSum.OperDate =  tmpEmployeeScheduleVIP.OperDate

         LEFT JOIN tmpHoursWorkDay ON tmpHoursWorkDay.OperDate =  tmpEmployeeScheduleVIP.OperDate
         
         LEFT JOIN tmpUserReferals ON tmpUserReferals.OperDate =  tmpEmployeeScheduleVIP.OperDate
                                  AND tmpUserReferals.UserId =  tmpEmployeeScheduleVIP.UserId

         LEFT JOIN Object AS Object_User ON Object_User.Id =  tmpEmployeeScheduleVIP.UserId

         LEFT JOIN Object AS Object_PayrollTypeVIP ON Object_PayrollTypeVIP.Id =  tmpEmployeeScheduleVIP.PayrollTypeVIPID

         LEFT JOIN ObjectFloat AS ObjectFloat_PercentPhone
                               ON ObjectFloat_PercentPhone.ObjectId = Object_PayrollTypeVIP.Id
                              AND ObjectFloat_PercentPhone.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentPhone()
         LEFT JOIN ObjectFloat AS ObjectFloat_PercentOther
                               ON ObjectFloat_PercentOther.ObjectId = Object_PayrollTypeVIP.Id
                              AND ObjectFloat_PercentOther.DescId = zc_ObjectFloat_PayrollTypeVIP_PercentOther()
         LEFT JOIN ObjectFloat AS ObjectFloat_Rate
                               ON ObjectFloat_Rate.ObjectId = Object_PayrollTypeVIP.Id
                              AND ObjectFloat_Rate.DescId = zc_ObjectFloat_PayrollTypeVIP_Rate()
         
         LEFT JOIN tmpTotalSum ON 1 = 1
                  
         
    ORDER BY tmpEmployeeScheduleVIP.OperDate, tmpEmployeeScheduleVIP.UserId;
    
    
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Movement_WagesVIP_CalcMonthUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.01.22                                                        *
*/

-- тест
-- 

select * from gpReport_Movement_WagesVIP_CalcMonthUser(inOperDate := ('01.01.2023')::TDateTime ,  inSession := '3');