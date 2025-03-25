-- Function: gpSelect_Object_Unit_Personal()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Personal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Personal(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               ParentId Integer, ParentName TVarChar,
               BusinessId Integer, BusinessName TVarChar,
               BranchId Integer, BranchName TVarChar, 
               
               AreaId Integer, AreaName TVarChar,
               CityId Integer, CityName TVarChar,
               CityKindId Integer, CityKindName TVarChar,
               RegionId Integer, RegionName TVarChar,
               ProvinceId Integer, ProvinceName TVarChar,
               
               PersonalHeadId Integer, PersonalHeadCode Integer, PersonalHeadName TVarChar, UnitName_Head TVarChar, BranchName_Head TVarChar,
               PartnerCode Integer, PartnerName TVarChar,
               
               FounderId Integer, FounderName TVarChar,
               DepartmentId Integer, DepartmentName TVarChar,
               Department_twoId Integer, Department_twoName TVarChar,    

               SheetWorkTimeId Integer, SheetWorkTimeName TVarChar,
              
               isIrna Boolean,
               isAvance Boolean,
               isErased Boolean,
               Address TVarChar,
               Comment TVarChar,
               isPersonalService Boolean, PersonalServiceDate TDateTime,
               PersonalServiceListName TVarChar,
               isError_psl Boolean

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
   -- Результат
   RETURN QUERY
     WITH
     tmpUnit AS (SELECT gpSelect.*
                 FROM gpSelect_Object_Unit (inSession) AS gpSelect
                 WHERE gpSelect.isErased = FALSE
                )
   , tmpPersonalServiceList AS (SELECT tmp.UnitId
                                     , SUM (tmp.Count) AS Count
                                     , STRING_AGG (DISTINCT tmp.PersonalServiceListName, ';') ::TVarChar AS PersonalServiceListName
                                FROM (SELECT DISTINCT 
                                             ObjectLink_Personal_Unit.ChildObjectId AS UnitId
                                           , 1                                      AS Count
                                           , Object_PersonalServiceList.ValueData   AS PersonalServiceListName
                                      FROM Object AS Object_Personal
                                           INNER JOIN ObjectBoolean AS ObjectBoolean_Main
                                                                    ON ObjectBoolean_Main.ObjectId = Object_Personal.Id
                                                                   AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_Personal_Main() 
                                                                   AND ObjectBoolean_Main.ValueData = TRUE
                                           INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                                                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                                               
                                           INNER JOIN ObjectLink AS ObjectLink_Personal_PersonalServiceList
                                                                 ON ObjectLink_Personal_PersonalServiceList.ObjectId = Object_Personal.Id
                                                                AND ObjectLink_Personal_PersonalServiceList.DescId = zc_ObjectLink_Personal_PersonalServiceList()
                                           LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = ObjectLink_Personal_PersonalServiceList.ChildObjectId                                  
                                      WHERE Object_Personal.DescId = zc_Object_Personal()
                                        AND Object_Personal.isErased = FALSE
                                        AND COALESCE (ObjectLink_Personal_PersonalServiceList.ChildObjectId,0) <> 0
                                        AND COALESCE ( TRIM (Object_PersonalServiceList.ValueData),'') <> ''
                                      ) AS tmp
                                      GROUP BY tmp.UnitId
                                )
       --
       SELECT
             Object_Unit.Id
           , Object_Unit.Code
           , Object_Unit.Name

           , Object_Unit.ParentId
           , Object_Unit.ParentName

           , Object_Unit.BusinessId
           , Object_Unit.BusinessName

           , Object_Unit.BranchId
           , Object_Unit.BranchName

           , Object_Unit.AreaId
           , Object_Unit.AreaName

           , Object_Unit.CityId
           , Object_Unit.CityName

           , Object_Unit.CityKindId
           , Object_Unit.CityKindName
           , Object_Unit.RegionId
           , Object_Unit.RegionName
           , Object_Unit.ProvinceId
           , Object_Unit.ProvinceName

           , Object_Unit.PersonalHeadId
           , Object_Unit.PersonalHeadCode
           , Object_Unit.PersonalHeadName
           , Object_Unit.UnitName_Head
           , Object_Unit.BranchName_Head

           , Object_Unit.PartnerCode
           , Object_Unit.PartnerName

           , Object_Unit.FounderId
           , Object_Unit.FounderName

           , Object_Unit.DepartmentId
           , Object_Unit.DepartmentName
           , Object_Unit.Department_twoId
           , Object_Unit.Department_twoName

           , Object_Unit.SheetWorkTimeId
           , Object_Unit.SheetWorkTimeName

           , Object_Unit.isIrna       :: Boolean AS isIrna
           , Object_Unit.isAvance     :: Boolean AS isAvance
           , Object_Unit.isErased
           , Object_Unit.Address
           , Object_Unit.Comment

           , Object_Unit.isPersonalService    ::Boolean   AS isPersonalService
           , Object_Unit.PersonalServiceDate  ::TDateTime AS PersonalServiceDate

           , tmpPersonalServiceList.PersonalServiceListName ::TVarChar
           , CASE WHEN tmpPersonalServiceList.Count > 1 THEN TRUE ELSE FALSE END ::Boolean AS isError_psl
       FROM tmpUnit AS Object_Unit
            INNER JOIN tmpPersonalServiceList ON tmpPersonalServiceList.UnitId = Object_Unit.Id
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.02.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_Personal (zfCalc_UserAdmin())
