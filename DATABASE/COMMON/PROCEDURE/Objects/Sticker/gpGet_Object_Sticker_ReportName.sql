-- Function: gpGet_Object_Sticker_ReportName()

DROP FUNCTION IF EXISTS gpGet_Object_Sticker_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Sticker_ReportName (
    IN inObjectId           Integer  , -- ���� �����������
    IN inSession            TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN
       -- �������� ���� ������������ �� ����� ���������
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());


       -- ����� �����
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintObject_Sticker')
              INTO vbPrintFormName
       FROM Object AS Object_Sticker
            LEFT JOIN PrintForms_View ON PrintForms_View.DescId = Object_Sticker.DescId
       WHERE Object_Sticker.Id = inObjectId
       ;

       -- ���������
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.10.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Sticker_ReportName (inObjectId:= 1005830 , inSession:= '5'); -- ���
