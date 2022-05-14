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
             , Sale TFloat, Efficiency TFloat
             , Color_UntilNextSUN Integer
             , isSendPartionDate Boolean
              )

AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbAmountSale TFloat;
  DECLARE vbAmountIn TFloat;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());
  vbUserId:= lpGetUserBySession (inSession);
  
    WITH 
        tmpSUN_Container_All AS (SELECT MIContainer.ContainerId
                                      , SUM (MIContainer.Amount)                                             AS AmountIn
                                 FROM MovementItemContainer AS MIContainer
                                      INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                                ON MovementBoolean_SUN.MovementId = MIContainer.MovementId
                                                               AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                                               AND MovementBoolean_SUN.ValueData = TRUE
                                WHERE MIContainer.DescId = zc_MIContainer_Count()
                                  AND MIContainer.MovementDescId = zc_Movement_Send()
                                  AND MIContainer.isActive = TRUE
                                  AND MIContainer.Amount > 0
                                  AND MIContainer.OperDate > '01.08.2018'
                                  AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' 
                                GROUP BY MIContainer.ContainerId
                                )
        -- все продажи за период
      , tmpContainer_Check AS (SELECT MIContainer.ContainerId                     AS ContainerId
                                    , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               FROM tmpSUN_Container_All
                                    INNER JOIN MovementItemContainer AS MIContainer
                                                                     ON MIContainer.ContainerId = tmpSUN_Container_All.ContainerId
                                                                    AND MIContainer.DescId = zc_MIContainer_Count()
                                                                    AND MIContainer.MovementDescId = zc_Movement_Check()
                                                                    AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY' 
                               GROUP BY MIContainer.ContainerId
                               HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) > 0
                               )

   
 
        -- результат
        SELECT Sum(tmpContainer_Check.Amount)::TFloat       AS Amount
             , Sum(tmpSUN_Container_All.AmountIn)::TFloat   AS AmountIn
        INTO vbAmountSale, vbAmountIn
        FROM tmpSUN_Container_All AS tmpSUN_Container_All 
        
            LEFT JOIN tmpContainer_Check ON tmpContainer_Check.ContainerId = tmpSUN_Container_All.ContainerId

        ;  

  -- Результат
  RETURN QUERY
  WITH tmpCashSettings AS (SELECT COALESCE(ObjectFloat_CashSettings_PercentUntilNextSUN.ValueData, 0)::TFloat   AS PercentUntilNextSUN
                           FROM Object AS Object_CashSettings
                                LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PercentUntilNextSUN
                                                      ON ObjectFloat_CashSettings_PercentUntilNextSUN.ObjectId = Object_CashSettings.Id 
                                                     AND ObjectFloat_CashSettings_PercentUntilNextSUN.DescId = zc_ObjectFloat_CashSettings_PercentUntilNextSUN()
                           WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                           LIMIT 1)          
         -- список подразделений
     , tmpMovement AS (SELECT Movement.ID
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
                          , COALESCE (ObjectBoolean_CommentSun_SendPartionDate.ValueData, False)           AS isSendPartionDate
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
                     
                          LEFT JOIN ObjectBoolean AS ObjectBoolean_CommentSun_SendPartionDate
                                                  ON ObjectBoolean_CommentSun_SendPartionDate.ObjectId = MILinkObject_CommentSend.ObjectId
                                                 AND ObjectBoolean_CommentSun_SendPartionDate.DescId   = zc_ObjectBoolean_CommentSun_SendPartionDate()
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
     , tmpUntilNextSUN AS (SELECT tmpResult.UnitId
                                 , (Sum(CASE WHEN tmpResult.CommentSendID = 14883299 
                                            THEN ROUND(tmpResult.Price * (COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount ) -
                                                       tmpResult.Amount + COALESCE(tmpSale.Sale, 0)), 2) ELSE 0 END) /
                                   Sum(ROUND(tmpResult.Price * COALESCE(tmpProtocol.AmountAuto, tmpResult.Amount) , 2)) * 100)::TFloat                                       AS PercentUntilNextSUN
                                                          
                            FROM tmpResult 
                                 LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
                                 LEFT JOIN tmpSale ON tmpSale.UnitId = tmpResult.UnitId
                                                  AND tmpSale.GoodsID = tmpResult.GoodsID
                            GROUP BY tmpResult.UnitId)

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
       , CASE WHEN vbAmountIn > 0 THEN (vbAmountSale / vbAmountIn * 100) END::TFloat                                       AS Efficiency
       , CASE WHEN COALESCE(tmpUntilNextSUN.PercentUntilNextSUN, 0) > 0 AND COALESCE(tmpCashSettings.PercentUntilNextSUN, 0) > 0 AND 
                   tmpUntilNextSUN.PercentUntilNextSUN >= tmpCashSettings.PercentUntilNextSUN 
              THEN zc_Color_Yelow()
              ELSE zc_Color_White() END Color_UntilNextSUN
       , tmpResult.isSendPartionDate
  FROM tmpResult
       LEFT JOIN Object AS Object_From ON Object_From.Id = tmpResult.UnitId
       LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = tmpResult.CommentSendID
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpResult.GoodsID
       LEFT JOIN tmpProtocol ON tmpProtocol.MovementItemId = tmpResult.MovementItemId
       LEFT JOIN tmpResulAll ON 1 = 1
       LEFT JOIN tmpSale ON tmpSale.UnitId = tmpResult.UnitId
                        AND tmpSale.GoodsID = tmpResult.GoodsID
       LEFT JOIN tmpCashSettings ON 1 = 1
       LEFT JOIN tmpUntilNextSUN ON tmpUntilNextSUN.UnitId = tmpResult.UnitId
  WHERE COALESCE (tmpResult.CommentSendID , 0) <> 0
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

select * from gpReport_CommentSendSUN(inStartDate := ('01.01.2022')::TDateTime , inEndDate := ('16.03.2022')::TDateTime ,  inSession := '3');
