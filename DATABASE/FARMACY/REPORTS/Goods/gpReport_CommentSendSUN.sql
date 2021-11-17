-- Function: gpReport_CommentSendSUN()

DROP FUNCTION IF EXISTS gpReport_CommentSendSUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CommentSendSUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitCode Integer, UnitName TVarChar, TypeSUN TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , CommentSendCode Integer, CommentSendName TVarChar
             , GoodsCode Integer, GoodsName TVarChar
             , Price TFloat, Amount TFloat, Summa TFloat, Formed TFloat, PercentZeroing TFloat
             , PercentZeroingRange TFloat
             , Sale TFloat
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
                          , CASE WHEN COALESCE (MovementBoolean_SUN_v4.ValueData, FALSE) = TRUE THEN 'СУН-ПИ'
                                 WHEN COALESCE (MovementBoolean_SUN_v3.ValueData, FALSE) = TRUE THEN 'Э-СУН'
                                 WHEN COALESCE (MovementBoolean_SUN_v2.ValueData, FALSE) = TRUE THEN 'СУН-v2'
                                 ELSE 'СУН-v1' END::TVarChar                                               AS TypeSUN 
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

                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v2
                                                    ON MovementBoolean_SUN_v2.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v2.DescId = zc_MovementBoolean_SUN_v2()
                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v3
                                                    ON MovementBoolean_SUN_v3.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v3.DescId = zc_MovementBoolean_SUN_v3()
                          LEFT JOIN MovementBoolean AS MovementBoolean_SUN_v4
                                                    ON MovementBoolean_SUN_v4.MovementId = Movement.Id
                                                   AND MovementBoolean_SUN_v4.DescId = zc_MovementBoolean_SUN_v4()
                     WHERE COALESCE (MILinkObject_CommentSend.ObjectId , 0) <> 0
                     )
     , tmpProtocolUnion AS (SELECT  MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpMovement AS Movement

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE

                                  INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                              AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                             UNION ALL
                             SELECT MovementItemProtocol.Id
                                  , MovementItemProtocol.MovementItemId
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                             FROM tmpMovement AS Movement

                                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE

                                  INNER JOIN MovementItemProtocol_arc AS MovementItemProtocol
                                                                      ON MovementItemProtocol.MovementItemId = MovementItem.Id
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
     , tmpResulAll AS (SELECT Sum(COALESCE( tmpProtocol.AmountAuto, MovementItem.Amount) - MovementItem.Amount) AS AmountZeroing
                            , Sum(COALESCE( tmpProtocol.AmountAuto, MovementItem.Amount))                       AS AmountAuto
                       FROM tmpMovement AS Movement

                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = FALSE
                                                  
                            LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = MovementItem.Id
                     --  WHERE Movement.StatusId = zc_Enum_Status_Complete() 
                     )
     , tmpResultGroup AS (SELECT DISTINCT tmpResult.UnitId
                                        , tmpResult.GoodsID
                          FROM tmpResult)
     , tmpSale AS (SELECT tmpResultGroup.UnitId
                        , tmpResultGroup.GoodsID
                        , SUM(- MIC.Amount)::TFloat     AS Sale
                   FROM tmpResultGroup
                   
                        LEFT JOIN MovementItemContainer AS MIC
                                                        ON MIC.OperDate >= inStartDate
                                                       AND MIC.OperDate < inEndDate + INTERVAL '1 DAY'
                                                       AND MIC.ObjectId_analyzer = tmpResultGroup.GoodsID
                                                       AND MIC.WhereObjectId_analyzer = tmpResultGroup.UnitId
                                                       AND MIC.MovementDescId = zc_Movement_Check()
                        
                   GROUP BY tmpResultGroup.UnitId
                          , tmpResultGroup.GoodsID)

  SELECT tmpResult.Id
       , Object_From.ObjectCode                                                           AS UnitCode
       , Object_From.ValueData                                                            AS UnitName
       , tmpResult.TypeSUN                                                                AS TypeSUN
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
       , COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount )::TFloat                      AS Formed
       , CASE WHEN COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) = 0 THEN 0
              ELSE ROUND((1 - tmpResult.Amount / COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount)) * 100, 2) END::TFloat AS PercentZeroing
       , CASE WHEN tmpResulAll.AmountAuto > 0 
              THEN ROUND(tmpResulAll.AmountZeroing / tmpResulAll.AmountAuto * 100, 2) ELSE 0 END::TFloat                   AS PercentZeroingRange
       , tmpSale.Sale
  FROM tmpResult
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpResult.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpResult.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsID
       LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
       LEFT JOIN tmpResulAll ON 1 = 1
       LEFT JOIN tmpSale ON tmpSale.UnitId = tmpResult.UnitId
                        AND tmpSale.GoodsID = tmpResult.GoodsID
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

select * from gpReport_CommentSendSUN(inStartDate := ('16.11.2021')::TDateTime , inEndDate := ('21.11.2021')::TDateTime ,  inSession := '3');
