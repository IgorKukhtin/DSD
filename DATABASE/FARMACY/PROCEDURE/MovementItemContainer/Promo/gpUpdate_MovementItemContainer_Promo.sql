-- Function: gpUpdate_MovementItemContainer_Promo (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItemContainer_Promo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItemContainer_Promo (
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbStatusID   Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Promo());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- ������ ������� ������ �����
    PERFORM  zfCheckRunProc ('gpUpdate_MovementItemContainer_Promo', 1);

    SELECT StatusId
    INTO vbStatusID
    FROM Movement
    WHERE Movement.Id = inMovementId;

    IF vbStatusId = zc_Enum_Status_Complete()
    THEN

      -- 1. �������� ObjectIntId_analyzer = NULL, ��� zc_MIContainer_Count() + zc_MIContainer_Summ() �� ��������� ��������
      UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.IsErased = TRUE
        AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
        AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check());

      -- 2. ����������� ��������� ObjectIntId_analyzer
      PERFORM  lpReComplete_Movement_Promo_All(inMovementId, vbUserId);

    ELSE

      -- 1. �������� ObjectIntId_analyzer = NULL, ��� zc_MIContainer_Count() + zc_MIContainer_Summ()
      UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
        AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check());
     END IF;

    -- ��������� <������ ���� ��������� ObjectIntId_analyzer>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Promo_Prescribe(), inMovementId, FALSE);

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 04.09.19        *
 16.10.18        *
*/