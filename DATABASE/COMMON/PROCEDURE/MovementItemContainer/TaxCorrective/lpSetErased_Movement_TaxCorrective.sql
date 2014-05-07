-- Function: lpSetErased_Movement_TaxCorrective (Integer, Integer)

DROP FUNCTION IF EXISTS lpSetErased_Movement_TaxCorrective (Integer, Integer);

CREATE OR REPLACE FUNCTION lpSetErased_Movement_TaxCorrective(
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
          -- � ���� ��������� "�������" <��� ������������ ���������� ���������>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), MovementLinkMovement.MovementChildId, NULL)
          FROM MovementLinkMovement
          WHERE MovementLinkMovement.MovementId = inMovementId
            AND MovementLinkMovement.DescId = zc_MovementLinkMovement_Master();
     /*ELSE 
     !!!!!!!!!! �������� !!!!!!!
     IF vbDocumentTaxKindId IN (zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalSR(), zc_Enum_DocumentTaxKind_CorrectiveSummaryJuridicalR())
          -- � ���� ��������� �� ��.���� + ������� + ������ "�������" <��� ������������ ���������� ���������>
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

     -- ������� ��������
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 06.05.14                                        *
*/

-- ����
-- SELECT * FROM lpSetErased_Movement_TaxCorrective (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
