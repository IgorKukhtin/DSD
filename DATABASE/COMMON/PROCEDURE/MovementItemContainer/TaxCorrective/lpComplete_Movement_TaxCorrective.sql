-- Function: lpComplete_Movement_TaxCorrective (Integer, Integer);

DROP FUNCTION IF EXISTS lpComplete_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer   , -- ключ Документа
   OUT outMessageText      Text      ,
    IN inUserId            Integer     -- пользователь
)
RETURNS Text
AS
$BODY$
  DECLARE vbDocumentTaxKindId Integer;
  DECLARE vbPrice TFloat;
  DECLARE vbMovementId_tax Integer;
  DECLARE vbTotalSumm_tax  TFloat;
  DECLARE vbTotalSumm_corr TFloat;
BEGIN

     -- определяется <Тип формирования налогового документа>
     vbDocumentTaxKindId:= (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind());

     -- Проверка ошибки
     IF '01.01.2017' < (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
         AND vbDocumentTaxKindId <> zc_Enum_DocumentTaxKind_Goods()
     THEN
         outMessageText:= (SELECT tmp.MessageText FROM lpSelect_TaxCorrectiveFromTax (inMovementId) AS tmp);
         -- !!!Выход если ошибка!!!
         IF outMessageText <> '' THEN RETURN; END IF;
     END IF;

     -- получили цену для DocumentTaxKind
     vbPrice := (SELECT ObjectFloat_Price.ValueData
                 FROM ObjectFloat AS ObjectFloat_Price
                 WHERE ObjectFloat_Price.ObjectId = vbDocumentTaxKindId
                   AND ObjectFloat_Price.DescId   = zc_objectFloat_DocumentTaxKind_Price()
                 );
     -- проверка цены
     IF vbPrice <> 0
     THEN
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND COALESCE (MIFloat_Price.ValueData, 0) <> vbPrice
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.Для документа <%> должна быть цена = <%>'
                            , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()))
                            , vbPrice
                             ;
         END IF;
     END IF;

     -- !!!сохранили - НОВАЯ схема с 30.03.18!!!
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NPP_calc(), inMovementId
                                           , EXISTS (SELECT 1
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
                                                    )
                                            );


     IF vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
          -- у всех возвратов "восстанавливаем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, vbDocumentTaxKindId)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId     = zc_MovementLinkMovement_Master()
            AND MovementLinkMovement.MovementChildId > 0
            ;
     END IF;


     -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TaxCorrective()
                                , inUserId     := inUserId
                                 );

     -- если сумма налоговой меньше чем сумма всех корректировок, показать в ошибке и сумму итого всех корр и сумму налоговой
     IF 1=1 -- inUserId = 5 OR inUserId = 9457
     THEN
         -- налоговая и сумма
         SELECT Movement.Id                       AS MovementId
              , MovementFloat_TotalSumm.ValueData AS TotalSumm
                INTO vbMovementId_tax, vbTotalSumm_tax
         FROM MovementLinkMovement AS MovementLinkMovement_Child
              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Child.MovementChildId
--                               AND Movement.StatusId = zc_Enum_Status_Complete()
              -- сумма налоговой
              INNER JOIN MovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = MovementLinkMovement_Child.MovementChildId
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSummPVAT()
         WHERE MovementLinkMovement_Child.MovementId = inMovementId
           AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child();

         -- Сумма ВСЕХ корректировок к налоговой
         SELECT SUM ( COALESCE (MovementFloat_TotalSumm.ValueData,0)) AS TotalSumm
                INTO vbTotalSumm_corr
         FROM MovementLinkMovement AS MovementLinkMovement_Child
              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Child.MovementId
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
              -- сумма корректировка
              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId = MovementLinkMovement_Child.MovementId
                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSummPVAT()
	 WHERE MovementLinkMovement_Child.MovementChildId = vbMovementId_tax
           AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child();

        -- проверка
        IF COALESCE (vbTotalSumm_tax,0) < COALESCE (vbTotalSumm_corr,0) --OR inUserId = 5
        THEN
            --
            outMessageText:= 'Ошибка.Сумма <' || zfConvert_FloatToString (vbTotalSumm_corr) || '>'
                          || ' по всем документам ' || (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_TaxCorrective())
                          || ' больше чем сумма <' || zfConvert_FloatToString (vbTotalSumm_tax) || '>'
                          || ' в документе <' || (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax()) || '>'
                          || ' № <' || (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = vbMovementId_tax AND MS.DescId = zc_MovementString_InvNumberPartner()) || '>'
                          || ' от <' || zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_tax)) || '>.'
                          || CHR (13) || 'Проведение невозможно.'
                            ;
            -- Распроводим Документ
            PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                         , inUserId     := inUserId);

            --
            RETURN;

            -- RAISE EXCEPTION 'Ошибка.Сумма налоговой <%> меньше суммы корректировок <%>', vbTotalSumm_tax, vbTotalSumm_corr;
          /*RAISE EXCEPTION 'Ошибка.Сумма <%> по всем документам % больше чем сумма <%> в документе <%> № <%> от <%>.%Проведение невозможно.'
                           , zfConvert_FloatToString (vbTotalSumm_corr)
                           , (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective())
                           , zfConvert_FloatToString (vbTotalSumm_tax)
                           , (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax())
                           , (SELECT MS.ValueData FROM MovementString AS MS WHERE MS.MovementId = vbMovementId_tax AND MS.DescId = zc_MovementString_InvNumberPartner())
                           , zfConvert_DateToString ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_tax))
                           , CHR (13)
                            ;*/
        END IF;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 06.05.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
