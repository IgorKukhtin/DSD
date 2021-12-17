-- gpUpdate_Movement_Tax_Branch()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_Branch (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_Branch (
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inBranchId            Integer   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- ��������� ������ ��� zc_Enum_DocumentTaxKind_Prepay
     
     IF (SELECT MLO.ObjectId
         FROM MovementLinkObject AS MLO
         WHERE MLO.MovementId = inMovementId
           AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()
         ) <> zc_Enum_DocumentTaxKind_Prepay()
     THEN 
         RAISE EXCEPTION '������.��� ���� �������� �������� <������>.';
     END IF;
     
     
     IF (SELECT DescId FROM Movement WHERE Id = inMovementId) = zc_Movement_Tax() 
     THEN
	vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_Branch());
     ELSE 
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_Branch());
     END IF;

     -- ��������� ����� � <������>
     --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, inBranchId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.12.21         *
*/

-- ����
--