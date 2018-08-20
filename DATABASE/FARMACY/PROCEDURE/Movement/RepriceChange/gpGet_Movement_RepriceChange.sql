-- Function: gpGet_Movement_RepriceChange()

DROP FUNCTION IF EXISTS gpGet_Movement_RepriceChange (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_RepriceChange(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , TotalSumm TFloat
             , ChangePercent TFloat
             , RetailId Integer, RetailName TVarChar
             , RetailForwardingId Integer, RetailForwardingName TVarChar
             , GUID TVarChar
             )
AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_RepriceChange());

    RETURN QUERY

    SELECT       
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , COALESCE(MovementFloat_TotalSumm.ValueData,0)    ::TFloat AS TotalSumm
      , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS ChangePercent
      
      , MovementLinkObject_Retail.ObjectId                        AS RetailId
      , Object_Retail.ValueData                                   AS RetailName

      , Object_RetailForwarding.Id                                AS RetailForwardingId
      , Object_RetailForwarding.ValueData                         AS RetailForwardingName

      , MovementString_GUID.ValueData                             AS GUID

    FROM Movement 
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
                               
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_RetailForwarding
                                     ON MovementLinkObject_RetailForwarding.MovementId = Movement.Id
                                    AND MovementLinkObject_RetailForwarding.DescId = zc_MovementLinkObject_RetailForwarding()
        LEFT JOIN Object AS Object_RetailForwarding ON Object_RetailForwarding.Id = MovementLinkObject_RetailForwarding.ObjectId

        LEFT OUTER JOIN MovementString AS MovementString_GUID
                                       ON MovementString_GUID.MovementId = Movement.Id
                                      AND MovementString_GUID.DescId = zc_MovementString_Comment()
   
    WHERE Movement.Id = inMovementId
      AND Movement.DescId = zc_Movement_RepriceChange();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         *
*/

-- test
-- select * from gpGet_Movement_RepriceChange(inMovementId := 3852856 ,  inSession := '3');