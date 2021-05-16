-- Function: lpSelect_MI_Child_calc()

DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpSelect_MI_Child_calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MI_Child_calc(
    IN inMovementId            Integer   , -- ����
    IN inUnitId                Integer   , -- ����
    IN inAmountGRN             TFloat    , -- ����� ������
    IN inAmountUSD             TFloat    , -- ����� ������
    IN inAmountEUR             TFloat    , -- ����� ������
    IN inAmountCard            TFloat    , -- ����� ������
    IN inAmountDiscount_GRN    TFloat    , -- �������������� ������ � ������� !!! ��� !!!
    IN inCurrencyValueUSD      TFloat    , --
    IN inParValueUSD           TFloat    , --
    IN inCurrencyValueEUR      TFloat    , --
    IN inParValueEUR           TFloat    , --
    IN inCurrencyValueCross    TFloat    , -- �����-����
    IN inParValueCross         TFloat    , -- ������� ��� �����-�����
    IN inCurrencyId_Client     Integer   , --
    IN inUserId                Integer     -- ����
)
RETURNS TABLE (MovementItemId      Integer
             , ParentId            Integer
             , CashId              Integer -- �����, � ������� ����� ������/������(���� �������)
             , CurrencyId          Integer -- ������ �����, � ������� ����� ������/������(���� �������)
             , AmountToPay         TFloat  -- ����� � ������, ���
             , AmountToPay_curr    TFloat  -- ����� � ������, EUR
             , AmountDiscount      TFloat  -- ����� ������, ���
             , AmountDiscount_curr TFloat  -- ����� ������, EUR
             , Amount              TFloat  -- ����� ������
             , Amount_GRN          TFloat  -- ����� ����� ������ � ���
             , Amount_EUR          TFloat  -- ����� ����� ������ � EUR
             , CurrencyValue       TFloat
             , ParValue            TFloat
             , CashId_Exc          Integer -- ����� � ��� - �� ������� ����� ������/������(���� �������) ����� ��� ������
              )
AS
$BODY$
   DECLARE vbTotalAmountToPay      TFloat;
   DECLARE vbTotalAmountToPay_curr TFloat;
   DECLARE vbCurrencyValueUSD      NUMERIC (20, 10);
   DECLARE vbAmountDiscount_currency TFloat;
BEGIN

     -- !������! ����, ����� ������������� ��-�� �����-�����, 2 �����
     vbCurrencyValueUSD:= zfCalc_CurrencyTo_Cross (inCurrencyValueEUR, inCurrencyValueCross);
     
     -- !������!
     -- vbAmountDiscount_currency


     --
     -- !!!��� �����!!!
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmp_MI_Master'))
     THEN
         -- ������� ������ - !!!������ ��� �����!!!
         CREATE TEMP TABLE _tmp_MI_Master (MovementItemId Integer, SummPriceList TFloat, SummPriceList_curr TFloat, AmountToPay TFloat, AmountToPay_curr TFloat) ON COMMIT DROP;
         INSERT INTO _tmp_MI_Master (MovementItemId, SummPriceList, SummPriceList_curr, AmountToPay, AmountToPay_curr)
           WITH tmpMI AS (SELECT MovementItem.Id AS MovementItemId
                                 -- SummPriceList
                               , zfCalc_SummIn (MovementItem.Amount, CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                                                               THEN zfCalc_CurrencyFrom (MIFloat_OperPriceList_curr.ValueData, inCurrencyValueEUR, 1)
                                                                          ELSE MIFloat_OperPriceList.ValueData
                                                                     END, 1) AS SummPriceList
                                 -- SummPriceList_curr
                               , zfCalc_SummIn (MovementItem.Amount, CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                                                               THEN MIFloat_OperPriceList_curr.ValueData
                                                                          ELSE zfCalc_CurrencyTo (MIFloat_OperPriceList.ValueData, inCurrencyValueEUR, 1)
                                                                     END, 1) AS SummPriceList_curr
   
                                -- AmountToPay
                              , CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                          THEN zfCalc_CurrencyFrom (zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData)
                                                                  , inCurrencyValueEUR, 1)
                                          ELSE zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData)
                                END AS AmountToPay
                                -- AmountToPay_curr
                              , CASE WHEN inCurrencyId_Client <> zc_Currency_GRN()
                                          THEN zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList_curr.ValueData, MIFloat_ChangePercent.ValueData)
                                          ELSE zfCalc_CurrencyTo (zfCalc_SummChangePercent (MovementItem.Amount, MIFloat_OperPriceList.ValueData, MIFloat_ChangePercent.ValueData)
                                                                , inCurrencyValueEUR, 1)
                                END AS AmountToPay_curr

                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                           ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                               LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList_curr
                                                           ON MIFloat_OperPriceList_curr.MovementItemId = MovementItem.Id
                                                          AND MIFloat_OperPriceList_curr.DescId         = zc_MIFloat_OperPriceList_curr()
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent
                                                           ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummChangePercent.DescId         = zc_MIFloat_SummChangePercent()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummChangePercent_curr
                                                           ON MIFloat_SummChangePercent_curr.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummChangePercent_curr.DescId         = zc_MIFloat_SummChangePercent_curr()
                          WHERE MovementItem.MovementId = inMovementId
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                         )
           -- ���������
           SELECT tmpMI.MovementItemId, tmpMI.SummPriceList, tmpMI.SummPriceList_curr, tmpMI.AmountToPay, tmpMI.AmountToPay_curr
           FROM tmpMI
         --WHERE tmpMI.MovementItemId     = inParentId
         --   OR COALESCE (inParentId, 0) = 0;
            -- SELECT 1, 12550, 12550
          ;

     END IF;
     -- !!!��� �����!!!
     --

