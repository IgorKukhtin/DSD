-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;

  DECLARE vbOperCount_Master TFloat;
  DECLARE vbOperCount_Child TFloat;
  DECLARE vbOperCount_Partner TFloat;
  DECLARE vbOperCount_Packer TFloat;
  DECLARE vbOperCount_Second TFloat;
  DECLARE vbOperCount_Tare   TFloat;
  DECLARE vbOperCount_Sh     TFloat;
  DECLARE vbOperCount_Kg     TFloat;
  DECLARE vbOperCount_ShFrom TFloat;
  DECLARE vbOperCount_KgFrom TFloat;
  DECLARE vbOperSumm_Partner     TFloat;
  DECLARE vbOperSumm_PartnerFrom TFloat;
  DECLARE vbOperSumm_Currency    TFloat;
  DECLARE vbOperSumm_Packer TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT TFloat;
  DECLARE vbOperSumm_PVAT_original TFloat;
  DECLARE vbOperSumm_Inventory TFloat;

  DECLARE vbTotalSummToPay            TFloat;
  DECLARE vbTotalSummService          TFloat;
  DECLARE vbTotalSummCard             TFloat;
  DECLARE vbTotalSummCardRecalc       TFloat;
  DECLARE vbTotalSummCardSecondRecalc TFloat;
  DECLARE vbTotalSummCardSecond       TFloat;
  DECLARE vbTotalSummCardSecondCash   TFloat;
  DECLARE vbTotalSummNalog            TFloat;
  DECLARE vbTotalSummNalogRecalc      TFloat;
  DECLARE vbTotalSummNalogRet         TFloat;
  DECLARE vbTotalSummNalogRetRecalc   TFloat;
  DECLARE vbTotalSummMinus            TFloat;
  DECLARE vbTotalSummAdd              TFloat;
  DECLARE vbTotalSummHoliday          TFloat;
  DECLARE vbTotalSummSocialIn         TFloat;
  DECLARE vbTotalSummSocialAdd        TFloat;
  DECLARE vbTotalSummChild            TFloat;
  DECLARE vbTotalSummChildRecalc      TFloat;
  DECLARE vbTotalSummMinusExt         TFloat;
  DECLARE vbTotalSummMinusExtRecalc   TFloat;

  DECLARE vbTotalSummTransport        TFloat;
  DECLARE vbTotalSummTransportAdd     TFloat;
  DECLARE vbTotalSummTransportAddLong TFloat;
  DECLARE vbTotalSummTransportTaxi    TFloat;
  DECLARE vbTotalSummPhone            TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;
  DECLARE vbPaidKindId Integer;
  DECLARE vbIsChangePrice Boolean;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� � ������������
     SELECT Movement.DescId
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, COALESCE (MovementFloat_VATPercent.ValueData, 0))
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -MovementFloat_ChangePercent.ValueData ELSE 0 END
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN MovementFloat_ChangePercent.ValueData ELSE 0 END
          , COALESCE (MovementFloat_ChangePrice.ValueData, 0)          AS ChangePrice
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)         AS PaidKindId

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue
            INTO vbMovementDescId, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbChangePrice, vbPaidKindId
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue

      FROM Movement
           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                     ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
           LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                   ON MovementFloat_VATPercent.MovementId = Movement.Id
                                  AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                        ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                       AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
           LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                 ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                   ON MovementFloat_ChangePercent.MovementId = Movement.Id
                                  AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
           LEFT JOIN MovementFloat AS MovementFloat_ChangePrice
                                   ON MovementFloat_ChangePrice.MovementId =  Movement.Id
                                  AND MovementFloat_ChangePrice.DescId = zc_MovementFloat_ChangePrice()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = CASE WHEN Movement.DescId = zc_Movement_TransferDebtOut() THEN zc_MovementLinkObject_PaidKindTo() WHEN Movement.DescId = zc_Movement_TransferDebtIn() THEN zc_MovementLinkObject_PaidKindFrom() ELSE zc_MovementLinkObject_PaidKind() END

           LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                        ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                       AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                        ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                       AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParValue
                                    ON MovementFloat_ParValue.MovementId = Movement.Id
                                   AND MovementFloat_ParValue.DescId = zc_MovementFloat_ParValue()
           LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                   ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                  AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
           LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                   ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                  AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

      WHERE Movement.Id = inMovementId;


     -- !!!���� ���������� - ���� �� ������ � ����!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
     THEN
     vbIsChangePrice:= vbPaidKindId <> zc_Enum_PaidKind_SecondForm()
                    OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0)
                        AND EXISTS (SELECT 1
                                    FROM MovementItem
                                         LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                     ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                    WHERE MovementItem.MovementId = inMovementId
                                      AND MovementItem.DescId = zc_MI_Master()
                                      AND MovementItem.isErased = FALSE
                                      AND COALESCE (MIFloat_ChangePercent.ValueData, 0) = 0
                                   ));
     ELSE
     vbIsChangePrice:= vbPaidKindId = zc_Enum_PaidKind_FirstForm();
     END IF;

     -- ������� �������� ���� � ������ (���� ����)
     SELECT
            -- ���������� �� ����� (������� ��������)
            OperCount_Master
            -- ���������� �� ����� (����������� ��������)
          , OperCount_Child
            -- ���������� �� �����������
          , OperCount_Partner
            -- ���������� �������
          , OperCount_Second
            -- ���������� ���� !!!�� �����������!!!
          , OperCount_Tare
            -- ���������� �� !!!�� �����������!!!
          , OperCount_Sh
            -- ���������� ��� !!!�� �����������!!!
          , OperCount_Kg
            -- ���������� �� !!!����!!!
          , OperCount_ShFrom
            -- ���������� ��� !!!����!!!
          , OperCount_KgFrom

            -- ����� ��� ���
          , CAST (OperSumm_MVAT
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_MVAT

            -- ����� � ���
          , CAST (OperSumm_PVAT
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PVAT
            -- ����� � ��� + !!!��!!! ������ ������ � ����
          , CAST (OperSumm_PVAT_original
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PVAT_original

            -- ����� �� �����������
          , CAST (OperSumm_Partner
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner
            -- ����� �� ����������� !!!����!!!
          , CAST (OperSumm_PartnerFrom
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PartnerFrom

            -- ����� � ������
          , CAST (CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN OperSumm_Partner_Currency ELSE OperSumm_Partner END
                  -- ��� ����������� � ������ CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue / vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency


            -- ���������� �� ������������
          , OperCount_Packer AS OperCount_Packer

            -- ����� �� ������������
          , OperSumm_Packer AS OperSumm_Packer

            -- ����� ����� �������
          , OperSumm_Inventory AS OperSumm_Inventory

            -- ����� ���������� ��
          , OperSumm_ToPay
          , OperSumm_Service
          , OperSumm_Card
          , OperSumm_CardSecond
          , OperSumm_Nalog
          , OperSumm_Minus
          , OperSumm_Add
          , OperSumm_Holiday
          , OperSumm_CardRecalc
          , OperSumm_CardSecondRecalc
          , OperSumm_CardSecondCash
          , OperSumm_NalogRecalc
          , OperSumm_SocialIn
          , OperSumm_SocialAdd
          , OperSumm_Child
          , OperSumm_ChildRecalc
          , OperSumm_MinusExt
          , OperSumm_MinusExtRecalc
          , OperSumm_Transport
          , OperSumm_TransportAdd
          , OperSumm_TransportAddLong
          , OperSumm_TransportTaxi
          , OperSumm_Phone
          , OperSumm_NalogRet
          , OperSumm_NalogRetRecalc
          
            INTO vbOperCount_Master, vbOperCount_Child, vbOperCount_Partner, vbOperCount_Second, vbOperCount_Tare, vbOperCount_Sh, vbOperCount_Kg, vbOperCount_ShFrom, vbOperCount_KgFrom
               , vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_PVAT_original, vbOperSumm_Partner, vbOperSumm_PartnerFrom, vbOperSumm_Currency
               , vbOperCount_Packer, vbOperSumm_Packer, vbOperSumm_Inventory
               , vbTotalSummToPay, vbTotalSummService, vbTotalSummCard, vbTotalSummCardSecond, vbTotalSummNalog, vbTotalSummMinus, vbTotalSummAdd, vbTotalSummHoliday
               , vbTotalSummCardRecalc, vbTotalSummCardSecondRecalc, vbTotalSummCardSecondCash, vbTotalSummNalogRecalc, vbTotalSummSocialIn, vbTotalSummSocialAdd
               , vbTotalSummChild, vbTotalSummChildRecalc, vbTotalSummMinusExt, vbTotalSummMinusExtRecalc
               , vbTotalSummTransport, vbTotalSummTransportAdd, vbTotalSummTransportAddLong, vbTotalSummTransportTaxi, vbTotalSummPhone
               , vbTotalSummNalogRet, vbTotalSummNalogRetRecalc
     FROM
     -- ������ �������� �����
    (SELECT
            -- ���������� �� ����� (������� ��������)
            OperCount_Master
            -- ���������� �� ����� (����������� ��������)
          , OperCount_Child
            -- ���������� �� �����������
          , OperCount_Partner
            -- ���������� �������
          , OperCount_Second
            -- ���������� ���� !!!�� �����������!!!
          , OperCount_Tare
            -- ���������� �� !!!�� �����������!!!
          , OperCount_Sh
            -- ���������� ��� !!!�� �����������!!!
          , OperCount_Kg
            -- ���������� �� !!!����!!!
          , OperCount_ShFrom
            -- ���������� ��� !!!����!!!
          , OperCount_KgFrom

            -- ����� ��� ���
          , CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� ��� ��� ��� %���=0
                      THEN (OperSumm_Partner)
                 WHEN vbPriceWithVAT AND 1=1
                      -- ���� ���� c ���
                      THEN CAST ( (OperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                      -- ���� ���� c ��� (������� ����� ���� ����  �������� ������ ��� =1/6 )
                      THEN OperSumm_Partner - CAST ( (OperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
            END AS OperSumm_MVAT

            -- ����� � ���
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ���
                      THEN (OperSumm_Partner)
                 WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���
                      THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2))
            END AS OperSumm_PVAT

            -- ����� � ��� + !!!��!!! ������ ������ � ����
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                      -- ���� ���� � ���
                      THEN (OperSumm_Partner_original)
                 WHEN vbVATPercent > 0
                      -- ���� ���� ��� ���
                      THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_original) AS NUMERIC (16, 2))
            END AS OperSumm_PVAT_original


            -- ����� �� �����������
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Partner_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner
            -- ����� �� ����������� !!!����!!!
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                              ELSE (OperSumm_PartnerFrom_ChangePrice)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_PartnerFrom

            -- ����� �� ����������� (!!!� ������!!!)
          , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Partner_ChangePrice_Currency)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Partner_Currency

            -- ���������� �� ������������
          , OperCount_Packer AS OperCount_Packer

            -- ����� �� ������������
          , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                    -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                              ELSE (OperSumm_Packer)
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
                 WHEN vbVATPercent > 0
                    -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                    THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                              ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                         END
            END AS OperSumm_Packer

            -- ����� ����� �������
          , OperSumm_Inventory AS OperSumm_Inventory

            -- ����� ���������� ��
          , OperSumm_ToPay
          , OperSumm_Service
          , OperSumm_Card
          , OperSumm_CardSecond
          , OperSumm_Nalog
          , OperSumm_Minus
          , OperSumm_Add
          , OperSumm_Holiday
          , OperSumm_CardRecalc
          , OperSumm_CardSecondRecalc
          , OperSumm_CardSecondCash
          , OperSumm_NalogRecalc
          , OperSumm_SocialIn
          , OperSumm_SocialAdd
          , OperSumm_Child
          , OperSumm_ChildRecalc
          , OperSumm_MinusExt
          , OperSumm_MinusExtRecalc
          , OperSumm_Transport
          , OperSumm_TransportAdd
          , OperSumm_TransportAddLong
          , OperSumm_TransportTaxi
          , OperSumm_Phone
          , OperSumm_NalogRet
          , OperSumm_NalogRetRecalc
     FROM
           -- �������� 1 ������ + !!! �������� � ������ ���� ����!!!
          (SELECT SUM (tmpMI.OperCount_Master)  AS OperCount_Master
                , SUM (tmpMI.OperCount_Child)   AS OperCount_Child
                , SUM (tmpMI.OperCount_Partner) AS OperCount_Partner -- ���������� � �����������
                , SUM (tmpMI.OperCount_Packer)  AS OperCount_Packer  -- ���������� � ������������
                , SUM (tmpMI.OperCount_Second)  AS OperCount_Second  -- ���������� �������

                , SUM (tmpMI.OperCount_Tare)     AS OperCount_Tare
                , SUM (tmpMI.OperCount_Sh)       AS OperCount_Sh
                , SUM (tmpMI.OperCount_Kg)       AS OperCount_Kg
                , SUM (tmpMI.OperCount_ShFrom)   AS OperCount_ShFrom
                , SUM (tmpMI.OperCount_KgFrom)   AS OperCount_KgFrom

                  -- ����� �� ����������� - � ����������� �� 2-� ������
                , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                            ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                       END) AS OperSumm_Partner
                  -- ����� �� ����������� - � ����������� �� 2-� ������ + !!!��!!! ������ ������ � ����
                , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                 THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                            ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                       END) AS OperSumm_Partner_original

                   -- ����� �� ����������� � ������ ������ ��� ���� - � ����������� �� 2-� ������
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                        END) AS OperSumm_Partner_ChangePrice
                   -- ����� �� ����������� � ������ ������ ��� ���� - � ����������� �� 2-� ������ !!!����!!!
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_calcFrom * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_calcFrom * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                        END) AS OperSumm_PartnerFrom_ChangePrice
                   -- ����� �� ����������� � ������ ������ ��� ���� - � ����������� �� 2-� ������ !!!� ������!!!
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) AS NUMERIC (16, 2))
                        END) AS OperSumm_Partner_ChangePrice_Currency


                   -- ����� �� ������������ - � ����������� �� 2-� ������
                 , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                  THEN CAST (tmpMI.OperCount_Packer * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                             ELSE CAST (tmpMI.OperCount_Packer * tmpMI.Price AS NUMERIC (16, 2))
                        END) AS OperSumm_Packer

                   -- ����� ����� �������
                 , SUM (tmpMI.OperSumm_Inventory) AS OperSumm_Inventory

                  -- ����� ���������� ��
                 , SUM (tmpMI.OperSumm_ToPay)       AS OperSumm_ToPay
                 , SUM (tmpMI.OperSumm_Service)     AS OperSumm_Service
                 , SUM (tmpMI.OperSumm_Card)        AS OperSumm_Card
                 , SUM (tmpMI.OperSumm_CardSecond)  AS OperSumm_CardSecond
                 , SUM (tmpMI.OperSumm_Nalog)       AS OperSumm_Nalog
                 , SUM (tmpMI.OperSumm_Minus)       AS OperSumm_Minus
                 , SUM (tmpMI.OperSumm_Add)         AS OperSumm_Add
                 , SUM (tmpMI.OperSumm_Holiday)     AS OperSumm_Holiday
                 , SUM (tmpMI.OperSumm_CardRecalc)  AS OperSumm_CardRecalc
                 , SUM (tmpMI.OperSumm_CardSecondRecalc)  AS OperSumm_CardSecondRecalc
                 , SUM (tmpMI.OperSumm_CardSecondCash)  AS OperSumm_CardSecondCash
                 , SUM (tmpMI.OperSumm_NalogRecalc) AS OperSumm_NalogRecalc
                 , SUM (tmpMI.OperSumm_SocialIn)    AS OperSumm_SocialIn
                 , SUM (tmpMI.OperSumm_SocialAdd)   AS OperSumm_SocialAdd
                 , SUM (tmpMI.OperSumm_Child)       AS OperSumm_Child
                 , SUM (tmpMI.OperSumm_ChildRecalc)      AS OperSumm_ChildRecalc
                 , SUM (tmpMI.OperSumm_MinusExt)         AS OperSumm_MinusExt
                 , SUM (tmpMI.OperSumm_MinusExtRecalc)   AS OperSumm_MinusExtRecalc
                 , SUM (tmpMI.OperSumm_Transport)        AS OperSumm_Transport
                 , SUM (tmpMI.OperSumm_TransportAdd)     AS OperSumm_TransportAdd
                 , SUM (tmpMI.OperSumm_TransportAddLong) AS OperSumm_TransportAddLong
                 , SUM (tmpMI.OperSumm_TransportTaxi)    AS OperSumm_TransportTaxi
                 , SUM (tmpMI.OperSumm_Phone)            AS OperSumm_Phone
                 , SUM (tmpMI.OperSumm_NalogRet)         AS OperSumm_NalogRet
                 , SUM (tmpMI.OperSumm_NalogRetRecalc)   AS OperSumm_NalogRetRecalc
            FROM (SELECT tmpMI.GoodsId
                       , tmpMI.GoodsKindId
                       , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                                   THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                              ELSE tmpMI.Price
                         END AS Price
                       , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                   -- ��� ����������� � ������ zc_Enum_Currency_Basis
                                   THEN CAST (tmpMI.Price_original * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                              ELSE tmpMI.Price_original
                         END AS Price_original
                       , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                   THEN tmpMI.Price
                              ELSE 0
                         END AS Price_Currency
                       , tmpMI.CountForPrice

                         -- ����� ������ ���-��, ��� ���� ������ ����
                       , tmpMI.OperCount_calc
                         -- �� ����� ������ ���-�� "����", ��� ���� ���� ������ ����
                       , tmpMI.OperCount_calcFrom

                         -- ���-�� Master (!!!��� ���� � �=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Master
                         END AS OperCount_Master
                         -- ���-�� Child (!!!��� ���� � �=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Child
                         END AS OperCount_Child
                         -- ���-�� Partner (!!!��� ���� � �=0!!!)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                               AND tmpMI.Price = 0
                                   THEN 0
                              ELSE tmpMI.OperCount_Partner
                         END AS OperCount_Partner

                       , tmpMI.OperCount_Packer
                       , tmpMI.OperCount_Second
                         -- ���� (���� ����=0)
                       , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                               AND tmpMI.Price = 0
                                   THEN CASE WHEN tmpMI.MovementDescId = zc_Movement_WeighingPartner()
                                                  THEN tmpMI.OperCount_Master
                                             ELSE tmpMI.OperCount_calc
                                        END
                              ELSE 0
                         END AS OperCount_Tare
                         -- �� (������)
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Sh
                         -- ��� (������)
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calc * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.OperCount_calc
                              ELSE 0
                         END AS OperCount_Kg
                         -- �� (����)
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calcFrom
                              ELSE 0
                         END AS OperCount_ShFrom
                         -- ��� (����)
                       , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                   THEN tmpMI.OperCount_calcFrom * COALESCE (ObjectFloat_Weight.ValueData, 0)
                              WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                   THEN tmpMI.OperCount_calcFrom
                              ELSE 0
                         END AS OperCount_KgFrom

                        -- ����� ����� �������
                      , tmpMI.OperSumm_Inventory

                        -- ����� ���������� ��
                      , tmpMI.OperSumm_ToPay
                      , tmpMI.OperSumm_Service
                      , tmpMI.OperSumm_Card
                      , tmpMI.OperSumm_CardSecond
                      , tmpMI.OperSumm_Nalog
                      , tmpMI.OperSumm_Minus
                      , tmpMI.OperSumm_Add
                      , tmpMI.OperSumm_Holiday
                      , tmpMI.OperSumm_CardRecalc
                      , tmpMI.OperSumm_CardSecondRecalc
                      , tmpMI.OperSumm_CardSecondCash
                      , tmpMI.OperSumm_NalogRecalc
                      , tmpMI.OperSumm_SocialIn
                      , tmpMI.OperSumm_SocialAdd
                      , tmpMI.OperSumm_Child
                      , tmpMI.OperSumm_ChildRecalc
                      , tmpMI.OperSumm_MinusExt
                      , tmpMI.OperSumm_MinusExtRecalc
                      , tmpMI.OperSumm_Transport
                      , tmpMI.OperSumm_TransportAdd
                      , tmpMI.OperSumm_TransportAddLong
                      , tmpMI.OperSumm_TransportTaxi
                      , tmpMI.OperSumm_Phone
                      , tmpMI.OperSumm_NalogRet
                      , tmpMI.OperSumm_NalogRetRecalc

                  FROM (SELECT Movement.DescId AS MovementDescId
                             , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN MovementItem.Id ELSE 0 END AS MovementItemId
                             , MovementItem.DescId
                             , MovementItem.ObjectId AS GoodsId
                             , MILinkObject_GoodsKind.ObjectId AS GoodsKindId

                             , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                         THEN CAST ( (1 + MIFloat_ChangePercent.ValueData / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                         THEN CAST ( (1 - vbDiscountPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                         THEN CAST ( (1 + vbExtraChargesPercent / 100) * COALESCE (MIFloat_Price.ValueData, 0) AS NUMERIC (16, 2))
                                    ELSE COALESCE (MIFloat_Price.ValueData, 0)
                               END AS Price
                             , COALESCE (MIFloat_Price.ValueData, 0) AS Price_original
                             , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

                             , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                               -- !!!����� ������ ���-��, ��� ���� ������ ����!!!
                             , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_EDI(), zc_Movement_WeighingPartner(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                          AND MovementItem.DescId IN (zc_MI_Master())
                                              THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                         WHEN MovementItem.DescId IN (zc_MI_Master())
                                              THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                         ELSE 0
                                    END) AS OperCount_calc
                               -- !!!�� ����� ������ ���-�� "����", ��� ���� ���� ������ ����!!!
                             , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale())
                                          AND MovementItem.DescId IN (zc_MI_Master())
                                              THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0)
                                         WHEN MovementItem.DescId IN (zc_MI_Master())
                                              THEN MovementItem.Amount
                                         ELSE 0
                                    END) AS OperCount_calcFrom

                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS OperCount_Master
                             , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Child
                             , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner -- ���������� � �����������
                             , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0))  AS OperCount_Packer  -- ���������� � ������������
                             , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))  AS OperCount_Second  -- ���������� �������

                             , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN MIFloat_Summ.ValueData ELSE 0 END, 0)) AS OperSumm_Inventory

                             , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0))         AS OperSumm_ToPay
                             , SUM (COALESCE (MIFloat_SummService.ValueData, 0))       AS OperSumm_Service
                             , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))          AS OperSumm_Card
                             , SUM (COALESCE (MIFloat_SummCardSecond.ValueData, 0))    AS OperSumm_CardSecond
                             , SUM (COALESCE (MIFloat_SummNalog.ValueData, 0))         AS OperSumm_Nalog
                             , SUM (COALESCE (MIFloat_SummMinus.ValueData, 0))         AS OperSumm_Minus
                             , SUM (COALESCE (MIFloat_SummAdd.ValueData, 0))           AS OperSumm_Add
                             , SUM (COALESCE (MIFloat_SummHoliday.ValueData, 0))       AS OperSumm_Holiday

                             , SUM (COALESCE (MIFloat_SummCardRecalc.ValueData, 0))         AS OperSumm_CardRecalc
                             , SUM (COALESCE (MIFloat_SummCardSecondRecalc.ValueData, 0))   AS OperSumm_CardSecondRecalc
                             , SUM (COALESCE (MIFloat_SummCardSecondCash.ValueData, 0))     AS OperSumm_CardSecondCash
                             , SUM (COALESCE (MIFloat_SummNalogRecalc.ValueData, 0))        AS OperSumm_NalogRecalc
                             , SUM (COALESCE (MIFloat_SummSocialIn.ValueData, 0))           AS OperSumm_SocialIn
                             , SUM (COALESCE (MIFloat_SummSocialAdd.ValueData, 0))          AS OperSumm_SocialAdd
                             , SUM (COALESCE (MIFloat_SummChild.ValueData, 0))              AS OperSumm_Child
                             , SUM (COALESCE (MIFloat_SummChildRecalc.ValueData, 0))        AS OperSumm_ChildRecalc
                             , SUM (COALESCE (MIFloat_SummMinusExt.ValueData, 0))           AS OperSumm_MinusExt
                             , SUM (COALESCE (MIFloat_SummMinusExtRecalc.ValueData, 0))     AS OperSumm_MinusExtRecalc

                             , SUM (COALESCE (MIFloat_SummTransport.ValueData, 0))        AS OperSumm_Transport
                             , SUM (COALESCE (MIFloat_SummTransportAdd.ValueData, 0))     AS OperSumm_TransportAdd
                             , SUM (COALESCE (MIFloat_SummTransportAddLong.ValueData, 0)) AS OperSumm_TransportAddLong
                             , SUM (COALESCE (MIFloat_SummTransportTaxi.ValueData, 0))    AS OperSumm_TransportTaxi
                             , SUM (COALESCE (MIFloat_SummPhone.ValueData, 0))            AS OperSumm_Phone
                             
                             , SUM (COALESCE (MIFloat_SummNalogRet.ValueData, 0))         AS OperSumm_NalogRet
                             , SUM (COALESCE (MIFloat_SummNalogRetRecalc.ValueData, 0))   AS OperSumm_NalogRetRecalc
                             
                        FROM Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased = FALSE
                             LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                              ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountChangePercent
                                                         ON MIFloat_AmountChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountChangePercent.DescId = zc_MIFloat_AmountChangePercent()
                                                        AND Movement.DescId IN (zc_Movement_SendOnPrice())
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountPacker
                                                         ON MIFloat_AmountPacker.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountPacker.DescId = zc_MIFloat_AmountPacker()
                             LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                         ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                                        AND Movement.DescId IN (zc_Movement_OrderExternal(), zc_Movement_OrderInternal())

                             LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                         ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                        AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                         ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                        AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                             LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                         ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummToPay
                                                         ON MIFloat_SummToPay.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummToPay.DescId = zc_MIFloat_SummToPay()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummService
                                                         ON MIFloat_SummService.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummService.DescId = zc_MIFloat_SummService()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCard
                                                         ON MIFloat_SummCard.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCard.DescId = zc_MIFloat_SummCard()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecond
                                                         ON MIFloat_SummCardSecond.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardSecond.DescId = zc_MIFloat_SummCardSecond()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummNalog
                                                         ON MIFloat_SummNalog.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummNalog.DescId = zc_MIFloat_SummNalog()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummMinus
                                                         ON MIFloat_SummMinus.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummMinus.DescId = zc_MIFloat_SummMinus()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                                         ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummHoliday
                                                         ON MIFloat_SummHoliday.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummHoliday.DescId = zc_MIFloat_SummHoliday()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardRecalc
                                                         ON MIFloat_SummCardRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardRecalc.DescId = zc_MIFloat_SummCardRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondRecalc
                                                         ON MIFloat_SummCardSecondRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardSecondRecalc.DescId = zc_MIFloat_SummCardSecondRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummCardSecondCash
                                                         ON MIFloat_SummCardSecondCash.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummCardSecondCash.DescId = zc_MIFloat_SummCardSecondCash()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRecalc
                                                         ON MIFloat_SummNalogRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummNalogRecalc.DescId = zc_MIFloat_SummNalogRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummSocialIn
                                                         ON MIFloat_SummSocialIn.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummSocialIn.DescId = zc_MIFloat_SummSocialIn()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummSocialAdd
                                                         ON MIFloat_SummSocialAdd.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummSocialAdd.DescId = zc_MIFloat_SummSocialAdd()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummChild
                                                         ON MIFloat_SummChild.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummChild.DescId = zc_MIFloat_SummChild()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummChildRecalc
                                                         ON MIFloat_SummChildRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummChildRecalc.DescId = zc_MIFloat_SummChildRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExt
                                                         ON MIFloat_SummMinusExt.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummMinusExt.DescId = zc_MIFloat_SummMinusExt()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummMinusExtRecalc
                                                         ON MIFloat_SummMinusExtRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummMinusExtRecalc.DescId = zc_MIFloat_SummMinusExtRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()

                             LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRet
                                                         ON MIFloat_SummNalogRet.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummNalogRet.DescId = zc_MIFloat_SummNalogRet()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummNalogRetRecalc
                                                         ON MIFloat_SummNalogRetRecalc.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummNalogRetRecalc.DescId = zc_MIFloat_SummNalogRetRecalc()
                                                        AND Movement.DescId = zc_Movement_PersonalService()
                                                        
                             LEFT JOIN MovementItemFloat AS MIFloat_SummTransport
                                                         ON MIFloat_SummTransport.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummTransport.DescId = zc_MIFloat_SummTransport()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAdd
                                                         ON MIFloat_SummTransportAdd.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummTransportAdd.DescId = zc_MIFloat_SummTransportAdd()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummTransportAddLong
                                                         ON MIFloat_SummTransportAddLong.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummTransportAddLong.DescId = zc_MIFloat_SummTransportAddLong()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummTransportTaxi
                                                         ON MIFloat_SummTransportTaxi.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummTransportTaxi.DescId = zc_MIFloat_SummTransportTaxi()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummPhone
                                                         ON MIFloat_SummPhone.MovementItemId = MovementItem.Id
                                                        AND MIFloat_SummPhone.DescId = zc_MIFloat_SummPhone()
                        WHERE Movement.Id = inMovementId
                        GROUP BY Movement.DescId
                               , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN MovementItem.Id ELSE 0 END
                               , MovementItem.DescId
                               , MovementItem.ObjectId
                               , MILinkObject_GoodsKind.ObjectId
                               , MIFloat_Price.ValueData
                               , MIFloat_CountForPrice.ValueData
                               , MIFloat_ChangePercent.ValueData
                       ) AS tmpMI

                       LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                             ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                            AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                            AND tmpMI.DescId = zc_MI_Master()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                            ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                       LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                            ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                           AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                       LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                 ) AS tmpMI
          ) AS _tmp
          ) AS _tmp;

     -- !!!�������� �������� - ����������� � ������ zc_Enum_Currency_Basis!!! - !!!������ ��� � ����������� � �������� �����!!!
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbParValue <> 0
     THEN
         vbOperSumm_Partner:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         vbOperSumm_PartnerFrom:= vbOperSumm_Partner;
         vbOperSumm_PVAT_original:= vbOperSumm_Partner;
         IF vbDiscountPercent = 0 AND vbExtraChargesPercent = 0
         THEN vbOperSumm_PVAT:= vbOperSumm_Partner;
         END IF;
         IF vbVATPercent = 0
         THEN vbOperSumm_MVAT:= vbOperSumm_Partner;
         END IF;
     END IF;


     -- ����
     -- RAISE EXCEPTION '%', vbOperCount_Master;

     IF vbMovementDescId IN (zc_Movement_PersonalSendCash(), zc_Movement_PersonalAccount(), zc_Movement_MobileBills(), zc_Movement_LossDebt(), zc_Movement_LossPersonal())
     THEN
         -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
     ELSE
     IF vbMovementDescId = zc_Movement_PersonalService()
     THEN
         -- ��������� �������� <�����  ����� (�������) >
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
         -- ��������� �������� <����� ����� (� �������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummToPay(), inMovementId, vbTotalSummToPay);
         -- ��������� �������� <����� ����� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummService(), inMovementId, vbTotalSummService);

         -- ��������� �������� <����� �� - 1�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCard(), inMovementId, vbTotalSummCard);
         -- ��������� �������� <����� �� - 2�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecond(), inMovementId, vbTotalSummCardSecond);
         -- ��������� �������� <������ - ��������� � ��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalog(), inMovementId, vbTotalSummNalog);
         -- ��������� �������� <����� ����� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinus(), inMovementId, vbTotalSummMinus);
         -- ��������� �������� <����� ����� ������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAdd(), inMovementId, vbTotalSummAdd);
         -- ��������� �������� <����� ����� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHoliday(), inMovementId, vbTotalSummHoliday);
         -- ��������� �������� <����� �� (����) - 1�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardRecalc(), inMovementId, vbTotalSummCardRecalc);
         -- ��������� �������� <����� �� (����) - 2�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecondRecalc(), inMovementId, vbTotalSummCardSecondRecalc);
         -- ��������� �������� <������ - ��������� � �� (����)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRecalc(), inMovementId, vbTotalSummNalogRecalc);

         -- ��������� �������� <����� �� (�����) - 2�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecondCash(), inMovementId, vbTotalSummCardSecondCash);

         -- ��������� �������� <����� ����� ��� ������� (�� ��������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialIn(), inMovementId, vbTotalSummSocialIn);
         -- ��������� �������� <����� ����� ��� ������� (���. � ��������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialAdd(), inMovementId, vbTotalSummSocialAdd);

         -- ��������� �������� <��������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChild(), inMovementId, vbTotalSummChild);
         -- ��������� �������� <�������� (����)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChildRecalc(), inMovementId, vbTotalSummChildRecalc);
         -- ��������� �������� < ��������� ���������� ��.�.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinusExt(), inMovementId, vbTotalSummMinusExt);
         -- ��������� �������� < ��������� ���������� ��.�. (����) >
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinusExtRecalc(), inMovementId, vbTotalSummMinusExtRecalc);

         -- ��������� �������� <����� ����� ��� (��������� �� ��������, ���� ����� ���� � ��������...)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransport(), inMovementId, vbTotalSummTransport);
         -- ��������� �������� <����� ����� ��������������� (�������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportAdd(), inMovementId, vbTotalSummTransportAdd);
         -- ��������� �������� <����� ����� ������������ (�������, ���� ���������������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportAddLong(), inMovementId, vbTotalSummTransportAddLong);
         -- ��������� �������� <����� ����� �� ����� (�������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportTaxi(), inMovementId, vbTotalSummTransportTaxi);

         -- ��������� �������� <����� ����� ���.����� (���������))>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPhone(), inMovementId, vbTotalSummPhone);
         
         -- ��������� �������� <������ - ���������� � ��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRet(), inMovementId, vbTotalSummNalogRet);
         -- ��������� �������� <������ - ���������� � �� (����)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRetRecalc(), inMovementId, vbTotalSummNalogRetRecalc);
     ELSE
         -- ��������� �������� <����� ����������("������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master + vbOperCount_Packer);
         -- ��������� �������� <����� ����������("����������� ��������")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
         -- ��������� �������� <����� ���������� � �����������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner);
         -- ��������� �������� <����� ����������, ����>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountTare(), inMovementId, vbOperCount_Tare);

         -- ��������� �������� <����� ����������, ��>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountSh(), inMovementId, vbOperCount_Sh);
         -- ��������� �������� <����� ����������, ���>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKg(), inMovementId, vbOperCount_Kg);
         IF vbMovementDescId = zc_Movement_SendOnPrice()
         THEN
             -- ��������� �������� <����� ����������, �� (����)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountShFrom(), inMovementId, vbOperCount_ShFrom);
             -- ��������� �������� <����� ����������, ��� (����)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKgFrom(), inMovementId, vbOperCount_KgFrom);
             -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������, ����)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFrom(), inMovementId, vbOperSumm_PartnerFrom);
         END IF;

         -- ��������� �������� <����� ����� �� ��������� (��� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- ��������� �������� <����� ����� �� ��������� (� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
         -- ��������� �������� <����� ����� ������ �� ���������>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange(), inMovementId, vbOperSumm_Partner - vbOperSumm_PVAT_original);
         -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, CASE WHEN vbMovementDescId = zc_Movement_Inventory() THEN vbOperSumm_Inventory ELSE vbOperSumm_Partner END);
         -- ��������� �������� <����� ����� !!!� ������!!! �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), inMovementId, vbOperSumm_Currency);
         -- ��������� �������� <����� ����� ������������ �� ��������� (� ������ ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPacker(), inMovementId, vbOperSumm_Packer);
     END IF;
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.18         * zc_Movement_LossPersonal
 05.01.18         * vbTotalSummNalogRet
                    vbTotalSummNalogRetRecalc
 20.06.17         * vbTotalSummCardSecondCash
 24.01.17         *
 16.01.15                                        * add !!!�����, ����������� � �������� �����!!!
 08.12.14                       * add NDSKind
 19.10.14                                        * add vbOperCount_Second
 09.08.14                                        * add zc_Movement_SendOnPrice
 19.07.14                                        * add zc_Movement_EDI
 22.05.14                                        * modify - ����� ������ ���-��, ��� ���� ������ ����
 08.05.14                                        * all
 03.05.14                                        * add zc_Movement_TransferDebtIn and zc_Movement_TransferDebtOut
 31.03.14                                        * add TotalCount...
 20.10.13                                        * add vbChangePrice
 03.10.13                                        * add zc_Movement_PersonalSendCash
 22.08.13                                        * add vbOperSumm_Inventory
 13.08.13                                        * add vbOperCount_Master and vbOperCount_Child
 16.07.13                                        * add COALESCE (MIFloat_AmountPartner... and MIFloat_AmountPacker...
 07.07.13                                        *
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- ����
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Sale() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
