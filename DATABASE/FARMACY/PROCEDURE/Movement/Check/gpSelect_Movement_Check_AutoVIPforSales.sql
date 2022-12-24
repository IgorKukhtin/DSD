-- Function: gpSelect_Movement_Check_AutoVIPforSales()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_AutoVIPforSales (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_AutoVIPforSales(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpUnit'))
    THEN
      DROP TABLE tmpUnit;
    END IF;
    
    CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
    SELECT 13711869  AS UnitId;
    
    ANALYSE tmpUnit;
    
    IF EXISTS(SELECT MovementBoolean_AutoVIPforSales.MovementId 
              FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
              
                   INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                                      AND Movement.DescId = zc_Movement_Check()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                      AND Movement.OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE)

                   
              WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales())
    THEN
      PERFORM gpSetErased_Movement_Check (MovementBoolean_AutoVIPforSales.MovementId, inSession) 
      FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
              
           INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                              AND Movement.DescId = zc_Movement_Check()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND Movement.OperDate < DATE_TRUNC ('MONTH', CURRENT_DATE)

                   
      WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales();    
    END IF;
     
    IF EXISTS(WITH tmpMovement AS (
                  SELECT MovementBoolean_AutoVIPforSales.MovementId
                       , MovementLinkObject_Unit.ObjectId                    AS UnitId  
                  FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
                      
                       INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                                          AND Movement.DescId = zc_Movement_Check()
                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                          AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE)

                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                               
                  WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales())
                      
              SELECT tmpUnit.UnitId   
              FROM tmpUnit
              
                   LEFT JOIN tmpMovement ON tmpMovement.UnitId = tmpUnit.UnitId
              
              WHERE COALESCE (tmpMovement.UnitId, 0) = 0)
    THEN

      PERFORM gpInsertUpdate_Movement_Check_AutoVIPforSales(ioId       := 0
                                                          , inUnitId   := T1.UnitId
                                                          , inDate     := DATE_TRUNC ('MONTH', CURRENT_DATE)
                                                          , inComment  := 'ВИП чек для резерва под продажи'
                                                          , inSession  := inSession)
      FROM (WITH tmpMovement AS (
                  SELECT MovementBoolean_AutoVIPforSales.MovementId
                       , MovementLinkObject_Unit.ObjectId                    AS UnitId  
                  FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
                      
                       INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                                          AND Movement.DescId = zc_Movement_Check()
                                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                          AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE)

                       INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                                                               
                  WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales())
                      
            SELECT tmpUnit.UnitId   
            FROM tmpUnit
                
                 LEFT JOIN tmpMovement ON tmpMovement.UnitId = tmpUnit.UnitId
                
            WHERE COALESCE (tmpMovement.UnitId, 0) = 0) AS T1;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.12.21                                                       *
*/

-- тест
-- 
select * from gpSelect_Movement_Check_AutoVIPforSales(inSession := '3')