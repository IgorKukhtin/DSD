-- Function: zfCalc_RateFuelValue

DROP FUNCTION IF EXISTS zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DetermentPaymentDate(
    IN inContractConditionId Integer   , -- ��� ��������
    IN inDayCount            Integer   , -- ���� ��������
    IN inDate                TDateTime , -- ���� �� ������� ���� ��������� ������ �������� ��������
)
RETURNS TDateTime AS
$BODY$
  DECLARE vbValue TFloat;
BEGIN

     -- ���������� ���������, ��� ����������� �� 2-� ������
     RETURN (vbValue);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DetermentPaymentDate (Integer, Integer, TDateTime) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.02.14                        * 
*/
/*
-- ����
SELECT * FROM zfCalc_DetermentPaymentDate (inDistance           := 100
                                  , inAmountFuel         := 17
                                  , inColdHour           := 1
                                  , inAmountColdHour     := 17
                                  , inColdDistance       := 100
                                  , inAmountColdDistance := 17
                                  , inFuel_Ratio         := 1.3059
                                  , inRateFuelKindTax    := 0)
*/