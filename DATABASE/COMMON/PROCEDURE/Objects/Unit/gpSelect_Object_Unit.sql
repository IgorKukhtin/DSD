-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
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
               AccountGroupCode Integer, AccountGroupName TVarChar,
               AccountDirectionCode Integer, AccountDirectionName TVarChar,
               ProfitLossGroupCode Integer, ProfitLossGroupName TVarChar,
               ProfitLossDirectionCode Integer, ProfitLossDirectionName TVarChar,
               RouteId Integer, RouteName TVarChar,
               RouteSortingId Integer, RouteSortingName TVarChar,
               AreaId Integer, AreaName TVarChar,
               CityId Integer, CityName TVarChar,
               CityKindId Integer, CityKindName TVarChar,
               RegionId Integer, RegionName TVarChar,
               ProvinceId Integer, ProvinceName TVarChar,
               PersonalHeadId Integer, PersonalHeadCode Integer, PersonalHeadName TVarChar, UnitName_Head TVarChar, BranchName_Head TVarChar,
               PartnerCode Integer, PartnerName TVarChar,
               UnitId_HistoryCost Integer, UnitCode_HistoryCost Integer, UnitName_HistoryCost TVarChar,
               FounderId Integer, FounderName TVarChar,
               DepartmentId Integer, DepartmentName TVarChar,
               Department_twoId Integer, Department_twoName TVarChar,
               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
               isLeaf Boolean, isPartionDate Boolean, isPartionGoodsKind boolean,
               isCountCount Boolean,
               isPartionGP Boolean,
               isIrna Boolean,
               isAvance Boolean,
               isErased Boolean,
               Address TVarChar,
               Comment TVarChar,
               isPersonalService Boolean, PersonalServiceDate TDateTime,
               GLN TVarChar, KATOTTG TVarChar,
               AddressEDIN TVarChar

) AS
$BODY$
   DECLARE vbUserId Integer;
   -- DECLARE vbAccessKeyAll Boolean;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbIsBranch_Kharkov Boolean;
   DECLARE vbObjectId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется - может ли пользовать видеть весь справочник
   -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

   -- определяется уровень доступа
   IF vbUserId <> 9457 -- Климентьев К.И.
      AND vbUserId <> 447966  -- Черниловский С.Ф.
      AND vbUserId <> 280162  -- Панасенко А.Н.
      AND vbUserId <> 943150  -- Туржанская А.В.
      AND vbUserId <> 7117614 -- Уряшева М.В.
      AND vbUserId <> 14599 -- Коротченко Т.Н.
   THEN
       vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId
                                FROM Object_RoleAccessKeyGuide_View
                                WHERE Object_RoleAccessKeyGuide_View.UserId   = vbUserId
                                  AND Object_RoleAccessKeyGuide_View.BranchId <> 0
                                  AND Object_RoleAccessKeyGuide_View.BranchId <> zc_Branch_Basis()
                                GROUP BY Object_RoleAccessKeyGuide_View.BranchId
                               );
   END IF;
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0;


   -- если Пользователь из филиал Харьков
   vbIsBranch_Kharkov:= EXISTS (SELECT 1
                                FROM Object_RoleAccessKeyGuide_View
                                WHERE Object_RoleAccessKeyGuide_View.BranchId <> 0
                                  -- AND Object_RoleAccessKeyGuide_View.AccessKeyId_guide IN (zc_Enum_Process_AccessKey_GuideKharkov(), zc_Enum_Process_AccessKey_GuideLviv())
                                  AND Object_RoleAccessKeyGuide_View.AccessKeyId_guide IN (zc_Enum_Process_AccessKey_GuideKharkov())
                               )
                    AND vbObjectId_Constraint <> 3080683 -- филиал Львов
                   ;



   -- Результат
   RETURN QUERY
     WITH Object_AccountDirection AS (SELECT * FROM Object_AccountDirection_View)
       ,  tmpPartner_Unit AS (SELECT ObjectLink_Partner_Unit.ChildObjectId AS UnitId
                                   , STRING_AGG (Object_Partner.ValueData, ';') :: TVarChar AS PartnerName
                              FROM ObjectLink AS ObjectLink_Partner_Unit
                                   LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Unit.ObjectId
                              WHERE ObjectLink_Partner_Unit.DescId = zc_ObjectLink_Partner_Unit()
                              GROUP BY ObjectLink_Partner_Unit.ChildObjectId
                             )

       , tmpCity AS (SELECT tmp.*
                     FROM gpSelect_Object_City(inSession) AS tmp
                    )
       --
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

           , Object_City.Id                 AS CityId
           , Object_City.Name               AS CityName

           , Object_City.CityKindId
           , Object_City.CityKindName
           , Object_City.RegionId
           , Object_City.RegionName
           , Object_City.ProvinceId
           , Object_City.ProvinceName

           , Object_PersonalHead.PersonalId    AS PersonalHeadId
           , Object_PersonalHead.PersonalCode  AS PersonalHeadCode
           , Object_PersonalHead.PersonalName  AS PersonalHeadName
           , Object_PersonalHead.UnitName      AS UnitName_Head
           , Object_PersonalHead.BranchName    AS BranchName_Head

           , 0 :: Integer                          AS PartnerCode
           , tmpPartner_Unit.PartnerName           AS PartnerName

           , Object_Unit_HistoryCost.Id            AS UnitId_HistoryCost
           , Object_Unit_HistoryCost.ObjectCode    AS UnitCode_HistoryCost
           , Object_Unit_HistoryCost.ValueData     AS UnitName_HistoryCost

           , Object_Founder.Id                 AS FounderId
           , Object_Founder.ValueData          AS FounderName

           , Object_Department.Id              AS DepartmentId
           , Object_Department.ValueData       AS DepartmentName
           , Object_Department_two.Id          AS Department_twoId
           , Object_Department_two.ValueData   AS Department_twoName

           , Object_SheetWorkTime.Id           AS SheetWorkTimeId
           , Object_SheetWorkTime.ValueData    AS SheetWorkTimeName

           , Object_Unit_View.isLeaf
           , ObjectBoolean_PartionDate.ValueData   AS isPartionDate
           , COALESCE (ObjectBoolean_PartionGoodsKind.ValueData, FALSE) :: Boolean AS isPartionGoodsKind
           , COALESCE (ObjectBoolean_CountCount.ValueData, FALSE)       :: Boolean AS isCountCount
           , COALESCE (ObjectBoolean_PartionGP.ValueData, FALSE)        :: Boolean AS isPartionGP

           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
           , COALESCE (ObjectBoolean_Avance.ValueData, FALSE)           :: Boolean AS isAvance
           , Object_Unit_View.isErased

           , ObjectString_Unit_Address.ValueData   AS Address
           , ObjectString_Unit_Comment.ValueData   AS Comment

           , COALESCE (ObjectBoolean_PersonalService.ValueData, FALSE)  ::Boolean   AS isPersonalService
           , COALESCE (ObjectDate_PersonalService.ValueData, Null)      ::TDateTime AS PersonalServiceDate

           , ObjectString_Unit_GLN.ValueData         :: TVarChar AS GLN
           , ObjectString_Unit_KATOTTG.ValueData     :: TVarChar AS KATOTTG
           , ObjectString_Unit_AddressEDIN.ValueData :: TVarChar AS AddressEDIN
       FROM Object_Unit_View
            LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = Object_Unit_View.Id
            LEFT JOIN Object_AccountDirection AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = Object_Unit_View.AccountDirectionId

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                 ON ObjectLink_Unit_HistoryCost.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
            LEFT JOIN Object AS Object_Unit_HistoryCost ON Object_Unit_HistoryCost.Id = ObjectLink_Unit_HistoryCost.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Founder
                                 ON ObjectLink_Unit_Founder.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Founder.DescId = zc_ObjectLink_Unit_Founder()
            LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = ObjectLink_Unit_Founder.ChildObjectId

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
            --LEFT JOIN Object AS Object_City ON Object_City.Id = ObjectLink_Unit_City.ChildObjectId
            LEFT JOIN tmpCity AS Object_City ON Object_City.Id = ObjectLink_Unit_City.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalHead
                                 ON ObjectLink_Unit_PersonalHead.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_PersonalHead.DescId   = zc_ObjectLink_Unit_PersonalHead()
            LEFT JOIN Object_Personal_View AS Object_PersonalHead ON Object_PersonalHead.PersonalId = ObjectLink_Unit_PersonalHead.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                 ON ObjectLink_Unit_Department.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
            LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department_two
                                 ON ObjectLink_Unit_Department_two.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
            LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                    ON ObjectBoolean_PartionDate.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind
                                    ON ObjectBoolean_PartionGoodsKind.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionGoodsKind.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CountCount
                                    ON ObjectBoolean_CountCount.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_CountCount.DescId = zc_ObjectBoolean_Unit_CountCount()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGP
                                    ON ObjectBoolean_PartionGP.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PartionGP.DescId = zc_ObjectBoolean_Unit_PartionGP()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_PersonalService
                                    ON ObjectBoolean_PersonalService.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_PersonalService.DescId = zc_ObjectBoolean_Unit_PersonalService()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_Avance
                                    ON ObjectBoolean_Avance.ObjectId = Object_Unit_View.Id
                                   AND ObjectBoolean_Avance.DescId = zc_ObjectBoolean_Unit_Avance()

            LEFT JOIN ObjectDate AS ObjectDate_PersonalService
                                 ON ObjectDate_PersonalService.ObjectId = Object_Unit_View.Id
                                AND ObjectDate_PersonalService.DescId = zc_ObjectDate_Unit_PersonalService()

            LEFT JOIN tmpPartner_Unit ON tmpPartner_Unit.UnitId = Object_Unit_View.Id

            LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                                 ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Unit_View.Id
                                AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
            LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId


       -- WHERE vbAccessKeyAll = TRUE
       WHERE (Object_Unit_View.BranchId = vbObjectId_Constraint
              OR (Object_Unit_View.BranchId > 0 AND vbIsBranch_Kharkov = FALSE)
              OR vbIsConstraint = FALSE
              OR Object_Unit_View.Id IN (8458 -- Склад База ГП
                                       , 8459 -- Склад Реализации
                                       , 8462 -- Склад Брак
                                       , 8461 -- Склад Возвратов
                                       , 256716 -- Склад УТИЛЬ
                                       , 3080691 -- Склад ГП ф.Львов
                                       , 6136671 -- Склад возвратов ф.Львов
                                       , 3080681 -- ф.Львов
                                       , 133049  -- Дільниця обліку і реалізації м`ясної сировини
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

           , CAST (0 as Integer)    AS CityId
           , CAST ('' as TVarChar)  AS CityName
           , CAST (0 as Integer)    AS CityKindId
           , CAST ('' as TVarChar)  AS CityKindName
           , CAST (0 as Integer)    AS RegionId
           , CAST ('' as TVarChar)  AS RegionName
           , CAST (0 as Integer)    AS ProvinceId
           , CAST ('' as TVarChar)  AS ProvinceName

           , CAST (0 as Integer)    AS PersonalHeadId
           , CAST (0 as Integer)    AS PersonalHeadCode
           , CAST ('' as TVarChar)  AS PersonalHeadName
           , CAST ('' as TVarChar)  AS UnitName_Head
           , CAST ('' as TVarChar)  AS BranchName_Head

           , CAST (0 as Integer)    AS PartnerCode
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS UnitId_HistoryCost
           , CAST (0 as Integer)    AS UnitCode_HistoryCost
           , CAST ('' as TVarChar)  AS UnitName_HistoryCost

           , CAST (0 as Integer)    AS FounderId
           , CAST ('' as TVarChar)  AS FounderName

           , CAST (0 as Integer)    AS DepartmentId
           , CAST ('' as TVarChar)  AS DepartmentName
           , CAST (0 as Integer)    AS Department_twoId
           , CAST ('' as TVarChar)  AS Department_twoName

           , CAST (0 as Integer)    AS SheetWorkTimeId
           , CAST ('' as TVarChar)  AS SheetWorkTimeName

           , TRUE  AS isLeaf
           , FALSE AS isPartionDate
           , FALSE AS isPartionGoodsKind
           , FALSE AS isCountCount
           , FALSE AS isPartionGP
           , FALSE AS isIrna
           , CAST (FALSE AS Boolean) AS isAvance
           , FALSE AS isErased
           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS Comment

           , FALSE     ::Boolean   AS isPersonalService
           , Null      ::TDateTime AS PersonalServiceDate

           , CAST ('' as TVarChar)  AS GLN
           , CAST ('' as TVarChar)  AS KATOTTG
           , CAST ('' as TVarChar)  AS AddressEDIN
       FROM Object as Object_Partner
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Partner.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
       WHERE Object_Partner.Id IN (298605 -- Одесса - "ОГОРЕНКО новый дистрибьютор"
                                 , 256624 -- Никополь - "Мержиєвський О.В. ФОП м. Нікополь вул. Альпова 6"
                                  )
      UNION ALL
       SELECT
             0 :: Integer AS Id
           , 0 :: Integer Code
           , '<ПУСТО>' :: TVarChar AS Name

           , 0 :: Integer AS ParentId
           , '<УДАЛИТЬ>' :: TVarChar AS ParentName

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

           , CAST (0 as Integer)    AS CityId
           , CAST ('' as TVarChar)  AS CityName

           , CAST (0 as Integer)    AS CityKindId
           , CAST ('' as TVarChar)  AS CityKindName
           , CAST (0 as Integer)    AS RegionId
           , CAST ('' as TVarChar)  AS RegionName
           , CAST (0 as Integer)    AS ProvinceId
           , CAST ('' as TVarChar)  AS ProvinceName

           , CAST (0 as Integer)    AS PersonalHeadId
           , CAST (0 as Integer)    AS PersonalHeadCode
           , CAST ('' as TVarChar)  AS PersonalHeadName
           , CAST ('' as TVarChar)  AS UnitName_Head
           , CAST ('' as TVarChar)  AS BranchName_Head

           , CAST (0 as Integer)    AS PartnerCode
           , CAST ('' as TVarChar)  AS PartnerName

           , CAST (0 as Integer)    AS UnitId_HistoryCost
           , CAST (0 as Integer)    AS UnitCode_HistoryCost
           , CAST ('' as TVarChar)  AS UnitName_HistoryCost

           , CAST (0 as Integer)    AS FounderId
           , CAST ('' as TVarChar)  AS FounderName

           , CAST (0 as Integer)    AS DepartmentId
           , CAST ('' as TVarChar)  AS DepartmentName
           , CAST (0 as Integer)    AS Department_twoId
           , CAST ('' as TVarChar)  AS Department_twoName

           , CAST (0 as Integer)    AS SheetWorkTimeId
           , CAST ('' as TVarChar)  AS SheetWorkTimeName

           , TRUE  AS isLeaf
           , FALSE AS isPartionDate
           , FALSE AS isPartionGoodsKind
           , FALSE AS isCountCount
           , FALSE AS isPartionGP
           , FALSE AS isIrna
           , CAST (FALSE AS Boolean) AS isAvance
           , FALSE AS isErased
           , CAST ('' as TVarChar)  AS Address
           , CAST ('' as TVarChar)  AS Comment
           , FALSE     ::Boolean    AS isPersonalService
           , Null      ::TDateTime  AS PersonalServiceDate
           , CAST ('' as TVarChar)  AS GLN
           , CAST ('' as TVarChar)  AS KATOTTG
           , CAST ('' as TVarChar)  AS AddressEDIN
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.23         * AddressEDIN
 28.06.23         *
 14.03.23         *
 03.10.22         * isPartionGP
 05.09.22         * PersonalService
 27.07.22         * isCountCount
 04.05.22         *
 15.12.21         * add PersonalHead
                    del PersonalSheetWorkTime
 04.10.21         * Comment
 05.04.19         * UnitId_HistoryCost
 06.03.17         * add isPartionGoodsKind
 16.11.16         * SheetWorkTime
 26.07.16         * Address
 03.07.15         * add ObjectLink_Unit_Route, ObjectLink_Unit_RouteSorting
 15.04.15         * add Contract
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 21.12.13                                        * ParentId
 21.11.13                       * добавил WITH из-за неправильной оптимизации DISTINCT и GROUP BY в 9.3
 03.11.13                                        * add lfSelect_Object_Unit_byProfitLossDirection and Object_AccountDirection_View
 28.10.13                         * переход на View
 04.07.13          * дополнение всеми реквизитами
 03.06.13
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit (zfCalc_UserAdmin())
