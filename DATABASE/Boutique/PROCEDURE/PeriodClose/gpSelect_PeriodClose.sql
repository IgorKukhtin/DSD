-- Function: gpSelect_PeriodClose (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_PeriodClose (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PeriodClose(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , RoleId Integer, RoleCode Integer, RoleName TVarChar, UserName_list TVarChar
             , UserId_excl Integer, UserCode_excl Integer, UserName_excl TVarChar
             , isUserName TVarChar

             , DescId Integer, DescName TVarChar
             , DescId_excl Integer, DescName_excl TVarChar

             , BranchId   Integer, BranchCode   Integer, BranchName TVarChar
             , PaidKindId Integer, PaidKindCode Integer, PaidKindName TVarChar

             , Period Integer, CloseDate TDateTime, CloseDate_excl TDateTime, CloseDate_store TDateTime
             , UserId Integer, UserName TVarChar, OperDate TDateTime
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.

*/

-- тест
-- SELECT * FROM gpSelect_PeriodClose (inSession:= zfCalc_UserAdmin()); 
