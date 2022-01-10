-- Function: ������� ����� ��� ��� - ���������� �� 2-� ������

DROP FUNCTION IF EXISTS zfCalc_Summ_NoVAT (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_NoVAT(
    IN inSumm          TFloat, -- ����� � ���
    IN inTaxKindValue  TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     -- ��������� �� 2-� ������
     IF inTaxKindValue > 0
     THEN
         RETURN CAST (inSumm / (1 + COALESCE (inTaxKindValue, 0) /100) AS NUMERIC (16, 2));
     ELSE
         RETURN inSumm;
     END IF;
                
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
-- SELECT * FROM zfCalc_Summ_NoVAT (inSumm:= 119, inTaxKindValue:= 19)
