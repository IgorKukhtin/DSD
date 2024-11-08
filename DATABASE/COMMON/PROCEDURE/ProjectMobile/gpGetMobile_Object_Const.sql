-- Function: gpGetMobile_Object_Const (TVarChar)

DROP FUNCTION IF EXISTS gpGetMobile_Object_Const (TVarChar);

CREATE OR REPLACE FUNCTION gpGetMobile_Object_Const(
    IN inSession          TVarChar       -- ������ ������������
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
             , UserPassword          TVarChar  -- ������
             , WebService            TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� ��
             , WebService_two        TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� �� (2)
             , WebService_three      TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� �� (3)
             , WebService_four       TVarChar  -- ���-������ ����� ������� ���������� ������� � �������� �� (4)
             -- , SyncDateIn         TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ���������� �����������, ����, �����, �����, ������� � �.�
             -- , SyncDateOut        TDateTime -- ����/����� ��������� ������������� - ����� "�������" ����������� �������� ���������� - ������, �������� � �.�
             , MobileVersion         TVarChar  -- ������ ���������� ����������. ������: "1.0.3.625"
             , MobileAPKFileName     TVarChar  -- �������� ".apk" ����� ���������� ����������. ������: "ProjectMobile.apk"
             , PriceListId_def       Integer   -- �����-���� ��� "��������" ��, �.�. ����������� �� ��������� ����������
             , PriceListName_def     TVarChar  -- �����-���� ��� "��������" ��, �.�. ����������� �� ��������� ����������
             , OperDate_diff         Integer   -- �� ������� ���� ����� ��������� ��� ������� � ������ �����, �.�. ��� �������� ���������� ���� ��������� �� ��������� ����� ���� �� ����������� ������ � �������� - ����������
             , ReturnDayCount        Integer   -- ������� ���� ����������� �������� �� ������ �����
             , CriticalOverDays      Integer   -- ���������� ���� ���������|����� �������� ������������ ������ ���������� (default 21)
             , CriticalDebtSum       TFloat    -- ����� �����|����� �������� ������������ ������ ���������� (default 1 ���.)
             , APIKey                TVarChar  -- APIKey ��� ���� ����
             , CriticalWeight        TFloat    -- ���������� ���������� ��� ������
)
AS
$BODY$
  DECLARE vbUserId     Integer;

  DECLARE vbMemberId      Integer;
  DECLARE vbPersonalId    Integer;
  DECLARE vbUnitId        Integer;
  DECLARE vbBranchId      Integer;
  DECLARE vbBranchId_cash Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���� ������������ inSession - ����� - !!!�����!!!
     /*IF COALESCE (inSession, '') = '' OR COALESCE (inSession, '0') = '0'
     THEN
         RETURN;
     END IF;*/


     -- ����� ���������
     SELECT ObjectLink_User_Member.ChildObjectId AS MemberId
          , lfSelect.PersonalId                  AS PersonalId
          , CASE WHEN vbUserId = 5866615 -- ����� �.�.
                      THEN 8411 -- ����� �� �.����

                 WHEN vbUserId = 10105228  -- ����� �.�.
                      THEN 8425 -- ����� �� �.�������

                 ELSE lfSelect.UnitId
            END AS UnitId
          , CASE WHEN vbUserId = 5866615 -- ����� �.�.
                      THEN 8379 -- ������ ����

                 WHEN vbUserId = 10105228  -- ����� �.�.
                      THEN 8381 -- ������ �������

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 8377 -- ������ ��.���
                      THEN zc_Branch_Basis()

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 301310 -- ������ ���������
                      THEN zc_Branch_Basis()

                 ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
            END AS BranchId

          , CASE WHEN vbUserId = 5866615 -- ����� �.�.
                      THEN 8379 -- ������ ����

                 WHEN vbUserId = 10105228  -- ����� �.�.
                      THEN 8381 -- ������ �������

                 WHEN ObjectLink_Unit_Branch.ChildObjectId = 8377 -- ������ ��.���
                      THEN zc_Branch_Basis()

                 ELSE COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
            END AS BranchId_cash


            INTO vbMemberId, vbPersonalId, vbUnitId, vbBranchId, vbBranchId_cash

     FROM ObjectLink AS ObjectLink_User_Member
          LEFT JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                                                    ON lfSelect.MemberId = ObjectLink_User_Member.ChildObjectId
                                                                   AND lfSelect.Ord      = 1
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = lfSelect.UnitId
                              AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
     WHERE ObjectLink_User_Member.ObjectId = CASE WHEN vbUserId = 5 OR vbUserId = 9457 THEN 1059546 -- !!!�������� - ��� �����!!! - �����    -> 1059546  - ���� �.�.
                                                --WHEN vbUserId = 1123966 THEN 81169 -- !!!�������� - ��� �����!!! - test_mob -> 1000168 - �������� �.�.
                                                  ELSE vbUserId
                                             END
       AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
    ;

     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbMemberId, 0) =  0 THEN
        RAISE EXCEPTION '������.� ������������ <%> �� ����������� �������� <��� (���.����)>.', lfGet_Object_ValueData (vbUserId);
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbPersonalId, 0) =  0 THEN
        RAISE EXCEPTION '������.� ������������ <%> �� ����������� �������� <��� (���������)>.', lfGet_Object_ValueData (vbUserId);
     END IF;
     -- �������� - �������� ������ ���� �����������
     IF COALESCE (vbUnitId, 0) =  0 THEN
        RAISE EXCEPTION '������.� ���������� <%> �� ����������� �������� <�������������>.', lfGet_Object_ValueData (vbPersonalId);
     END IF;

     -- ���������
     RETURN QUERY
       WITH tmpPersonal AS (SELECT vbMemberId                AS MemberId
                                 , Object_Member.ValueData   AS MemberName
                                 , vbPersonalId              AS PersonalId
                                 , CASE (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbBranchId)
                                        WHEN 1  THEN 8459    -- ������ zc_Branch_Basis - ����� ����������
                                        WHEN 2  THEN 8411    -- ������ ����      - ����� �� � ����
                                        WHEN 3  THEN 8417    -- ������ �������� (������) - ����� �� �.�������� (������)
                                        WHEN 4  THEN 346093  -- ������ ������    - ����� �� �.������
                                        WHEN 5  THEN 8415    -- ������ �������� (����������) - ����� �� �.�������� (����������)
                                        WHEN 7  THEN 8413    -- ������ ��.���    - ����� �� �.������ ���
                                        WHEN 9  THEN 8425    -- ������ �������   - ����� �� �.�������
                                        WHEN 11 THEN 301309  -- ������ ��������� - ����� �� �.���������
                                        WHEN 12 THEN 3080691 -- ������ �����     - ����� �� �.�����
                                        -- WHEN ??? THEN 8459   -- ������ ???    - ����� ����������
                                        ELSE vbUnitId
                                   END AS UnitId
                                 , CASE (SELECT Object.ObjectCode FROM Object WHERE Object.Id = vbBranchId)
                                        WHEN 1  THEN 8461    -- ������ zc_Branch_Basis - ����� ���������
                                        WHEN 2  THEN 428365  -- ������ ����      - ����� ��������� �.����
                                        WHEN 3  THEN 428364  -- ������ �������� (������) - ����� ��������� �.�������� (������)
                                        WHEN 4  THEN 346094  -- ������ ������    - ����� ��������� �.������
                                        WHEN 5  THEN 428363  -- ������ �������� (����������) - ����� ��������� �.�������� (����������)
                                        WHEN 7  THEN 428366  -- ������ ��.���    - ����� ��������� �.������ ���
                                        WHEN 9  THEN 409007  -- ������ �������   - ����� ��������� �.�������
                                        WHEN 11 THEN 309599  -- ������ ��������� - ����� ��������� �.���������
                                        WHEN 12 THEN 3080696 -- ������ �����     - ����� ��������� �.�����
                                        -- WHEN ??? THEN 8461   -- ������ ???    - ����� ���������
                                        ELSE vbUnitId
                                   END AS UnitId_ret
                            FROM Object AS Object_Member
                            WHERE Object_Member.Id = vbMemberId
                           )
       -- ���������
       SELECT Object_PaidKind_FirstForm.Id           AS PaidKindId_First
            , Object_PaidKind_FirstForm.ValueData    AS PaidKindName_First
            , Object_PaidKind_SecondForm.Id          AS PaidKindId_Second
            , Object_PaidKind_SecondForm.ValueData   AS PaidKindName_Second

            , Object_Status_UnComplete.Id            AS StatusId_UnComplete
            , Object_Status_UnComplete.ValueData     AS StatusName_UnComplete
            , Object_Status_Complete.Id              AS StatusId_Complete
            , Object_Status_Complete.ValueData       AS StatusName_Complete
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

