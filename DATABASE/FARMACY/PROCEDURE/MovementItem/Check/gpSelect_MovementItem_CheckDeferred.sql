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
     
   WITH 
  tmpStatus AS (SELECT zc_Enum_Status_UnComplete() AS StatusId)   
                        
, tmpMov AS
      ( SELECT Movement.Id
        FROM tmpStatus
          LEFT JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                            AND Movement.DescId = zc_Movement_Check()
                            
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)

          INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                     ON MovementBoolean_Deferred.MovementId = Movement.Id
                                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                    AND MovementBoolean_Deferred.ValueData = True 
       
       )

       SELECT
             MovementItem.MovementId          AS MovementId 
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount
           , MIFloat_Price.ValueData  AS Price
       FROM tmpMov
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpMov.Id
                                 AND MovementItem.isErased   = false
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
      ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred (TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А
 08.04.16         *
 03.07.15                                                                       * 
 25.05.15                         *
 
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('2')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
