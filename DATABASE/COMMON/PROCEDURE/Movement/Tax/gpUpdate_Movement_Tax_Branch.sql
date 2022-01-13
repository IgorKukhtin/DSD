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

     outBranchName := (SELECT Object.ValueData FROM Object WHERE Object.Id = inBranchId);
     
-- ��������� ����� � <������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Branch(), inMovementId, inBranchId);

     -- ������������ 
     vbAccessKeyId:= CASE WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportDnepr())
                               THEN zc_Enum_Process_AccessKey_DocumentDnepr()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKiev())
                               THEN zc_Enum_Process_AccessKey_DocumentKiev()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportOdessa())
                               THEN zc_Enum_Process_AccessKey_DocumentOdessa()

                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportZaporozhye())
                               THEN zc_Enum_Process_AccessKey_DocumentZaporozhye()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKrRog())
                               THEN zc_Enum_Process_AccessKey_DocumentKrRog()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportNikolaev())
                               THEN zc_Enum_Process_AccessKey_DocumentNikolaev()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportKharkov())
                               THEN zc_Enum_Process_AccessKey_DocumentKharkov()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportCherkassi())
                               THEN zc_Enum_Process_AccessKey_DocumentCherkassi()
   
                          WHEN inBranchId = (SELECT Id FROM Object WHERE DescId = zc_Object_Branch() AND AccessKeyId = zc_Enum_Process_AccessKey_TrasportLviv())
                               THEN zc_Enum_Process_AccessKey_DocumentLviv()
                     END;
     -- !!!������!!!
     UPDATE Movement SET AccessKeyId = vbAccessKeyId WHERE Movement.Id = inMovementId AND vbAccessKeyId > 0;
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