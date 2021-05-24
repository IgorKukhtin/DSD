-- Function: gpUpdateMovement_CheckedProtocol()

DROP FUNCTION IF EXISTS gpUpdateMovement_CheckedProtocol (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_CheckedProtocol(
    IN inId                  Integer   , -- ���� ������� <��������>
 INOUT ioChecked             Boolean   , -- ��������
   OUT outCheckedDate        TDateTime ,
   OUT outCheckedName        TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD 
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbMemberId_user Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);  --  lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());

     -- ������������ <���������� ����> - ��� ���������� �������� / ������ �������  ��������
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;

     -- ���������� �������
     ioChecked:= NOT ioChecked;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, ioChecked);

     IF ioChecked = TRUE
     THEN
         -- ��������� �������� <���� >
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Checked(), inId, CURRENT_TIMESTAMP);
         -- ��������� �������� <������������ >
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Checked(), inId, vbMemberId_user);
     END IF;

     outCheckedDate := COALESCE ((SELECT MD.ValueData 
                                 FROM MovementDate AS MD
                                 WHERE MD.MovementId = inId AND MD.DescId = zc_MovementDate_Checked())
                                 ,  NULL) :: TDateTime;
     outCheckedName := COALESCE ((SELECT Object.ValueData 
                                 FROM MovementLinkObject AS MLO
                                      LEFT JOIN Object ON Object.Id = MLO.ObjectId
                                 WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_Checked())
                                 , NULL) :: TVarChar;     

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.18         *
*/


-- ����
-- SELECT * FROM gpUpdateMovement_CheckedProtocol (inId:= 275079, ioChecked:= 'False', inSession:= '2')
