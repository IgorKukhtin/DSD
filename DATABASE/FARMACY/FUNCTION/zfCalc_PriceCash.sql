-- Function: zfCalc_PriceCash

DROP FUNCTION IF EXISTS zfCalc_PriceCash (TFloat, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_PriceCash(
    IN inPrice    TFloat   , -- 
    IN inNoRound  Boolean    -- 
)
RETURNS TFloat
AS
$BODY$
  DECLARE vbResult TFloat;
BEGIN

    vbResult := inPrice;

    -- ���������
    IF COALESCE (inNoRound, False) = False AND inPrice > 10.00
    THEN
      vbResult := TRUNC(inPrice);
      IF inPrice - TRUNC(inPrice) > 0.60
      THEN
        vbResult := vbResult + 1;
      ELSEIF inPrice - TRUNC(inPrice) > 0.25
      THEN
        vbResult := vbResult + 0.5;      
      END IF; 
    END IF;
    
    RETURN vbResult;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.07.21                                                       *
*/

-- ����
-- 
SELECT zfCalc_PriceCash (10.601, False)