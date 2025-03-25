-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
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
               CityId Integer, CityName TVarChar, CityName_full TVarChar,
               CityKindId Integer, CityKindName TVarChar,
               RegionId Integer, RegionName TVarChar,
               ProvinceId Integer, ProvinceName TVarChar,
               PersonalHeadId Integer, PersonalHeadName TVarChar,
               FounderId Integer, FounderName TVarChar, 
               DepartmentId Integer, DepartmentName TVarChar,
               Department_twoId Integer, Department_twoName TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               isErased boolean, isLeaf boolean,
               isPartionDate boolean, isPartionGoodsKind boolean,
               isCountCount Boolean,
               isPartionGP Boolean,
               isAvance Boolean,
               Address TVarChar,
               Comment TVarChar,
               GLN TVarChar, KATOTTG TVarChar,
               AddressEDIN TVarChar
) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
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

           , CAST (0 as Integer)    AS CityId
           , CAST ('' as TVarChar)  AS CityName
           , CAST ('' as TVarChar)  AS CityName_full

           , CAST (0 as Integer)    AS CityKindId
           , CAST ('' as TVarChar)  AS CityKindName
           , CAST (0 as Integer)    AS RegionId
           , CAST ('' as TVarChar)  AS RegionName
           , CAST (0 as Integer)    AS ProvinceId
           , CAST ('' as TVarChar)  AS ProvinceName

           , CAST (0 as Integer)    AS PersonalHeadId
           , CAST ('' as TVarChar)  AS PersonalHeadName

           , CAST (0 as Integer)    AS FounderId
           , CAST ('' as TVarChar)  AS FounderName   

           , CAST (0 as Integer)    AS DepartmentId
           , CAST ('' as TVarChar)  AS DepartmentName
           , CAST (0 as Integer)    AS Department_twoId
           , CAST ('' as TVarChar)  AS Department_twoName

           , CAST (0 as Integer)    AS SheetWorkTimeId
           , CAST ('' as TVarChar)  AS SheetWorkTimeName

           , CAST (NULL AS Boolean) AS isErased
           , CAST (NULL AS Boolean) AS isLeaf
           , CAST (FALSE AS Boolean) AS isPartionDate
           , CAST (FALSE AS Boolean) AS isPartionGoodsKind
           , CAST (FALSE AS Boolean) AS isCountCount
           , CAST (FALSE AS Boolean) AS isPartionGP
           , CAST (FALSE AS Boolean) AS isAvance
           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS Comment
           , CAST ('' as TVarChar)  AS GLN
           , CAST ('' as TVarChar)  AS KATOTTG
           , CAST ('' as TVarChar)  AS AddressEDIN
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

           , Object_Route.Id                AS RouteId
           , Object_Route.ValueData         AS RouteName

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ValueData  AS RouteSortingName

           , Object_Area.Id                 AS AreaId
           , Object_Area.ValueData          AS AreaName

           , Object_City.Id                 AS CityId
           , Object_City.ValueData          AS CityName
           , ( CASE WHEN COALESCE (Object_Region.ValueData,'')   <> '' THEN COALESCE (Object_Region.ValueData,'') ||' обл., ' ELSE ''  END
              ||CASE WHEN COALESCE (Object_Province.ValueData,'') <> '' THEN COALESCE (Object_Province.ValueData,'') ||' район, ' ELSE ''  END
              ||CASE WHEN COALESCE (Object_CityKind.ValueData,'') <> '' THEN COALESCE (Object_CityKind.ValueData,'') ||' ' ELSE ''  END
              ||COALESCE (Object_City.ValueData,'')
             ) ::TVarChar AS CityName_full

           , Object_CityKind.Id             AS CityKindId
           , Object_CityKind.ValueData      AS CityKindName
           , Object_Region.Id               AS RegionId
           , Object_Region.ValueData        AS RegionName
           , Object_Province.Id             AS ProvinceId
           , Object_Province.ValueData      AS ProvinceName

           , Object_PersonalHead.Id         AS PersonalHeadId
           , Object_PersonalHead.ValueData  AS PersonalHeadName

           , Object_Founder.Id              AS FounderId
           , Object_Founder.ValueData       AS FounderName

           , Object_Department.Id           AS DepartmentId
           , Object_Department.ValueData    AS DepartmentName
           , Object_Department_two.Id          AS Department_twoId
           , Object_Department_two.ValueData   AS Department_twoName

           , Object_SheetWorkTime.Id        AS SheetWorkTimeId
           , Object_SheetWorkTime.ValueData AS SheetWorkTimeName

           , Object_Unit_View.isErased
           , Object_Unit_View.isLeaf

           , ObjectBoolean_PartionDate.ValueData      AS isPartionDate
           , COALESCE (ObjectBoolean_PartionGoodsKind.ValueData, FALSE) :: Boolean AS isPartionGoodsKind
           , COALESCE (ObjectBoolean_CountCount.ValueData, FALSE)       :: Boolean AS isCountCount
           , COALESCE (ObjectBoolean_PartionGP.ValueData, FALSE)        :: Boolean AS isPartionGP
           , COALESCE (ObjectBoolean_Avance.ValueData, FALSE)           :: Boolean AS isAvance
           , ObjectString_Unit_Address.ValueData      AS Address
           , ObjectString_Unit_Comment.ValueData      AS Comment
           , ObjectString_Unit_GLN.ValueData         :: TVarChar AS GLN
           , ObjectString_Unit_KATOTTG.ValueData     :: TVarChar AS KATOTTG
           , ObjectString_Unit_AddressEDIN.ValueData :: TVarChar AS AddressEDIN
       FROM Object_Unit_View
            LEFT JOIN Object_AccountDirection_View AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = Object_Unit_View.AccountDirectionId

            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Object_Unit_View.Id
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

            LEFT JOIN ObjectString AS ObjectString_Unit_Comment
                                   ON ObjectString_Unit_Comment.ObjectId = Object_Unit_View.Id
                                  AND ObjectString_Unit_Comment.DescId = zc_ObjectString_Unit_Comment()

            LEFT JOIN ObjectString AS ObjectString_Unit_GLN
                                   ON ObjectString_Unit_GLN.ObjectId = Object_Unit_View.Id
                                  AND ObjectString_Unit_GLN.DescId = zc_ObjectString_Unit_GLN()
            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG
                                   ON ObjectString_Unit_KATOTTG.ObjectId = Object_Unit_View.Id
                                  AND ObjectString_Unit_KATOTTG.DescId = zc_ObjectString_Unit_KATOTTG()
            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN
                                   ON ObjectString_Unit_AddressEDIN.ObjectId = Object_Unit_View.Id
                                  AND ObjectString_Unit_AddressEDIN.DescId = zc_ObjectString_Unit_AddressEDIN()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_ProfitLossDirection -- "Аналитика ОПиУ - направление" установлена !!!только!!! у следующего после самого верхнего уровня
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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_City
                                 ON ObjectLink_Unit_City.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_City.DescId = zc_ObjectLink_Unit_City()
            LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Unit_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_City_CityKind
                                 ON ObjectLink_City_CityKind.ObjectId = Object_City.Id
                                AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
            LEFT JOIN Object AS Object_CityKind ON Object_CityKind.Id = ObjectLink_City_CityKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_City_Region
                                 ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
            LEFT JOIN Object AS Object_Region ON Object_Region.Id = ObjectLink_City_Region.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_City_Province
                                 ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
            LEFT JOIN Object AS Object_Province ON Object_Province.Id = ObjectLink_City_Province.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalHead
                                 ON ObjectLink_Unit_PersonalHead.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_PersonalHead.DescId   = zc_ObjectLink_Unit_PersonalHead()
            LEFT JOIN Object AS Object_PersonalHead ON Object_PersonalHead.Id = ObjectLink_Unit_PersonalHead.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                    ON ObjectBoolean_PartionDate.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind
                                    ON ObjectBoolean_PartionGoodsKind.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionGoodsKind.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CountCount
                                    ON ObjectBoolean_CountCount.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_CountCount.DescId = zc_ObjectBoolean_Unit_CountCount()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGP
                                    ON ObjectBoolean_PartionGP.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionGP.DescId = zc_ObjectBoolean_Unit_PartionGP()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Avance
                                    ON ObjectBoolean_Avance.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_Avance.DescId = zc_ObjectBoolean_Unit_Avance()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Founder
                                 ON ObjectLink_Unit_Founder.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Founder.DescId = zc_ObjectLink_Unit_Founder()
            LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = ObjectLink_Unit_Founder.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                 ON ObjectLink_Unit_Department.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
            LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department_two
                                 ON ObjectLink_Unit_Department_two.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
            LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                                 ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
            LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId

      WHERE Object_Unit_View.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.10.24         * Department
 11.07.23         *
 28.06.23         *
 14.03.23         * Avance
 27.07.22         * isCountCount
 15.12.21         * PersonalHead
                    dell PersonalSheetWorkTime
 04.10.21         * Comment
 06.03.17         * add PartionGoodsKind
 16.11.16         * add SheetWorkTime
 26.07.16         *
 24.11.15         * add PersonalSheetWorkTime
 19.07.15         * add Area
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 12.11.13                                        * add Object_AccountDirection_View
 04.07.13          * + If...
 11.06.13                        *

*/

-- тест
-- select * from gpGet_Object_Unit(inId := 8382 ,  inSession := '9457');
