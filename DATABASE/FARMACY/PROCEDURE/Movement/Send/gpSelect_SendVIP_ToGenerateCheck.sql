-- Function: gpSelect_SendVIP_ToGenerateCheck()

DROP FUNCTION IF EXISTS gpSelect_SendVIP_ToGenerateCheck (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_SendVIP_ToGenerateCheck(
    IN inUnitID        Integer    , -- Подразделение
    IN inStartDate     TDateTime  , --
    IN inEndDate       TDateTime  , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , FromId Integer, FromName TVarChar
             , MovamantItemId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Price TFloat, Summa TFloat
               )

AS
$BODY$
  DECLARE vbDateViewed TDateTime;
BEGIN

  RETURN QUERY
  WITH tmpMovementID AS (SELECT Movement.id
                         FROM Movement
                              INNER JOIN MovementBoolean AS MovementBoolean_VIP
                                                         ON MovementBoolean_VIP.MovementId = Movement.Id
                                                        AND MovementBoolean_VIP.DescId = zc_MovementBoolean_VIP()

                              INNER JOIN MovementBoolean AS MovementBoolean_Confirmed
                                                         ON MovementBoolean_Confirmed.MovementId = Movement.Id
                                                        AND MovementBoolean_Confirmed.DescId = zc_MovementBoolean_Confirmed()
                         WHERE Movement.DescId = zc_Movement_Send()
                           AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           AND COALESCE (MovementBoolean_VIP.ValueData, FALSE) = TRUE
                           AND COALESCE (MovementBoolean_Confirmed.ValueData, FALSE) = TRUE
                        )


     , tmpMovement AS (SELECT Movement.id
                       FROM tmpMovementID AS Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND MovementLinkObject_To.ObjectId = inUnitId
                       )
     , tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                   AND ObjectFloat_Goods_Price.ValueData > 0
                                  THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                  ELSE ROUND (Price_Value.ValueData, 2)
                             END :: TFloat                           AS Price
                           , Price_Goods.ChildObjectId               AS GoodsId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                         LEFT JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         LEFT JOIN ObjectFloat AS Price_Value
                                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                         -- Фикс цена для всей Сети
                         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                               AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                 ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                      WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                      )
     , tmpMovementItem AS (SELECT
                                   Movement.Id                                     AS Id
                                 , Movement.InvNumber                              AS InvNumber
                                 , Movement.OperDate                               AS OperDate

                                 , MovementItem.Id                                 AS MovamantItemId
                                 , MovementItem.ObjectId                           AS GoodsId
                                 , MovementItem.Amount                             AS Amount

                                 , COALESCE (MIFloat_MovementItemId.ValueData, 0)  AS MI_Check

                            FROM tmpMovement

                                 INNER JOIN Movement ON Movement.ID = tmpMovement.ID

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE

                                 LEFT OUTER JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                                   ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()
                            WHERE COALESCE (MIFloat_MovementItemId.ValueData, 0) = 0
                            )


  SELECT
         Movement.Id                            AS Id
       , Movement.InvNumber                     AS InvNumber
       , Movement.OperDate                      AS OperDate
       , Object_From.Id                         AS FromId
       , Object_From.ValueData                  AS FromName

       , Movement.MovamantItemId                AS MovamantItemId
       , Movement.GoodsId                       AS GoodsId
       , Object_Goods.ObjectCode                AS GoodsCode
       , Object_Goods.ValueData                 AS GoodsName
       , Movement.Amount                        AS Amount

       , COALESCE(tmpObject_Price.Price,0)::TFloat                     AS Price
       , COALESCE(tmpObject_Price.Price * Movement.Amount, 0)::TFloat  AS Summa


  FROM tmpMovementItem AS Movement

       INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId


       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId

       LEFT OUTER JOIN tmpObject_Price ON tmpObject_Price.GoodsId = Movement.GoodsId

  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 28.05.20         *
*/

-- SELECT * FROM gpSelect_SendVIP_ToGenerateCheck(inUnitID := 183292 , inStartDate:= '28.05.2020', inEndDate:= '28.05.2020', inSession:= '3');
