-- Function: ���������� ����� , ���� ������ ������

DROP FUNCTION IF EXISTS zfCalc_Summ_Equal (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_Equal(
    IN inSumm1          TFloat, -- 
    IN inSumm2          TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF COALESCE (inSumm1,0) <> COALESCE (inSumm2,0)
     THEN
         -- 
         RAISE EXCEPTION '������. C���� � ������ �� ������������� ����� �����.'; 
     END IF;

     RETURN COALESCE (inSumm1, 0);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.12.23         *
*/

-- ����
-- SELECT * FROM zfCalc_Summ_Equal (inSumm1:= 100, inSumm2:= 100)
