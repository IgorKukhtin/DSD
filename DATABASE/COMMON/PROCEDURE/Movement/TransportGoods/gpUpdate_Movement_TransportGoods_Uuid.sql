-- Function: gpUpdate_Movement_TransportGoods_Uuid ()

--DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Uuid (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_Uuid (Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_Uuid(
    IN inMovementId               Integer   , --
    IN inUuid                     TVarChar  , -- ������������� ���������, � ����������� �������-����������� ������� (�-���)
    IN inCommentError             TVarChar  , -- ����� ������ ��� ��������� (�-���)
    IN inSession                  TVarChar    -- ������ ������������

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ������������� ���������, � ����������� �������-����������� ������� (�-���)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Uuid(), inMovementId, inUuid);

     -- �������� ����� ������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, inCommentError);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.05.23                                                       *
*/

-- ����
--