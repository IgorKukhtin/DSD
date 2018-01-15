-- Function:  gpReport_Movement_Check_Cross()

DROP FUNCTION IF EXISTS gpReport_Movement_Check_Cross (Integer, TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check_Cross (Integer, TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_Movement_Check_Cross (Integer, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_Check_Cross(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inIsFarm           Boolean,    -- 
    IN inShowAll          Boolean,    --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbDayCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;

   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
   DECLARE vbUnitId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- !!!меняем параметр!!!
    IF inIsFarm = TRUE THEN vbUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
    END IF;

    IF COALESCE (vbUnitId, 0)<> 0 THEN inUnitId:= vbUnitId; END IF;

    vbDateStartPromo := date_trunc('month', inStartDate);
    vbDatEndPromo := date_trunc('month', inEndDate) + interval '1 month'; 
    
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES ( inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate;

     CREATE TEMP TABLE tmpDatePromo ON COMMIT DROP AS
        SELECT date_trunc('month', tmp.OperDate) AS OperDate
             , count (date_trunc('month', tmp.OperDate)) :: Tfloat AS DayMonth
        FROM (SELECT GENERATE_SERIES ( vbDateStartPromo, vbDatEndPromo - interval '1 day' , '1 DAY' :: INTERVAL) AS OperDate) AS tmp
        GROUP BY date_trunc('month', tmp.OperDate);
 
 CREATE TEMP TABLE _tmpMovPromoUnit (GoodsId Integer, Amount Tfloat, AmountPlanMax Tfloat) ON COMMIT DROP;
    INSERT INTO _tmpMovPromoUnit (GoodsId, Amount, AmountPlanMax)
    WITH
        tmpKoef AS (SELECT tmp.OperDate
                         , CAST (tmp.CountDays / tmpDatePromo.DayMonth AS  NUMERIC (15,4)) AS Amount
                    FROM
                        (SELECT date_trunc('month', tmpOperDate.OperDate) AS OperDate
                              , count (date_trunc('month', tmpOperDate.OperDate)) :: Tfloat AS CountDays
                         FROM tmpOperDate
                         GROUP BY date_trunc('month', tmpOperDate.OperDate)
                        ) AS tmp
                      LEFT JOIN tmpDatePromo ON tmpDatePromo.Operdate =  tmp.OperDate
                    )

    --  данные из "план по маркетингу для точек"
   , tmpMovPromoUnit AS (SELECT DATE_TRUNC ('month', Movement.OperDate) AS OperDate
                              , MovementItem.ObjectId                 AS GoodsId
                              , SUM (MovementItem.Amount)             AS Amount
                              , SUM (MIFloat_AmountPlanMax.ValueData) AS AmountPlanMax 
                         FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                     AND MovementLinkObject_Unit.ObjectId = inUnitId

                              INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId = zc_MI_Master()
                                                     AND MovementItem.isErased = FALSE 
                              LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                          ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                         AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                         WHERE Movement.DescId = zc_Movement_PromoUnit()
                           AND Movement.OperDate >= vbDateStartPromo AND Movement.OperDate < vbDatEndPromo
                           AND Movement.StatusId = zc_Enum_Status_Complete()
                         GROUP BY DATE_TRUNC ('month', Movement.OperDate)
                                , MovementItem.ObjectId    
                         )

               SELECT tmpMovPromoUnit.GoodsId
                    , SUM (tmpMovPromoUnit.Amount * tmpKoef.Amount)        AS Amount
                    , SUM (tmpMovPromoUnit.AmountPlanMax * tmpKoef.Amount) AS AmountPlanMax 
               FROM tmpMovPromoUnit
                    LEFT JOIN tmpKoef ON tmpKoef.OperDate = tmpMovPromoUnit.OperDate
                GROUP BY tmpMovPromoUnit.GoodsId
               ;

 CREATE TEMP TABLE tmpContainer (OperDate Tdatetime, GoodsId Integer, Amount Tfloat) ON COMMIT DROP;
    INSERT INTO tmpContainer (OperDate, GoodsId, Amount )
                         SELECT date_trunc('day', MIContainer.OperDate) AS OperDate
                              , MIContainer.ObjectId_analyzer AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                         FROM MovementItemContainer AS MIContainer
                         WHERE MIContainer.DescId = zc_MIContainer_Count()
                           AND MIContainer.MovementDescId = zc_Movement_Check()
                           AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 DAY'
                           AND MIContainer.WhereObjectId_analyzer = inUnitId
                         GROUP BY MIContainer.OperDate
                                , MIContainer.ObjectId_analyzer 
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0;

 CREATE TEMP TABLE _tmpGoods (GoodsId Integer, Price TFloat) ON COMMIT DROP;
    INSERT INTO _tmpGoods (GoodsId, Price)
               SELECT tmp.GoodsId, COALESCE (ObjectHistoryFloat_Price.ValueData, 0) AS Price
               FROM 
                  (SELECT DISTINCT _tmpMovPromoUnit.GoodsId FROM _tmpMovPromoUnit
                  UNION
                  SELECT DISTINCT tmpContainer.GoodsId FROM tmpContainer WHERE inShowAll = True
                  ) AS tmp
               LEFT JOIN Object_Price_View AS Object_Price ON Object_Price.GoodsId  = tmp.GoodsId
                                                          AND Object_Price.UnitId = inUnitId 
               -- получаем значения цены и НТЗ из истории значений на дату на начало                                                          
               LEFT JOIN ObjectHistory AS ObjectHistory_Price
                                       ON ObjectHistory_Price.ObjectId = Object_Price.Id
                                      AND ObjectHistory_Price.DescId = zc_ObjectHistory_Price()
                                      AND inStartDate >= ObjectHistory_Price.StartDate AND inStartDate < ObjectHistory_Price.EndDate
               LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Price
                                            ON ObjectHistoryFloat_Price.ObjectHistoryId = ObjectHistory_Price.Id
                                           AND ObjectHistoryFloat_Price.DescId = zc_ObjectHistoryFloat_Price_Value()
               ;

   -- все данные за месяц
   CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
                      SELECT tmpOperDate.operdate
                           , COALESCE(tmpContainer.GoodsId, 0) AS GoodsId
                           , SUM (tmpContainer.Amount) AS Amount
                      FROM tmpOperDate
                           INNER JOIN tmpContainer ON tmpContainer.operDate = tmpOperDate.OperDate
                           INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmpContainer.GoodsId
                      GROUP BY COALESCE(tmpContainer.GoodsId, 0), tmpOperDate.operdate
                      ORDER BY 1
                      ;

     vbIndex := 0;
     -- именно так, из-за перехода времени кол-во дней может быть разное
     vbDayCount := (SELECT COUNT(*) FROM tmpOperDate);

     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbDayCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] AS Value'||vbIndex||'  '||
                          ', DAY' || vbIndex || '[2]::Integer  AS TypeId'||vbIndex||' ';
     END LOOP;


     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
               FROM tmpOperDate
                   LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                   LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1 
               ;  
     RETURN NEXT cur1;
    

     vbQueryText := '
          SELECT Object_Goods.Id                 AS GoodsId
               , Object_Goods.ObjectCode         AS GoodsCode
               , Object_Goods.ValueData          AS GoodsName
               , Object_GoodsGroup.ValueData     AS GoodsGroupName
               , _tmpMovPromoUnit.Amount         AS PromoAmount
               , _tmpMovPromoUnit.AmountPlanMax  AS PromoAmountPlanMax
               , _tmpGoods.Price
               , (_tmpMovPromoUnit.Amount * _tmpGoods.Price)         AS PromoSum
               , (_tmpMovPromoUnit.AmountPlanMax * _tmpGoods.Price)  AS PromoPlanMaxSum
               , tmpData.Amount                  AS TotalAmount
               , CASE WHEN (_tmpMovPromoUnit.Amount - COALESCE(tmpData.Amount,0)) > 0 THEN (_tmpMovPromoUnit.Amount - COALESCE(tmpData.Amount,0)) ELSE 0 END AS PromoAmountDiff
               , CASE WHEN (_tmpMovPromoUnit.AmountPlanMax  - COALESCE(tmpData.Amount,0)) > 0 THEN (_tmpMovPromoUnit.AmountPlanMax  - COALESCE(tmpData.Amount,0)) ELSE 0 END AS PromoAmountPlanMaxDiff
            '|| vbFieldNameText ||'
          FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.GoodsId, Object_Data.GoodsId)           -- AS GoodsId
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.OperDate, Object_Data.OperDate) AS OperDate
                                         , ARRAY[ COALESCE(Movement_Data.Amount,0) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT * FROM tmpMI) AS Movement_Data
                                        FULL JOIN  
                                         (SELECT tmpOperDate.operdate, 0, 
                                                 COALESCE(_tmpGoods.GoodsId, 0) AS GoodsId 

                                            FROM tmpOperDate, _tmpGoods 
                                        ) AS Object_Data
                                           ON Object_Data.OperDate = Movement_Data.OperDate
                                          AND Object_Data.GoodsId = Movement_Data.GoodsId
                                  order by 1,2''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = D.Key[1]
         LEFT JOIN _tmpMovPromoUnit ON _tmpMovPromoUnit.GoodsId = D.Key[1]
         LEFT JOIN (SELECT tmpMI.GoodsId, SUM(tmpMI.Amount) AS Amount FROM tmpMI GROUP BY tmpMI.GoodsId) AS tmpData ON tmpData.GoodsId = D.Key[1]
         LEFT JOIN _tmpGoods ON _tmpGoods.GoodsId = D.Key[1]
         
         LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                              ON ObjectLink_Goods_GoodsGroup.ObjectId = _tmpGoods.GoodsId
                             AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
         LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        ORDER BY Object_Goods.ValueData
        ';


     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 08.02.17         *
*/

-- тест
-- SELECT * FROM gpReport_Movement_Check_Cross(inUnitId := 183292 , inDateStart := ('01.02.2016')::TDateTime , inDateFinal := ('29.02.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
-- SELECT * FROM gpReport_Movement_Check_Cross (inUnitId:= 0, inDateStart:= '20150801'::TDateTime, inDateFinal:= '20150810'::TDateTime, inIsPartion:= FALSE, inSession:= '3')
