-- Function: gpGet_MI_Sale_Child_Total()

DROP FUNCTION IF EXISTS gpGet_MI_Sale_Child_Total (Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean,Boolean, TFloat,TFloat,TFloat,TFloat, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, Boolean,TFloat, Boolean,TFloat, Boolean,TFloat, Integer, TVarChar);

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
             
             , AmountOver_GRN       TFloat

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
   DECLARE vbAmountDiffLeft_GRN  TFloat;   
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
     
     
     --inAmountDiscount_EUR := Round(inAmountDiscount_EUR);

     /*IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION '������. ����� ��������� ����� % ��������� ����� � ������ %', inAmountRemains_EUR, inAmountToPay_EUR;
     ELSE*/
     
     IF inisAmountRemains_EUR = TRUE AND COALESCE (inAmountRemains_EUR, 0) < 0
     THEN
        RAISE EXCEPTION '������. ����� ��������� ����� % ������ ��� �������������', inAmountRemains_EUR;
     /*ELSEIF COALESCE (inAmountDiscount_EUR, 0) > inAmountToPay_EUR
     THEN
        RAISE EXCEPTION '������. ����� ��������� �������� ��� ���������� % ��������� ����� � ������ %', inAmountDiscount_EUR, inAmountToPay_EUR;
     ELSEIF COALESCE (inAmountDiscount_EUR, 0) < - 0.5
     THEN
        RAISE EXCEPTION '������. ����� ��������� �������� ��� ���������� % ������ ���� �������������', inAmountDiscount_EUR;*/
     END IF;
     
     inAmountToPay_GRN := zfCalc_CurrencyFrom ( COALESCE (inAmountToPay_EUR, 0), inCurrencyValueEUR, 1);
     
          
     -- ����� ������ - EUR
     vbAmountPay_EUR := ROUND(zfCalc_CurrencyTo (inAmountGRN, inCurrencyValueEUR, 1) 
                            + COALESCE (inAmountEUR, 0)
                            + Round ( inAmountUSD / inCurrencyValueCross, 2)
                            + zfCalc_CurrencyTo (inAmountCard, inCurrencyValueEUR, 1)
                            + COALESCE (inAmountDiscount_EUR, 0)
                           , 2) ;

     -- ����� ������ - ���
     vbAmountPay_GRN := COALESCE (inAmountGRN, 0)
                      + zfCalc_CurrencyFrom ( COALESCE (inAmountEUR, 0), inCurrencyValueEUR, 1)
                      + Round ( inAmountUSD * vbCurrencyValueUSD, 1)
                      + COALESCE (inAmountCard, 0)
                      + zfCalc_CurrencyFrom ( COALESCE (inAmountDiscount_EUR, 0), inCurrencyValueEUR, 1)
                       ;

     -- �� ������ ������ ��������   
     IF inisAmountRemains_EUR = FALSE THEN inAmountRemains_EUR := 0; END IF;
     IF inisAmountDiff = FALSE THEN inAmountManualDiff := 0; END IF;
       
     -- *** ����� - ���
     IF inisGRN = FALSE AND inisGRNOld = FALSE AND COALESCE (inAmountGRN, 0) > 0 
     THEN
       inisGRN := True;
       inisGRNOld = True;
     ELSEIF inisGRN = TRUE AND inisGRNOld = TRUE AND COALESCE (inAmountGRN, 0) = 0
     THEN
       inisGRN := False;
       inisGRNOld = False;
     ELSEIF inisGRN = TRUE AND inisGRNOld = FALSE AND COALESCE (inAmountGRN, 0) = 0
     THEN
        -- ������ ������� �����
        inAmountGRN := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round(inAmountRemains) <= 0
                            THEN -- ���� �������� �� ������ ������ ���� ����� �� ��������
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                 Round(inAmountRemains)
                            ELSE
                                 inAmountToPay_GRN - vbAmountPay_GRN
                       END;
     END IF;
     -- �������� ������ ����� ������ �����                        
     IF inisGRN = False AND inisGRNOld = TRUE
     THEN
        -- ������ ������� �����
        inAmountGRN := 0;
     END IF;
       
     -- *** ����� - EUR
     IF inisEUR = FALSE AND inisEUROld = FALSE AND COALESCE (inAmountEUR, 0) > 0 
     THEN
       inisEUR := True;
       inisEUROld = True;
     ELSEIF inisEUR = TRUE AND inisEUROld = TRUE AND COALESCE (inAmountEUR, 0) = 0
     THEN
       inisEUR := False;
       inisEUROld = False;
     ELSEIF inisEUR = TRUE AND inisEUROld = FALSE AND COALESCE (inAmountEUR, 0) = 0
     THEN
        -- ������ ������� �����
        inAmountEUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round (COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) <= 0
                            THEN -- ���� �������� �� ������ ������ ���� ����� �� ��������
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- ��������� � 100 ������, ������� ������� ��������� � ������� ��������
                                 Round (COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR, -2)
                            ELSE -- �� ���������
                                 zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                       END;

     END IF;
     -- �������� EUR ����� ������ �����                        
     IF inisEUR = False AND inisEUROld = TRUE
     THEN
        -- ������ ������� �����
        inAmountEUR := 0;
     END IF;

     -- *** ����� - USD
     IF inisUSD = FALSE AND inisUSDOld = FALSE AND COALESCE (inAmountUSD, 0) > 0 
     THEN
       inisUSD := True;
       inisUSDOld = True;
     ELSEIF inisUSD = TRUE AND inisUSDOld = TRUE AND COALESCE (inAmountUSD, 0) = 0
     THEN
       inisUSD := False;
       inisUSDOld = False;
     ELSEIF inisUSD = TRUE AND inisUSDOld = FALSE AND COALESCE (inAmountUSD, 0) = 0
     THEN
        -- ������ ������� �����
        inAmountUSD := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round((COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) * inCurrencyValueCross) <= 0
                            THEN -- ���� �������� �� ������ ������ ���� ����� �� ��������
                                 0
                            WHEN inCurrencyId_Client = zc_Currency_EUR()
                            THEN -- ��������� � 0 ������, ������� ������� ��������� � ������� ��������
                                 Round((COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR) * inCurrencyValueCross, -2)
                            ELSE -- �� ���������
                                 zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, vbCurrencyValueUSD, 1)
                       END;

     END IF;
     -- �������� USD ����� ������ �����                        
     IF inisUSD = False AND inisUSDOld = TRUE
     THEN
        -- ������ ������� �����
        inAmountUSD := 0;
     END IF;

     -- *** ����� - ��� �� �����
     IF inisCard = FALSE AND inisCardOld = FALSE AND COALESCE (inAmountCard, 0) > 0 
     THEN
       inisCard := True;
       inisCardOld = True;
     ELSEIF inisCard = TRUE AND inisCardOld = TRUE AND COALESCE (inAmountCard, 0) = 0
     THEN
       inisCard := False;
       inisCardOld = False;
     ELSEIF inisCard = TRUE AND inisCardOld = FALSE AND COALESCE (inAmountCard, 0) = 0
     THEN
        -- ������ ������� �����
        inAmountCard := CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND Round(inAmountRemains) <= 0
                             THEN -- ���� �������� �� ������ ������ ���� ����� �� ��������
                                  0
                             WHEN inCurrencyId_Client = zc_Currency_EUR()
                             THEN -- ��������� � 0 ������, ������� ������� ��������� � ��������
                                  Round(inAmountRemains)
                             ELSE
                                  inAmountToPay_GRN - vbAmountPay_GRN
                        END;
     END IF;
     -- �������� ��� �� ����� ����� ������ �����                        
     IF inisCard = False AND inisCardOld = TRUE
     THEN
        -- ������ ������� �����
        inAmountCard := 0;
     END IF;
          
     -- ������������� ����� ��������
     IF inisDiscount = TRUE AND inisDiscountOld = FALSE AND COALESCE (inAmountDiscount_EUR, 0) = 0
     THEN
 
        -- ������ ������� �����
        inAmountDiscount_EUR := CASE WHEN inCurrencyId_Client = zc_Currency_EUR()
                                     THEN -- ��������� � 100 ������, ������� ������� ��������� � ������� ��������
                                          COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR
                                     ELSE -- �� ���������
                                          zfCalc_CurrencyTo (inAmountToPay_GRN - vbAmountPay_GRN, inCurrencyValueEUR, 1)
                                END;
                                
        inisAmountDiff := True;
        inAmountManualDiff := 0;
     END IF;
     -- �������� ��� �� ����� ����� ������ �����                        
     IF inisDiscount = False AND inisDiscountOld = TRUE
     THEN
        -- ������ ������� �����
        inAmountDiscount_EUR := 0;
        inAmountDiscount := 0;
     END IF;
     
     IF inisAmountRemains_EUR = TRUE
     THEN
       inAmountDiscount_EUR := COALESCE (inAmountToPay_EUR, 0) - vbAmountPay_EUR - inAmountRemains_EUR + inAmountDiscount_EUR;
       inisAmountRemains_EUR := False;
     END IF;
                                                      
     -- ���������
     RETURN QUERY
      SELECT -- � ������, ��� - ����� ���������
             Res.AmountToPay
             -- � ������, EUR - ����� ���������
           , Res.AmountToPay_EUR

             -- � ������, ��� - �� ���������
           , Res.AmountToPayFull
             -- � ������, EUR - �� ���������
           , Res.AmountToPayFull_EUR

             -- ������� �������� ��������, ���
           , Res.AmountRemains
             -- ������� �������� ��������, EUR
           , Res.AmountRemains_EUR

             -- �����, ���
           , Res.AmountDiff

             -- �������������� ������ - ���
           , Res.AmountDiscount                                                  AS AmountDiscount
             -- �������������� ������ - ���
           , round(Res.AmountDiscount)::TFloat                                   AS AmountDiscRound
             -- ���������� - ���
           , (Res.AmountDiscount - round(Res.AmountDiscount))::TFloat            AS AmountDiscDiff
             -- ����������� ������ - ���
           , Res.AmountRounding


             -- �������������� ������ - EUR
           , Res.AmountDiscount_EUR                                              AS AmountDiscount_EUR
             -- �������������� ������ - EUR
           , round(Res.AmountDiscount_EUR)::TFloat                               AS AmountDiscRound_EUR
             -- ���������� - EUR
           , (Res.AmountDiscount_EUR - round(Res.AmountDiscount_EUR))::TFloat    AS AmountDiscDiff_EUR
             -- ����������� ������ - EUR
           , Res.AmountRounding_EUR

           , Res.AmountGRN
           , Res.AmountUSD
           , Res.AmountEUR
           , Res.AmountCard
           
           , Res.AmountToPay_Calc
           , Res.AmountToPay_EUR_Calc
           
           , FALSE                                                              AS isAmountRemains_EUR
           , FALSE                                                              AS isAmountDiff

           
           , Res.AmountGRN > 0, Res.AmountUSD > 0, Res.AmountEUR > 0, Res.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND Res.AmountDiff = 0 AND (Res.AmountGRN_Over + Res.AmountUSD_Over_GRN + Res.AmountEUR_Over_GRN + Res.AmountCARD_Over) > 0
           , Res.AmountGRN > 0, Res.AmountUSD > 0, Res.AmountEUR > 0, Res.AmountCard > 0
           , ABS(Res.AmountDiscount_EUR) >= 1 OR ABS(Res.AmountDiscount) >= 5 AND Res.AmountDiff = 0 AND (Res.AmountGRN_Over + Res.AmountUSD_Over_GRN + Res.AmountEUR_Over_GRN + Res.AmountCARD_Over) > 0

             -- AmountPay, ���
           , Res.AmountPay
             -- AmountPay, EUR
           , Res.AmountPay_EUR

           , Res.AmountGRN_EUR
           , Res.AmountGRN_Over

           , Res.AmountUSD_EUR
           , Res.AmountUSD_Pay
           , Res.AmountUSD_Pay_GRN
           , Res.AmountUSD_Over
           , Res.AmountUSD_Over_GRN

           , Res.AmountEUR_Pay
           , Res.AmountEUR_Pay_GRN
           , Res.AmountEUR_Over
           , Res.AmountEUR_Over_GRN

           , Res.AmountCARD_EUR
           , Res.AmountCARD_Over
           
           , Res.AmountOver_GRN

           , Res.AmountRest
           , Res.AmountRest_EUR

             -- �������� ������� �� ������� (������ ���� 0)
           , Res.AmountDiffFull_GRN
           , Res.AmountDiffFull_EUR
           
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

