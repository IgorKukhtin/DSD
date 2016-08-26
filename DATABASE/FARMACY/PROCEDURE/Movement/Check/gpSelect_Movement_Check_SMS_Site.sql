-- Function: gpSelect_Movement_OrderInternal() - ���� ������� ������ ��� ������, �� ������� ���� �������������, �� ��� �������� "���������� ���"

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_SMS_Site (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_SMS_Site(
    IN inUnitId_list      TVarChar ,  -- ������ �������������, ����� ���
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer -- ���� ���������
             , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat  -- ����� ���-��
             , TotalSumm TFloat   -- ����� �����
             , TotalSummChangePercent TFloat
             , UnitId Integer    -- ���� ������
             , UnitName TVarChar -- �������� ������
             , IsDeferred Boolean
             , CashMember TVarChar -- ��� ���������
             , Bayer TVarChar      -- ��� ����������
             , BayerPhone TVarChar -- ��� ����������
             , InvNumberOrder TVarChar  -- � ������ �� �����
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIndex Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������
     CREATE TEMP TABLE _tmpUnitSMS_List (UnitId Integer) ON COMMIT DROP;

     -- ������ �������������
     vbIndex := 1;
     WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
         -- ��������� �� ��� �����
         INSERT INTO _tmpUnitSMS_List (UnitId) SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer;
         -- ������ ����������
         vbIndex := vbIndex + 1;
     END LOOP;

     -- ���������
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )

         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.TotalSummChangePercent
           , Movement_Check.UnitId
           , Movement_Check.UnitName
           , Movement_Check.IsDeferred
           , CASE WHEN Movement_Check.InvNumberOrder <> '' AND COALESCE (Movement_Check.CashMember, '') = '' THEN zc_Member_Site() ELSE Movement_Check.CashMember END :: TVarChar AS CashMember
           , Movement_Check.Bayer
           , Movement_Check.BayerPhone
           , Movement_Check.InvNumberOrder
           , Movement_Check.ConfirmedKindName
           , Movement_Check.ConfirmedKindClientName
        FROM Movement_Check_View AS Movement_Check
             JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
             LEFT JOIN _tmpUnitSMS_List ON _tmpUnitSMS_List.UnitId = Movement_Check.UnitId
                           
       WHERE Movement_Check.ConfirmedKindId        = zc_Enum_ConfirmedKind_Complete()
         AND Movement_Check.ConfirmedKindId_Client = zc_Enum_ConfirmedKind_SmsNo()
         AND (_tmpUnitSMS_List.UnitId > 0 OR vbIndex = 1)
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 25.08.16                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Check_SMS_Site (inUnitId_list:= '', inSession:= '2')
