-- Function: gpSetErased_Movement_PromoCode (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_PromoCode (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_PromoCode(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Promo());
    vbUserId:= lpGetUserBySession (inSession);

/*
    -- 1. �������� ObjectIntId_analyzer = NULL, ��� zc_MIContainer_Count() + zc_MIContainer_Summ()
    UPDATE MovementItemContainer SET ObjectIntId_analyzer = NULL
    FROM MovementItem
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId     = zc_MI_Master()
      -- AND MovementItem.IsErased = FALSE - �� ������ ������, ����� - �������
      AND MovementItemContainer.ObjectIntId_analyzer = MovementItem.Id
      AND MovementItemContainer.MovementDescId IN (zc_Movement_Income(), zc_Movement_Check())
     ;
     */


    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 14.12.17         *
*/
