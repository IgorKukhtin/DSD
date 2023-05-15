-- Function: ������� ����� ������ - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummDiscount (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummDiscount(
    IN inSumm        TFloat, -- ����� ��� ������
    IN inDiscountTax TFloat  -- % ������
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN COALESCE (inSumm, 0) - zfCalc_SummDiscountTax (inSumm, inDiscountTax);

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
-- SELECT * FROM zfCalc_SummDiscount (inSumm:= 100, inDiscountTax:= 15)
