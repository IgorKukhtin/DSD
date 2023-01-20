-- Function: ������� % �������

DROP FUNCTION IF EXISTS zfCalc_Value_VAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Value_VAT(
    IN inSummFrom  TFloat, -- 100
    IN inSummTo    TFloat  -- 100 + X %
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN CASE WHEN COALESCE (inSummFrom, 0) = 0 AND COALESCE (inSummTo, 0) > 0 THEN  100
                 WHEN COALESCE (inSummFrom, 0) = 0 AND COALESCE (inSummTo, 0) < 0 THEN -100
                 WHEN COALESCE (inSummFrom, 0) = 0 AND COALESCE (inSummTo, 0) = 0 THEN    0
                 ELSE COALESCE (inSummTo, 0) * 100 / inSummFrom - 100
            END;
                
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
-- SELECT * FROM zfCalc_Value_VAT (inSummFrom:= 100, inSummTo:= 120)
