-- Function: lpSetErased_Movement_TaxCorrective (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement_TaxCorrective(
    IN inMovementId        Integer   , -- ключ Документа
    IN inUserId            Integer     -- пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbDocumentTaxKindId Integer;
BEGIN

     -- определяется <Тип формирования налогового документа>
     vbDocumentTaxKindId:= (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind());

     IF vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
          -- 1. Проверки на "распроведение" / "удаление"
          PERFORM lpCheck_Movement_Status (inMovementId, inUserId);

          -- у всех возвратов "удаляем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, NULL)
          FROM MovementLinkMovement
               JOIN Movement ON Movement.Id     = MovementLinkMovement.MovementChildId
                            AND Movement.DescId = zc_Movement_ReturnIn()
               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_find
                                              ON MovementLinkMovement_find.MovementChildId = MovementLinkMovement.MovementChildId
                                             AND MovementLinkMovement_find.DescId = zc_MovementLinkMovement_Master()
                                             AND MovementLinkMovement_find.MovementId <> inMovementId
               LEFT JOIN Movement AS Movement_TaxCorrective
                                  ON Movement_TaxCorrective.Id       = MovementLinkMovement_find.MovementId
                                 AND Movement_TaxCorrective.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Complete())
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
            AND Movement_TaxCorrective.Id IS NULL;
     /*ELSE 
     -- !!!!!!!!!! ДОДЕЛАТЬ !!!!!!! - Juridical
     IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR())
     THEN
          -- у всех возвратов по Юр.лицу + Договор + период "удаляем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement_find.Id, NULL)
          FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
               INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                     ON ObjectLink_Partner_Juridical.ChildObjectId = MovementLinkObject_From.ObjectId
                                    AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

               INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                             ON MovementLinkObject_From_find.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                            AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                             ON MovementLinkObject_Contract_find.ObjectId = MovementLinkObject_Contract.ObjectId
                                            AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract_find.MovementId = MovementLinkObject_From_find.MovementId

               INNER JOIN Movement AS Movement_find ON Movement_find.Id = MovementLinkObject_From_find.MovementId
                                                   AND Movement_find.DescId = zc_Movement_ReturnIn()
               INNER JOIN MovementDate AS MovementDate_OperDatePartner_find
                                       ON MovementDate_OperDatePartner_find.MovementId = Movement_find.Id
                                      AND MovementDate_OperDatePartner_find.DescId = zc_MovementDate_OperDatePartner()
                                      AND MovementDate_OperDatePartner_find.ValueData BETWEEN DATE_TRUNC ('MONTH', Movement.OperDate) AND (DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
               INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                             ON MovementLinkObject_DocumentTaxKind.MovementId = Movement_find.Id
                                            AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                            AND MovementLinkObject_DocumentTaxKind.ObjectId = vbDocumentTaxKindId
          WHERE Movement.Id = inMovementId;
     ELSE 
     -- !!!!!!!!!! ДОДЕЛАТЬ !!!!!!! - Partner
     IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryPartnerR())
     THEN
          -- у всех возвратов по Юр.лицу + Договор + период "удаляем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), Movement_find.Id, NULL)
          FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Partner
                                             ON MovementLinkObject_Partner.MovementId = Movement.Id
                                            AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

               INNER JOIN MovementLinkObject AS MovementLinkObject_From_find
                                             ON MovementLinkObject_From_find.ObjectId = MovementLinkObject_Partner.ObjectId
                                            AND MovementLinkObject_From_find.DescId = zc_MovementLinkObject_From()
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract_find
                                             ON MovementLinkObject_Contract_find.ObjectId = MovementLinkObject_Contract.ObjectId
                                            AND MovementLinkObject_Contract_find.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract_find.MovementId = MovementLinkObject_From_find.MovementId

               INNER JOIN Movement AS Movement_find ON Movement_find.Id = MovementLinkObject_From_find.MovementId
                                                   AND Movement_find.DescId = zc_Movement_ReturnIn()
               INNER JOIN MovementDate AS MovementDate_OperDatePartner_find
                                       ON MovementDate_OperDatePartner_find.MovementId = Movement_find.Id
                                      AND MovementDate_OperDatePartner_find.DescId = zc_MovementDate_OperDatePartner()
                                      AND MovementDate_OperDatePartner_find.ValueData BETWEEN DATE_TRUNC ('MONTH', Movement.OperDate) AND (DATE_TRUNC ('MONTH', Movement.OperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
               INNER JOIN MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                                             ON MovementLinkObject_DocumentTaxKind.MovementId = Movement_find.Id
                                            AND MovementLinkObject_DocumentTaxKind.DescId = zc_MovementLinkObject_DocumentTaxKind()
                                            AND MovementLinkObject_DocumentTaxKind.ObjectId = vbDocumentTaxKindId
          WHERE Movement.Id = inMovementId;
     END IF;
     END IF;*/
     END IF;

     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 06.05.14                                        *
*/

-- тест
-- SELECT * FROM lpSetErased_Movement_TaxCorrective (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
