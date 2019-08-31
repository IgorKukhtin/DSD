-- Function: gpGet_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpGet_MovementItem_EmployeeSchedule_User (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_EmployeeSchedule_User(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (OperDate  TDateTime,
               ValueUser TVarChar,
               TimeStart TVarChar,
               TimeEnd TVarChar 
              )
AS
$BODY$
   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
   DECLARE vbUserId Integer;
   DECLARE vbComingValueDay TVarChar;
   DECLARE vbTypeId Integer;
   DECLARE vbValue Integer;
   DECLARE vbResult TVarChar;
   DECLARE vbTimeStart TVarChar;
   DECLARE vbTimeEnd TVarChar; 
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    
    vbResult := '';
    vbTimeStart := '';
    vbTimeEnd := '';

    -- проверка наличия графика
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN
    
      SELECT Movement.ID 
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();
    
        -- Наличие записи по сотруднику
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementId = vbMovementID
                  AND MovementItem.DescId = zc_MI_Master()
                  AND MovementItem.ObjectId = vbUserId)
      THEN

        SELECT MovementItem.ID, COALESCE (MovementItemString.ValueData, '')
        INTO vbMovementItemID, vbComingValueDay
        FROM MovementItem
         
             LEFT JOIN MovementItemString ON MovementItemString.DescId = zc_MIString_ComingValueDayUser()
                                          AND MovementItemString.MovementItemId = MovementItem.ID
          
        WHERE MovementItem.MovementId = vbMovementID
          AND MovementItem.DescId = zc_MI_Master()
          AND MovementItem.ObjectId = vbUserId;

        IF COALESCE (vbComingValueDay, '') = ''
        THEN
          vbComingValueDay := '0000000000000000000000000000000';
        END IF;
    
        vbTypeId :=  date_part('day',  CURRENT_DATE);
    
        vbResult :=lpDecodeValueDay(vbTypeId, vbComingValueDay);

          -- Наличие записи по дню
        IF EXISTS(SELECT 1 FROM MovementItem
                  WHERE MovementItem.MovementId = vbMovementID
                    AND MovementItem.DescId = zc_MI_Child()
                    AND MovementItem.ParentId = vbMovementItemID
                    AND MovementItem.Amount = date_part('DAY',  CURRENT_DATE)::Integer)
        THEN
          SELECT CASE WHEN MIDate_Start.ValueData IS NULL THEN '' ELSE TO_CHAR(MIDate_Start.ValueData, 'HH24:MI')  END
               , CASE WHEN MIDate_End.ValueData IS NULL THEN '' ELSE TO_CHAR(MIDate_End.ValueData , 'HH24:MI')  END
          INTO vbTimeStart
             , vbTimeEnd
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


    RETURN QUERY
    SELECT CURRENT_DATE::TDateTime                        AS OperDate
         , vbResult                                       AS ValueUser
         , vbTimeStart                                    AS TimeStart
         , vbTimeEnd                                      AS TimeEnd
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_MovementItem_EmployeeSchedule_User (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.19                                                       *
*/

-- тест
-- select * from gpGet_MovementItem_EmployeeSchedule_User(inSession := '3');
