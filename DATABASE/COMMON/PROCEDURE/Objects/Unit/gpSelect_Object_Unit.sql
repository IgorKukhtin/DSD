-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
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
               AccountGroupCode Integer, AccountGroupName TVarChar,
               AccountDirectionCode Integer, AccountDirectionName TVarChar,
               ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar,
               ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               RouteId Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingName TVarChar,
               AreaId Integer, AreaName TVarChar,
               PersonalSheetWorkTimeId Integer, PersonalSheetWorkTimeName TVarChar,
               PartnerCode Integer, PartnerName TVarChar,
               UnitCode_HistoryCost Integer, UnitName_HistoryCost TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               isLeaf Boolean, isPartionDate Boolean, isPartionGoodsKind boolean,
               isErased Boolean,
               Address TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
   -- DECLARE vbAccessKeyAll Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- ������������ - ����� �� ���������� ������ ���� ����������
   -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- ������������ ������� �������
   IF vbUserId <> 9457 -- ���������� �.�.
      AND vbUserId <> 447966 -- ������������ �.�.
   THEN
       vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   END IF;
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;


   -- ���������
   RETURN QUERY 
     WITH Object_AccountDirection AS (SELECT * FROM Object_AccountDirection_View)
       SELECT 
             Object_Unit_View.Id     
           , Object_Unit_View.Code   
           , Object_Unit_View.Name
         
           , COALESCE (Object_Unit_View.ParentId, 0) AS ParentId
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

           , View_AccountDirection.AccountGroupCode
           , View_AccountDirection.AccountGroupName
           , View_AccountDirection.AccountDirectionCode
           , View_AccountDirection.AccountDirectionName
         
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupName
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionName

           , Object_Route.Id                AS RouteId
           , Object_Route.ValueData         AS RouteName

           , Object_RouteSorting.Id         AS RouteSortingId
           , Object_RouteSorting.ValueData  AS RouteSortingName

           , Object_Area.Id                 AS AreaId
           , Object_Area.ValueData          AS AreaName

           , Object_PersonalSheetWorkTime.Id            AS PersonalSheetWorkTimeId
           , Object_PersonalSheetWorkTime.ValueData     AS PersonalSheetWorkTimeName
         
           , Object_Partner.ObjectCode             AS PartnerCode
           , Object_Partner.ValueData              AS PartnerName

           , Object_Unit_HistoryCost.ObjectCode    AS UnitCode_HistoryCost
           , Object_Unit_HistoryCost.ValueData     AS UnitName_HistoryCost

           , Object_SheetWorkTime.Id               AS SheetWorkTimeId 
           , Object_SheetWorkTime.ValueData        AS SheetWorkTimeName

           , Object_Unit_View.isLeaf
           , ObjectBoolean_PartionDate.ValueData   AS isPartionDate
           , COALESCE (ObjectBoolean_PartionGoodsKind.ValueData, TRUE) :: Boolean AS isPartionGoodsKind

           , Object_Unit_View.isErased

           , ObjectString_Unit_Address.ValueData   AS Address
       FROM Object_Unit_View
            LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = Object_Unit_View.Id
            LEFT JOIN Object_AccountDirection AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = Object_Unit_View.AccountDirectionId

            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Object_Unit_View.Id 
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

            LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                 ON ObjectLink_Unit_HistoryCost.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
            LEFT JOIN Object AS Object_Unit_HistoryCost ON Object_Unit_HistoryCost.Id = ObjectLink_Unit_HistoryCost.ChildObjectId

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalSheetWorkTime
                                 ON ObjectLink_Unit_PersonalSheetWorkTime.ObjectId = Object_Unit_View.Id 
                                AND ObjectLink_Unit_PersonalSheetWorkTime.DescId = zc_ObjectLink_Unit_PersonalSheetWorkTime()
            LEFT JOIN Object AS Object_PersonalSheetWorkTime ON Object_PersonalSheetWorkTime.Id = ObjectLink_Unit_PersonalSheetWorkTime.ChildObjectId
        
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                    ON ObjectBoolean_PartionDate.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind
                                    ON ObjectBoolean_PartionGoodsKind.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionGoodsKind.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Unit
                                 ON ObjectLink_Partner_Unit.ChildObjectId = Object_Unit_View.Id
                                AND ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Unit.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                                 ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
            LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId

       -- WHERE vbAccessKeyAll = TRUE
       WHERE (Object_Unit_View.BranchId = vbObjectId_Constraint
              OR vbIsConstraint = FALSE
              OR Object_Unit_View.Id IN (8459 -- ����� ����������
                                       , 8462 -- ����� ����
                                       , 8461 -- ����� ���������
                                       , 256716 -- ����� �����
                                        )
             )
      UNION ALL
       SELECT 
             Object_Partner.Id     
           , Object_Partner.ObjectCode   
           , Object_Partner.ValueData
         
           , 0 :: Integer AS ParentId
           , '' :: TVarChar AS ParentName 

           , 0 :: Integer AS BusinessId
           , '' :: TVarChar AS BusinessName 
         
           , Object_Branch.Id :: Integer AS BranchId
           , Object_Branch.ValueData :: TVarChar AS BranchName
         
           , 0 :: Integer   AS JuridicalId
           , '' :: TVarChar AS JuridicalName

           , 0 :: Integer   AS ContractId
           , '' :: TVarChar AS InvNumber

           , 0 :: Integer   AS Contract_JuridicalId
           , '' :: TVarChar AS Contract_JuridicalName
         
           , 0 :: Integer   AS Contract_InfomoneyId
           , '' :: TVarChar AS Contract_InfomoneyName

           , 0 :: Integer   AS AccountGroupCode
           , '' :: TVarChar AS AccountGroupName
           , 0 :: Integer   AS AccountDirectionCode
           , '' :: TVarChar AS AccountDirectionName
         
           , 0 :: Integer   AS ProfitLossGroupCode
           , '' :: TVarChar AS ProfitLossGroupName
           , 0 :: Integer   AS ProfitLossDirectionCode
           , '' :: TVarChar AS ProfitLossDirectionName

           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName

           , CAST (0 as Integer)    AS AreaId
           , CAST ('' as TVarChar)  AS AreaName

           , CAST (0 as Integer)    AS PersonalSheetWorkTimeId
           , CAST ('' as TVarChar)  AS PersonalSheetWorkTimeName

           , CAST (0 as Integer)    AS PartnerCode
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS UnitCode_HistoryCost
           , CAST ('' as TVarChar)  AS UnitName_HistoryCost

           , CAST (0 as Integer)    AS SheetWorkTimeId 
           , CAST ('' as TVarChar)  AS SheetWorkTimeName

           , TRUE  AS isLeaf
           , FALSE AS isPartionDate
           , FALSE AS isPartionGoodsKind
           , FALSE AS isErased
           , CAST ('' as TVarChar)  AS Address 
       FROM Object as Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Partner.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
       WHERE Object_Partner.Id IN (298605 -- ������ - "�������� ����� ������������"
                                 , 256624 -- �������� - "����������� �.�. ��� �. ͳ������ ���. ������� 6"
                                  )
      UNION ALL
       SELECT 
             0 :: Integer AS Id
           , 0 :: Integer Code
           , '<�����>' :: TVarChar AS Name
         
           , 0 :: Integer AS ParentId
           , '<�������>' :: TVarChar AS ParentName 

           , 0 :: Integer AS BusinessId
           , '' :: TVarChar AS BusinessName 
         
           , 0 :: Integer AS BranchId
           , '' :: TVarChar AS BranchName
         
           , 0 :: Integer   AS JuridicalId
           , '' :: TVarChar AS JuridicalName

           , 0 :: Integer   AS ContractId
           , '' :: TVarChar AS InvNumber

           , 0 :: Integer   AS Contract_JuridicalId
           , '' :: TVarChar AS Contract_JuridicalName
         
           , 0 :: Integer   AS Contract_InfomoneyId
           , '' :: TVarChar AS Contract_InfomoneyName

           , 0 :: Integer   AS AccountGroupCode
           , '' :: TVarChar AS AccountGroupName
           , 0 :: Integer   AS AccountDirectionCode
           , '' :: TVarChar AS AccountDirectionName
         
           , 0 :: Integer   AS ProfitLossGroupCode
           , '' :: TVarChar AS ProfitLossGroupName
           , 0 :: Integer   AS ProfitLossDirectionCode
           , '' :: TVarChar AS ProfitLossDirectionName

           , CAST (0 as Integer)    AS RouteId
           , CAST ('' as TVarChar)  AS RouteName

           , CAST (0 as Integer)    AS RouteSortingId
           , CAST ('' as TVarChar)  AS RouteSortingName

           , CAST (0 as Integer)    AS AreaId
           , CAST ('' as TVarChar)  AS AreaName

           , CAST (0 as Integer)    AS PersonalSheetWorkTimeId
           , CAST ('' as TVarChar)  AS PersonalSheetWorkTimeName

           , CAST (0 as Integer)    AS PartnerCode
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS UnitCode_HistoryCost
           , CAST ('' as TVarChar)  AS UnitName_HistoryCost

           , CAST (0 as Integer)    AS SheetWorkTimeId 
           , CAST ('' as TVarChar)  AS SheetWorkTimeName

           , TRUE  AS isLeaf
           , FALSE AS isPartionDate
           , FALSE AS isPartionGoodsKind
           , FALSE AS isErased
           , CAST ('' as TVarChar)  AS Address 
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.03.17         * add isPartionGoodsKind
 16.11.16         * SheetWorkTime
 26.07.16         * Address
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.12.13                                        * ParentId
 21.11.13                       * ������� WITH ��-�� ������������ ����������� DISTINCT � GROUP BY � 9.3
 03.11.13                                        * add lfSelect_Object_Unit_byProfitLossDirection and Object_AccountDirection_View
 28.10.13                         * ������� �� View              
 04.07.13          * ���������� ����� �����������              
 03.06.13          
*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit (zfCalc_UserAdmin())
