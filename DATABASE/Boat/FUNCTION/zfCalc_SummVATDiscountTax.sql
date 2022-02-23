-- Function: ������� ����� ��� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummVATDiscountTax (TFloat, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummVATDiscountTax(
    IN inSumm          TFloat, -- ����� ��� ���
    IN inDiscountTax   TFloat, -- % ������
    IN inTaxKindValue  TFloat  -- % ���
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN zfCalc_SummWVATDiscountTax (inSumm, inDiscountTax, inTaxKindValue) - zfCalc_SummDiscountTax (inSumm, inDiscountTax);
                
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
-- SELECT * FROM zfCalc_SummVATDiscountTax (inSumm:= 100, inDiscountTax:= 0, inTaxKindValue:= 19)
