-- Function: gpSelect_Object_RepriceUnitSheduler()

DROP FUNCTION IF EXISTS gpSelect_Object_RepriceUnitSheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RepriceUnitSheduler(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Ord Integer, ID Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AreaName TVarChar, JuridicalId Integer, JuridicalName TVarChar, ProvinceCityName TVarChar

             , PercentDifference Integer
             , VAT20 Boolean
             , PercentRepriceMax TFloat
             , PercentRepriceMin TFloat
             , EqualRepriceMax TFloat
             , EqualRepriceMin TFloat
             , isEqual Boolean
             , UnitRePriceId Integer
             , UnitRePriceName TVarChar
             , UserId Integer
             , UserName TVarChar
             , DataStartLast TDateTime
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

   RETURN QUERY
       SELECT
             ROW_NUMBER() OVER (ORDER BY Object_RepriceUnitSheduler.Id)::Integer as Ord
           , Object_RepriceUnitSheduler.Id                    AS Id
           , Object_RepriceUnitSheduler.ObjectCode            AS Code
           , Object_RepriceUnitSheduler.ValueData             AS Name
           , Object_Unit.Id                                   AS UnitId
           , Object_Unit.ObjectCode                           AS UnitCode
           , Object_Unit.ValueData                            AS UnitName
           , Object_Area.ValueData                            AS AreaName
           , Object_Juridical.Id                              AS JuridicalID
           , Object_Juridical.ValueData                       AS JuridicalName
           , Object_ProvinceCity.ValueData                    AS ProvinceCityName

           , ObjectFloat_PercentDifference.ValueData::Integer AS PercentDifference
           , ObjectBoolean_VAT20.ValueData                    AS VAT20
           , ObjectFloat_PercentRepriceMax.ValueData          AS PercentRepriceMax
           , ObjectFloat_PercentRepriceMin.ValueData          AS PercentRepriceMin
           , ObjectFloat_EqualRepriceMax.ValueData            AS EqualRepriceMax
           , ObjectFloat_EqualRepriceMin.ValueData            AS EqualRepriceMin
           , ObjectBoolean_Equal.ValueData                    AS isEqual
           , COALESCE (Object_UnitRePrice.Id,0)          ::Integer  AS UnitRePriceId
           , COALESCE (Object_UnitRePrice.ValueData, '') ::TVarChar AS UnitRePriceName
           , Object_User.Id                                   AS UnitId
           , Object_User.ValueData                            AS UnitName
           , ObjectDate_DataStartLast.ValueData               AS DataStartLast
           , Object_RepriceUnitSheduler.isErased              AS isErased

       FROM Object AS Object_RepriceUnitSheduler
           LEFT JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()
           LEFT JOIN Object AS Object_Unit
                             ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                ON ObjectLink_Unit_Area.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
           LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Unit_Area.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Unit_ProvinceCity
                                ON ObjectLink_Unit_ProvinceCity.ObjectId = ObjectLink_Unit_Juridical.ObjectId
                               AND ObjectLink_Unit_ProvinceCity.DescId = zc_ObjectLink_Unit_ProvinceCity()
           LEFT JOIN Object AS Object_ProvinceCity ON Object_ProvinceCity.Id = ObjectLink_Unit_ProvinceCity.ChildObjectId



           LEFT JOIN ObjectFloat AS ObjectFloat_PercentDifference
                                 ON ObjectFloat_PercentDifference.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectFloat_PercentDifference.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentDifference()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_VAT20
                                   ON ObjectBoolean_VAT20.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectBoolean_VAT20.DescId = zc_ObjectBoolean_RepriceUnitSheduler_VAT20()

           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRepriceMax
                                 ON ObjectFloat_PercentRepriceMax.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectFloat_PercentRepriceMax.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMax()

           LEFT JOIN ObjectFloat AS ObjectFloat_PercentRepriceMin
                                 ON ObjectFloat_PercentRepriceMin.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectFloat_PercentRepriceMin.DescId = zc_ObjectFloat_RepriceUnitSheduler_PercentRepriceMin()

           LEFT JOIN ObjectFloat AS ObjectFloat_EqualRepriceMax
                                 ON ObjectFloat_EqualRepriceMax.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectFloat_EqualRepriceMax.DescId = zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMax()

           LEFT JOIN ObjectFloat AS ObjectFloat_EqualRepriceMin
                                 ON ObjectFloat_EqualRepriceMin.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectFloat_EqualRepriceMin.DescId = zc_ObjectFloat_RepriceUnitSheduler_EqualRepriceMin()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Equal
                                   ON ObjectBoolean_Equal.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectBoolean_Equal.DescId = zc_ObjectBoolean_RepriceUnitSheduler_Equal()
                                  
           LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                                ON ObjectLink_Unit_UnitRePrice.ObjectId = Object_Unit.Id 
                               AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()
           LEFT JOIN Object AS Object_UnitRePrice ON Object_UnitRePrice.Id = ObjectLink_Unit_UnitRePrice.ChildObjectId
                                  
           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RepriceUnitSheduler_User()
           LEFT JOIN Object AS Object_User
                             ON Object_User.Id = ObjectLink_User.ChildObjectId

           LEFT JOIN ObjectDate AS ObjectDate_DataStartLast
                                ON ObjectDate_DataStartLast.ObjectId = Object_RepriceUnitSheduler.Id
                               AND ObjectDate_DataStartLast.DescId = zc_ObjectDate_RepriceUnitSheduler_DataStartLast()

       WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RepriceUnitSheduler(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 30.10.18        *
 29.10.18        *
 23.10.18        *
 22.10.18        *
*/

-- тест
-- 
-- SELECT * FROM gpSelect_Object_RepriceUnitSheduler ('3')