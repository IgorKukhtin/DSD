-- Function: gpSelect_Object_Unit()

-- DROP FUNCTION gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentCode Integer,ParentName TVarChar,
               BusinessId Integer, BusinessCode Integer, BusinessName TVarChar, 
               BranchId Integer, BranchCode Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar,
               AccountDirectionId Integer, AccountDirectionCode Integer, AccountDirectionName TVarChar,
               ProfitLossDirectionId Integer, ProfitLossDirectionICode Integer, ProfitLossDirectionName TVarChar,
               isErased boolean, isLeaf boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
       SELECT 
             Object_Unit.Id         AS Id
           , Object_Unit.ObjectCode AS Code
           , Object_Unit.ValueData  AS Name
         
           , COALESCE(Object_Parent.Id, 0)  AS ParentId
           , Object_Parent.ObjectCode AS ParentCode
           , Object_Parent.ValueData  AS ParentName 

           , Object_Business.Id         AS BusinessId
           , Object_Business.ObjectCode AS BusinessCode
           , Object_Business.ValueData  AS BusinessName 
 
           , Object_Branch.Id         AS BranchId
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData  AS BranchName
         
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
         
           , Object_AccountDirection.Id         AS AccountDirectionId
           , Object_AccountDirection.ObjectCode AS AccountDirectionCode
           , Object_AccountDirection.ValueData  AS AccountDirectionName
         
           , Object_ProfitLossDirection.Id         AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ObjectCode AS ProfitLossDirectionCode
           , Object_ProfitLossDirection.ValueData  AS ProfitLossDirectionName
         
           , Object_Unit.isErased AS isErased
           , ObjectBoolean_isLeaf.ValueData AS isLeaf
       FROM Object AS Object_Unit
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                ON ObjectLink_Unit_Business.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Unit_Business.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
           LEFT JOIN Object AS Object_AccountDirection ON Object_AccountDirection.Id = ObjectLink_Unit_AccountDirection.ChildObjectId
         
           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection
                                ON ObjectLink_Unit_ProfitLossDirection.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()
           LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_Unit_ProfitLossDirection.ChildObjectId
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
       WHERE Object_Unit.DescId = zc_Object_Unit();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.07.13          * дополнение всеми реквизитами              
 03.06.13          

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit ('2')