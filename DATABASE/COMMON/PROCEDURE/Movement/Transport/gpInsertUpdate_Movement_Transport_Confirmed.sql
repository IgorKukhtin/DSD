-- Function: gpInsertUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Transport_Confirmed (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Transport_Confirmed(
    IN inId           Integer   , -- ���� ������� <��������>
    IN inisConfirmed  Boolean   , -- ����������� / ��������
    IN inSession      TVarChar    -- ������ ������������

)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());
     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_Transport_Confirmed());

     -- ������������ <���������� ����> 
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;

     -- ���������� - ���� ���������� ���������, ���� � ����� ����������� Child - �������� ����
     IF inisConfirmed = TRUE
     THEN 
       -- ��������� <�����������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inId, vbMemberId_user); 
     ELSE
       -- ��������� <�����������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_UserConfirmedKind(), inId, Null);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserConfirmedKind(), inId, 0); 
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