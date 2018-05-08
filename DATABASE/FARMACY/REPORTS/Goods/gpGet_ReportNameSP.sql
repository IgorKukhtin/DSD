-- Function: gpGet_ReportNameSP()

DROP FUNCTION IF EXISTS gpGet_ReportNameSP (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_ReportNameSP (
    IN inJuridicalId         Integer  , -- 
    IN inPartnerMedicalId    Integer  , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN

       -- ��������� 
       -- �� ������� �� ������ ��.����
       SELECT COALESCE (PrintForms_View.PrintFormName, '����� �� �������� ���.�������')
              INTO vbPrintFormName
       FROM PrintForms_View
       WHERE PrintForms_View.PartnerMedicalId = inPartnerMedicalId
         AND PrintForms_View.ReportType = 'Report_Check_SP';

     RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 07.02.18         *
*/

-- ����
-- SELECT * FROM gpGet_ReportNameSP (inJuridicalId:= 0, inPartnerMedicalId:= 3690583, inSession:= '5'); -- test
-- SELECT * FROM gpGet_ReportNameSP (inJuridicalId:= 0, inPartnerMedicalId:= 4474508, inSession:= '5'); -- ���.