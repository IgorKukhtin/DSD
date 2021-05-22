-- Function: gpReport_CommentSendSUN_NonCommodityView()

DROP FUNCTION IF EXISTS gpReport_CommentSendSUN_NonCommodityView (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommentSendSUN_NonCommodityView(
    IN inOperDate      TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , Amount TFloat, Formed TFloat
             , InvNumberPrev TVarChar, OperDatePrev TDateTime
             , AmountPrev TFloat, FormedPrev TFloat
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
  WITH tmpMovement AS (SELECT Movement.ID
                            , Movement.InvNumber
                            , Movement.StatusId
                            , Movement.OperDate
                            , inOperDate - ((date_part('isodow', inOperDate) - 1)||' day')::INTERVAL <= Movement.OperDate AS isCurrent
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       WHERE MovementDate_Insert.ValueData BETWEEN inOperDate - ((date_part('isodow', inOperDate) + 6)::TVarChar||' day')::INTERVAL AND inOperDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Send())
     , tmpResult AS (SELECT Movement.ID                                                                    AS ID
                          , Movement.InvNumber
                          , Movement.OperDate
                          , Movement.isCurrent                                                             AS isCurrent 
                          , MovementLinkObject_From.ObjectId                                               AS UnitId
                          , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                          , MovementItem.ObjectId                                                          AS GoodsID
                          , MovementItem.Id                                                                AS MovementItemId
                          , MovementItem.Amount                                                            AS Amount
                     FROM tmpMovement AS Movement
                          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE

                          LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                           ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                     WHERE COALESCE (MILinkObject_CommentSend.ObjectId , 0) = 15180138 
                     )
     , tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpResult AS MovementItem

                                  INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                             UNION ALL
                             SELECT MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpResult AS MovementItem

                                  INNER JOIN MovementItemProtocol_arc AS MovementItemProtocol
                                                                      ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                                     AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                     AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                            )
      , tmpProtocolAll AS (SELECT MovementItemProtocol.MovementItemId
                                , MovementItemProtocol.ProtocolData
                                , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                           FROM tmpProtocolUnion AS MovementItemProtocol
                           )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)

  SELECT tmpResult.Id
       , Object_From.Id                                                                   AS UnitId
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , Object_Goods.Id                                                                  AS GoodsId
       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , tmpResult.InvNumber
       , tmpResult.OperDate
       , (COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) - tmpResult.Amount)::TFloat AS Amount
       , COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount )::TFloat                      AS Formed
       , tmpResultPrev.InvNumber
       , tmpResultPrev.OperDate
       , (COALESCE(tmpProtocolPrev.AmountAuto, tmpResultPrev.Amount ) - tmpResultPrev.Amount)::TFloat AS AmountPrev
       , COALESCE(tmpProtocolPrev.AmountAuto, tmpResultPrev.Amount )::TFloat                          AS FormedPrev
  FROM tmpResult
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpResult.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpResult.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsID
       LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
       
       LEFT JOIN tmpResult AS tmpResultPrev
                           ON tmpResultPrev.UnitId = tmpResult.UnitId
                          AND tmpResultPrev.GoodsID = tmpResult.GoodsID
                          AND tmpResultPrev.isCurrent = FALSE 
       LEFT JOIN tmpProtocol AS tmpProtocolPrev
                             ON tmpProtocolPrev.MovementItemId = tmpResultPrev.MovementItemId
  WHERE tmpResult.isCurrent = TRUE
  ORDER BY Object_From.ValueData, tmpResult.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_CommentSendSUN_NonCommodityView (TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- 
select * from gpReport_CommentSendSUN_NonCommodityView(inOperDate := ('13.05.2021')::TDateTime , inSession := '3');