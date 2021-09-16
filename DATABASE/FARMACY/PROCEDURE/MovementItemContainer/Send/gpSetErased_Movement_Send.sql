	-- Function: gpSetErased_Movement_Send (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_Send(
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
  DECLARE vbisDefSUN Boolean;
  DECLARE vbIsSUN Boolean;
  DECLARE vbIsVIP Boolean;
  DECLARE vbisSendLoss Boolean;
  DECLARE vbInsertDate TDateTime;
  DECLARE vbInsertUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_Send());
     vbUserId := inSession::Integer; 
     
    -- ��������� ���������
    SELECT
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To,
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE),
        COALESCE (MovementBoolean_SUN.ValueData, FALSE),
        DATE_TRUNC ('DAY', MovementDate_Insert.ValueData),
        COALESCE (MovementBoolean_VIP.ValueData, FALSE), 
        COALESCE (MovementBoolean_SendLoss.ValueData, FALSE),
        COALESCE (MLO_Insert.ObjectId, 0)
    INTO
        vbFromId,
        vbUnitId,
        vbisDefSUN,
        vbIsSUN,
        vbInsertDate,
        vbIsVIP,
        vbisSendLoss,
        vbInsertUserId
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementBoolean AS MovementBoolean_VIP
                                  ON MovementBoolean_VIP.MovementId = Movement.Id
                                 AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()
        LEFT JOIN MovementBoolean AS MovementBoolean_SendLoss
                                  ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                 AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()
        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
    WHERE Movement.Id = inMovementId;     
    
    IF vbisSendLoss = TRUE
    THEN 
      RAISE EXCEPTION '������. ������������ ����������� � ��������� <� ������ ��������> ���������. ������� ������� <� ������ ��������>';     
    END IF;     

    IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
              WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- ��� ���� "������ ������"
    THEN
      vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
      IF vbUnitKey = '' THEN
        vbUnitKey := '0';
      END IF;
      vbUserUnitId := vbUnitKey::Integer;
        
      IF vbisDefSUN = TRUE
      THEN
        RAISE EXCEPTION '������. �������, �� �� ������ ������������� ������ �����������! ��������� ������ �� ����������� �� ���.';
      END IF;

      IF COALESCE (vbUserUnitId, 0) = 0
      THEN 
        RAISE EXCEPTION '������. �� ������� ������������� ����������.';     
      END IF;     
       
      IF COALESCE (vbFromId, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnitId, 0) <> COALESCE (vbUserUnitId, 0) 
      THEN 
        RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     

      IF vbIsSUN = TRUE AND EXISTS(SELECT 1
                                   FROM Object AS Object_CashSettings
                                        LEFT JOIN ObjectDate AS ObjectDate_CashSettings_DateBanSUN
                                                             ON ObjectDate_CashSettings_DateBanSUN.ObjectId = Object_CashSettings.Id 
                                                            AND ObjectDate_CashSettings_DateBanSUN.DescId = zc_ObjectDate_CashSettings_DateBanSUN()
                                   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                                     AND ObjectDate_CashSettings_DateBanSUN.ValueData = vbInsertDate)
      THEN
        RAISE EXCEPTION '������. ������ ��� ���� ����������, �������� ��������� IT.';
      END IF;                                
      
      IF COALESCE((SELECT MovementFloat_TotalCount.ValueData
                   FROM MovementFloat AS MovementFloat_TotalCount
                   WHERE MovementFloat_TotalCount.MovementId = inMovementId
                     AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()), 0) <> 0
         AND NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                        WHERE Object_RoleUser.ID = vbInsertUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy()) -- ���� ������ �� "������ ������"
      THEN
        RAISE EXCEPTION '������. �������� ����������� ��� ���������.';     
      END IF;                                
    END IF;     
    
    IF vbIsVIP = TRUE AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin()))
                      AND vbUserId <> 235009 
    THEN
      RAISE EXCEPTION '������. �������� VIP ����������� ��� ���������.';         
    END IF;

    -- ��������
    IF EXISTS (SELECT MIC.Id FROM MovementItemContainer AS MIC WHERE MIC.Movementid = inMovementId)
    THEN
         RAISE EXCEPTION '������.�������� �������, �������� ���������!';
    END IF;
     
    -- �������� - ���� <Master> ��������, �� <������>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    -- �������� - ���� ���� <Child> ��������, �� <������>
    PERFORM lfCheck_Movement_ChildStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_Erased(), inComment:= '�������');

    -- ������� ��������
    PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                , inUserId     := vbUserId);

    -- �������� � ��
    IF vbisSUN = TRUE 
    THEN
       PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ��������� �.�.  ������ �.�.
 19.12.18                                                                                     *  
 30.07.15                                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_Movement_Send (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())