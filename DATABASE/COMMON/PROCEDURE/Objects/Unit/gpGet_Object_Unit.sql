-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- ������������� 
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, ParentName TVarChar,
               BusinessId Integer, BusinessName TVarChar, 
               BranchId Integer, BranchName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               ContractId Integer, InvNumber TVarChar,
               Contract_JuridicalId Integer, Contract_JuridicalName TVarChar,
               Contract_InfomoneyId Integer, Contract_InfomoneyName TVarChar,
               AccountDirectionId Integer, AccountDirectionName TVarChar,
               ProfitLossDirectionId Integer, ProfitLossDirectionName TVarChar,
               RouteId Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingName TVarChar,
               AreaId Integer, AreaName TVarChar,
               isErased boolean, isLeaf boolean,
               isPartionDate boolean
) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Unit());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Unit()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 

           , CAST (0 as Integer)   AS BusinessId
           , CAST ('' as TVarChar) AS BusinessName 
           
           , CAST (0 as Integer)   AS BranchId
           , CAST ('' as TVarChar) AS BranchName
         
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName

           , CAST (0 as Integer)   AS ContractId
           , CAST ('' as TVarChar) AS InvNumber

           , CAST (0 as Integer)   AS Contract_JuridicalId
           , CAST ('' as TVarChar) AS Contract_JuridicalName
         
           , CAST (0 as Integer)   AS Contract_InfomoneyId
           , CAST ('' as TVarChar) AS Contract_InfomoneyName
         
           , CAST (0 as Integer)   AS AccountDirectionId
           , CAST ('' as TVarChar) AS AccountDirectionName
         
           , CAST (0 as Integer)   AS ProfitLossDirectionId
           , CAST ('' as TVarChar) AS ProfitLossDirectionName
         
           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName

           , CAST (0 as Integer)    AS AreaId
           , CAST ('' as TVarChar)  AS AreaName

           , CAST (NULL AS Boolean) AS isErased
           , CAST (NULL AS Boolean) AS isLeaf
           , CAST (NULL AS Boolean) AS isPartionDate
;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Unit_View.Id     
           , Object_Unit_View.Code   
           , Object_Unit_View.Name
         
           , Object_Unit_View.ParentId 
           , Object_Unit_View.ParentName 

           , Object_Unit_View.BusinessId
           , Object_Unit_View.BusinessName 
         
           , Object_Unit_View.BranchId
           , Object_Unit_View.BranchName
         
           , Object_Unit_View.JuridicalId
           , Object_Unit_View.JuridicalName

           , Object_Contract_View.ContractId
           , Object_Contract_View.InvNumber
           , Object_Contract_View.JuridicalId   AS Contract_JuridicalId
           , Object_Juridical.ValueData         AS Contract_JuridicalName
           , Object_Contract_View.InfomoneyId   AS Contract_InfomoneyId
           , Object_Infomoney.ValueData         AS Contract_InfomoneyName

           , View_AccountDirection.AccountDirectionId
           , View_AccountDirection.AccountDirectionName
         
           , Object_ProfitLossDirection.Id        AS ProfitLossDirectionId
           , Object_ProfitLossDirection.ValueData AS ProfitLossDirectionName

           , Object_Route.Id           AS RouteId
           , Object_Route.ValueData    AS RouteName

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ValueData  AS RouteSortingName
         
           , Object_Area.Id            AS AreaId
           , Object_Area.ValueData     AS AreaName

           , Object_Unit_View.isErased
           , Object_Unit_View.isLeaf

           , ObjectBoolean_PartionDate.ValueData  AS isPartionDate

       FROM Object_Unit_View
            LEFT JOIN Object_AccountDirection_View AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = Object_Unit_View.AccountDirectionId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection -- "��������� ���� - �����������" ����������� !!!������!!! � ���������� ����� ������ �������� ������ 
                                 ON ObjectLink_Unit_ProfitLossDirection.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_ProfitLossDirection.DescId = zc_ObjectLink_Unit_ProfitLossDirection()
            LEFT JOIN Object AS Object_ProfitLossDirection ON Object_ProfitLossDirection.Id = ObjectLink_Unit_ProfitLossDirection.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract
                                 ON ObjectLink_Unit_Contract.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_Unit_Contract.ChildObjectId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_Infomoney ON Object_Infomoney.Id = Object_Contract_View.InfomoneyId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Route
                                 ON ObjectLink_Unit_Route.ObjectId = Object_Unit_View.Id 
                                AND ObjectLink_Unit_Route.DescId = zc_ObjectLink_Unit_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Unit_Route.ChildObjectId
          
            LEFT JOIN ObjectLink AS ObjectLink_Unit_RouteSorting
                                 ON ObjectLink_Unit_RouteSorting.ObjectId = Object_Unit_View.Id 
                                AND ObjectLink_Unit_RouteSorting.DescId = zc_ObjectLink_Unit_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Unit_RouteSorting.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit_View.Id 
                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
        
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                    ON ObjectBoolean_PartionDate.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

      WHERE Object_Unit_View.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit(integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.07.15         * add Area
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 12.11.13                                        * add Object_AccountDirection_View
 04.07.13          * + If...              
 11.06.13                        *

*/

-- ����
-- SELECT * FROM gpGet_Object_Unit (1, '2')