-- Function:  gpReport_SAMP_Load()

DROP FUNCTION IF EXISTS gpReport_SAMP_Load (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SAMP_Load(
    IN inMovementId       Integer  ,  --
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartSale        TDateTime,  -- Дата начала отчета
    IN inEndSale          TDateTime,  -- Дата окончания отчета
--    IN inOperDateStart    TDateTime,  -- Дата начала действия изменений по Категории наценки
--    IN inOperDateEnd      TDateTime,  -- Дата окончания действия изменений по Категории наценки
    IN inAmount           TFloat,     -- мин кол-во продаж за анализируемый период
    IN inChangePercent    TFloat,     -- % отклонения продаж
    IN inDayCount         TFloat,     --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbPeriodCount  Integer;
   DECLARE vbDate2   TDateTime;
   DECLARE vbDate3   TDateTime;
   DECLARE vbDate4   TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбрано подразделение.';
    END IF;
    
    IF COALESCE (inDayCount, 0) = 0 
    THEN
        RAISE EXCEPTION 'Ошибка.Не выбрано кол-во дней периода для анализа.';
    END IF;
        
    vbPeriodCount := (ROUND( (date_part('DAY', inEndSale - inStartSale) / inDayCount) ::TFloat, 0)) :: Integer;
    
    IF (vbPeriodCount * inDayCount) < date_part('DAY', inEndSale - inStartSale)
    THEN
        RAISE EXCEPTION 'Ошибка.Кол-во дней периода не кратно периоду для анализа.';
    END IF; 
     
    -- Результат

   -- Определяем периоды для анализа
   CREATE TEMP TABLE _tmpDateList  (OperDate TDateTime, NumPeriod Integer)  ON COMMIT DROP;
   INSERT INTO _tmpDateList (OperDate, NumPeriod)
              WITH
              tmpDateList AS (SELECT generate_series(inStartSale, inEndSale, '1 day'::interval):: TDateTime AS OperDate)
              SELECT tmp.OperDate
                   , CEIL (tmp.Ord / inDayCount)::Integer AS NumPeriod
              FROM (SELECT tmpDateList.OperDate
                         , ROW_NUMBER() OVER (ORDER BY tmpDateList.OperDate) ::tfloat AS Ord
                    FROM tmpDateList
                    ) AS tmp;
  
   CREATE TEMP TABLE _tmpMI (Id Integer, GoodsId Integer) ON COMMIT DROP;
   -- уже сохраненные данные  
   INSERT INTO _tmpMI (Id, GoodsId)
               SELECT MovementItem.Id 
                    , MovementItem.ObjectId AS GoodsId
               FROM MovementItem
               WHERE MovementItem.MovementId = inMovementId
                 ANd MovementItem.DescId = zc_MI_Master()
               ;
               
    CREATE TEMP TABLE _tmpData (GoodsId Integer,TotalAmount TFloat, Amount TFloat, AmountMin TFloat, NumMin TFloat, AmountMax TFloat, NumMax TFloat) ON COMMIT DROP;
    WITH
    -- продажи за период по подразделению, просчет продаж с интервалом в N дней
    tmpData_Container AS (SELECT MIContainer.ObjectId_analyzer               AS GoodsId
                               , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                               , _tmpDateList.NumPeriod                      AS NumPeriod
                          FROM MovementItemContainer AS MIContainer
                               LEFT JOIN _tmpDateList ON _tmpDateList.OperDate = DATE_TRUNC ('DAY', MIContainer.OperDate)
                          WHERE MIContainer.DescId = zc_MIContainer_Count()
                            AND MIContainer.MovementDescId = zc_Movement_Check()
                            AND MIContainer.WhereObjectId_analyzer = inUnitId
                            AND MIContainer.OperDate >= inStartSale AND MIContainer.OperDate < inEndSale + INTERVAL '1 DAY'
                          GROUP BY MIContainer.ObjectId_analyzer
                                 , _tmpDateList.NumPeriod
                          HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0 
                             AND SUM (COALESCE (-1 * MIContainer.Amount, 0)) >= inAmount 
                          )
  --Выбираем период с мин и макс продажами
  , tmpMin_Max AS (SELECT tmp.GoodsId
                        , SUM (CASE WHEN tmp.OrdMax = 1 THEN tmp.Amount ELSE 0 END)     AS AmountMax
                        , SUM (CASE WHEN tmp.OrdMax = 1 THEN tmp.NumPeriod ELSE 0 END)  AS NumMax
                        , SUM (CASE WHEN tmp.OrdMin = 1 THEN tmp.Amount ELSE 0 END)     AS AmountMin
                        , SUM (CASE WHEN tmp.OrdMin = 1 THEN tmp.NumPeriod ELSE 0 END)  AS NumMin
                   FROM (
                         SELECT tmpData_Container.*
                              , ROW_NUMBER() OVER (PARTITION BY tmpData_Container.GoodsId ORDER BY tmpData_Container.Amount desc) AS OrdMax
                              , ROW_NUMBER() OVER (PARTITION BY tmpData_Container.GoodsId ORDER BY tmpData_Container.Amount ) AS OrdMin
                         FROM tmpData_Container 
                         WHERE tmpData_Container.NumPeriod <> 4
                         ) AS tmp
                   WHERE tmp.OrdMax = 1 OR tmp.OrdMin = 1
                   GROUP BY tmp.GoodsId
                   )

   -- Анализируем позиции, у которых продажи упали или выросли на NNN%, за последние N дней анализируемого периода попадают в отчет.                      
   INSERT INTO _tmpData (GoodsId, TotalAmount, Amount, AmountMin, NumMin, AmountMax, NumMax)
               SELECT tmpData.GoodsId
                    , tmpData.TotalAmount AS TotalAmount
                    , tmpData.Amount      AS Amount
                    , CASE WHEN tmpData.Amount_WithOutPerSent >= tmpMin_Max.AmountMin THEN tmpMin_Max.AmountMin ELSE 0 END AS AmountMin   -- продажа выросла
                    , CASE WHEN tmpData.Amount_WithOutPerSent >= tmpMin_Max.AmountMin THEN tmpMin_Max.NumMin ELSE 0 END    AS NumMin      -- продажа выросла3
                    , CASE WHEN tmpData.Amount_WithPerSent <= tmpMin_Max.AmountMax    THEN tmpMin_Max.AmountMax ELSE 0 END AS AmountMax   -- продажа упала
                    , CASE WHEN tmpData.Amount_WithPerSent <= tmpMin_Max.AmountMax    THEN tmpMin_Max.NumMax ELSE 0 END    AS NumMax      -- продажа упала
                 FROM (SELECT tmpData_Container.*
                            , CASE WHEN tmpData_Container.NumPeriod = 4 THEN (tmpData_Container.Amount + tmpData_Container.Amount * 20/100) ELSE 0 END AS Amount_WithPerSent
                            , CASE WHEN tmpData_Container.NumPeriod = 4 THEN (tmpData_Container.Amount - tmpData_Container.Amount * 20/100) ELSE 0 END AS Amount_WithOutPerSent
                            , SUM (tmpData_Container.Amount) OVER (PARTITION BY tmpData_Container.GoodsId) AS TotalAmount
                       FROM tmpData_Container

                       ) AS tmpData
                       LEFT JOIN tmpMin_Max ON tmpMin_Max.GoodsId = tmpData.GoodsId
                                                                                                 
                 WHERE tmpData.NumPeriod = 4 
                   ;

   --проверяем для строк , возможно какойто товар выпал из отчета, такую строку удаляем
   
   -- уберем пометки удаления со всех (чтоб потом не мучаться если нужно восстановить)
   UPDATE MovementItem 
      SET isErased = FALSE
   WHERE MovementItem.MovementId = inMovementId;
   
   WITH 
   tmpMI_Del AS (SELECT COALESCE (_tmpMI.Id, 0) AS Id
              FROM _tmpData
                  FULL JOIN _tmpMI ON _tmpMI.GoodsId = _tmpData.GoodsId
              WHERE _tmpData.GoodsId IS NULL
              )
   UPDATE MovementItem 
         SET isErased = TRUE 
   WHERE MovementItem.Id IN (SELECT tmpMI_Del.Id FROM tmpMI_Del);
   
   PERFORM lpInsertUpdate_MI_MarginCategory_Master (ioId           := COALESCE (_tmpMI.Id, 0)           ::integer
                                                  , inMovementId   := inMovementId
                                                  , inGoodsId      := _tmpData.GoodsId
                                                  , inAmount       := _tmpData.TotalAmount              ::TFloat
                                                  , inAmountAnalys := COALESCE (_tmpData.Amount, 0)     ::TFloat
                                                  , inAmountMin    := COALESCE (_tmpData.AmountMin, 0)  ::TFloat
                                                  , inAmountMax    := COALESCE (_tmpData.AmountMax, 0)  ::TFloat
                                                  , inNumberMin    := COALESCE (_tmpData.NumMin, 0)  ::TFloat
                                                  , inNumberMax    := COALESCE (_tmpData.NumMax, 0)  ::TFloat
                                                  , inUserId       := vbUserId
                                                  )
   FROM _tmpData   
       LEFT JOIN _tmpMI ON _tmpMI.GoodsId = _tmpData.GoodsId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 20.11.17         *
*/

-- тест
-- select * from gpReport_SAMP_Load(inMovementId := 3959786 , inUnitId := 472116 , inStartSale := ('01.10.2017')::TDateTime , inEndSale := ('31.10.2017')::TDateTime , inAmount := 2 , inChangePercent := 10 ,  inSession := '3');