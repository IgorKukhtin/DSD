-- Function: ������� ����� � ��� - ���������� �� 4-� ������

DROP FUNCTION IF EXISTS zfCalc_SummWVAT_4 (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_SummWVAT_4(
    IN inSumm          TFloat, -- ����� ��� ���
    IN inTaxKindValue  TFloat  -- % ���
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF inTaxKindValue > 0
     THEN
         -- ��������� �� 2-� ������
         RETURN CAST (COALESCE (inSumm, 0) * (1 + COALESCE (inTaxKindValue, 0)/100) AS NUMERIC (16, 4));
     ELSE
         RETURN COALESCE (inSumm, 0);
     END IF;
                
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
-- SELECT * FROM zfCalc_SummWVAT_4 (inSumm:= 1.12, inTaxKindValue:= 19)
