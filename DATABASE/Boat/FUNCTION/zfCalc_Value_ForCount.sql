-- Function: �������

DROP FUNCTION IF EXISTS zfCalc_Value_ForCount (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Value_ForCount(
    IN inValue     TFloat , -- 
    IN inForCount  TFloat   -- 
)
RETURNS NUMERIC (16, 8)
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN COALESCE (inValue, 0) / CASE WHEN inForCount > 0 THEN inForCount ELSE 1 END;
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.21                                        *
*/

-- ����
-- SELECT * FROM zfCalc_Value_ForCount (inValue:= 1.2345, inForCount:= 1000)
