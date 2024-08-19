
DROP FUNCTION IF EXISTS lpSelect_MovementFloat_TotalSumm_Sale (Integer);

CREATE OR REPLACE FUNCTION lpSelect_MovementFloat_TotalSumm_Sale(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
RETURNS TABLE ( 
               TotalSummMVAT   TFloat
             , TotalSummPVAT   TFloat
             , TotalSumm       TFloat  
             , TotalSummMVAT_real   TFloat
             , TotalSummPVAT_real   TFloat
             , TotalSumm_real       TFloat
)
 AS
$BODY$
  DECLARE vbMovementDescId  Integer;
  DECLARE vbOperDatePartner TDateTime;

  DECLARE vbOperCount_Master TFloat;
   
  DECLARE vbOperSumm_Partner       TFloat;
  DECLARE vbOperSumm_MVAT          TFloat;
  DECLARE vbOperSumm_PVAT          TFloat;
  DECLARE vbOperSumm_VAT_2018      TFloat; 
  DECLARE vbOperSumm_Currency      TFloat;

  DECLARE vbOperSumm_Partner_real       TFloat;
  DECLARE vbOperSumm_MVAT_real          TFloat;
  DECLARE vbOperSumm_PVAT_real          TFloat;
  DECLARE vbOperSumm_VAT_2018_real      TFloat; 
  DECLARE vbOperSumm_Currency_real      TFloat;


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
            -- Сумма без НДС
           CAST (OperSumm_MVAT
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_MVAT

            -- Сумма с НДС
          , CAST (OperSumm_PVAT
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_PVAT

            -- Сумма по Контрагенту
          , CAST (OperSumm_Partner
                  -- так переводится в валюту zc_Enum_Currency_Basis
                -- !!!убрал, переводится в строчной части!!! * CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN CASE WHEN vbParValue = 0 THEN 0 ELSE vbCurrencyValue / vbParValue END ELSE 1 END
            AS NUMERIC (16, 2)) AS OperSumm_Partner

          -- Сумма в валюте
          , CAST (CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN OperSumm_Partner_Currency ELSE OperSumm_Partner END
                  -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue / vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency           


            -- Сумма без НДС
          , CAST (OperSumm_MVAT_real AS NUMERIC (16, 2)) AS OperSumm_MVAT_real
            -- Сумма с НДС
          , CAST (OperSumm_PVAT_real AS NUMERIC (16, 2)) AS OperSumm_PVAT_real
            -- Сумма по Контрагенту
          , CAST (OperSumm_Partner_real AS NUMERIC (16, 2)) AS OperSumm_Partner_real
          -- Сумма в валюте
          , CAST (CASE WHEN vbCurrencyDocumentId <> zc_Enum_Currency_Basis() THEN OperSumm_Partner_Currency_real ELSE OperSumm_Partner_real END
                  -- так переводится в валюту CurrencyPartnerId
                * CASE WHEN vbCurrencyPartnerId <> vbCurrencyDocumentId THEN CASE WHEN vbParPartnerValue = 0 THEN 0 ELSE vbCurrencyPartnerValue / vbParPartnerValue END ELSE CASE WHEN vbCurrencyPartnerId = zc_Enum_Currency_Basis() THEN 0 ELSE 1 END END
            AS NUMERIC (16, 2)) AS OperSumm_Currency_real


           INTO  vbOperSumm_MVAT          -- Сумма без НДС
               , vbOperSumm_PVAT          -- Сумма с НДС
               , vbOperSumm_Partner       -- Сумма по Контрагенту
               , vbOperSumm_Currency      -- Сумма в валюте 
               --
               , vbOperSumm_MVAT_real          -- Сумма без НДС
               , vbOperSumm_PVAT_real          -- Сумма с НДС
               , vbOperSumm_Partner_real       -- Сумма по Контрагенту
               , vbOperSumm_Currency_real      -- Сумма в валюте

     FROM  -- Расчет Итоговых суммы
          (WITH --tmpMI_child_ReturnIn AS (SELECT MovementItem.ParentId       AS ParentId
                tmpMI_all AS (SELECT MovementItem.DescId
                                   , MovementItem.ObjectId           AS GoodsId
                                   , MILinkObject_GoodsKind.ObjectId AS GoodsKindId

                                   , COALESCE (MILinkObject_GoodsReal.ObjectId, MovementItem.ObjectId) AS GoodsId_real
                                   , COALESCE (MILinkObject_GoodsKindReal.ObjectId, MILinkObject_GoodsKind.ObjectId) AS GoodsKindId_real
  
                                   , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                                   , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_calc
                                   , MovementItem.Amount AS OperCount_Master
                                   , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS OperCount_Partner -- Количество у контрагента   
                                   , COALESCE (MIFloat_ChangePercent.ValueData,0)  AS ChangePercent

                            FROM Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.isErased = FALSE 
                                                        AND MovementItem.DescId = zc_MI_Master()
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
  
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsReal
                                                                  ON MILinkObject_GoodsReal.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsReal.DescId         = zc_MILinkObject_GoodsReal()
                                                                 --AND vbPartnerName NOT ILIKE '%СІЛЬПО-ФУД ТОВ%'
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindReal
                                                                  ON MILinkObject_GoodsKindReal.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKindReal.DescId         = zc_MILinkObject_GoodsKindReal()
                                                                 --AND vbPartnerName NOT ILIKE '%СІЛЬПО-ФУД ТОВ%'
                                                                                  
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
                          )                             
 
              , tmpMI AS (SELECT tmpMI_all.GoodsId     AS GoodsId
                               , tmpMI_all.GoodsKindId AS GoodsKindId

                               , CASE WHEN tmpMI_all.ChangePercent <> 0 AND vbIsChangePrice = TRUE
                                           THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                    , inChangePercent:= tmpMI_all.ChangePercent
                                                                    , inPrice        := tmpMI_all.Price
                                                                    , inIsWithVAT    := vbPriceWithVAT
                                                                     )
                                      ELSE COALESCE (tmpMI_all.Price, 0)
                                 END AS Price
                               , COALESCE (tmpMI_all.Price, 0)         AS Price_original
                               , COALESCE (tmpMI_all.CountForPrice, 0) AS CountForPrice

                                 -- !!!очень важное кол-во, для него расчет сумм!!!
                               , SUM (tmpMI_all.OperCount_calc) AS OperCount_calc
                       
                               , SUM (tmpMI_all.OperCount_Master)  AS OperCount_Master
                               , SUM (tmpMI_all.OperCount_Partner) AS OperCount_Partner -- Количество у контрагента

                          FROM tmpMI_all
                          GROUP BY tmpMI_all.GoodsId
                                 , tmpMI_all.GoodsKindId
                                 , CASE WHEN tmpMI_all.ChangePercent <> 0 AND vbIsChangePrice = TRUE
                                             THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                      , inChangePercent:= tmpMI_all.ChangePercent
                                                                      , inPrice        := tmpMI_all.Price
                                                                      , inIsWithVAT    := vbPriceWithVAT
                                                                       )
                                        ELSE COALESCE (tmpMI_all.Price, 0)
                                   END
                                 , tmpMI_all.Price
                                 , tmpMI_all.CountForPrice
                                 , tmpMI_all.ChangePercent
                         )
              , tmpMI_real AS (SELECT tmpMI_all.GoodsId_real     AS GoodsId
                                    , tmpMI_all.GoodsKindId_real AS GoodsKindId
     
                                    , CASE WHEN tmpMI_all.ChangePercent <> 0 AND vbIsChangePrice = TRUE
                                                THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                         , inChangePercent:= tmpMI_all.ChangePercent
                                                                         , inPrice        := tmpMI_all.Price
                                                                         , inIsWithVAT    := vbPriceWithVAT
                                                                          )
                                           ELSE COALESCE (tmpMI_all.Price, 0)
                                      END AS Price
                                    , COALESCE (tmpMI_all.Price, 0)         AS Price_original
                                    , COALESCE (tmpMI_all.CountForPrice, 0) AS CountForPrice
     
                                      -- !!!очень важное кол-во, для него расчет сумм!!!
                                    , SUM (tmpMI_all.OperCount_calc) AS OperCount_calc
                            
                                    , SUM (tmpMI_all.OperCount_Master)  AS OperCount_Master
                                    , SUM (tmpMI_all.OperCount_Partner) AS OperCount_Partner -- Количество у контрагента
     
                               FROM tmpMI_all
                               GROUP BY tmpMI_all.GoodsId_real
                                      , tmpMI_all.GoodsKindId_real
                                      , CASE WHEN tmpMI_all.ChangePercent <> 0 AND vbIsChangePrice = TRUE
                                                  THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                                           , inChangePercent:= tmpMI_all.ChangePercent
                                                                           , inPrice        := tmpMI_all.Price
                                                                           , inIsWithVAT    := vbPriceWithVAT
                                                                            )
                                             ELSE COALESCE (tmpMI_all.Price, 0)
                                        END
                                      , tmpMI_all.Price
                                      , tmpMI_all.CountForPrice
                                      , tmpMI_all.ChangePercent
                              )
-------------------
     , tmpCalc1 AS (SELECT
                 
                  -- Сумма без НДС
                  CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
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
                , CASE
                       -- если цены с НДС
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (OperSumm_Partner)
                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            THEN OperSumm_Partner + OperSumm_VAT_2018

                       -- если цены без НДС
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_Partner) AS NUMERIC (16, 2)) 
                            
                  END AS OperSumm_PVAT

                 -- Сумма по Контрагенту
                , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    ELSE (OperSumm_Partner_ChangePrice)
                               END

                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Sale())
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
          FROM
                 -- получили 1 запись + !!! перевели в валюту если надо!!!
                (SELECT 
                        -- новая Схема для суммы НДС - 6 знаков
                        CAST (
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

                        -- сумма по Контрагенту - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                             END
                          
                             ) AS OperSumm_Partner

                         -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                             END
                            ) AS OperSumm_Partner_ChangePrice

                        -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков !!!в валюте!!!
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) AS NUMERIC (16, 2))
                             END) AS OperSumm_Partner_ChangePrice_Currency                       
                  FROM (SELECT tmpMI.GoodsId
                             , tmpMI.GoodsKindId
                            
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

                               -- очень важное кол-во, для него расчет сумм
                             , tmpMI.OperCount_calc

                               -- кол-во Partner (!!!без тары с ц=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Partner
                               END AS OperCount_Partner

                        FROM tmpMI
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                       ) AS tmpMI
                ) AS _tmp
          )
   , tmpCalc2 AS (SELECT
                  -- Сумма без НДС
                  CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                            -- если цены без НДС или %НДС=0
                            THEN (_tmp_real.OperSumm_Partner)
                       WHEN vbPriceWithVAT AND 1=1
                            -- если цены c НДС
                            THEN CAST ( (_tmp_real.OperSumm_Partner) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                       WHEN vbPriceWithVAT
                            -- если цены c НДС (Вариант может быть если  первичен расчет НДС =1/6 )
                            THEN _tmp_real.OperSumm_Partner - CAST ( (_tmp_real.OperSumm_Partner) / (100 / vbVATPercent + 1) AS NUMERIC (16, 2))
                  END AS OperSumm_MVAT_real

                  -- Сумма с НДС
                , CASE
                       -- если цены с НДС
                       WHEN vbPriceWithVAT OR vbVATPercent = 0
                            THEN (_tmp_real.OperSumm_Partner)
                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            THEN _tmp_real.OperSumm_Partner + _tmp_real.OperSumm_VAT_2018

                       -- если цены без НДС
                       WHEN vbVATPercent > 0
                            THEN CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner) AS NUMERIC (16, 2)) 
                  END AS OperSumm_PVAT_real

                 -- Сумма по Контрагенту
                , CASE WHEN vbPriceWithVAT = TRUE OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                                    ELSE (_tmp_real.OperSumm_Partner_ChangePrice)
                               END

                       -- если цены без НДС, и новая Схема для НДС - 6 знаков
                       WHEN vbPaidKindId = zc_Enum_PaidKind_FirstForm()
                            AND vbOperDatePartner >= zc_DateStart_Tax_2018()
                            AND vbMovementDescId IN (zc_Movement_Sale())
                            THEN _tmp_real.OperSumm_Partner_ChangePrice + _tmp_real.OperSumm_VAT_2018

                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END

                       -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                       WHEN vbVATPercent > 0
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Partner_real

                  -- Сумма по Контрагенту (!!!в валюте!!!)
                , CASE WHEN vbPriceWithVAT OR vbVATPercent = 0
                          -- если цены с НДС или %НДС=0, тогда учитываем или % Скидки или % Наценки !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                                    ELSE (_tmp_real.OperSumm_Partner_ChangePrice_Currency)
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы с НДС (этот вариант будет и для НАЛ и для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN vbIsChangePrice = FALSE AND vbDiscountPercent     > 0 THEN CAST ( (1 - vbDiscountPercent     / 100) * (CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    WHEN vbIsChangePrice = FALSE AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbExtraChargesPercent / 100) * (CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                               END
                       WHEN vbVATPercent > 0
                          -- если цены без НДС, тогда учитываем или % Скидки или % Наценки для суммы без НДС, округляем до 2-х знаков, а потом добавляем НДС (этот вариант может понадобиться для БН) !!!но для БН и "иногда" НАЛ - скидка/наценка учтена в цене!!!
                          THEN CASE WHEN 1=0 AND vbDiscountPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 - vbDiscountPercent/100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    WHEN 1=0 AND vbExtraChargesPercent > 0 THEN CAST ( (1 + vbVATPercent / 100) * CAST ( (1 + vbExtraChargesPercent/100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2)) AS NUMERIC (16, 2))
                                    ELSE CAST ( (1 + vbVATPercent / 100) * (_tmp_real.OperSumm_Partner_ChangePrice_Currency) AS NUMERIC (16, 2))
                               END
                  END AS OperSumm_Partner_Currency_real

          FROM
                 -- получили 1 запись + !!! перевели в валюту если надо!!!
                (SELECT 
                        -- новая Схема для суммы НДС - 6 знаков
                        CAST (
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

                        -- сумма по Контрагенту - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * tmpMI.Price / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * tmpMI.Price AS NUMERIC (16, 2))
                             END
                          
                             ) AS OperSumm_Partner

                         -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price - vbChangePrice) AS NUMERIC (16, 2))
                             END
                            ) AS OperSumm_Partner_ChangePrice

                        -- сумма по Контрагенту с учетом скидки для цены - с округлением до 2-х знаков !!!в валюте!!!
                      , SUM (CASE WHEN tmpMI.CountForPrice <> 0
                                       THEN CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) / tmpMI.CountForPrice AS NUMERIC (16, 2))
                                  ELSE CAST (tmpMI.OperCount_calc * (tmpMI.Price_Currency - vbChangePrice) AS NUMERIC (16, 2))
                             END) AS OperSumm_Partner_ChangePrice_Currency                       
                  FROM (SELECT tmpMI.GoodsId
                             , tmpMI.GoodsKindId
                            
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

                               -- очень важное кол-во, для него расчет сумм
                             , tmpMI.OperCount_calc

                               -- кол-во Partner (!!!без тары с ц=0!!!)
                             , CASE WHEN COALESCE (Object_InfoMoney_View.InfoMoneyDestinationId, 0) = zc_Enum_InfoMoneyDestination_20500() -- Оборотная тара
                                     AND tmpMI.Price = 0
                                         THEN 0
                                    ELSE tmpMI.OperCount_Partner
                               END AS OperCount_Partner

                        FROM tmpMI_real AS tmpMI
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ObjectId = tmpMI.GoodsId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                       ) AS tmpMI
                ) AS _tmp_real
                )

     SELECT tmpCalc1.OperSumm_MVAT
          , tmpCalc1.OperSumm_PVAT
          , tmpCalc1.OperSumm_Partner
          , tmpCalc1.OperSumm_Partner_Currency
          , tmpCalc2.OperSumm_MVAT_real            
          , tmpCalc2.OperSumm_PVAT_real            
          , tmpCalc2.OperSumm_Partner_real         
          , tmpCalc2.OperSumm_Partner_Currency_real
     FROM tmpCalc1  
         LEFT JOIN tmpCalc2 ON 1=1 
                
                
          ) 
          AS _tmp;

     -- !!!меняется значение - переводится в валюту zc_Enum_Currency_Basis!!! - !!!нельзя что б переводился в строчной части!!!
     IF vbCurrencyDocumentId <> zc_Enum_Currency_Basis() AND vbParValue <> 0
     THEN
         vbOperSumm_Partner:= CAST (vbOperSumm_Currency * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         vbOperSumm_Partner_real:= CAST (vbOperSumm_Currency_real * vbCurrencyValue / vbParValue AS NUMERIC (16, 2));
         
         IF vbDiscountPercent = 0 AND vbExtraChargesPercent = 0
         THEN 
             vbOperSumm_PVAT:= vbOperSumm_Partner;
             vbOperSumm_PVAT_real:= vbOperSumm_Partner_real;
         END IF;
         IF vbVATPercent = 0
         THEN 
             vbOperSumm_MVAT:= vbOperSumm_Partner;
             vbOperSumm_MVAT_real:= vbOperSumm_Partner_real;
         END IF; 
         
         
     END IF;

     -- Тест
      --RAISE EXCEPTION 'Summ_MVAT %  Summ_PVAT %   Summ %', vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner ;
      -- Результат
    RETURN QUERY

     SELECT vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_Partner
          , vbOperSumm_MVAT_real, vbOperSumm_PVAT_real, vbOperSumm_Partner_real
     ;


     -- Сохранили свойство <Итого сумма по накладной (без НДС)>1
        
     /* 
         -- Сохранили свойство <Итого сумма по накладной (без НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- Сохранили свойство <Итого сумма по накладной (с НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
          -- Сохранили свойство <Итого сумма по накладной (с учетом НДС и скидки)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbOperSumm_Partner );
       
    */

if  inMovementId = 25153488 and 1=0
then
    RAISE EXCEPTION 'Ошибка.<%>', vbTotalSummAvCardSecondRecalc;
end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.08.24         *
*/
-- тест
--SELECT * from lpSelect_MovementFloat_TotalSumm_Sale(28785530 ) 

--  SELECT * from lpSelect_MovementFloat_TotalSumm_Sale (28786822) 
--  SELECT * from lpSelect_MovementFloat_TotalSumm_Sale (28765855) 