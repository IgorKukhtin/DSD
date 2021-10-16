-- Function: gpReport_TopListDiffGoods()

DROP FUNCTION IF EXISTS gpReport_TopListDiffGoods (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TopListDiffGoods(
    IN inStartDate     TDateTime,  -- Дата начала
    IN inEndDate       TDateTime,  -- Дата окончания
    IN inUnitId        Integer  ,  -- Подразделение
    IN inТop           Integer,  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord Integer
             , GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat, Summa TFloat
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
  WITH tmpMovement AS (SELECT MovementListDiff.ID
                            , MovementListDiff.InvNumber
                            , MovementListDiff.OperDate  
                            , MovementLinkObject_Unit.ObjectId AS UnitId
                       FROM Movement AS MovementListDiff

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                         ON MovementLinkObject_Unit.MovementId = MovementListDiff.Id
                                                        AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()

                       WHERE MovementListDiff.OperDate BETWEEN inStartDate AND inEndDate
                         AND MovementListDiff.DescId = zc_Movement_ListDiff() 
                         AND MovementListDiff.StatusId = zc_Enum_Status_Complete()
                         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0))                         
     , tmpMI AS (SELECT Movement.ID                                                                    AS ID
                      , Movement.InvNumber
                      , Movement.OperDate
                      , MovementItem.ObjectId                                                          AS GoodsID
                      , MovementItem.Id                                                                AS MovementItemId
                      , MovementItem.Amount                                                            AS Amount
                      , COALESCE(MIFloat_Price.ValueData,0)                                            AS Price
                 FROM tmpMovement as Movement
                 
                      INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                             AND MovementItem.DescId = zc_MI_Master()
                                             AND MovementItem.isErased = FALSE
                                             AND MovementItem.Amount > 0 

                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItem.ID
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                                 
                 )     
     , tmpMISum AS (SELECT tmpMI.GoodsID                                        AS GoodsID
                         , SUM(tmpMI.Amount)::TFloat                            AS Amount
                         , SUM(ROUND(tmpMI.Price * tmpMI.Amount, 2))::TFloat    AS Summa
                    FROM tmpMI
                    GROUP BY tmpMI.GoodsID
                    ORDER BY 2 DESC  
                    LIMIT inТop)

  SELECT ROW_NUMBER() OVER (ORDER BY tmpMISum.Amount DESC)::Integer  AS Ord
       , Object_Goods.ObjectCode                                     AS GoodsCode
       , Object_Goods.ValueData                                      AS GoodsName
       , tmpMISum.Amount                                             AS Amount
       , ROUND(tmpMISum.Summa / tmpMISum.Amount, 2)::TFloat          AS Price
       , tmpMISum.Summa                                              AS Summa
  FROM tmpMISum

       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMISum.GoodsID

  ORDER BY tmpMISum.Amount DESC;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_TopListDiffGoods (TDateTime, TDateTime, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.10.21                                                       *
*/

-- тест
--

select * from gpReport_TopListDiffGoods(inStartDate := '01.10.2021', inEndDate := '30.10.2021', inUnitId := 0, inТop := 100, inSession := '3');