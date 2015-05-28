-- Function: gpSelect_Movement_TaxAll()

DROP FUNCTION IF EXISTS gpSelect_Movement_Medoc (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Medoc(
    IN inStartDate      TDateTime , --
    IN inEndDate        TDateTime , --
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar 
           , OperDate TDateTime
           , InvNumberPartner TVarChar
           , InvNumberBranch TVarChar
           , InvNumberRegistered TVarChar
           , DateRegistered TDateTime
           , FromINN TVarChar
           , ToINN TVarChar
           , DescName TVarChar
           , TotalSumm TFloat
           , isIncome  Boolean
           , MovementInvNumber TVarChar
           , MovementOperDate TDateTime
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= inSession;

     --
     RETURN QUERY
     SELECT
             Movement_Medoc.InvNumber
           , Movement_Medoc.OperDate
           , Movement_Medoc.InvNumberPartner
           , Movement_Medoc.InvNumberBranch
           , Movement_Medoc.InvNumberRegistered
           , Movement_Medoc.DateRegistered
           , Movement_Medoc.FromINN
           , Movement_Medoc.ToINN
           , Movement_Medoc.Desc
           , Movement_Medoc.TotalSumm
           , Movement_Medoc.isIncome 
           , Movement.InvNumber
           , Movement.OperDate

       FROM  Movement_Medoc_View AS Movement_Medoc

            LEFT JOIN Movement 
                   ON Movement_Medoc.ParentId = Movement.Id AND Movement.StatusId <> zc_Enum_Status_Erased() 

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
                                    
         WHERE Movement_Medoc.OperDate BETWEEN inStartDate AND inEndDate;
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Medoc (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.15                        * 
 18.05.15                        * 
 18.04.15                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TaxAll (inPeriodDate:= ('01.03.2015')::TDateTime, inSession:= zfCalc_UserAdmin())
