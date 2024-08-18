
DROP FUNCTION IF EXISTS lpSelect_MovementFloat_TotalSumm1_Sale (Integer);

CREATE OR REPLACE FUNCTION lpSelect_MovementFloat_TotalSumm1_Sale(
    IN inMovementId Integer -- ���� ������� <��������>
)
RETURNS TABLE ( 
               TotalSummMVAT   TFloat
             , TotalSummPVAT   TFloat
             , TotalSumm       TFloat
)
 AS
$BODY$
  DECLARE vbMovementDescId  Integer;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbOperCount_Master TFloat;
   
  DECLARE vbOperSumm_Partner     TFloat;
  DECLARE vbOperSumm_MVAT          TFloat;
  DECLARE vbOperSumm_PVAT          TFloat;
  DECLARE vbOperSumm_PVAT_original TFloat;
  DECLARE vbOperSumm_VAT_2018      TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;
  DECLARE vbPaidKindId Integer;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;

  DECLARE vbCurrencyDocumentId Integer;
  DECLARE vbCurrencyPartnerId Integer;
  DECLARE vbCurrencyValue TFloat;
  DECLARE vbParValue TFloat;
  DECLARE vbCurrencyPartnerValue TFloat;
  DECLARE vbParPartnerValue TFloat;

  DECLARE vbIsNPP_calc Boolean;
  DECLARE vbDocumentTaxKindId Integer;
  DECLARE vbDocumentTaxKindId_tax Integer;

  DECLARE vbPartnerName TVarChar;
BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     -- ��� ��������� ����� ��� ������� �������� ���� �� ����������� � ������������
     SELECT Movement.DescId
          , CASE WHEN Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_SendOnPrice())
                      THEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
                 ELSE Movement.OperDate
            END AS OperDatePartner
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE(ObjectFloat_NDSKind_NDS.ValueData, COALESCE (MovementFloat_VATPercent.ValueData, 0))
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 AND Movement.DescId <> zc_Movement_ChangePercent() THEN -1 * MovementFloat_ChangePercent.ValueData
                 WHEN Movement.DescId = zc_Movement_ChangePercent() THEN COALESCE (MovementFloat_ChangePercent.ValueData, 0)
                 ELSE 0
            END AS DiscountPercent
          , CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 AND Movement.DescId <> zc_Movement_ChangePercent() THEN MovementFloat_ChangePercent.ValueData
                 WHEN Movement.DescId = zc_Movement_ChangePercent() THEN 0
                 ELSE 0
            END AS ExtraChargesPercent
          , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, FALSE)  AS isDiscountPrice_juridical
          , COALESCE (MovementFloat_ChangePrice.ValueData, 0)          AS ChangePrice
          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)         AS PaidKindId

          , COALESCE (MovementLinkObject_CurrencyDocument.ObjectId, zc_Enum_Currency_Basis()) AS CurrencyDocumentId
          , COALESCE (MovementLinkObject_CurrencyPartner.ObjectId, zc_Enum_Currency_Basis())  AS CurrencyPartnerId
          , COALESCE (MovementFloat_CurrencyValue.ValueData, 0)                               AS CurrencyValue
          , COALESCE (MovementFloat_ParValue.ValueData, 0)                                    AS ParValue
          , COALESCE (MovementFloat_CurrencyPartnerValue.ValueData, 0)                        AS CurrencyPartnerValue
          , COALESCE (MovementFloat_ParPartnerValue.ValueData, 0)                             AS ParPartnerValue
          
          , Object_Partner.ValueData AS vbPartnerName

            INTO vbMovementDescId, vbOperDatePartner, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice, vbChangePrice, vbPaidKindId
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
               , vbPartnerName

      FROM Movement
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
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

           LEFT JOIN MovementLinkObject AS MovementLinkObject_FromTo
                                        ON MovementLinkObject_FromTo.MovementId = Movement.Id
                                       AND MovementLinkObject_FromTo.DescId     = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() END

           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_FromTo.ObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_FromTo.ObjectId
                               AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                   ON ObjectBoolean_isDiscountPrice.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                  AND ObjectBoolean_isDiscountPrice.DescId   = zc_ObjectBoolean_Juridical_isDiscountPrice()

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
                                  AND MovementFloat_CurrencyPartnerValue.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Income(),zc_Movement_OrderIncome(), zc_Movement_Invoice()) THEN zc_MovementFloat_CurrencyValue() ELSE zc_MovementFloat_CurrencyPartnerValue() END
           LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                   ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                  AND MovementFloat_ParPartnerValue.DescId = CASE WHEN Movement.DescId IN (zc_Movement_Income(),zc_Movement_OrderIncome(), zc_Movement_Invoice()) THEN zc_MovementFloat_ParValue() ELSE zc_MovementFloat_ParPartnerValue() END

      WHERE Movement.Id = inMovementId;



     -- !!!���� ���������� - ���� �� ������ � ����!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
     THEN
         vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- � �� ���� ���� �����
                        OR vbPaidKindId <> zc_Enum_PaidKind_SecondForm()         -- ��� ��
                        OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0) -- � ����� ���� ������, �� ���� ���� ���� ������� �� ������� = 0%
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
            -- ����� ��� ���
           CAST (OperSumm_MVAT
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

            -- ����� ���
          , OperSumm_VAT_2018

            -- ����� �� �����������
          , CAST (OperSumm_Partner
                  -- ��� ����������� � ������ zc_Enum_Currency_Basis
                -- !!!�����, ����������� � �������� �����!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner
           

           INTO  vbOperSumm_MVAT          -- ����� ��� ���
               , vbOperSumm_PVAT          -- ����� � ���
               , vbOperSumm_PVAT_original -- ����� � ��� + !!!��!!! ������ ������ � ����
               , vbOperSumm_VAT_2018      -- ����� ���
               , vbOperSumm_Partner       -- ����� �� �����������
            

     FROM  -- ������ �������� �����
          (WITH --tmpMI_child_ReturnIn AS (SELECT MovementItem.ParentId       AS ParentId
                                             
                tmpMI AS (SELECT Movement.DescId AS MovementDescId
                               , 0 AS MovementItemId
                               , MovementItem.DescId
                               , MovementItem.ObjectId           AS GoodsId
                               , MILinkObject_GoodsKind.ObjectId AS GoodsKindId

                               , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= -1 * vbDiscountPercent
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= 1 * vbExtraChargesPercent
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                 END AS Price
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS Price_original
                               , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice


                                 -- !!!����� ������ ���-��, ��� ���� ������ ����!!!
                               , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_EDI(), zc_Movement_WeighingPartner(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                            AND MovementItem.DescId IN (zc_MI_Master())
                                                THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                           WHEN MovementItem.DescId IN (zc_MI_Master())
                                                THEN MovementItem.Amount 
                                           ELSE 0
                                      END) AS OperCount_calc
                       
                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Master
                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner -- ���������� � �����������

                          FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.isErased = FALSE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                                ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                                                               AND vbPartnerName NOT ILIKE '%Ѳ����-��� ���%'
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                                ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                                                               AND vbPartnerName NOT ILIKE '%Ѳ����-��� ���%'


                               LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                               LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()

                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                          WHERE Movement.Id = inMovementId
                          GROUP BY Movement.DescId
                                 , MovementItem.DescId
                                 , MovementItem.ObjectId
                                 , MILinkObject_GoodsKind.ObjectId
                                 , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                      , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                      , inChangePercent:= -1 * vbDiscountPercent
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!��� ��� �� ���������!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                      , inChangePercent:= 1 * vbExtraChargesPercent
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                   END
                                 , MIFloat_Price.ValueData
                                 , MIFloat_CountForPrice.ValueData
                                 , MIFloat_ChangePercent.ValueData
                         )

-------------------
           SELECT
                 
                  -- ����� ��� ���
                  CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
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
                , CASE
                       -- ���� ���� � ���
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Partner)
                       -- ���� ���� ��� ���, � ����� ����� ��� ��� - 6 ������
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            THEN OperSumm_Partner + OperSumm_VAT_2018

                       -- ���� ���� ��� ���
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2)) 
                            
                  END AS OperSumm_PVAT

                  -- ����� � ��� + !!!��!!! ������ ������ � ����
                , CASE -- ���� ���� � ���
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Partner_original)

                       -- ���� ���� ��� ���, � ����� ����� ��� ��� - 6 ������
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                            THEN OperSumm_Partner_original + OperSumm_VAT_2018_original

                       -- ���� ���� ��� ���
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_original) AS NUMERIC (16, 2))
                  END AS OperSumm_PVAT_original

                , OperSumm_VAT_2018

                  -- ����� �� �����������
                , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                          -- ���� ���� � ��� ��� %���=0, ����� ��������� ��� % ������ ��� % ������� !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_Partner_ChangePrice)
                               END

                       -- ���� ���� ��� ���, � ����� ����� ��� ��� - 6 ������
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                            THEN OperSumm_Partner_ChangePrice + OperSumm_VAT_2018

                       -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� � ��� (���� ������� ����� � ��� ��� � ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END

                       -- ���� ���� ��� ���, ����� ��������� ��� % ������ ��� % ������� ��� ����� ��� ���, ��������� �� 2-� ������, � ����� ��������� ��� (���� ������� ����� ������������ ��� ��) !!!�� ��� �� � "������" ��� - ������/������� ������ � ����!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Partner
                  
          FROM
                 -- �������� 1 ������ + !!! �������� � ������ ���� ����!!!
                (SELECT SUM (tmpMI.OperCount_Master) AS OperCount_Master
                      , SUM (tmpMI.OperCount_Partner) AS OperCount_Partner -- ���������� � �����������

                        -- ����� ����� ��� ����� ��� - 6 ������
                      , CAST (
                        SUM (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                                       -- ���� ���� � ���
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / (100 + vbVATPercent)
                                                  AS NUMERIC (16, 6))
                                  WHEN vbVATPercent > 0
                                       -- ���� ���� ��� ���
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / 100
                                                  AS NUMERIC (16, 6))
                             END)
                        AS NUMERIC (16, 2)) AS OperSumm_VAT_2018

                        -- ����� ����� ��� ����� ��� - 6 ������ + !!!��!!! ������ ������ � ����
                      , CAST (
                        SUM (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                                       -- ���� ���� � ���
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / (100 + vbVATPercent)
                                                  AS NUMERIC (16, 6))
                                  WHEN vbVATPercent > 0
                                       -- ���� ���� ��� ���
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / 100
                                                  AS NUMERIC (16, 6))
                             END)
                        AS NUMERIC (16, 2)) AS OperSumm_VAT_2018_original

                        -- ����� �� ����������� - � ����������� �� 2-� ������
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                             END
                          
                             ) AS OperSumm_Partner
                        -- ����� �� ����������� - � ����������� �� 2-� ������ + !!!��!!! ������ ������ � ����
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                             END) AS OperSumm_Partner_original

                         -- ����� �� ����������� � ������ ������ ��� ���� - � ����������� �� 2-� ������
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                             END
                         
                            ) AS OperSumm_Partner_ChangePrice
                       
                  FROM (SELECT tmpMI.GoodsId
                             , tmpMI.GoodsKindId
                             , tmpMI.myLevel

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
                               
                             , tmpMI.CountForPrice
                             
                               -- ����� ������ ���-��, ��� ���� ������ ����
                             , tmpMI.OperCount_calc

                               -- ���-�� Master (!!!��� ���� � �=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Master
                               END AS OperCount_Master
                             
                               -- ���-�� Partner (!!!��� ���� � �=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- ��������� ����
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Partner
                               END AS OperCount_Partner

                        FROM (SELECT tmpMI.MovementDescId
                                   , tmpMI.MovementItemId
                                   , tmpMI.DescId
                                   , tmpMI.GoodsId
                                   , tmpMI.GoodsKindId

                                     -- !!! ������ ������ !!!
                                   , 1 AS myLevel
                                     -- !!! ������ ������ !!!
                                   , tmpMI.Price AS Price

                                   , tmpMI.Price_original
                                  
                                   , tmpMI.CountForPrice

                                 
                                    -- !!!����� ������ ���-��, ��� ���� ������ ����!!! - !!! ������ ������ !!!
                                   , (tmpMI.OperCount_calc ) AS OperCount_calc
                                     -- !!!�� ����� ������ ���-�� "����", ��� ���� ���� ������ ����!!!
                               
                                     -- !!!������ ���-��, ��� ���� zc_MovementFloat_TotalCount !!! - !!! ������ ������ !!!
                                   , (tmpMI.OperCount_Master ) AS OperCount_Master

                                   , tmpMI.OperCount_Partner -- ���������� � �����������
                                  
                              FROM tmpMI
                             ) AS tmpMI

                             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                   ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                                  AND tmpMI.DescId = zc_MI_Master()
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
         
         vbOperSumm_PVAT_original:= vbOperSumm_Partner;
         IF vbDiscountPercent = 0 AND vbExtraChargesPercent = 0
         THEN vbOperSumm_PVAT:= vbOperSumm_Partner;
         END IF;
         IF vbVATPercent = 0
         THEN vbOperSumm_MVAT:= vbOperSumm_Partner;
         END IF;
     END IF;

     -- ����
      --RAISE EXCEPTION 'Summ_MVAT %  Summ_PVAT %   Summ %', vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner ;
      -- ���������
    RETURN QUERY

     SELECT vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner ;
     --
     --IF inMovementId = 24935207
     --THEN
     --    RAISE EXCEPTION '������.<%>  %', FALSE /*vbIsNPP_calc*/, vbOperSumm_MVAT;
     --END IF;


     -- ��������� �������� <����� ����� �� ��������� (��� ���)>1
        
     /* 
         -- ��������� �������� <����� ����� �� ��������� (��� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- ��������� �������� <����� ����� �� ��������� (� ���)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
          -- ��������� �������� <����� ����� �� ��������� (� ������ ��� � ������)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_Partner );
       
    */

if  inMovementId = 25153488 and 1=0
then
    RAISE EXCEPTION '������.<%>', vbTotalSummAvCardSecondRecalc;
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.08.24         *
*/
-- ����
-- 
SELECT * from lpSelect_MovementFloat_TotalSumm1_Sale (28765855) 