-- Function: gpInsertUpdate_MovementItem_SalePodium_update()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium_update (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SalePodium_update(
 INOUT ioId                             Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                     Integer   , -- ���� ������� <��������>
 INOUT ioGoodsId                        Integer   , -- *** - �����
    IN inPartionId                      Integer   , -- ������
 INOUT ioDiscountSaleKindId             Integer   , -- *** - ��� ������ ��� �������
    IN inIsPay                          Boolean   , -- �������� � �������
 INOUT ioAmount                         TFloat    , -- ����������
 INOUT ioChangePercent                  TFloat    , -- *** - % ������
                                        
 INOUT ioSummChangePercent              TFloat    , -- *** - �������������� ������ � ������� ���
 INOUT ioSummChangePercent_curr         TFloat    , -- *** - �������������� ������ � ������� � ������***
                                       
 INOUT ioOperPriceList                  TFloat    , -- *** - ���� ���� ���

    IN inSession                        TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate      TDateTime;
--   DECLARE vbCurrencyId    Integer;
   DECLARE vbCurrencyId_pl Integer;
   DECLARE vbUnitId        Integer;
   DECLARE vbUnitId_user   Integer;
   DECLARE vbClientId      Integer;
--   DECLARE vbCashId        Integer;

   DECLARE vbPriceListId        Integer; -- *����� ��������, ����� ���� ��� � ��� ��� � � ������
   DECLARE vbCurrencyValue_pl   TFloat;  -- *���� ��� �������� �� ������ ������ � ���
   DECLARE vbParValue_pl        TFloat;  -- *������� ��� �������� �� ������ ������ � ���
   DECLARE vbOperPriceList_pl   TFloat;  -- *���� �� ������ - ��������� � ���
   DECLARE vbOperPriceList_curr TFloat;  -- *���� �� ������ - � ��� ������ ��� ����

   DECLARE vbIsOperPriceListReal Boolean; -- �����

--   DECLARE outCountForPrice TFloat;
  --  DECLARE outCountForPrice TFloat;

   DECLARE outTotalSummPriceList            TFloat    ; -- +����� �� ������ � ���
   DECLARE outTotalSummPriceList_curr       TFloat    ; -- +����� �� ������ � ������***

   DECLARE outTotalChangePercent            TFloat    ; -- *+����� ������ � ������� ���
   DECLARE outTotalChangePercent_curr       TFloat    ; -- *+����� ������ � ������� � ������***

   DECLARE outTotalChangePercentPay         TFloat    ; -- *�������������� ������ � �������� ���
   DECLARE outTotalChangePercentPay_curr    TFloat    ; -- *�������������� ������ � ������***

--   DECLARE outTotalPay                      TFloat    ; -- *+����� ������ � ������� ���
  -- DECLARE outTotalPay_curr                 TFloat    ; -- *+����� ������ � ������� � ������***

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);

     
     -- �����
     vbIsOperPriceListReal:= TRUE;

     -- ������
     inIsPay:= TRUE;


     -- ��������� �� ���������
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_From.ObjectId, 0)            AS UnitId
          , COALESCE (MovementLinkObject_To.ObjectId, 0)              AS ClientId
            -- ����� ��� ��������, ���� ����������
          , COALESCE (OL_pl.ChildObjectId, zc_PriceList_Basis())      AS PriceListId
            INTO vbOperDate, vbUnitId, vbClientId, vbPriceListId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MovementLinkObject_From.ObjectId
                                         AND OL_pl.DescId   = zc_ObjectLink_Unit_PriceList()
     WHERE Movement.Id = inMovementId;


     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�������������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbPriceListId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����-����>.';
     END IF;
     -- �������� - ������������
     IF vbUnitId_user > 0 AND vbUnitId_user <> vbUnitId THEN
        RAISE EXCEPTION '������.��� ���� ��������� �������� ��� ������������� <%>.', lfGet_Object_ValueData_sh (vbUnitId);
     END IF;


     -- �� ������� - ���� � ������
     SELECT lpGet.ValuePrice, lpGet.CurrencyId
             INTO vbOperPriceList_curr, vbCurrencyId_pl
     FROM lpGet_ObjectHistory_PriceListItem (vbOperDate, vbPriceListId, ioGoodsId) AS lpGet;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbOperPriceList_curr, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ������� �������� <���� (�����)>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbCurrencyId_pl, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ������� �������� <������ (�����)>.';
     END IF;

     
     -- ������ �� ������ : GoodsId � OperPrice � CountForPrice � CurrencyId
     SELECT Object_PartionGoods.GoodsId                                    AS GoodsId
    --      , COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
  --        , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
