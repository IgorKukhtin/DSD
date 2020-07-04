-- View: PrintForms_View

-- DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --�/�
           , CAST ('PrintMovement_Sale1' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           ,  zc_Enum_PaidKind_SecondForm()             AS PaidKindId --���
           , CAST ('PrintMovement_Sale2' AS TVarChar)
      UNION
-- ������� isDiscountPrice = True - �������� ���� �� �������
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2DiscountPrice' AS TVarChar)
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                           ON ObjectBoolean_isDiscountPrice.ObjectId = Object_Juridical.Id 
                          AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice() 
                          AND ObjectBoolean_isDiscountPrice.ValueData = TRUE
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ������� isPriceWithVAT = True - �������� ���� � ���
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2PriceWithVAT' AS TVarChar)
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id 
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT() 
                          AND ObjectBoolean_isPriceWithVAT.ValueData = TRUE
        LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND OH_JuridicalDetails.OKPO NOT IN ('2902403938') 
      UNION
-- ����
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --�/�
           , CAST ('PrintMovement_Bill' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_SecondForm()              AS PaidKindId --�
           , CAST ('PrintMovement_Bill' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_Movement_Sale()
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
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- ���������� � ���������� �������
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale'||OH_JuridicalDetails.OKPO AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30487219','32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ����-��� ��� + Ѳ����-���
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32294926' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32294926', '40720198', '32294897')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- �ϲ����� � ���, г�� ����, 
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32490244' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32490244', '41744911', '39775097')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ���� ������ ó��������� ��� + в�� ������ �.�.�.�.
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481', '34431547')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ������ ����i������� ������� ��� + ������ �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315', '39622918')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Adventis + Billa + Kray
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale35275230' AS TVarChar)
      FROM Object AS Object_Juridical
           LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
           LEFT JOIN ObjectLink AS ObjectLink_Retail
                                ON ObjectLink_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND (OH_JuridicalDetails.OKPO IN ('35275230','25288083','35231874') -- '39143745' ��������� � ��.������ ������
             OR ObjectLink_Retail.ChildObjectId IN (310862) -- ���� �������
            )
      UNION
-- Omega+��� ���(�����)
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale30982361' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30982361', '33184262')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale31929492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('31929492', '32334104', '19202597')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Furshet
      SELECT
             zc_Movement_Sale()
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
             zc_Movement_Sale()
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
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale36387249' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36387249', '36387233', '38916558', '40982829')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Objora
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale22447463' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('22447463', '37223357', '37223320')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale36003603' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36003603')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ����+����+������+�����+������ ������� ������� + ��� ������ + ������ + ������-2015 + ���� 2017 ��� + ������
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale39118745' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('39118745','39117631', '39118572', '39143745' -- ? + Գ��� + ? + ? + ?
                                      , '39118195' -- ����������
                                      , '39117799' -- ������
                                      , '41805811' -- ������
                                      , '40145541' -- ������
                                      --, '39775097' -- ������-2015
                                      , '41299013' -- �.�.�. ���
                                      , '41360805' -- ���� 2017 ���
                                      , '41201250' -- ������
                                      , '41200660' -- ������
                                      , '42599711' -- �������
                                      --, '32490244' -- �ϲ����� � ��� 
                                      --, '41744911' -- ���� ����
                                      , '42668161' -- ����� �������
                                      , '42465240' -- ����� "�������"
                                      , '43233918' -- �� ������ ������� ����� 43233918
                                       )  -- ��������� �� ��.������ ������
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- ������� 2902403938
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.06.2017' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2902403938' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('2902403938')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION

      -- ���������
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('30.11.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax' AS TVarChar)
      UNION
      -- ��������� c 01.12.2014
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.12.2014' AS TDateTime)
           , CAST ('31.12.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax1214' AS TVarChar)
      UNION
