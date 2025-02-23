-- Function: ������� ����� �� ������� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummDiscountTax(
    IN inSumm          TFloat, -- ����� ��� ������
    IN inDiscountTax   TFloat  -- % ������
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN CAST (COALESCE (inSumm, 0.0) * (1 - COALESCE (inDiscountTax, 0.0) / 100) AS NUMERIC (16, 2));

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
-- SELECT * FROM zfCalc_SummDiscountTax (inSumm:= 100, inDiscountTax:= 15)