--    RAISE EXCEPTION '������.<%>  %', (select _tmp_MI_Master.AmountToPay from _tmp_MI_Master )
--   , (select _tmp_MI_Master.AmountToPay_curr from _tmp_MI_Master )
--    ;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
     END IF;

     -- �������� - �������� ������ ���� �����������
     IF NOT EXISTS (SELECT 1 FROM _tmp_MI_Master) THEN
        RAISE EXCEPTION '������.��� ������ ��� ������������ ������.';
     END IF;

     -- ����� ����� ����� � ������ - !!! ��� + EUR !!!
     vbTotalAmountToPay     := (SELECT SUM (_tmp_MI_Master.AmountToPay)      FROM _tmp_MI_Master);
     vbTotalAmountToPay_curr:= (SELECT SUM (_tmp_MI_Master.AmountToPay_curr) FROM _tmp_MI_Master);

     -- ��������
     IF vbTotalAmountToPay < inAmountDiscount_GRN THEN
        RAISE EXCEPTION '������.����� �������������� ������ = <%> % �� ����� ���� ������ ��� <%> %.', inAmountDiscount_GRN, '���', vbTotalAmountToPay, '���';
     END IF;



     -- ��������� �����
     RETURN QUERY
          WITH -- �����
               tmpCash AS (SELECT lpSelect.CashId, lpSelect.CurrencyId, lpSelect.isBankAccount FROM lpSelect_Object_Cash (inUnitId, inUserId) AS lpSelect)
     -- ������������ - �������������� ������
   , tmp_MI_Master_all AS (SELECT _tmp_MI_Master.MovementItemId
                                  -- ����� � ������ - !!! ��� + EUR !!!
                                , _tmp_MI_Master.AmountToPay
                                , _tmp_MI_Master.AmountToPay_curr

                                  -- ������������ ���. ������ �� ��������� - !!! ��� !!!
                                , CASE WHEN inAmountDiscount_GRN = vbTotalAmountToPay
                                            THEN _tmp_MI_Master.AmountToPay

                                       -- ���� ������ ����� ��� ��� ������
                                       WHEN FLOOR (zfCalc_CurrencyTo (inAmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR))
                                                 = zfCalc_CurrencyTo (inAmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR)
                                       OR 1=1
                                       THEN -- �������� ����� ����� ������� � ���
                                            zfCalc_CurrencyFrom (-- ����� ����� EUR
                                                                 FLOOR (-- �������� ������������� � EUR
                                                                        ABS (
                                                                        zfCalc_CurrencyTo (inAmountDiscount_GRN * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay
                                                                                         , inCurrencyValueEUR, inParValueEUR)
                                                                       ))
                                                               , inCurrencyValueEUR, inParValueEUR)
                                          -- !!!������� ����!!!
                                          * CASE WHEN inAmountDiscount_GRN < 0 THEN -1 ELSE 1 END


                                       WHEN FLOOR (inAmountDiscount_GRN) <> inAmountDiscount_GRN OR 1=1
                                       -- �������� �� 2-� ��.
                                       THEN ROUND (inAmountDiscount_GRN * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay, 2)

                                       -- ��������� ���.
                                       /*ELSE FLOOR (inAmountDiscount_GRN * _tmp_MI_Master.AmountToPay / vbTotalAmountToPay)*/

                                       ELSE 0

                                  END AS AmountDiscount_GRN

                                , ROW_NUMBER() OVER (ORDER BY _tmp_MI_Master.AmountToPay DESC) AS Ord

                           FROM _tmp_MI_Master
                         /*WHERE -- ����� ���� ��� ��������
                                 inAmountDiscount_GRN = vbTotalAmountToPay
                              OR -- ��� ����� ������ ����� ���
                                 FLOOR (zfCalc_CurrencyTo (inAmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR))
                               = zfCalc_CurrencyTo (inAmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR)
                              OR -- ��� ����� ������ ��� ����� 1EUR
                                 inAmountDiscount_GRN > zfCalc_CurrencyFrom (1, inCurrencyValueEUR, inParValueEUR)*/
                          )
         -- ��������� - �������������� ������ - �.�. ������� �� ���. ��� ����������
       , tmp_MI_Master AS (SELECT tmp_MI_Master_all.MovementItemId
                                  -- ����� � ������� - !!! ��� + EUR !!!
                                , tmp_MI_Master_all.AmountToPay
                                , tmp_MI_Master_all.AmountToPay_curr

                                  -- ���. ������ �� ��������� ����� ������� �� ���. ��� ���������� - !!! ��� !!!
                                , tmp_MI_Master_all.AmountDiscount_GRN
                                  - (CASE WHEN tmp_MI_Master_all.Ord = 1
                                               THEN (SELECT SUM (tmp_MI_Master_all.AmountDiscount_GRN) AS AmountDiscount_GRN FROM tmp_MI_Master_all)
                                                  - inAmountDiscount_GRN
                                          ELSE 0
                                     END) AS AmountDiscount_GRN

                                  -- ���. ������ �� ��������� ��� ������� - !!! ��� !!!
                                , tmp_MI_Master_all.AmountDiscount_GRN AS AmountDiscount_GRN_two_orig
                                  --
                                , tmp_MI_Master_all.Ord

                           FROM tmp_MI_Master_all
                          )
