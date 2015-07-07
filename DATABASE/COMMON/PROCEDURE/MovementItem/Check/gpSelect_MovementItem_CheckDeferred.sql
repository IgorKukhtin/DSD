DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckDeferred (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckDeferred(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId integer, GoodsId integer, GoodsName TVarChar, Amount TFloat, Price TFloat)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
   vbUnitId := vbUnitKey::Integer;
     RETURN QUERY
   WITH Mov
   AS
   (
      SELECT       
          Movement.Id
        FROM Movement 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                      AND MovementLinkObject_Unit.ObjectId = vbUnitId

          LEFT OUTER JOIN MovementBoolean AS MovementBoolean_Deferred
                                      ON MovementBoolean_Deferred.MovementId = Movement.Id
                                   AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                            
        WHERE Movement.DescId = zc_Movement_Check()
          AND
          Movement.StatusId = zc_Enum_Status_UnComplete()
          AND
          MovementBoolean_Deferred.ValueData = True 
          AND
          (
             MovementLinkObject_Unit.ObjectId = vbUnitId 
             OR 
             vbUnitId = 0
          )
    )
       SELECT
             MovementItem.MovementId 
           , MovementItem.GoodsId
           , MovementItem.GoodsName
           , MovementItem.Amount
           , MovementItem.Price
       FROM Mov
       Inner Join MovementItem_Check_View AS MovementItem 
                                        ON Mov.Id = MovementItem.MovementId  
      WHERE MovementItem.isErased   = false;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А
 03.07.15                                                                       * 
 25.05.15                         *
 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('2')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
