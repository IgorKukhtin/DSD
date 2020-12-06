-- Function: gpSelect_Cash_DistributionPromo()

--DROP FUNCTION IF EXISTS gpSelect_Cash_DistributionPromo (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Cash_DistributionPromo (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_DistributionPromo (
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer 
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , Amount        Integer
             , SummRepay     TFloat
             , Message       TBlob
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbObjectId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   -- сеть пользователя
   vbObjectId := COALESCE (lpGet_DefaultValue('zc_Object_Retail', vbUserId), '0');

   RETURN QUERY
   SELECT Movement.Id                                                    AS ID
        , MovementDate_StartPromo.ValueData                              AS StartPromo
        , MovementDate_EndPromo.ValueData                                AS EndPromo
        , COALESCE(MovementFloat_Amount.ValueData,0)::Integer            AS Amount
        , MovementFloat_SummRepay.ValueData                              AS SummRepay
        , MovementBlob_Message.ValueData                                 AS Message
   FROM Movement

        INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                      ON MovementLinkObject_Retail.MovementId = Movement.Id
                                     AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                     AND MovementLinkObject_Retail.ObjectId = vbObjectId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()
        LEFT JOIN MovementFloat AS MovementFloat_SummRepay
                                ON MovementFloat_SummRepay.MovementId =  Movement.Id
                               AND MovementFloat_SummRepay.DescId = zc_MovementFloat_SummRepay()

        LEFT JOIN MovementDate AS MovementDate_StartPromo
                               ON MovementDate_StartPromo.MovementId = Movement.Id
                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                               ON MovementDate_EndPromo.MovementId = Movement.Id
                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementBlob AS MovementBlob_Message
                               ON MovementBlob_Message.MovementId = Movement.Id
                              AND MovementBlob_Message.DescId = zc_MovementBlob_Message()

        LEFT JOIN MovementItem AS MI_DistributionPromo
                               ON MI_DistributionPromo.MovementId = Movement.Id
                              AND MI_DistributionPromo.DescId = zc_MI_Child()
                              AND MI_DistributionPromo.isErased = FALSE
                              AND MI_DistributionPromo.Amount = 1
                              AND MI_DistributionPromo.ObjectId = vbUnitId
                                                              
   WHERE Movement.DescId = zc_Movement_DistributionPromo()
     AND Movement.StatusId = zc_Enum_Status_Complete()
     AND MovementDate_StartPromo.ValueData <= CURRENT_DATE + INTERVAL '1 DAY'
     AND MovementDate_EndPromo.ValueData >= CURRENT_DATE - INTERVAL '1 DAY'
     AND (COALESCE(MI_DistributionPromo.ObjectId, 0) = vbUnitId OR 
          NOT EXISTS(SELECT 1 FROM MovementItem
                     WHERE MovementItem.MovementId = Movement.Id
                       AND MovementItem.DescId = zc_MI_Child()
                       AND MovementItem.Amount = 1
                       AND MovementItem.isErased = FALSE))
       
   ORDER BY Movement.Id
   ;


END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.12.20                                                       *
*/

-- тест
--
 SELECT * FROM gpSelect_Cash_DistributionPromo('3')
