-- View: PrintForms_View

-- DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS

      SELECT CAST ('Report_Check_SP' AS TVarChar)        AS ReportType
           , CAST ('01.01.2000' AS TDateTime)            AS StartDate
           , CAST ('01.01.2200' AS TDateTime)            AS EndDate
           , CAST (0            AS Integer)              AS JuridicalId
           , CAST (Object_PartnerMedical.Id AS Integer)  AS PartnerMedicalId
           , CAST ('PrintReport_CheckSP_' || Object_PartnerMedical.Id AS TVarChar)     AS PrintFormName
      FROM Object AS Object_PartnerMedical 
      WHERE Object_PartnerMedical.DescId = zc_Object_PartnerMedical()
        AND Object_PartnerMedical.Id IN  (4474508        -- "Комунальний заклад "ДЦПМСД №1""
                                        , 4474509        -- "Комунальний заклад "ДЦПМСД №8""
                                        , 4474307        -- "Комунальний заклад "ДЦПМСД №4""
                                        , 4474556        -- "Комунальний заклад "ДЦПМСД №9""
                                        , 4212299        -- "Комунальний заклад "ДЦПМСД №11""
                                         )
      ;

ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.02.18         *
*/

-- тест
-- SELECT * FROM PrintForms_View 

/*
CREATE OR REPLACE VIEW PrintForms_View
AS

      SELECT CAST ('Report_Check_SP' AS TVarChar)        AS ReportType
           , CAST ('01.01.2000' AS TDateTime)            AS StartDate
           , CAST ('01.01.2200' AS TDateTime)            AS EndDate
           , CAST (Object_Juridical.Id AS Integer)       AS JuridicalId
           , CAST (Object_PartnerMedical.Id AS Integer)  AS PartnerMedicalId
           , CAST ('PrintReport_CheckSP_'||Object_Juridical.Id || '_' || Object_PartnerMedical.Id AS TVarChar)     AS PrintFormName
      FROM Object AS Object_Juridical
           LEFT JOIN Object AS Object_PartnerMedical 
                             ON Object_PartnerMedical.DescId = zc_Object_PartnerMedical()
                            AND ((Object_PartnerMedical.Id = 3690583 /*4474509*/ AND Object_Juridical.Id = 393052)
                              OR (Object_PartnerMedical.Id = 3690529 /*4474508*/ AND Object_Juridical.Id = 393038))
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
         AND Object_Juridical.Id IN (393052, 393038) 
      ;

ALTER TABLE PrintForms_View OWNER TO postgres;
*/