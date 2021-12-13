-- Function: gpSelect_Object_MedicSPIC(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicSPIC(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicSPIC(
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PartnerMedicalId Integer, PartnerMedicalName TVarChar
             , AmbulantClinicSPId Integer, AmbulantClinicSPName TVarChar
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

          , Object_AmbulantClinicSP.Id          AS AmbulantClinicSPId
          , Object_AmbulantClinicSP.ValueData   AS AmbulantClinicSPName

          , Object_MedicSP.isErased           AS isErased
     FROM Object AS Object_MedicSP
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                              ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MedicSP_PartnerMedical.ChildObjectId
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_AmbulantClinicSP
                              ON ObjectLink_MedicSP_AmbulantClinicSP.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_AmbulantClinicSP.DescId = zc_ObjectLink_MedicSP_AmbulantClinicSP()
         LEFT JOIN Object AS Object_AmbulantClinicSP ON Object_AmbulantClinicSP.Id = ObjectLink_MedicSP_AmbulantClinicSP.ChildObjectId
     WHERE Object_MedicSP.DescId = zc_Object_MedicSP()
       AND COALESCE(ObjectLink_MedicSP_PartnerMedical.ChildObjectId, 0) = 0;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.12.21                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_Object_MedicSPChoice(inPartnerMedicalId :=4212299 , inUnitId := 183292, inOperDate :='02.01.2019' :: TDateTime ,inSession:= '2' ::TVarChar)

select * from gpSelect_Object_MedicSPIC(inSession := '3');