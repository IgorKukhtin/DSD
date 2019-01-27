-- Function: gpSelect_Object_GlobalConst_user()

DROP FUNCTION IF EXISTS gpSelect_Object_GlobalConst_user(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GlobalConst_user(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, OperDate TDateTime, ValueText TVarChar, EnumName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       WITH tmpRoleAccessKey_all AS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId AND AccessKeyId IN (zc_Enum_GlobalConst_BankAccountDate(), zc_Enum_GlobalConst_CashDate(), zc_Enum_GlobalConst_IntegerDate(), zc_Enum_GlobalConst_PeriodClosePlan()))
          , tmpUser_Admin AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId LIMIT 1)
       SELECT Object_GlobalConst.Id
            , COALESCE (ActualBankStatement.ValueData, CURRENT_DATE) :: TDateTime AS OperDate
            , Object_GlobalConst.ValueData AS ValueText
            , ObjectString.ValueData AS EnumName
       FROM Object AS Object_GlobalConst
            LEFT JOIN tmpRoleAccessKey_all ON tmpRoleAccessKey_all.AccessKeyId = Object_GlobalConst.Id
            LEFT JOIN tmpUser_Admin ON tmpUser_Admin.Id = 1
            LEFT JOIN ObjectDate AS ActualBankStatement 
                                 ON ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement()
                                AND ActualBankStatement.ObjectId = Object_GlobalConst.Id
            LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_GlobalConst.Id
                                  AND ObjectString.DescId = zc_ObjectString_Enum()
       WHERE Object_GlobalConst.DescId = zc_Object_GlobalConst()
         AND (Object_GlobalConst.ObjectCode < 100 OR tmpUser_Admin.Id = 1)
         AND (tmpRoleAccessKey_all.AccessKeyId > 0 OR tmpUser_Admin.Id = 1)
       ORDER BY 1
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GlobalConst_user(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.15                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_GlobalConst_user (zfCalc_UserAdmin())

