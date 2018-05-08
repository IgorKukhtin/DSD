-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               Address TVarChar, 
               ProvinceCityId Integer, ProvinceCityName TVarChar,
               ParentId Integer, ParentName TVarChar,
               UserManagerId Integer, UserManagerName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, 
               MarginCategoryId Integer, MarginCategoryName TVarChar,
               AreaId Integer, AreaName TVarChar,
               UnitCategoryId Integer, UnitCategoryName TVarChar,
               isLeaf boolean, 
               TaxService TFloat, TaxServiceNigth TFloat,
               StartServiceNigth TDateTime, EndServiceNigth TDateTime,
               CreateDate TDateTime, CloseDate TDateTime,
               isRepriceAuto Boolean
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
           , CAST ('' as TVarChar) AS Address
           
           , CAST (0 as Integer)   AS ProvinceCityId
           , CAST ('' as TVarChar) AS ProvinceCityName
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 
           
           , CAST (0 as Integer)   AS UserManagerId
           , CAST ('' as TVarChar) AS UserManagerName

           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           
           , CAST (0 as Integer)   AS MarginCategoryId
           , CAST ('' as TVarChar) AS MarginCategoryName

           , CAST (0 as Integer)   AS AreaId
           , CAST ('' as TVarChar) AS AreaName
           
           , CAST (0 as Integer)   AS UnitCategoryId
           , CAST ('' as TVarChar) AS UnitCategoryName
           
           , false                 AS isLeaf
           , CAST (0 as TFloat)    AS TaxService
           , CAST (0 as TFloat)    AS TaxServiceNigth
           
           , CAST (Null as TDateTime) AS StartServiceNigth
           , CAST (Null as TDateTime) AS EndServiceNigth

           , CAST ((CURRENT_DATE + INTERVAL '1 DAY') as TDateTime) AS CreateDate
           , CAST ((CURRENT_DATE + INTERVAL '1 DAY') as TDateTime) AS CloseDate

           , False                 AS isRepriceAuto
;
   ELSE
       RETURN QUERY 
      
    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name
      , ObjectString_Unit_Address.ValueData                AS Address

      , Object_ProvinceCity.Id                             AS ProvinceCityId
      , Object_ProvinceCity.ValueData                      AS ProvinceCityName
      
      , Object_Parent.Id                                   AS ParentId
      , Object_Parent.ValueData                            AS ParentName

      , COALESCE (Object_UserManager.Id, 0)                AS UserManagerId
      , COALESCE (Object_Member.ValueData, Object_UserManager.ValueData) AS UserManagerName
      
      , Object_Juridical.Id                                AS JuridicalId
      , Object_Juridical.ValueData                         AS JuridicalName

      , Object_MarginCategory.Id                           AS MarginCategoryId
      , Object_MarginCategory.ValueData                    AS MarginCategoryName
      
      , Object_Area.Id                                     AS AreaId
      , Object_Area.ValueData                              AS AreaName
      
      , Object_UnitCategory.Id                                     AS UnitCategoryId
      , Object_UnitCategory.ValueData                              AS UnitCategoryName
      
      , ObjectBoolean_isLeaf.ValueData                     AS isLeaf

      , ObjectFloat_TaxService.ValueData                   AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData              AS TaxServiceNigth

      , CASE WHEN COALESCE(ObjectDate_StartServiceNigth.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartServiceNigth.ValueData ELSE Null END ::TDateTime  AS StartServiceNigth
      , CASE WHEN COALESCE(ObjectDate_EndServiceNigth.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_EndServiceNigth.ValueData ELSE Null END ::TDateTime  AS EndServiceNigth
      --, ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

      , COALESCE (ObjectDate_Create.ValueData, (CURRENT_DATE + INTERVAL '1 DAY')) ::TDateTime  AS CreateDate
      , COALESCE (ObjectDate_Close.ValueData, (CURRENT_DATE + INTERVAL '1 DAY'))  ::TDateTime  AS CloseDate
      
      , COALESCE(ObjectBoolean_RepriceAuto.ValueData, False) AS isRepriceAuto

    FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
      
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_MarginCategory
                             ON ObjectLink_Unit_MarginCategory.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_MarginCategory.DescId = zc_ObjectLink_Unit_MarginCategory()
        LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_Unit_MarginCategory.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                             ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager
                             ON ObjectLink_Unit_UserManager.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_UserManager.DescId = zc_ObjectLink_Unit_UserManager()
        LEFT JOIN Object AS Object_UserManager ON Object_UserManager.Id = ObjectLink_Unit_UserManager.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_UserManager.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                             ON ObjectLink_Unit_Area.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
        LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId
                
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                             ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id 
                            AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
        LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectString AS ObjectString_Unit_Address
                               ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxService
                              ON ObjectFloat_TaxService.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxService.DescId = zc_ObjectFloat_Unit_TaxService()

        LEFT JOIN ObjectFloat AS ObjectFloat_TaxServiceNigth
                              ON ObjectFloat_TaxServiceNigth.ObjectId = Object_Unit.Id
                             AND ObjectFloat_TaxServiceNigth.DescId = zc_ObjectFloat_Unit_TaxServiceNigth()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RepriceAuto
                                ON ObjectBoolean_RepriceAuto.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RepriceAuto.DescId = zc_ObjectBoolean_Unit_RepriceAuto()

        LEFT JOIN ObjectDate AS ObjectDate_StartServiceNigth
                             ON ObjectDate_StartServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartServiceNigth.DescId = zc_ObjectDate_Unit_StartServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_EndServiceNigth
                             ON ObjectDate_EndServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndServiceNigth.DescId = zc_ObjectDate_Unit_EndServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_Create
                             ON ObjectDate_Create.ObjectId = Object_Unit.Id
                            AND ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
        LEFT JOIN ObjectDate AS ObjectDate_Close
                             ON ObjectDate_Close.ObjectId = Object_Unit.Id
                            AND ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()
                            
    WHERE Object_Unit.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit (integer, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.05.18                                                        * add UnitCategory
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 08.04.16         *
 24.02.16         * 
 27.06.14         *
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')

--select * from gpGet_Object_Unit(inId := 377613 ,  inSession := '3'::TVarChar);
