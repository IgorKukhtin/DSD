-- Function: gpReport_PercentageOccupancySUN()

DROP FUNCTION IF EXISTS gpReport_PercentageOccupancySUN (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PercentageOccupancySUN(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumbr TVarChar, OperDate TDateTime
             , UnitCode Integer, UnitName TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , AmountAll TFloat, AmountSend TFloat
             , AmountAllCalc TFloat, AmountOccupancyCalc TFloat
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
                            , Movement.OperDate
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                    ON MovementBoolean_SUN.MovementId = Movement.Id
                                   AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                   AND MovementBoolean_SUN.ValueData = TRUE
                       WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.DescId = zc_Movement_Send()
                         AND Movement.StatusId = zc_Enum_Status_Complete())
     , tmpProtocolAll AS (SELECT Movement.ID
                               , Movement.InvNumber
                               , Movement.OperDate
                               , MovementItemProtocol.MovementItemId
                               , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                               , MovementItem.Amount
                               , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                          FROM tmpMovement AS Movement

                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id

                               INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                               INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                           AND Object_Goods_Main.isInvisibleSUN = False

                               INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                              AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                          )
     , tmpProtocol AS (SELECT tmpProtocolAll.Id
                            , tmpProtocolAll.InvNumber
                            , tmpProtocolAll.OperDate
                            , tmpProtocolAll.MovementItemId
                            , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                            , tmpProtocolAll.Amount
                       FROM tmpProtocolAll
                       WHERE tmpProtocolAll.Ord = 1)
     , tmpResult AS (SELECT tmpProtocol.Id
                          , tmpProtocol.InvNumber
                          , tmpProtocol.OperDate
                          , SUM(tmpProtocol.AmountAuto) AS AmountAuto
                          , SUM(tmpProtocol.Amount) AS Amount
                     FROM tmpProtocol
                     GROUP BY tmpProtocol.Id, tmpProtocol.InvNumber, tmpProtocol.OperDate)

  SELECT tmpResult.Id
       , tmpResult.InvNumber
       , tmpResult.OperDate
       , Object_From.ObjectCode                                                         AS UnitCode
       , Object_From.ValueData                                                          AS UnitName
       , Object_Juridical.ObjectCode                                                    AS JuridicalCode
       , Object_Juridical.ValueData                                                     AS JuridicalName
       , tmpResult.AmountAuto::TFloat                                                   AS AmountAll
       , tmpResult.Amount::TFloat                                                       AS AmountSend
       , tmpResult.AmountAuto::TFloat                                                   AS AmountAllCalc
       , (tmpResult.AmountAuto - tmpResult.Amount)::TFloat                              AS AmountOccupancyCalc

  FROM tmpResult

       LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                    ON MovementLinkObject_From.MovementId = tmpResult.Id
                                   AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                        ON ObjectLink_Unit_Juridical.ObjectId = Object_From.Id
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId


  ;

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
--
SELECT * FROM gpReport_PercentageOccupancySUN (inStartDate:= '01.07.2020', inEndDate:= '30.07.2020', inSession:= '3')

