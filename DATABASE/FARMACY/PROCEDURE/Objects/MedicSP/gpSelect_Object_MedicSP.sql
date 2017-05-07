-- Function: gpSelect_Object_MedicSP(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicSP(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicSP(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_MedicSP());

   RETURN QUERY 
     SELECT Object_MedicSP.Id                 AS Id
          , Object_MedicSP.ObjectCode         AS Code
          , Object_MedicSP.ValueData          AS Name

          , Object_PartnerMedical.Id          AS PartnerMedicalId
          , Object_PartnerMedical.ValueData   AS PartnerMedicalName

          , Object_MedicSP.isErased           AS isErased
     FROM Object AS Object_MedicSP
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                              ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MedicSP_PartnerMedical.ChildObjectId
     WHERE Object_MedicSP.DescId = zc_Object_MedicSP();
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MedicSP(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.05.17         * add PartnerMedical
 14.02.17         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_MedicSP('2')