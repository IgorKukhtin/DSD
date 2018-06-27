-- Function: gpUpdate_ScaleCeh_Movement_ArticleLoss()

DROP FUNCTION IF EXISTS gpUpdate_ScaleCeh_Movement_ArticleLoss (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ScaleCeh_Movement_ArticleLoss(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inArticleLossId       Integer   , -- ���� �������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� ����� � <��������� ������������� 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inMovementId, inArticleLossId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.06.18                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_ScaleCeh_Movement_ArticleLoss (inMovementId:= 0, inSession:= '2')
