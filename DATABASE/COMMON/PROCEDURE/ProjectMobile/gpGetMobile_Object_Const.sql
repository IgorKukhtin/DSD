-- Function: gpGetMobile_Object_Const (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_Object_Const (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Object_Const(
    IN inSession          TVarChar       -- ������ ������������
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
             -- , SyncDateIn          TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
             -- , SyncDateOut         TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ������, �������� � �.�
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
-- !!!�������� - ��� �����!!! - �������� �.�.
if inSession = '5' then  inSession :=  '140094'; end if;

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY
       WITH tmpPersonal AS (SELECT ObjectLink_User_Member.ChildObjectId      AS MemberId
                                 , Object_Member.ValueData                   AS MemberName
                                 , MAX (View_Personal.PersonalId) :: Integer AS PersonalId
                            FROM (SELECT 1) AS tmp
                                 LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ObjectId = vbUserId
                                                        AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                 LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
                                 LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.MemberId = ObjectLink_User_Member.ChildObjectId
                            GROUP BY ObjectLink_User_Member.ChildObjectId
                                   , Object_Member.ValueData
                           )
       -- ���������
       SELECT Object_PaidKind_FirstForm.Id           AS PaidKindId_First
            , Object_PaidKind_FirstForm.ValueData    AS PaidKindName_First
            , Object_PaidKind_SecondForm.Id          AS PaidKindId_Second
            , Object_PaidKind_SecondForm.ValueData   AS PaidKindName_Second
           
            , Object_Status_Complete.Id              AS StatusId_Complete
            , Object_Status_Complete.ValueData       AS StatusName_Complete
            , Object_Status_UnComplete.Id            AS StatusId_UnComplete
            , Object_Status_UnComplete.ValueData     AS StatusName_UnComplete
            , Object_Status_Erased.Id                AS StatusId_Erased
            , Object_Status_Erased.ValueData         AS StatusName_Erased

            , Object_Unit.Id                         AS UnitId
            , Object_Unit.ValueData                  AS UnitName
            , Object_Unit_ret.Id                     AS UnitId_ret
            , Object_Unit_ret.ValueData              AS UnitName_ret
            , Object_Cash.Id                         AS CashId
            , Object_Cash.ValueData                  AS CashName

            , tmpPersonal.MemberId
            , tmpPersonal.MemberName
            , tmpPersonal.PersonalId

            , Object_User.Id               AS UserId
            , Object_User.ValueData        AS UserLogin
            , ObjectString_User_.ValueData AS UserPassword

            , REPLACE (LOWER (Object_ConnectParam.ValueData), '/project', '/projectmobile')::TVarChar AS WebService

            -- AS LastDateIn
            -- AS LastDateOut

       FROM tmpPersonal
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
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= zfCalc_UserAdmin())
