-- Function: gpInsertUpdate_MovementItem_SalePodium()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SalePodium (Integer, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SalePodium(
 INOUT ioId                             Integer   , -- ���� ������� <������� ���������>
    IN inMovementId                     Integer   , -- ���� ������� <��������>
 INOUT ioGoodsId                        Integer   , -- *** - �����
    IN inPartionId                      Integer   , -- ������
 INOUT ioDiscountSaleKindId             Integer   , -- *** - ��� ������ ��� �������
    IN inIsPay                          Boolean   , -- �������� � �������
 INOUT ioAmount                         TFloat    , -- ����������
 INOUT ioChangePercent                  TFloat    , -- *** - % ������
 INOUT ioChangePercentNext              TFloat    , -- *** - % ������ ���.

 INOUT ioSummChangePercent              TFloat    , -- *** - �������������� ������ � ������� ���
 INOUT ioSummChangePercent_curr         TFloat    , -- *** - �������������� ������ � ������� � ������***

   OUT outOperPrice                     TFloat    , -- ���� ��. � ������
   OUT outCountForPrice                 TFloat    , -- ���� ��.�� ����������
   OUT outTotalSumm                     TFloat    , -- +����� ��. � ������
   OUT outTotalSummBalance              TFloat    , -- +����� ��. ���
 INOUT ioOperPriceList                  TFloat    , -- *** - ���� ���� ���
   OUT outOperPriceListReal_curr        TFloat    , -- *** - ���� ���� � ������

   OUT outTotalSummPriceList            TFloat    , -- +����� �� ������ � ���
   OUT outTotalSummPriceList_curr       TFloat    , -- +����� �� ������ � ������***

   OUT outCurrencyValue                 TFloat    , -- *���� ��� �������� �� ������ ������ � ���
   OUT outParValue                      TFloat    , -- *������� ��� �������� �� ������ ������ � ���

   OUT outTotalChangePercent            TFloat    , -- *+����� ������ � ������� ���
   OUT outTotalChangePercent_curr       TFloat    , -- *+����� ������ � ������� � ������***

   OUT outTotalChangePercentPay         TFloat    , -- *�������������� ������ � �������� ���
   OUT outTotalChangePercentPay_curr    TFloat    , -- *�������������� ������ � ������***

   OUT outTotalPay                      TFloat    , -- *+����� ������ � ������� ���
   OUT outTotalPay_curr                 TFloat    , -- *+����� ������ � ������� � ������***

   OUT outTotalPayOth                   TFloat    , -- *����� ������ � �������� ���
   OUT outTotalPayOth_curr              TFloat    , -- *����� ������ � �������� � ������***

   OUT outTotalCountReturn              TFloat    , -- *���-�� �������
   OUT outTotalReturn                   TFloat    , -- *����� �������� ���
   OUT outTotalPayReturn                TFloat    , -- *����� �������� ������ ���

   OUT outTotalSummToPay                TFloat    , -- +����� � ������ ���
   OUT outTotalSummToPay_curr           TFloat    , -- +����� � ������ � ������***

   OUT outTotalSummDebt                 TFloat    , -- +����� ����� � ������� ���
   OUT outTotalSummDebt_curr            TFloat    , -- +����� ����� � ������� � ������***

   OUT outDiscountSaleKindName          TVarChar  , -- *** - ��� ������ ��� �������
   OUT outBarCode_partner               TVarChar  , -- �������� �����-��� ���������� ��� �������� �����
    IN inBarCode_partner                TVarChar  , -- �����-��� ����������
    IN inBarCode_old                    TVarChar  , -- �����-��� �� �������� ����� - old
    IN inComment                        TVarChar  , -- ����������
    IN inSession                        TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbOperDate      TDateTime;
   DECLARE vbCurrencyId    Integer;
   DECLARE vbCurrencyId_pl Integer;
   DECLARE vbUnitId        Integer;
   DECLARE vbUnitId_user   Integer;
   DECLARE vbClientId      Integer;
   DECLARE vbCashId        Integer;

   DECLARE vbPriceListId        Integer; -- *����� ��������, ����� ���� ��� � ��� ��� � � ������
   DECLARE vbCurrencyValue_pl   TFloat;  -- *���� ��� �������� �� ������ ������ � ���
   DECLARE vbParValue_pl        TFloat;  -- *������� ��� �������� �� ������ ������ � ���
   DECLARE vbOperPriceList_pl   TFloat;  -- *���� �� ������ - ��������� � ���
   DECLARE vbOperPriceList_curr TFloat;  -- *���� �� ������ - ���� � ���, ����� ��������� � �� ������ ��� ���� (�������� zc_Currency_EUR)
   DECLARE vbIsDiscount_pl      Boolean;

   DECLARE vbCurrencyId_Client Integer;

   DECLARE vbIsOperPriceListReal Boolean; -- �����
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId_user:= lpGetUnit_byUser (vbUserId);


     -- �������� - ������� PODIUM
     IF EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_From
                WHERE MLO_From.MovementId =  inMovementId
                  AND MLO_From.ObjectId   = 6318  -- ������� PODIUM
                  AND MLO_From.DescId     =  zc_MovementLinkObject_From()
               )
      --AND ioId > 0
        AND zfCalc_User_PriceListReal (vbUserId) = TRUE
     THEN
        RAISE EXCEPTION '������.��� ���� �������� ��������.�������������� ����� ������ ���� ���������.';
     END IF;


     -- ����� - � ����� ������ ���� ���� ������� � ��� (� ������ ������)
     vbIsOperPriceListReal:= zfCalc_User_PriceListReal (vbUserId) = TRUE
                         AND NOT EXISTS (SELECT 1 FROM MovementLinkObject AS MLO_From
                                         WHERE MLO_From.MovementId =  inMovementId
                                           AND MLO_From.ObjectId   = 6318  -- ������� PODIUM
                                           AND MLO_From.DescId     =  zc_MovementLinkObject_From()
                                        );

     -- ������
     IF vbIsOperPriceListReal = TRUE
     THEN inIsPay:= TRUE;
     END IF;

     -- ������ ���-��
     IF COALESCE (ioAmount, 0) = 0 AND COALESCE (ioId, 0) = 0 
     THEN
         -- �� ���������
         ioAmount:= 1;
     END IF;


     -- �������� - �������� ������ ���� ��������
     IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (inPartionId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <������>.';
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF ioAmount < 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <���-��>.';
     END IF;
     -- �������� - ���������� inPartionId
     IF vbUserId <> zc_User_Sybase()
        AND EXISTS (SELECT 1 FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = inPartionId AND MI.Id <> COALESCE (ioId, 0)) THEN
        RAISE EXCEPTION '������.� ��������� ��� ���� ����� <% %> �.<%>.������������ ���������.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                       ;
     END IF;


     -- ��������� �� ���������
     SELECT Movement.OperDate
          , COALESCE (MLO_From.ObjectId, 0) AS UnitId
          , COALESCE (MLO_To.ObjectId, 0)   AS ClientId
            -- ������ ����������
          , COALESCE (MLO_CurrencyClient.ObjectId, zc_Currency_EUR()) AS ClientId
            -- ����� ��� ��������, ���� ����������
          , COALESCE (OL_pl.ChildObjectId, zc_PriceList_Basis()) AS PriceListId
            INTO vbOperDate, vbUnitId, vbClientId, vbCurrencyId_Client, vbPriceListId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MLO_From
                                         ON MLO_From.MovementId = Movement.Id
                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MLO_To
                                         ON MLO_To.MovementId = Movement.Id
                                        AND MLO_To.DescId     = zc_MovementLinkObject_To()
            LEFT JOIN MovementLinkObject AS MLO_CurrencyClient
                                         ON MLO_CurrencyClient.MovementId = Movement.Id
                                        AND MLO_CurrencyClient.DescId     = zc_MovementLinkObject_CurrencyClient()
            LEFT JOIN ObjectLink AS OL_pl ON OL_pl.ObjectId = MLO_From.ObjectId
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


     -- �� ������� - ���� � ������, ����� ����� ���� ������ �� �������� ����, ���� ����� ���
     SELECT lpGet.ValuePrice, lpGet.CurrencyId, lpGet.isDiscount
             INTO vbOperPriceList_curr, vbCurrencyId_pl, vbIsDiscount_pl
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
          , COALESCE (Object_PartionGoods.CountForPrice, 1)                AS CountForPrice
          , COALESCE (Object_PartionGoods.OperPrice, 0)                    AS OperPrice
          , COALESCE (Object_PartionGoods.CurrencyId, zc_Currency_Basis()) AS CurrencyId
            INTO ioGoodsId, outCountForPrice, outOperPrice, vbCurrencyId
     FROM Object_PartionGoods
     WHERE Object_PartionGoods.MovementItemId = inPartionId;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
     END IF;


     -- ���� ��.���� �� � ������� ������
     IF COALESCE (vbCurrencyId, 0) <> zc_Currency_Basis()
     THEN
         IF 1=0 -- EXISTS (SELECT 1 FROM MovementItem AS MI JOIN MovementItem AS MI_parent ON MI_parent.Id = MI.ParentId AND MI_parent.isErased = FALSE WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Child() AND MI.isErased = FALSE)
         THEN
             -- ���������� ���� - ���� �������
             SELECT tmp.CurrencyValue_eur, tmp.ParValue_eur
                    INTO outCurrencyValue, outParValue
             FROM (SELECT MAX (COALESCE (MIFloat_CurrencyValue.ValueData, 0)) AS CurrencyValue_eur
                        , MAX (COALESCE (MIFloat_ParValue.ValueData,      0)) AS ParValue_eur
                   FROM MovementItem
                         JOIN MovementItem AS MI_parent ON MI_parent.Id = MovementItem.ParentId AND MI_parent.isErased = FALSE
                         INNER JOIN Object ON Object.Id = MovementItem.ObjectId AND Object.DescId = zc_Object_Cash()
                         INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                          ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                         AND MILinkObject_Currency.ObjectId       = zc_Currency_EUR()
                         LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                     ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                         LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                     ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Child()
                     AND MovementItem.isErased   = FALSE
                  ) AS tmp;
         ELSE
             -- ���������� ���� �� ���� ���������
             SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                    INTO outCurrencyValue, outParValue
             FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                   , inCurrencyFromId:= zc_Currency_Basis()
                                                   , inCurrencyToId  := vbCurrencyId
                                                    ) AS tmp;
         END IF;

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

     -- ������, � �� ������ - ���� ���� ������ �� � ������� ������
     IF 1=1 -- OR COALESCE (vbCurrencyId_pl, 0) <> zc_Currency_Basis()
     THEN
             -- ���������� ���� -- ���� �������
             SELECT tmp.CurrencyValue_eur, tmp.ParValue_eur
                    INTO vbCurrencyValue_pl, vbParValue_pl
             FROM (SELECT MAX (COALESCE (MIFloat_CurrencyValue.ValueData, 0)) AS CurrencyValue_eur
                        , MAX (COALESCE (MIFloat_ParValue.ValueData,      0)) AS ParValue_eur
                   FROM MovementItem
                         JOIN MovementItem AS MI_parent ON MI_parent.Id = MovementItem.ParentId AND MI_parent.isErased = FALSE
                         INNER JOIN Object ON Object.Id = MovementItem.ObjectId AND Object.DescId = zc_Object_Cash()
                         INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                          ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                         AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                                         AND MILinkObject_Currency.ObjectId       = zc_Currency_EUR()
                         LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                     ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                    AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                         LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                     ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                    AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.DescId     = zc_MI_Child()
                     AND MovementItem.isErased   = FALSE
                  ) AS tmp;


         -- ���� �� �������
         IF COALESCE (vbCurrencyValue_pl, 0) = 0
         THEN
             -- ���������� ���� �� ���� ���������
             SELECT COALESCE (tmp.Amount, 0), COALESCE (tmp.ParValue, 0)
                    INTO vbCurrencyValue_pl, vbParValue_pl
             FROM lfSelect_Movement_Currency_byDate (inOperDate      := vbOperDate
                                                   , inCurrencyFromId:= zc_Currency_Basis()
                                                     -- !!! �������� - zc_Currency_EUR !!!
                                                   , inCurrencyToId  := zc_Currency_EUR() -- vbCurrencyId_pl
                                                    ) AS tmp;
         END IF;

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


     -- ���� �����-��� ���������� - ����������
     IF EXISTS (SELECT 1 FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = vbUnitId_user AND ObjectBoolean.DescId = zc_ObjectBoolean_Unit_PartnerBarCode() AND ObjectBoolean.ValueData = TRUE)
        AND vbUserId <> zc_User_Sybase()
     THEN
         -- ��� ������������ ���������� ������ ���
         IF COALESCE (inBarCode_partner, '') = '' AND (COALESCE (inBarCode_old, '') = '' OR COALESCE (inPartionId, 0) = 0) AND COALESCE (ioId, 0) = 0
         THEN
             RETURN; -- !!!�����!!!
         END IF;

         -- ���� ����� ������ <�����-��� ����������> - ���������� ������ ���, �.�. ���� ����� � ������ �����
         IF COALESCE (inBarCode_partner, '') <> '' AND COALESCE (inBarCode_old, '') = '' AND COALESCE (ioId, 0) = 0 AND COALESCE (inPartionId, 0) = 0
         THEN
             RETURN; -- !!!�����!!!
         END IF;


         -- ���� ��� ��� ������
         IF ioId > 0
         THEN
             -- !!!������!!!
             inBarCode_partner:= (SELECT MIS.ValueData FROM MovementItemString AS MIS WHERE MIS.MovementItemId = ioId AND MIS.DescId = zc_MIString_BarCode());
         END IF;

         -- ��������
         IF COALESCE (inBarCode_partner, '') = ''
         THEN
             RAISE EXCEPTION '������.�� ����������� �������� <�����-��� ����������>.';
         END IF;

     END IF;


     -- ��������: ������� ������ ����
     IF vbUserId <> zc_User_Sybase()
        AND ioAmount > COALESCE ((SELECT Container.Amount
                                  FROM Container
                                       LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                     ON CLO_Client.ContainerId = Container.Id
                                                                    AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                  WHERE Container.PartionId     = inPartionId
                                    AND Container.DescId        = zc_Container_Count()
                                    AND Container.WhereObjectId = vbUnitId
                                    AND Container.Amount        > 0
                                    AND CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
                                 ), 0)
     THEN
        RAISE EXCEPTION '������.��� ������ <% %> �.<%> ������� = <%>.'
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.LabelId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData    ((SELECT Object_PartionGoods.GoodsId     FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , lfGet_Object_ValueData_sh ((SELECT Object_PartionGoods.GoodsSizeId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId))
                      , zfConvert_FloatToString (COALESCE ((SELECT Container.Amount
                                                            FROM Container
                                                                 LEFT JOIN ContainerLinkObject AS CLO_Client
                                                                                               ON CLO_Client.ContainerId = Container.Id
                                                                                              AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                                                            WHERE Container.PartionId     = inPartionId
                                                              AND Container.DescId        = zc_Container_Count()
                                                              AND Container.WhereObjectId = vbUnitId
                                                              AND Container.Amount        > 0
                                                              AND CLO_Client.ContainerId IS NULL -- !!!��������� ����� �����������!!!
                                                           ), 0))
                       ;
     END IF;


     -- ������
     IF EXISTS (SELECT 1
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
                    -- !!! �������� ?
                    OR ObjectFloat_PeriodYear.ValueData > 2020
                      )
               )
        AND vbIsDiscount_pl = FALSE
     THEN
         SELECT tmp.ChangePercent, tmp.ChangePercentNext, tmp.DiscountSaleKindId INTO ioChangePercent, ioChangePercentNext, ioDiscountSaleKindId
         FROM zfSelect_DiscountSaleKind (vbOperDate, vbUnitId, ioGoodsId, vbClientId, vbUserId) AS tmp;
     ELSE
         ioChangePercent     := 0;
         ioChangePercentNext := 0;
         ioDiscountSaleKindId:= 9; -- ��� ������
     END IF;


     -- �������� - �������� ������ ���� �����������
     IF COALESCE (ioOperPriceList, 0) <= 0 THEN
        RAISE EXCEPTION '������.�� ������� �������� <���� ���� ���>.';
     END IF;

     -- *���� �� ������ - ��� ������� ����� ������
     -- ���� ���� � ������
     IF vbCurrencyId_pl <> zc_Currency_Basis()
     THEN
         -- ���� � ���������� � ���
         IF vbCurrencyId_Client = zc_Currency_GRN()
         THEN
             -- ��������� � ���, ���������� �� 0 ��. - �.�. � ���������� � ���
             vbOperPriceList_pl:= zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl), 0);
         ELSE
             -- !!!��������� �� ������ � ���, ���������� �� 4 ��.!!! - ***��� �������� �����
             vbOperPriceList_pl:= zfCalc_CurrencyFrom (vbOperPriceList_curr, vbCurrencyValue_pl, vbParValue_pl);
         END IF;
     ELSE
         -- � ������ ��� � ���
         vbOperPriceList_pl:= vbOperPriceList_curr;
         --
         IF vbCurrencyId_Client = zc_Currency_GRN()
         THEN
             -- !!! �������� - � ����� ���� � zc_Currency_EUR + ���������� �� 0-� ��. - �.�. � ���������� � ��� !!!
             vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl), 0);
         ELSE
             -- !!! �������� - � ����� ���� � zc_Currency_EUR + ���������� �� 0-� ��. - �.�. � ���������� � ������ !!!
             vbOperPriceList_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencySumm (vbOperPriceList_curr, vbCurrencyId_pl, zc_Currency_EUR(), vbCurrencyValue_pl, vbParValue_pl), 0);
         END IF;
     END IF;

     -- ���� � ��� �� ������� �� ������� - ������ ����� INSERT + ���� ������ IsOperPriceListReal = TRUE
     IF COALESCE (ioId, 0) = 0 AND vbIsOperPriceListReal = TRUE
     THEN
         -- �� ����� ���� ������������ � ���� ��� ���� ���� ��� + ����������
         ioOperPriceList:= zfCalc_SummChangePercentNext (1, vbOperPriceList_pl, ioChangePercent, ioChangePercentNext);
     END IF;



     -- �������������� ������ � ������� ��� - �������� � ������� � �������
     IF (inIsPay = TRUE AND ioAmount <> COALESCE ((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId), 0))
        OR ioAmount = 0
     THEN
         -- �������������� ������ � ������� ��� + � ������
         IF inIsPay = FALSE
         THEN -- !!!��������!!!
              ioSummChangePercent     := 0;
              ioSummChangePercent_curr:= 0;
         ELSE
             -- !!!�����!!!
             IF vbIsOperPriceListReal = FALSE
             THEN
                  -- ����� �� ��� ����
                  ioSummChangePercent     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()),      0);
                  ioSummChangePercent_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent_curr()), 0);
             ELSE
                 -- ��������� ��� PriceListReal
                 IF vbCurrencyId_Client = zc_Currency_GRN()
                 THEN
                     -- ����� ������ �� ���� � ��� + ����������
                     ioSummChangePercent     := zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_pl, ioChangePercent, ioChangePercentNext)
                                              - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                     -- ��������� �� ��� � ������ + ����������
                     ioSummChangePercent_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencyTo (ioSummChangePercent, outCurrencyValue, outParValue));
                 ELSE
                     -- ����� ������ �� ���� � ������ + ����������
                     ioSummChangePercent_curr:= zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_curr, ioChangePercent, ioChangePercentNext)
                                                -- !!! �������� - zc_Currency_EUR !!!
                                              - zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);
                     -- ��������� �� ������ � ��� + ��� ����������
                     ioSummChangePercent     := zfCalc_CurrencyFrom (ioSummChangePercent_curr, outCurrencyValue, outParValue);

                 END IF;
             END IF;
         END IF;

     ELSE
         -- !!!�����!!!
         IF vbIsOperPriceListReal = TRUE
         THEN
              -- ��������� ��� PriceListReal
              IF vbCurrencyId_Client = zc_Currency_GRN()
              THEN
                  -- ����� ������ �� ���� � ��� + ����������
                  ioSummChangePercent     := zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_pl, ioChangePercent, ioChangePercentNext)
                                           - zfCalc_SummPriceList (ioAmount, ioOperPriceList);
                  -- ��������� �� ��� � ������ + ����������
                  ioSummChangePercent_curr:= zfCalc_SummPriceList (1, zfCalc_CurrencyTo (ioSummChangePercent, outCurrencyValue, outParValue));
              ELSE
                  -- ����� ������ �� ���� � ������ + ����������
                  ioSummChangePercent_curr:= zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_curr, ioChangePercent, ioChangePercentNext)
                                             -- !!! �������� - zc_Currency_EUR !!!
                                           - zfCalc_SummPriceList (ioAmount, vbOperPriceList_curr);
                  -- ��������� �� ������ � ��� + ����������
                  ioSummChangePercent     := zfCalc_SummPriceList (1, zfCalc_CurrencyFrom (ioSummChangePercent_curr, outCurrencyValue, outParValue));
              END IF;

         ELSE
              -- ����� �� ��� ����
              ioSummChangePercent     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent()),      0);
              ioSummChangePercent_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_SummChangePercent_curr()), 0);
         END IF;

     END IF;


     -- ������� �������� ������
     outDiscountSaleKindName := (SELECT Object.ValueData FROM Object WHERE Object.Id = ioDiscountSaleKindId);


     -- ������� ����� ��. � ������, ��� ����� - ��������� �� 2-� ������
     outTotalSumm := zfCalc_SummIn (ioAmount, outOperPrice, outCountForPrice);
     -- ������� ����� ��. � ��� �� ��������, ��� �����
     outTotalSummBalance := zfCalc_CurrencyFrom (outTotalSumm, outCurrencyValue, outParValue);


     -- ����� ����� �� ������ + ���� ��� ��������� ��� ����
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- ��������� ��� ���
         outTotalSummPriceList      := zfCalc_SummIn (ioAmount, vbOperPriceList_pl, 1);
         -- ��������� ��� ������
         outTotalSummPriceList_curr := zfCalc_SummIn (ioAmount, vbOperPriceList_curr, 1);
     ELSE
         -- ***��� �������� �����
         -- ��������� ��� ���
         outTotalSummPriceList      := zfCalc_SummIn (ioAmount, vbOperPriceList_pl, 1);
         -- ��������� ��� ������
         outTotalSummPriceList_curr := zfCalc_SummIn (ioAmount, vbOperPriceList_curr, 1);
     END IF;


     -- ����� ������ � �������, ��� ����� - !!!��������� �� ���� ������ - ������ %, ��� ��������� - ������!!!
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- ��������� ��� ���
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_pl,   ioChangePercent, ioChangePercentNext) + COALESCE (ioSummChangePercent,      0);
         -- ��������� ��� ������
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_curr, ioChangePercent, ioChangePercentNext) + COALESCE (ioSummChangePercent_curr, 0);
     ELSE
         -- ***��� �������� �����
         -- ��������� ��� ������
         outTotalChangePercent_curr := outTotalSummPriceList_curr - zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_curr, ioChangePercent, ioChangePercentNext) + COALESCE (ioSummChangePercent_curr, 0);
         -- ��������� ��� ��� - ��������� ����� �� ������� � ������ � ���
         outTotalChangePercent      := outTotalSummPriceList      - zfCalc_CurrencyFrom (zfCalc_SummChangePercentNext (ioAmount, vbOperPriceList_curr, ioChangePercent, ioChangePercentNext), vbCurrencyValue_pl, vbParValue_pl) + COALESCE (ioSummChangePercent,      0);
     END IF;


     -- ����� ������ � �������, ��� �����
     IF inIsPay = TRUE
     THEN
         IF vbCurrencyId_Client = zc_Currency_GRN()
         THEN
             -- ��������� ��� ���
             outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
             -- ��������� ��� ������
             outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
         ELSE
             -- ��������� ��� ������
             outTotalPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
             -- ��������� ��� ���
             outTotalPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         END IF;

     ELSE
         -- ����� �� ��� ����
         outTotalPay      := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay()),      0);
         outTotalPay_curr := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPay_curr()), 0);
     END IF;


     -- ������� ����� � ������
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- ��������� ��� ���
         outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
         -- ��������� ��� ������
         outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
     ELSE
         -- ��������� ��� ������
         outTotalSummToPay_curr := COALESCE (outTotalSummPriceList_curr, 0) - COALESCE (outTotalChangePercent_curr, 0) ;
         -- ��������� ��� ���
         outTotalSummToPay      := COALESCE (outTotalSummPriceList, 0)      - COALESCE (outTotalChangePercent,      0) ;
     END IF;


     -- ������� ����� ����� � �������
     IF vbCurrencyId_Client = zc_Currency_GRN()
     THEN
         -- ��������� ��� ���
         outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
         -- ��������� ��� ������
         outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;
     ELSE
         -- ��������� ��� ������
         outTotalSummDebt_curr := COALESCE (outTotalSummToPay_curr, 0) - COALESCE (outTotalPay_curr, 0) ;
         -- ��������� ��� ���
         outTotalSummDebt      := COALESCE (outTotalSummToPay, 0)      - COALESCE (outTotalPay,      0) ;
     END IF;
     

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Sale   (ioId                    := ioId
                                              , inMovementId            := inMovementId
                                              , inGoodsId               := ioGoodsId
                                              , inPartionId             := COALESCE (inPartionId, 0)
                                              , inDiscountSaleKindId    := ioDiscountSaleKindId
                                              , inAmount                := ioAmount
                                              , inChangePercent         := COALESCE (ioChangePercent, 0)
                                              , inChangePercentNext     := COALESCE (ioChangePercentNext, 0)
                                              -- , inSummChangePercent     := COALESCE (ioSummChangePercent, 0)
                                              , inOperPrice             := COALESCE (outOperPrice, 0)
                                              , inCountForPrice         := COALESCE (outCountForPrice, 0)
                                                -- �������� ���� ������ � ���
                                              , inOperPriceList         := vbOperPriceList_pl
                                                --
                                              , inCurrencyValue         := outCurrencyValue
                                              , inParValue              := outParValue
                                                -- ����� ������ � ���: ��% + ������
                                              , inTotalChangePercent    := COALESCE (outTotalChangePercent, 0)
                                              -- , inTotalChangePercentPay := COALESCE (outTotalChangePercentPay, 0)
                                              -- , inTotalPay              := COALESCE (outTotalPay, 0)
                                              -- , inTotalPayOth           := COALESCE (outTotalPayOth, 0)
                                              -- , inTotalCountReturn      := COALESCE (outTotalCountReturn, 0)
                                              -- , inTotalReturn           := COALESCE (outTotalReturn, 0)
                                              -- , inTotalPayReturn        := COALESCE (outTotalPayReturn, 0)
                                              , inBarCode               := inBarCode_partner
                                              , inComment               := -- !!!��� SYBASE - ����� ������!!!
                                                                           CASE WHEN vbUserId = zc_User_Sybase() AND SUBSTRING (inComment FROM 1 FOR 5) = '*123*'
                                                                                     THEN -- ������ �������
                                                                                          SUBSTRING (inComment FROM 6 FOR CHAR_LENGTH (inComment) - 5)
                                                                                     ELSE inComment
                                                                           END
                                              , inUserId                := vbUserId
                                               );


     -- ��������� - ����� ������ � EUR: ��% + ������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalChangePercent_curr(), ioId, COALESCE (outTotalChangePercent_curr, 0));
     -- ��������� - ���� ���� ���
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceListReal(), ioId
                                             , CASE WHEN ioAmount <> 0 THEN (COALESCE (outTotalSummPriceList, 0) - COALESCE (outTotalChangePercent, 0)) / ioAmount ELSE 0 END
                                              );
     -- ��������� - ���� ����� (� ������) - !!! �������� - zc_Currency_EUR!!!
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPriceList_curr(), ioId, vbOperPriceList_curr);
     -- ��������� - ������ (���� ������) - � ����� ������ ���� ���� ������, ��� � �������� ������ �� �������� ������ �� �����������
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Currency_pl(), ioId, vbCurrencyId_pl);

     -- ��������� ������ � ���
     IF inIsPay = TRUE
     THEN
         -- ������� ����� ��� ��������, � ������� ������� ������
         vbCashId := (SELECT lpSelect.CashId
                      FROM lpSelect_Object_Cash (vbUnitId, vbUserId) AS lpSelect
                      WHERE lpSelect.isBankAccount = FALSE
                        AND lpSelect.CurrencyId    = zc_Currency_GRN()
                     );

         -- �������� - �������� ������ ���� �����������
         IF COALESCE (vbCashId, 0) = 0 THEN
           -- ��� Sybase - ��������
           IF vbUserId = zc_User_Sybase()
           THEN vbCashId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Cash() AND Object.ObjectCode = 1);
           ELSE RAISE EXCEPTION '������.��� �������� <%> �� ����������� �������� <�����> � ���. (%)', lfGet_Object_ValueData (vbUnitId), vbUnitId;
           END IF;
         END IF;


         -- ���������
         PERFORM lpInsertUpdate_MI_Sale_Child (ioId                 := tmp.Id
                                             , inMovementId         := inMovementId
                                             , inParentId           := ioId
                                             , inCashId             := tmp.CashId
                                             , inCurrencyId         := tmp.CurrencyId
                                             , inCashId_Exc         := NULL
                                             , inAmount             := tmp.Amount
                                             , inCurrencyValue      := tmp.CurrencyValue
                                             , inParValue           := tmp.ParValue
                                             , inUserId             := vbUserId
                                              )
         FROM (WITH tmpMI AS (SELECT MovementItem.Id                 AS Id
                                   , MovementItem.ObjectId           AS CashId
                                   , MILinkObject_Currency.ObjectId  AS CurrencyId
                                   , MIFloat_CurrencyValue.ValueData AS CurrencyValue
                                   , MIFloat_ParValue.ValueData      AS ParValue
                              FROM MovementItem
                                   LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                               ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                    ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                   AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                              WHERE MovementItem.ParentId   = ioId
                                AND MovementItem.MovementId = inMovementId
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                             )
               SELECT tmpMI.Id                                                  AS Id
                    , COALESCE (_tmpCash.CashId, tmpMI.CashId)                  AS CashId
                    , COALESCE (_tmpCash.CurrencyId, tmpMI.CurrencyId)          AS CurrencyId
                    , CASE WHEN _tmpCash.CashId > 0 THEN outTotalPay ELSE 0 END AS Amount
                    , COALESCE (tmpMI.CurrencyValue, 0)                         AS CurrencyValue
                    , COALESCE (tmpMI.CurrencyId, 0)                            AS ParValue
               FROM (SELECT vbCashId AS CashId, zc_Currency_GRN() AS CurrencyId
                    ) AS _tmpCash
                    FULL JOIN tmpMI ON tmpMI.CashId = _tmpCash.CashId
              ) AS tmp
         ;

         -- � ������ �������� - �������������� ������ � ������� ��� - �.�. ����� ��������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent(), ioId, COALESCE (ioSummChangePercent, 0));
         -- � ������ �������� - �������������� ������ � ������� � ���  - �.�. ����� ��������
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummChangePercent_curr(), ioId, COALESCE (ioSummChangePercent_curr, 0));

         -- � ������ �������� - ����� ������ � ������� ���
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay(),      ioId, outTotalPay);
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TotalPay_curr(), ioId, outTotalPay_curr);

         -- ����������� �������� ����� �� ���������
         PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     END IF;


     -- � ������ �������� - ���� - �� ������� !!!� ��������� �����!!!
     -- PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_CurrencyValue(), ioId, outCurrencyValue)
     --       , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ParValue(),      ioId, outParValue)
     --        ;


     -- "������" ����������� "��������" ����� �� ��������
     PERFORM lpUpdate_MI_Sale_Total (ioId);


     -- ������� �������������� ������ � ��������, ��� �����
     outTotalChangePercentPay     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay()),      0);
     outTotalChangePercentPay_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalChangePercentPay_curr()), 0);

     -- ������� ����� ������ � ��������, ��� �����
     outTotalPayOth     := COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth()),      0);
     outTotalPayOth_curr:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayOth_curr()), 0);

     -- ������� ���-�� �������, ��� �����
     outTotalCountReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalCountReturn()), 0);
     -- ������� ����� �������� ���, ��� �����
     outTotalReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalReturn()), 0);
     -- ������� ����� �������� ������ ���, ��� �����
     outTotalPayReturn:= COALESCE ((SELECT MIF.ValueData FROM MovementItemFloat AS MIF WHERE MIF.MovementItemId = ioId AND MIF.DescId = zc_MIFloat_TotalPayReturn()), 0);

     -- �������� �����-��� ���������� ��� �������� �����
     outBarCode_partner:= '';

