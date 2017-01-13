-- Function: gpUnComplete_Movement_Promo (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Promo (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Promo(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Promo());
    vbUserId:= lpGetUserBySession (inSession);


    -- 1. �������� ObjectIntId_analyzer = NULL, ��� zc_MIContainer_Count() + zc_MIContainer_Summ()
    UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      -- AND MovementItem.IsErased = FALSE - �� ������ ������, ����� - �������
      AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
      AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check())
     ;


    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�
 25.04.16         *
*/