-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Address TVarChar
             , ProvinceCityId Integer, ProvinceCityName TVarChar
             , ParentId Integer, ParentName TVarChar
             , JuridicalName TVarChar, MarginCategoryName TVarChar, isLeaf boolean, isErased boolean
             , RouteId integer, RouteName TVarChar
             , RouteSortingId integer, RouteSortingName TVarChar
             , TaxService TFloat, TaxServiceNigth TFloat
             , StartServiceNigth TDateTime, EndServiceNigth TDateTime
             , isRepriceAuto Boolean
             , isOver Boolean
             , isUploadBadm Boolean
             , isMarginCategory Boolean
             , Num_byReportBadm Integer
) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
    WITH 
    tmpByBadm AS (SELECT ObjectBoolean_UploadBadm.ObjectId    AS UnitId
                       , ROW_NUMBER() OVER (ORDER BY ObjectBoolean_UploadBadm.ObjectId )  ::integer  AS Num_byReportBadm
                  FROM ObjectBoolean AS ObjectBoolean_UploadBadm
                  WHERE ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
                    AND ObjectBoolean_UploadBadm.ValueData = TRUE)

    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name
      , ObjectString_Unit_Address.ValueData                AS Address

      , Object_ProvinceCity.Id                             AS ProvinceCityId
      , Object_ProvinceCity.ValueData                      AS ProvinceCityName

      , COALESCE(ObjectLink_Unit_Parent.ChildObjectId,0)   AS ParentId
      , Object_Parent.ValueData                            AS ParentName

      , Object_Juridical.ValueData                         AS JuridicalName
      , Object_MarginCategory.ValueData                    AS MarginCategoryName
      , ObjectBoolean_isLeaf.ValueData                     AS isLeaf
      , Object_Unit.isErased                               AS isErased

      , 0                                                  AS RouteId
      , ''::TVarChar                                       AS RouteName
      , 0                                                  AS RouteSortingId
      , ''::TVarChar                                       AS RouteSortingName

      , ObjectFloat_TaxService.ValueData                     AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData                AS TaxServiceNigth

      , ObjectDate_StartServiceNigth.ValueData               AS StartServiceNigth
      , ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

      , COALESCE(ObjectBoolean_RepriceAuto.ValueData, False) AS isRepriceAuto
      , COALESCE(ObjectBoolean_Over.ValueData, False)        AS isOver
      , COALESCE(ObjectBoolean_UploadBadm.ValueData, False)  AS isUploadBadm
      , COALESCE(ObjectBoolean_MarginCategory.ValueData, False)  AS isMarginCategory
      , COALESCE(tmpByBadm.Num_byReportBadm, Null) ::Integer     AS Num_byReportBadm

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
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Over
                                ON ObjectBoolean_Over.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_Over.DescId = zc_ObjectBoolean_Unit_Over()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_UploadBadm
                                ON ObjectBoolean_UploadBadm.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_MarginCategory
                                ON ObjectBoolean_MarginCategory.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_MarginCategory.DescId = zc_ObjectBoolean_Unit_MarginCategory()

        LEFT JOIN ObjectDate AS ObjectDate_StartServiceNigth
                             ON ObjectDate_StartServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartServiceNigth.DescId = zc_ObjectDate_Unit_StartServiceNigth()

        LEFT JOIN ObjectDate AS ObjectDate_EndServiceNigth
                             ON ObjectDate_EndServiceNigth.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndServiceNigth.DescId = zc_ObjectDate_Unit_EndServiceNigth()

        LEFT JOIN tmpByBadm ON tmpByBadm.UnitId = Object_Unit.Id

    WHERE Object_Unit.DescId = zc_Object_Unit();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.08.17         * add ProvinceCity
 06.03.17         * add Address
 31.01.17         * add isMarginCategory
 16.01.17         * add isUploadBadm
 13.10.16         * add isOver
 08.04.16         *
 24.02.16         * add RepriceAuto
 21.08.14                         *
 27.06.14         *
 25.06.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Unit ('2')