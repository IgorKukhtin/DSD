-- Function: gpGetBalanceParam()

DROP FUNCTION IF EXISTS gpGetBalanceParam (TBlob ,TVarChar);

CREATE OR REPLACE FUNCTION gpGetBalanceParam(
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

  vbData TVarChar;
  vbKey   TVarChar;
  vbValue TVarChar;
  vbCode  TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());
     vbUserId := lpGetUserBySession(inSession);

     vbIndex := 1;
     WHILE split_part(inData, ';', vbIndex) <> '' LOOP

         EXECUTE 'SELECT '||chr(39)||split_part(inData, ';', vbIndex)||chr(39) INTO vbData;
         IF vbData <> '' THEN
            EXECUTE 'SELECT '||chr(39)||split_part(vbData, '=', 1)||chr(39) INTO vbKey;
            EXECUTE 'SELECT '||chr(39)||split_part(vbData, '=', 2)||chr(39) INTO vbValue;

            CASE vbKey
                WHEN 'accountgroupname' THEN
                   BEGIN
                      vbCode := split_part(vbValue, ' ', 1);
                      SELECT Id, ValueData INTO vbAccountGroupId, vbAccountGroupName
                        FROM Object
                       WHERE DescId = zc_Object_AccountGroup() AND ObjectCode = zfConvert_StringToNumber (vbCode);
                   END;
                WHEN 'accountdirectionname' THEN
                   BEGIN
                      vbCode := split_part(vbValue, ' ', 1);
                      SELECT Id, ValueData INTO vbAccountDirectionId, vbAccountDirectionName
                        FROM Object
                       WHERE DescId = zc_Object_AccountDirection() AND ObjectCode = zfConvert_StringToNumber (vbCode);
                   END;
                WHEN 'accountname' THEN
                   BEGIN
                      vbCode := split_part(vbValue, ' ', 1);
                      SELECT Id, ValueData INTO vbAccountId, vbAccountName
                        FROM Object
                       WHERE DescId = zc_Object_Account() AND ObjectCode = zfConvert_StringToNumber (vbCode);
                   END;
                WHEN 'businessname' THEN
                   BEGIN
                      SELECT Id, ValueData INTO vbBusinessId, vbBusinessName
                        FROM Object
                       WHERE DescId = zc_Object_Business() AND ValueData = vbValue;
                   END;
                WHEN 'infomoneyname' THEN
                   BEGIN
                      SELECT Id, ValueData INTO vbInfoMoneyId, vbInfoMoneyName
                        FROM Object
                       WHERE DescId = zc_Object_InfoMoney() AND ValueData = vbValue;
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
     , 0 AS ProfitLossGroupId
     , '' :: TVarChar AS ProfitLossGroupName 
     , 0 AS ProfitLossDirectionId 
     , '' :: TVarChar AS ProfitLossDirectionName 
     , 0 AS ProfitLossId 
     , '' :: TVarChar AS ProfitLossName 
     , 0 AS BranchId 
     , '' :: TVarChar AS BranchName
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.14                         *
*/

-- тест
-- SELECT * FROM gpGetBalanceParam (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inBranchId:= null,inSession:= '2');

