-- Function: gpReport_TelegramBot_CheckRed()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_CheckRed (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_CheckRed(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMessage Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);

    SELECT string_agg('№ '||Movement.InvNumber||' от '|| zfConvert_DateShortToString(Movement.OperDate)||' - '||Object_Unit.ValueData, chr(13))
    INTO vbMessage
    FROM Movement

         LEFT JOIN MovementString AS MovementString_CommentError
                                  ON MovementString_CommentError.MovementId = Movement.Id
                                 AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
         LEFT JOIN MovementString AS MovementString_InvNumberSP
                                  ON MovementString_InvNumberSP.MovementId = Movement.Id
                                 AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP() 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId  
                                                                         
         LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                      ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                     AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
         LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                   ON MovementBoolean_Deferred.MovementId = Movement.Id
                                  AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
   		                      
         LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                      ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                     AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
         LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId
                   
    WHERE Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY'
      AND Movement.OperDate < CURRENT_TIMESTAMP - INTERVAL '5 MIN'
      AND Movement.DescId = zc_Movement_Check()
      AND COALESCE (Object_CashRegister.ValueData, '') <> ''
      AND Movement.StatusId = zc_Enum_Status_UnComplete();
    
    IF COALESCE (vbMessage, '') <> ''
    THEN
      RETURN QUERY
      SELECT 'Красные чеки:'||chr(13)||chr(13)||vbMessage;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 06.04.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpReport_TelegramBot_CheckRed(inSession := '3');