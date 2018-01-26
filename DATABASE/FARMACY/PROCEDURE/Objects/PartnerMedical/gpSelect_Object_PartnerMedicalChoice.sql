
DROP FUNCTION IF EXISTS gpSelect_Object_PartnerMedicalChoice(TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerMedicalChoice(
    IN inOperDate    TDateTime ,
    IN inUnitId      Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MedicFIO TVarChar
             , MedicSPId Integer, MedicSPName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartnerMedical());

     RETURN QUERY  
     WITH
         tmpData AS (SELECT DISTINCT
                            ObjectLink_Contract_Juridical.ChildObjectId  AS JuridicalId
                          , ObjectLink_PartnerMedical_Juridical.ObjectId AS PartnerMedicalId
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

                     WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitId
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       )

     SELECT Object_PartnerMedical.Id          AS Id
          , Object_PartnerMedical.ObjectCode  AS Code
          , Object_PartnerMedical.ValueData   AS Name
          
          , Object_Juridical.Id               AS JuridicalId
          , Object_Juridical.ObjectCode       AS JuridicalCode
          , Object_Juridical.ValueData        AS JuridicalName
          , ObjectString_PartnerMedical_FIO.ValueData  AS MedicFIO
         
          , 0                                 AS MedicSPId
          , '' :: TVarChar                    AS MedicSPName
          
          , Object_PartnerMedical.isErased AS isErased
     FROM tmpData
          LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.PartnerMedicalId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
   
          LEFT JOIN ObjectString AS ObjectString_PartnerMedical_FIO
                                     ON ObjectString_PartnerMedical_FIO.ObjectId = Object_PartnerMedical.Id
                                    AND ObjectString_PartnerMedical_FIO.DescId = zc_ObjectString_PartnerMedical_FIO()
   ;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.01.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartnerMedicalChoice(inOperDate :='01.12.2017' :: TDateTime, inUnitId := 183289, inSession := '2')