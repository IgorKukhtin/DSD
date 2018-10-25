-- Function: gpGet_Object_PartnerMedical()

DROP FUNCTION IF EXISTS gpGet_Object_PartnerMedical(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PartnerMedical(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , DepartmentId Integer, DepartmentName TVarChar
             , MedicFIO TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_PartnerMedical());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_PartnerMedical()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (0 as Integer)    AS DepartmentId
           , CAST ('' as TVarChar)  AS DepartmentName

           , CAST ('' as TVarChar)  AS MedicFIO

           , CAST (NULL AS Boolean) AS isErased
;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_PartnerMedical.Id          AS Id
           , Object_PartnerMedical.ObjectCode  AS Code
           , Object_PartnerMedical.ValueData   AS Name
           
           , Object_Juridical.Id               AS JuridicalId
           , Object_Juridical.ObjectCode       AS JuridicalCode
           , Object_Juridical.ValueData        AS JuridicalName

           , Object_Department.Id              AS DepartmentId
           , Object_Department.ValueData       AS DepartmentName

           , ObjectString_PartnerMedical_FIO.ValueData  AS MedicFIO

           , Object_PartnerMedical.isErased    AS isErased
           
       FROM Object AS Object_PartnerMedical
       
           LEFT JOIN ObjectString AS ObjectString_PartnerMedical_FIO
                                  ON ObjectString_PartnerMedical_FIO.ObjectId = Object_PartnerMedical.Id
                                 AND ObjectString_PartnerMedical_FIO.DescId = zc_ObjectString_PartnerMedical_FIO()   

           LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id 
                               AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PartnerMedical_Juridical.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Department 
                                ON ObjectLink_PartnerMedical_Department.ObjectId = Object_PartnerMedical.Id 
                               AND ObjectLink_PartnerMedical_Department.DescId = zc_ObjectLink_PartnerMedical_Department()
           LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_PartnerMedical_Department.ChildObjectId      

       WHERE Object_PartnerMedical.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PartnerMedical(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.18         *
 16.02.17         * FIO
 22.12.16         * 

*/

-- тест
-- SELECT * FROM gpGet_Object_PartnerMedical (2, '')
