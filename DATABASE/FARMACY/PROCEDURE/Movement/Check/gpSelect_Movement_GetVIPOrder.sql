-- Function: gpSelect_Movement_GetVIPOrder()

DROP FUNCTION IF EXISTS gpSelect_Movement_GetVIPOrder (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_GetVIPOrder (
    IN inVIPOrder         TVarChar ,
   OUT outVIPOrder        TVarChar,    -- 
   OUT outisMoreThanOne   Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)

RETURNS Record 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   
   DECLARE vbCount Integer;

   DECLARE vbText TBlob;
BEGIN
-- if inSession = '3' then return; end if;


   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   outisMoreThanOne := False;
   
   IF EXISTS(SELECT *
             FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                               ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                              AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                  LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                           ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                          AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             WHERE Movement.InvNumberOrder = inVIPOrder
               AND COALESCE(MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_Complete())
   THEN
   
     SELECT Movement.InvNumberOrder
     INTO outVIPOrder
     FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                       ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                      AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
          LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                   ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                  AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
     WHERE Movement.InvNumberOrder = inVIPOrder
       AND COALESCE(MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_Complete();   
   
     RETURN;
   END IF;
    
   SELECT count(*)::INTEGER
   INTO vbCount
   FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
   WHERE Movement.InvNumberOrder::TVarChar ILIKE '%'||inVIPOrder
     AND COALESCE(MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_Complete();   
   
   IF vbCount = 0
   THEN
     RAISE EXCEPTION 'По введеному номеру <%> подтвержденных заказов не найдено.', inVIPOrder;
   ELSEIF vbCount = 1
   THEN
   
     SELECT Movement.InvNumberOrder
     INTO outVIPOrder
     FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                       ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                      AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
     WHERE Movement.InvNumberOrder::TVarChar ILIKE '%'||inVIPOrder
       AND COALESCE(MovementLinkObject_ConfirmedKind.ObjectId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_Complete();   

   ELSE
   
      outisMoreThanOne := True;
   END IF;
         
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_GetVIPOrder (TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.11.21                                                       *

*/

--тест
--
 SELECT * FROM gpSelect_Movement_GetVIPOrder ('40', '3');