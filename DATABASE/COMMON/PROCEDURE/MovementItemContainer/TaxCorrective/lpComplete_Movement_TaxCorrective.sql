-- Function: lpComplete_Movement_TaxCorrective (Integer, Integer);

DROP FUNCTION IF EXISTS lpComplete_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_TaxCorrective(
    IN inMovementId        Integer   , -- ���� ���������
   OUT outMessageText      Text      ,
    IN inUserId            Integer     -- ������������
)
RETURNS Text
AS
$BODY$
  DECLARE vbDocumentTaxKindId Integer;
BEGIN

     -- ������������ <��� ������������ ���������� ���������>
     vbDocumentTaxKindId:= (SELECT ObjectId  FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_DocumentTaxKind());

     -- �������� ������
     outMessageText:= (SELECT tmp.MessageText FROM lpSelect_TaxCorrectiveFromTax (inMovementId) AS tmp);
     -- !!!����� ���� ������!!!
     IF outMessageText <> '' THEN RETURN; END IF;


     IF vbDocumentTaxKindId = zc_Enum_DocumentTaxKind_Corrective()
     THEN
          -- � ���� ��������� "���������������" <��� ������������ ���������� ���������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, vbDocumentTaxKindId)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     END IF;

     -- ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_TaxCorrective()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * add lpInsert_MovementProtocol
 06.05.14                                        *
*/

-- ����
-- SELECT * FROM lpComplete_Movement_TaxCorrective (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
