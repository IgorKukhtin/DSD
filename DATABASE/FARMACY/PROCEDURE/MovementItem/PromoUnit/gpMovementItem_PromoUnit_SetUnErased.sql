-- Function: gpMovementItem_PromoUnit_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_PromoUnit_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_PromoUnit_SetUnErased(
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
    --vbUserId := lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_PromoUnit());
    vbUserId := inSession;
    -- ������������� ����� ��������
    outIsErased := FALSE;

    -- ����������� ������
    UPDATE MovementItem SET isErased = FALSE WHERE Id = inMovementItemId
    RETURNING MovementId INTO vbMovementId;

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PromoUnit_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.
 04.02.17         *
*/