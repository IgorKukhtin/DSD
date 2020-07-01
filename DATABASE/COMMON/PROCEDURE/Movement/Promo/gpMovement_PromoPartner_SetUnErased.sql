-- Function: gpMovement_PromoPartner_SetUnErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovement_PromoPartner_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovement_PromoPartner_SetUnErased(
    IN inMovementId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased       Boolean              , -- ����� ��������
    IN inSession         TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_PromoGoods());
    vbUserId := lpGetUserBySession (inSession);


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId)
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- ������������� ����� ��������
    outIsErased := FALSE;

    -- ����������� ������
    UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Id = inMovementId
    RETURNING ParentId INTO vbMovementId;

    -- �������� - ��������� ��������� �������� ������
    -- PERFORM lfCheck_Movement_Parent (inMovementId:= vbMovementId, inComment:= '���������');

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = vbMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovement_PromoPartner_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.  ��������� �.�.
 05.11.15                                                                      *
*/