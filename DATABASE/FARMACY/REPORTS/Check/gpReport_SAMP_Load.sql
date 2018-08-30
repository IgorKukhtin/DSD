-- Function:  gpReport_SAMP_Load()
DROP FUNCTION IF EXISTS gpReport_SAMP_Load (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SAMP_Load (Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_SAMP_Load(
    IN inMovementId       Integer  ,  --
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartSale        TDateTime,  -- Дата начала отчета
    IN inEndSale          TDateTime,  -- Дата окончания отчета
    IN inAmount           TFloat,     -- мин кол-во продаж за анализируемый период
    IN inChangePercent    TFloat,     -- % отклонения продаж
    IN inDayCount         TFloat,     --
    IN inPriceMin         TFloat,     --
    IN inPriceMax         TFloat,     --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId  Integer;
   DECLARE vbPeriodCount  Integer;
   DECLARE vbMarginCategoryId Integer;
   DECLARE vbOperDateStart TDateTime;
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
        
    vbPeriodCount := (CEIL( (date_part('DAY', inEndSale - inStartSale) / inDayCount) ::TFloat)) :: Integer;
    --должно быть мин. 2 периода для анализа
    IF vbPeriodCount < 2 THEN vbPeriodCount := 2; END IF;

    vbOperDateStart := (inEndSale - ('' ||(vbPeriodCount * inDayCount)-1 || 'DAY ')  :: interval ) TDateTime;
    
    --IF (vbPeriodCount * inDayCount) <> date_part('DAY', inEndSale - inStartSale)+1
    IF vbOperDateStart <> inStartSale
    THEN
        RAISE EXCEPTION 'Ошибка.Кол-во дней периода не кратно периоду для анализа.Рекомендуемая нач.дата <%>', vbOperDateStart;
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
               
    CREATE TEMP TABLE _tmpData (GoodsId Integer,TotalAmount TFloat, Amount TFloat, AmountMin TFloat, NumMin TFloat, AmountMax TFloat, NumMax TFloat, Remains TFloat, Price TFloat) ON COMMIT DROP;
    WITH
    --получаем список товаров с розничной ценой в пределах от inPriceMin до inPriceMax
    tmpPriceGoods AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                           , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                           
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                           INNER JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                                 AND (Price_Value.ValueData >= inPriceMin AND (Price_Value.ValueData <= inPriceMax OR inPriceMax = 0))
                                                 
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                      )
                     
  -- продажи за период по подразделению, просчет продаж с интервалом в N дней
  , tmpData_Container_ALL AS (SELECT tmp.*
                                   , SUM (tmp.Amount) OVER (PARTITION BY tmp.GoodsId) AS TotalAmount
                              FROM (SELECT MIContainer.ObjectId_analyzer               AS GoodsId
                                         , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                                         , tmpPriceGoods.Price                         AS Price
                                         , _tmpDateList.NumPeriod                      AS NumPeriod
                                    FROM MovementItemContainer AS MIContainer
                                         INNER JOIN tmpPriceGoods ON tmpPriceGoods.GoodsId = MIContainer.ObjectId_analyzer
                                         
                                         LEFT JOIN _tmpDateList ON _tmpDateList.OperDate = DATE_TRUNC ('DAY', MIContainer.OperDate)
                                         
                                    WHERE MIContainer.DescId = zc_MIContainer_Count()
                                      AND MIContainer.MovementDescId = zc_Movement_Check()
                                      AND MIContainer.WhereObjectId_analyzer = inUnitId
                                      AND MIContainer.OperDate >= inStartSale AND MIContainer.OperDate < inEndSale + INTERVAL '1 DAY'
                                    GROUP BY MIContainer.ObjectId_analyzer
                                           , _tmpDateList.NumPeriod, tmpPriceGoods.Price
                                    HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                                    --   AND SUM (COALESCE (-1 * MIContainer.Amount, 0)) >= inAmount
                                   ) AS tmp
                              -- WHERE tmp.Amount >= inAmount
                              )
  -- продажи за период по подразделению, ,без продаж меньше inAmount
  , tmpData_Container AS (SELECT tmpData_Container_ALL.*
                          FROM tmpData_Container_ALL
                          WHERE tmpData_Container_ALL.TotalAmount >= inAmount
                          )
                          
  --Выбираем период с мин и макс продажами
  , tmpMin_Max AS (SELECT tmp.GoodsId
                        , tmp.Price
                        , SUM (CASE WHEN tmp.OrdMax = 1 THEN tmp.Amount ELSE 0 END)     AS AmountMax
                        , SUM (CASE WHEN tmp.OrdMax = 1 THEN tmp.NumPeriod ELSE 0 END)  AS NumMax
                        , SUM (CASE WHEN tmp.OrdMin = 1 THEN tmp.Amount ELSE 0 END)     AS AmountMin
                        , SUM (CASE WHEN tmp.OrdMin = 1 THEN tmp.NumPeriod ELSE 0 END)  AS NumMin
                   FROM (
                         SELECT tmpData_Container.*
                              , ROW_NUMBER() OVER (PARTITION BY tmpData_Container.GoodsId ORDER BY tmpData_Container.Amount desc) AS OrdMax
                              , ROW_NUMBER() OVER (PARTITION BY tmpData_Container.GoodsId ORDER BY tmpData_Container.Amount )     AS OrdMin
                         FROM tmpData_Container 
                         WHERE tmpData_Container.NumPeriod <> vbPeriodCount -- 4 
                         ) AS tmp
                   WHERE tmp.OrdMax = 1 OR tmp.OrdMin = 1
                   GROUP BY tmp.GoodsId, tmp.Price
                   )
  -- остатки
  , tmpRemains AS (SELECT tmpPriceGoods.GoodsId                AS GoodsId
                        , SUM (COALESCE (Container.Amount, 0)) AS Amount_Remains
                   FROM tmpPriceGoods
                        LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                           AND Container.ObjectId = tmpPriceGoods.GoodsId
                                           AND Container.WhereObjectId = inUnitId
                                           AND Container.Amount <> 0
                   GROUP BY tmpPriceGoods.GoodsId
                   HAVING SUM (COALESCE (Container.Amount, 0)) <> 0
                  )
   -- Анализируем позиции, у которых продажи упали или выросли на NNN%, за последние N дней анализируемого периода попадают в отчет.                      
   INSERT INTO _tmpData (GoodsId, TotalAmount, Amount, AmountMin, NumMin, AmountMax, NumMax, Remains, Price)
               SELECT tmpData.GoodsId
                    , tmpData.TotalAmount AS TotalAmount
                    , tmpData.Amount      AS Amount
                    , CASE WHEN tmpData.Amount_WithOutPerSent >= tmpMin_Max.AmountMin THEN tmpMin_Max.AmountMin ELSE 0 END AS AmountMin   -- продажа выросла
                    , CASE WHEN tmpData.Amount_WithOutPerSent >= tmpMin_Max.AmountMin THEN tmpMin_Max.NumMin ELSE 0 END    AS NumMin      -- продажа выросла3
                    , CASE WHEN tmpData.Amount_WithPerSent <= tmpMin_Max.AmountMax    THEN tmpMin_Max.AmountMax ELSE 0 END AS AmountMax   -- продажа упала
                    , CASE WHEN tmpData.Amount_WithPerSent <= tmpMin_Max.AmountMax    THEN tmpMin_Max.NumMax ELSE 0 END    AS NumMax      -- продажа упала
                    
                    , COALESCE (tmpRemains.Amount_Remains, 0)  :: Tfloat AS Remains
                    , tmpData.Price                            :: Tfloat AS Price
                 FROM (SELECT tmpData_Container.*
                            , CASE WHEN tmpData_Container.NumPeriod = vbPeriodCount /*4*/ THEN (tmpData_Container.Amount + tmpData_Container.Amount * inChangePercent/100) ELSE 0 END AS Amount_WithPerSent
                            , CASE WHEN tmpData_Container.NumPeriod = vbPeriodCount /*4*/ THEN (tmpData_Container.Amount - tmpData_Container.Amount * inChangePercent/100) ELSE 0 END AS Amount_WithOutPerSent
                            --, SUM (tmpData_Container.Amount) OVER (PARTITION BY tmpData_Container.GoodsId) AS TotalAmount
                       FROM tmpData_Container

                       ) AS tmpData
                       LEFT JOIN tmpMin_Max ON tmpMin_Max.GoodsId = tmpData.GoodsId
                       LEFT JOIN tmpRemains ON tmpRemains.GoodsId = tmpData.GoodsId                                                                              
                 WHERE tmpData.NumPeriod = vbPeriodCount -- 4 
                   ;

   --проверяем для строк , возможно какойто товар выпал из отчета, такую строку удаляем
   
   -- уберем пометки удаления со всех (чтоб потом не мучаться если нужно восстановить)
   UPDATE MovementItem 
      SET isErased = FALSE
   WHERE MovementItem.MovementId = inMovementId;-- и мастера и чайлда
   
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
                                                  , inNumberMin    := COALESCE (_tmpData.NumMin, 0)     ::TFloat
                                                  , inNumberMax    := COALESCE (_tmpData.NumMax, 0)     ::TFloat
                                                  , inRemains      := COALESCE (_tmpData.Remains, 0)    ::TFloat
                                                  , inPrice        := COALESCE (_tmpData.Price, 0)      ::TFloat
                                                  , inUserId       := vbUserId
                                                  )
   FROM _tmpData   
       LEFT JOIN _tmpMI ON _tmpMI.GoodsId = _tmpData.GoodsId;



   -- сохраняем чайлд 
   
   CREATE TEMP TABLE _tmpMI_Child (Id Integer, MarginCategoryItemId Integer) ON COMMIT DROP;
   -- уже сохраненные данные  
   INSERT INTO _tmpMI_Child (Id, MarginCategoryItemId)
               SELECT MovementItem.Id 
                    , MovementItem.ObjectId
               FROM MovementItem
               WHERE MovementItem.MovementId = inMovementId
                 ANd MovementItem.DescId = zc_MI_Child()
               ;
   -- находим категорию наценки
   vbMarginCategoryId := (SELECT DISTINCT ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId
                          FROM ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                               LEFT JOIN  ObjectLink AS ObjectLink_MarginCategoryLink_MarginCategory 
                                                     ON ObjectLink_MarginCategoryLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                                    AND ObjectLink_MarginCategoryLink_MarginCategory.DescId = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                          
                               LEFT JOIN Object AS Object_MarginCategory
                                                ON Object_MarginCategory.Id = ObjectLink_MarginCategoryLink_MarginCategory.ChildObjectId
                                               AND Object_MarginCategory.isErased = FALSE
                          
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent 	
                                                     ON ObjectFloat_Percent.ObjectId = Object_MarginCategory.Id
                                                    AND ObjectFloat_Percent.DescId = zc_ObjectFloat_MarginCategory_Percent()
                          WHERE ObjectLink_MarginCategoryLink_Unit.DescId = zc_ObjectLink_MarginCategoryLink_Unit()
                           AND  ObjectLink_MarginCategoryLink_Unit.ChildObjectId = inUnitId --183293 --подразделение
                          AND COALESCE (ObjectFloat_Percent.ValueData, 0) = 0
                          );
   
   CREATE TEMP TABLE _tmpMarginCategoryItem (Id Integer, MarginPercent TFloat) ON COMMIT DROP;
   INSERT INTO _tmpMarginCategoryItem (Id, MarginPercent)
               SELECT Object_MarginCategoryItem.Id
                    , Object_MarginCategoryItem.MarginPercent
               FROM Object_MarginCategoryItem_View AS Object_MarginCategoryItem
                    INNER JOIN Object AS MarginCategoryItem 
                                      ON MarginCategoryItem.Id = Object_MarginCategoryItem.Id
                                     AND MarginCategoryItem.isErased = FALSE
               WHERE Object_MarginCategoryItem.MarginCategoryId = vbMarginCategoryId;
      
   --метим на удаление строки, которых нет в выборке        
   WITH 
   tmpMI_Del AS (SELECT COALESCE (_tmpMI_Child.Id, 0) AS Id
                 FROM _tmpMarginCategoryItem
                     FULL JOIN _tmpMI_Child ON _tmpMI_Child.MarginCategoryItemId = _tmpMarginCategoryItem.Id
                 WHERE _tmpMarginCategoryItem.Id IS NULL
                 )
   UPDATE MovementItem 
         SET isErased = TRUE 
   WHERE MovementItem.Id IN (SELECT tmpMI_Del.Id FROM tmpMI_Del);
   
   PERFORM lpInsertUpdate_MI_MarginCategory_Child (ioId                   := COALESCE (_tmpMI_Child.Id, 0)           ::integer
                                                 , inMovementId           := inMovementId                            ::integer
                                                 , inMarginCategoryItemId := _tmpMarginCategoryItem.Id               ::integer
                                                 , inAmount               := _tmpMarginCategoryItem.MarginPercent    ::TFloat
                                                 , inUserId               := vbUserId
                                                 )
   FROM _tmpMarginCategoryItem   
        LEFT JOIN _tmpMI_Child ON _tmpMI_Child.MarginCategoryItemId = _tmpMarginCategoryItem.Id;
    
   
   -- сохранили протокол
   -- сохранили свойство <Дата корректировки>
   PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), inMovementId, CURRENT_TIMESTAMP);
   -- сохранили свойство <Пользователь (создание)>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), inMovementId, vbUserId);    
        
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