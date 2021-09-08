-- Function: gpUpdate_Movement_Check_Update_CommentChecking()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Update_CommentChecking(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Update_CommentChecking(
    IN inMovementId                Integer   , -- ���� ������� <��������>
    IN inCommentChecking           TVarChar  , -- ���������� ��� �����������
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
     AND vbUserId <> 9383066 
  THEN
    RAISE EXCEPTION '��������� <���������� ��� �����������> ��� ���������.';
  END IF;
      
  --������ �������� ������������
  PERFORM lpInsertUpdate_MovementString(zc_MovementString_CommentChecking(), inMovementId, inCommentChecking);
  
  -- ��������� ��������
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 29.07.21                                                                    *
*/

-- ����

select * from gpUpdate_Movement_Check_Update_CommentChecking(inMovementId := 24368435 , inCommentChecking := '645745768' ,  inSession := '3');