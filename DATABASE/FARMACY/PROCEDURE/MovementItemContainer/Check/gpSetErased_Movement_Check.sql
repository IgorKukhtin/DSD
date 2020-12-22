DROP FUNCTION IF EXISTS gpSetErased_Movement_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Check(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    --���� �������� ��� �������� �� �������� �����
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

/*    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- ��� ���� "������ ������"
    THEN
      RAISE EXCEPTION '������. �������� ����� ��� ���������.';     
    END IF;     
*/
    IF EXISTS(SELECT 1
              FROM Movement
              WHERE
                  ID = inMovementId
                  AND
                  StatusId = zc_Enum_Status_Complete())
    THEN
        IF inSession = zfCalc_UserSite()
        THEN
          RETURN;
        END IF;
        vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Income());
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.   ������ �.�.
 13.05.19                                                                                     *
 05.07.15                                                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())