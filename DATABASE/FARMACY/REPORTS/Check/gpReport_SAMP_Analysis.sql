-- Function:  gpReport_SAMP_Analysis()
DROP FUNCTION IF EXISTS gpReport_SAMP_Analysis(Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SAMP_Analysis(
    IN inMovementId       Integer  ,  --
    IN inYear1            TDateTime,  -- Год1 для анализа
    IN inYear2            TDateTime,  -- Год2 для анализа
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsId         Integer
             , GoodsCode       Integer
             , GoodsName       TVarChar
             , Price_MI        TFloat
             , Amount_MI       TFloat
             , AmountAnalys_MI TFloat
             , AmountYear1     TFloat
             , AmountYear2     TFloat
             , AmountAnalys1   TFloat
             , AmountAnalys2   TFloat
             )
       
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale   TDateTime;
   DECLARE vbDayCount  TFloat;
   
   DECLARE vbStartSale1 TDateTime;
   DECLARE vbEndSale1   TDateTime;
   DECLARE vbStartSale2 TDateTime;
   DECLARE vbEndSale2   TDateTime;

   DECLARE vbStartPeriod1 TDateTime;
   DECLARE vbStartPeriod2 TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- получаемданные из шапки документа
    SELECT MovementDate_StartSale.ValueData            AS StartSale
         , MovementDate_EndSale.ValueData              AS EndSale
         , MovementLinkObject_Unit.ObjectId            AS UnitId
         , MovementFloat_DayCount.ValueData            AS DayCount
       INTO vbStartSale, vbEndSale, vbUnitId, vbDayCount
    FROM Movement AS Movement_MarginCategory 

         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement_MarginCategory.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement_MarginCategory.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

         LEFT JOIN MovementFloat AS MovementFloat_DayCount
                                 ON MovementFloat_DayCount.MovementId = Movement_MarginCategory.Id
                                AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement_MarginCategory.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                                                    
    WHERE Movement_MarginCategory.Id =  inMovementId
      AND Movement_MarginCategory.DescId = zc_Movement_MarginCategory();
          
    --выбираем товары для отчета и данные по ним из мастера документа
    CREATE TEMP TABLE _tmpGoodsList  (GoodsId Integer, Amount TFloat, AmountAnalys TFloat, Price TFloat)  ON COMMIT DROP;
      INSERT INTO _tmpGoodsList (GoodsId, Amount, AmountAnalys, Price)
           SELECT MovementItem.ObjectId                           AS GoodsId
                , MovementItem.Amount                    ::TFloat AS Amount
                , COALESCE (MIFloat_Amount.ValueData, 0) ::TFloat AS AmountAnalys
                , COALESCE (MIFloat_Price.ValueData, 0)  ::TFloat AS Price
           FROM MovementItem
                INNER JOIN MovementItemBoolean AS MIBoolean_Report
                                               ON MIBoolean_Report.MovementItemId = MovementItem.Id
                                              AND MIBoolean_Report.DescId = zc_MIBoolean_Report()
                                              AND COALESCE (MIBoolean_Report.ValueData, FALSE) = TRUE

                LEFT JOIN MovementItemFloat AS MIFloat_Amount
                                        ON MIFloat_Amount.MovementItemId = MovementItem.Id
                                       AND MIFloat_Amount.DescId = zc_MIFloat_Amount()
                                       
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId     = zc_MI_Master()
             AND MovementItem.isErased   = FALSE;
    
    --даты нач. и окончания периода
    vbStartSale1:=  (EXTRACT (DAY FROM vbStartSale)||'.'||EXTRACT (MONTH FROM vbStartSale)||'.'||EXTRACT (YEAR FROM inYear1)) ::TDateTime;                   
    vbEndSale1  :=  (EXTRACT (DAY FROM vbEndSale)  ||'.'||EXTRACT (MONTH FROM vbEndSale)  ||'.'||EXTRACT (YEAR FROM inYear1)) ::TDateTime + INTERVAL '1 Day';
    vbStartSale2:=  (EXTRACT (DAY FROM vbStartSale)||'.'||EXTRACT (MONTH FROM vbStartSale)||'.'||EXTRACT (YEAR FROM inYear2)) ::TDateTime;                   
    vbEndSale2  :=  (EXTRACT (DAY FROM vbEndSale)  ||'.'||EXTRACT (MONTH FROM vbEndSale)  ||'.'||EXTRACT (YEAR FROM inYear2)) ::TDateTime + INTERVAL '1 Day';

    --даты нач. и окончания периода для анализа    
    vbStartPeriod1:= (vbEndSale1 - ('' ||vbDayCount || 'DAY ')  :: interval ) TDateTime;
    vbStartPeriod2:= (vbEndSale2 - ('' ||vbDayCount || 'DAY ')  :: interval ) TDateTime;

    -- Результат
    RETURN QUERY
    WITH
    -- продажи за периоды по подразделению
    tmpData_Container AS (SELECT MIContainer.ObjectId_analyzer                AS GoodsId
                               , MIContainer.OperDate                         AS OperDate
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0) ) AS Amount
                          FROM _tmpGoodsList
                          
                               INNER JOIN MovementItemContainer AS MIContainer  ON MIContainer.ObjectId_analyzer = _tmpGoodsList.GoodsId
                               
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.WhereObjectId_analyzer = vbUnitId
                            AND ((MIContainer.OperDate >= vbStartSale1 AND MIContainer.OperDate < vbEndSale1)
                                 OR 
                                 (MIContainer.OperDate >= vbStartSale2 AND MIContainer.OperDate < vbEndSale2))
                                 
                          GROUP BY MIContainer.ObjectId_analyzer
                                 , MIContainer.OperDate
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0 
                          )
                          
  --Разджеляем продажи по периодам
  , tmpData AS (SELECT tmp.GoodsId  
                     , SUM (CASE WHEN tmp.OperDate >= vbStartSale1   AND tmp.OperDate < vbEndSale1 THEN tmp.Amount ELSE 0 END)  AS AmountYear1
                     , SUM (CASE WHEN tmp.OperDate >= vbStartSale2   AND tmp.OperDate < vbEndSale2 THEN tmp.Amount ELSE 0 END)  AS AmountYear2
                     , SUM (CASE WHEN tmp.OperDate >= vbStartPeriod1 AND tmp.OperDate < vbEndSale1 THEN tmp.Amount ELSE 0 END)  AS AmountAnalys1
                     , SUM (CASE WHEN tmp.OperDate >= vbStartPeriod2 AND tmp.OperDate < vbEndSale2 THEN tmp.Amount ELSE 0 END)  AS AmountAnalys2
    
                FROM tmpData_Container AS tmp
                GROUP BY tmp.GoodsId  
                )
                
  --результат
  SELECT Object_Goods.Id              ::Integer   AS GoodsId
       , Object_Goods.ObjectCode      ::Integer   AS GoodsCode
       , Object_Goods.ValueData       ::TVarChar  AS GoodsName
       
       , _tmpGoodsList.Price          ::TFloat    AS Price_MI
       , _tmpGoodsList.Amount         ::TFloat    AS Amount_MI
       , _tmpGoodsList.AmountAnalys   ::TFloat    AS AmountAnalys_MI
       
       , tmpData.AmountYear1          ::TFloat
       , tmpData.AmountYear2          ::TFloat
       , tmpData.AmountAnalys1        ::TFloat
       , tmpData.AmountAnalys2        ::TFloat
  FROM _tmpGoodsList
       LEFT JOIN tmpData ON tmpData.GoodsId = _tmpGoodsList.GoodsId
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoodsList.GoodsId
  ;

        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 26.11.17         *
*/

-- тест
-- select * from gpReport_SAMP_Analysis(inMovementId := 3959786 , inYear1 := ('01.10.2015')::TDateTime , inYear2 := ('31.10.2016')::TDateTime , inSession := '3');