-- Function: gpGet_MovementItem_EmployeeScheduleVIP_User()

DROP FUNCTION IF EXISTS gpGet_MovementItem_EmployeeScheduleVIP_User (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_EmployeeScheduleVIP_User(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime,
               StartHour TVarChar,
               StartMin TVarChar,
               EndHour TVarChar, 
               EndMin TVarChar, 
               GridColumns TVarChar  
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

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    
   vbStartHour := '8';
   vbStartMin := '00'; 
   vbEndHour := '21';
   vbEndMin := '00'; 
   
   IF vbUserId = 3
   THEN
     vbUserId := 390046;
   END IF;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_VIPManager())
   THEN
      RAISE EXCEPTION 'По вам не предусмотрено заполнение графика.';   
   END IF;

    -- проверка наличия графика
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeScheduleVIP())
    THEN
    
      SELECT Movement.ID 
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeScheduleVIP();
            
        -- Наличие записи по сотруднику
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

          -- Наличие записи по дню
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

               LEFT JOIN MovementItemDate AS MIDate_Start
                                          ON MIDate_Start.MovementItemId = MovementItem.Id
                                         AND MIDate_Start.DescId = zc_MIDate_Start()

               LEFT JOIN MovementItemDate AS MIDate_End
                                          ON MIDate_End.MovementItemId = MovementItem.Id
                                         AND MIDate_End.DescId = zc_MIDate_End()

               LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                             ON MIBoolean_ServiceExit.MovementItemId = MovementItem.Id
                                            AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

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
         , vbStartHour::TVarChar
         , vbStartMin::TVarChar
         , vbEndHour::TVarChar
         , vbEndMin::TVarChar
         , ('cxGridDBBandedTableView1Value'||(date_part('DAY',  CURRENT_DATE) + 22)::TVarChar)::TVarChar
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_EmployeeScheduleVIP_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.09.19                                                       *
 23.02.19                                                       *
*/

-- тест
-- select * from gpGet_MovementItem_EmployeeScheduleVIP_User(inSession := '3');

-- 
select * from gpGet_MovementItem_EmployeeScheduleVIP_User(inSession := '390046');