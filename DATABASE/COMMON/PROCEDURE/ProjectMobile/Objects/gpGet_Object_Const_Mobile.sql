-- Function: gpGet_Object_Const_Mobile (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Const_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Const_Mobile(
     IN inMemberId       Integer  , -- ���.����
     IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE (PaidKindId_First    Integer   -- ����� ������ - ��
             , PaidKindName_First  TVarChar  -- ����� ������ - ��
             , PaidKindId_Second   Integer   -- ����� ������ - ���
             , PaidKindName_Second TVarChar  -- ����� ������ - ���
             , StatusId_UnComplete   Integer   -- ������ - �� ��������
             , StatusName_UnComplete TVarChar  -- ������ - �� ��������
             , StatusId_Complete     Integer   -- ������ - ��������
             , StatusName_Complete   TVarChar  -- ������ - ��������
             , StatusId_Erased     Integer   -- ������ - ������
             , StatusName_Erased   TVarChar  -- ������ - ������
             , UnitId              Integer   -- ������������� - �� ����� ����� ����� ����������� ����� + ����� ������� ����� ��������� �� ������� �� + � �.�.
             , UnitName            TVarChar  -- �������������
             , UnitId_ret          Integer   -- ������������� �������� - �� ����� ����� ����� ����������� �������
             , UnitName_ret        TVarChar  -- ������������� ��������
             , CashId              Integer   -- ����� - ������������ ���� ����� ������������� ������ �����
             , CashName            TVarChar  -- �����
             , MemberId            Integer   -- ���. ����
             , MemberName          TVarChar  -- ���. ����|������������
             , PersonalId          Integer   -- ���������
             , UserId              Integer   -- ������������
             , UserLogin           TVarChar  -- �����
             , UserPassword        TVarChar  -- ������
             , WebService          TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� ��
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
   DECLARE calcSession TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);
--vbMemberId:= inMemberId;
     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION '������.�� ���������� ���� �������.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                     FROM ObjectLink AS ObjectLink_User_Member
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

     -- ���������
     RETURN QUERY
       -- ���������
       SELECT tmpMobileConst.PaidKindId_First
            , tmpMobileConst.PaidKindName_First
            , tmpMobileConst.PaidKindId_Second
            , tmpMobileConst.PaidKindName_Second
           
            , tmpMobileConst.StatusId_Complete
            , tmpMobileConst.StatusName_Complete
            , tmpMobileConst.StatusId_UnComplete
            , tmpMobileConst.StatusName_UnComplete
            , tmpMobileConst.StatusId_Erased
            , tmpMobileConst.StatusName_Erased

            , tmpMobileConst.UnitId
            , tmpMobileConst.UnitName
            , tmpMobileConst.UnitId_ret
            , tmpMobileConst.UnitName_ret
            , tmpMobileConst.CashId
            , tmpMobileConst.CashName

            , tmpMobileConst.MemberId
            , tmpMobileConst.MemberName
            , tmpMobileConst.PersonalId

            , tmpMobileConst.UserId
            , tmpMobileConst.UserLogin
            , tmpMobileConst.UserPassword

            , tmpMobileConst.WebService

       FROM gpGetMobile_Object_Const (calcSession) AS tmpMobileConst

     ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.17         *
*/

-- ����
--select * from gpGet_Object_Const_Mobile(inMemberId := 149833 ,  inSession := '5');