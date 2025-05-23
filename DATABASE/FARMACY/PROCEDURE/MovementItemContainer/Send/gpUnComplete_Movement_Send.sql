-- Function: gpUnComplete_Movement_Send (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Send(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnit_From Integer;
  DECLARE vbUnit_To   Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbStatusID   Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUserUnitId Integer;
  DECLARE vbisSUN Boolean;
  DECLARE vbisDefSUN Boolean;
  DECLARE vbisNotDisplaySUN Boolean;
  DECLARE vbInsertDate TDateTime;
  DECLARE vbisSendLoss Boolean;
  DECLARE vbisBansSEND Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send());
    vbUserId := inSession::Integer;
    -- �������� - ���� <Master> ������, �� <������>
    PERFORM lfCheck_Movement_ParentStatus (inMovementId:= inMovementId, inNewStatusId:= zc_Enum_Status_UnComplete(), inComment:= '�����������');

     -- ��������� ������ ����������� � ������� ������    
    IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
    THEN
      IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), zc_Enum_Role_UnComplete()))
      THEN
        RAISE EXCEPTION '������������� ��� ���������, ���������� � ���������� ��������������';
      END IF;
    END IF;
    
    SELECT COALESCE(ObjectBoolean_CashSettings_BansSEND.ValueData, FALSE)   AS isBansSEND
    INTO vbisBansSEND
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BansSEND
                                 ON ObjectBoolean_CashSettings_BansSEND.ObjectId = Object_CashSettings.Id 
                                AND ObjectBoolean_CashSettings_BansSEND.DescId = zc_ObjectBoolean_CashSettings_BansSEND()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
    
/*
    IF EXISTS (select 
               -- update Movement set OperDate = '01.01.2020'
               from (SELECT Movement.*
                          , ROW_NUMBER() OVER (PARTITION BY Movement.Id ORDER BY MovementProtocol .OperDate aSC) AS Ord
                          , MovementProtocol .OperDate as OperDate_prot
                     FROM Movement 
                          inner JOIN MovementProtocol on MovementProtocol. MovementId = Movement.Id
                                      inner JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                                ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                                               AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                                                               and MovementBoolean_SUN_v2.ValueData = true
                     where Movement.OperDate = '21.04.2020'
                        AND Movement.DescId = zc_Movement_Send() 
                        AND Movement.StatusId = zc_Enum_Status_Erased()
                        AND Movement.Id = inMovementId
                    ) as tmp
               
               where tmp.Ord = 1
                 and DATE_TRUNC ('day', OperDate_prot) = '21.04.2020'
               order by OperDate_prot
              )
    THEN
        RAISE EXCEPTION '������.�������� �����������.�� ��� �����!';
    END IF;
*/     

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT
        Movement.OperDate,
        Movement.StatusId,
        Movement_From.ObjectId AS Unit_From,
        Movement_To.ObjectId AS Unit_To,
        COALESCE (MovementBoolean_SUN.ValueData, FALSE), 
        COALESCE (MovementBoolean_DefSUN.ValueData, FALSE), 
        COALESCE (MovementBoolean_NotDisplaySUN.ValueData, FALSE),
        DATE_TRUNC ('DAY', MovementDate_Insert.ValueData), 
        COALESCE (MovementBoolean_SendLoss.ValueData, FALSE)
    INTO
        vbOperDate,
        vbStatusID,
        vbUnit_From,
        vbUnit_To,
        vbisSUN,
        vbisDefSUN,
        vbisNotDisplaySUN,
        vbInsertDate,
        vbisSendLoss
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_From
                                      ON Movement_From.MovementId = Movement.Id
                                     AND Movement_From.DescId = zc_MovementLinkObject_From()
        INNER JOIN MovementLinkObject AS Movement_To
                                      ON Movement_To.MovementId = Movement.Id
                                     AND Movement_To.DescId = zc_MovementLinkObject_To()
        LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                  ON MovementBoolean_SUN.MovementId = Movement.Id
                                 AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                  ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                 AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
        LEFT JOIN MovementBoolean AS MovementBoolean_NotDisplaySUN
                                  ON MovementBoolean_NotDisplaySUN.MovementId = Movement.Id
                                 AND MovementBoolean_NotDisplaySUN.DescId = zc_MovementBoolean_NotDisplaySUN()
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementBoolean AS MovementBoolean_SendLoss
                                  ON MovementBoolean_SendLoss.MovementId = Movement.Id
                                 AND MovementBoolean_SendLoss.DescId = zc_MovementBoolean_SendLoss()
    WHERE Movement.Id = inMovementId;
    
    IF vbOperDate >= '01.01.2024' AND COALESCE(vbUnit_To, 0) <> 11299914 AND COALESCE (vbisBansSEND, FALSE) = TRUE AND 
       NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN 
      RAISE EXCEPTION '������. �������� ������ ����������� � 1.01.2024 ��������� ������ ��������������..';             
    END IF;    

    IF vbisSendLoss = TRUE AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN 
      RAISE EXCEPTION '������. ������������ ����������� � ��������� <� ������ ��������> ���������. ������� ������� <� ������ ��������>';     
    END IF;     

    IF vbisSUN = TRUE AND vbOperDate < CURRENT_DATE 
       AND  NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN 
      RAISE EXCEPTION '������. ������ � ������������� ������������� ��� ���������!.';     
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

      IF COALESCE (vbUnit_From, 0) <> COALESCE (vbUserUnitId, 0) AND COALESCE (vbUnit_To, 0) <> COALESCE (vbUserUnitId, 0) 
      THEN 
        RAISE EXCEPTION '������. ��� ��������� �������� ������ � �������������� <%>.', (SELECT ValueData FROM Object WHERE ID = vbUserUnitId);     
      END IF;     
      
      IF vbStatusID = zc_Enum_Status_Erased() AND vbisNotDisplaySUN = TRUE
      THEN 
        RAISE EXCEPTION '������. �������� ������ �� �� �������� � ������������ ��� � ��������� �� ���������� ��� ����� ���������.';     
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
    END IF;     

    /*IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId in (vbUnit_From,vbUnit_To)
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
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

    -- �������� � ��
    IF vbisSUN = TRUE 
    THEN
       PERFORM  gpSelect_MovementSUN_TechnicalRediscount(inMovementId, True, inSession);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�  ������ �.�.
 02.07.19                                                                                   *
 19.12.18                                                                                   *  
 30.07.15                                                                       *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_Send (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())