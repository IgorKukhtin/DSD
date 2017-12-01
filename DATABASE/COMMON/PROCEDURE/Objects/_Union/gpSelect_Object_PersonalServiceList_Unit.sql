-- Function: gpSelect_Object_PersonalServiceList_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_PersonalServiceList_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PersonalServiceList_Unit(
    IN inSession           TVarChar     -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ItemName TVarChar, isErased Boolean
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractId Integer, ContractCode Integer, ContractNumber TVarChar, ContractStateKindCode Integer, StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , OKPO TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StoragePlace());
     vbUserId := inSession;

     RETURN QUERY
     SELECT Object_Cash.Id
          , Object_Cash.ObjectCode     
          , Object_Cash.Valuedata AS Name
          , ObjectDesc.ItemName
          , Object_Cash.isErased
          , View_InfoMoney.InfoMoneyId
          , View_InfoMoney.InfoMoneyCode
          , View_InfoMoney.InfoMoneyGroupName
          , View_InfoMoney.InfoMoneyDestinationName
          , View_InfoMoney.InfoMoneyName
          , View_InfoMoney.InfoMoneyName_all
          , NULL::Integer AS PaidKindId
          , ''::TVarChar  AS PaidKindName
          , NULL::Integer AS ContractId
          , NULL::Integer AS ContractCode
          , ''::TVarChar  AS ContractNumber
          , NULL::Integer AS ContractStateKindCode
          , NULL::TDateTime AS StartDate
          , NULL::TDateTime AS EndDate
          , ''::TVarChar AS ContractTagName
          , ''::TVarChar AS ContractKindName
          , ''::TVarChar AS OKPO
     FROM Object AS Object_Cash
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Cash.DescId
          LEFT JOIN View_InfoMoney_40801 AS View_InfoMoney ON 1 = 1
     WHERE Object_Cash.DescId = zc_Object_Cash()
       AND Object_Cash.isErased = FALSE
       
       

        SELECT 
            Object_Unit.Id          AS Id
          , Object_Unit.ObjectCode  AS Code
          , Object_Unit.ValueData   AS Name
          , Object_Unit.DescId      AS DescId
          , ObjectDesc.ItemName     AS DescName
          , Object_Unit.isErased
          , Object_Branch.ValueData AS BranchName
          , NULL::TVarChar          AS PaidKindName
          
          , NULL::TVarChar          AS UnitName
          , NULL::Integer           AS PositionCode
          , NULL::TVarChar          AS PositionName
          , False::Boolean          AS isDateOut

        FROM Object AS Object_Unit
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Unit.DescId
            LEFT OUTER JOIN ObjectLink AS ObjectLink_Unit_Branch
                                       ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                      AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT OUTER JOIN Object AS Object_Branch
                                   ON Object_Branch.id = ObjectLink_Unit_Branch.ChildObjectId
                                  AND Object_Branch.DescId = zc_Object_Branch()
        WHERE Object_Unit.DescId = zc_Object_Unit()
          AND (Object_Unit.isErased = FALSE OR inIsShowDel = TRUE)
    UNION ALL
     SELECT Object_PersonalServiceList.Id       
          , Object_PersonalServiceList.ObjectCode     
          , Object_PersonalServiceList.ValueData
          , ObjectDesc.Id                        AS DescId
          , ObjectDesc.ItemName                  AS DescName
          , Object_PersonalServiceList.isErased  AS isErased
          , Object_Branch.ValueData              AS BranchName
          , Object_PaidKind.ValueData            AS PaidKindName
          
     FROM Object AS Object_PersonalServiceList
          LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_PersonalServiceList.DescId
          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_PaidKind
                               ON ObjectLink_PersonalServiceList_PaidKind.ObjectId = Object_PersonalServiceList.Id 
                              AND ObjectLink_PersonalServiceList_PaidKind.DescId = zc_ObjectLink_PersonalServiceList_PaidKind()
          LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = ObjectLink_PersonalServiceList_PaidKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_PersonalServiceList_Branch
                               ON ObjectLink_PersonalServiceList_Branch.ObjectId = Object_PersonalServiceList.Id 
                              AND ObjectLink_PersonalServiceList_Branch.DescId = zc_ObjectLink_PersonalServiceList_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_PersonalServiceList_Branch.ChildObjectId

    WHERE Object_PersonalServiceList.DescId = zc_Object_PersonalServiceList()
      AND (Object_PersonalServiceList.isErased = FALSE OR inIsShowDel = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 01.12.17         *
*/

-- тест
-- 