--��������� c 01.01.2015
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.01.2015' AS TDateTime)
           , CAST ('31.03.2016' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0115' AS TVarChar)
      UNION
--��������� c 01.04.2016
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.04.2016' AS TDateTime)
           , CAST ('28.02.2017' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0416' AS TVarChar)
      UNION
--��������� c 01.03.2017
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.03.2017' AS TDateTime)
           , CAST ('30.11.2018' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0317' AS TVarChar)
      UNION
--��������� c 01.12.2018
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.12.2018' AS TDateTime)
           , CAST ('01.01.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax1218' AS TVarChar)           
      UNION
--�������
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('30.11.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective' AS TVarChar)
      UNION
--�������  c 01.12.2014
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.12.2014' AS TDateTime)
           , CAST ('31.12.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective1214' AS TVarChar)
      UNION
--�������  c 01.01.2015
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.01.2015' AS TDateTime)
           , CAST ('31.03.2016' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0115' AS TVarChar)

      UNION
--�������  c 01.04.2016
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.04.2016' AS TDateTime)
           , CAST ('28.02.2017' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0416' AS TVarChar)
      UNION
--�������  c 01.03.2017
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.03.2017' AS TDateTime)
           , CAST ('30.11.2018' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0317' AS TVarChar)
      UNION
--�������  c 01.12.2018
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.12.2018' AS TDateTime)
           , CAST ('01.01.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective1218' AS TVarChar)
/*
-- ����� ����� ���������
      UNION
      SELECT
             zc_Movement_Sale()
           , CAST ('SaleTax' AS TVarChar)
           , CAST ('10.02.2014' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax_2014' AS TVarChar)
*/
-- ������������� ���� - ��������
      UNION
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnIn' AS TVarChar)
      UNION
-- Ashan + в�� ������ �.�.�.�.
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_PriceCorrective35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481', '34431547')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Metro - PriceCorrective
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_PriceCorrective32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


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

      /*UNION
-- Metro - ReturnIn
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()*/

      UNION
-- Ashan
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
-- Amstor
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


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

      UNION
-- ������������ Amstor
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315')        
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
    
      UNION
-- ������������ �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')        
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
-- ������������ �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport36003603' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36003603')        
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- ������������ ���������, ������
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport36387249' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36387249', '36387233', '38916558')        
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- ���������� ��������
      SELECT
             zc_Object_Sticker()
           , CAST ('Sticker' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintObject_Sticker' AS TVarChar)

      UNION
      -- ������ ������������� �����
      SELECT
             zc_Movement_Sale()
           , CAST ('Quality' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Quality32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')        
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

--   ORDER BY 1,2,4


       ;

ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.12.18         * PrintMovement_Quality32049199
 26.10.17         * add PrintObject_Sticker
 19.06.17         * add PrintMovement_Sale2902403938
 15.03.17         * add Tax0317, TaxCorrective0317
 01.02.16         * add PrintMovement_Transport
 21.12.15         * add PrintMovement_Sale36003603 �����
                      , PrintMovement_Sale39118745 
 18.12.15         * add PrintMovement_Sale2DiscountPrice
 28.01.15                                                        * + PrintMovement_ReturnIn32049199
 25.11.14                                                        * + new nalog forms
 23.04.14                                                        * + PrintMovement_ReturnIn32049199
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

/*
----------------
PrintMovement_Sale01074874.fr3 -- ��� ����������� ���� ������� ��-10
PrintMovement_Sale2902403938.fr3 -- ������� ����� ���������� ���
PrintMovement_Sale30487219.fr3 -- ���-������  ���
PrintMovement_Sale32516492.fr3 -- ������ ����i������� ������� ���
PrintMovement_Sale35275230.fr3 -- ������� ���
PrintMovement_Sale37910513.fr3 -- ������ ����� ��
*/

-- ����
-- SELECT * FROM PrintForms_View LEFT JOIN Object ON Object.Id = JuridicalId WHERE JuridicalId IN (SELECT JuridicalId FROM PrintForms_View GROUP BY JuridicalId, ReportType, PaidKindId, StartDate HAVING COUNT(*) > 1) ORDER BY ReportType, JuridicalId, PaidKindId, StartDate
-- SELECT * FROM PrintForms_View LEFT JOIN Object ON Object.Id = JuridicalId WHERE PrintFormName = 'PrintMovement_Sale35275230'
