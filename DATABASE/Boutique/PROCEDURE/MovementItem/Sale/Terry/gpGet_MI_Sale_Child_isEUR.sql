-- Function: gpGet_MI_Sale_Child_isEUR()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isEUR (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isEUR(
    IN inIsEUR             Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- ����� � ������
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains TFloat
             , AmountChange  TFloat
             , AmountEUR     TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountEUR TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF inIsEUR THEN
         IF inAmountEUR = 0 THEN
         vbAmountEUR := CAST (CASE WHEN COALESCE(inCurrencyValueEUR,1) <> 0 
                                   THEN (inAmount - (COALESCE (inAmountGRN,0)
                                                + (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1)) 
                                                +  COALESCE (inAmountCard,0) 
                                                +  COALESCE (inAmountDiscount,0)))
                                         /  COALESCE(inCurrencyValueEUR,1)
                                   ELSE 0
                              END AS NUMERIC (16, 0)) ;
         ELSE vbAmountEUR := inAmountEUR;
         END IF;
     ELSE 
         vbAmountEUR := 0;
     END IF;

         -- ���������
         RETURN QUERY 
          SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(inAmountDiscount,0) ) > 0 
                      THEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(inAmountDiscount,0) )
                      ELSE 0
                 END                                            ::TFloat AS AmountRemains          
               , CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(inAmountDiscount,0) ) < 0 
                      THEN (inAmount - ( COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(vbAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(inAmountDiscount,0) )) * (-1)
                      ELSE 0
                 END                                            ::TFloat AS AmountChange
               , vbAmountEUR                                    ::TFloat AS AmountEUR
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
-- SELECT * FROM gpGet_MI_Sale_Child_isEUR(inIsEUR := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountCard := 0 , inAmountDiscount := 0.4 ,  inSession := '2');
