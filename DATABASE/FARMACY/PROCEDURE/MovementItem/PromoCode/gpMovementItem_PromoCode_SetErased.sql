-- Function: gpMovementItem_PromoCode_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PromoCode_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PromoCode_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Promo());
    vbUserId := inSession;
    -- ������������� ����� ��������
    outIsErased := TRUE;

    -- ����������� ������
    UPDATE MovementItem SET isErased = TRUE WHERE Id = inMovementItemId
    RETURNING MovementId INTO vbMovementId;

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete() AND NOT EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- !!! �� ������� - ������ ���� ���������� ��������!!!
    -- outIsErased := FALSE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.
 13.12.17         *
*/