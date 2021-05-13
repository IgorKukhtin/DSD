-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_isUSD (Boolean,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_isUSD(
    IN inIsUSD               Boolean  , --
    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueCross  TFloat   , --
    IN inAmountToPay         TFloat   , -- ����� � ������, ���
    IN inAmountToPay_curr    TFloat   , -- ����� � ������, EUR
    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount      TFloat   , -- ��� ��� ��� EUR
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
             , AmountUSD           TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAmountPay_GRN      TFloat;
   DECLARE vbAmountUSD          TFloat;
   DECLARE vbAmountDiscount_GRN TFloat;
   DECLARE vbCurrencyValueUSD   NUMERIC (20, 10);
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !������! ����, ����� ������������� ��-�� �����-�����, 2 �����
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);


     -- ����� ������ - ���
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                      + COALESCE (inAmountCard, 0)
                      + COALESCE (inAmountDiscount, 0)
                       ;
     -- ���������
     vbAmountDiscount_GRN:= COALESCE (inAmountDiscount, 0);

     -- ����� - USD
     IF inIsUSD = TRUE
     THEN
         IF inAmountUSD = 0
         THEN -- ������ ������� �����
              vbAmountUSD := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                       THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                            -- zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, inCurrencyValueUSD, 1))

                                            -- ������� � EUR, ����� �������� �� �����-����� � ��������� � 0 ������
                                            ROUND (zfCalc_CurrencyFrom (inAmountToPay_curr - zfCalc_CurrencyTo (vbAmountPay_GRN, inCurrencyValueEUR, 1)
                                                                      , inCurrencyValueCross, 1
                                                                       )
                                                 , 0)

                                       ELSE -- �� ���������
                                            zfCalc_CurrencyTo (inAmountToPay - vbAmountPay_GRN, vbCurrencyValueUSD, 1)
                             END;
              -- ���� ��� ������, ���������� � � ������ "�������"
              IF vbAmountDiscount_GRN = 0
              THEN
                  -- ������� ������� ���� �������
                  vbAmountDiscount_GRN:= inAmountToPay - zfCalc_CurrencyFrom (vbAmountUSD, vbCurrencyValueUSD, 1);

                  -- ���� ������� �����
                  IF ABS (vbAmountDiscount_GRN) >= zc_AmountDiscountGRN()
                  THEN
                      -- ��������� ������ - �� ������� ������
                    --vbAmountDiscount_GRN:= (inAmountToPay - vbAmountPay_GRN)
                    --                     - zfCalc_CurrencyFrom (vbAmountUSD, inCurrencyValueUSD, 1)
                    --                      ;
                      -- ��������� ������ ���.
                      vbAmountDiscount_GRN:= vbAmountDiscount_GRN + (vbAmountDiscount_GRN - vbAmountDiscount_GRN) - FLOOR (vbAmountDiscount_GRN - vbAmountDiscount_GRN);
                  END IF;

                  -- ����������� ����� � ������ ������ AmountDiscount
                  vbAmountPay_GRN:= vbAmountPay_GRN + vbAmountDiscount_GRN;

              END IF;

         ELSE -- �������� ��� ���������
              vbAmountUSD := inAmountUSD;
         END IF;

     ELSE
         -- ��������
         vbAmountUSD:= 0;

         -- ���� ��� 0
         IF inAmountGRN  = 0
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
     IF vbAmountUSD < 0 THEN vbAmountUSD:= 0; END IF;


     -- ���������
     RETURN QUERY
      WITH -- ������� � ������ - ���
           tmpData_all AS (SELECT inAmountToPay - (vbAmountPay_GRN + zfCalc_CurrencyFrom (vbAmountUSD, vbCurrencyValueUSD, 1)) AS AmountDiff
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
                               , vbAmountUSD AS AmountUSD

                          FROM tmpData_all
                         )
      -- ���������
      SELECT -- �������, ���
             tmpData.AmountRemains :: TFloat AS AmountRemains
             -- �������, EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (tmpData.AmountRemains, vbCurrencyValueUSD, 1), 1) :: TFloat AS AmountRemains_curr

             -- �����, ���
           , tmpData.AmountDiff :: TFloat AS AmountDiff

             -- �������������� ������ - ���
           , vbAmountDiscount_GRN :: TFloat AS AmountDiscount
             -- �������������� ������ - EUR
           , zfCalc_SummIn (1, zfCalc_CurrencyTo (vbAmountDiscount_GRN, inCurrencyValueEUR, 1), 1) :: TFloat AS AmountDiscount_curr

             -- ��������� ����� USD
           , tmpData.AmountUSD

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
-- SELECT * FROM gpGet_MI_Sale_Child_isUSD(inIsUSD := 'True' , inCurrencyValueUSD := 28 , inCurrencyValueEUR := 32.33 , inCurrencyValueCross := 1.2 , inAmountToPay := 32717.96 , inAmountToPay_curr := 1012 , inAmountGRN := 0 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCard := 0 , inAmountDiscount := 0 , inCurrencyId_Client := 18101 ,  inSession := '2');