-- if inSession = '2'
-- then
--    RAISE EXCEPTION '������.<%>', ioOperPriceList;
-- end if;

     -- ��������� �� ������
     outOperPriceListReal_curr:= ROUND (zfCalc_CurrencyTo (ioOperPriceList, vbCurrencyValue_pl, vbParValue_pl), 2);


     -- �������� ���� ��. ��� ����� - �.�. � ������������ �������� ��� ����
     IF vbUnitId_user > 0
     THEN
         outOperPrice         := 0; -- ���� ��. � ������
         outCountForPrice     := 0; -- ���� ��.�� ����������
         outTotalSumm         := 0; -- ����� ��. � ������
         outTotalSummBalance  := 0; -- ����� ��. ���
         outCurrencyValue     := 0; -- ���� ��� �������� �� ������ ������ � ���
         outParValue          := 0; -- ������� ��� �������� �� ������ ������ � ���
     END IF;

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
-- SELECT * FROM gpInsertUpdate_MovementItem_SalePodium (ioId := 0 , inMovementId := 8 , ioGoodsId := 446 , inPartionId := 50 , inIsPay := False ,  ioAmount := 4 ,ioSummChangePercent:=0, ioOperPriceList := 1030 , inBarCode_partner := '1' ::TVarChar,  inSession := zfCalc_UserAdmin());
