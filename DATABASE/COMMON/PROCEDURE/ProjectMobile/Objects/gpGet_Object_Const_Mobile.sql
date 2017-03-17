-- Function: gpGet_Object_Const_Mobile (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Const_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Const_Mobile(
     IN inMemberId       Integer  , -- ���.����
     IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE (PaidKindId_First    Integer   -- ����� ������ - ��
             , PaidKindName_First  TVarChar  -- ����� ������ - ���
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
   DECLARE calcUserId Integer;
   DECLARE calcSession TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     vbMemberId:= (SELECT tmp.MemberId FROM gpGetMobile_Object_Const (inSession) AS tmp);
     IF (COALESCE(inMemberId,0) <> 0 AND COALESCE(vbMemberId,0) <> inMemberId)
        THEN
            RAISE EXCEPTION '������.�� ���������� ���� �������.'; 
     END IF;

     calcSession := (SELECT CAST (ObjectLink_User_Member.ObjectId AS TVarChar) 
                     FROM ObjectLink AS ObjectLink_User_Member
                     WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                       AND ObjectLink_User_Member.ChildObjectId = vbMemberId);

     calcUserId:= lpGetUserBySession (calcSession);

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

            , tmpPersonal.MemberId
            , tmpPersonal.MemberName
            , tmpPersonal.PersonalId

            , Object_User.Id               AS UserId
            , Object_User.ValueData        AS UserLogin
            , ObjectString_User_.ValueData AS UserPassword

            , Object_ConnectParam.ValueData AS WebService

       FROM gpGetMobile_Object_Const (calcUserId) AS tmpMobileConst
            LEFT JOIN Object AS Object_PaidKind_FirstForm  ON Object_PaidKind_FirstForm.Id = zc_Enum_PaidKind_FirstForm()
            LEFT JOIN Object AS Object_PaidKind_SecondForm ON Object_PaidKind_SecondForm.Id = zc_Enum_PaidKind_SecondForm()

            LEFT JOIN Object AS Object_Status_Complete   ON Object_Status_Complete.Id   = zc_Enum_Status_Complete()
            LEFT JOIN Object AS Object_Status_UnComplete ON Object_Status_UnComplete.Id = zc_Enum_Status_UnComplete()
            LEFT JOIN Object AS Object_Status_Erased     ON Object_Status_Erased.Id     = zc_Enum_Status_Erased()

            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = 8459 -- ����� ����������
            LEFT JOIN Object AS Object_Unit_ret ON Object_Unit_ret.Id = 8461 -- ����� ���������
            LEFT JOIN Object AS Object_Cash     ON Object_Cash.Id     = NULL

            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
            LEFT JOIN ObjectString AS ObjectString_User_
                                   ON ObjectString_User_.ObjectId = Object_User.Id
                                  AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

            LEFT JOIN Object AS Object_ConnectParam ON Object_ConnectParam.Id = zc_Enum_GlobalConst_ConnectParam ()
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.02.17                                        *
*/

-- ����
-- SELECT * FROM gpGet_Object_Const_Mobile (inSession:= zfCalc_UserAdmin())
