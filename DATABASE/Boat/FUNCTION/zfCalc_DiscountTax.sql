-- Function: ������� % ������ - ���������� �� 1-��� �����

DROP FUNCTION IF EXISTS zfCalc_DiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_DiscountTax(
    IN inSummDiscountTax TFloat, -- ����� �� �������
    IN inSumm            TFloat  -- ����� ��� ������
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN CAST (CASE WHEN inSumm <> 0 THEN COALESCE (inSummDiscountTax, 0.0) * 100 / inSumm ELSE 0 END AS NUMERIC (16, 1));

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
-- SELECT * FROM zfCalc_DiscountTax (inSummDiscountTax:= 100, inSumm:= 150)