/*select * from gpGet_MI_Sale_Child_Total(inisGRN := 'False' , inisUSD := 'False' , inisEUR := 'False' , inisCard := 'False' , inisDiscount := 'True' , 
                                        inisGRNOld := 'False' , inisUSDOld := 'False' , inisEUROld := 'False' , inisCardOld := 'False' , inisDiscountOld := 'False' , 
                                        inCurrencyValueUSD := 37.68 , inCurrencyValueInUSD := 37.31 , inCurrencyValueEUR := 40.95 , inCurrencyValueInEUR := 40.54 , inCurrencyValueCross := 1.01 , 
                                        inAmountToPay_GRN := 18468.45 , inAmountToPay_EUR := 451 , 
                                        inAmountGRN := 0 , inAmountUSD := 0 , inAmountEUR := 0 , inAmountCard := 0 , inAmountDiscount_EUR := 0 , inAmountDiscount := 0 , inAmountDiff := 0 , 
                                        inisChangeEUR := 'False' , inAmountRemains := 18468 , 
                                        inisAmountRemains_EUR := 'False' , inAmountRemains_EUR := 0 , inisAmountDiff := 'False' , inAmountManualDiff := 0 , inAmountOver_GRN := 0 , 
                                        inCurrencyId_Client := 18101 ,  inSession := '2');*/