--          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO ioGoodsId -- , outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;

/*
     -- ���� ��.���� �� � ������� ������
     IF COALESCE (vbCurrencyId, 0) <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                INTO outCurrencyValue, outParValue
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                               , inCurrencyToId  := vbCurrencyId
                                                ) AS tmp;
         -- ��������
         IF COALESCE (vbCurrencyId, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <������>.';
         END IF;
         -- ��������
         IF COALESCE (outCurrencyValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <����>.';
         END IF;
         -- ��������
         IF COALESCE (outParValue, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
         END IF;

     ELSE
         -- ���� �� �����
         outCurrencyValue:= 0;
         outParValue     := 0;
     END IF;
     */

     -- ������, � �� ������ - ���� ���� ������ �� � ������� ������
     IF 1=1 OR COALESCE (vbCurrencyId_pl, 0) <> zc_Currency_Basis()
     THEN
         -- ���������� ���� �� ���� ���������
         SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                INTO vbCurrencyValue_pl, vbParValue_pl
         FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                               , inCurrencyFromId:= zc_Currency_Basis()
                                                 -- !!! �������� - zc_Currency_EUR !!!
                                               , inCurrencyToId  := zc_Currency_EUR() -- vbCurrencyId_pl
                                                ) AS tmp;
         -- ��������
         IF COALESCE (vbCurrencyValue_pl, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <����>.';
         END IF;
         -- ��������
         IF COALESCE (vbParValue_pl, 0) = 0 THEN
            RAISE EXCEPTION '������.�� ���������� �������� <�������>.';
         END IF;

     ELSE
         -- ���� �� �����
         vbCurrencyValue_pl:= 0;
         vbParValue_pl     := 0;
     END IF;



     -- ������
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
         FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

     ELSEIF EXISTS (SELECT 1
                    FROM Object_PartionGoods
                         LEFT JOIN ObjectLink AS ObjectLink_Partner_Period
                                              ON ObjectLink_Partner_Period.ObjectId      = Object_PartionGoods.PartnerId
                                             AND ObjectLink_Partner_Period.DescId        = zc_ObjectLink_Partner_Period()
             
                         LEFT JOIN ObjectFloat AS ObjectFloat_PeriodYear
                                               ON ObjectFloat_PeriodYear.ObjectId = Object_PartionGoods.PartnerId
                                              AND ObjectFloat_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
                    WHERE Object_PartionGoods.MovementItemId = inPartionId
                      AND ((ObjectLink_Partner_Period.ChildObjectId = 1074 -- �����-����
                        AND ObjectFloat_PeriodYear.ValueData = 2020
                           )
                        OR ObjectFloat_PeriodYear.ValueData > 2020
                          )
                   )
         THEN
             SELECT tmp.ChangePercent, tmp.DiscountSaleKindId INTO ioChangePercent, ioDiscountSaleKindId
             FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;

     ioChangePercent :=  COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.DescId = zc_MIFloat_ChangePercent() AND MIF.MovementItemId = ioId), 0);

     ELSE
         ioChangePercent     := 0;
         ioDiscountSaleKindId:= 9; -- ��� ������
     END IF;


     -- ���� (�����)
     IF zc_Enum_GlobalConst_isTerry() = TRUE
     THEN
         RAISE EXCEPTION '������.zc_Enum_GlobalConst_isT... = TRUE';

     ELSE 
          -- �������� - �������� ������ ���� �����������
          IF COALESCE (ioOperPriceList, 0) <= 0 THEN
             RAISE EXCEPTION '������.�� ������� �������� <���� ���� ���>.';
          END IF;

          -- *���� �� ������ - ��� ������� ����� ������
          IF vbCurrencyId_pl <> zc_Currency_Basis()
          THEN
              -- ��������� � ���
              vbOperPriceList_pl:= zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl));
          ELSE
              -- ��� � ������ � ���
              vbOperPriceList_pl:= vbOperPriceList_curr;
              -- !!! �������� - � ����� ���� � zc_Currency_EUR !!!
              vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl));
          END IF;

          -- ���� � ��� �� ������� �� ������� - ������ ����� INSERT
          IF COALESCE (ioId, 0) = 0 AND vbIsOperPriceListReal = TRUE
          THEN
              -- �� ����� ���� ������������ � ���� ��� ���� ���� ���
              ioOperPriceList := zfCalc_SummChangePercent (1, vbOperPriceList_pl, ioChangePercent);
          END IF;
     
     END IF;


                 -- ��������� ���� PriceListReal
                 ioSummChangePercent     := zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl, ioChangePercent)
                                          - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                 --
                 ioSummChangePercent_curr:= zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent)
                                            -- !!! �������� - zc_Currency_EUR !!!
                                          - zfCalc_SummPriceList (ioAmount, zfCalc_CurrencySumm (ioOperPriceList, zc_Currency_Basis(), zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl));




     -- ������� ����� ��. � ������, ��� ����� - ��������� �� 2-� ������
