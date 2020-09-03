-- Function: gpGet_Movement_TechnicalRediscount_Cash_Id()

DROP FUNCTION IF EXISTS gpGet_Movement_TechnicalRediscount_Cash_Id (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TechnicalRediscount_Cash_Id(
   OUT outMovementId       Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   outMovementId := 0;
   
   IF vbUnitId = 0
   THEN
     RETURN;
   END IF;

   IF EXISTS(SELECT Movement.Id
             FROM Movement 
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             WHERE Movement.DescId = zc_Movement_TechnicalRediscount()   
               AND Movement.StatusId = zc_Enum_Status_UnComplete()
               AND MovementLinkObject_Unit.ObjectId = vbUnitId)
   THEN
      SELECT Max(Movement.Id) AS Id
      INTO outMovementId
      FROM Movement 
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
           LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                     ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                    AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
           LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                     ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                    AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()
           LEFT JOIN MovementBoolean AS MovementBoolean_CorrectionSUN
                                     ON MovementBoolean_CorrectionSUN.MovementId = Movement.Id
                                    AND MovementBoolean_CorrectionSUN.DescId = zc_MovementBoolean_CorrectionSUN()
      WHERE Movement.DescId = zc_Movement_TechnicalRediscount()   
        AND Movement.StatusId = zc_Enum_Status_UnComplete()
        AND MovementLinkObject_Unit.ObjectId = vbUnitId
        AND COALESCE (MovementBoolean_RedCheck.ValueData, False) = FALSE
        AND COALESCE (MovementBoolean_Adjustment.ValueData, False) = FALSE
        AND COALESCE (MovementBoolean_CorrectionSUN.ValueData, False) = FALSE;  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.02.20                                                       *
 */

-- тест
-- SELECT * FROM gpGet_Movement_TechnicalRediscount_Cash_Id (inSession:= '3')
