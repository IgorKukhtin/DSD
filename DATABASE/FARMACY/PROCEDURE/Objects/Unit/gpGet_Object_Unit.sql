-- Function: gpGet_Object_Unit()

DROP FUNCTION IF EXISTS gpGet_Object_Unit(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               ParentId Integer, ParentName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, 
               MarginCategoryId Integer, MarginCategoryName TVarChar,
               isLeaf boolean, 
               TaxService TFloat, TaxServiceNigth TFloat,
               StartServiceNigth TDateTime, EndServiceNigth TDateTime,
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
           
           , CAST (0 as Integer)   AS ParentId
           , CAST ('' as TVarChar) AS ParentName 

           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName
           
           , CAST (0 as Integer)   AS MarginCategoryId
           , CAST ('' as TVarChar) AS MarginCategoryName
           , false                 AS isLeaf
           , CAST (0 as TFloat)    AS TaxService
           , CAST (0 as TFloat)    AS TaxServiceNigth
           
           , CAST (Null as TDateTime) AS StartServiceNigth
           , CAST (Null as TDateTime) AS EndServiceNigth

           , False                 AS isRepriceAuto
;
   ELSE
       RETURN QUERY 
      
    SELECT 
        Object_Unit.Id                                     AS Id
      , Object_Unit.ObjectCode                             AS Code
      , Object_Unit.ValueData                              AS Name

      , Object_Parent.Id                                   AS ParentId
      , Object_Parent.ValueData                            AS ParentName

      , Object_Juridical.Id                                AS JuridicalId
      , Object_Juridical.ValueData                         AS JuridicalName

      , Object_MarginCategory.Id                           AS MarginCategoryId
      , Object_MarginCategory.ValueData                    AS MarginCategoryName
      , ObjectBoolean_isLeaf.ValueData                     AS isLeaf

      , ObjectFloat_TaxService.ValueData                     AS TaxService
      , ObjectFloat_TaxServiceNigth.ValueData                AS TaxServiceNigth

      , ObjectDate_StartServiceNigth.ValueData               AS StartServiceNigth
      , ObjectDate_EndServiceNigth.ValueData                 AS EndServiceNigth

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
        
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isLeaf 
                                ON ObjectBoolean_isLeaf.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_isLeaf.DescId = zc_ObjectBoolean_isLeaf()

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

    WHERE Object_Unit.Id = inId;

   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Unit (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.04.16         *
 24.02.16         * 
 27.06.14         *
 11.06.13                        *

*/

-- тест
-- SELECT * FROM gpSelect_Unit('2')