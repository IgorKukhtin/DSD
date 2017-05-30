-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isDiscount (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isDiscount(
    IN inisDiscount        Boolean  , --
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmount            TFloat   , -- ����� � ������
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains TFloat
             , AmountChange  TFloat
             , AmountDiscount TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbSumm TFloat;
   DECLARE vbAmountDiscount TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inisDiscount THEN
         vbAmountDiscount := CAST ((inAmount - (COALESCE (inAmountGRN,0)
                                           + (COALESCE (inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1)) 
                                           + (COALESCE (inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                           +  COALESCE (inAmountCard,0))
                                    ) AS NUMERIC (16, 2)) ;
     ELSE 
         vbAmountDiscount := 0;
     END IF;

         -- ���������
         RETURN QUERY 
          SELECT CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(vbAmountDiscount,0) ) > 0 
                      THEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(vbAmountDiscount,0) )
                      ELSE 0
                 END                                            ::TFloat AS AmountRemains          
               , CASE WHEN inAmount - (  COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0)
                                    +  COALESCE(vbAmountDiscount,0) ) < 0 
                      THEN (inAmount - ( COALESCE(inAmountGRN,0) 
                                    + (COALESCE(inAmountUSD,0) * COALESCE(inCurrencyValueUSD,1))
                                    + (COALESCE(inAmountEUR,0) * COALESCE(inCurrencyValueEUR,1)) 
                                    +  COALESCE(inAmountCard,0) 
                                    +  COALESCE(vbAmountDiscount,0) )) * (-1)
                      ELSE 0
                 END                                            ::TFloat AS AmountChange
               , vbAmountDiscount                               ::TFloat AS AmountDiscount
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
-- select * from gpGet_MI_Sale_Child_isDiscount(inisDiscount := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2 , inAmount := 5247.4 , inAmountGRN := 1.2 , inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 ,  inSession := '2');