-- Function: gpGet_Object_Const_Mobile (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Const_Mobile (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Const_Mobile(
     IN inMemberId       Integer  , -- ���.����
     IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE (PaidKindId_First      Integer   -- ����� ������ - ��
             , PaidKindName_First    TVarChar  -- ����� ������ - ���
             , PaidKindId_Second     Integer   -- ����� ������ - ���
             , PaidKindName_Second   TVarChar  -- ����� ������ - ���
             , StatusId_UnComplete   Integer   -- ������ - �� ��������
             , StatusName_UnComplete TVarChar  -- ������ - �� ��������
             , StatusId_Complete     Integer   -- ������ - ��������
             , StatusName_Complete   TVarChar  -- ������ - ��������
             , StatusId_Erased       Integer   -- ������ - ������
             , StatusName_Erased     TVarChar  -- ������ - ������
             , UnitId                Integer   -- ������������� - �� ����� ����� ����� ����������� ����� + ����� ������� ����� ��������� �� ������� �� + � �.�.
             , UnitName              TVarChar  -- �������������
             , UnitId_ret            Integer   -- ������������� �������� - �� ����� ����� ����� ����������� �������
             , UnitName_ret          TVarChar  -- ������������� ��������
             , CashId                Integer   -- ����� - ������������ ���� ����� ������������� ������ �����
             , CashName              TVarChar  -- �����
             , MemberId              Integer   -- ���. ����
             , MemberName            TVarChar  -- ���. ����, ������������
             , PersonalId            Integer   -- ���������
             , UserId                Integer   -- ������������
             , UserLogin             TVarChar  -- �����
             -- , UserPassword          TVarChar  -- ������
             , WebService            TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� ��
             -- , SyncDateIn         TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
             -- , SyncDateOut        TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ������, �������� � �.�
             -- , MobileVersion         TVarChar  -- ������ ���������� ����������. ������: "1.0.3.625"
             -- , MobileAPKFileName     TVarChar  -- �������� ".apk" ����� ���������� ����������. ������: "ProjectMobile.apk"
             , PriceListId_def       Integer   -- �����-���� ��� "��������" ��, �.�. ����������� �� ��������� ����������
             , PriceListName_def     TVarChar  -- �����-���� ��� "��������" ��, �.�. ����������� �� ��������� ����������
             , OperDate_diff         Integer   -- �� ������� ���� ����� ��������� ��� ������� � ������ �����, �.�. ��� �������� ���������� ���� ��������� �� ��������� ����� ���� �� ����������� ������ � �������� - ����������
             , ReturnDayCount        Integer   -- ������� ���� ����������� �������� �� ������ �����
)
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbUserId_Mobile Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ ��������!!! - � ������ ����������� ������������ ����� ������������� ������ � ���������� ����������
     vbUserId_Mobile:= (SELECT lfGet.UserId FROM lfGet_User_MobileCheck (inMemberId:= inMemberId, inUserId:= vbUserId) AS lfGet);


     -- ���������
     RETURN QUERY
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

            , tmpMobileConst.WebService

            , tmpMobileConst.PriceListId_def
            , tmpMobileConst.PriceListName_def
            , tmpMobileConst.OperDate_diff
            , tmpMobileConst.ReturnDayCount

       FROM gpGetMobile_Object_Const (vbUserId_Mobile :: TVarChar) AS tmpMobileConst
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.17         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Const_Mobile (inMemberId := 149833 ,  inSession := '5');
