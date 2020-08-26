-- Function: gpReport_CommentSendSUN()

DROP FUNCTION IF EXISTS gpReport_CommentSendSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommentSendSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , CommentSendCode Integer, CommentSendName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Price TFloat, Amount TFloat, Summa TFloat
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
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                            INNER JOIN MovementDate AS MovementDate_Insert
                                                    ON MovementDate_Insert.MovementId = Movement.Id
                                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       WHERE MovementDate_Insert.ValueData BETWEEN inStartDate AND inEndDate + INTERVAL '1 DAY'
                         AND Movement.DescId = zc_Movement_Send())
     , tmpResult AS (SELECT Movement.ID                                                                    AS ID
                          , Movement.InvNumber
                          , Movement.OperDate
                          , MovementLinkObject_From.ObjectId                                               AS UnitId
                          , MILinkObject_CommentSend.ObjectId                                              AS CommentSendID
                          , MovementItem.ObjectId                                                          AS GoodsID
                          , MovementItem.Id                                                                AS MovementItemId
                          , MovementItem.Amount                                                            AS Amount
                          , COALESCE(MIFloat_PriceFrom.ValueData,0)                                        AS Price
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

                          LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                            ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                           AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                     WHERE COALESCE (MILinkObject_CommentSend.ObjectId , 0) <> 0
                     )
     , tmpProtocolAll AS (SELECT MovementItem.MovementItemId
                               , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM tmpResult AS MovementItem

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)

  SELECT tmpResult.Id
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , tmpResult.InvNumber
       , tmpResult.OperDate
       , Object_CommentSend.ObjectCode                                                    AS CommentSendCode
       , Object_CommentSend.ValueData                                                     AS CommentSendName
       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , tmpResult.Price::TFloat                                                          AS Price
       , (COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) - tmpResult.Amount)::TFloat AS Amount
       , ROUND(tmpResult.Price * (COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) -
                                tmpResult.Amount), 2)::TFloat                             AS Summa
  FROM tmpResult
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpResult.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpResult.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsID
       LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
  ORDER BY Object_From.ValueData, tmpResult.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_PercentageOverdueSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpReport_CommentSendSUN (inStartDate:= '25.08.2020', inEndDate:= '25.08.2020', inSession:= '3')
