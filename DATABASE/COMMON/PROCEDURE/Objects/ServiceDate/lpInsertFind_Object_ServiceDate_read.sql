-- Function: lpInsertFind_Object_ServiceDate_read (TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ServiceDate_read (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ServiceDate_read(
    IN inOperDate  TDateTime -- ����� ����������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbServiceDateId Integer;
   DECLARE vbOperDate_str   TVarChar;
BEGIN

     -- ������ ��������
     IF COALESCE (inOperDate, zc_DateEnd()) = zc_DateEnd() OR COALESCE (inOperDate, zc_DateStart()) = zc_DateStart()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- ������ - 1-�� ����� ������
         inOperDate:= DATE_TRUNC ('MONTH', inOperDate);
         -- ����������� � �������
         vbOperDate_str:= TO_CHAR (inOperDate, 'YYYY MONTH');
     END IF;

     -- ������� �� ��-��
     vbServiceDateId:= (SELECT Object.Id
                         FROM Object
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_ServiceDate()
                        );

     -- ���������� ��������
     RETURN (vbServiceDateId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.25                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= NULL);
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= '31.01.2013');
