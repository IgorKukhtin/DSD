-- Function: gpReport_ChangeCommentsSUN()

DROP FUNCTION IF EXISTS gpReport_ChangeCommentsSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ChangeCommentsSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , CommentSendCode Integer, CommentSendName TVarChar
             , CommentSendChangeCode Integer, CommentSendChangeName TVarChar
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
     , tmpMI AS (SELECT Movement.ID                                                                    AS ID
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

                      LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId = zc_MI_Master()
                                            AND MovementItem.isErased = FALSE

                      LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                       ON MILinkObject_CommentSend.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                      LEFT JOIN ObjectLink AS ObjectLink_CommentSend_CommentTR
                                           ON ObjectLink_CommentSend_CommentTR.ObjectId = MILinkObject_CommentSend.ObjectId
                                          AND ObjectLink_CommentSend_CommentTR.DescId = zc_ObjectLink_CommentSend_CommentTR()


                      LEFT OUTER JOIN MovementItemFloat AS MIFloat_PriceFrom
                                                        ON MIFloat_PriceFrom.MovementItemId = MovementItem.ID
                                                       AND MIFloat_PriceFrom.DescId = zc_MIFloat_PriceFrom()
                 WHERE COALESCE (ObjectLink_CommentSend_CommentTR.ChildObjectId , 0) = 0
                   AND COALESCE (MILinkObject_CommentSend.ObjectId , 0) <> 0
                 )
     , tmpProtocolAll AS (SELECT MovementItem.MovementItemId
                               , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM tmpMI AS MovementItem

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)
     , tmpCommentSend AS (SELECT Object_CommentSend.Id                             AS Id
                               , Object_CommentSend.ObjectCode                     AS Code
                               , Object_CommentSend.ValueData                      AS Name
                           FROM Object AS Object_CommentSend

                                LEFT JOIN ObjectLink AS ObjectLink_CommentSend_CommentTR
                                                     ON ObjectLink_CommentSend_CommentTR.ObjectId = Object_CommentSend.Id
                                                    AND ObjectLink_CommentSend_CommentTR.DescId = zc_ObjectLink_CommentSend_CommentTR()

                           WHERE Object_CommentSend.DescId = zc_Object_CommentSend()
                             AND COALESCE (ObjectLink_CommentSend_CommentTR.ChildObjectId, 0) <> 0)
     , tmpProtocolCommentAll AS (SELECT MovementItem.MovementItemId, tmpCommentSend.Code, tmpCommentSend.Name
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.OperDate DESC) AS Ord
                          FROM tmpMI AS MovementItem

                               INNER JOIN tmpCommentSend ON 1 = 1

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.MovementItemId
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%'||tmpCommentSend.Name||'%'

                          )
     , tmpProtocolComment AS (SELECT tmpProtocolCommentAll.MovementItemId
                                   , tmpProtocolCommentAll.Code 
                                   , tmpProtocolCommentAll.Name 
                              FROM tmpProtocolCommentAll
                              WHERE tmpProtocolCommentAll.Ord = 1)

  SELECT tmpMI.Id
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , tmpMI.InvNumber
       , tmpMI.OperDate
       , Object_CommentSend.ObjectCode                                                    AS CommentSendCode
       , Object_CommentSend.ValueData                                                     AS CommentSendName
       , tmpProtocolComment.Code                                                          AS CommentSendChangeCode
       , tmpProtocolComment.Name                                                          AS CommentSendChangeName
       , Object_Goods.ObjectCode                                                          AS GoodsCode
       , Object_Goods.ValueData                                                           AS GoodsName
       , tmpMI.Price::TFloat                                                              AS Price
       , (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) - tmpMI.Amount)::TFloat         AS Amount
       , ROUND(tmpMI.Price * (COALESCE(tmpProtocol.AmountAuto, tmpMI.Amount ) -
                                tmpMI.Amount), 2)::TFloat                                 AS Summa
  FROM tmpMI
       INNER JOIN tmpProtocolComment ON tmpProtocolComment.MovementItemId = tmpMI.MovementItemId
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMI.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpMI.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsID
       LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpMI.MovementItemId
  ORDER BY Object_From.ValueData, tmpMI.Id;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_ChangeCommentsSUN (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.09.20                                                       *
*/

-- тест
--

select * from gpReport_ChangeCommentsSUN(inStartDate := ('14.09.2020')::TDateTime , inEndDate := ('14.09.2020')::TDateTime ,  inSession := '3');