--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_two
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_three
--          , 'http//project-vds.vds.colocall.com/projectmobile/index.php' :: TVarChar AS WebService_four

--            , LOWER ('http//integer-srv.alan.dp.ua/projectmobile/index.php')   :: TVarChar AS WebService
  --          , LOWER ('http//integer-srv2.alan.dp.ua/projectmobile/index.php')    :: TVarChar AS WebService_two
    --        , LOWER ('http//integer-srv-r.alan.dp.ua/projectmobile/index.php') :: TVarChar AS WebService_three
      --      , LOWER ('http//integer-srv2-r.alan.dp.ua/projectmobile/index.php')  :: TVarChar AS WebService_four

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php')    END :: TVarChar AS WebService

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php') 
                                            ELSE LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')   END :: TVarChar AS WebService_two

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv2-r.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv-r.alan.dp.ua/projectmobile/index.php')  END :: TVarChar AS WebService_three

            , CASE WHEN vbUserId = 5 OR 1=1 THEN LOWER ('http://integer-srv-r.alan.dp.ua/projectmobile/index.php')
                                            ELSE LOWER ('http://integer-srv2-r.alan.dp.ua/projectmobile/index.php') END :: TVarChar AS WebService_four

/*
            , LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')    :: TVarChar AS WebService
            , LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php')   :: TVarChar AS WebService_two
            , LOWER ('http://integer-srv2.alan.dp.ua/projectmobile/index.php')  :: TVarChar AS WebService_three
            , LOWER ('http://integer-srv.alan.dp.ua/projectmobile/index.php') :: TVarChar AS WebService_four
*/
            -- AS LastDateIn
            -- AS LastDateOut

            -- , '1.26.0'::TVarChar             AS MobileVersion
             , getMobileConst.MobileVersion
            -- , 'ProjectMobile.apk'::TVarChar  AS MobileAPKFileName
            , getMobileConst.MobileAPKFileName

            , Object_PriceList_def.Id        AS PriceListId_def
            , Object_PriceList_def.ValueData AS PriceListName_def

            -- , 0::Integer  AS OperDate_diff  -- ���� �� ���� ���� ����� ��� ����, ����� ����� ��� ������� ������� �������� ����������
            , getMobileConst.OperDateDiff AS OperDate_diff  -- ���� �� ���� ���� ����� ��� ����, ����� ����� ��� ������� ������� �������� ����������
            -- , 14::Integer AS ReturnDayCount -- ���� 14 ����
            , getMobileConst.ReturnDayCount -- ���� 14 ����
            -- , 21::Integer AS CriticalOverDays
            , getMobileConst.CriticalOverDays
            -- , 1::TFloat   AS CriticalDebtSum
            , getMobileConst.CriticalDebtSum
            , zc_Google_APIKey() AS APIKey

            , 5::TFloat   AS CriticalWeight

       FROM tmpPersonal
            LEFT JOIN gpGet_Object_MobileConst_BySession (inSession:= inSession) AS getMobileConst ON 1 = 1
            LEFT JOIN Object AS Object_PaidKind_FirstForm  ON Object_PaidKind_FirstForm.Id = zc_Enum_PaidKind_FirstForm()
            LEFT JOIN Object AS Object_PaidKind_SecondForm ON Object_PaidKind_SecondForm.Id = zc_Enum_PaidKind_SecondForm()

            LEFT JOIN Object AS Object_Status_UnComplete ON Object_Status_UnComplete.Id = zc_Enum_Status_UnComplete()
            LEFT JOIN Object AS Object_Status_Complete   ON Object_Status_Complete.Id   = zc_Enum_Status_Complete()
            LEFT JOIN Object AS Object_Status_Erased     ON Object_Status_Erased.Id     = zc_Enum_Status_Erased()

            LEFT JOIN Object AS Object_Unit     ON Object_Unit.Id     = tmpPersonal.UnitId -- ����� ����������
            LEFT JOIN Object AS Object_Unit_ret ON Object_Unit_ret.Id = tmpPersonal.UnitId_ret
            LEFT JOIN ObjectLink AS ObjectLink_Cash_Branch
                                 ON ObjectLink_Cash_Branch.ChildObjectId = vbBranchId_cash
                                AND ObjectLink_Cash_Branch.DescId        = zc_ObjectLink_Cash_Branch()
                                AND vbBranchId_cash                      <> zc_Branch_Basis()
            LEFT JOIN Object AS Object_Cash     ON Object_Cash.Id     = CASE WHEN vbBranchId_cash = zc_Branch_Basis() THEN 14462 /*����� �����*/ ELSE ObjectLink_Cash_Branch.ObjectId END

            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId
            LEFT JOIN ObjectString AS ObjectString_User_
                                   ON ObjectString_User_.ObjectId = Object_User.Id
                                  AND ObjectString_User_.DescId = zc_ObjectString_User_Password()

            LEFT JOIN Object AS Object_ConnectParam ON Object_ConnectParam.Id = zc_Enum_GlobalConst_ConnectParam ()

            LEFT JOIN Object AS Object_PriceList_def ON Object_PriceList_def.Id = zc_PriceList_Basis()
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  �������� �.�.   ������ �.�.
 21.03.19                                                                    * APIKey
 04.12.17                                                       * WebService_three, WebService_four
 11.05.17                                                       * OperDate_diff
 17.02.17                                        *
