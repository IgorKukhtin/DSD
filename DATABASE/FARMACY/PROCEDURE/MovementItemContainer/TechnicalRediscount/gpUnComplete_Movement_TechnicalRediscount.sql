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
  DECLARE vbUnitId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE vbisRedCheck Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_TechnicalRediscount());

    -- ���������� ���� � ������������� � ...
    SELECT DATE_TRUNC ('DAY', Movement.OperDate)                AS OperDate    
         , MLO_Unit.ObjectId                                    AS UnitId
         , COALESCE (MovementBoolean_RedCheck.ValueData, False) AS isRedCheck
    INTO vbOperDate
       , vbUnitId
       , vbisRedCheck
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                   ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                  AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
    WHERE Movement.Id = inMovementId;

    -- ����������� ��������
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId    := vbUserId);
                                 
    -- ����������� � ��������
    IF vbisRedCheck = FALSE
    THEN
      PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, zfCalc_UserAdmin());
    END IF;

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