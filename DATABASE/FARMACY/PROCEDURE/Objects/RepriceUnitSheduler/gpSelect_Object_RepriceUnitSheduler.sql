-- Function: gpSelect_Object_RepriceUnitSheduler()

DROP FUNCTION IF EXISTS gpSelect_Object_RepriceUnitSheduler(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RepriceUnitSheduler(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar

             , PercentDifference Integer
             , VAT20 Boolean
             , PercentRepriceMax Integer
             , PercentRepriceMin Integer
             , EqualRepriceMax Integer
             , EqualRepriceMin Integer
             , DataStartLast TDateTime
             , isErased boolean) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());

   RETURN QUERY
       SELECT
             Object_RepriceUnitSheduler.Id                    AS Id
           , Object_RepriceUnitSheduler.ObjectCode            AS Code
           , Object_RepriceUnitSheduler.ValueData             AS Name
           , Object_Juridical.Id                              AS JuridicalId
           , Object_Juridical.ObjectCode                      AS JuridicalCode
           , Object_Juridical.ValueData                       AS JuridicalName
           , ObjectFloat_PercentDifference.ValueData::Integer AS PercentDifference
           , ObjectBoolean_VAT20.ValueData                    AS VAT20
           , ObjectFloat_PercentRepriceMax.ValueData::Integer AS PercentRepriceMax
           , ObjectFloat_PercentRepriceMin.ValueData::Integer AS PercentRepriceMin
           , ObjectFloat_EqualRepriceMax.ValueData::Integer   AS EqualRepriceMax
           , ObjectFloat_EqualRepriceMin.ValueData::Integer   AS EqualRepriceMin
           , ObjectDate_DataStartLast.ValueData               AS DataStartLast
           , Object_RepriceUnitSheduler.isErased              AS isErased

       FROM Object AS Object_RepriceUnitSheduler
           INNER JOIN ObjectLink AS ObjectLink_Juridical
                                 ON ObjectLink_Juridical.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Juridical.DescId = zc_ObjectLink_RepriceUnitSheduler_Juridical()
           INNER JOIN Object AS Object_Juridical
                             ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

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
 22.10.18        *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RepriceUnitSheduler ('3')