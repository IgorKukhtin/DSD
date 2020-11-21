-- Function: gpGet_Object_MedicSP (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_MedicSP (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedicSP(
    IN inId          Integer,        -- Должности
    IN inSession     TVarChar        -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , AmbulantClinicSPId Integer, AmbulantClinicSPName TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_MedicSP());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_MedicSP()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           , CAST (0 as Integer)    AS PartnerMedicalId
           , CAST ('' as TVarChar)  AS PartnerMedicalName
           , CAST (0 as Integer)    AS AmbulantClinicSPId
           , CAST ('' as TVarChar)  AS AmbulantClinicSPName
           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY 
       SELECT Object_MedicSP.Id                   AS Id
            , Object_MedicSP.ObjectCode           AS Code
            , Object_MedicSP.ValueData            AS Name
            , Object_PartnerMedical.Id            AS PartnerMedicalId
            , Object_PartnerMedical.ValueData     AS PartnerMedicalName
            , Object_AmbulantClinicSP.Id          AS AmbulantClinicSPId
            , Object_AmbulantClinicSP.ValueData   AS AmbulantClinicSPName
            , Object_MedicSP.isErased             AS isErased
       FROM Object AS Object_MedicSP
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                              ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MedicSP_PartnerMedical.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_AmbulantClinicSP
                              ON ObjectLink_MedicSP_AmbulantClinicSP.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_AmbulantClinicSP.DescId = zc_ObjectLink_MedicSP_AmbulantClinicSP()
         LEFT JOIN Object AS Object_AmbulantClinicSP ON Object_AmbulantClinicSP.Id = ObjectLink_MedicSP_AmbulantClinicSP.ChildObjectId
       WHERE Object_MedicSP.Id = inId;
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.11.20                                                       *
 06.05.17         * add PartnerMedical
 14.02.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MedicSP(0,'2')