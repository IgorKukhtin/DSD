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
                                        , 4474558        -- КНП Кам’янської міської ради "ЦПМСД N3"
                                         )

    UNION
      -- доп. соглашения для департаментов здоровья
      SELECT CAST ('Report_Check_SP' AS TVarChar)        AS ReportType
           , CAST ('01.01.2000' AS TDateTime)            AS StartDate
           , CAST ('01.01.2200' AS TDateTime)            AS EndDate
           , CAST (0            AS Integer)              AS JuridicalId
           , CAST (Object_Department.Id AS Integer)      AS PartnerMedicalId
           , CAST ('PrintReport_CheckSP_' || Object_Department.Id AS TVarChar)     AS PrintFormName
      FROM Object AS Object_Department 
      WHERE Object_Department.DescId = zc_Object_Juridical()
        AND Object_Department.Id IN  (8513005        -- "Управління охорони здоров'я Кам'янської міської ради"
                                    , 9102200        -- "Відділ охорони здоров'я Павлоградської міської ради"
                                    , 9089478        -- "Відділ охорони здоров'я Нікопольскої міської ради"
                                    , 9126996        -- "Департамент охорони здоров’я населення Дніпровської міської ради "
                                     )
      ;

ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.18         *
 07.02.18         *
*/

-- тест
-- SELECT * FROM PrintForms_View 

--SELECT * FROM Object WHERE Object.DescId = zc_Object_Juridical() ;

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
--select * from gpGet_ReportNameSP(inJuridicalId := 393054 , inPartnerMedicalId := 4474558 ,  inSession := '3');