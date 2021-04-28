-- Function: gpUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Transport_Confirmed(
    IN inMovementId           Integer   , -- ���� ������� <��������>
    IN inisConfirmed  Boolean   , -- ����������� / ��������
    IN inSession      TVarChar    -- ������ ������������

)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());

     -- ������������ <���������� ����>
     vbMemberId_user:= (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId
                       );

     -- ���������� - ���� ���������� ���������, ���� � ����� ����������� Child - �������� ����
     IF inisConfirmed = TRUE
     THEN
       -- ��������� <�����������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inMovementId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inMovementId, vbMemberId_user);
     ELSE
       -- ��������� <�����������>
     --PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inMovementId, NULL);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inMovementId, NULL);

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.21         *
*/

-- ����
--