*/
/*
-------- GetCurrentCoordinates :
try (LocManagerObj :=TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE)
FCurCoordinatesMsg:= '������ ��� ��������� � ������� GPS';

if not Assigned(LocManagerObj := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.LOCATION_SERVICE))
FCurCoordinatesMsg:= '�� ������� ������ GPS';

if not Assigned(LocationManager := TJLocationManager.Wrap((LocManagerObj as ILocalObject).GetObjectID))
FCurCoordinatesMsg:= '��� ������� ������� � ��������� GPS'

if   not LocationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER)
 and not locationManager.isProviderEnabled(TJLocationManager.JavaClass.NETWORK_PROVIDER)
 and ...
FCurCoordinatesMsg:= '�� �������� �� ������� ������ ��� ��� ������� � GPS ��� NETWORK �����'


-------- GetAddress:
if not Assigned(geocoder:= TJGeocoder.JavaClass.init(SharedActivityContext))
FCurCoordinatesMsg:= ' ��� ������� � ������ ������ - geocoder ���: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+'';

if not geocoder.getFromLocation(Latitude, Longitude,1).size > 0
FCurCoordinatesMsg:= ' �� ������������ ����� ��� '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''

if not Assigned(TJAddress.Wrap((AddressList.get(0) as ILocalObject).GetObjectID))
FCurCoordinatesMsg:= ' ������ � ������ ��� �������������� ������ ���: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude);

except
FCurCoordinatesMsg:= ' ������ � ������ ��� ����������� ������ ���: '+FloatToStr(Latitude)+', '+FloatToStr(Longitude)+''
*/
-- ����
-- SELECT * FROM ObjectString where DescId = zc_ObjectString_MobileConst_MobileVersion();
-- UPDATE ObjectString SET ValueData = '1.61.0' WHERE DescId = zc_ObjectString_MobileConst_MobileVersion();
-- UPDATE ObjectString SET ValueData = '1.72.0' WHERE DescId = zc_ObjectString_MobileConst_MobileVersion();
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpGetMobile_Object_Const (inSession:= '1000168')
-- D:\Project-Basis\Bin\aMobile.sdb
