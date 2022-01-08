-- Function: ������� ����� � ��� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_SummWVAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVAT(
    IN inSumm          TFloat, -- ����� ��� ���
    IN inTaxKindValue  TFloat  -- % ���
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     RETURN CAST (inSumm * (1 + COALESCE (inTaxKindValue, 0)/100) AS NUMERIC (16, 2));
                
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.03.21                                        *
*/

-- ����
-- SELECT * FROM zfCalc_SummWVAT (inSumm:= 100, inTaxKindValue:= 16)
