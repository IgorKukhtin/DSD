-- Function: gpGet_Object_Unit()

-- DROP FUNCTION gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, 
               ParentId Integer, ParentName TVarChar, 
               BranchId Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               AccountDirectionId Integer, AccountDirectionName TVarChar,
               ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

     RETURN QUERY 
     SELECT 
           Object.Id                  AS Id
         , Object.ObjectCode          AS Code
         , Object.ValueData           AS Name
         , Object.isErased            AS isErased
         , Parent.Id                  AS ParentId
         , Parent.ValueData           AS ParentName 
         , Branch.Id                  AS BranchId
         , Branch.ValueData           AS BranchName
         , Juridical.Id               AS JuridicalId
         , Juridical.ValueData        AS JuridicalName
         , AccountDirection.Id        AS AccountDirectionId
         , AccountDirection.ValueData AS AccountDirectionName
         , ProfitLossDirection.Id     AS ProfitLossDirectionId
         , ProfitLossDirection.ValueData AS ProfitLossDirectionName
     FROM Object
LEFT JOIN ObjectLink AS Unit_Parent
       ON Unit_Parent.ObjectId = Object.Id
      AND Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
LEFT JOIN Object AS Parent
       ON Parent.Id = Unit_Parent.ChildObjectId
LEFT JOIN ObjectLink AS Unit_Branch
       ON Unit_Branch.ObjectId = Object.Id
      AND Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
LEFT JOIN Object AS Branch
       ON Branch.Id = Unit_Branch.ChildObjectId
LEFT JOIN ObjectLink AS Unit_Juridical
       ON Unit_Juridical.ObjectId = Object.Id
      AND Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
LEFT JOIN Object AS Juridical
       ON Juridical.Id = Unit_Juridical.ChildObjectId
LEFT JOIN ObjectLink AS Unit_AccountDirection
       ON Unit_AccountDirection.ObjectId = Object.Id
      AND Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
LEFT JOIN Object AS AccountDirection
       ON AccountDirection.Id = Unit_AccountDirection.ChildObjectId
LEFT JOIN ObjectLink AS Unit_ProfitLossDirection
       ON Unit_ProfitLossDirection.ObjectId = Object.Id
      AND Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()
LEFT JOIN Object AS ProfitLossDirection
       ON ProfitLossDirection.Id = Unit_ProfitLossDirection.ChildObjectId
    WHERE Object.Id = inId;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit(integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')