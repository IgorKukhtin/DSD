-- Function: gpGet_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpGet_MovementItem_EmployeeSchedule_User (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_EmployeeSchedule_User(
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (OperDate  TDateTime,
               StartHour TVarChar,
               StartMin TVarChar,
               EndHour TVarChar, 
               EndMin TVarChar 
              )
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;

   DECLARE vbStartHour TVarChar;
   DECLARE vbStartMin TVarChar; 
   DECLARE vbEndHour TVarChar;
   DECLARE vbEndMin TVarChar; 
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    
   vbStartHour := '';
   vbStartMin := '00'; 
   vbEndHour := '';
   vbEndMin := '00'; 

    -- �������� ������� �������
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
    
      SELECT Movement.ID 
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();
    
        -- ������� ������ �� ����������
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN

        SELECT MovementItem.ID
        INTO vbMovementItemID
        FROM MovementItem
        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId;

          -- ������� ������ �� ���
        IF EXISTS(SELECT 1 FROM MovementItem
                  WHERE MovementItem.MovementId = vbMovementID
                    AND MovementItem.DescId = zc_MI_Child()
                    AND MovementItem.ParentId = vbMovementItemID
                    AND MovementItem.Amount = date_part('DAY',  CURRENT_DATE)::Integer)
        THEN
          SELECT CASE WHEN MIDate_Start.ValueData IS NULL THEN '' ELSE date_part('HOUR',  MIDate_Start.ValueData)::TVarChar END
               , CASE WHEN MIDate_Start.ValueData IS NULL THEN '' ELSE date_part('minute',  MIDate_Start.ValueData)::TVarChar  END
               , CASE WHEN MIDate_End.ValueData IS NULL THEN '' ELSE date_part('HOUR',  MIDate_End.ValueData)::TVarChar  END
               , CASE WHEN MIDate_End.ValueData IS NULL THEN '' ELSE date_part('minute',  MIDate_End.ValueData)::TVarChar  END
          INTO vbStartHour, vbStartMin, vbEndHour, vbEndMin 
          FROM MovementItem

               INNER JOIN MovementItemDate AS MIDate_Start
                                           ON MIDate_Start.MovementItemId = MovementItem.Id
                                          AND MIDate_Start.DescId = zc_MIDate_Start()

               INNER JOIN MovementItemDate AS MIDate_End
                                           ON MIDate_End.MovementItemId = MovementItem.Id
                                          AND MIDate_End.DescId = zc_MIDate_End()

          WHERE MovementItem.MovementId = vbMovementID
            AND MovementItem.DescId = zc_MI_Child()
            AND MovementItem.ParentId = vbMovementItemID
            AND MovementItem.Amount = date_part('DAY',  CURRENT_DATE)::Integer;        
          
        END IF;	
      END IF;	
    END IF;

    IF Length(vbStartMin) < 2
    THEN
      vbStartMin := '0'||vbStartMin; 
    END IF; 
    
    IF Length(vbEndMin) < 2
    THEN
      vbEndMin := '0'||vbEndMin; 
    END IF; 

    RETURN QUERY
    SELECT CURRENT_DATE::TDateTime                        AS OperDate
         , vbStartHour 
         , vbStartMin 
         , vbEndHour 
         , vbEndMin 
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.02.19                                                       *
*/

-- ����
-- select * from gpGet_MovementItem_EmployeeSchedule_User(inSession := '3');
