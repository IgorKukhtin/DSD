-- Function: gpUpdate_Movement_TransportGoods_CommentError ()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TransportGoods_CommentError (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TransportGoods_CommentError(
    IN inMovementId               Integer   , --
    IN inCommentError             TVarChar  , -- ����� ������ ��� ��������� (�-���)
    IN inSession                  TVarChar    -- ������ ������������

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId       Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� ����� ������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentError(), inMovementId, inCommentError);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.06.23                                                       *
*/

-- ����
--