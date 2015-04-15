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
               LEFT JOIN MovementLinkMovement AS MovementLinkMovement_find
                                              ON MovementLinkMovement_find.MovementChildId = MovementLinkMovement.MovementChildId
                                             AND MovementLinkMovement_find.DescId = zc_MovementLinkMovement_Master()
                                             AND MovementLinkMovement_find.MovementId <> inMovementId
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master()
            AND MovementLinkMovement_find.MovementChildId IS NULL;
     /*ELSE 
     !!!!!!!!!! ДОДЕЛАТЬ !!!!!!!
     IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR())
          -- у всех возвратов по Юр.лицу + Договор + период "удаляем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, NULL)
          FROM Movement
               INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                             ON MovementLinkObject_Contract.MovementId = Movement.Id
                                            AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                            AND MovementLinkObject_Contract.ObjectId = vbContractId
               INNER JOIN MovementLinkObject ON MovementLinkObject.MovementId = Movement.Id
                                            AND MovementLinkObject.DescId = zc_MovementLinkObject_To()
                                            AND MovementLinkObject.ObjectId = vbToId
          WHERE Movement.Id = inMovementId;*/
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
