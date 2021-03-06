-- Function: ������� ����� ��� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_Summ_VAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_VAT(
    IN inSumm          TFloat, -- ����� � ���
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN inSumm - zfCalc_Summ_NoVAT (inSumm, inTaxKindValue);
                
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
-- SELECT * FROM zfCalc_Summ_VAT (inSumm:= 119, inTaxKindValue:= 19)
