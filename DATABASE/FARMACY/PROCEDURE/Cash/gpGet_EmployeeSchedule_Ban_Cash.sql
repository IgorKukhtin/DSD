-- Function: gpGet_EmployeeSchedule_Ban_Cash(TVarChar)

DROP FUNCTION IF EXISTS gpGet_EmployeeSchedule_Ban_Cash(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_EmployeeSchedule_Ban_Cash(
   OUT outBanCash    BOOLEAN, 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS BOOLEAN
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbMovementID Integer;
   DECLARE vbNotSchedule Boolean;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());
                     
    SELECT COALESCE (ObjectBoolean_NotSchedule.ValueData, False)
    INTO vbNotSchedule
    FROM Object AS Object_User
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                ON ObjectLink_User_Member.ObjectId = Object_User.Id
               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN ObjectBoolean AS ObjectBoolean_NotSchedule
                                 ON ObjectBoolean_NotSchedule.ObjectId = ObjectLink_User_Member.ChildObjectId
                                AND ObjectBoolean_NotSchedule.DescId = zc_ObjectBoolean_Member_NotSchedule()
    WHERE Object_User.Id = vbUserId;
       
    IF  EXISTS(SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
       OR vbRetailId <> 4 
       OR vbNotSchedule = True
    THEN
      outBanCash := False;
      RETURN;
    ELSE
      outBanCash := True;
    END IF;

     -- Отметка посещаемости
    IF EXISTS(SELECT 1 FROM Movement
              WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
              AND Movement.DescId = zc_Movement_EmployeeSchedule())
    THEN

      SELECT Movement.ID
      INTO vbMovementID
      FROM Movement
      WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
        AND Movement.DescId = zc_Movement_EmployeeSchedule();

      IF EXISTS(SELECT *
                FROM ObjectBoolean AS ObjectBoolean_WorkingMultiple
                WHERE ObjectBoolean_WorkingMultiple.ObjectId = vbUserId
                  AND ObjectBoolean_WorkingMultiple.DescId = zc_ObjectBoolean_User_WorkingMultiple()
                  AND ObjectBoolean_WorkingMultiple.ValueData = TRUE)
         AND vbUnitId <> 0
      THEN
        IF EXISTS(SELECT 1 
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = vbMovementID
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer

                       LEFT JOIN MovementItemDate AS MIDate_Start
                                                   ON MIDate_Start.MovementItemId = MIChild.Id
                                                  AND MIDate_Start.DescId = zc_MIDate_Start()

                       LEFT JOIN MovementItemDate AS MIDate_End
                                                  ON MIDate_End.MovementItemId = MIChild.Id
                                                 AND MIDate_End.DescId = zc_MIDate_End()

                       LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                     ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                    AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

                  WHERE MIMaster.MovementId = vbMovementID
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId
                    AND COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE)
           OR
           EXISTS(SELECT 1 
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = MIMaster.MovementId
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1
                                              AND MIChild.ObjectId = vbUnitId 

                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                                                  AND MIDate_End.ValueData > date_trunc('day', CURRENT_DATE)


                  WHERE MIMaster.MovementId = (SELECT Movement.ID
                                               FROM Movement
                                               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - interval '1 day')
                                                 AND Movement.DescId = zc_Movement_EmployeeSchedule() )
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId)                  
        THEN
          outBanCash := False;
        END IF;
        
      ELSE
        IF EXISTS(SELECT 1 
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = vbMovementID
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer

                       LEFT JOIN MovementItemDate AS MIDate_Start
                                                   ON MIDate_Start.MovementItemId = MIChild.Id
                                                  AND MIDate_Start.DescId = zc_MIDate_Start()

                       LEFT JOIN MovementItemDate AS MIDate_End
                                                  ON MIDate_End.MovementItemId = MIChild.Id
                                                 AND MIDate_End.DescId = zc_MIDate_End()

                       LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                     ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                    AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()

                  WHERE MIMaster.MovementId = vbMovementID
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId
                    AND (COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE
                     OR MIBoolean_ServiceExit.ValueData IS NOT NULL AND MIDate_End.ValueData IS NOT NULL))
           OR
           EXISTS(SELECT 1 
                  FROM MovementItem AS MIMaster
                       INNER JOIN MovementItem AS MIChild
                                               ON MIChild.MovementId = MIMaster.MovementId
                                              AND MIChild.DescId = zc_MI_Child()
                                              AND MIChild.ParentId = MIMaster.ID
                                              AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1

                       INNER JOIN MovementItemDate AS MIDate_End
                                                   ON MIDate_End.MovementItemId = MIChild.Id
                                                  AND MIDate_End.DescId = zc_MIDate_End()
                                                  AND MIDate_End.ValueData > date_trunc('day', CURRENT_DATE)


                  WHERE MIMaster.MovementId = (SELECT Movement.ID
                                               FROM Movement
                                               WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - interval '1 day')
                                                 AND Movement.DescId = zc_Movement_EmployeeSchedule() )
                    AND MIMaster.DescId = zc_MI_Master()
                    AND MIMaster.ObjectId = vbUserId)                  
        THEN
          outBanCash := False;
        END IF;
      END IF;
    ELSE 
      outBanCash := False;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.09.19                                                       *
 06.09.19                                                       *
*/

-- тест
-- SELECT * FROM gpGet_EmployeeSchedule_Ban_Cash('12104119')