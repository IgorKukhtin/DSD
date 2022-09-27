DROP FUNCTION IF EXISTS gpSetErased_Movement_CheckSite (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_CheckSite(
    IN inMovementId        Integer  ,   -- ���� ���������
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbStatusId Integer;
  
  
  DECLARE vbCashRegisterId Integer;
  DECLARE vbInvNumberOrder TVarChar;
  DECLARE vbConfirmedKindId Integer;
BEGIN
    --���� �������� ��� �������� �� �������� �����
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    SELECT 
      Movement.StatusId,
      COALESCE(MovementString_InvNumberOrder.ValueData, ''),
      COALESCE(MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete())
    INTO
      vbStatusId,
      vbInvNumberOrder,
      vbConfirmedKindId
    FROM Movement 
         LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                  ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
         LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                      ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                     AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
    WHERE Id = inMovementId;          

    IF vbInvNumberOrder = ''
    THEN
      RAISE EXCEPTION '������. ������� ��������� ������ ��������� ����������� � �����.';     
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
        RAISE EXCEPTION '������. �������� ����������� ���������� ���������.';     
      ELSE
        Return;
      END IF;
    END IF;
    
    IF vbConfirmedKindId <> zc_Enum_ConfirmedKind_UnComplete()
    THEN
      RAISE EXCEPTION '������. �������� �������������� ���������� ���������.';     
    END IF;

    -- ���� ���� ������������� �� ������� �������
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False)
    THEN
      PERFORM lpSetErased_MovementItem(MovementItem.Id, vbUserId)
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False;
    END IF;

    -- ��������� ���������� ������������� ���������� ��������� �����
    IF COALESCE((SELECT MovementFloat.ValueData
                 FROM MovementFloat
                 WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
                   AND MovementFloat.MovementId = inMovementId), 0) <> 0
    THEN
      PERFORM gpUpdate_LoyaltySaveMoney_SummaDiscount (MovementFloat_LoyaltySMID.ValueData::INTEGER, -1.0 * MovementFloat.ValueData, inSession)
      FROM MovementFloat
           INNER JOIN MovementFloat AS MovementFloat_LoyaltySMID
                                    ON MovementFloat_LoyaltySMID.DescID = zc_MovementFloat_LoyaltySMID()
                                   AND MovementFloat_LoyaltySMID. MovementId = inMovementId
      WHERE MovementFloat.DescID = zc_MovementFloat_LoyaltySMDiscount()
        AND MovementFloat.MovementId = inMovementId;
    END IF;

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 27.09.22                                                      *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_CheckSite (inMovementId:=  29473932  , inSession:= zfCalc_UserSite())