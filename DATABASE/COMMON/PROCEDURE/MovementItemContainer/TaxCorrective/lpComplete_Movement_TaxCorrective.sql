-- Function: lpComplete_Movement_TaxCorrective (Integer, Integer);

DROP FUNCTION IF EXISTS lpComplete_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TaxCorrective(
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
          -- у всех возвратов "восстанавливаем" <Тип формирования налогового документа>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, vbDocumentTaxKindId)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;

     -- ФИНИШ - Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_TaxCorrective() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 10.05.14                                        * add lpInsert_MovementProtocol
 06.05.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
