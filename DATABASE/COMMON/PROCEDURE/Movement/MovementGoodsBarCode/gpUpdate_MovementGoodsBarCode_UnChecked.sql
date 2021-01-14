-- Function: gpUpdate_MovementGoodsBarCode_Checked()

DROP FUNCTION IF EXISTS gpUpdate_MovementGoodsBarCode_UnChecked (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementGoodsBarCode_UnChecked(
    IN inId                  Integer  , -- �������� ��������� ������� 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ � ���� ������ - ������ �� ������, 
     IF COALESCE (inId, 0) = 0
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ������������ <���������� ����> - ��� ���������� ��������
     vbMemberId_user:= CASE WHEN vbUserId = 5 THEN 9457 ELSE
                       (SELECT ObjectLink_User_Member.ChildObjectId
                        FROM ObjectLink AS ObjectLink_User_Member
                        WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                          AND ObjectLink_User_Member.ObjectId = vbUserId)
                       END
                      ;
     -- ��������
     IF COALESCE (vbMemberId_user, 0) = 0
     THEN 
          RAISE EXCEPTION '������.� ������������ <%> �� ��������� �������� <���.����>.', lfGet_Object_ValueData (vbUserId);
     END IF;


     -- ��������� �������� <�������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), inId, FALSE);
     -- ��������� �������� <����/�����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Checked(), inId, CURRENT_TIMESTAMP);
     -- ��������� ����� � <������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Checked(), inId, vbMemberId_user);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.18         *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementGoodsBarCode_UnChecked(inBarCode := '201000923136' ,  inSession := '5');
