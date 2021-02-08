-- Function: gpSelect_MovementOccupancySUN()

DROP FUNCTION IF EXISTS gpSelect_MovementOccupancySUN (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementOccupancySUN(
    IN inMovementID    Integer   , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumbr TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , MovementItemId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , AmountFormed TFloat, AmountSend TFloat, AmountDelta TFloat
             , CommentSendId Integer, CommentSendCode Integer, CommentSendName TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar, isResort Boolean
              )

AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);

  -- Результат
  RETURN QUERY
  WITH tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM MovementItemProtocol
                             WHERE MovementItemProtocol.MovementItemId IN (SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
                                   AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                   AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                             UNION ALL
                             SELECT MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM movementitemprotocol_arc AS MovementItemProtocol
                             WHERE MovementItemProtocol.MovementItemId  IN (SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.MovementId = inMovementID)
                                   AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                   AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                            )
      , tmpProtocolAll AS (SELECT Movement.ID
                               , Movement.InvNumber
                               , Movement.OperDate
                               , MovementItemProtocol.MovementItemId
                               , MovementItemProtocol.ProtocolData
                               , MovementItem.Amount
                               , MovementItem.ObjectId
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM Movement

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id

                               INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                               INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                           AND Object_Goods_Main.isInvisibleSUN = False

                               INNER JOIN tmpProtocolUnion AS MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id

                          WHERE Movement.ID = inMovementID
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.Id
                            , tmpProtocolAll.InvNumber
                            , tmpProtocolAll.OperDate
                            , tmpProtocolAll.MovementItemId
                            , tmpProtocolAll.ObjectId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                            , tmpProtocolAll.Amount
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)

  SELECT tmpProtocol.Id
       , tmpProtocol.InvNumber
       , tmpProtocol.OperDate
       , Object_From.ObjectCode                                                         AS UnitCode
       , Object_From.ValueData                                                          AS UnitName
       , Object_Juridical.ObjectCode                                                    AS JuridicalCode
       , Object_Juridical.ValueData                                                     AS JuridicalName
       , tmpProtocol.MovementItemId                                                     AS MovementItemId
       , Object_Goods.Id                                                                AS GoodsId
       , Object_Goods.ObjectCode                                                        AS GoodsCode
       , Object_Goods.ValueData                                                         AS GoodsName
       , tmpProtocol.AmountAuto::TFloat                                                 AS AmountFormed
       , tmpProtocol.Amount::TFloat                                                     AS AmountSend
       , (tmpProtocol.AmountAuto - tmpProtocol.Amount)::TFloat                          AS AmountDelta
       , Object_CommentSend.Id                                                          AS CommentTRId
       , Object_CommentSend.ObjectCode                                                  AS CommentTRCode
       , Object_CommentSend.ValueData                                                   AS CommentTRName
       , Object_CommentTR.Id                                                            AS CommentTRId
       , Object_CommentTR.ObjectCode                                                    AS CommentTRCode
       , Object_CommentTR.ValueData                                                     AS CommentTRName
       , COALESCE(ObjectBoolean_CommentTR_Resort.ValueData, False)                      AS isResort
  FROM tmpProtocol

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = tmpProtocol.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpProtocol.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                        ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

       LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                        ON MILinkObject_CommentSend.MovementItemId = tmpProtocol.MovementItemId
                                       AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()
       LEFT JOIN Object AS Object_CommentSend
                        ON Object_CommentSend.ID = MILinkObject_CommentSend.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_CommentSend_CommentTR
                            ON ObjectLink_CommentSend_CommentTR.ObjectId = Object_CommentSend.Id
                           AND ObjectLink_CommentSend_CommentTR.DescId = zc_ObjectLink_CommentSend_CommentTR()
       LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentSend_CommentTR.ChildObjectId

       LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentTR_Resort
                               ON ObjectBoolean_CommentTR_Resort.ObjectId = Object_CommentTR.Id 
                              AND ObjectBoolean_CommentTR_Resort.DescId = zc_ObjectBoolean_CommentTR_Resort()
  ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementOccupancySUN (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
--SELECT * FROM gpSelect_MovementOccupancySUN (inMovementID:= 21592297 , inSession:= '3')