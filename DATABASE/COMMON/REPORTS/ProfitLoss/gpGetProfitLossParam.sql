-- Function: gpReport_JuridicalCollation()

DROP FUNCTION IF EXISTS gpGetProfitLossParam (TBlob ,TVarChar);

CREATE OR REPLACE FUNCTION gpGetProfitLossParam(
    IN inData             TBlob ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (RootType Integer, AccountGroupId Integer, AccountGroupName TVarChar
             , AccountDirectionId Integer, AccountDirectionName TVarChar
             , AccountId Integer, AccountName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ObjectDirectionId Integer, ObjectDestinationId Integer
             , JuridicalBasisId Integer
             , BusinessId Integer, BusinessName TVarChar
             , ProfitLossGroupId Integer, ProfitLossGroupName TVarChar
             , ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar
             , ProfitLossId Integer, ProfitLossName TVarChar
             , BranchId Integer, BranchName TVarChar
              )
AS
$BODY$
DECLARE
  vbUserId Integer;
  vbIndex  Integer;
  vbRootType INTEGER;
  vbAccountGroupId INTEGER;
  vbAccountGroupName TVarChar;
  vbAccountDirectionId INTEGER;
  vbAccountDirectionName TVarChar;
  vbAccountId INTEGER;
  vbAccountName TVarChar;
  vbInfoMoneyId INTEGER;
  vbInfoMoneyName TVarChar;
  vbObjectDirectionId INTEGER;
  vbObjectDestinationId INTEGER;
  vbJuridicalBasisId INTEGER;
  vbBusinessId INTEGER;
  vbBusinessName TVarChar;
  vbProfitLossGroupId Integer;
  vbProfitLossGroupName TVarChar;
  vbProfitLossDirectionId Integer;
  vbProfitLossDirectionName TVarChar;
  vbProfitLossId Integer;
  vbProfitLossName TVarChar;
  vbBranchId Integer;
  vbBranchName TVarChar;

  vbData TVarChar;
  vbKey   TVarChar;
  vbValue TVarChar;
  vbCode  Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId := lpGetUserBySession(inSession);

     SELECT Object_Account_View.AccountGroupId, Object_Account_View.AccountGroupName,
            Object_Account_View.AccountDirectionId, Object_Account_View.AccountDirectionName,
            Object_Account_View.AccountId, Object_Account_View.AccountName
             INTO vbAccountGroupId, vbAccountGroupName, vbAccountDirectionId, vbAccountDirectionName, vbAccountId, vbAccountName
       FROM Object_Account_View
      WHERE Object_Account_View.AccountId = zc_Enum_Account_100301();

     vbIndex := 1;
     WHILE split_part(inData, ';', vbIndex) <> '' LOOP

         EXECUTE 'SELECT '||chr(39)||split_part(inData, ';', vbIndex)||chr(39) INTO vbData;
         IF vbData <> '' THEN
            EXECUTE 'SELECT '||chr(39)||split_part(vbData, '=', 1)||chr(39) INTO vbKey;
            EXECUTE 'SELECT '||chr(39)||split_part(vbData, '=', 2)||chr(39) INTO vbValue;

            CASE vbKey
                WHEN 'profitlossgroupname' THEN
                   BEGIN
                      vbCode := zfConvert_StringToNumber (split_part(vbValue, ' ', 1));
                      SELECT Id, ValueData INTO vbProfitLossGroupId, vbProfitLossGroupName
                        FROM Object
                       WHERE DescId = zc_Object_ProfitLossGroup() AND ObjectCode = vbCode;
                   END;
                WHEN 'profitlossdirectionname' THEN
                   BEGIN
                      vbCode := zfConvert_StringToNumber (split_part(vbValue, ' ', 1));
                      SELECT Id, ValueData INTO vbProfitLossDirectionId, vbProfitLossDirectionName
                        FROM Object
                       WHERE DescId = zc_Object_ProfitLossDirection() AND ObjectCode = vbCode;
                   END;
                WHEN 'profitlossname' THEN
                   BEGIN
                      vbCode := zfConvert_StringToNumber (split_part(vbValue, ' ', 1));
                      SELECT Id, ValueData INTO vbProfitLossId, vbProfitLossName
                        FROM Object
                       WHERE DescId = zc_Object_ProfitLoss() AND ObjectCode = vbCode;
                   END;
                WHEN 'businessname' THEN
                   BEGIN
                      SELECT Id, ValueData INTO vbBusinessId, vbBusinessName
                        FROM Object
                       WHERE DescId = zc_Object_Business() AND ValueData = vbValue;
                   END;
                WHEN 'branchname_profitloss' THEN
                   BEGIN
                      SELECT Id, ValueData INTO vbBranchId, vbBranchName
                        FROM Object
                       WHERE DescId = zc_Object_Branch() AND ValueData = vbValue;
                   END;
               ELSE BEGIN END;
            END CASE;
         END IF;
         vbIndex := vbIndex + 1;

     END LOOP;


     RETURN QUERY
     SELECT
       0 AS RootType
     , vbAccountGroupId AS AccountGroupId
     , vbAccountGroupName AS AccountGroupName
     , vbAccountDirectionId AS AccountDirectionId
     , vbAccountDirectionName AS AccountDirectionName
     , vbAccountId AS AccountId
     , vbAccountName AS AccountName
     , vbInfoMoneyId AS InfoMoneyId
     , vbInfoMoneyName AS InfoMoneyName
     , 0 AS ObjectDirectionId
     , 0 AS ObjectDestinationId
     , 0 AS JuridicalBasisId
     , vbBusinessId AS BusinessId
     , vbBusinessName AS BusinessName
     , vbProfitLossGroupId
     , vbProfitLossGroupName
     , vbProfitLossDirectionId
     , vbProfitLossDirectionName
     , vbProfitLossId
     , vbProfitLossName
     , vbBranchId
     , vbBranchName
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetProfitLossParam (TBlob, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.14                         *
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2');

