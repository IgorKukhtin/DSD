-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_ContractJuridical (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractJuridical(
    IN inJuridicalId    Integer, 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar
             , Comment TVarChar 
             , StartDate TDateTime, EndDate TDateTime
             , ContractTagName TVarChar, ContractKindName TVarChar
             , PaidKindName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , PersonalName TVarChar
             , AreaName TVarChar
             , ContractArticleName TVarChar
             , ContractStateKindCode Integer 
             , isDefault Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean
             , isErased Boolean 
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());

   RETURN QUERY 
   SELECT
         Object_Contract_View.ContractId AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive
       , ObjectString_Comment.ValueData   AS Comment 

       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       
       , Object_Contract_View.ContractTagName
       , Object_ContractKind.ValueData      AS ContractKindName
       , Object_PaidKind.ValueData          AS PaidKindName

       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_Personal_View.PersonalName  AS PersonalName
       , Object_Area.ValueData              AS AreaName
       , Object_ContractArticle.ValueData   AS ContractArticleName

       , Object_Contract_View.ContractStateKindCode

       , COALESCE (ObjectBoolean_Default.ValueData, False)  AS isDefault
       , COALESCE (ObjectBoolean_Standart.ValueData, False) AS isStandart

       , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
       , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique

       , Object_Contract_View.isErased
       
   FROM Object_Contract_View
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()

        LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                               ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()
        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                             ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Area
                             ON ObjectLink_Contract_Area.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Area.DescId = zc_ObjectLink_Contract_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Contract_Area.ChildObjectId                     

        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
      
   WHERE Object_Contract_View.JuridicalId = inJuridicalId
--     AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
     AND Object_Contract_View.isErased = FALSE
  ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractJuridical (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.05.14                                        * add ObjectBoolean...
 20.05.14                                        * !!!ContractKindName - всегда!!!
 25.04.14                                        * add ContractTagName
 13.02.14                                        * del zc_Enum_ContractStateKind_Close, здесь надо показывать все договора :)
 13.02.14                                        * add zc_Enum_ContractStateKind_Close
 12.02.14                         * add KindColor
 05.02.14                                        * add all
 06.01.14                                        * add Object_InfoMoney_View
 26.11.13                         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractJuridical (inJuridicalId:= 1, inSession := zfCalc_UserAdmin())
