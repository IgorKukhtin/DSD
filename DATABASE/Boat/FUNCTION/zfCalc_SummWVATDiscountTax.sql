-- Function: ������� ����� � ��� � �� ������� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummWVATDiscountTax (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVATDiscountTax(
    IN inSumm          TFloat, -- ����� ��� ���
    IN inDiscountTax   TFloat, -- % ������
    IN inTaxKindValue  TFloat  -- % ���
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 4-� ������
     RETURN CAST (zfCalc_SummWVAT (zfCalc_SummDiscountTax (inSumm, inDiscountTax), inTaxKindValue) AS NUMERIC (16, 4));
                
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
