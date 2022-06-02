-- Function: gpGet_Movement_CashSend_exit()

DROP FUNCTION IF EXISTS gpGet_Movement_CashSend_exit (Integer, TFloat, TFloat, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_CashSend_exit(
    IN inMovementId        Integer  , -- ���� ���������
    IN inCashId_from       Integer   , -- ����� (������) 
    IN inCashId_to         Integer   , -- ����� (������) 
    IN inCurrencyValue     TFloat    , -- ����
    IN inParValue          TFloat    , -- �������
    IN inAmountOut         TFloat    , -- ����� (������)
    IN inAmountIn          TFloat    , -- ����� (������)
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountIn TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_CashSend());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY 
       SELECT inAmountOut AS AmountIn
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.06.22         * 
*/

-- ����
-- SELECT * FROM gpGet_Movement_CashSend_exit(inMovementId := 608 , inCashId_from := 608 , inCashId_to := 0 , inCurrencyValue := 0, inParValue := 0, inAmountOut := 555, inAmountIn := 0,  inSession := '5');
