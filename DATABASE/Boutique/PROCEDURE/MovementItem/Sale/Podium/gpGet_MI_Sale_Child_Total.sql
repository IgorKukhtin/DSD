-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Integer,Integer,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TVarChar);
DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(
    IN inCurrencyValueUSD  TFloat   , --
    IN inCurrencyValueEUR  TFloat   , --
    IN inAmountToPay_GRN   TFloat   , -- ����� � ������, ���
    IN inAmountToPay_EUR   TFloat   , -- ����� � ������, EUR
    IN inAmountGRN         TFloat   , --
    IN inAmountUSD         TFloat   , --
    IN inAmountEUR         TFloat   , --
    IN inAmountCard        TFloat   , --
    IN inAmountDiscount    TFloat   , -- ��� ��� ��� EUR
    IN inCurrencyId_Client Integer  , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (AmountToPay         TFloat -- � ������, ���
             , AmountToPay_curr    TFloat -- � ������, EUR
             , AmountRemains       TFloat -- �������, ���
             , AmountRemains_curr  TFloat -- �������, EUR
             , AmountDiff          TFloat -- �����, ���
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     RETURN QUERY
       WITH tmp AS (-- ������ - ������� �������� �������� / ���� �����
                    SELECT CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                THEN
                                    CASE WHEN COALESCE (inAmountGRN, 0)  = 0
                                          AND COALESCE (inAmountUSD, 0)  = 0
                                          AND COALESCE (inAmountEUR, 0)  = 0
                                          AND COALESCE (inAmountCard, 0) = 0
                                    THEN inAmountToPay_EUR + zfCalc_SummPriceList (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1))
                                        - COALESCE (inAmountDiscount, 0)
 
                                    WHEN
                                                                  ABS (zfCalc_SummPriceList (1
                                                                    , inAmountToPay_GRN + zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1))
                                                                      -- ����� ����� ������ - ��������� � ���
                                                                    - (COALESCE (inAmountGRN, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                     + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                     + COALESCE (inAmountCard, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                      )) < 1
                                    THEN
                             zfCalc_SummPriceList (1
                                                   -- ��������� ������� � EUR
                                                 , zfCalc_CurrencyTo (-- ����� � ������ - ��������� � ���
                                                                      inAmountToPay_GRN
                                                                    + zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1))
                                                                      -- ����� ����� ������ - ��������� � ���
                                                                    - (COALESCE (inAmountGRN, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                     + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                     + COALESCE (inAmountCard, 0)
                                                                     + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                      )
                                                                 , inCurrencyValueEUR, 1)
                                                 , 0)
                                    ELSE
                                    zfCalc_SummIn (1
                                                   -- ��������� ������� � EUR
                                                 , zfCalc_CurrencyTo (-- ����� � ������ - ��������� � ���
                                                   zfCalc_SummPriceList (1, inAmountToPay_GRN + zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1)
                                                                            -- ����� ����� ������ - ��������� � ���
                                                                          - (COALESCE (inAmountGRN, 0)
                                                                           + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                                           + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                                           + COALESCE (inAmountCard, 0)
                                                                           + zfCalc_CurrencyFrom (inAmountDiscount, inCurrencyValueEUR, 1)
                                                                            ))
                                                                 , inCurrencyValueEUR, 1)
                                                 , 1)
                                    END
                                ELSE -- ����� � ������ ����� ����� ������ - ��� � ���
                                     inAmountToPay_GRN + zfCalc_SummIn (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 0)
                                                    - (COALESCE (inAmountGRN, 0)
                                                    + zfCalc_CurrencyFrom (inAmountUSD, inCurrencyValueUSD, 1)
                                                    + zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, 1)
                                                    + COALESCE (inAmountCard, 0)
                                                    + COALESCE (inAmountDiscount, 0)
                                                     )
                           END AS AmountDiff
                   )
       SELECT -- � ������, ���
              CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        -- ��������� �� EUR � ��� + ���������� �� 0 ������
                        THEN inAmountToPay_GRN + zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (inAmountToPay_EUR, inCurrencyValueEUR, 1), 0)
                   ELSE inAmountToPay_GRN
              END :: TFloat AS AmountToPay

              -- � ������, EUR
            , CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                        THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1), 1) + inAmountToPay_EUR
                   ELSE -- ��������� �� ��� � EUR + ���������� �� 2� ������
                        zfCalc_SummIn (1, zfCalc_CurrencyTo (inAmountToPay_GRN, inCurrencyValueEUR, 1), 1) + inAmountToPay_EUR
              END :: TFloat AS AmountToPay_curr

              -- ������� �������� ��������, ���
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- ��������� �� EUR � ��� + ���������� �� 0 ������
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (tmp.AmountDiff, inCurrencyValueEUR, 1), 0)

                   WHEN tmp.AmountDiff > 0
                        -- ����� ���� � ���
                        THEN tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountRemains

              -- ������� �������� ��������, EUR + ���������� �� 0 ������
            , CASE WHEN tmp.AmountDiff > 0 AND inCurrencyId_Client = zc_Currency_EUR()
                        -- ����� ���� � EUR - ������ ���������
                        THEN tmp.AmountDiff

                   WHEN tmp.AmountDiff > 0
                        -- ��������� �� ��� � EUR + ���������� ?
                        THEN zfCalc_SummIn (1, zfCalc_CurrencyTo (tmp.AmountDiff, inCurrencyValueEUR, 1), 1)

                   ELSE 0
              END :: TFloat AS AmountRemains_curr


              -- �����, ���
            , CASE WHEN tmp.AmountDiff < 0 AND inCurrencyId_Client = zc_Currency_EUR() 
                        -- ��������� �� EUR � ��� + ���������� �� 0 ������
                        THEN zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (-1 * tmp.AmountDiff, inCurrencyValueEUR, 1), 0)

                   WHEN tmp.AmountDiff < 0
                        -- ����� ���� � ���
                        THEN -1 * tmp.AmountDiff

                   ELSE 0
              END :: TFloat AS AmountDiff

       FROM tmp;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.05.17         *
*/

-- ����
-- SELECT * FROM gpGet_MI_Sale_Child_Total (inCurrencyValueUSD:= 1, inCurrencyValueEUR:= 1, inAmountToPay_GRN:= 1, inAmountToPay_EUR:= 1, inAmountGRN:= 1, inAmountUSD:= 1, inAmountEUR:= 1, inAmountCard:= 1, inAmountDiscount:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inSession:= zfCalc_UserAdmin());
