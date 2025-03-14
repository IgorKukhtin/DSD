-- Function: gpGet_MI_Sale_Child_isGRN()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isGRN(
    IN inIsGRN             Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , --
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains TFloat
             , AmountChange  TFloat
             , AmountGRN     TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountGRN TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsGRN = TRUE THEN
         IF inAmountGRN = 0 THEN
         vbAmountGRN := (inAmount - ( (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE (inAmountCard,0) 
                                    +  COALESCE (inAmountDiscount,0)) );
          ELSE vbAmountGRN := inAmountGRN;
          END IF;
     ELSE 
         vbAmountGRN := 0;
     END IF;

         -- ���������
         RETURN QUERY 
          SELECT CASE WHEN inAmount - (  COALESCE(vbAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(inAmountDiscount,0) ) > 0 
                      THEN inAmount - (  COALESCE(vbAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(inAmountDiscount,0) )
                      ELSE 0
                 END                                            ::TFloat AS AmountRemains          
               , CASE WHEN inAmount - (  COALESCE(vbAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(inAmountDiscount,0) ) < 0 
                      THEN (inAmount - ( COALESCE(vbAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(inAmountDiscount,0) )) * (-1)
                      ELSE 0
                 END                                            ::TFloat AS AmountChange
               , vbAmountGRN                                    ::TFloat AS AmountGRN
                ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 29.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_isGRN(inIsGRN := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 100 ,inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount := 0.4 ,  inSession := '2');
