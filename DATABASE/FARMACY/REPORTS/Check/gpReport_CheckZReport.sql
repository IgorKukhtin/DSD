-- Function: gpReport_CheckZReport()

DROP FUNCTION IF EXISTS gpReport_CheckZReport(TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckZReport(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , ZReport Integer, FiscalNumber TVarChar
             
             , DateZReport TDateTime
             , OperDate TDateTime

             , SummaCash TFloat
             , SummaCard TFloat
             , SummaTotal TFloat
            
             , SummCashCheck TFloat
             , SummCardCheck TFloat
             , SummaTotalCheck TFloat

             , SummCashDelta TFloat
             , SummCardDelta TFloat
             , SummaTotalDelta TFloat

             , UnitId Integer
             , UnitCode Integer
             , UnitName TVarChar

             , UserId Integer
             , UserCode Integer
             , UserName TVarChar
             
             , ColorRA_calc Integer
             
             , isErased boolean) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ZReportLog());

   RETURN QUERY
    WITH tmpCheck AS (SELECT Object_CashRegister.ValueData                                                       AS CashRegisterName
                           , MovementFloat_ZReport.ValueData                                                     AS ZReport
                           , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                      THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                      ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END)             AS SummCash
                           , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                      THEN 0
                                      ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                           COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END)             AS SummCard
                      FROM Movement

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                     
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                        ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                       AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                           LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
               		                      
                           LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                                    ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                                   AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                                       
                           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                   ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                           LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                                   ON MovementFloat_TotalSummPayAdd.MovementId =  Movement.Id
                                                  AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()

                           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                        ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                       AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()

                           LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                                   ON MovementFloat_ZReport.MovementId =  Movement.Id
                                                  AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                      WHERE Movement.OperDate >= inStartDate - INTERVAL '1 DAY'
                        AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                        AND Movement.StatusId = zc_Enum_Status_Complete()
                        AND Movement.DescId = zc_Movement_Check()
                        AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                      GROUP BY Object_CashRegister.ValueData
                             , MovementFloat_ZReport.ValueData )
       , tmpReturnIn AS (SELECT Object_CashRegister.ValueData                                                       AS CashRegisterName
                              , MovementFloat_ZReport.ValueData                                                     AS ZReport
                              , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                         THEN COALESCE(MovementFloat_TotalSumm.ValueData, 0)
                                         ELSE COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END)             AS SummCash
                              , SUM(CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                         THEN 0
                                         ELSE COALESCE(MovementFloat_TotalSumm.ValueData, 0) - 
                                              COALESCE(MovementFloat_TotalSummPayAdd.ValueData, 0) END)             AS SummCard
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                                         
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                           ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                          AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                              LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
                   		                      
                              LEFT JOIN MovementString AS MovementString_FiscalCheckNumber
                                                       ON MovementString_FiscalCheckNumber.MovementId = Movement.Id
                                                      AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
                                                           
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSummPayAdd
                                                      ON MovementFloat_TotalSummPayAdd.MovementId =  Movement.Id
                                                     AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
   
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                           ON MovementLinkObject_PaidType.MovementId = Movement.Id
                                                          AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()

                              LEFT JOIN MovementFloat AS MovementFloat_ZReport
                                                      ON MovementFloat_ZReport.MovementId =  Movement.Id
                                                     AND MovementFloat_ZReport.DescId = zc_MovementFloat_ZReport()

                         WHERE Movement.OperDate >= inStartDate - INTERVAL '1 DAY'
                           AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                           AND Movement.DescId = zc_Movement_ReturnIn()
                           AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                         GROUP BY Object_CashRegister.ValueData
                                , MovementFloat_ZReport.ValueData)
       
                           
   SELECT
          Object_ZReportLog.Id         AS Id
        , Object_ZReportLog.ObjectCode AS ZReport
        , Object_ZReportLog.ValueData  AS FiscalNumber
        
        , ObjectDate_Date.ValueData    AS DateZReport
        , DATE_TRUNC ('DAY', ObjectDate_Date.ValueData)::TDateTime AS OperDate

        , ObjectFloat_SummaCash.ValueData    AS SummaCash
        , ObjectFloat_SummaCard.ValueData    AS SummaCard
        
        , (COALESCE(ObjectFloat_SummaCash.ValueData, 0) +
          COALESCE(ObjectFloat_SummaCard.ValueData, 0))::TFloat    AS SummaTotal
          
        , (COALESCE(tmpCheck.SummCash, 0) - COALESCE(tmpReturnIn.SummCash, 0))::TFloat   AS SummCashCheck
        , (COALESCE(tmpCheck.SummCard, 0) - COALESCE(tmpReturnIn.SummCard, 0))::TFloat   AS SummCardCheck

        , (COALESCE(tmpCheck.SummCash, 0) - COALESCE(tmpReturnIn.SummCash, 0)  +
          COALESCE(tmpCheck.SummCard, 0) - COALESCE(tmpReturnIn.SummCard, 0))::TFloat    AS SummaTotalCheck

        , (COALESCE (ObjectFloat_SummaCash.ValueData, 0) - COALESCE(tmpCheck.SummCash, 0) + COALESCE(tmpReturnIn.SummCash, 0))::TFloat   AS SummCashDelta
        , (COALESCE (ObjectFloat_SummaCard.ValueData, 0) - COALESCE(tmpCheck.SummCard, 0) + COALESCE(tmpReturnIn.SummCard, 0))::TFloat   AS SummCardDelta

        , (COALESCE(ObjectFloat_SummaCash.ValueData, 0) + COALESCE(ObjectFloat_SummaCard.ValueData, 0) -
          COALESCE(tmpCheck.SummCash, 0) + COALESCE(tmpReturnIn.SummCash, 0)  -
          COALESCE(tmpCheck.SummCard, 0) + COALESCE(tmpReturnIn.SummCard, 0))::TFloat    AS SummaTotalDelta

        , Object_Unit.ID                     AS UnitId
        , Object_Unit.ObjectCode             AS UnitCode
        , Object_Unit.ValueData              AS UnitName

        , Object_User.ID                     AS UserId
        , Object_User.ObjectCode             AS UserCode
        , Object_User.ValueData              AS UserName
        
        , CASE WHEN (COALESCE (ObjectFloat_SummaCash.ValueData, 0) - COALESCE(tmpCheck.SummCash, 0) + COALESCE(tmpReturnIn.SummCash, 0)) <> 0
                 OR (COALESCE (ObjectFloat_SummaCard.ValueData, 0) - COALESCE(tmpCheck.SummCard, 0) + COALESCE(tmpReturnIn.SummCard, 0)) <> 0
               THEN 11394815
               ELSE zc_Color_White()  END  AS ColorRA_calc

        , Object_ZReportLog.isErased   AS isErased
   FROM Object AS Object_ZReportLog
                          
        LEFT JOIN ObjectDate AS ObjectDate_Date
                             ON ObjectDate_Date.ObjectId = Object_ZReportLog.Id
                            AND ObjectDate_Date.DescId = zc_ObjectDate_ZReportLog_Date()

        LEFT JOIN ObjectFloat AS ObjectFloat_SummaCash
                              ON ObjectFloat_SummaCash.ObjectId = Object_ZReportLog.Id
                             AND ObjectFloat_SummaCash.DescId = zc_ObjectFloat_ZReportLog_SummaCash()
        LEFT JOIN ObjectFloat AS ObjectFloat_SummaCard
                              ON ObjectFloat_SummaCard.ObjectId = Object_ZReportLog.Id
                             AND ObjectFloat_SummaCard.DescId = zc_ObjectFloat_ZReportLog_SummaCard()

        LEFT JOIN ObjectLink AS ObjectLink_ZReportLog_Unit
                             ON ObjectLink_ZReportLog_Unit.ObjectId = Object_ZReportLog.Id
                            AND ObjectLink_ZReportLog_Unit.DescId = zc_ObjectLink_ZReportLog_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_ZReportLog_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_ZReportLog_User
                             ON ObjectLink_ZReportLog_User.ObjectId = Object_ZReportLog.Id
                            AND ObjectLink_ZReportLog_User.DescId = zc_ObjectLink_ZReportLog_User()
        LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_ZReportLog_User.ChildObjectId
        
        LEFT JOIN tmpCheck ON tmpCheck.CashRegisterName = Object_ZReportLog.ValueData
                          AND tmpCheck.ZReport = Object_ZReportLog.ObjectCode
        
        LEFT JOIN tmpReturnIn ON tmpReturnIn.CashRegisterName = Object_ZReportLog.ValueData
                             AND tmpReturnIn.ZReport = Object_ZReportLog.ObjectCode

   WHERE Object_ZReportLog.DescId = zc_Object_ZReportLog()
     AND ObjectDate_Date.ValueData >= DATE_TRUNC ('DAY', inStartDate) 
     AND ObjectDate_Date.ValueData < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
     AND (ObjectLink_ZReportLog_Unit.ChildObjectId = inUnitId OR inUnitId = 0);

END;$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.05.18         *
*/

-- тест
-- 

select * from gpReport_CheckZReport(inStartDate := ('06.09.2021')::TDateTime , inEndDate := ('06.09.2021')::TDateTime , inUnitId := 0 ,  inSession := '3');