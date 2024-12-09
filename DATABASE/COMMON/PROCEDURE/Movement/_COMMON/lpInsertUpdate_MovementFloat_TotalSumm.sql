-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId  Integer;
  DECLARE vbOperDatePartner TDateTime;

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
  DECLARE vbOperSumm_Packer        TFloat;
  DECLARE vbOperSumm_MVAT          TFloat;
  DECLARE vbOperSumm_PVAT          TFloat;
  DECLARE vbOperSumm_PVAT_original TFloat;
  DECLARE vbOperSumm_VAT_2018      TFloat;
  DECLARE vbOperSumm_Inventory     TFloat;
  DECLARE vbOperSumm_LossAsset     TFloat;
  DECLARE vbOperSumm_Tare          TFloat; 
  DECLARE vbCostPromo_PromoTrade   TFloat;

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
  DECLARE vbTotalSummAuditAdd         TFloat;
  DECLARE vbTotalSummHouseAdd         TFloat;
  DECLARE vbTotalDayAudit             TFloat;
  DECLARE vbTotalSummHoliday          TFloat;
  DECLARE vbTotalSummSocialIn         TFloat;
  DECLARE vbTotalSummSocialAdd        TFloat;
  DECLARE vbTotalSummChild            TFloat;
  DECLARE vbTotalSummChildRecalc      TFloat;
  DECLARE vbTotalSummMinusExt         TFloat;
  DECLARE vbTotalSummMinusExtRecalc   TFloat;
  DECLARE vbTotalSummAddOth           TFloat;
  DECLARE vbTotalSummAddOthRecalc     TFloat;
  DECLARE vbTotalSummFine             TFloat;
  DECLARE vbTotalSummFineOth          TFloat;
  DECLARE vbTotalSummFineOthRecalc    TFloat;
  DECLARE vbTotalSummHosp             TFloat;
  DECLARE vbTotalSummHospOth          TFloat;
  DECLARE vbTotalSummHospOthRecalc    TFloat;
  DECLARE vbTotalSummCompensation       TFloat;
  DECLARE vbTotalSummCompensationRecalc TFloat;
  DECLARE vbTotalSummAvance            TFloat;
  DECLARE vbTotalSummAvanceRecalc      TFloat;
  DECLARE vbTotalSummAvCardSecond            TFloat;
  DECLARE vbTotalSummAvCardSecondRecalc      TFloat;

  DECLARE vbTotalSummMedicdayAdd    TFloat;
  DECLARE vbTotalDayMedicday        TFloat;
  DECLARE vbTotalSummSkip           TFloat;
  DECLARE vbTotalDaySkip            TFloat;

  DECLARE vbTotalSummTransport        TFloat;
  DECLARE vbTotalSummTransportAdd     TFloat;
  DECLARE vbTotalSummTransportAddLong TFloat;
  DECLARE vbTotalSummTransportTaxi    TFloat;
  DECLARE vbTotalSummPhone            TFloat;
  DECLARE vbTotalHeadCount_Master     TFloat;
  DECLARE vbTotalHeadCount_Child      TFloat;
  DECLARE vbTotalLiveWeight           TFloat;

  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbExtraChargesPercent TFloat;
  DECLARE vbChangePrice TFloat;
  DECLARE vbPaidKindId Integer;
  DECLARE vbIsChangePrice Boolean;
  DECLARE vbIsDiscountPrice Boolean;  
  DECLARE vbIsTotalSumm_GoodsReal Boolean;

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
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     -- Эти параметры нужны для расчета конечных сумм по Контрагенту и Заготовителю
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
          , COALESCE (MovementBoolean_TotalSumm_GoodsReal.ValueData, FALSE)                   AS isTotalSumm_GoodsReal

            INTO vbMovementDescId, vbOperDatePartner, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbExtraChargesPercent, vbIsDiscountPrice, vbChangePrice, vbPaidKindId
               , vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyValue, vbParValue, vbCurrencyPartnerValue, vbParPartnerValue
               , vbPartnerName, vbIsTotalSumm_GoodsReal

      FROM Movement
           LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                  ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                 AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
           LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                     ON MovementBoolean_PriceWithVAT.MovementId = Movement.Id
                                    AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

           LEFT JOIN MovementBoolean AS MovementBoolean_TotalSumm_GoodsReal
                                     ON MovementBoolean_TotalSumm_GoodsReal.MovementId =  Movement.Id
                                    AND MovementBoolean_TotalSumm_GoodsReal.DescId = zc_MovementBoolean_TotalSumm_GoodsReal()

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


     -- !!!надо ОПРЕДЕЛИТЬ - НОВАЯ схема для TaxCorrective с 30.03.18!!!
     IF vbMovementDescId = zc_Movement_TaxCorrective()
     THEN
         -- !!!ОПРЕДЕЛИЛИ!!!
         vbDocumentTaxKindId:= COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()), 0);
         vbDocumentTaxKindId_tax:= COALESCE ((SELECT MLO.ObjectId
                                              FROM MovementLinkMovement AS MLM
                                                   LEFT JOIN MovementLinkObject AS MLO
                                                                                ON MLO.MovementId = MLM.MovementChildId
                                                                               AND MLO.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                                              WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Child()
                                             ), 0);
         -- !!!ОПРЕДЕЛИЛИ!!!
         vbIsNPP_calc:= EXISTS (SELECT 1
                                FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_NPPTax_calc
                                                                 ON MIFloat_NPPTax_calc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_NPPTax_calc.DescId         = zc_MIFloat_NPPTax_calc()
                                     LEFT JOIN MovementItemFloat AS MIFloat_NPP_calc
                                                                 ON MIFloat_NPP_calc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_NPP_calc.DescId         = zc_MIFloat_NPP_calc()
                                     LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                                 ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                                AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                                  AND MovementItem.Amount     <> 0
                                  AND (MIFloat_NPPTax_calc.ValueData    <> 0
                                    OR MIFloat_NPP_calc.ValueData       <> 0
                                    OR MIFloat_AmountTax_calc.ValueData <> 0
                                      )
                               );
     ELSE
         vbIsNPP_calc:= FALSE;
     END IF;


     -- !!!надо определить - есть ли скидка в цене!!!
     IF vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal())
     THEN
         vbIsChangePrice:= vbIsDiscountPrice = TRUE                              -- у Юр лица есть галка
                        OR vbPaidKindId <> zc_Enum_PaidKind_SecondForm()         -- это БН
                        OR ((vbDiscountPercent > 0 OR vbExtraChargesPercent > 0) -- в шапке есть скидка, но есть хоть один элемент со скидкой = 0%
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


     -- Перевод Итоговых сумм в валюту (если надо)
     SELECT
            -- Количество по факту (главные элементы)
            OperCount_Master
            -- Количество по факту (подчиненные элементы)
          , OperCount_Child
            -- Количество по Контрагенту
          , OperCount_Partner
            -- Количество дозаказ
          , OperCount_Second
            -- Количество тары !!!по Контрагенту!!!
          , OperCount_Tare
            -- Количество шт !!!по Контрагенту!!!
          , OperCount_Sh
            -- Количество вес !!!по Контрагенту!!!
          , OperCount_Kg
            -- Количество шт !!!ушло!!!
          , OperCount_ShFrom
            -- Количество вес !!!ушло!!!
          , OperCount_KgFrom

            -- Сумма без НДС
          , CAST (OperSumm_MVAT
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_MVAT

            -- Сумма с НДС
          , CAST (OperSumm_PVAT
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PVAT
            -- Сумма с НДС + !!!НЕ!!! учтена скидка в цене
          , CAST (OperSumm_PVAT_original
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PVAT_original

            -- Сумма НДС
          , OperSumm_VAT_2018

            -- Сумма по Контрагенту
          , CAST (OperSumm_Partner
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner
            -- Сумма по Контрагенту !!!ушло!!!
          , CAST (OperSumm_PartnerFrom
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PartnerFrom

            -- Сумма в валюте
          , CAST (CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN OperSumm_Partner_Currency ELSE OperSumm_Partner END
                  -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbMovementDescId <> zc_Movement_Invoice() AND vbMovementDescId <> zc_Movement_Income() AND vbMovementDescId <> zc_Movement_OrderIncome()
                       THEN CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue / vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
                       ELSE 1
                  END
            AS NUMERIC (16, 2)) AS OperSumm_Currency

            -- оборотная тара
          , OperSumm_Tare


            -- Количество по Заготовителю
          , OperCount_Packer AS OperCount_Packer

            -- Сумма по Заготовителю
          , OperSumm_Packer AS OperSumm_Packer

            -- сумма ввода остатка
          , OperSumm_Inventory AS OperSumm_Inventory
            --
          , OperSumm_LossAsset
          --
          , CostPromo_PromoTrade

            -- сумма начисления зп
          , OperSumm_ToPay
          , OperSumm_Service
          , OperSumm_Card
          , OperSumm_CardSecond
          , OperSumm_Nalog
          , OperSumm_Minus
          , OperSumm_Add
          , OperSumm_AuditAdd

          , OperDayAudit

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
          , OperSumm_HouseAdd
          , OperSumm_NalogRet
          , OperSumm_NalogRetRecalc
          , OperSumm_Avance
          , OperSumm_AvanceRecalc

          , OperSumm_AvCardSecond
          , OperSumm_AvCardSecondRecalc

          , OperSumm_AddOth
          , OperSumm_AddOthRecalc
          , OperSumm_Fine
          , OperSumm_Hosp
          , OperSumm_FineOth
          , OperSumm_HospOth
          , OperSumm_FineOthRecalc
          , OperSumm_HospOthRecalc

          , OperSumm_Compensation
          , OperSumm_CompensationRecalc

          , OperHeadCount_Master
          , OperHeadCount_Child
          , OperLiveWeight

          , OperSumm_MedicdayAdd
          , OperDayMedicday
          , OperSumm_Skip
          , OperDaySkip

            INTO vbOperCount_Master, vbOperCount_Child, vbOperCount_Partner, vbOperCount_Second, vbOperCount_Tare, vbOperCount_Sh, vbOperCount_Kg, vbOperCount_ShFrom, vbOperCount_KgFrom

               , vbOperSumm_MVAT          -- Сумма без НДС
               , vbOperSumm_PVAT          -- Сумма с НДС
               , vbOperSumm_PVAT_original -- Сумма с НДС + !!!НЕ!!! учтена скидка в цене
               , vbOperSumm_VAT_2018      -- Сумма НДС
               , vbOperSumm_Partner       -- Сумма по Контрагенту
               , vbOperSumm_PartnerFrom   -- Сумма по Контрагенту !!!ушло!!!
               , vbOperSumm_Currency      -- Сумма в валюте

                 -- оборотная тара
               , vbOperSumm_Tare

               , vbOperCount_Packer       -- Количество по Заготовителю
               , vbOperSumm_Packer        -- Сумма по Заготовителю
               , vbOperSumm_Inventory     -- сумма ввода остатка
               , vbOperSumm_LossAsset  
               , vbCostPromo_PromoTrade

                 -- сумма начисления зп
               , vbTotalSummToPay, vbTotalSummService, vbTotalSummCard, vbTotalSummCardSecond, vbTotalSummNalog, vbTotalSummMinus
               , vbTotalSummAdd, vbTotalSummAuditAdd, vbTotalDayAudit

               , vbTotalSummHoliday
               , vbTotalSummCardRecalc, vbTotalSummCardSecondRecalc, vbTotalSummCardSecondCash, vbTotalSummNalogRecalc
               , vbTotalSummSocialIn, vbTotalSummSocialAdd
               , vbTotalSummChild, vbTotalSummChildRecalc, vbTotalSummMinusExt, vbTotalSummMinusExtRecalc

               , vbTotalSummTransport, vbTotalSummTransportAdd, vbTotalSummTransportAddLong
               , vbTotalSummTransportTaxi, vbTotalSummPhone, vbTotalSummHouseAdd
               , vbTotalSummNalogRet, vbTotalSummNalogRetRecalc, vbTotalSummAvance, vbTotalSummAvanceRecalc

               , vbTotalSummAvCardSecond, vbTotalSummAvCardSecondRecalc

               , vbTotalSummAddOth, vbTotalSummAddOthRecalc
               , vbTotalSummFine, vbTotalSummHosp, vbTotalSummFineOth, vbTotalSummHospOth, vbTotalSummFineOthRecalc, vbTotalSummHospOthRecalc

               , vbTotalSummCompensation, vbTotalSummCompensationRecalc

               , vbTotalHeadCount_Master, vbTotalHeadCount_Child 
               , vbTotalLiveWeight

               , vbTotalSummMedicdayAdd, vbTotalDayMedicday, vbTotalSummSkip, vbTotalDaySkip

     FROM  -- Расчет Итоговых суммы
          (WITH tmpMI_child_ReturnIn AS (SELECT MovementItem.ParentId       AS ParentId
                                              , MAX (Movement_Tax.OperDate) AS OperDate_tax
                                         FROM MovementItem
                                              LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                                          ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                                         AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                                              LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MIFloat_MovementId.ValueData :: Integer
                                              LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Tax
                                                                             ON MovementLinkMovement_Tax.MovementId = Movement_Sale.Id
                                                                            AND MovementLinkMovement_Tax.DescId     = zc_MovementLinkMovement_Master()
                                              LEFT JOIN Movement AS Movement_Tax ON Movement_Tax.Id = MovementLinkMovement_Tax.MovementChildId
                                         WHERE MovementItem.MovementId = inMovementId
                                           AND MovementItem.DescId     = zc_MI_Child()
                                           AND MovementItem.isErased   = FALSE
                                           AND MovementItem.Amount     <> 0
                                           AND vbMovementDescId = zc_Movement_ReturnIn()
                                         GROUP BY MovementItem.ParentId
                                        )
              , tmpMI AS (SELECT Movement.DescId AS MovementDescId
                               , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN MovementItem.Id ELSE 0 END AS MovementItemId
                               , MovementItem.DescId
                               , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId) AS GoodsId
                               , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId) AS GoodsKindId

                               , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                    , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                    , inChangePercent:= -1 * vbDiscountPercent
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                           THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                    , inChangePercent:= 1 * vbExtraChargesPercent
                                                                    , inPrice        := MIFloat_Price.ValueData
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                 END AS Price
                               , COALESCE (MIFloat_Price.ValueData, 0)         AS Price_original
                               , COALESCE (MIFloat_PriceTare.ValueData, 0)     AS PriceTare
                               , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice

                                 -- округлили
                               , CASE WHEN vbMovementDescId = zc_Movement_ChangePercent()
                                           THEN CAST (MIFloat_Price.ValueData * vbDiscountPercent / 100 AS NUMERIC (16, 2))
                                      ELSE 0
                                 END AS Price_ChangePercent

                               , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent

                                 -- !!!очень важное кол-во, для него расчет сумм!!!
                               , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_EDI(), zc_Movement_WeighingPartner(), zc_Movement_Income(), zc_Movement_ReturnOut())
                                            AND MovementItem.DescId IN (zc_MI_Master())
                                                THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                           WHEN MovementItem.DescId IN (zc_MI_Master())
                                                THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                                           ELSE 0
                                      END) AS OperCount_calc
                                 -- !!!не очень важное кол-во "ушло", для него тоже расчет сумм!!!
                               , SUM (CASE WHEN Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Sale())
                                            AND MovementItem.DescId IN (zc_MI_Master())
                                                THEN COALESCE (MIFloat_AmountChangePercent.ValueData, 0)
                                           WHEN MovementItem.DescId IN (zc_MI_Master())
                                                THEN MovementItem.Amount
                                           ELSE 0
                                      END) AS OperCount_calcFrom

                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS OperCount_Master
                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END) AS OperCount_Child
                               , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS OperCount_Partner -- Количество у контрагента
                               , SUM (COALESCE (MIFloat_AmountPacker.ValueData, 0))  AS OperCount_Packer  -- Количество у заготовителя
                               , SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0))  AS OperCount_Second  -- Количество дозаказ

                               , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_Inventory() THEN MIFloat_Summ.ValueData ELSE 0 END, 0)) AS OperSumm_Inventory
                               , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_LossAsset() THEN MIFloat_Summ.ValueData ELSE 0 END, 0)) AS OperSumm_LossAsset
                               , SUM (COALESCE (CASE WHEN Movement.DescId = zc_Movement_PromoTrade() THEN MIFloat_Summ.ValueData ELSE 0 END, 0)) AS CostPromo_PromoTrade

                               , SUM (COALESCE (MIFloat_SummToPay.ValueData, 0))              AS OperSumm_ToPay
                               , SUM (COALESCE (MIFloat_SummService.ValueData, 0))            AS OperSumm_Service
                               , SUM (COALESCE (MIFloat_SummCard.ValueData, 0))               AS OperSumm_Card
                               , SUM (COALESCE (MIFloat_SummCardSecond.ValueData, 0))         AS OperSumm_CardSecond
                               , SUM (COALESCE (MIFloat_SummNalog.ValueData, 0))              AS OperSumm_Nalog
                               , SUM (COALESCE (MIFloat_SummMinus.ValueData, 0))              AS OperSumm_Minus
                               , SUM (COALESCE (MIFloat_SummAdd.ValueData, 0))                AS OperSumm_Add
                               , SUM (COALESCE (MIFloat_SummAuditAdd.ValueData, 0))           AS OperSumm_AuditAdd
                               , SUM (COALESCE (MIFloat_DayAudit.ValueData, 0))               AS OperDayAudit
                               , SUM (COALESCE (MIFloat_SummHoliday.ValueData, 0))            AS OperSumm_Holiday

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

                               , SUM (COALESCE (MIFloat_SummTransport.ValueData, 0))          AS OperSumm_Transport
                               , SUM (COALESCE (MIFloat_SummTransportAdd.ValueData, 0))       AS OperSumm_TransportAdd
                               , SUM (COALESCE (MIFloat_SummTransportAddLong.ValueData, 0))   AS OperSumm_TransportAddLong
                               , SUM (COALESCE (MIFloat_SummTransportTaxi.ValueData, 0))      AS OperSumm_TransportTaxi
                               , SUM (COALESCE (MIFloat_SummPhone.ValueData, 0))              AS OperSumm_Phone
                               , SUM (COALESCE (MIFloat_SummHouseAdd.ValueData, 0))           AS OperSumm_HouseAdd

                               , SUM (COALESCE (MIFloat_SummNalogRet.ValueData, 0))           AS OperSumm_NalogRet
                               , SUM (COALESCE (MIFloat_SummNalogRetRecalc.ValueData, 0))     AS OperSumm_NalogRetRecalc

                               , SUM (COALESCE (MIFloat_SummAvance.ValueData, 0))             AS OperSumm_Avance
                               , SUM (COALESCE (MIFloat_SummAvanceRecalc.ValueData, 0))       AS OperSumm_AvanceRecalc
                               , SUM (COALESCE (MIFloat_SummAvCardSecond.ValueData, 0))       AS OperSumm_AvCardSecond
                               , SUM (COALESCE (MIFloat_SummAvCardSecondRecalc.ValueData, 0)) AS OperSumm_AvCardSecondRecalc

                               , SUM (COALESCE (MIFloat_AmountTax_calc.ValueData, 0))         AS AmountTax_calc
                               , SUM (COALESCE (MIFloat_SummTaxDiff_calc.ValueData, 0))       AS SummTaxDiff_calc
                               , SUM (COALESCE (MIFloat_PriceTax_calc.ValueData, 0))          AS PriceTax_calc

                               , SUM (COALESCE (MIFloat_SummAddOth.ValueData, 0))             AS OperSumm_AddOth
                               , SUM (COALESCE (MIFloat_SummAddOthRecalc.ValueData, 0))       AS OperSumm_AddOthRecalc
                               , SUM (COALESCE (MIFloat_SummFine.ValueData, 0))               AS OperSumm_Fine
                               , SUM (COALESCE (MIFloat_SummHosp.ValueData, 0))               AS OperSumm_Hosp
                               , SUM (COALESCE (MIFloat_SummFineOth.ValueData, 0))            AS OperSumm_FineOth
                               , SUM (COALESCE (MIFloat_SummHospOth.ValueData, 0))            AS OperSumm_HospOth
                               , SUM (COALESCE (MIFloat_SummFineOthRecalc.ValueData, 0))      AS OperSumm_FineOthRecalc
                               , SUM (COALESCE (MIFloat_SummHospOthRecalc.ValueData, 0))      AS OperSumm_HospOthRecalc

                               , SUM (COALESCE (MIFloat_SummCompensation.ValueData, 0))       AS OperSumm_Compensation
                               , SUM (COALESCE (MIFloat_SummCompensationRecalc.ValueData, 0)) AS OperSumm_CompensationRecalc

                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END)  AS OperHeadCount_Master
                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Child()  THEN COALESCE (MIFloat_HeadCount.ValueData, 0) ELSE 0 END)  AS OperHeadCount_Child
                               , SUM (CASE WHEN MovementItem.DescId = zc_MI_Master() THEN COALESCE (MIFloat_LiveWeight.ValueData, 0) ELSE 0 END) AS OperLiveWeight

                               , SUM (COALESCE (MIFloat_SummMedicdayAdd.ValueData, 0))            AS OperSumm_MedicdayAdd
                               , SUM (COALESCE (MIFloat_DayMedicday.ValueData, 0))            AS OperDayMedicday
                               , SUM (COALESCE (MIFloat_SummSkip.ValueData, 0))               AS OperSumm_Skip
                               , SUM (COALESCE (MIFloat_DaySkip.ValueData, 0))                AS OperDaySkip
                          FROM Movement
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.isErased = FALSE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                                ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                                                               AND vbIsTotalSumm_GoodsReal = TRUE
                                                               --AND vbPartnerName NOT ILIKE '%СІЛЬПО-ФУД ТОВ%'
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                                ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal() 
                                                               AND vbIsTotalSumm_GoodsReal = TRUE
                                                               --AND vbPartnerName NOT ILIKE '%СІЛЬПО-ФУД ТОВ%'


                               LEFT JOIN tmpMI_child_ReturnIn ON tmpMI_child_ReturnIn.ParentId = MovementItem.Id

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
                               -- цена оборотной тары - zc_MovementFloat_TotalSummTare
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceTare
                                                           ON MIFloat_PriceTare.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceTare.DescId = zc_MIFloat_PriceTare()
                                                          AND COALESCE (MIFloat_Price.ValueData,0) = 0

                               LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                           ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                               LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                               LEFT JOIN MovementItemFloat AS MIFloat_AmountTax_calc
                                                           ON MIFloat_AmountTax_calc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_AmountTax_calc.DescId         = zc_MIFloat_AmountTax_calc()
                                                          AND vbMovementDescId                      = zc_Movement_TaxCorrective()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummTaxDiff_calc
                                                           ON MIFloat_SummTaxDiff_calc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummTaxDiff_calc.DescId         = zc_MIFloat_SummTaxDiff_calc()
                                                          AND vbMovementDescId                        = zc_Movement_TaxCorrective()
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceTax_calc
                                                           ON MIFloat_PriceTax_calc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceTax_calc.DescId         = zc_MIFloat_PriceTax_calc()
                                                          AND vbMovementDescId                      = zc_Movement_TaxCorrective()

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
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAuditAdd
                                                           ON MIFloat_SummAuditAdd.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAuditAdd.DescId = zc_MIFloat_SummAuditAdd()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_DayAudit
                                                           ON MIFloat_DayAudit.MovementItemId = MovementItem.Id
                                                          AND MIFloat_DayAudit.DescId = zc_MIFloat_DayAudit()
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

                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvance
                                                           ON MIFloat_SummAvance.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAvance.DescId = zc_MIFloat_SummAvance()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvanceRecalc
                                                           ON MIFloat_SummAvanceRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAvanceRecalc.DescId = zc_MIFloat_SummAvanceRecalc()
                                                          AND Movement.DescId = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecond
                                                           ON MIFloat_SummAvCardSecond.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAvCardSecond.DescId = zc_MIFloat_SummAvCardSecond()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAvCardSecondRecalc
                                                           ON MIFloat_SummAvCardSecondRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAvCardSecondRecalc.DescId = zc_MIFloat_SummAvCardSecondRecalc()
                                                          AND Movement.DescId = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummAddOth
                                                           ON MIFloat_SummAddOth.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAddOth.DescId = zc_MIFloat_SummAddOth()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummAddOthRecalc
                                                           ON MIFloat_SummAddOthRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummAddOthRecalc.DescId = zc_MIFloat_SummAddOthRecalc()
                                                          AND Movement.DescId = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummFine
                                                           ON MIFloat_SummFine.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummFine.DescId         = zc_MIFloat_SummFine()
                                                          AND Movement.DescId                 = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummHosp
                                                           ON MIFloat_SummHosp.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummHosp.DescId         = zc_MIFloat_SummHosp()
                                                          AND Movement.DescId                 = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummFineOth
                                                           ON MIFloat_SummFineOth.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummFineOth.DescId         = zc_MIFloat_SummFineOth()
                                                          AND Movement.DescId                    = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummHospOth
                                                           ON MIFloat_SummHospOth.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummHospOth.DescId         = zc_MIFloat_SummHospOth()
                                                          AND Movement.DescId                    = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummFineOthRecalc
                                                           ON MIFloat_SummFineOthRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummFineOthRecalc.DescId         = zc_MIFloat_SummFineOthRecalc()
                                                          AND Movement.DescId                          = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummHospOthRecalc
                                                           ON MIFloat_SummHospOthRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummHospOthRecalc.DescId         = zc_MIFloat_SummHospOthRecalc()
                                                          AND Movement.DescId                          = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_SummCompensation
                                                           ON MIFloat_SummCompensation.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummCompensation.DescId = zc_MIFloat_SummCompensation()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummCompensationRecalc
                                                           ON MIFloat_SummCompensationRecalc.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummCompensationRecalc.DescId = zc_MIFloat_SummCompensationRecalc()
                                                          AND Movement.DescId = zc_Movement_PersonalService()

                               LEFT JOIN MovementItemFloat AS MIFloat_DayMedicday
                                                           ON MIFloat_DayMedicday.MovementItemId = MovementItem.Id
                                                          AND MIFloat_DayMedicday.DescId = zc_MIFloat_DayMedicday()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_DaySkip
                                                           ON MIFloat_DaySkip.MovementItemId = MovementItem.Id
                                                          AND MIFloat_DaySkip.DescId = zc_MIFloat_DaySkip()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummMedicdayAdd
                                                           ON MIFloat_SummMedicdayAdd.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummMedicdayAdd.DescId = zc_MIFloat_SummMedicdayAdd()
                                                          AND Movement.DescId = zc_Movement_PersonalService()
                               LEFT JOIN MovementItemFloat AS MIFloat_SummSkip
                                                           ON MIFloat_SummSkip.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummSkip.DescId = zc_MIFloat_SummSkip()
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
                               LEFT JOIN MovementItemFloat AS MIFloat_SummHouseAdd
                                                           ON MIFloat_SummHouseAdd.MovementItemId = MovementItem.Id
                                                          AND MIFloat_SummHouseAdd.DescId = zc_MIFloat_SummHouseAdd()

                               LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                           ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                          AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                               LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                                           ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                                          AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
                          WHERE Movement.Id = inMovementId
                          GROUP BY Movement.DescId
                                 , CASE WHEN Movement.DescId = zc_Movement_TaxCorrective() THEN MovementItem.Id ELSE 0 END
                                 , MovementItem.DescId
                                 , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId)
                                 , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId)
                                 , CASE WHEN MIFloat_ChangePercent.ValueData <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                      , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        WHEN vbDiscountPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                      , inChangePercent:= -1 * vbDiscountPercent
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        WHEN vbExtraChargesPercent <> 0 AND vbIsChangePrice = TRUE AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_OrderExternal()) -- !!!для НАЛ не учитываем!!!
                                             THEN zfCalc_PriceTruncate (inOperDate     := COALESCE (tmpMI_child_ReturnIn.OperDate_tax, vbOperDatePartner)
                                                                      , inChangePercent:= 1 * vbExtraChargesPercent
                                                                      , inPrice        := MIFloat_Price.ValueData
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        ELSE COALESCE (MIFloat_Price.ValueData, 0)
                                   END
                                 , MIFloat_Price.ValueData
                                 , MIFloat_CountForPrice.ValueData
                                 , MIFloat_ChangePercent.ValueData
						  , COALESCE (MIFloat_PriceTare.ValueData, 0)
                         )

