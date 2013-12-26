-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId             Integer,       -- ключ объекта <Договор>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar
             , Comment TVarChar
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             
             , PersonalId Integer, PersonalName TVarChar
             , AreaId Integer, AreaName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindId Integer, ContractStateKindName TVarChar
             
             , isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Contract());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             0 :: Integer    AS Id
           , lfGet_ObjectCode(0, zc_Object_Contract()) AS Code
           , '' :: TVarChar  AS InvNumber
           , '' :: TVarChar  AS InvNumberArchive
           , '' :: TVarChar   AS Comment
           
           , CURRENT_DATE :: TDateTime AS SigningDate
           , CURRENT_DATE :: TDateTime AS StartDate
           , CURRENT_DATE :: TDateTime AS EndDate

           , 0 :: Integer   AS ContractKindId
           , '' :: TVarChar AS ContractKindName
           , 0 :: Integer   AS JuridicalId
           , '' :: TVarChar AS JuridicalName
           , 0 :: Integer   AS PaidKindId
           , '' :: TVarChar AS PaidKindName
           , 0 :: Integer   AS InfoMoneyId
           , '' :: TVarChar AS InfoMoneyName

           , 0 :: Integer   AS PersonalId
           , '' :: TVarChar AS PersonalName
           , 0 :: Integer   AS AreaId
           , '' :: TVarChar AS AreaName
           , 0 :: Integer   AS ContractArticleId
           , '' :: TVarChar AS ContractArticleName
           , 0 :: Integer   AS ContractStateKindId
           , '' :: TVarChar AS ContractStateKindName          
           
           , NULL :: Boolean  AS isErased;
   ELSE
       RETURN QUERY
       SELECT
             Object_Contract_View.ContractId   AS Id
           , Object_Contract_View.ContractCode AS Code
           
           , Object_Contract_View.InvNumber
           
           , ObjectString_InvNumberArchive.ValueData AS InvNumberArchive
           , ObjectString_Comment.ValueData AS Comment
                      
           , ObjectDate_Signing.ValueData AS SigningDate
           , Object_Contract_View.StartDate
           , Object_Contract_View.EndDate

           , Object_ContractKind.Id        AS ContractKindId
           , Object_ContractKind.ValueData AS ContractKindName
           , Object_Juridical.Id           AS JuridicalId
           , Object_Juridical.ValueData    AS JuridicalName
           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName

           , Object_Personal_View.PersonalId    AS PersonalId
           , Object_Personal_View.PersonalName  AS PersonalName
           , Object_Area.Id                     AS AreaId
           , Object_Area.ValueData              AS AreaName
           , Object_ContractArticle.Id          AS ContractArticleId
           , Object_ContractArticle.ValueData   AS ContractArticleName
           , Object_ContractStateKind.Id        AS ContractStateKindId
           , Object_ContractStateKind.ValueData AS ContractStateKindName          

           , Object_Contract_View.isErased

       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
            
            LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                                   ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()
            
            LEFT JOIN ObjectString AS ObjectString_Comment
                                   ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()                                  
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
            
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
      
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractStateKind
                                 ON ObjectLink_Contract_ContractStateKind.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_ContractStateKind.DescId = zc_ObjectLink_Contract_ContractStateKind() 
            LEFT JOIN Object AS Object_ContractStateKind ON Object_ContractStateKind.Id = ObjectLink_Contract_ContractStateKind.ChildObjectId 
                                
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId

       WHERE Object_Contract_View.ContractId = inId;

   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.13         * add from redmaine
 20.10.13                                        * add from redmaine
 22.07.13         * add  SigningDate, StartDate, EndDate 
 11.06.13         *
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract (inId := 2, inSession := zfCalc_UserAdmin())
