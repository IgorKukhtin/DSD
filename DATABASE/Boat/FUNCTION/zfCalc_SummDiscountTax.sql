-- Function: ������� ����� �� ������� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummDiscountTax(
    IN inSumm          TFloat, -- �����
    IN inDiscountTax   TFloat  -- % ������
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN inSumm - zfCalc_SummDiscount (inSumm, inDiscountTax);
                
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
