-- Function: gpSelect_Movement_Check_UpdateOrdersSite()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_UpdateOrdersSite (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_UpdateOrdersSite(
    IN inStartDate        TDateTime  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , InvNumberOrder TVarChar
             , UnitId Integer
             , UnitName TVarChar
             , isMobileApplication boolean
             , DateComing TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    SELECT Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , MovementString_InvNumberOrder.ValueData   AS InvNumberOrder 
         , Object_Unit.Id                            AS UnitId
         , Object_Unit.ValueData                     AS UnitName
         , COALESCE(MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
         , MovementDate_Coming.ValueData                                AS DateComing
    FROM MovementDate AS DateUserConfirmedKind
    
         INNER JOIN Movement ON Movement.Id = DateUserConfirmedKind.MovementId
         
         INNER JOIN MovementString AS MovementString_InvNumberOrder
                                   ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                  AND COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
                                  
         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                  
         LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                   ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                  AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

         LEFT JOIN MovementDate AS MovementDate_Coming
                                ON MovementDate_Coming.MovementId = Movement.Id
                               AND MovementDate_Coming.DescId = zc_MovementDate_Coming()
    
    WHERE DateUserConfirmedKind.DescId = zc_MovementDate_UserConfirmedKind()
      AND DateUserConfirmedKind.ValueData >= inStartDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpSelect_Movement_Check_UpdateOrdersSite (inStartDate:= CURRENT_DATE, inSession:= '3')