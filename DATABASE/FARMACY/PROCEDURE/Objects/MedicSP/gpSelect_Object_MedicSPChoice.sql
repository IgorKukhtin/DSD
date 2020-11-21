-- Function: gpSelect_Object_MedicSPChoice(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MedicSPChoice(Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedicSPChoice(
    IN inPartnerMedicalId   Integer   ,    -- мед. учреждение
    IN inUnitId             Integer   ,
    IN inOperDate           TDateTime ,
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
     WITH
         tmpData AS (SELECT DISTINCT
                            ObjectLink_PartnerMedical_Juridical.ObjectId AS PartnerMedicalId
                     FROM ObjectLink AS ObjectLink_Unit_Juridical
                          INNER JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                                ON ObjectLink_Contract_JuridicalBasis.ChildObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                          INNER JOIN ObjectDate AS ObjectDate_Start
                                                ON ObjectDate_Start.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                               AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                               AND ObjectDate_Start.ValueData <= inOperDate
                          INNER JOIN ObjectDate AS ObjectDate_End
                                                ON ObjectDate_End.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                               AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End() 
                                               AND ObjectDate_End.ValueData >= inOperDate
                                                                                
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                        
                          INNER JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                                ON ObjectLink_PartnerMedical_Juridical.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId 
                                               AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                                               AND (ObjectLink_PartnerMedical_Juridical.ObjectId = inPartnerMedicalId OR inPartnerMedicalId = 0)

                     WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                  UNION 
                     SELECT DISTINCT
                            ObjectLink_PartnerMedical_Department.ObjectId      AS PartnerMedicalId
                     FROM ObjectLink AS ObjectLink_Unit_Juridical
                          INNER JOIN ObjectLink AS ObjectLink_Contract_JuridicalBasis
                                                ON ObjectLink_Contract_JuridicalBasis.ChildObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Contract_JuridicalBasis.DescId = zc_ObjectLink_Contract_JuridicalBasis()

                          INNER JOIN ObjectDate AS ObjectDate_Start
                                                ON ObjectDate_Start.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                               AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
                                               AND ObjectDate_Start.ValueData <= inOperDate
                          INNER JOIN ObjectDate AS ObjectDate_End
                                                ON ObjectDate_End.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                               AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End() 
                                               AND ObjectDate_End.ValueData >= inOperDate
                                                                                
                          LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                               ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_JuridicalBasis.ObjectId
                                              AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                          -- привязіваем по департаменту мед центра
                          INNER JOIN ObjectLink AS ObjectLink_PartnerMedical_Department
                                                ON ObjectLink_PartnerMedical_Department.ChildObjectId = ObjectLink_Contract_Juridical.ChildObjectId 
                                               AND ObjectLink_PartnerMedical_Department.DescId = zc_ObjectLink_PartnerMedical_Department()
                                               AND (ObjectLink_PartnerMedical_Department.ObjectId = inPartnerMedicalId OR inPartnerMedicalId = 0)
         
                     WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )

     SELECT Object_MedicSP.Id                 AS Id
          , Object_MedicSP.ObjectCode         AS Code
          , Object_MedicSP.ValueData          AS Name

          , Object_PartnerMedical.Id          AS PartnerMedicalId
          , Object_PartnerMedical.ValueData   AS PartnerMedicalName

          , Object_AmbulantClinicSP.Id        AS AmbulantClinicSPId
          , Object_AmbulantClinicSP.ValueData AS AmbulantClinicSPName

          , Object_MedicSP.isErased           AS isErased
     FROM Object AS Object_MedicSP
          INNER JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                                ON ObjectLink_MedicSP_PartnerMedical.ObjectId = Object_MedicSP.Id
                               AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()

          INNER JOIN tmpData ON tmpData.PartnerMedicalId = ObjectLink_MedicSP_PartnerMedical.ChildObjectId

          LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_MedicSP_PartnerMedical.ChildObjectId

         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_AmbulantClinicSP
                              ON ObjectLink_MedicSP_AmbulantClinicSP.ObjectId = Object_MedicSP.Id
                             AND ObjectLink_MedicSP_AmbulantClinicSP.DescId = zc_ObjectLink_MedicSP_AmbulantClinicSP()

         LEFT JOIN Object AS Object_AmbulantClinicSP ON Object_AmbulantClinicSP.Id = ObjectLink_MedicSP_AmbulantClinicSP.ChildObjectId

     WHERE Object_MedicSP.DescId = zc_Object_MedicSP()
     
/*     FROM tmpData
         LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.PartnerMedicalId
         
         LEFT JOIN ObjectLink AS ObjectLink_MedicSP_PartnerMedical
                              ON ObjectLink_MedicSP_PartnerMedical.ChildObjectId = Object_PartnerMedical.Id
                             AND ObjectLink_MedicSP_PartnerMedical.DescId = zc_ObjectLink_MedicSP_PartnerMedical()
         LEFT JOIN Object AS Object_MedicSP ON Object_MedicSP.Id = ObjectLink_MedicSP_PartnerMedical.ObjectId
 */
     ;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.11.20                                                       *
 03.01.19         *
 25.01.18         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_MedicSPChoice(inPartnerMedicalId :=4212299 , inUnitId := 183292, inOperDate :='02.01.2019' :: TDateTime ,inSession:= '2' ::TVarChar)