--     outTotalSumm := zfCalc_SummIn (ioAmount, outOperPrice, outCountForPrice);
     -- ������� ����� ��. � ��� �� ��������, ��� �����
--     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList := zfCalc_SummPriceList (ioAmount, vbOperPriceList_pl);
     -- ��������� ����� �� ������ �� ��������, ��� �����
     outTotalSummPriceList_curr := zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);

     -- ��������� ����� ������ � ������� ���, ��� ����� - !!!��������� �� ���� ������ - ������ %, ��� ��������� - ������!!!
     IF vbIsOperPriceListReal = FALSE
     THEN
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent,      0);
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
     ELSE
         -- !!!�����!!!
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_pl,   ioChangePercent) + COALESCE (ioSummChangePercent, 0);
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercent (ioAmount, vbOperPriceList_curr, ioChangePercent) + COALESCE (ioSummChangePercent_curr, 0);
     END IF;

/*
     -- ������� ����� ������ � ������� ���, ��� �����
     IF inIsPay = TRUE
     THEN
         outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
     ELSE
         outTotalPay      := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()),      0);
         outTotalPay_curr := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay_curr()), 0);
     END IF;


     -- ������� ����� � ������
     outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
     outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;

     -- ������� ����� ����� � ������� ���
     outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
     outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;

*/


     -- ���������
     -- ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                    := ioId

     -- ��������� - ���� �����
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList(), ioId, vbOperPriceList_pl);

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), ioId, ioChangePercent);

     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent(), ioId, outTotalChangePercent);


     -- ��������� - ���� ���� ���
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId, CASE WHEN ioAmount <> 0 THEN (COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0)) / ioAmount ELSE 0 END);


     -- ��������� - ���� ����� (� ������) - !!! �������� - zc_Currency_EUR!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList_curr(), ioId, vbOperPriceList_curr);
     -- ��������� - ������ (���� ������) - � ����� ������ ���� ���� ������, ��� � �������� ������ �� �������� ������ �� �����������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency_pl(), ioId, vbCurrencyId_pl);
         
     -- ��������� - 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), ioId, COALESCE (outTotalChangePercent_curr, 0));



         -- � ������ �������� - �������������� ������ � ������� ��� - �.�. ����� ��������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));
         -- � ������ �������� - �������������� ������ � ������� � ���  - �.�. ����� ��������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(), ioId, COALESCE (ioSummChangePercent_curr, 0));

         -- � ������ �������� - ����� ������ � ������� ���
--         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      ioId, outTotalPay);
  --       PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), ioId, outTotalPay_curr);

         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


     -- "������" ����������� "��������" ����� �� ��������
     PERFORM lpUpdate_MI_Sale_Total (ioId);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.17         *
 28.06.17         *
 13.16.17         *
 09.05.17         *
 10.04.17         *
*/

-- ����
/*
select 
   gpInsertUpdate_MovementItem_SalePodium_update(
      ioId                             := MovementItem.Id
    , inMovementId                     := MovementItem.MovementId
    , ioGoodsId                        := MovementItem.ObjectId
    , inPartionId                      := MovementItem.PartionId
    , ioDiscountSaleKindId             := 0
    , inIsPay                          := TRUE
    , ioAmount                         := MovementItem.Amount
    , ioChangePercent                  := 0
                                        
    , ioSummChangePercent              := 0
    , ioSummChangePercent_curr         := 0
                                       
    , ioOperPriceList                  := MIFloat_OperPriceListReal.ValueData

    , inSession                        := '2'
)
, *
      from Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
          LEFT JOIN MovementItemFloat AS MIFloat_OperPriceListReal
                                      ON MIFloat_OperPriceListReal.MovementItemId = MovementItem.Id
                                     AND MIFloat_OperPriceListReal.DescId         = zc_MIFloat_OperPriceListReal()
WHERE Movement.DescId = zc_Movement_Sale()
and Movement.StatusId = zc_Enum_Status_Complete()
and Movement.Id = 3409 
*/
