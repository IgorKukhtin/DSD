-- Function: gpSelect_Object_Unit()
DROP FUNCTION IF EXISTS gpSelect_Object_Unit_MCS(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_MCS(
    IN inisShowAll   Boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar, Phone TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , ParentId Integer, ParentName TVarChar
             , UserManagerId Integer, UserManagerName TVarChar, MemberName TVarChar
             , JuridicalName TVarChar, MarginCategoryName TVarChar, isLeaf boolean, isErased boolean
             , AreaId Integer, AreaName TVarChar
             , Period   TFloat
             , Period1  TFloat
             , Period2  TFloat
             , Period3  TFloat
             , Period4  TFloat
             , Period5  TFloat
             , Period6  TFloat
             , Period7  TFloat
             , Day   TFloat
             , Day1  TFloat
             , Day2  TFloat
             , Day3  TFloat
             , Day4  TFloat
             , Day5  TFloat
             , Day6  TFloat
             , Day7  TFloat
             , isHoliday Boolean
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    SELECT 
        Object_Unit.Id                                    AS Id
      , Object_Unit.ObjectCode                            AS Code
      , Object_Unit.ValueData                             AS Name
      , ObjectString_Unit_Address.ValueData               AS Address
      , ObjectString_Unit_Phone.ValueData                 AS Phone

      , Object_ProvinceCity.Id                            AS ProvinceCityId
      , Object_ProvinceCity.ValueData                     AS ProvinceCityName

      , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)  AS ParentId
      , Object_Parent.ValueData                           AS ParentName

      , COALESCE (Object_UserManager.Id, 0)               AS UserManagerId
      , Object_UserManager.ValueData                      AS UserManagerName
      , Object_Member.ValueData                           AS MemberName

      , Object_Juridical.ValueData                        AS JuridicalName
      , Object_MarginCategory.ValueData                   AS MarginCategoryName
      , ObjectBoolean_isLeaf.ValueData                    AS isLeaf
      , Object_Unit.isErased                              AS isErased

      , Object_Area.Id                                    AS AreaId
      , Object_Area.ValueData                             AS AreaName

      , ObjectFloat_Period.ValueData        :: TFloat     AS Period
      , ObjectFloat_Period1.ValueData       :: TFloat     AS Period1
      , ObjectFloat_Period2.ValueData       :: TFloat     AS Period2
      , ObjectFloat_Period3.ValueData       :: TFloat     AS Period3
      , ObjectFloat_Period4.ValueData       :: TFloat     AS Period4
      , ObjectFloat_Period5.ValueData       :: TFloat     AS Period5
      , ObjectFloat_Period6.ValueData       :: TFloat     AS Period6
      , ObjectFloat_Period7.ValueData       :: TFloat     AS Period7

      , ObjectFloat_Day.ValueData           :: TFloat     AS Day
      , ObjectFloat_Day1.ValueData          :: TFloat     AS Day1
      , ObjectFloat_Day2.ValueData          :: TFloat     AS Day2
      , ObjectFloat_Day3.ValueData          :: TFloat     AS Day3
      , ObjectFloat_Day4.ValueData          :: TFloat     AS Day4
      , ObjectFloat_Day5.ValueData          :: TFloat     AS Day5
      , ObjectFloat_Day6.ValueData          :: TFloat     AS Day6
      , ObjectFloat_Day7.ValueData          :: TFloat     AS Day7

      , ObjectBoolean_Holiday.ValueData                   AS isHoliday

    FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
         
        LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                             ON ObjectLink_Unit_ProvinceCity.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
        LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_MarginCategory
                             ON ObjectLink_Unit_MarginCategory.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_MarginCategory.DescId = zc_ObjectLink_Unit_MarginCategory()
        LEFT JOIN Object AS Object_MarginCategory ON Object_MarginCategory.Id = ObjectLink_Unit_MarginCategory.ChildObjectId

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

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

        LEFT JOIN ObjectString AS ObjectString_Unit_Address
                               ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

        LEFT JOIN ObjectString AS ObjectString_Unit_Phone
                               ON ObjectString_Unit_Phone.ObjectId = Object_Unit.Id
                              AND ObjectString_Unit_Phone.DescId = zc_ObjectString_Unit_Phone()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Holiday
                                ON ObjectBoolean_Holiday.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Holiday.DescId = zc_ObjectBoolean_Unit_Holiday()
      
        LEFT JOIN ObjectFloat AS ObjectFloat_Period
                              ON ObjectFloat_Period.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period.DescId = zc_ObjectFloat_Unit_Period()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period1
                              ON ObjectFloat_Period1.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period1.DescId = zc_ObjectFloat_Unit_Period1()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period2
                              ON ObjectFloat_Period2.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period2.DescId = zc_ObjectFloat_Unit_Period2()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period3
                              ON ObjectFloat_Period3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period3.DescId = zc_ObjectFloat_Unit_Period3()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period4
                              ON ObjectFloat_Period4.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period4.DescId = zc_ObjectFloat_Unit_Period4()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period5
                              ON ObjectFloat_Period5.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period5.DescId = zc_ObjectFloat_Unit_Period5()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period6
                              ON ObjectFloat_Period6.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period6.DescId = zc_ObjectFloat_Unit_Period6()
        LEFT JOIN ObjectFloat AS ObjectFloat_Period7
                              ON ObjectFloat_Period7.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Period7.DescId = zc_ObjectFloat_Unit_Period7()
        
        LEFT JOIN ObjectFloat AS ObjectFloat_Day
                              ON ObjectFloat_Day.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day.DescId = zc_ObjectFloat_Unit_Day()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day1
                              ON ObjectFloat_Day1.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day1.DescId = zc_ObjectFloat_Unit_Day1()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day2
                              ON ObjectFloat_Day2.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day2.DescId = zc_ObjectFloat_Unit_Day2()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day3
                              ON ObjectFloat_Day3.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day3.DescId = zc_ObjectFloat_Unit_Day3()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day4
                              ON ObjectFloat_Day4.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day4.DescId = zc_ObjectFloat_Unit_Day4()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day5
                              ON ObjectFloat_Day5.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day5.DescId = zc_ObjectFloat_Unit_Day5()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day6
                              ON ObjectFloat_Day6.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day6.DescId = zc_ObjectFloat_Unit_Day6()
        LEFT JOIN ObjectFloat AS ObjectFloat_Day7
                              ON ObjectFloat_Day7.ObjectId = Object_Unit.Id
                             AND ObjectFloat_Day7.DescId = zc_ObjectFloat_Unit_Day7()
                             


    WHERE Object_Unit.DescId = zc_Object_Unit()
      AND (inisShowAll = True OR Object_Unit.isErased = False);
  
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit_MCS (False, '2')