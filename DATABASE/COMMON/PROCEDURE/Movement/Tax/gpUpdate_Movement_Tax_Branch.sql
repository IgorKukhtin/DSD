-- gpUpdate_Movement_Tax_Branch()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_Branch (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_Branch (
    IN inMovementId          Integer   , -- ���� ������� <>
    IN inBranchId            Integer   , -- ������
   OUT outBranchName         TVarChar   , 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- ��������� ������ ��� zc_Enum_DocumentTaxKind_Prepay
     
   /*IF (SELECT MLO.ObjectId
         FROM MovementLinkObject AS MLO
         WHERE MLO.MovementId = inMovementId
           AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()
         ) <> zc_Enum_DocumentTaxKind_Prepay()
     THEN 
         RAISE EXCEPTION '������.��� ���� �������� �������� <������>.';
     END IF;*/
     
     
     IF (SELECT DescId FROM Movement WHERE Id = inMovementId) = zc_Movement_Tax() 
     THEN
	vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Tax_Branch());
     ELSE 
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TaxCorrective_Branch());
     END IF;

     outBranchName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inBranchId);
     
     -- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, inBranchId);

     -- ������������ 
     vbAccessKeyId:= zfGet_AccessKey_onBranch (inBranchId, zc_Enum_Process_InsertUpdate_Movement_Tax(), vbUserId);

     -- !!!������!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Movement.Id = inMovementId AND vbAccessKeyId > 0;
     --PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, inBranchId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

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