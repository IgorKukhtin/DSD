-- Function: gpSelect_Movement_OrderInternal() - ���� ������� ������ ��� ������, �� ������� ���� �������������, �� ��� �������� "���������� ���"

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
     
     ANALYSE _tmpUnitSMS_List;

     -- ���������
     RETURN QUERY
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
	       , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)   AS Bayer
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)        AS BayerPhone
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName
        FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                          AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete()
             INNER JOIN Movement ON Movement.Id = MovementLinkObject_ConfirmedKindClient.MovementId
                                AND Movement.StatusId = zc_Enum_Status_UnComplete()

             LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                       ON MovementBoolean_Deferred.MovementId = Movement.Id
			                          AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
             LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                       ON MovementBoolean_ConfirmByPhone.MovementId = Movement.Id
                                      AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()

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

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN Object AS Object_ConfirmedKind       ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId -- COALESCE (MovementLinkObject_ConfirmedKindClient.ObjectId, zc_Enum_ConfirmedKind_SmsNo())

             LEFT JOIN _tmpUnitSMS_List ON _tmpUnitSMS_List.UnitId = MovementLinkObject_Unit.ObjectId
        WHERE MovementLinkObject_ConfirmedKindClient.DescId     = zc_MovementLinkObject_ConfirmedKindClient()
          AND MovementLinkObject_ConfirmedKindClient.ObjectId   = zc_Enum_ConfirmedKind_SmsNo()
          AND COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False) = False
          AND (_tmpUnitSMS_List.UnitId > 0 OR vbIndex = 1)
        UNION ALL
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
	       , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)   AS Bayer
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)        AS BayerPhone
           , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
           , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName
        FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                          AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_UnComplete()
             INNER JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                           ON MovementLinkObject_CancelReason.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                          AND MovementLinkObject_CancelReason.DescId     = zc_MovementLinkObject_CancelReason()
             INNER JOIN Object AS Object_CancelReason 
                               ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                              AND Object_CancelReason.ObjectCode IN (2, 3, 4, 5)
             INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                        ON MovementBoolean_MobileApplication.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                       AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                       AND MovementBoolean_MobileApplication.ValueData = True
             INNER JOIN Movement ON Movement.Id = MovementLinkObject_ConfirmedKindClient.MovementId
                                AND Movement.StatusId = zc_Enum_Status_Erased()
                                AND Movement.OperDate >= '03.05.2023'

             LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                       ON MovementBoolean_Deferred.MovementId = Movement.Id
			                          AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()
             LEFT JOIN MovementBoolean AS MovementBoolean_Delay
                                       ON MovementBoolean_Delay.MovementId = Movement.Id
			                          AND MovementBoolean_Delay.DescId     = zc_MovementBoolean_Delay()
             LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                       ON MovementBoolean_ConfirmByPhone.MovementId = Movement.Id
                                      AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()

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

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN Object AS Object_ConfirmedKind       ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId -- COALESCE (MovementLinkObject_ConfirmedKindClient.ObjectId, zc_Enum_ConfirmedKind_SmsNo())

             LEFT JOIN _tmpUnitSMS_List ON _tmpUnitSMS_List.UnitId = MovementLinkObject_Unit.ObjectId
        WHERE MovementLinkObject_ConfirmedKindClient.DescId     = zc_MovementLinkObject_ConfirmedKindClient()
          AND MovementLinkObject_ConfirmedKindClient.ObjectId   = zc_Enum_ConfirmedKind_SmsNo()
          AND COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False) = False
          AND COALESCE(MovementBoolean_Delay.ValueData, False) = False
          AND (_tmpUnitSMS_List.UnitId > 0 OR vbIndex = 1)     
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 21.04.21                                                                                    * add BuyerForSite
 25.08.16                                        *
*/

-- ����
-- 
SELECT * FROM gpSelect_Movement_Check_SMS_Site (inUnitId_list:= (SELECT string_agg(id::Text, ',') FROM gpSelect_Object_Unit_Active (inNotUnitId := 0, inSession := '3')), inSession:= '2')

