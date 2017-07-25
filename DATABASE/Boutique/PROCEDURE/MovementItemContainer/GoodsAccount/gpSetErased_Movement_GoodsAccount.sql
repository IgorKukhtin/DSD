-- Function: gpSetErased_Movement_GoodsAccount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_GoodsAccount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_GoodsAccount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_GoodsAccount());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���.������ ���������
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);
    
    -- ������� ������ �� ���� ��� � ��������
    /*PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Child(), MLM_Child.MovementId, Null)
    FROM MovementLinkMovement AS MLM_Child
    WHERE MLM_Child.descId = zc_MovementLinkMovement_Child()
      AND MLM_Child.MovementChildId = inMovementId;*/
    
    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- ����������� "��������" ����� �� ��������� ������ ������� / ��������
    PERFORM lpUpdate_MI_Partion_Total_byMovement(inMovementId);

    -- ���� ��� ������ �������� ����� ����������� ��������� ����� �� ����������
    IF vbStatusId = zc_Enum_Status_Complete() 
    THEN 
         -- ��������� ��������� ����� �� ����������
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.
 23.07.17         *
 18.05.17         *
*/
