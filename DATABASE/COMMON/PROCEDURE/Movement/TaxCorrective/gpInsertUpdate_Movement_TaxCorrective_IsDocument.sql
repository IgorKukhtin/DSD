-- gpInsertUpdate_Movement_TaxCorrective_IsDocument()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TaxCorrective_IsDocument (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TaxCorrective_IsDocument (
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inIsDocument          Boolean   , -- ���� �� ����������� �������� (��/���)
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TaxCorrective_IsDocument());

     -- ��������� �������� <���� �� ����������� ��������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Document(), COALESCE (MovementLinkMovement_Master_find.MovementId, Movement.Id), inIsDocument)
     FROM Movement
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master
                                         ON MovementLinkMovement_Master.MovementId = Movement.Id
                                        AND MovementLinkMovement_Master.DescId = zc_MovementLinkMovement_Master()
          LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Master_find
                                         ON MovementLinkMovement_Master_find.MovementChildId = MovementLinkMovement_Master.MovementChildId
                                        AND MovementLinkMovement_Master_find.DescId = zc_MovementLinkMovement_Master()
      WHERE Movement.Id = ioId
        AND Movement.DescId = zc_Movement_TaxCorrective();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.04.14                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TaxCorrective_IsDocument (ioId:= 0, inIsDocument:= FALSE, inSession:= '2')
