-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_AccountExternal (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_AccountExternal (
    IN inStartDate              TDateTime ,  
    IN inEndDate                TDateTime ,
    IN inAccountId              Integer ,
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS TABLE  (InvNumber Integer, OperDate TDateTime
              , CLIENTCODE Integer, CLIENTINN TVarChar, CLIENTOKPO TVarChar, CLIENTNAME TVarChar
              , SUMA TFloat, PDV TFloat, SUMAPDV TFloat
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Account());
     vbUserId:= lpGetUserBySession (inSession);
  
    RETURN QUERY

    SELECT Report_Account.InvNumber, Report_Account.OperDate  
         , Report_Account.ObjectCode_Direction, ObjectHistory_JuridicalDetails_ViewByDate.INN
         , ObjectHistory_JuridicalDetails_ViewByDate.OKPO, Report_Account.ObjectName_Direction
         , (Report_Account.SummOut/1.2)::TFloat, (Report_Account.SummOut - Report_Account.SummOut/1.2)::TFloat, Report_Account.SummOut

    FROM 
      lpReport_Account(inStartDate := inStartDate, inEndDate := inEndDate
                     , inAccountGroupId := 0, inAccountDirectionId := 0, inInfoMoneyId := 0
                     , inAccountId := 9179, inBusinessId := 0, inProfitLossGroupId := 0, inProfitLossDirectionId := 0
                     , inProfitLossId := 0, inBranchId := 0,  inUserId := vbUserId, inIsMovement := true) AS Report_Account
             JOIN ObjectHistory_JuridicalDetails_ViewByDate ON ObjectHistory_JuridicalDetails_ViewByDate.JuridicalId = Report_Account.ObjectId_Direction
              AND ObjectHistory_JuridicalDetails_ViewByDate.EndDate = zc_DateEnd()

    WHERE COALESCE(Report_Account.SummOut, 0) <> 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_AccountExternal (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 15.09.14                          * 
*/

-- тест
-- SELECT * FROM gpReport_Account (inStartDate:= '01.12.2013', inEndDate:= '31.12.2013', inAccountGroupId:= 0, inAccountDirectionId:= 0, inInfoMoneyId:= 0, inAccountId:= 0, inBusinessId:= 0, inProfitLossGroupId:= 0,  inProfitLossDirectionId:= 0,  inProfitLossId:= 0,  inBranchId:= 0, inSession:= zfCalc_UserAdmin());
