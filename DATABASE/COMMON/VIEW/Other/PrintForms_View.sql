-- View: PrintForms_View

DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS
      SELECT
             zc_movement_sale()                         AS DescId
           , CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --�/�
           , CAST ('PrintMovement_Sale1' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           ,  zc_Enum_PaidKind_SecondForm()             AS PaidKindId --���
           , CAST ('PrintMovement_Sale2' AS TVarChar)
      UNION
-- ����
      SELECT
             zc_movement_sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --�/�
           , CAST ('PrintMovement_Bill' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_movement_sale()
           , CAST ('Bill' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- �/�
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Bill01074874' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('01074874','23193668','01074791','25774961','01074302','01074064',
                                        '01073981','26139824','01074874','24755803','04791599','01073946','01074741','25927436')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION

--���� � ������������ ���� �������� ����� ����� ��������� ������, � � ���������� ��������� EndDate �� StartDate ���� ������

-- ��������� ������ ��� ������������ � �������������� ������� ���������
-- � ����� ������ �� ����
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- ���������� � ���������� �������
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale'||OH_JuridicalDetails.OKPO AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30487219','32294926','32516492','35442481','32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Adventis + Billa + Kray
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale35275230' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35275230','25288083','35231874')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Omega_Tavr
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale30982361' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30982361','32334104','19202597')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Furshet
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale37910513' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('37910513','37910542')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ��
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale01074874' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('01074874','23193668'
                                      , '01074791','25774961','01074302','01074064','01073981','26139824'
                                      , '01074874','24755803','04791599','01073946','01074741','25927436'
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- FM
      SELECT
             zc_movement_sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale36387249' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36387249','36387233')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION

--���������
      SELECT
             zc_movement_sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.02.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax' AS TVarChar)
      UNION
--�������
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.02.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective' AS TVarChar)

/*
-- ����� ����� ���������
      UNION
      SELECT
             zc_movement_sale()
           , CAST ('SaleTax' AS TVarChar)
           , CAST ('10.02.2014' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax_2014' AS TVarChar)
*/
-- �������� �� ��� ��������
      UNION
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnIn' AS TVarChar)
-- �������� ������� ��������
      UNION
      SELECT
             zc_movement_returnout()
           , CAST ('ReturnOut' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnOut' AS TVarChar)

-- ���������� �� ������������ ����
      UNION
      SELECT
             zc_Movement_ProfitLossService()
           , CAST ('ProfitLossService' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ProfitLossService' AS TVarChar)


--       ORDER BY 1,2,4

       ;



ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.04.14                                                        * + Bill
 03.04.14                                                        * + Bill
 02.04.14                                                        * + Adventis + Billa + Kray
 27.02.14                                                        * + Tax
 26.02.14                                                        * + FM, Metro
 25.02.14                                                        * + OKPO
 24.02.14                                                        * + fix milti OKPO
 18.02.14                                                        * + OKPO
 17.02.14                                                        * + ProfitLossService
 10.02.14                                                        * + TaxCorrective, ReturnOut
 06.02.14                                                        * + ReturnIn
 05.02.14                                                        *
*/

-- ����
-- SELECT * FROM PrintForms_View