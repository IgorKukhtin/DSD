-- Function: gpSelect_Movement_OrderInternal() - ���� ������� ������ ��� ������, �� ������� ���� �������������, �� ��� �������� "���������� ���"

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_SMS_Site (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Check_SMS_Site (TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_SMS_Site(
    -- IN inUnitId_list      TVarChar ,  -- ������ �������������, ����� ���
    IN inUnitId_list      TBlob    ,  -- ������ �������������, ����� ���
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
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusId AS StatusCode
           , zc_Enum_Status_Erased() :: TVarChar AS StatusName
           , 0 :: TFloat AS TotalCount
           , 0 :: TFloat AS TotalSumm
           , 0 :: TFloat AS TotalSummChangePercent
           , MovementLinkObject_Unit.ObjectId           AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean AS IsDeferred
           , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND MovementLinkObject_CheckMember.ObjectId IS NULL THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	   , MovementString_Bayer.ValueData             AS Bayer
           , MovementString_BayerPhone.ValueData        AS BayerPhone
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName
        FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                          AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete()
             INNER JOIN Movement ON Movement.Id = MovementLinkObject_ConfirmedKindClient.MovementId
                                AND Movement.StatusId <> zc_Enum_Status_Erased()

	     LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
			               ON MovementBoolean_Deferred.MovementId = Movement.Id
				      AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                          ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                         AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
	     LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId

	     LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN Object AS Object_ConfirmedKind       ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId -- COALESCE (MovementLinkObject_ConfirmedKindClient.ObjectId, zc_Enum_ConfirmedKind_SmsNo())

             LEFT JOIN _tmpUnitSMS_List ON _tmpUnitSMS_List.UnitId = MovementLinkObject_Unit.ObjectId
        WHERE MovementLinkObject_ConfirmedKindClient.DescId     = zc_MovementLinkObject_ConfirmedKindClient()
          AND MovementLinkObject_ConfirmedKindClient.ObjectId   = zc_Enum_ConfirmedKind_SmsNo()
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
