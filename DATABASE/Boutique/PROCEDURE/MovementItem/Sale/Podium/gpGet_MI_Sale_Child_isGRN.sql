-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isGRN (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isGRN(
    IN inIsGRN               Boolean  , --
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay         TFloat   , -- ����� � ������, ���
    IN inAmountToPay_curr    TFloat   , -- ����� � ������, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , --
    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
               -- �����, ���
             , AmountDiff          TFloat
               -- �������������� ������
             , AmountDiscount      TFloat
             , AmountDiscount_curr TFloat
               -- ��������� �����
             , AmountGRN           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountGRN          TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
   DECLARE vbCurrencyValueUSD   NUMERIC (20, 10);
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !������! ����, ����� ������������� ��-�� �����-�����, 2 �����
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);


     -- ����� ������ - ���
     vbAmountPay_GRN := zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, 1)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;
     -- ���������
     vbAmountDiscount_GRN:= COALESCE (inAmountDiscount, 0);


     -- ����� - ���
     IF inIsGRN = TRUE
     THEN
         IF inAmountGRN = 0
         THEN -- ������ ������� �����
              vbAmountGRN := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                            zfCalc_SummPriceList (1, inAmountToPay - vbAmountPay_GRN)
                                       ELSE
                                            inAmountToPay - vbAmountPay_GRN
                             END;

              -- ���� ��� ������, ���������� � � ������ "�������"
              IF vbAmountDiscount_GRN = 0
              THEN
                  -- ������� ������� ���� �������
                  vbAmountDiscount_GRN:= inAmountToPay - vbAmountGRN;

                  -- ���� ������� �����
                  IF ABS (vbAmountDiscount_GRN) >= zc_AmountDiscountGRN()
                  THEN
                      -- ��������� ������ ���.
                      vbAmountDiscount_GRN:= vbAmountDiscount_GRN - FLOOR (vbAmountDiscount_GRN);
                  END IF;

                  -- ����������� ����� � ������ ������ AmountDiscount
                  vbAmountPay_GRN:= vbAmountPay_GRN + vbAmountDiscount_GRN;

              END IF;

          ELSE -- �������� ��� ���������
               vbAmountGRN := inAmountGRN;
          END IF;

     ELSE
         -- ��������
         vbAmountGRN := 0;

         -- ���� ��� 0
         IF inAmountUSD  = 0
        AND inAmountEUR  = 0
        AND inAmountCard = 0
         THEN
             -- �������� �������������� ������
             vbAmountDiscount_GRN:= 0;
             -- ����������� ����� � ������ ������ AmountDiscount
             vbAmountPay_GRN:= 0;
         END IF;

     END IF;

     -- ���������
     IF vbAmountGRN < 0 THEN vbAmountGRN:= 0; END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ���
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + vbAmountGRN) AS AmountDiff
                          )
              -- ������ - ���
            , tmpData AS (SELECT CASE WHEN tmpData_all.AmountDiff > 0
                                      THEN tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountRemains

                               , CASE WHEN tmpData_all.AmountDiff < 0
                                      THEN -1 * tmpData_all.AmountDiff
                                      ELSE 0
                                 END AS AmountDiff

                                 -- ��������� �����
                               , vbAmountGRN AS AmountGRN

                          FROM tmpData_all
                         )
      -- ���������
      SELECT -- �������, ���
             tmpData.AmountRemains :: TFloat AS AmountRemains
             -- �������, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountRemains_curr

             -- �����, ���
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- �������������� ������ - ���
           , vbAmountDiscount_GRN :: TFloat AS AmountDiscount
             -- �������������� ������ - EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (vbAmountDiscount_GRN, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

             -- ��������� ����� ���
           , tmpData.AmountGRN

      FROM tmpData;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 29.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_isGRN(inIsGRN := 'True' , inCurrencyValueUSD := 26.25 , inCurrencyValueEUR := 31.2, inCurrencyValueCross:= 1, inAmountToPay:= 5247.4, inAmountToPay_curr:= 123, inAmountGRN := 100 ,inAmountUSD := 100 , inAmountEUR := 84 , inAmountCard := 0 , inAmountDiscount := 0.4 , inCurrencyId_Client:= zc_Currency_EUR(), inSession := '2');
