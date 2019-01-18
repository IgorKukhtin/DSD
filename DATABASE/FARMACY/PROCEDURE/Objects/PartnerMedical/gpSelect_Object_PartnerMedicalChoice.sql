
DROP FUNCTION IF EXISTS gpSelect_Object_PartnerMedicalChoice(TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PartnerMedicalChoice(
    IN inOperDate    TDateTime ,
    IN inUnitId      Integer   ,
    IN inSPKindId    Integer   ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , MedicFIO TVarChar
             , MedicSPId Integer, MedicSPName TVarChar
             , DepartmentId Integer, DepartmentName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_PartnerMedical());
IF COALESCE (inSPKindId, 0) <> 4823010 
    THEN
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
                  UNION 
                     SELECT DISTINCT
                            ObjectLink_PartnerMedical_Juridical.ChildObjectId  AS JuridicalId
                          , ObjectLink_PartnerMedical_Department.ObjectId      AS PartnerMedicalId
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
                          --
                          LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                                               ON ObjectLink_PartnerMedical_Juridical.ObjectId = ObjectLink_PartnerMedical_Department.ObjectId 
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

          , Object_Department.Id              AS DepartmentId
          , Object_Department.ValueData       AS DepartmentName
          
          , Object_PartnerMedical.isErased AS isErased
     FROM tmpData
          LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = tmpData.PartnerMedicalId
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpData.JuridicalId
   
          LEFT JOIN ObjectString AS ObjectString_PartnerMedical_FIO
                                 ON ObjectString_PartnerMedical_FIO.ObjectId = Object_PartnerMedical.Id
                                AND ObjectString_PartnerMedical_FIO.DescId = zc_ObjectString_PartnerMedical_FIO()

          LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Department
                               ON ObjectLink_PartnerMedical_Department.ObjectId = Object_PartnerMedical.Id
                              AND ObjectLink_PartnerMedical_Department.DescId = zc_ObjectLink_PartnerMedical_Department()
          LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_PartnerMedical_Department.ChildObjectId;

   -- если выбран соцпроект 1303
    ELSE
RETURN QUERY
     SELECT Object_PartnerMedical.Id          AS Id
          , Object_PartnerMedical.ObjectCode  AS Code
          , Object_PartnerMedical.ValueData   AS Name
          
          , Object_Juridical.Id               AS JuridicalId
          , Object_Juridical.ObjectCode       AS JuridicalCode
          , Object_Juridical.ValueData        AS JuridicalName
          , ObjectString_PartnerMedical_FIO.ValueData  AS MedicFIO
         
          , 0                                 AS MedicSPId
          , '' :: TVarChar                    AS MedicSPName

          , Object_Department.Id              AS DepartmentId
          , Object_Department.ValueData       AS DepartmentName
          
          , Object_PartnerMedical.isErased AS isErased
     FROM ObjectLink AS ObjectLink_Unit_PartnerMedical
     
          LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId
          
          LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                               ON ObjectLink_PartnerMedical_Juridical.ObjectId = Object_PartnerMedical.Id
                              AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_PartnerMedical_Juridical.ChildObjectId
   
          LEFT JOIN ObjectString AS ObjectString_PartnerMedical_FIO
                                 ON ObjectString_PartnerMedical_FIO.ObjectId = Object_PartnerMedical.Id
                                AND ObjectString_PartnerMedical_FIO.DescId = zc_ObjectString_PartnerMedical_FIO()

          LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Department
                               ON ObjectLink_PartnerMedical_Department.ObjectId = Object_PartnerMedical.Id
                              AND ObjectLink_PartnerMedical_Department.DescId = zc_ObjectLink_PartnerMedical_Department()
          LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_PartnerMedical_Department.ChildObjectId
     WHERE ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
       AND ObjectLink_Unit_PartnerMedical.ObjectId = inUnitId;
    END IF;

    
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.01.19         * inSPKindId
 02.01.19         * плюс выборка по департаменту
 24.10.18         *
 25.01.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_PartnerMedicalChoice(inOperDate :='02.01.2019' :: TDateTime, inUnitId := 183289, inSPKindId:= 4823010, inSession := '2')
-- SELECT * FROM gpSelect_Object_PartnerMedicalChoice(inOperDate :='02.01.2019' :: TDateTime, inUnitId := 377595, inSPKindId:= 48230101 , inSession := '2')
