-- Function: gpSelect_Movement_TaxAll()

 DROP FUNCTION IF EXISTS gpSelect_Movement_TaxAll (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TaxAll(
    IN inPeriodDate     TDateTime , --
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, DateRegistered TDateTime, InvNumberRegistered TVarChar, MedocCode Integer)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Tax());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inPeriodDate, inPeriodDate, NULL, NULL, NULL, vbUserId);


     --
     RETURN QUERY
     SELECT
             Movement.Id                                AS Id
           , MovementDate_DateRegistered.ValueData      AS DateRegistered
           , CASE 
           --  WHEN Movement_Medoc.isIncome = TRUE THEN 'income' :: TVarChar
               WHEN Movement_Medoc.isIncome = TRUE THEN (COALESCE (MovementString_InvNumberRegistered.ValueData, '???') || ' - income') :: TVarChar
               ELSE MovementString_InvNumberRegistered.ValueData   
               -- ELSE '' :: TVarChar
             END AS InvNumberRegistered
           , Movement_Medoc.InvNumber::Integer     AS MedocCode

       FROM  Movement_Medoc_View AS Movement_Medoc

            LEFT JOIN Movement 
                   ON Movement_Medoc.ParentId = Movement.Id AND Movement.StatusId <> zc_Enum_Status_Erased() 

            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                   ON MovementDate_DateRegistered.MovementId =  Movement.Id
                                  AND MovementDate_DateRegistered.DescId = zc_MovementDate_DateRegistered()

            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                    AND MovementString_InvNumberRegistered.DescId = zc_MovementString_InvNumberRegistered()
                                    
         WHERE Movement_Medoc.OperDate >=  inPeriodDate AND Movement_Medoc.OperDate < (inPeriodDate + INTERVAL '1 month');
          
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TaxAll (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.05.15                        * 
 18.04.15                        * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TaxAll (inPeriodDate:= '01.07.2024', inSession:= zfCalc_UserAdmin())
