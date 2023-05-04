DROP FUNCTION IF EXISTS gpSetErased_Movement_CheckVIP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CheckVIP(
    IN inMovementId        Integer               , -- ���� ���������
    IN inCancelReasonId    Integer               , -- ������� ������ ��� �����
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbCheckSourceKind Integer;
  DECLARE vbInvNumberOrder  TVarChar;
BEGIN
    --���� �������� ��� �������� �� �������� �����
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    vbCheckSourceKind := (SELECT MovementLinkObject.ObjectId  FROM MovementLinkObject
                          WHERE MovementLinkObject.DescId = zc_MovementLinkObject_CheckSourceKind()
                            AND MovementLinkObject.MovementID = inMovementId);
                            
    vbInvNumberOrder := COALESCE((SELECT MovementString_InvNumberOrder.ValueData 
                                  FROM MovementString AS MovementString_InvNumberOrder
                                  WHERE MovementString_InvNumberOrder.MovementId = inMovementId
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()), '');

    IF COALESCE (vbCheckSourceKind, 0) = zc_Enum_CheckSourceKind_Tabletki() OR vbInvNumberOrder <> ''
    THEN
       IF COALESCE (inCancelReasonId, 0) = 0
       THEN
        RAISE EXCEPTION '������. ��� �������� VIP ���� ������������ � <%> ���� ������� ������� ������. ��� �������� ����������� �������� ������.  ',
          COALESCE((SELECT Object.ValueData FROM Object WHERE Object.ID = vbCheckSourceKind), '�� �����');
       END IF;
       PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CancelReason(), inMovementId, inCancelReasonId);
    ELSE
       IF COALESCE (inCancelReasonId, 0) <> 0
       THEN
        RAISE EXCEPTION '������. ��� �������� VIP ����� �� ���� ������� ������� ������. ��� �������� ����������� �������� ������.';
       END IF;
    END IF;
   
    -- ������� ��������
    PERFORM gpSetErased_Movement_Check (inMovementId := inMovementId
                                      , inSession     := inSession);
                       
    -- �������� � �� ��� ��������               
    IF EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_CheckSourceKind
              WHERE MovementLinkObject_CheckSourceKind.MovementId =  inMovementId
                AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki())
    THEN
      PERFORM gpSelect_MovementCheck_TechnicalRediscount (inMovementId, inSession);
    END IF;

    -- ������� ������� �������� ��� ��� ����������        
    IF EXISTS(SELECT * FROM MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
              INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                         ON MovementBoolean_MobileApplication.MovementId = MovementLinkObject_ConfirmedKindClient.MovementId
                                        AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                        AND MovementBoolean_MobileApplication.ValueData = True
              WHERE MovementLinkObject_ConfirmedKindClient.MovementId =  inMovementId
                AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
                AND MovementLinkObject_ConfirmedKindClient.ObjectId = zc_Enum_ConfirmedKind_SmsYes())
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), inMovementId, zc_Enum_ConfirmedKind_SmsNo());
    END IF;
                                      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_CheckVIP (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())