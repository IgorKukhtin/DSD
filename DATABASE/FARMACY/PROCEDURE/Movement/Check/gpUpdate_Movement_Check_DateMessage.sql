-- Function: gpUpdate_Movement_Check_DateMessage()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateMessage(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateMessage(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCheckSourceKindId   Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE(inCheckSourceKindId, 0) <> zc_Enum_CheckSourceKind_Tabletki()
  THEN
    RETURN 0;
  END IF;

  -- raise notice 'Value 05: % % %', inMovementId, inCheckSourceKindId, inSession;
  
  IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) OR
    NOT EXISTS(SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy()) 
  THEN
    RETURN 0;
  END IF;

  IF EXISTS(SELECT * FROM MovementBoolean 
            WHERE MovementBoolean.DescId = zc_MovementBoolean_AccruedFine()
              AND MovementBoolean.MovementId = inMovementId)
  THEN
    RETURN 0;
  END IF;
  
  IF date_part('isodow', CURRENT_DATE)::Integer = 7
  THEN
    SELECT CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SundayStart.ValueData ELSE Null END ::TDateTime AS SundayStart
         , CASE WHEN COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SundayEnd.ValueData - INTERVAL '31 MINUTE' ELSE Null END ::TDateTime AS SundayEnd
    INTO vbStartDate, vbEndDate 
    FROM MovementLinkObject 
    
         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject.ObjectId
    
         LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                              ON ObjectDate_SundayStart.ObjectId = Object_Unit.Id
                             AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
         LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                              ON ObjectDate_SundayEnd.ObjectId = Object_Unit.Id
                             AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()
 
    WHERE MovementLinkObject.MovementId = inMovementId;
  ELSEIF date_part('isodow', CURRENT_DATE)::Integer = 6
  THEN
    SELECT CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SaturdayStart.ValueData ELSE Null END ::TDateTime AS SaturdayStart
         , CASE WHEN COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_SaturdayEnd.ValueData - INTERVAL '31 MINUTE' ELSE Null END ::TDateTime AS SaturdayEnd
    INTO vbStartDate, vbEndDate 
    FROM MovementLinkObject 
    
         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject.ObjectId
    
         LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                              ON ObjectDate_SaturdayStart.ObjectId = Object_Unit.Id
                             AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
         LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                              ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit.Id
                             AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
 
    WHERE MovementLinkObject.MovementId = inMovementId;  
  ELSE
    SELECT CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_MondayStart.ValueData ELSE Null END ::TDateTime AS MondayStart
         , CASE WHEN COALESCE(ObjectDate_MondayEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_MondayEnd.ValueData - INTERVAL '31 MINUTE' ELSE Null END ::TDateTime AS MondayEnd
    INTO vbStartDate, vbEndDate 
    FROM MovementLinkObject 
    
         INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject.ObjectId
    
         LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                              ON ObjectDate_MondayStart.ObjectId = Object_Unit.Id
                             AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
         LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                              ON ObjectDate_MondayEnd.ObjectId = Object_Unit.Id
                             AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
 
    WHERE MovementLinkObject.MovementId = inMovementId;  
  END IF;  

  --raise notice 'Value 05: % % %', vbStartDate, vbEndDate, inSession;

  IF vbStartDate IS NULL OR vbEndDate IS NULL OR vbStartDate::Time > CURRENT_TIMESTAMP::Time OR vbEndDate::Time < CURRENT_TIMESTAMP::Time
  THEN
    RETURN 0;
  END IF;
   
  IF NOT EXISTS(SELECT * FROM MovementDate 
                WHERE MovementDate.DescId = zc_MovementDate_Message()
                  AND MovementDate.MovementId = inMovementId)
  THEN
    --������ ������� ���� ����� ���������
    PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Message(), inMovementId, CURRENT_TIMESTAMP);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
    
  ELSEIF (SELECT MovementDate.ValueData FROM MovementDate 
          WHERE MovementDate.DescId = zc_MovementDate_Message()
            AND MovementDate.MovementId = inMovementId) < CURRENT_TIMESTAMP - INTERVAL '31 MINUTE'
  THEN 
    --������ ������� ��������� �����
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_AccruedFine(), inMovementId, TRUE);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);  
  END IF;

  -- !!!�������� ��� �����!!!
  IF inSession = zfCalc_UserAdmin()
  THEN
      RAISE EXCEPTION '���� ������ ������� ��� % % %', inMovementId, inCheckSourceKindId, inSession;
  END IF;
              
  RETURN 1;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 15.04.21                                                                    *
*/

-- ���� SELECT * FROM gpUpdate_Movement_Check_DateMessage(inMovementId := 28578239 , inCheckSourceKindId := zc_Enum_CheckSourceKind_Tabletki(), inSession := '3');