-------------------
           SELECT
                  -- Количество по факту (главные элементы)
                  OperCount_Master
                  -- Количество по факту (подчиненные элементы)
                , OperCount_Child
                  -- Количество по Контрагенту
                , OperCount_Partner
                  -- Количество дозаказ
                , OperCount_Second
                  -- Количество тары !!!по Контрагенту!!!
                , OperCount_Tare
                  -- Количество шт !!!по Контрагенту!!!
                , OperCount_Sh
                  -- Количество вес !!!по Контрагенту!!!
                , OperCount_Kg
                  -- Количество шт !!!ушло!!!
                , OperCount_ShFrom
                  -- Количество вес !!!ушло!!!
                , OperCount_KgFrom


                  -- Сумма без НДС
                , CASE WHEN vbMovementDescId = zc_Movement_ChangePercent()
                            -- для документа ChangePercent - без НДС
                            THEN (Sum_ChangePercent)

                       WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                            -- если цены без НДС или %НДС=0
                            THEN (OperSumm_Partner)
                       WHEN vbPriceWithVAT AND 1=1
                            -- если цены c НДС
                            THEN CAST ( (OperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                       WHEN vbPriceWithVAT
                            -- если цены c НДС (Вариант может быть если  первичен расчет НДС =1/6 )
                            THEN OperSumm_Partner - CAST ( (OperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
                  END AS OperSumm_MVAT

                  -- Сумма с НДС
                , CASE WHEN vbMovementDescId = zc_Movement_ChangePercent()
                            -- для документа ChangePercent - с НДС
                            THEN (Sum_ChangePercent_plus)

                       -- если цены с НДС
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Partner)
                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                            THEN OperSumm_Partner + OperSumm_VAT_2018

                       -- если цены без НДС
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2))
                  END AS OperSumm_PVAT

                  -- Сумма с НДС + !!!НЕ!!! учтена скидка в цене
                , CASE -- если цены с НДС
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Partner_original)

                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                            THEN OperSumm_Partner_original + OperSumm_VAT_2018_original

                       -- если цены без НДС
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_original) AS NUMERIC (16, 2))
                  END AS OperSumm_PVAT_original

                , OperSumm_VAT_2018

                  -- Сумма по Контрагенту
                , CASE WHEN vbMovementDescId = zc_Movement_ChangePercent()
                            -- для документа ChangePercent - с НДС
                            THEN (Sum_ChangePercent_plus)

                       WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_Partner_ChangePrice)
                               END

                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                            THEN OperSumm_Partner_ChangePrice + OperSumm_VAT_2018

                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END

                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Partner
                  -- Сумма по Контрагенту !!!ушло!!!
                , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_PartnerFrom_ChangePrice)
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_PartnerFrom_ChangePrice) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_PartnerFrom

                  -- Сумма по Контрагенту (!!!в валюте!!!)
                , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_Partner_ChangePrice_Currency)
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Partner_Currency

                  -- Количество по Заготовителю
                , OperCount_Packer AS OperCount_Packer

                  -- Сумма по Заготовителю
                , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_Packer)
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbDiscountPercent > 0 THEN CAST ( (1 - vbDiscountPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbPaidKindId = zc_Enum_PaidKind_SecondForm() AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (OperSumm_Packer) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (OperSumm_Packer) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Packer

                  -- Сумма оборотной тары с НДС
                , CASE -- если цены с НДС
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Tare)
                       -- если цены без НДС
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Tare) AS NUMERIC (16, 2))
                  END AS OperSumm_Tare

                  -- сумма ввода остатка
                , OperSumm_Inventory AS OperSumm_Inventory
                  --
                , OperSumm_LossAsset  
                --
                , CostPromo_PromoTrade

                  -- сумма начисления зп
                , OperSumm_ToPay
                , OperSumm_Service
                , OperSumm_Card
                , OperSumm_CardSecond
                , OperSumm_Nalog
                , OperSumm_Minus
                , OperSumm_Add
                , OperSumm_AuditAdd
                , OperDayAudit
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
                , OperSumm_HouseAdd
                , OperSumm_NalogRet
                , OperSumm_NalogRetRecalc
                , OperSumm_Avance
                , OperSumm_AvanceRecalc
                , OperSumm_AvCardSecond
                , OperSumm_AvCardSecondRecalc
                , OperSumm_AddOth
                , OperSumm_AddOthRecalc
                , OperSumm_Fine
                , OperSumm_Hosp
                , OperSumm_FineOth
                , OperSumm_HospOth
                , OperSumm_FineOthRecalc
                , OperSumm_HospOthRecalc
                , OperSumm_Compensation
                , OperSumm_CompensationRecalc
                , OperHeadCount_Master
                , OperHeadCount_Child
                , OperLiveWeight
                , OperSumm_MedicdayAdd
                , OperDayMedicday
                , OperSumm_Skip
                , OperDaySkip
           FROM
                 -- получили 1 запись + !!! перевели в валюту если надо!!!
                (SELECT SUM (CASE WHEN tmpMI.myLevel IN (2, 3) AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
                                       THEN 0
                                  ELSE tmpMI.OperCount_Master
                            END) AS OperCount_Master
                      , SUM (tmpMI.OperCount_Child)   AS OperCount_Child
                      , SUM (tmpMI.OperCount_Partner) AS OperCount_Partner -- Количество у контрагента
                      , SUM (tmpMI.OperCount_Packer)  AS OperCount_Packer  -- Количество у заготовителя
                      , SUM (tmpMI.OperCount_Second)  AS OperCount_Second  -- Количество дозаказ

                      , SUM (tmpMI.OperCount_Tare) AS OperCount_Tare
                      , SUM (CASE WHEN tmpMI.myLevel IN (2, 3) AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
                                       THEN 0
                                  ELSE tmpMI.OperCount_Sh
                            END) AS OperCount_Sh
                      , SUM (CASE WHEN tmpMI.myLevel IN (2, 3) AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice(), zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical(), zc_Enum_DocumentTaxKind_ChangePercent())
                                       THEN 0
                                  ELSE tmpMI.OperCount_Kg
                            END) AS OperCount_Kg
                      , SUM (tmpMI.OperCount_ShFrom) AS OperCount_ShFrom
                      , SUM (tmpMI.OperCount_KgFrom) AS OperCount_KgFrom

                        -- новая Схема для суммы НДС - 6 знаков
                      , CAST (
                        SUM (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                                       -- если цены с НДС
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / (100 + vbVATPercent)
                                                  AS NUMERIC (16, 6))
                                  WHEN vbVATPercent > 0
                                       -- если цены без НДС
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / 100
                                                  AS NUMERIC (16, 6))
                             END)
                        AS NUMERIC (16, 2)) AS OperSumm_VAT_2018

                        -- новая Схема для суммы НДС - 6 знаков + !!!НЕ!!! учтена скидка в цене
                      , CAST (
                        SUM (CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                                       -- если цены с НДС
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / (100 + vbVATPercent)
                                                  AS NUMERIC (16, 6))
                                  WHEN vbVATPercent > 0
                                       -- если цены без НДС
                                       THEN CAST (-- !!!OperSumm_Partner!!!
                                                  CASE WHEN tmpMI.CountForPrice <> 0
                                                            THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                                       ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                                                  END
                                                * vbVATPercent / 100
                                                  AS NUMERIC (16, 6))
                             END)
                        AS NUMERIC (16, 2)) AS OperSumm_VAT_2018_original

                        -- сумма по Контрагенту - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                             END
                             -- Сумма DIFF для НН в колонке 13/1строка
                           + tmpMI.SummTaxDiff_calc
                             ) AS OperSumm_Partner
                        -- сумма по Контрагенту - с округлением до 2-х знаков + !!!НЕ!!! учтена скидка в цене
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_original / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price_original AS NUMERIC (16, 2))
                             END) AS OperSumm_Partner_original

                         -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                             END
                            -- Сумма DIFF для НН в колонке 13/1строка
                          + tmpMI.SummTaxDiff_calc
                            ) AS OperSumm_Partner_ChangePrice
                        -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков !!!ушло!!!
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calcFrom * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calcFrom * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                             END) AS OperSumm_PartnerFrom_ChangePrice
                        -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков !!!в валюте!!!
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) AS NUMERIC (16, 2))
                             END) AS OperSumm_Partner_ChangePrice_Currency

                        -- сумма по Заготовителю - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_Packer * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_Packer * tmpMI.Price AS NUMERIC (16, 2))
                             END) AS OperSumm_Packer

                        -- сумма oборотной тары - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_Tare * tmpMI.PriceTare / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_Tare * tmpMI.PriceTare AS NUMERIC (16, 2))
                             END) AS OperSumm_Tare

                        -- сумма ввода остатка
                      , SUM (tmpMI.OperSumm_Inventory) AS OperSumm_Inventory
                        --
                      , SUM (tmpMI.OperSumm_LossAsset) AS OperSumm_LossAsset   
                      --
                      , SUM (tmpMI.CostPromo_PromoTrade) AS CostPromo_PromoTrade

                        -- для документа ChangePercent - без НДС
                      , SUM (tmpMI.Sum_ChangePercent) AS Sum_ChangePercent
                        -- для документа ChangePercent - с НДС
                      , SUM (tmpMI.Sum_ChangePercent + CAST (tmpMI.Sum_ChangePercent * vbVATPercent / 100 AS NUMERIC (16, 2))) AS Sum_ChangePercent_plus

                       -- сумма начисления зп
                      , SUM (tmpMI.OperSumm_ToPay)       AS OperSumm_ToPay
                      , SUM (tmpMI.OperSumm_Service)     AS OperSumm_Service
                      , SUM (tmpMI.OperSumm_Card)        AS OperSumm_Card
                      , SUM (tmpMI.OperSumm_CardSecond)  AS OperSumm_CardSecond
                      , SUM (tmpMI.OperSumm_Nalog)       AS OperSumm_Nalog
                      , SUM (tmpMI.OperSumm_Minus)       AS OperSumm_Minus
                      , SUM (tmpMI.OperSumm_Add)         AS OperSumm_Add
                      , SUM (tmpMI.OperSumm_AuditAdd)    AS OperSumm_AuditAdd
                      , SUM (tmpMI.OperDayAudit)         AS OperDayAudit
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
                      , SUM (tmpMI.OperSumm_HouseAdd)         AS OperSumm_HouseAdd
                      , SUM (tmpMI.OperSumm_NalogRet)         AS OperSumm_NalogRet
                      , SUM (tmpMI.OperSumm_NalogRetRecalc)   AS OperSumm_NalogRetRecalc
                      , SUM (tmpMI.OperSumm_Avance)           AS OperSumm_Avance
                      , SUM (tmpMI.OperSumm_AvanceRecalc)     AS OperSumm_AvanceRecalc
                      , SUM (tmpMI.OperSumm_AvCardSecond)           AS OperSumm_AvCardSecond
                      , SUM (tmpMI.OperSumm_AvCardSecondRecalc)     AS OperSumm_AvCardSecondRecalc
                      , SUM (tmpMI.OperSumm_AddOth)           AS OperSumm_AddOth
                      , SUM (tmpMI.OperSumm_AddOthRecalc)     AS OperSumm_AddOthRecalc
                      , SUM (tmpMI.OperSumm_Fine)             AS OperSumm_Fine
                      , SUM (tmpMI.OperSumm_Hosp)             AS OperSumm_Hosp
                      , SUM (tmpMI.OperSumm_FineOth)          AS OperSumm_FineOth
                      , SUM (tmpMI.OperSumm_HospOth)          AS OperSumm_HospOth
                      , SUM (tmpMI.OperSumm_FineOthRecalc)    AS OperSumm_FineOthRecalc
                      , SUM (tmpMI.OperSumm_HospOthRecalc)    AS OperSumm_HospOthRecalc
                      , SUM (tmpMI.OperSumm_Compensation)       AS OperSumm_Compensation
                      , SUM (tmpMI.OperSumm_CompensationRecalc) AS OperSumm_CompensationRecalc
                      , SUM (tmpMI.OperHeadCount_Master)      AS OperHeadCount_Master
                      , SUM (tmpMI.OperHeadCount_Child)       AS OperHeadCount_Child
                      , SUM (tmpMI.OperLiveWeight)            AS OperLiveWeight

                      , SUM (tmpMI.OperSumm_MedicdayAdd)    AS OperSumm_MedicdayAdd
                      , SUM (tmpMI.OperDayMedicday)         AS OperDayMedicday
                      , SUM (tmpMI.OperSumm_Skip)           AS OperSumm_Skip
                      , SUM (tmpMI.OperDaySkip)             AS OperDaySkip
                  FROM (SELECT tmpMI.GoodsId
                             , tmpMI.GoodsKindId
                             , tmpMI.myLevel

                               -- Сумма DIFF для НН в колонке 13/1строка
                             , tmpMI.SummTaxDiff_calc

                               -- для документа ChangePercent - без НДС
                             , tmpMI.Sum_ChangePercent

                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         -- так переводится в валюту zc_Enum_Currency_Basis
                                         THEN CAST (tmpMI.Price * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                    ELSE tmpMI.Price
                               END AS Price
                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         -- так переводится в валюту zc_Enum_Currency_Basis
                                         THEN CAST (tmpMI.Price_original * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                    ELSE tmpMI.Price_original
                               END AS Price_original
                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         THEN tmpMI.Price
                                    ELSE 0
                               END AS Price_Currency
                             , tmpMI.CountForPrice
                             , CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis()
                                         -- так переводится в валюту zc_Enum_Currency_Basis
                                         THEN CAST (tmpMI.PriceTare * CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END AS NUMERIC (16, 2))
                                    ELSE tmpMI.PriceTare
                               END AS PriceTare

                               -- очень важное кол-во, для него расчет сумм
                             , tmpMI.OperCount_calc
                               -- не очень важное кол-во "ушло", для него тоже расчет сумм
                             , tmpMI.OperCount_calcFrom

                               -- кол-во Master (!!!без тары с ц=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Master
                               END AS OperCount_Master
                               -- кол-во Child (!!!без тары с ц=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Child
                               END AS OperCount_Child
                               -- кол-во Partner (!!!без тары с ц=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Partner
                               END AS OperCount_Partner

                             , tmpMI.OperCount_Packer
                             , tmpMI.OperCount_Second
                               -- тара (если цена=0)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN CASE WHEN tmpMI.MovementDescId = zc_Movement_WeighingPartner()
                                                        THEN tmpMI.OperCount_Master
                                                   ELSE tmpMI.OperCount_calc
                                              END
                                    ELSE 0
                               END AS OperCount_Tare
                               -- ШТ (пришло)
                             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                         THEN tmpMI.OperCount_calc
                                    ELSE 0
                               END AS OperCount_Sh
                               -- ВЕС (пришло)
                             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                         THEN tmpMI.OperCount_calc * COALESCE (ObjectFloat_Weight.ValueData, 0)
                                    WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                         THEN tmpMI.OperCount_calc
                                    ELSE 0
                               END AS OperCount_Kg
                               -- ШТ (ушло)
                             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                         THEN tmpMI.OperCount_calcFrom
                                    ELSE 0
                               END AS OperCount_ShFrom
                               -- ВЕС (ушло)
                             , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                         THEN tmpMI.OperCount_calcFrom * COALESCE (ObjectFloat_Weight.ValueData, 0)
                                    WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Kg()
                                         THEN tmpMI.OperCount_calcFrom
                                    ELSE 0
                               END AS OperCount_KgFrom

                              -- сумма ввода остатка
                            , tmpMI.OperSumm_Inventory
                            , tmpMI.OperSumm_LossAsset  
                            , tmpMI.CostPromo_PromoTrade

                              -- сумма начисления зп
                            , tmpMI.OperSumm_ToPay
                            , tmpMI.OperSumm_Service
                            , tmpMI.OperSumm_Card
                            , tmpMI.OperSumm_CardSecond
                            , tmpMI.OperSumm_Nalog
                            , tmpMI.OperSumm_Minus
                            , tmpMI.OperSumm_Add
                            , tmpMI.OperSumm_AuditAdd
                            , tmpMI.OperDayAudit
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
                            , tmpMI.OperSumm_HouseAdd
                            , tmpMI.OperSumm_NalogRet
                            , tmpMI.OperSumm_NalogRetRecalc
                            , tmpMI.OperSumm_Avance
                            , tmpMI.OperSumm_AvanceRecalc
                            , tmpMI.OperSumm_AvCardSecond
                            , tmpMI.OperSumm_AvCardSecondRecalc

                            , tmpMI.OperSumm_AddOth
                            , tmpMI.OperSumm_AddOthRecalc

                            , tmpMI.OperSumm_Fine
                            , tmpMI.OperSumm_Hosp
                            , tmpMI.OperSumm_FineOth
                            , tmpMI.OperSumm_HospOth
                            , tmpMI.OperSumm_FineOthRecalc
                            , tmpMI.OperSumm_HospOthRecalc

                            , tmpMI.OperSumm_Compensation
                            , tmpMI.OperSumm_CompensationRecalc

                            , tmpMI.OperHeadCount_Master
                            , tmpMI.OperHeadCount_Child
                            , tmpMI.OperLiveWeight

                            , tmpMI.OperSumm_MedicdayAdd
                            , tmpMI.OperDayMedicday
                            , tmpMI.OperSumm_Skip
                            , tmpMI.OperDaySkip
                        FROM (SELECT tmpMI.MovementDescId
                                   , tmpMI.MovementItemId
                                   , tmpMI.DescId
                                   , tmpMI.GoodsId
                                   , tmpMI.GoodsKindId

                                     -- !!! ПЕРВАЯ Строка !!!
                                   , 1 AS myLevel
                                     -- !!! ПЕРВАЯ Строка !!!
                                   , CASE WHEN vbIsNPP_calc = TRUE
                                           AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                              )
                                               THEN tmpMI.PriceTax_calc * CASE WHEN tmpMI.OperCount_calc < 0 THEN -1 ELSE 1 END
                                          WHEN vbIsNPP_calc = TRUE
                                           AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                          )
                                               THEN tmpMI.PriceTax_calc
                                          ELSE 1 * tmpMI.Price
                                     END AS Price

                                   , tmpMI.Price_original
                                   , tmpMI.PriceTare
                                   , tmpMI.CountForPrice

                                     -- для документа ChangePercent - без НДС
                                   , CASE WHEN vbMovementDescId = zc_Movement_ChangePercent()
                                              THEN CAST (tmpMI.OperCount_calc * tmpMI.Price_ChangePercent AS NUMERIC (16, 2))
                                         ELSE 0
                                     END AS Sum_ChangePercent

                                   , tmpMI.ChangePercent
                                     -- Сумма DIFF для НН в колонке 13/1строка
                                   , tmpMI.SummTaxDiff_calc

                                     -- !!!очень важное кол-во, для него расчет сумм!!! - !!! ПЕРВАЯ Строка !!!
                                   , (CASE WHEN vbIsNPP_calc = TRUE THEN 1 * tmpMI.AmountTax_calc ELSE tmpMI.OperCount_calc END) AS OperCount_calc
                                     -- !!!не очень важное кол-во "ушло", для него тоже расчет сумм!!!
                                   , tmpMI.OperCount_calcFrom

                                     -- !!!важное кол-во, для него zc_MovementFloat_TotalCount !!! - !!! ПЕРВАЯ Строка !!!
                                   , (CASE WHEN vbIsNPP_calc = TRUE THEN 1 * tmpMI.AmountTax_calc ELSE tmpMI.OperCount_Master END) AS OperCount_Master


                                   , tmpMI.OperCount_Child
                                   , tmpMI.OperCount_Partner -- Количество у контрагента
                                   , tmpMI.OperCount_Packer  -- Количество у заготовителя
                                   , tmpMI.OperCount_Second  -- Количество дозаказ

                                   , tmpMI.OperSumm_Inventory
                                   , tmpMI.OperSumm_LossAsset  
                                   , tmpMI.CostPromo_PromoTrade

                                   , tmpMI.OperSumm_ToPay
                                   , tmpMI.OperSumm_Service
                                   , tmpMI.OperSumm_Card
                                   , tmpMI.OperSumm_CardSecond
                                   , tmpMI.OperSumm_Nalog
                                   , tmpMI.OperSumm_Minus
                                   , tmpMI.OperSumm_Add
                                   , tmpMI.OperSumm_AuditAdd
                                   , tmpMI.OperDayAudit
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
                                   , tmpMI.OperSumm_HouseAdd

                                   , tmpMI.OperSumm_NalogRet
                                   , tmpMI.OperSumm_NalogRetRecalc

                                   , tmpMI.OperSumm_Avance
                                   , tmpMI.OperSumm_AvanceRecalc

                                   , tmpMI.OperSumm_AvCardSecond
                                   , tmpMI.OperSumm_AvCardSecondRecalc

                                   , tmpMI.OperSumm_AddOth
                                   , tmpMI.OperSumm_AddOthRecalc

                                   , tmpMI.OperSumm_Fine
                                   , tmpMI.OperSumm_Hosp
                                   , tmpMI.OperSumm_FineOth
                                   , tmpMI.OperSumm_HospOth
                                   , tmpMI.OperSumm_FineOthRecalc
                                   , tmpMI.OperSumm_HospOthRecalc

                                   , tmpMI.OperSumm_Compensation
                                   , tmpMI.OperSumm_CompensationRecalc

                                   , tmpMI.OperHeadCount_Master
                                   , tmpMI.OperHeadCount_Child
                                   , tmpMI.OperLiveWeight

                                   , tmpMI.OperSumm_MedicdayAdd
                                   , tmpMI.OperDayMedicday
                                   , tmpMI.OperSumm_Skip
                                   , tmpMI.OperDaySkip
                              FROM tmpMI
                             UNION ALL
                              SELECT tmpMI.MovementDescId
                                   , tmpMI.MovementItemId
                                   , tmpMI.DescId
                                   , tmpMI.GoodsId
                                   , tmpMI.GoodsKindId

                                     -- !!! ВТОРАЯ Строка !!!
                                   , 2 AS myLevel
                                     -- !!! ВТОРАЯ Строка !!!
                                   , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                              )
                                               THEN -1 * (tmpMI.PriceTax_calc - tmpMI.Price)
                                          WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                          )
                                               THEN 1 * tmpMI.PriceTax_calc
                                          ELSE 1 * tmpMI.Price
                                     END AS Price

                                   , tmpMI.Price_original
                                   , tmpMI.PriceTare
                                   , tmpMI.CountForPrice

                                     -- для документа ChangePercent - без НДС
                                   , 0 AS Sum_ChangePercent

                                   , tmpMI.ChangePercent
                                     -- Сумма DIFF для НН в колонке 13/1строка
                                   , 0 AS SummTaxDiff_calc

                                     -- !!!очень важное кол-во, для него расчет сумм!!! - !!! ВТОРАЯ Строка !!!
                                   , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                              )
                                               THEN 1 * tmpMI.OperCount_calc

                                          WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                          )
                                               THEN -1 * (tmpMI.AmountTax_calc - tmpMI.OperCount_calc)

                                          ELSE -1 * (tmpMI.AmountTax_calc - tmpMI.OperCount_calc)

                                     END AS OperCount_calc

                                     -- !!!не очень важное кол-во "ушло", для него тоже расчет сумм!!!
                                   , tmpMI.OperCount_calcFrom

                                     -- !!!важное кол-во, для него zc_MovementFloat_TotalCount !!! - !!! ВТОРАЯ Строка !!!
                                   , CASE WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax NOT IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                             , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                              )
                                               THEN 1 * tmpMI.OperCount_calc

                                          WHEN vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                                     , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                                     , zc_Enum_DocumentTaxKind_ChangePercent()
                                                                      )
                                           AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                                         , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                                          )
                                               THEN -1 * (tmpMI.AmountTax_calc - tmpMI.OperCount_calc)

                                          ELSE -1 * (tmpMI.AmountTax_calc - tmpMI.OperCount_calc)
                                     END AS OperCount_Master

                                   , tmpMI.OperCount_Child
                                   , tmpMI.OperCount_Partner -- Количество у контрагента
                                   , tmpMI.OperCount_Packer  -- Количество у заготовителя
                                   , tmpMI.OperCount_Second  -- Количество дозаказ

                                   , tmpMI.OperSumm_Inventory
                                   , tmpMI.OperSumm_LossAsset 
                                   , tmpMI.CostPromo_PromoTrade

                                   , tmpMI.OperSumm_ToPay
                                   , tmpMI.OperSumm_Service
                                   , tmpMI.OperSumm_Card
                                   , tmpMI.OperSumm_CardSecond
                                   , tmpMI.OperSumm_Nalog
                                   , tmpMI.OperSumm_Minus
                                   , tmpMI.OperSumm_Add
                                   , tmpMI.OperSumm_AuditAdd
                                   , tmpMI.OperDayAudit
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
                                   , tmpMI.OperSumm_HouseAdd

                                   , tmpMI.OperSumm_NalogRet
                                   , tmpMI.OperSumm_NalogRetRecalc

                                   , tmpMI.OperSumm_Avance
                                   , tmpMI.OperSumm_AvanceRecalc

                                   , tmpMI.OperSumm_AvCardSecond
                                   , tmpMI.OperSumm_AvCardSecondRecalc

                                   , tmpMI.OperSumm_AddOth
                                   , tmpMI.OperSumm_AddOthRecalc

                                   , tmpMI.OperSumm_Fine
                                   , tmpMI.OperSumm_Hosp
                                   , tmpMI.OperSumm_FineOth
                                   , tmpMI.OperSumm_HospOth
                                   , tmpMI.OperSumm_FineOthRecalc
                                   , tmpMI.OperSumm_HospOthRecalc
                                   , tmpMI.OperSumm_Compensation
                                   , tmpMI.OperSumm_CompensationRecalc

                                   , tmpMI.OperHeadCount_Master
                                   , tmpMI.OperHeadCount_Child
                                   , tmpMI.OperLiveWeight

                                   , tmpMI.OperSumm_MedicdayAdd
                                   , tmpMI.OperDayMedicday
                                   , tmpMI.OperSumm_Skip
                                   , tmpMI.OperDaySkip
                              FROM tmpMI
                              WHERE vbIsNPP_calc = TRUE

                             UNION ALL
                              SELECT tmpMI.MovementDescId
                                   , tmpMI.MovementItemId
                                   , tmpMI.DescId
                                   , tmpMI.GoodsId
                                   , tmpMI.GoodsKindId

                                     -- !!! ТРЕТЬЯ Строка !!!
                                   , 3 AS myLevel
                                     -- !!! ТРЕТЬЯ Строка !!!
                                   , tmpMI.PriceTax_calc - tmpMI.Price AS Price

                                   , tmpMI.Price_original
                                   , tmpMI.PriceTare
                                   , tmpMI.CountForPrice

                                     -- для документа ChangePercent - без НДС
                                   , 0 AS Sum_ChangePercent

                                   , tmpMI.ChangePercent
                                     -- Сумма DIFF для НН в колонке 13/1строка
                                   , 0 AS SummTaxDiff_calc

                                     -- !!!очень важное кол-во, для него расчет сумм!!! - !!! ТРЕТЬЯ Строка !!!
                                   , -1 * tmpMI.OperCount_calc AS OperCount_calc

                                     -- !!!не очень важное кол-во "ушло", для него тоже расчет сумм!!!
                                   , tmpMI.OperCount_calcFrom

                                     -- !!!важное кол-во, для него zc_MovementFloat_TotalCount !!! - !!! ВТОРАЯ Строка !!!
                                   , -1 * tmpMI.OperCount_calc AS OperCount_Master

                                   , tmpMI.OperCount_Child
                                   , tmpMI.OperCount_Partner -- Количество у контрагента
                                   , tmpMI.OperCount_Packer  -- Количество у заготовителя
                                   , tmpMI.OperCount_Second  -- Количество дозаказ

                                   , tmpMI.OperSumm_Inventory
                                   , tmpMI.OperSumm_LossAsset 
                                   , tmpMI.CostPromo_PromoTrade

                                   , tmpMI.OperSumm_ToPay
                                   , tmpMI.OperSumm_Service
                                   , tmpMI.OperSumm_Card
                                   , tmpMI.OperSumm_CardSecond
                                   , tmpMI.OperSumm_Nalog
                                   , tmpMI.OperSumm_Minus
                                   , tmpMI.OperSumm_Add
                                   , tmpMI.OperSumm_AuditAdd
                                   , tmpMI.OperDayAudit
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
                                   , tmpMI.OperSumm_HouseAdd

                                   , tmpMI.OperSumm_NalogRet
                                   , tmpMI.OperSumm_NalogRetRecalc

                                   , tmpMI.OperSumm_Avance
                                   , tmpMI.OperSumm_AvanceRecalc
                                   , tmpMI.OperSumm_AvCardSecond
                                   , tmpMI.OperSumm_AvCardSecondRecalc

                                   , tmpMI.OperSumm_AddOth
                                   , tmpMI.OperSumm_AddOthRecalc

                                   , tmpMI.OperSumm_Fine
                                   , tmpMI.OperSumm_Hosp
                                   , tmpMI.OperSumm_FineOth
                                   , tmpMI.OperSumm_HospOth
                                   , tmpMI.OperSumm_FineOthRecalc
                                   , tmpMI.OperSumm_HospOthRecalc
                                   , tmpMI.OperSumm_Compensation
                                   , tmpMI.OperSumm_CompensationRecalc

                                   , tmpMI.OperHeadCount_Master
                                   , tmpMI.OperHeadCount_Child
                                   , tmpMI.OperLiveWeight

                                   , tmpMI.OperSumm_MedicdayAdd
                                   , tmpMI.OperDayMedicday
                                   , tmpMI.OperSumm_Skip
                                   , tmpMI.OperDaySkip
                              FROM tmpMI
                              WHERE vbIsNPP_calc = TRUE
                                AND vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectivePrice()
                                                          , zc_Enum_DocumentTaxKind_CorrectivePriceSummaryJuridical()
                                                          , zc_Enum_DocumentTaxKind_ChangePercent()
                                                           )
                                AND vbDocumentTaxKindId_tax IN (zc_Enum_DocumentTaxKind_TaxSummaryJuridicalS()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryJuridicalSR()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryPartnerS()
                                                              , zc_Enum_DocumentTaxKind_TaxSummaryPartnerSR()
                                                               )
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

     -- !!!меняется значение - переводится в валюту zc_Enum_Currency_Basis!!! - !!!нельзя что б переводился в строчной части!!!
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

     -- Тест
     -- RAISE EXCEPTION '%', vbOperCount_Master;
     --
     --IF inMovementId = 24935207
     --THEN
     --    RAISE EXCEPTION 'Ошибка.<%>  %', vbIsNPP_calc, vbOperSumm_MVAT;
     --END IF;


     IF vbMovementDescId IN (zc_Movement_PersonalSendCash(), zc_Movement_PersonalAccount(), zc_Movement_MobileBills(), zc_Movement_LossDebt(), zc_Movement_LossPersonal(), zc_Movement_ProfitLossResult()
                           , zc_Movement_PersonalGroupSummAdd())
     THEN
         -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
     ELSE
     IF vbMovementDescId IN (zc_Movement_PersonalService(), zc_Movement_PersonalTransport())
     THEN
         -- Сохранили свойство <Итого  Сумма (затраты) >
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperCount_Master);
         -- Сохранили свойство <Итого Сумма (к выплате)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummToPay(), inMovementId, vbTotalSummToPay);
         -- Сохранили свойство <Итого Сумма начислено>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummService(), inMovementId, vbTotalSummService);

         -- Сохранили свойство <Карта БН - 1ф.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCard(), inMovementId, vbTotalSummCard);
         -- Сохранили свойство <Карта БН - 2ф.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecond(), inMovementId, vbTotalSummCardSecond);
         -- Сохранили свойство <Налоги - удержания с ЗП>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalog(), inMovementId, vbTotalSummNalog);
         -- Сохранили свойство <Итого Сумма удержания>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinus(), inMovementId, vbTotalSummMinus);
         -- Сохранили свойство <Итого Сумма премия>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAdd(), inMovementId, vbTotalSummAdd);
         -- Сохранили свойство <Итого Сумма доплаты за аудит>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAuditAdd(), inMovementId, vbTotalSummAuditAdd);
         -- Сохранили свойство <Итого Сумма доплаты за аудит>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDayAudit(), inMovementId, vbTotalDayAudit);
         -- Сохранили свойство <Итого Сумма отпускные>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHoliday(), inMovementId, vbTotalSummHoliday);
         -- Сохранили свойство <Карта БН (ввод) - 1ф.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardRecalc(), inMovementId, vbTotalSummCardRecalc);
         -- Сохранили свойство <Карта БН (ввод) - 2ф.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecondRecalc(), inMovementId, vbTotalSummCardSecondRecalc);
         -- Сохранили свойство <Налоги - удержания с ЗП (ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRecalc(), inMovementId, vbTotalSummNalogRecalc);

         -- Сохранили свойство <Карта БН (касса) - 2ф.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCardSecondCash(), inMovementId, vbTotalSummCardSecondCash);

         -- Сохранили свойство <Итого Сумма соц выплаты (из зарплаты)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialIn(), inMovementId, vbTotalSummSocialIn);
         -- Сохранили свойство <Итого Сумма соц выплаты (доп. к зарплате)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSocialAdd(), inMovementId, vbTotalSummSocialAdd);

         -- Сохранили свойство <Алименты>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChild(), inMovementId, vbTotalSummChild);
         -- Сохранили свойство <Алименты (ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChildRecalc(), inMovementId, vbTotalSummChildRecalc);
         -- Сохранили свойство < Удержания сторонними юр.л.>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinusExt(), inMovementId, vbTotalSummMinusExt);
         -- Сохранили свойство < Удержания сторонними юр.л. (ввод) >
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMinusExtRecalc(), inMovementId, vbTotalSummMinusExtRecalc);

         -- Сохранили свойство <Итого Сумма ГСМ (удержание за заправку, хотя может быть и доплатой...)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransport(), inMovementId, vbTotalSummTransport);
         -- Сохранили свойство <Итого Сумма командировочные (доплата)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportAdd(), inMovementId, vbTotalSummTransportAdd);
         -- Сохранили свойство <Итого Сумма дальнобойные (доплата, тоже командировочные)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportAddLong(), inMovementId, vbTotalSummTransportAddLong);
         -- Сохранили свойство <Итого Сумма на такси (доплата)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummTransportTaxi(), inMovementId, vbTotalSummTransportTaxi);

         -- Сохранили свойство <Итого Сумма Моб.связь (удержание))>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPhone(), inMovementId, vbTotalSummPhone);

         -- Сохранили свойство <Налоги - возмещение к ЗП>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRet(), inMovementId, vbTotalSummNalogRet);
         -- Сохранили свойство <Налоги - возмещение к ЗП (ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummNalogRetRecalc(), inMovementId, vbTotalSummNalogRetRecalc);

         -- Сохранили свойство <Аванс>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalAvance(), inMovementId, vbTotalSummAvance);
         -- Сохранили свойство <Аванс (ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalAvanceRecalc(), inMovementId, vbTotalSummAvanceRecalc);

         -- Сохранили свойство <Карта БН - 2ф. Аванс>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAvCardSecond(), inMovementId, vbTotalSummAvCardSecond);
         -- Сохранили свойство <Карта БН (ввод) - 2ф. Аванс>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAvCardSecondRecalc(), inMovementId, vbTotalSummAvCardSecondRecalc);

         -- Сохранили свойство <Премия (распределено)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAddOth(), inMovementId, vbTotalSummAddOth);
         -- Сохранили свойство <Премия (ввод для распределения)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummAddOthRecalc(), inMovementId, vbTotalSummAddOthRecalc);

         -- Сохранили свойство <штраф>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFine(), inMovementId, vbTotalSummFine);
         -- Сохранили свойство <штраф(распределено)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFineOth(), inMovementId, vbTotalSummFineOth);
         -- Сохранили свойство <штраф(ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFineOthRecalc(), inMovementId, vbTotalSummFineOthRecalc);
         -- Сохранили свойство <Больничный>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHosp(), inMovementId, vbTotalSummHosp);
         -- Сохранили свойство <Больничный(распределено)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHospOth(), inMovementId, vbTotalSummHospOth);
         -- Сохранили свойство <Больничный(ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHospOthRecalc(), inMovementId, vbTotalSummHospOthRecalc);

         -- Сохранили свойство <Компенсация>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCompensation(), inMovementId, vbTotalSummCompensation);
         -- Сохранили свойство <Компенсация(ввод)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCompensationRecalc(), inMovementId, vbTotalSummCompensationRecalc);

         -- Сохранили свойство <Итого Сумма компенсации за жилье)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummHouseAdd(), inMovementId, vbTotalSummHouseAdd);

         -- Сохранили свойство  <Сумма доплата за санобработка>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMedicdayAdd(), inMovementId, vbTotalSummMedicdayAdd);
         -- Сохранили свойство  <Дней доплата за санобработка>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDayMedicday(), inMovementId, vbTotalDayMedicday);
         -- Сохранили свойство <Сумма удержаний за прогул>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSkip(), inMovementId, vbTotalSummSkip);
         -- Сохранили свойство <Дней удержаний за прогул>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDaySkip(), inMovementId, vbTotalDaySkip);

     ELSE
         -- Сохранили свойство <Итого количество("главные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbOperCount_Master + vbOperCount_Packer);
         -- Сохранили свойство <Итого количество("подчиненные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountChild(), inMovementId, vbOperCount_Child);
         -- Сохранили свойство <Итого количество у контрагента>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountPartner(), inMovementId, vbOperCount_Partner);
         -- Сохранили свойство <Итого количество, тары>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountTare(), inMovementId, vbOperCount_Tare);

         -- Сохранили свойство <Итого количество, шт>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountSh(), inMovementId, vbOperCount_Sh);
         -- Сохранили свойство <Итого количество, вес>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKg(), inMovementId, vbOperCount_Kg);
         IF vbMovementDescId = zc_Movement_SendOnPrice()
         THEN
             -- Сохранили свойство <Итого количество, шт (ушло)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountShFrom(), inMovementId, vbOperCount_ShFrom);
             -- Сохранили свойство <Итого количество, вес (ушло)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountKgFrom(), inMovementId, vbOperCount_KgFrom);
             -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки, ушло)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummFrom(), inMovementId, vbOperSumm_PartnerFrom);
         END IF;


         -- если цены без НДС, и новая Схема для НДС - 6 знаков
        /* IF vbPaidKindId = zc_Enum_PaidKind_FirstForm()
        AND vbOperDatePartner >= zc_DateStart_Tax_2018()
        AND vbMovementDescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Sale(), zc_Movement_ReturnIn())
         THEN
             -- Сохранили свойство <Итого количество, шт (ушло)>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCountShFrom(), inMovementId, vbOperCount_ShFrom);
         END IF;*/


         IF EXISTS (SELECT 1 FROM lpInsertUpdate_MovementFloat_TotalSumm_check_err() AS lp WHERE lp.MovementId = inMovementId)
         THEN
             SELECT lp.S1, lp.S2, lp.S2
                   INTO vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner
             FROM lpInsertUpdate_MovementFloat_TotalSumm_check_err() AS lp
             WHERE lp.MovementId = inMovementId;

         END IF;
     
         -- Сохранили свойство <Итого сумма по накладной (без НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- Сохранили свойство <Итого сумма по накладной (с НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
         -- Сохранили свойство <Итого сумма скидки по накладной>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange(), inMovementId, vbOperSumm_Partner - vbOperSumm_PVAT_original);
         -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, CASE WHEN vbMovementDescId = zc_Movement_Inventory() THEN vbOperSumm_Inventory WHEN vbMovementDescId = zc_Movement_LossAsset() THEN vbOperSumm_LossAsset ELSE vbOperSumm_Partner END);
         -- Сохранили свойство <Итого сумма !!!в валюте!!! по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCurrency(), inMovementId, vbOperSumm_Currency);
         -- Сохранили свойство <Итого сумма заготовителю по накладной (с учетом НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPacker(), inMovementId, vbOperSumm_Packer);

         -- Сохранили свойство <Итого кол-во голов расход>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalHeadCount(), inMovementId, vbTotalHeadCount_Master);
         -- Сохранили свойство <Итого кол-во голов приход>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalHeadCountChild(), inMovementId, vbTotalHeadCount_Child); 
         -- Сохранили свойство <Итого живой вес>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLiveWeight(), inMovementId, vbTotalLiveWeight);

         -- Сохранили свойство <Итого сумма по Оборотной таре>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), inMovementId, vbOperSumm_Tare);

         IF vbMovementDescId = zc_Movement_PromoTrade()
         THEN
             -- Сохранили свойство <Стоимость участия в акции>
             PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CostPromo(), inMovementId, vbCostPromo_PromoTrade);
         END IF;

     END IF;
     END IF;

