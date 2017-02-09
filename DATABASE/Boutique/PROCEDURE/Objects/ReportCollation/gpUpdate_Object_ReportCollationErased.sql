-- Function: gpUpdate_Object_ReportCollationErased(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollationErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollationErased(
    IN inId             Integer  , -- 
    IN inSession        TVarChar
)
RETURNS VOID 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMemberId_user Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- ������ � ���� ������ - ������ �� ������, 
     IF COALESCE (inId, 0) = 0
     THEN
         RETURN; -- !!!�����!!!
     END IF;

     -- ������������ <���������� ����> - ��� ����������� ���� inReestrKindId
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

                     
     -- ��������� �������� <���� ����� � �����������>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), inId, CURRENT_TIMESTAMP);
     -- ��������� �������� <������������ (����� � �����������)>
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReportCollation_Buh(), inId, vbMemberId_user);
     -- ��������� �������� <����� � �����������>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), inId, False);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.01.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_ReportCollationErased(inBarCode := '201000923136' ,  inSession := '5');
