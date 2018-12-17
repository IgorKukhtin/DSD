-- Function: gpReComplete_Movement_Inventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Inventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Inventory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= inSession; -- lpCheckRight (inSession, zc_Enum_Process_Complete_Inventory());

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = 308121) -- ��� ���� "������ ������"
    THEN
     
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;
       vbUserUnitId := vbUnitKey::Integer;

       SELECT MLO_Unit.ObjectId
       INTO vbUnitId
       FROM  Movement
             INNER JOIN MovementLinkObject AS MLO_Unit
                                           ON MLO_Unit.MovementId = Movement.Id
                                          AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
       WHERE Movement.Id = inMovementId;

       IF COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0)
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
        PERFORM gpUpdate_Status_Inventory(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                          inSession    := inSession);
        --�������� ��������
        PERFORM gpUpdate_Status_Inventory(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_Complete(),
                                          inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.   ������ �.�.
17.12.18                                                                                       *
18.09.15                                                                         *
*/