-- Function: gpReComplete_Movement_Send(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Send(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbFromId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Send());

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
    THEN
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
        vbUnitKey := '0';
      END IF;
      vbUserUnitId := vbUnitKey::Integer;
        
      IF COALESCE (vbUserUnitId, 0) = 0
      THEN 
        RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
      END IF;     

      --���������� ������������� ����������
      SELECT MovementLinkObject_To.ObjectId AS UnitId
             INTO vbUnitId
      FROM MovementLinkObject AS MovementLinkObject_To
      WHERE MovementLinkObject_To.MovementId = inMovementId
        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To();

      --���������� ������������� �����������
      SELECT MovementLinkObject_From.ObjectId AS vbFromId
             INTO vbFromId
      FROM MovementLinkObject AS MovementLinkObject_From
      WHERE MovementLinkObject_From.MovementId = inMovementId
        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From();
       
      IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
      THEN 
        RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     
    END IF;     

    -- ������ ���� �������� ��������
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE
                    Id = inMovementId
                    AND
                    StatusId = zc_Enum_Status_Complete()
             )
    THEN
        --����������� ��������
        PERFORM gpUpdate_Status_Send(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                     inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_Send(inMovementId := inMovementId,
                                     inStatusCode := zc_Enum_StatusCode_Complete(),
                                     inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.  ������ �.�.
 19.12.18                                                                      *  
 18.09.15                                                         *
*/
