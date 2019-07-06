-- Function: gpUnComplete_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Sale(
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
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Sale());
    vbUserId := inSession::Integer;

     -- ��������� ������ ����������� � ������� ������    
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
    THEN
      IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
      THEN
        RAISE EXCEPTION '������������� ��� ���������, ���������� � ���������� ��������������';
      END IF;
    END IF;

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT
        Movement_Sale.OperDate,
        Movement_Sale.UnitId
    INTO
        vbOperDate,
        vbUnitId
    FROM 
        Movement_Sale_View AS Movement_Sale
    WHERE 
        Movement_Sale.Id = inMovementId;

    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnitId
                  Inner Join MovementItem AS MI_Sale
                                          ON MI_Inventory.ObjectId = MI_Sale.ObjectId
                                         AND MI_Sale.DescId = zc_MI_Master()
                                         AND MI_Sale.IsErased = FALSE
                                         AND MI_Sale.Amount > 0
                                         AND MI_Sale.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� �������� �����������. ������ ���������� ��������� ���������!';
    END IF;*/
    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�   ������ �.�.
 02.07.19                                                                                     *
 13.10.15                                                                       *
*/