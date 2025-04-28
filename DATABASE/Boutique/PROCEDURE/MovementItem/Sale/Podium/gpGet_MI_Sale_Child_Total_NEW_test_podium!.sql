-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean, TFloat,TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, Boolean,TFloat, Boolean,TFloat, Boolean,TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Sale_Child_Total(

    -- ������������� �����
    IN inisGRN               Boolean  , -- ������ ���
    IN inisUSD               Boolean  , -- ������ ������
    IN inisEUR               Boolean  , -- ������ ����
    IN inisCard              Boolean  , -- ������ �����
    IN inisDiscount          Boolean  , -- ������� �������

    -- ���������� �������� �����
    IN inisGRNOld            Boolean  , -- ������ ��� ����. ��������
    IN inisUSDOld            Boolean  , -- ������ ������ ����. ��������
    IN inisEUROld            Boolean  , -- ������ ���� ����. ��������
    IN inisCardOld           Boolean  , -- ������ ����� ����. ��������
    IN inisDiscountOld       Boolean  , -- ������� ������� ����. ��������

    IN inCurrencyValueUSD    TFloat   , --
    IN inCurrencyValueInUSD  TFloat   , --
    IN inCurrencyValueEUR    TFloat   , --
    IN inCurrencyValueInEUR  TFloat   , --
    IN inCurrencyValueCross  TFloat   , --

    IN inAmountToPay_GRN     TFloat   , -- ����� � ������, ���
    IN inAmountToPay_EUR     TFloat   , -- ����� � ������, EUR

    IN inAmountGRN           TFloat   , --
    IN inAmountUSD           TFloat   , --
    IN inAmountEUR           TFloat   , --
    IN inAmountCard          TFloat   , --
    IN inAmountDiscount_EUR  TFloat   , -- ������ EUR
    IN inAmountDiscount      TFloat   , -- ������ ���
    IN inAmountDiff          TFloat   , -- ��������

    IN inisChangeEUR         Boolean  , --
    IN inAmountRemains       TFloat   , -- ������� � ���

    IN inisAmountRemains_EUR Boolean  , --
    IN inAmountRemains_EUR   TFloat   , --

    IN inisAmountDiff        Boolean  , --
    IN inAmountManualDiff    TFloat   , --


    IN inCurrencyId_Client   Integer  , --
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS TABLE (-- ������������ - ��� �������
               AmountToPay         TFloat -- � ������, ���
             , AmountToPay_EUR     TFloat -- � ������, EUR
               -- ���� - ������ ����
             , AmountToPayFull     TFloat
             , AmountToPayFull_EUR TFloat
               --
             , AmountRemains       TFloat -- �������, ���
             , AmountRemains_EUR   TFloat -- �������, EUR

               -- �����, ���
             , AmountDiff          TFloat

               -- �������������� ������ ���.
             , AmountDiscount      TFloat
               -- �������������� ������ (����� �����)
             , AmountDiscRound     TFloat
               -- �������������� ������ (�������)
             , AmountDiscDiff      TFloat
               -- ���������� ������ �� ���.
             , AmountRounding      TFloat

               -- �������������� ������ EUR
             , AmountDiscount_EUR  TFloat
               -- �������������� ������ EUR (����� �����)
             , AmountDiscRound_EUR TFloat
               -- �������������� ������ EUR (�������)
             , AmountDiscDiff_EUR  TFloat
               -- ���������� ������ �� EUR
             , AmountRounding_EUR  TFloat

               -- ��������� �����
             , AmountGRN           TFloat
             , AmountUSD           TFloat
             , AmountEUR           TFloat
             , AmountCard          TFloat

               -- ��������� ����� ���.
             , AmountToPay_Calc    TFloat
             , AmountToPay_EUR_Calc TFloat

             , isAmountRemains_EUR Boolean
             , isAmountDiff        Boolean

               -- ����� �������� ����� ��� ������ ���������� ��������
             , isGRN               Boolean
             , isUSD               Boolean
             , isEUR               Boolean
             , isCard              Boolean
             , isDiscount          Boolean

               -- ����� �������� ����� ��� ������ ���������� ��������
             , isGRNOld            Boolean
             , isUSDOld            Boolean
             , isEUROld            Boolean
             , isCardOld           Boolean
             , isDiscountOld       Boolean

               -- AmountPay - ��� �������
             , AmountPay            TFloat
             , AmountPay_EUR        TFloat

             , AmountGRN_EUR        TFloat
             , AmountGRN_Over       TFloat

             , AmountUSD_EUR        TFloat
             , AmountUSD_Pay        TFloat
             , AmountUSD_Pay_GRN    TFloat
             , AmountUSD_Over       TFloat
             , AmountUSD_Over_GRN   TFloat

             , AmountEUR_Pay        TFloat
             , AmountEUR_Pay_GRN    TFloat
             , AmountEUR_Over       TFloat
             , AmountEUR_Over_GRN   TFloat

             , AmountCARD_EUR       TFloat
             , AmountCARD_Over      TFloat

             , AmountRest           TFloat
             , AmountRest_EUR       TFloat

               -- �������� ������� �� ������� (������ ���� 0)
             , AmountDiffFull_GRN   TFloat
             , AmountDiffFull_EUR   TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyValueUSD NUMERIC (20, 10);

   DECLARE vbAmountPay_GRN       TFloat;
   DECLARE vbAmountPay_EUR       TFloat;

   DECLARE
     -- � ������
     vbAmountToPay_EUR     TFloat;
      -- ��� ������
     vbAmountToPayFull_GRN TFloat;
      -- � ������
     vbAmountToPay_GRN     TFloat;

     -- ������ - GRN
     vbPayGRN      TFloat;
     vbPayGRN_eur  TFloat;

     -- ������ - USD
     vbPayUSD      TFloat;
     vbPayUSD_eur  TFloat;
     vbPayUSD_grn  TFloat;

     -- ������ - EUR
     vbPayEUR      TFloat;
     vbPayEUR_grn  TFloat;

     -- ������ - Card
     vbPayCard     TFloat;
     vbPayCard_eur TFloat;

     -- ����
     vbRem_GRN     TFloat;
     -- ����
     vbRem_EUR     TFloat;

     -- �����
     vbAmountDiff TFloat;

     -- �������������� ������ EUR - ����������
     vbRoundDiscount_EUR TFloat;
     -- �������������� ������ GRN - ����������
     vbRoundDiscount_GRN TFloat;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !������! ����, ����� ������������� ��-�� �����-����� ��� ����������
     inCurrencyValueCross := CASE WHEN inCurrencyValueCross > 0 THEN inCurrencyValueCross ELSE 1 END;
     vbCurrencyValueUSD:= inCurrencyValueEUR::NUMERIC (20, 10) / inCurrencyValueCross::NUMERIC (20, 10);

     IF inAmountGRN < 0 THEN inAmountGRN := 0; END IF;
     IF inAmountUSD < 0 THEN inAmountUSD := 0; END IF;
     IF inAmountEUR < 0 THEN inAmountEUR := 0; END IF;
     IF inAmountCard < 0 THEN inAmountCard :=0; END IF;


     IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION '������. ����� ��������� ����� % ��������� ����� � ������ %', inAmountRemains_EUR, inAmountToPay_EUR;
     ELSEIF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) < 0
     THEN
        RAISE EXCEPTION '������. ����� ��������� ����� % ������ ��� �������������', inAmountRemains_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION '������. ����� ��������� �������� ��� ���������� % ��������� ����� � ������ %', inAmountDiscount_EUR, inAmountToPay_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) < - 0.5
     THEN
        RAISE EXCEPTION '������. ����� ��������� �������� ��� ���������� % ������ ���� �������������', inAmountDiscount_EUR;
     END IF;


     -- � ������
     vbAmountToPay_EUR    := inAmountToPay_EUR;
   --vbAmountToPay_EUR    := inAmountToPay_EUR - inAmountDiscount_EUR;
      -- ��� ������
     vbAmountToPayFull_GRN:= zfCalc_CurrencyFrom (vbAmountToPay_EUR, inCurrencyValueEUR, 1);
      -- � ������
     vbAmountToPay_GRN    := ROUND (vbAmountToPayFull_GRN, 0);

     -- ������ - GRN
     vbPayGRN:= inAmountGRN;
     vbPayGRN_eur:= zfCalc_CurrencyTo_2 (vbPayGRN, inCurrencyValueEUR, 1); -- � ������ �� 2-�

     -- ������ - USD
     vbPayUSD    := inAmountUSD;
     vbPayUSD_eur:= ROUND (vbPayUSD / inCurrencyValueCross, 2);
     vbPayUSD_grn:= zfCalc_CurrencyFrom_2 (vbPayUSD, inCurrencyValueUSD, 1); -- � ������ �� 2-�

     -- ������ - EUR
     vbPayEUR    := inAmountEUR;
     vbPayEUR_grn:= zfCalc_CurrencyFrom_2 (vbPayEUR, inCurrencyValueEUR, 1); -- � ������ �� 2-�

     -- ������ - Card
     vbPayCard:= inAmountCard;
     vbPayCard_eur:= zfCalc_CurrencyTo_2 (vbPayCard, inCurrencyValueEUR, 1); -- � ������ �� 2-�

     -- ����
     vbRem_GRN:= vbAmountToPayFull_GRN
               - vbPayGRN
               - vbPayUSD_grn
               - vbPayEUR_grn
               - vbPayCard
               -- ����� �������������� ������ ��� - !!!��������!!!
               - zfCalc_CurrencyFrom_2 (inAmountDiscount_EUR, inCurrencyValueEUR, 1)
                ;

     -- ����
     vbRem_EUR:= vbAmountToPay_EUR
               - vbPayGRN_eur
               - vbPayUSD_eur
               - vbPayEUR
               - vbPayCard_eur
               -- ����� �������������� ������ - !!!��������!!!
               - inAmountDiscount_EUR
                ;

     -- ���� �����
     IF vbRem_EUR < 0
     THEN
         -- �����
         IF vbRem_GRN < 0 THEN vbAmountDiff:= -1 * vbRem_GRN; ELSE vbRem_GRN:= 0; END IF;
         --
         vbRem_GRN:= 0;
         vbRem_EUR:= 0;
         -- ��������� ������� ����� � ������
         -- ............

     END IF;


     -- �������������� ������ EUR - ����������
     vbRoundDiscount_EUR := vbRem_EUR - ROUND (vbRem_EUR, 0);
     -- �������������� ������ GRN - ����������
     vbRoundDiscount_GRN := vbRem_GRN - ROUND (vbRem_GRN, 0);

     -- ����, ���������������
     vbRem_EUR:= vbRem_EUR - vbRoundDiscount_EUR;
     -- ����, ���������������
     vbRem_GRN:= vbRem_GRN - vbRoundDiscount_GRN;


     -- ���������
     RETURN QUERY
      SELECT -- � ������, ��� - ����� ���������
             vbAmountToPay_GRN AS AmountToPay
             -- � ������, EUR - ����� ���������
           , vbAmountToPay_EUR AS AmountToPay_EUR

             -- � ������, ��� - �� ���������
           , vbAmountToPayFull_GRN AS AmountToPayFull
             -- � ������, EUR - �� ���������
           , vbAmountToPay_EUR     AS AmountToPayFull_EUR

             -- ������� �������� ��������, ���
           , vbRem_GRN AS AmountRemains
             -- ������� �������� ��������, EUR
           , vbRem_EUR AS AmountRemains_EUR

             -- �����, ���
           , vbAmountDiff AS AmountDiff


             -- �������������� ������ - ��� - !!!��������!!!
           , zfCalc_CurrencyFrom_2 (inAmountDiscount_EUR, inCurrencyValueEUR, 1) AS AmountDiscount
             -- �������������� ������ - ���
           , 0 :: TFloat AS AmountDiscRound
             -- ���������� - ���
           , vbRoundDiscount_GRN :: TFloat AmountDiscDiff
             -- ����������� ������ - ���
           , 0 :: TFloat AmountRounding


             -- �������������� ������ - EUR -  !!!��������!!!
           , inAmountDiscount_EUR AS AmountDiscount_EUR
             -- �������������� ������ - EUR
           , 0 :: TFloat AS AmountDiscRound_EUR

             -- ���������� - EUR
           , vbRoundDiscount_EUR AS AmountDiscDiff_EUR
             -- ����������� ������ - EUR
           , 0 :: TFloat AS AmountRounding_EUR

           , vbPayGRN  AS AmountGRN
           , vbPayUSD  AS AmountUSD
           , vbPayEUR  AS AmountEUR
           , vbPayCard AS AmountCard

           , 0 :: TFloat AS AmountToPay_Calc
           , 0 :: TFloat AS AmountToPay_EUR_Calc

           , FALSE       AS isAmountRemains_EUR
           , FALSE       AS isAmountDiff

             -- � ������� - �������� �����
           , vbPayGRN > 0, vbPayUSD > 0, vbPayEUR > 0, vbPayCard > 0
           , vbRoundDiscount_EUR <> 0 OR vbRoundDiscount_GRN <> 0 OR inAmountDiscount_EUR <> 0

             -- ��� ���������� - �������� �����
           , vbPayGRN > 0, vbPayUSD > 0, vbPayEUR > 0, vbPayCard > 0
           , vbRoundDiscount_EUR <> 0 OR vbRoundDiscount_GRN <> 0 OR inAmountDiscount_EUR <> 0

             -- AmountPay, ���
           , (vbPayGRN + vbPayUSD_grn + vbPayEUR_grn + vbPayCard)     :: TFloat AS AmountPay
             -- AmountPay, EUR
           , (vbPayGRN_eur + vbPayUSD_eur + vbPayEUR + vbPayCard_eur) :: TFloat AS AmountPay_EUR

           , vbPayGRN_eur AS AmountGRN_EUR
           , 0 :: TFloat  AS AmountGRN_Over

           , vbPayUSD_eur AS AmountUSD_EUR
           , vbPayUSD     AS AmountUSD_Pay
           , vbPayUSD_grn AS AmountUSD_Pay_GRN
           , 0 :: TFloat  AS AmountUSD_Over
           , 0 :: TFloat  AS AmountUSD_Over_GRN

           , vbPayEUR     AS AmountEUR_Pay
           , vbPayEUR_grn AS AmountEUR_Pay_GRN
           , 0 :: TFloat  AS AmountEUR_Over
           , 0 :: TFloat  AS AmountEUR_Over_GRN

           , 0 :: TFloat  AS AmountCARD_EUR
           , 0 :: TFloat  AS AmountCARD_Over

           , 0 :: TFloat  AS AmountRest
           , 0 :: TFloat  AS AmountRest_EUR

             -- �������� ������� �� ������� (������ ���� 0)
           , 0 :: TFloat  AS AmountDiffFull_GRN
           , 0 :: TFloat  AS AmountDiffFull_EUR

      FROM lpGet_MI_Sale_Child_TotalCalc(inCurrencyValueUSD       := inCurrencyValueUSD
                                       , inCurrencyValueInUSD     := inCurrencyValueInUSD
                                       , inCurrencyValueEUR       := inCurrencyValueEUR
                                       , inCurrencyValueInEUR     := inCurrencyValueInEUR
                                       , inCurrencyValueCross     := inCurrencyValueCross

                                       , inAmountToPay_EUR        := inAmountToPay_EUR

                                       , inAmountGRN              := inAmountGRN
                                       , inAmountUSD              := inAmountUSD
                                       , inAmountEUR              := inAmountEUR
                                       , inAmountCard             := inAmountCard
                                       , inAmountDiscount_EUR     := inAmountDiscount_EUR

                                       , inisDiscount             := inisDiscount
                                       , inisChangeEUR            := inisChangeEUR
                                       , inisAmountRemains_EUR    := inisAmountRemains_EUR
                                       , inAmountRemains_EUR      := inAmountRemains_EUR
                                       , inisAmountDiff           := inisAmountDiff
                                       , inAmountDiff             := inAmountManualDiff
                                       , inCurrencyId_Client      := inCurrencyId_Client
                                       , inUserId                 := vbUserId) AS Res
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 22.05.17         *
*/

-- ����
--
/*
select * from gpGet_MI_Sale_Child_Total(inisGRN := 'False' , inisUSD := 'True' , inisEUR := 'False' , inisCard := 'True' , inisDiscount := 'True' ,
                                        inisGRNOld := 'False' , inisUSDOld := 'True' , inisEUROld := 'False' , inisCardOld := 'True' , inisDiscountOld := 'True' ,
                                        inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.09 ,
                                        inAmountToPay_GRN := 18468.45 , inAmountToPay_EUR := 451 ,
                                        inAmountGRN := 0 , inAmountUSD := 200 , inAmountEUR := 0 , inAmountCard := 10900 , inAmountDiscount_EUR := 283 , inAmountDiscount := 5807.79 , inAmountDiff := 0 ,
                                        inisChangeEUR := 'True' , inAmountRemains := 0 ,
                                        inisAmountRemains_EUR := 'False' , inAmountRemains_EUR := 0 , inisAmountDiff := 'False' , inAmountManualDiff := -10 ,
                                        inCurrencyId_Client := 18101 ,  inSession := '2');
*/
