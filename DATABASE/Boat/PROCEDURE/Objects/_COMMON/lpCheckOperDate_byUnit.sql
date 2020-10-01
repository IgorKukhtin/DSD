-- Function: lpCheckOperDate_byUnit()

DROP FUNCTION IF EXISTS lpCheckOperDate_byUnit (Integer, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpCheckOperDate_byUnit (
    IN inUnitId_by Integer  , -- ������������� ��� User
    IN inOperDate  TDateTime, -- ���� ���������
    IN inUserId    Integer
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     -- �������� - ���� - !!!������!!! ��� ������������� ��� User
     IF inUnitId_by > 0 AND inOperDate < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '17 HOUR')
     -- IF inUnitId_by > 0 AND inOperDate < DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '1 HOUR')
     THEN
         RAISE EXCEPTION '������.��� <%> ��������� ������ �������� ������ � <%>', lfGet_Object_ValueData_sh (inUnitId_by), zfConvert_DateToString (DATE_TRUNC ('DAY', CURRENT_TIMESTAMP - INTERVAL '17 HOUR'));
     END IF;


END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.03.18                                        *
*/

-- ����
-- SELECT * FROM lpCheckOperDate_byUnit (inUnitId_by:= 1525, inOperDate:= CURRENT_DATE, inUserId:= zfCalc_UserAdmin() :: Integer)