if  inMovementId = 25153488 and 1=0
then
    RAISE EXCEPTION 'Ошибка.<%>', vbTotalSummAvCardSecondRecalc;
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.12.24         * zc_MovementFloat_TotalLiveWeight
 02.05.23         *
 27.03.23         *
 17.01.22         * zc_MIFloat_SummAvance, zc_MIFloat_SummAvanceRecalc
 25.04.22         * zc_MovementFloat_TotalSummTare
 18.11.21         *
 25.03.20         *
 15.09.19         *
 29.07.19         *
 22.02.19         * TotalHeadCount
 25.06.18         * SummAddOth
                    SummAddOthRecalc
 27.02.18         * zc_Movement_LossPersonal
 05.01.18         * vbTotalSummNalogRet
                    vbTotalSummNalogRetRecalc
 20.06.17         * vbTotalSummCardSecondCash
 24.01.17         *
 16.01.15                                        * add !!!убрал, переводится в строчной части!!!
 08.12.14                       * add NDSKind
 19.10.14                                        * add vbOperCount_Second
 09.08.14                                        * add zc_Movement_SendOnPrice
 19.07.14                                        * add zc_Movement_EDI
 22.05.14                                        * modify - очень важное кол-во, для него расчет сумм
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
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where DescId = zc_Movement_Sale() and OperDate between ('01.11.2014')::TDateTime and  ('31.12.2014')::TDateTime
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= Movement.Id) from Movement where Id =22482106  -- 8796848
