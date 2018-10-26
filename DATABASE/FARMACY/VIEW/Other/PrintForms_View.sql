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
        AND Object_PartnerMedical.Id IN  (4474508        -- "����������� ������ "������ �1""
                                        , 4474509        -- "����������� ������ "������ �8""
                                        , 4474307        -- "����������� ������ "������ �4""
                                        , 4474556        -- "����������� ������ "������ �9""
                                        , 4212299        -- "����������� ������ "������ �11""
                                        , 4474558        -- ��� ��������� ����� ���� "����� N3"
                                         )

    UNION
      -- ���. ���������� ��� ������������� ��������
      SELECT CAST ('Report_Check_SP' AS TVarChar)        AS ReportType
           , CAST ('01.01.2000' AS TDateTime)            AS StartDate
           , CAST ('01.01.2200' AS TDateTime)            AS EndDate
           , CAST (0            AS Integer)              AS JuridicalId
           , CAST (Object_Department.Id AS Integer)      AS PartnerMedicalId
           , CAST ('PrintReport_CheckSP_' || Object_Department.Id AS TVarChar)     AS PrintFormName
      FROM Object AS Object_Department 
      WHERE Object_Department.DescId = zc_Object_Juridical()
        AND Object_Department.Id IN  (8513005        -- "��������� ������� ������'� ���'������ ����� ����"
                                    , 9102200        -- "³��� ������� ������'� ������������� ����� ����"
                                    , 9089478        -- "³��� ������� ������'� ͳ��������� ����� ����"
                                    , 9126996        -- "����������� ������� ������� ��������� ���������� ����� ���� "
                                     )
      ;

ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.10.18         *
 07.02.18         *
*/

-- ����
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