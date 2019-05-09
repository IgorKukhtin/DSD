-- Function: gpComplete_Movement_Inventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_Inventory  (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Inventory(
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
  vbUserId:= inSession;
  
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
   
      IF (COALESCE ((SELECT COUNT(*) FROM MovementItem WHERE MovementItem.MovementId = inMovementId
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased  = FALSE), 0) > 3 OR 
          COALESCE ((SELECT COUNT(*) FROM Movement 

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                                AND Movement.DescId = zc_Movement_Inventory()
                                AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                AND Movement.StatusId = zc_Enum_Status_Complete()), 0) >= 1) AND
        EXISTS(SELECT 1
                FROM Movement

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                     INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                                   ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                                  AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

                WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
                  AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                  AND Movement.DescId = zc_Movement_Check()
                  AND MovementLinkObject_Unit.ObjectId = vbUnitId
                  AND Movement.StatusId = zc_Enum_Status_Complete()) AND
         (SELECT MAX(Movement.OperDate)
          FROM Movement

               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

               INNER JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                             ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                            AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()

          WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE)
            AND Movement.OperDate < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
            AND Movement.DescId = zc_Movement_Check()
            AND MovementLinkObject_Unit.ObjectId = vbUnitId
            AND Movement.StatusId = zc_Enum_Status_Complete()) > 
          COALESCE ((SELECT MAX(EmployeeWorkLog.DateZReport)
                     FROM EmployeeWorkLog
                     WHERE EmployeeWorkLog.DateLogIn >= DATE_TRUNC ('DAY', CURRENT_DATE)
                       AND EmployeeWorkLog.DateLogIn < DATE_TRUNC ('DAY', CURRENT_DATE) + INTERVAL '1 DAY'
                       AND EmployeeWorkLog.UnitId = vbUnitId
                       AND EmployeeWorkLog.DateZReport IS NOT NULL),DATE_TRUNC ('DAY', CURRENT_DATE)) 
      THEN 
        RAISE EXCEPTION '������. ����� �� ������� ���������� �������� � ��������������� ���������.';     
      END IF;             
   END IF;     
  

  -- ����������� �������� �����
  -- PERFORM lpInsertUpdate_MovementFloat_TotalSummInventory (inMovementId);

  -- ���������� ��������
  PERFORM lpComplete_Movement_Inventory(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          

  -- ���������� ��������
  UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
  WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.   ������ �.�.
 17.12.18                                                                        *
 11.07.15                                                         *
 */

-- ����
-- SELECT * FROM gpComplete_Movement_Inventory (inMovementId:= 29207, inSession:= '2')
