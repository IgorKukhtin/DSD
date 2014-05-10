-- Function: lpComplete_Movement_TaxCorrective (Integer, Integer);

DROP FUNCTION IF EXISTS lpComplete_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer   , -- ���� ���������
    IN inUserId            Integer     -- ������������
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbDocumentTaxKindId Integer;
BEGIN

     -- ������������ <��� ������������ ���������� ���������>
     vbDocumentTaxKindId:= (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind());

     IF vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
          -- � ���� ��������� "���������������" <��� ������������ ���������� ���������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, vbDocumentTaxKindId)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;

     -- ����� - ����������� ������ ������ ���������
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_TaxCorrective() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 10.05.14                                        * add lpInsert_MovementProtocol
 06.05.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
