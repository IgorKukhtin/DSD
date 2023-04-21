-- Function: gpSelect_MovementOccupancyCheck()

DROP FUNCTION IF EXISTS gpSelect_MovementOccupancyCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementOccupancyCheck(
    IN inMovementID    Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumbr TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountOrder TFloat, AmountChech TFloat, AmountDelta TFloat
             , CommentCheckId Integer, CommentCheckCode Integer, CommentCheckName TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar, isResort Boolean
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Check());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN QUERY
  SELECT MovementItem.MovementId                                                        AS Id
       , Movement.InvNumber
       , Movement.OperDate
       , Object_Unit.ObjectCode                                                         AS UnitCode
       , Object_Unit.ValueData                                                          AS UnitName
       , Object_Juridical.ObjectCode                                                    AS JuridicalCode
       , Object_Juridical.ValueData                                                     AS JuridicalName
       , MovementItem.Id                                                                AS MovementItemId
       , Object_Goods.Id                                                                AS GoodsId
       , Object_Goods.ObjectCode                                                        AS GoodsCode
       , Object_Goods.ValueData                                                         AS GoodsName
       , MIFloat_AmountOrder.ValueData                                                  AS AmountOrder
       , MovementItem.Amount                                                            AS AmountCheck
       , (MIFloat_AmountOrder.ValueData - MovementItem.Amount)::TFloat                  AS AmountDelta
       , Object_CommentCheck.Id                                                         AS CommentCheckId
       , Object_CommentCheck.ObjectCode                                                 AS CommentCheckCode
       , Object_CommentCheck.ValueData                                                  AS CommentCheckName
       , Object_CommentTR.Id                                                            AS CommentTRId
       , Object_CommentTR.ObjectCode                                                    AS CommentTRCode
       , Object_CommentTR.ValueData                                                     AS CommentTRName
       , COALESCE(ObjectBoolean_CommentTR_Resort.ValueData, False)                      AS isResort
  FROM MovementItem
  
       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
       INNER JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                     ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                    AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                    AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki()

       LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                    ON MovementLinkObject_Unit.MovementId = MovementItem.MovementId
                                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                        ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId
       
       LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                   ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                  AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
       

       LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentCheck
                                        ON MILinkObject_CommentCheck.MovementItemId = MovementItem.Id
                                       AND MILinkObject_CommentCheck.DescId = zc_MILinkObject_CommentCheck()
       LEFT JOIN Object AS Object_CommentCheck
                        ON Object_CommentCheck.ID = MILinkObject_CommentCheck.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_CommentCheck_CommentTR
                            ON ObjectLink_CommentCheck_CommentTR.ObjectId = Object_CommentCheck.Id
                           AND ObjectLink_CommentCheck_CommentTR.DescId = zc_ObjectLink_CommentCheck_CommentTR()
       LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentCheck_CommentTR.ChildObjectId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Resort
                               ON ObjectBoolean_CommentTR_Resort.ObjectId = Object_CommentTR.Id 
                              AND ObjectBoolean_CommentTR_Resort.DescId = zc_ObjectBoolean_CommentTR_Resort()
                              
  WHERE MovementItem.MovementId = inMovementID
    AND MovementItem.DescId     = zc_MI_Master()
    AND COALESCE (MIFloat_AmountOrder.ValueData, 0) > 0
    AND MovementItem.Amount     < MIFloat_AmountOrder.ValueData 

  ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementOccupancyCheck (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.04.23                                                       *
*/

-- тест
--
SELECT * FROM gpSelect_MovementOccupancyCheck (inMovementID:= 31771844 , inSession:= '3')