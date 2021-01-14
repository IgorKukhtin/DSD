-- Function: gpUpdate_MovementGoodsBarCode_Checked(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementGoodsBarCode_Checked (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementGoodsBarCode_Checked(
    IN inBarCode             TVarChar  , -- �������� ��������� ������� 
    IN inSession             TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbId Integer;
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ������ � ���� ������ - ������ �� ������, �.�. �� ������ ���������� "������" ���
     IF COALESCE (TRIM (inBarCode), '') = ''
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

     -- �� ����� ���� ���������� ��������  
     vbId:= (SELECT Movement.Id
             FROM (SELECT zfConvert_StringToNumber (SUBSTR (inBarCode, 4, 13-4)) AS Id) AS tmp
                 INNER JOIN Movement ON Movement.Id = tmp.Id
                                  AND Movement.DescId IN (zc_Movement_SendOnPrice(), zc_Movement_Loss())
                                  AND Movement.StatusId <> zc_Enum_Status_Erased()
             );

     -- ��������
     IF COALESCE (vbId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� � ����� <%> �� ������.', inBarCode;
     END IF;

     -- ��������� �������� <�������� (��/���)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Checked(), vbId, True);
     -- ��������� �������� <����/�����>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Checked(), vbId, CURRENT_TIMESTAMP);
     -- ��������� ����� � <������������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Checked(), vbId, vbMemberId_user);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.18         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_ReportCollation(inBarCode := '201000923136' ,  inSession := '5');
