-- Function: gpUnComplete_Movement_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_TechnicalRediscount(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbInventoryID Integer;
  DECLARE vbStatusID Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TechnicalRediscount());

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
                                 
    -- 5.1 �������� ��������������
    IF EXISTS(SELECT *
              FROM Movement
              WHERE Movement.DescId = zc_Movement_Inventory()
                AND Movement.ParentId = inMovementId)
    THEN
        SELECT Movement.ID
             , Movement.StatusId
        INTO vbInventoryID
           , vbStatusID
        FROM Movement
        WHERE Movement.DescId = zc_Movement_Inventory()
          AND Movement.ParentId = inMovementId;

        IF vbStatusID = zc_Enum_Status_Complete()
        THEN
          PERFORM gpUnComplete_Movement_Inventory (vbInventoryID, inSession);
        END IF;

        IF vbStatusID <> zc_Enum_Status_Erased()
        THEN
          PERFORM gpSetErased_Movement_Inventory (vbInventoryID, inSession);
        END IF;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/