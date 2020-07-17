-- Function: gpComplete_Movement_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpComplete_Movement_ComputerAccessoriesRegister  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ComputerAccessoriesRegister(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;
           
    -- ��������
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. ��� ������ ��� ����������.';
    END IF;

         
    -- ������� ��������
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_ComputerAccessoriesRegister()
                               , inUserId     := vbUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.07.20                                                       *
 */

-- ����
-- select * from gpUpdate_Status_ComputerAccessoriesRegister(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

