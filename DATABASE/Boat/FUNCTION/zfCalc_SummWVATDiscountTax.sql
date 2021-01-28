-- Function: ������� ����� �� ������� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummWVATDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVATDiscountTax(
    IN inSumm          TFloat, -- �����
    IN inDiscountTax   TFloat, -- % ������
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN CAST (zfCalc_SummDiscountTax (inSumm, inDiscountTax) * (1 + inTaxKindValue/100) AS NUMERIC (16, 2));
                
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
-- SELECT * FROM zfCalc_SummWVATDiscountTax (inSumm:= 100, inDiscountTax:= 0, inTaxKindValue:= 16)
