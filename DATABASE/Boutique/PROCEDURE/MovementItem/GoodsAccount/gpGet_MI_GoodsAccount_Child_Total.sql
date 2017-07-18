-- Function: gpGet_MI_GoodsAccount_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_GoodsAccount_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_GoodsAccount_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_GoodsAccount_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay       TFloat   , --
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains TFloat -- �������, ���
             , AmountDiff    TFloat -- �����, ���
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       SELECT gpGet.AmountRemains
            , gpGet.AmountDiff
       FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD  := inCurrencyValueUSD
                                     , inCurrencyValueEUR  := inCurrencyValueEUR
                                     , inAmountToPay       := inAmountToPay
                                     , inAmountGRN         := inAmountGRN
                                     , inAmountUSD         := inAmountUSD
                                     , inAmountEUR         := inAmountEUR
                                     , inAmountCard        := inAmountCard
                                     , inAmountDiscount    := inAmountDiscount
                                     , inSession           := inSession
                                      ) AS gpGet;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_GoodsAccount_Child_Total (inId:= 92, inMovementId:= 28, inSession:= zfCalc_UserAdmin());
