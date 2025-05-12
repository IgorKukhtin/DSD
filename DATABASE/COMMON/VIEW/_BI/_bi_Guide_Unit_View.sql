-- View: _bi_Guide_Unit_View

 DROP VIEW IF EXISTS _bi_Guide_Unit_View;

-- Справочник Подразделения
CREATE OR REPLACE VIEW _bi_Guide_Unit_View
AS
       WITH
       Object_AccountDirection AS (SELECT * FROM Object_AccountDirection_View)
     , tmpCity AS (SELECT * FROM gpSelect_Object_City(zfCalc_UserAdmin()) AS tmp)
       SELECT
             Object_Unit.Id         AS Id
           , Object_Unit.ObjectCode AS Code
           , Object_Unit.ValueData  AS Name 
           , Object_Unit.AccessKeyId
             -- Признак "Удален да/нет"
           , Object_Unit.isErased   AS isErased

            -- Родитель Группа
           , Object_Parent.Id                    AS ParentId 
           , Object_Parent.ObjectCode            AS ParentCode
           , Object_Parent.ValueData             AS ParentName
           --Бизнес
           , Object_Business.Id         AS BusinessId
           , Object_Business.ObjectCode AS BusinessCode
           , Object_Business.ValueData  AS BusinessName 
           --Филиалы
           , Object_Branch.Id         AS BranchId
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData  AS BranchName
           --Юридическое лицо(главное)
           , Object_Juridical.Id         AS JuridicalId
           , Object_Juridical.ObjectCode AS JuridicalCode
           , Object_Juridical.ValueData  AS JuridicalName
           --Договора(кому выставляются затраты)
           , Object_Contract_View.ContractId
           , Object_Contract_View.InvNumber
           --Договора(кому выставляются затраты)  - юр.лицо
           , Object_Contract_View.JuridicalId      AS Contract_JuridicalId
           , Object_Juridical_Contract.ValueData   AS Contract_JuridicalName
           --Договора(кому выставляются затраты)  - Статьи назначения
           , Object_Contract_View.InfomoneyId      AS Contract_InfomoneyId
           , Object_Infomoney_Contract.ValueData   AS Contract_InfomoneyName
           --Аналитики управленческих счетов - направление
           , ObjectLink_Unit_AccountDirection.ChildObjectId AS AccountDirectionId
           , View_AccountDirection.AccountGroupCode
           , View_AccountDirection.AccountGroupName
           , View_AccountDirection.AccountDirectionCode
           , View_AccountDirection.AccountDirectionName
           --Аналитики статей отчета о прибылях и убытках - направление
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossGroupName
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionCode
           , lfObject_Unit_byProfitLossDirection.ProfitLossDirectionName
           --Регион
           , Object_Area.Id                 AS AreaId
           , Object_Area.ValueData          AS AreaName
           --Город
           , Object_City.Id                 AS CityId
           , Object_City.Name               AS CityName
           , Object_City.CityKindId
           , Object_City.CityKindName
           , Object_City.RegionId
           , Object_City.RegionName
           , Object_City.ProvinceId
           , Object_City.ProvinceName
           --Руководитель подразделения
           , Object_PersonalHead.PersonalId    AS PersonalHeadId
           , Object_PersonalHead.PersonalCode  AS PersonalHeadCode
           , Object_PersonalHead.PersonalName  AS PersonalHeadName
           --Руководитель подразделения - Подразделение
           , Object_PersonalHead.UnitName      AS UnitName_Head  
           --Руководитель подразделения - Филиал
           , Object_PersonalHead.BranchName    AS BranchName_Head
           --Подразделение, указывается если с/с возврата от покупателя берется из "альтернативного" подразделения
           , Object_Unit_HistoryCost.Id            AS UnitId_HistoryCost
           , Object_Unit_HistoryCost.ObjectCode    AS UnitCode_HistoryCost
           , Object_Unit_HistoryCost.ValueData     AS UnitName_HistoryCost
           --Учредитель
           , Object_Founder.Id                 AS FounderId
           , Object_Founder.ValueData          AS FounderName
           --Департамент 1 уровня
           , Object_Department.Id              AS DepartmentId
           , Object_Department.ValueData       AS DepartmentName
           --Департамент 2-го уровня
           , Object_Department_two.Id          AS Department_twoId
           , Object_Department_two.ValueData   AS Department_twoName
           --Режим работы (Шаблон табеля р.вр.)
           , Object_SheetWorkTime.Id           AS SheetWorkTimeId
           , Object_SheetWorkTime.ValueData    AS SheetWorkTimeName

           --Свойство указывающее имеет ли элемент справочника подчиненные элементы
           , ObjectBoolean_isLeaf.ValueData AS isLeaf
           --Партии даты в учете
           , ObjectBoolean_PartionDate.ValueData   AS isPartionDate
           --Партии по виду упак. для сырья
           , COALESCE (ObjectBoolean_PartionGoodsKind.ValueData, FALSE) :: Boolean AS isPartionGoodsKind
           --Учет батонов
           , COALESCE (ObjectBoolean_CountCount.ValueData, FALSE)       :: Boolean AS isCountCount
           --Партии для ГП и Тушенки
           , COALESCE (ObjectBoolean_PartionGP.ValueData, FALSE)        :: Boolean AS isPartionGP
           --Ирна
           , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)       :: Boolean AS isIrna
           --Начисление аванс автомат.
           , COALESCE (ObjectBoolean_Avance.ValueData, FALSE)           :: Boolean AS isAvance
           --Адрес
           , ObjectString_Unit_Address.ValueData   AS Address
           --Примечание
           , ObjectString_Unit_Comment.ValueData   AS Comment
           --Формировать начисление зп автоматом
           , COALESCE (ObjectBoolean_PersonalService.ValueData, FALSE)  ::Boolean   AS isPersonalService
           --Дата/время когда сформировались начисление зп автоматом
           , COALESCE (ObjectDate_PersonalService.ValueData, Null)      ::TDateTime AS PersonalServiceDate
           --GLN - система EDIN
           , ObjectString_Unit_GLN.ValueData         :: TVarChar AS GLN
           --КАТОТТГ - система EDIN
           , ObjectString_Unit_KATOTTG.ValueData     :: TVarChar AS KATOTTG
           --Адрес для EDIN - система EDIN
           , ObjectString_Unit_AddressEDIN.ValueData :: TVarChar AS AddressEDIN
       FROM Object AS Object_Unit
           -- Родитель Группа
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                                ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Parent.DescId   = zc_ObjectLink_Unit_Parent()
           LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
           --Бизнес
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Business
                                ON ObjectLink_Unit_Business.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Business.DescId = zc_ObjectLink_Unit_Business()
           LEFT JOIN Object AS Object_Business ON Object_Business.Id = ObjectLink_Unit_Business.ChildObjectId
           --Филиалы
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
           LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
           --Юридическое лицо(главное)
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
           --Аналитики управленческих счетов - направление
           LEFT JOIN ObjectLink AS ObjectLink_Unit_AccountDirection
                                ON ObjectLink_Unit_AccountDirection.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_AccountDirection.DescId = zc_ObjectLink_Unit_AccountDirection()
           LEFT JOIN Object_AccountDirection AS View_AccountDirection ON View_AccountDirection.AccountDirectionId = ObjectLink_Unit_AccountDirection.ChildObjectId
           --Аналитики статей отчета о прибылях и убытках - направление
           LEFT JOIN lfSelect_Object_Unit_byProfitLossDirection() AS lfObject_Unit_byProfitLossDirection ON lfObject_Unit_byProfitLossDirection.UnitId = Object_Unit.Id

           --Свойство указывающее имеет ли элемент справочника подчиненные элементы
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                   ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                                  AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()
            --Адрес
            LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                   ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()
            --Примечание
            LEFT JOIN ObjectString AS ObjectString_Unit_Comment
                                   ON ObjectString_Unit_Comment.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_Comment.DescId = zc_ObjectString_Unit_Comment()
            --GLN - система EDIN
            LEFT JOIN ObjectString AS ObjectString_Unit_GLN
                                   ON ObjectString_Unit_GLN.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_GLN.DescId = zc_ObjectString_Unit_GLN()
            --КАТОТТГ - система EDIN
            LEFT JOIN ObjectString AS ObjectString_Unit_KATOTTG
                                   ON ObjectString_Unit_KATOTTG.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_KATOTTG.DescId = zc_ObjectString_Unit_KATOTTG()
            --Адрес для EDIN - система EDIN
            LEFT JOIN ObjectString AS ObjectString_Unit_AddressEDIN
                                   ON ObjectString_Unit_AddressEDIN.ObjectId = Object_Unit.Id
                                  AND ObjectString_Unit_AddressEDIN.DescId = zc_ObjectString_Unit_AddressEDIN()
            --Подразделение, указывается если с/с возврата от покупателя берется из "альтернативного" подразделения
            LEFT JOIN ObjectLink AS ObjectLink_Unit_HistoryCost
                                 ON ObjectLink_Unit_HistoryCost.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_HistoryCost.DescId = zc_ObjectLink_Unit_HistoryCost()
            LEFT JOIN Object AS Object_Unit_HistoryCost ON Object_Unit_HistoryCost.Id = ObjectLink_Unit_HistoryCost.ChildObjectId
            --Учредитель
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Founder
                                 ON ObjectLink_Unit_Founder.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Founder.DescId = zc_ObjectLink_Unit_Founder()
            LEFT JOIN Object AS Object_Founder ON Object_Founder.Id = ObjectLink_Unit_Founder.ChildObjectId
            --Договор(кому выставляются затраты)
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract
                                 ON ObjectLink_Unit_Contract.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ObjectLink_Unit_Contract.ChildObjectId
            --Договора(кому выставляются затраты)  - юр.лицо
            LEFT JOIN Object AS Object_Juridical_Contract ON Object_Juridical_Contract.Id = Object_Contract_View.JuridicalId
            --Договора(кому выставляются затраты)  - Статьи назначения
            LEFT JOIN Object AS Object_Infomoney_Contract ON Object_Infomoney_Contract.Id = Object_Contract_View.InfomoneyId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Route
                                 ON ObjectLink_Unit_Route.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Route.DescId = zc_ObjectLink_Unit_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Unit_Route.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_RouteSorting
                                 ON ObjectLink_Unit_RouteSorting.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_RouteSorting.DescId = zc_ObjectLink_Unit_RouteSorting()
            LEFT JOIN Object AS Object_RouteSorting ON Object_RouteSorting.Id = ObjectLink_Unit_RouteSorting.ChildObjectId
            --Регион
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                 ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
            --Города
            LEFT JOIN ObjectLink AS ObjectLink_Unit_City
                                 ON ObjectLink_Unit_City.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_City.DescId = zc_ObjectLink_Unit_City()
            LEFT JOIN tmpCity AS Object_City ON Object_City.Id = ObjectLink_Unit_City.ChildObjectId
            --Руководитель подразделения
            LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalHead
                                 ON ObjectLink_Unit_PersonalHead.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_PersonalHead.DescId   = zc_ObjectLink_Unit_PersonalHead()
            LEFT JOIN Object_Personal_View AS Object_PersonalHead ON Object_PersonalHead.PersonalId = ObjectLink_Unit_PersonalHead.ChildObjectId
            --Департамент 1-го уровня
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                 ON ObjectLink_Unit_Department.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
            LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId
            --Департамент 2-го уровня
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department_two
                                 ON ObjectLink_Unit_Department_two.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
            LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId
            --Партии даты в учете
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionDate
                                    ON ObjectBoolean_PartionDate.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_PartionDate.DescId = zc_ObjectBoolean_Unit_PartionDate()
            --Партии по виду упак. для сырья
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGoodsKind
                                    ON ObjectBoolean_PartionGoodsKind.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_PartionGoodsKind.DescId = zc_ObjectBoolean_Unit_PartionGoodsKind()
            --Ирна
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                    ON ObjectBoolean_Guide_Irna.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()
            --Учет батонов
            LEFT JOIN ObjectBoolean AS ObjectBoolean_CountCount
                                    ON ObjectBoolean_CountCount.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_CountCount.DescId = zc_ObjectBoolean_Unit_CountCount()
            --Партии для ГП и Тушенки
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PartionGP
                                    ON ObjectBoolean_PartionGP.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_PartionGP.DescId = zc_ObjectBoolean_Unit_PartionGP()
            --Формировать начисление зп автоматом
            LEFT JOIN ObjectBoolean AS ObjectBoolean_PersonalService
                                    ON ObjectBoolean_PersonalService.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_PersonalService.DescId = zc_ObjectBoolean_Unit_PersonalService()
            --Начисление аванс автомат.
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Avance
                                    ON ObjectBoolean_Avance.ObjectId = Object_Unit.Id
                                   AND ObjectBoolean_Avance.DescId = zc_ObjectBoolean_Unit_Avance()
            --Дата/время когда сформировались начисление зп автоматом
            LEFT JOIN ObjectDate AS ObjectDate_PersonalService
                                 ON ObjectDate_PersonalService.ObjectId = Object_Unit.Id
                                AND ObjectDate_PersonalService.DescId = zc_ObjectDate_Unit_PersonalService()

             --Режим работы (Шаблон табеля р.вр.)
            LEFT JOIN ObjectLink AS ObjectLink_Unit_SheetWorkTime
                                 ON ObjectLink_Unit_SheetWorkTime.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_SheetWorkTime.DescId = zc_ObjectLink_Unit_SheetWorkTime()
            LEFT JOIN Object AS Object_SheetWorkTime ON Object_SheetWorkTime.Id = ObjectLink_Unit_SheetWorkTime.ChildObjectId
            
       WHERE Object_Unit.DescId = zc_Object_Unit()
      ;

ALTER TABLE _bi_Guide_Unit_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.05.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_Unit_View limit 10