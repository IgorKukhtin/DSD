-- Function: gpGet_Movement_Reprice()

DROP FUNCTION IF EXISTS gpGet_Movement_Reprice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Reprice(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , ChangePercent TFloat
             , UnitId Integer, UnitName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
             , GUID TVarChar
             )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Reprice());

    RETURN QUERY

    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
      , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
      
      , MovementLinkObject_Unit.ObjectId                      AS UnitId
      , Object_Unit.ValueData                                 AS UnitName

      , Object_UnitForwarding.Id                              AS UnitForwardingId
      , Object_UnitForwarding.ValueData                       AS UnitForwardingName

      , MovementString_GUID.ValueData                         AS GUID

    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                               
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                     ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                    AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
        LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()
   
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_Reprice();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_Reprice (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 01.11.17         *
 21.06.16         *
 27.11.15                                                                        *
*/

-- test
-- select * from gpGet_Movement_Reprice(inMovementId := 3852856 ,  inSession := '3');