/*            -- 1.1. ������� ��� ������ EUR - � ������������� ������
          , tmp_MI_EUR AS (SELECT tmpMI.MovementItemId
                                  -- ����� � ������ ���. ������ - !!! ��� !!!
                                , tmpMI.Amount_all
                                  -- ����� � ������ ���. ������ - ��� ����. EUR - !!! ��� !!!
                                , tmpMI.Amount_calc
                                  -- ����� � !!! ��� !!! � ������ ���. ������ - ������������ ������� !!!0 ������!!! + � ����������� �����
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY ABS (tmpMI.AmountDiscount_GRN) ASC, tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM (SELECT tmpMI.MovementItemId
                                        -- ����� � ������ ���. ������ - !!! ��� !!!
                                      , tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN AS Amount_all

                                        -- ����� � ������ ���. ������ - ��� ����. EUR - !!! ��� !!!
                                      , CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND 1=0
                                                  -- ������� ����� ����� � ������ ...???
                                                  THEN zfCalc_CurrencyFrom (tmpMI.AmountToPay_curr - zfCalc_CurrencyTo (tmpMI.AmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR), inCurrencyValueEUR, inParValueEUR)
                                             --
                                           --WHEN inAmountGRN > 150 OR inAmountCard > 0
                                           --      -- ������� ��� ������� ����� ���, �.�. ��� ���������� �������
                                           --     THEN zfCalc_CurrencyFrom (-- ��������� � ������ + ��������� ���.
                                           --                               FLOOR (zfCalc_CurrencyTo (tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN, inCurrencyValueEUR, inParValueEUR))
                                           --                             , inCurrencyValueEUR, inParValueEUR)
                                             -- ???����� ������� ����� ����� � ������???
                                             ELSE tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN

                                        END AS Amount_calc
                                        -- ���. ������
                                      , tmpMI.AmountDiscount_GRN

                                 FROM tmp_MI_Master AS tmpMI
                                ) AS tmpMI
                          )
        -- 1.2. ������ EUR ��������� - !!! ��� !!!
      , tmp_MI_EUR_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR)  - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_EUR AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountEUR > 0
                          )
            -- 2.1. ������� ��� ������ USD - � ������������� ������
          , tmp_MI_USD AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all
                                , tmpMI.Amount_calc
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM (SELECT tmpMI.MovementItemId
                                      , tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) AS Amount_all
                                      , CASE WHEN inCurrencyId_Client = zc_Currency_EUR() AND 1=0
                                                  -- ������� ����� ����� � ������ ...???
                                                  THEN tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)
                                             --
                                             WHEN inAmountGRN > 155 OR inAmountCard > 0 OR 1=1
                                                  -- ������� ��� ������� ����� ���, �.�. ��� ���������� �������
                                                  THEN zfCalc_CurrencyFrom (FLOOR (zfCalc_CurrencyTo (tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0), vbCurrencyValueUSD, inParValueUSD))
                                                                          , vbCurrencyValueUSD, inParValueUSD)
                                             -- ����� ������� ����� ����� � ������
                                             ELSE tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)
                                        END AS Amount_calc
                                 FROM tmp_MI_EUR AS tmpMI
                                      LEFT JOIN tmp_MI_EUR_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                                ) AS tmpMI
                          )
        -- 2.2. ������ USD ��������� - !!! ��� !!!
      , tmp_MI_USD_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD)  - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_USD AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountUSD > 0
                          )*/


            -- 2.1. ������� ��� ������ USD - � ������������� ������
          , tmp_MI_USD AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all
                                , tmpMI.Amount_calc
                                  -- ���. ������
                                , tmpMI.AmountDiscount_GRN
                                  --
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY ABS (tmpMI.AmountDiscount_GRN) DESC, tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM

                                  -- � �/�
                                , ROW_NUMBER() OVER (ORDER BY ABS (tmpMI.AmountDiscount_GRN) DESC, tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Ord

                           FROM (SELECT tmpMI.MovementItemId
                                        -- ����� � ������ ���. ������ - !!! ��� !!!
                                      , tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN AS Amount_all

                                      , CASE /*WHEN inCurrencyId_Client = zc_Currency_EUR() AND 1=0
                                                  -- ������� ����� ����� � ������ ...???
                                                  THEN zfCalc_CurrencyFrom (tmpMI.AmountToPay_curr - zfCalc_CurrencyTo (tmpMI.AmountDiscount_GRN, vbCurrencyValueUSD, inParValueUSD), vbCurrencyValueUSD, inParValueUSD)*/
                                             --
                                             WHEN inAmountGRN > 155 OR inAmountCard > 0 OR 1=1
                                                  -- ������� ��� ������� ����� ���, �.�. ��� ���������� �������
                                                  THEN zfCalc_CurrencyFrom (-- ��������� � ������ + ��������� ���.
                                                                          --FLOOR (zfCalc_CurrencyTo (tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN, vbCurrencyValueUSD, inParValueUSD))
                                                                            ROUND (zfCalc_CurrencyTo (tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN, vbCurrencyValueUSD, inParValueUSD), 0)
                                                                          , vbCurrencyValueUSD, inParValueUSD)

                                             -- ???����� ������� ����� ����� � ������???
                                             ELSE tmpMI.AmountToPay - tmpMI.AmountDiscount_GRN

                                        END AS Amount_calc
                                        -- ���. ������
                                      , tmpMI.AmountDiscount_GRN

                                 FROM tmp_MI_Master AS tmpMI
                                    --LEFT JOIN tmp_MI_EUR_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                                ) AS tmpMI
                          )
       -- 2.2. ������ USD ��������� - !!! ��� !!!
     , tmp_MI_USD_res2 AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD)  - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount

                                , CASE WHEN zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD)  - DD.Amount_SUM > 0
                                       -- �������� ���������, ��������� ������
                                       THEN DD.Amount_all - DD.Amount_calc
                                       -- �������� ��������
                                       ELSE 0

                                  END AS AmountDiscount_GRN_add

                                  -- ������������ - ������� ��������
                                , DD.Amount_SUM

                                , DD.Ord

                           FROM tmp_MI_USD AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountUSD > 0
                          )
        -- 2.3.1. ������������ ���� ����� �� ����� ����������
      , tmpDiscount_USD_add AS (SELECT MAX (tmp.Ord) AS Ord
                                     , SUM (tmp.AmountDiscount_GRN_add) AS AmountDiscount_GRN_add
                                FROM tmp_MI_USD_res2 AS tmp
                               )
        -- 2.3.2. ������ USD ��������� - !!! ��� !!!
      , tmp_MI_USD_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                  -- ������� �������� �� ��������
                                , DD.Amount
                                  -- ������������ ������ - ��� ��� ��������� � ���������� ��������� - ����� ��������
                                , DD.AmountDiscount_GRN_add
                                - CASE WHEN tmp.Ord > 0
                                       -- ������������, ��� � ������������
                                       THEN COALESCE (tmp.AmountDiscount_GRN_add, 0)
                                       ELSE 0
                                  END AS AmountDiscount_GRN_add
                                  -- ������������ - ������� ��������
                                , DD.Amount_SUM

                           FROM tmp_MI_USD_res2 AS DD
                                -- ����������, ����� ������ �����
                                LEFT JOIN tmpDiscount_USD_add AS tmp ON tmp.Ord = DD.Ord
                          )

            -- 1.1. ������� ��� ������ EUR - � ������������� ������
          , tmp_MI_EUR AS (SELECT tmpMI.MovementItemId
                                  -- ����� � ������ ���. ������ - !!! ��� !!!
                                , tmpMI.Amount_all
                                  -- ����� � ������ ���. ������ - ��� ����. EUR - !!! ��� !!!
                                , tmpMI.Amount_calc
                                  -- ����� � !!! ��� !!! � ������ ���. ������ - ������������ ������� !!!0 ������!!! + � ����������� �����
                                , SUM (tmpMI.Amount_calc) OVER (ORDER BY ABS (tmpMI.AmountDiscount_GRN) ASC, tmpMI.Amount_all ASC, tmpMI.MovementItemId ASC) AS Amount_SUM

                           FROM (SELECT tmpMI.MovementItemId

                                      , tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) - COALESCE (tmpRes.AmountDiscount_GRN_add, 0) AS Amount_all

                                        -- ����� � ������ ���. ������ - ��� ����. EUR - !!! ��� !!!
                                      , CASE /*WHEN inCurrencyId_Client = zc_Currency_EUR() AND 1=0
                                                  -- ������� ����� ����� � ������ ...???
                                                  THEN tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)*/
                                             --
                                             WHEN inAmountGRN > 150 OR inAmountCard > 0
                                                   -- ������� ��� ������� ����� ���, �.�. ��� ���������� �������
                                                  THEN zfCalc_CurrencyFrom (-- ��������� � ������ + ��������� ���.
                                                                            FLOOR (zfCalc_CurrencyTo (tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) - COALESCE (tmpRes.AmountDiscount_GRN_add, 0), inCurrencyValueEUR, inParValueEUR))
                                                                          , inCurrencyValueEUR, inParValueEUR)

                                             -- ����� ������� ����� ����� � ������
                                             ELSE tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) - COALESCE (tmpRes.AmountDiscount_GRN_add, 0)

                                        END AS Amount_calc
                                        -- ���. ������
                                      , tmpMI.AmountDiscount_GRN + COALESCE (tmpRes.AmountDiscount_GRN_add, 0) AS AmountDiscount_GRN

                                 FROM tmp_MI_USD AS tmpMI
                                      LEFT JOIN tmp_MI_USD_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                                ) AS tmpMI
                          )
        -- 1.2. ������ EUR ��������� - !!! ��� !!!
      , tmp_MI_EUR_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR)  - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_EUR AS DD
                           WHERE zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountEUR > 0
                          )



            -- 3.1. ������� ��� ������ ��� - � ������������� ������
          , tmp_MI_GRN AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_all - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_EUR AS tmpMI
                                LEFT JOIN tmp_MI_EUR_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
        -- 3.2. ������ ��� ���������
      , tmp_MI_GRN_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN inAmountGRN - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE inAmountGRN - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_GRN AS DD
                           WHERE inAmountGRN - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountGRN > 0
                          )
           -- 4.1. ������� ��� ������ �� ��� - � ������������� ������
         , tmp_MI_Card AS (SELECT tmpMI.MovementItemId
                                , tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) AS Amount_calc
                                , SUM (tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0)) OVER (ORDER BY tmpMI.Amount_calc - COALESCE (tmpRes.Amount, 0) ASC, tmpMI.MovementItemId ASC) AS Amount_SUM
                           FROM tmp_MI_GRN AS tmpMI
                                LEFT JOIN tmp_MI_GRN_res AS tmpRes ON tmpRes.MovementItemId = tmpMI.MovementItemId
                          )
       -- 4.2. ������ �� ��� ���������
     , tmp_MI_Card_res AS (
                           -- ��������� � ���
                           SELECT DD.MovementItemId
                                , CASE WHEN inAmountCard - DD.Amount_SUM > 0
                                       -- �������� ���������
                                       THEN DD.Amount_calc
                                       -- �������� ��������
                                       ELSE inAmountCard - (DD.Amount_SUM - DD.Amount_calc)

                                  END AS Amount
                                , DD.Amount_SUM
                           FROM tmp_MI_Card AS DD
                           WHERE inAmountCard - (DD.Amount_SUM - DD.Amount_calc) > 0
                             AND inAmountCard > 0
                          )
            -- 5. ������� - ��������� - !!!��� � ��� !!!
          , tmp_MI_res AS (SELECT tmp_MI_Master.MovementItemId

                                  -- ����� � ������� - !!! ��� + EUR !!!
                                , tmp_MI_Master.AmountToPay - tmp_MI_Master.AmountDiscount_GRN - COALESCE (tmp_MI_USD_res.AmountDiscount_GRN_add, 0) AS AmountToPay
                              --, tmp_MI_Master.AmountToPay_curr - zfCalc_CurrencyTo (tmp_MI_Master.AmountDiscount_GRN + COALESCE (tmp_MI_USD_res.AmountDiscount_GRN_add, 0), inCurrencyValueEUR, inParValueEUR) AS AmountToPay_curr
                                , zfCalc_CurrencyTo (tmp_MI_Master.AmountToPay - tmp_MI_Master.AmountDiscount_GRN - COALESCE (tmp_MI_USD_res.AmountDiscount_GRN_add, 0), inCurrencyValueEUR, inParValueEUR) AS AmountToPay_curr

                                  -- ���. ������ - !!! ��� + EUR !!!
                                , tmp_MI_Master.AmountDiscount_GRN + COALESCE (tmp_MI_USD_res.AmountDiscount_GRN_add, 0) AS AmountDiscount
                                , ROUND (zfCalc_CurrencyTo (tmp_MI_Master.AmountDiscount_GRN + COALESCE (tmp_MI_USD_res.AmountDiscount_GRN_add, 0), inCurrencyValueEUR, inParValueEUR), 4) AS AmountDiscount_curr

                                  --
                                , COALESCE (tmp_MI_GRN_res.Amount, 0)  AS Amount_GRN
                                , COALESCE (tmp_MI_Card_res.Amount, 0) AS Amount_Card
                                , COALESCE (tmp_MI_EUR_res.Amount, 0)  AS Amount_EUR_grn
                                , COALESCE (tmp_MI_USD_res.Amount, 0)  AS Amount_USD_grn

                           FROM tmp_MI_Master
                                LEFT JOIN tmp_MI_GRN_res  ON tmp_MI_GRN_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_Card_res ON tmp_MI_Card_res.MovementItemId = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_EUR_res  ON tmp_MI_EUR_res.MovementItemId  = tmp_MI_Master.MovementItemId
                                LEFT JOIN tmp_MI_USD_res  ON tmp_MI_USD_res.MovementItemId  = tmp_MI_Master.MovementItemId
                          )
    -- 6.0. �������� ...
  , tmp_Currency_ROUND AS (SELECT tmp_MI_res.Amount_EUR_grn - zfCalc_CurrencyFrom (-- ��������� � ������ + �������� �� 2-� ��.
                                                                                   ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                                                                 , inCurrencyValueEUR, inParValueEUR) AS Amount_EUR_grn
                                , tmp_MI_res.Amount_USD_grn - zfCalc_CurrencyFrom (-- ��������� � ������ + �������� �� 2-� ��.
                                                                                   ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD), 2)
                                                                                 , vbCurrencyValueUSD, inParValueUSD) AS Amount_USD_grn
                           FROM tmp_MI_res
                          )
      -- 6.1. �������� �������� ����� ������ � ������ - !!!��� �� ������ ��������� ���� �� ���!!! + "��������" � ���
    , tmp_Currency_all AS (SELECT tmp_MI_res.MovementItemId
                                  -- ����� EUR � ���
                                , tmp_MI_res.Amount_EUR_grn - zfCalc_CurrencyFrom (-- ��������� � ������ + ��������� ���. ��� ��������� ���.
                                                                                   CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                                                                        THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                                                                        ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR))
                                                                                           / 100
                                                                                   END
                                                                                 , inCurrencyValueEUR, inParValueEUR) AS Amount_EUR_grn

                                  -- ��������� ����� EUR � ��� -> � USD
                                , CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                       THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR), 2)
                                       ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR))
                                          / 100
                                  END AS Amount_EUR

                                  -- ����� USD � ���
                                , tmp_MI_res.Amount_USD_grn - zfCalc_CurrencyFrom (-- ��������� � ������ + ��������� ���. ��� ��������� ���.
                                                                                   CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                                                                        THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD), 2)
                                                                                        ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD))
                                                                                           / 100
                                                                                   END
                                                                                 , vbCurrencyValueUSD, inParValueUSD) AS Amount_USD_grn

                                  -- ��������� ����� USD � ��� -> � USD
                                , CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_ROUND AS tmp) = 0
                                       THEN ROUND (zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD), 2)
                                       ELSE FLOOR (100 * zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD))
                                          / 100
                                  END AS Amount_USD


                           FROM tmp_MI_res
                          )
          -- 6.2. �������� �������� ����� - ��������� "��������" � ��� ���� �� ��� ����� = 0
        , tmp_Currency AS (SELECT tmp_Currency_all.MovementItemId
                                , CASE WHEN (SELECT SUM (tmp.Amount_EUR_grn) FROM tmp_Currency_all AS tmp) = 0 THEN 0 ELSE tmp_Currency_all.Amount_EUR_grn END AS Amount_EUR_grn
                                , tmp_Currency_all.Amount_EUR
                                , CASE WHEN (SELECT SUM (tmp.Amount_USD_grn) FROM tmp_Currency_all AS tmp) = 0 THEN 0 ELSE tmp_Currency_all.Amount_USD_grn END AS Amount_USD_grn
                                , tmp_Currency_all.Amount_USD
                           FROM tmp_Currency_all
                          )
            -- 7. �������� ������ - ������ ��� + ������ ������
          , tmp_Change AS (-- �� "���������" ������
                           SELECT  1 * SUM (tmp_Currency.Amount_EUR_grn) AS Amount_EUR_grn
                                ,  1 * SUM (tmp_Currency.Amount_USD_grn) AS Amount_USD_grn
                                , zfCalc_CurrencyTo (SUM (tmp_Currency.Amount_EUR_grn), inCurrencyValueEUR, inParValueEUR) AS Amount_EUR
                                , zfCalc_CurrencyTo (SUM (tmp_Currency.Amount_USD_grn), vbCurrencyValueUSD, inParValueUSD) AS Amount_USD
                           FROM tmp_Currency
                          UNION ALL
                           -- �� ����� ����� � ������
                           SELECT  1 * (zfCalc_CurrencyFrom (inAmountEUR, inCurrencyValueEUR, inParValueEUR) - tmp.Amount_EUR_grn) AS Amount_EUR_grn
                                ,  1 * (zfCalc_CurrencyFrom (inAmountUSD, vbCurrencyValueUSD, inParValueUSD) - tmp.Amount_USD_grn) AS Amount_USD_grn

                                , inAmountEUR - zfCalc_CurrencyTo (tmp.Amount_EUR_grn, inCurrencyValueEUR, inParValueEUR) AS Amount_EUR
                                , inAmountUSD - zfCalc_CurrencyTo (tmp.Amount_USD_grn, vbCurrencyValueUSD, inParValueUSD) AS Amount_USD
                           FROM -- ����� � ��� - 1 ������
                                (SELECT SUM (tmp_MI_res.Amount_EUR_grn) AS Amount_EUR_grn
                                      , SUM (tmp_MI_res.Amount_USD_grn) AS Amount_USD_grn
                                 FROM tmp_MI_res
                                ) AS tmp
                          )
           -- 8. ������ - Child
         , tmpMI_Child AS (SELECT MovementItem.Id                     AS MovementItemId
                                , COALESCE (MovementItem.ParentId, 0) AS ParentId
                                , MovementItem.ObjectId               AS CashId
                           FROM MovementItem
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Child()
                             AND MovementItem.isErased   = FALSE
                          )
       -- 1.1. ��������� : GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

              -- ����� � ������ �������������� ������
            , tmp_MI_res.AmountToPay         :: TFloat AS AmountToPay
            , tmp_MI_res.AmountToPay_curr    :: TFloat AS AmountToPay_curr
              -- �������������� ������
            , tmp_MI_res.AmountDiscount      :: TFloat AS AmountDiscount
            , tmp_MI_res.AmountDiscount_curr :: TFloat AS AmountDiscount_curr

            , (tmp_MI_res.Amount_GRN + COALESCE (tmp_Currency.Amount_EUR_grn, 0)  + COALESCE (tmp_Currency.Amount_USD_grn, 0)) :: TFloat AS Amount
            , tmp_MI_res.Amount_GRN          :: TFloat AS Amount_GRN
            , zfCalc_CurrencyTo (tmp_MI_res.Amount_GRN, inCurrencyValueEUR, inParValueEUR) :: TFloat AS Amount_EUR

            , 0 :: TFloat  AS CurrencyValue
            , 0 :: TFloat  AS ParValue
            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR (tmp_MI_res.Amount_GRN + COALESCE (tmp_Currency.Amount_EUR_grn, 0)  + COALESCE (tmp_Currency.Amount_USD_grn, 0)) <> 0
          OR tmp_MI_res.Amount_GRN          <> 0
          OR tmp_MI_res.AmountDiscount      <> 0
          OR tmp_MI_res.AmountDiscount_curr <> 0

      UNION ALL
       -- 1.2. ��������� : GRN - Card
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

              -- ����� � ������ �������������� ������
            , tmp_MI_res.AmountToPay         :: TFloat AS AmountToPay
            , tmp_MI_res.AmountToPay_curr    :: TFloat AS AmountToPay_curr
              -- �������������� ������
            , tmp_MI_res.AmountDiscount      :: TFloat AS AmountDiscount
            , tmp_MI_res.AmountDiscount_curr :: TFloat AS AmountDiscount_curr

            , tmp_MI_res.Amount_Card         :: TFloat AS Amount
            , tmp_MI_res.Amount_Card         :: TFloat AS Amount_GRN
            , zfCalc_CurrencyTo (tmp_MI_res.Amount_Card, inCurrencyValueEUR, inParValueEUR) :: TFloat AS Amount_EUR

            , 0 :: TFloat  AS CurrencyValue
            , 0 :: TFloat  AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_GRN() AND tmpCash.isBankAccount = TRUE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp_MI_res.Amount_Card     <> 0

      UNION ALL
       -- 1.3. ��������� : EUR
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , tmp_MI_res.AmountToPay         :: TFloat AS AmountToPay
            , tmp_MI_res.AmountToPay_curr    :: TFloat AS AmountToPay_curr            , tmp_MI_res.AmountDiscount      :: TFloat AS AmountDiscount
            , tmp_MI_res.AmountDiscount_curr :: TFloat AS AmountDiscount_curr

            , COALESCE (tmp_Currency.Amount_EUR, 0) :: TFloat AS Amount
            , tmp_MI_res.Amount_EUR_GRN             :: TFloat AS Amount_GRN
            , COALESCE (tmp_Currency.Amount_EUR, 0) :: TFloat AS Amount_EUR

            , inCurrencyValueEUR AS CurrencyValue
            , inParValueEUR      AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_EUR()
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
     -- ����., �.�. ����� ���� EUR
     --WHERE tmpMI_Child.MovementItemId > 0
     --   OR tmp_Currency.Amount_EUR    <> 0

      UNION ALL
       -- 1.4. ��������� : USD
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , tmp_MI_res.MovementItemId  AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

              -- ����� � ������ �������������� ������
            , tmp_MI_res.AmountToPay         :: TFloat AS AmountToPay
            , tmp_MI_res.AmountToPay_curr    :: TFloat AS AmountToPay_curr
              -- �������������� ������
            , tmp_MI_res.AmountDiscount      :: TFloat AS AmountDiscount
            , tmp_MI_res.AmountDiscount_curr :: TFloat AS AmountDiscount_curr

            , COALESCE (tmp_Currency.Amount_USD, 0) :: TFloat AS Amount
            , tmp_MI_res.Amount_USD_GRN             :: TFloat AS Amount_GRN
            , zfCalc_CurrencyTo (tmp_MI_res.Amount_USD_GRN, inCurrencyValueEUR, inParValueEUR) :: TFloat AS Amount_EUR

              -- !!!������� ��� ����!!!
            , inCurrencyValueUSD :: TFloat AS CurrencyValue
            , inParValueUSD                AS ParValue

            , 0 :: Integer AS CashId_Exc

       FROM tmp_MI_res
            LEFT JOIN tmp_Currency ON tmp_Currency.MovementItemId = tmp_MI_res.MovementItemId
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_USD()
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = tmp_MI_res.MovementItemId
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp_Currency.Amount_USD    <> 0

      UNION ALL
       -- 2.1. ��������� : Exchange EUR -> GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , 0                          AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountToPay_curr
            , 0 :: TFloat AS AmountDiscount
            , 0 :: TFloat AS AmountDiscount_curr

            , tmp.Amount_EUR     :: TFloat AS Amount
            , tmp.Amount_EUR_grn :: TFloat AS Amount_GRN
            , 0                  :: TFloat AS Amount_EUR

            , inCurrencyValueEUR           AS CurrencyValue
            , inParValueEUR                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_Exc

       FROM (SELECT SUM (tmp_Change.Amount_EUR) AS Amount_EUR, SUM (tmp_Change.Amount_EUR_grn) AS Amount_EUR_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_EUR()
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
            -- LEFT JOIN !!!���� �� ��� ������� ���  zc_MILinkObject_Cash!!!
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp.Amount_EUR             <> 0
          OR tmp.Amount_EUR_grn         <> 0

      UNION ALL
       -- 2.2. ��������� : Exchange USD -> GRN
       SELECT tmpMI_Child.MovementItemId AS MovementItemId
            , 0                          AS ParentId
            , tmpCash.CashId
            , tmpCash.CurrencyId

            , 0 :: TFloat AS AmountToPay
            , 0 :: TFloat AS AmountToPay_curr
            , 0 :: TFloat AS AmountDiscount
            , 0 :: TFloat AS AmountDiscount_curr

            , tmp.Amount_USD     :: TFloat AS Amount
            , tmp.Amount_USD_grn :: TFloat AS Amount_GRN
            , 0                  :: TFloat AS Amount_EUR

              -- !!!������� ��� ����!!!
            , inCurrencyValueUSD :: TFloat AS CurrencyValue
            , inParValueUSD                AS ParValue
            , tmpCash_ch.CashId :: Integer AS CashId_Exc

       FROM (SELECT SUM (tmp_Change.Amount_USD) AS Amount_USD, SUM (tmp_Change.Amount_USD_grn) AS Amount_USD_grn FROM tmp_Change) AS tmp
            LEFT JOIN tmpCash ON tmpCash.CurrencyId = zc_Currency_USD() AND tmpCash.isBankAccount = FALSE
            LEFT JOIN tmpCash AS tmpCash_ch ON tmpCash_ch.CurrencyId = zc_Currency_GRN() AND tmpCash_ch.isBankAccount = FALSE
            LEFT JOIN tmpMI_Child ON tmpMI_Child.ParentId = 0
                                 AND tmpMI_Child.CashId   = tmpCash.CashId
            -- LEFT JOIN !!!���� �� ��� ������� ���  zc_MILinkObject_Cash!!!
       WHERE tmpMI_Child.MovementItemId > 0
          OR tmp.Amount_USD             <> 0
          OR tmp.Amount_USD_grn         <> 0
      ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.17         *
*/

-- ����
/*
--WITH tmp AS (SELECT * FROM lpSelect_MI_Child_calc (inMovementId:= 10102, inUnitId:= 6318 , inAmountGRN := 0 , inAmountUSD := 500 , inAmountEUR := 580 , inAmountCARD := 0 , inAmountDiscount_GRN := 0.56 , vbCurrencyValueUSD := 28 , inParValueUSD := 1 , inCurrencyValueEUR := 32.33 , inParValueEUR := 1, inCurrencyValueCross:= 1, inParValueCross:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inUserId:= zfCalc_UserAdmin() :: Integer))
WITH tmp AS (SELECT * FROM lpSelect_MI_Child_calc (inMovementId:= 10102, inUnitId:= 6318 , inAmountGRN := 0 , inAmountUSD := 500 , inAmountEUR := 580 , inAmountCARD := 0 , inAmountDiscount_GRN := 0.56 , vbCurrencyValueUSD := 28 , inParValueUSD := 1 , inCurrencyValueEUR := 32.33 , inParValueEUR := 1, inCurrencyValueCross:= 1, inParValueCross:= 1, inCurrencyId_Client:= zc_Currency_EUR(), inUserId:= zfCalc_UserAdmin() :: Integer))
SELECT tmpAll.ParentId, tmp_GRN.Amount AS Amount_GRN, tmp_Card.Amount AS Amount_Card, tmp_EUR.Amount AS Amount_EUR, tmp_EUR.Amount_GRN AS Amount_EUR_GRN, tmp_EUR.CurrencyId AS Id_EUR, tmp_USD.Amount AS Amount_USD, tmp_USD.Amount_GRN AS Amount_USD_GRN, tmp_USD.CurrencyId AS Id_USD, tmp_EUR.CurrencyValue, tmp_EUR.ParValue, tmp_USD.CurrencyValue, tmp_USD.ParValue, tmp_EUR.CashId_Exc AS CashId_Exc_fromEUR, tmp_USD.CashId_Exc AS CashId_Exc_fromUSD
FROM (SELECT DISTINCT tmp.ParentId FROM tmp) AS tmpAll
     LEFT JOIN tmp AS tmp_GRN  ON tmp_GRN.ParentId  = tmpAll.ParentId AND tmp_GRN.CurrencyId  = zc_Currency_GRN() AND COALESCE (tmp_GRN.CashId, 0)      IN (SELECT Id FROM Object WHERE DescId = zc_Object_Cash())
     LEFT JOIN tmp AS tmp_Card ON tmp_Card.ParentId = tmpAll.ParentId AND tmp_Card.CurrencyId = zc_Currency_GRN() AND COALESCE (tmp_Card.CashId, 0) NOT IN (SELECT Id FROM Object WHERE DescId = zc_Object_Cash())
     LEFT JOIN tmp AS tmp_EUR  ON tmp_EUR.ParentId  = tmpAll.ParentId AND tmp_EUR.CurrencyId = zc_Currency_EUR()
     LEFT JOIN tmp AS tmp_USD  ON tmp_USD.ParentId  = tmpAll.ParentId AND tmp_USD.CurrencyId = zc_Currency_USD()
ORDER BY 1
*/
-- select * from gpInsertUpdate_MI_Sale_Child(inMovementId := 10102 , inParentId := 0 , inAmountGRN := 0 , inAmountUSD := 500 , inAmountEUR := 580 , inAmountCARD := 0 , inAmountDiscount := 0.56 , vbCurrencyValueUSD := 28 , inParValueUSD := 1 , inCurrencyValueEUR := 32.33 , inParValueEUR := 1 , inSession := '2');
