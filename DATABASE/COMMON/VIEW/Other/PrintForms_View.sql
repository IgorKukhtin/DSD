-- View: PrintForms_View

DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS
      SELECT
             CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS PartnerId
           , CAST ('PrintMovement_Sale' AS TVarChar)    AS PrintFormName
      UNION
/*
--���� � ������������ ���� �������� ����� ����� ��������� ��� ������, � � ���������� ��������� EndDate �� StartDate ���� ������
      SELECT
             CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2015' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS PartnerId
           , CAST ('PrintMovement_Sale_2015' AS TVarChar)    AS PrintFormName
      UNION
*/
-- ��������� ������ ��� ������������ � �������������� ������� ���������
      SELECT
             CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (17661 AS INTEGER)                         -- ����� C&C
           , CAST ('PrintMovement_SaleMetro' AS TVarChar)
      UNION
--��������� ���� ���������� ��� ����
      SELECT
             CAST ('SaleTax' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('09.02.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax' AS TVarChar)

-- ����� ����� ���������
      UNION
      SELECT
             CAST ('SaleTax' AS TVarChar)
           , CAST ('10.02.2014' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax_2014' AS TVarChar)


       ;



ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.

 05.02.14                                                        *
*/

-- ����
-- SELECT * FROM PrintForms_View