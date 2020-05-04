-- Function: gpSetErased_Movement_Send_Filter()

DROP FUNCTION IF EXISTS gpSetErased_Movement_Send_Filter  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Send_Filter(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar                -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId        Integer;
  DECLARE vbStatusId      Integer;
  DECLARE vbisDeferred    Boolean;
BEGIN
    vbUserId:= inSession;

    IF vbUserId <> 298786
       AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN 
      RAISE EXCEPTION '������. ������� ��� �������� ��� �������� ��� ���������!.';     
    END IF;     

    -- ��������� ���������
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
    INTO
        vbStatusId,
        vbisDeferred
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement.Id = inMovementId;
    
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
      RETURN;
    END IF;

    IF vbisDeferred = TRUE
    THEN
      PERFORM gpUpdate_Movement_Send_Deferred (inMovementId, False, inSession);
    END IF;
    
    PERFORM gpSetErased_Movement_Send (inMovementId, inSession);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.  ������ �.�.
 30.04.20                                                                        *  
 

-- ����
-- SELECT * FROM gpSetErased_Movement_Send_Filter (inMovementId:= 29207, inSession:= '3')
*/