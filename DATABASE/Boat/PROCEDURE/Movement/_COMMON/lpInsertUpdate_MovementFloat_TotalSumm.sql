-- Function: lpInsertUpdate_MovementFloat_TotalSumm (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm(
    IN inMovementId Integer -- Ключ объекта <Документ>
)
  RETURNS VOID AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbOperDatePartner TDateTime;
  DECLARE vbPriceWithVAT Boolean;
  DECLARE vbVATPercent TFloat;
  DECLARE vbDiscountPercent TFloat;
  DECLARE vbPaidKindId Integer;
  
  DECLARE vbTotalCount_Master TFloat;
  DECLARE vbTotalCount_Child TFloat;
  DECLARE vbTotalCountRemains TFloat;
  DECLARE vbTotalSumm TFloat;
  DECLARE vbTotalSummChange TFloat;
  DECLARE vbOperSumm_PVAT TFloat;
  DECLARE vbOperSumm_MVAT TFloat;
  DECLARE vbOperSumm_PVAT_original TFloat;    
              
BEGIN

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент документа не сохранен.';
     END IF;

     -- Эти параметры нужны для расчета конечных сумм по Контрагенту 
     SELECT Movement.DescId
          , CASE WHEN Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut(), zc_Movement_Sale(), zc_Movement_ReturnIn())
                      THEN COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
                 ELSE Movement.OperDate
            END AS OperDatePartner
          , COALESCE (MovementBoolean_PriceWithVAT.ValueData, TRUE)
          , COALESCE (MovementFloat_VATPercent.ValueData, 0)
          , COALESCE (MovementFloat_DiscountTax.ValueData, 0) AS DiscountPercent
          --, CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) < 0 THEN -1 * MovementFloat_ChangePercent.ValueData ELSE 0 END AS DiscountPercent
          --, CASE WHEN COALESCE (MovementFloat_ChangePercent.ValueData, 0) > 0 THEN      MovementFloat_ChangePercent.ValueData ELSE 0 END AS ExtraChargesPercent

          , COALESCE (MovementLinkObject_PaidKind.ObjectId, 0)         AS PaidKindId

            INTO vbMovementDescId, vbOperDatePartner, vbPriceWithVAT, vbVATPercent, vbDiscountPercent, vbPaidKindId

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
           LEFT JOIN MovementFloat AS MovementFloat_DiscountTax
                                   ON MovementFloat_DiscountTax.MovementId = Movement.Id
                                  AND MovementFloat_DiscountTax.DescId = zc_MovementFloat_DiscountTax()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_FromTo
                                        ON MovementLinkObject_FromTo.MovementId = Movement.Id
                                       AND MovementLinkObject_FromTo.DescId     = CASE WHEN Movement.DescId = zc_Movement_Sale() THEN zc_MovementLinkObject_To() WHEN Movement.DescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_From() END

           LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                        ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                       AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()

      WHERE Movement.Id = inMovementId;

     --
     SELECT SUM (COALESCE(tmpMI.OperCount_Master, 0))  AS TotalCount_Master
          , SUM (COALESCE(tmpMI.OperCount_Child, 0))   AS TotalCount_Child
          , SUM (COALESCE(tmpMI.OperSumm_original,0))  AS TotalSumm
          , SUM (COALESCE (tmpMI.ChangePercent, 0))    AS TotalSummChange

           -- Сумма без НДС
          , SUM (CASE WHEN NOT vbPriceWithVAT OR vbVATPercent = 0
                      -- если цены без НДС или %НДС=0
                      THEN (zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) ))
                 WHEN vbPriceWithVAT AND 1=1
                      -- если цены c НДС
                      THEN CAST ( (zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) )) / (1 + vbVATPercent / 100) AS NUMERIC (16, 2))
                 WHEN vbPriceWithVAT
                      -- если цены c НДС (Вариант может быть если  первичен расчет НДС =1/6 )
                      THEN zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) ) - CAST ( ((zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) )) / (100 / vbVATPercent + 1)) AS NUMERIC (16, 2) )
            END) AS OperSumm_MVAT
    
            -- Сумма с НДС
          , SUM (CASE -- если цены с НДС
                 WHEN vbPriceWithVAT OR vbVATPercent = 0
                      THEN (zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) ))
                 -- если цены без НДС
                 WHEN vbVATPercent > 0
                      THEN CAST ( ((1 + vbVATPercent / 100) * zfCalc_SummIn (tmpMI.OperCount_Master, tmpMI.Price, COALESCE (tmpMI.CountForPrice,1) )) AS NUMERIC (16, 2))
            END) AS OperSumm_PVAT
    
            -- Сумма с НДС + !!!НЕ!!! учтена скидка в цене
          , SUM (CASE -- если цены с НДС
                 WHEN vbPriceWithVAT OR vbVATPercent = 0
                      THEN (OperSumm_original)
    
                 -- если цены без НДС
                 WHEN vbVATPercent > 0
                      THEN CAST ( (1 + vbVATPercent / 100) * (OperSumm_original) AS NUMERIC (16, 2))
            END) AS OperSumm_PVAT_original

                               
            INTO vbTotalCount_Master, vbTotalCount_Child, vbTotalSumm , vbTotalSummChange
              , vbOperSumm_MVAT, vbOperSumm_PVAT, vbOperSumm_PVAT_original
       
       FROM (SELECT MovementItem.DescId
                  , MovementItem.ObjectId            AS GoodsId
                  , CASE WHEN MovementItem.DescId = zc_MI_Master() THEN MovementItem.Amount ELSE 0 END AS OperCount_Master
                  , CASE WHEN MovementItem.DescId = zc_MI_Child() THEN MovementItem.Amount ELSE 0 END  AS OperCount_Child
                  , MIFloat_OperPrice.ValueData      AS OperPrice_original
                  --цена со скидкой
                  , CASE WHEN MIFloat_ChangePercent.ValueData <> 0  AND vbMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) -- !!!для НАЛ не учитываем!!!
                         THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                  , inChangePercent:= MIFloat_ChangePercent.ValueData
                                                  , inPrice        := MIFloat_OperPrice.ValueData
                                                  , inIsWithVAT    := vbPriceWithVAT
                                                   )
                         WHEN vbDiscountPercent <> 0 AND vbMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) -- !!!для НАЛ не учитываем!!!
                              THEN zfCalc_PriceTruncate (inOperDate     := vbOperDatePartner
                                                       , inChangePercent:= -1 * vbDiscountPercent
                                                       , inPrice        := MIFloat_OperPrice.ValueData
                                                       , inIsWithVAT    := vbPriceWithVAT
                                                        )
                         ELSE COALESCE (MIFloat_OperPrice.ValueData, 0)
                    END AS Price
                  , COALESCE (MIFloat_CountForPrice.ValueData, 0) AS CountForPrice
                  , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                  , zfCalc_SummIn (MovementItem.Amount, MIFloat_OperPrice.ValueData, COALESCE (MIFloat_CountForPrice.ValueData, 0) ) AS OperSumm_original
             FROM MovementItem
                  LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = MovementItem.PartionId
                  
                  LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                              ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
      
                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
      
                  LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                              ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                             AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                                             
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND MovementItem.isErased = false
             ) AS tmpMI;


  
         -- Сохранили свойство <Итого количество("главные элементы")>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalCount(), inMovementId, vbTotalCount_Master);
         -- Сохранили свойство <Итого Сумма>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), inMovementId, vbTotalSumm);
         -- Сохранили свойство <Итого сумма по накладной (без НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummMVAT(), inMovementId, vbOperSumm_MVAT);
         -- Сохранили свойство <Итого сумма по накладной (с НДС)>
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPVAT(), inMovementId, vbOperSumm_PVAT);
         -- Сохранили свойство <Итого сумма скидки по накладной>
         --PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummChange(), inMovementId, vbOperSumm_Partner - vbOperSumm_PVAT_original); 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.02.21         *
*/
-- select lpInsertUpdate_MovementFloat_TotalSumm (inMovementId:= id) from gpSelect_Movement_WeighingPartner (inStartDate := ('01.06.2014')::TDateTime , inEndDate := ('30.06.2014')::TDateTime ,  inSession := '5') as a
-- тест
-- SELECT lpInsertUpdate_MovementFloat_TotalSumm(inMovementId:= 76) 