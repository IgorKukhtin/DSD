--  gpReport_Check_JackdawsCheck()

DROP FUNCTION IF EXISTS gpReport_Check_JackdawsCheck (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_JackdawsCheck(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , OperDateDay TDateTime
             , UnitID Integer, UnitCode Integer, UnitName TVarChar
             , JackdawsChecksName TVarChar
             , isRetrievedAccounting Boolean
             , TotalSumm TFloat
             , SummaReceivedFact TFloat
             , CommentChecking TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
   vbUserId:= lpGetUserBySession (inSession);

     -- Результат
   RETURN QUERY
   WITH tmpMovementAll AS (SELECT
                               Movement.Id
                             , Movement.InvNumber
                             , Movement.OperDate                                 AS OperDate
                             , DATE_TRUNC ('DAY', Movement.OperDate)::TDateTime  AS OperDateDay
                             , MovementLinkObject_Unit.ObjectId                  AS UnitId
                        FROM Movement

                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND (inUnitId = 0 OR MovementLinkObject_Unit.ObjectId = inUnitId)

                        WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                          AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_Check())
      , tmpMovement AS (SELECT
                               Movement.*
                             , Object_JackdawsChecks.ValueData             AS JackdawsChecksName
                             , MovementFloat_TotalSumm.ValueData           AS TotalSumm
                             , MovementFloat_SummaReceivedFact.ValueData   AS SummaReceivedFact
                        FROM tmpMovementAll AS Movement

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_JackdawsChecks
                                                          ON MovementLinkObject_JackdawsChecks.MovementId =  Movement.Id
                                                         AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
                             LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId
                                                         
                             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                     ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                             LEFT JOIN MovementFloat AS MovementFloat_SummaReceivedFact
                                                     ON MovementFloat_SummaReceivedFact.MovementId =  Movement.Id
                                                    AND MovementFloat_SummaReceivedFact.DescId = zc_MovementFloat_SummaReceivedFact()

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                          ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
                        WHERE COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 10413041
                          AND COALESCE(Object_JackdawsChecks.ObjectCode, 0) <> 0 
                           OR COALESCE(MovementLinkObject_CashRegister.ObjectId, 0) = 0 
                        )


  SELECT Movement.Id
       , Movement.InvNumber
       , Movement.OperDate
       , Movement.OperDateDay
       , Object_Unit.ID                             AS UnitID
       , Object_Unit.ObjectCode
       , Object_Unit.ValueData

       , Movement.JackdawsChecksName                AS JackdawsChecksName
       , COALESCE(MovementBoolean_RetrievedAccounting.ValueData,FALSE)   AS isRetrievedAccounting
       , Movement.TotalSumm                         AS TotalSumm
       , Movement.SummaReceivedFact                 AS SummaReceivedFact
       , MovementString_CommentChecking.ValueData   AS CommentChecking
  FROM tmpMovement AS Movement 
  
       INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Movement.UnitId
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            AND ObjectLink_Juridical_Retail.ChildObjectId = 4

       LEFT JOIN MovementBoolean AS MovementBoolean_RetrievedAccounting
                                 ON MovementBoolean_RetrievedAccounting.MovementId = Movement.Id
                                AND MovementBoolean_RetrievedAccounting.DescId = zc_MovementBoolean_RetrievedAccounting()
                            
       LEFT JOIN MovementString AS MovementString_CommentChecking
                                ON MovementString_CommentChecking.MovementId = Movement.Id
                               AND MovementString_CommentChecking.DescId = zc_MovementString_CommentChecking()

       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId

  ORDER BY Movement.UnitId
         , Movement.OperDateDay
         , Movement.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 29.07.21                                                                                    *
*/

-- тест
-- 


select * from gpReport_Check_JackdawsCheck(inStartDate := ('08.07.2021')::TDateTime , inEndDate := ('08.07.2021')::TDateTime , inUnitId := 183289 ,  inSession := '3');