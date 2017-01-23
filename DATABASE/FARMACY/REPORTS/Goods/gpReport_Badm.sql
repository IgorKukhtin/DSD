-- Function:  gpReport_Badm()
DROP FUNCTION IF EXISTS gpReport_Badm (TDateTime, TDateTime, TVarChar);



CREATE OR REPLACE FUNCTION  gpReport_Badm(
    IN inStartDate        TDateTime,  -- Дата начала
    IN inEndDate          TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode   Integer, GoodsName   TVarChar
             , RemainsEnd1 TFloat, Amount_Sale1 TFloat
             , RemainsEnd2 TFloat, Amount_Sale2 TFloat
             , RemainsEnd3 TFloat, Amount_Sale3 TFloat
             , RemainsEnd4 TFloat, Amount_Sale4 TFloat
             , RemainsEnd5 TFloat, Amount_Sale5 TFloat
             , RemainsEnd6 TFloat, Amount_Sale6 TFloat
             , RemainsEnd7 TFloat, Amount_Sale7 TFloat
             , RemainsEnd8 TFloat, Amount_Sale8 TFloat
             , RemainsEnd9 TFloat, Amount_Sale9 TFloat
             , RemainsEnd10 TFloat, Amount_Sale10 TFloat
             , RemainsEnd11 TFloat, Amount_Sale11 TFloat
             , RemainsEnd12 TFloat, Amount_Sale12 TFloat
             , RemainsEnd13 TFloat, Amount_Sale13 TFloat
             , RemainsEnd14 TFloat, Amount_Sale14 TFloat
             , RemainsEnd15 TFloat, Amount_Sale15 TFloat
             , RemainsEnd16 TFloat, Amount_Sale16 TFloat
             , RemainsEnd17 TFloat, Amount_Sale17 TFloat
             , RemainsEnd18 TFloat, Amount_Sale18 TFloat
             , RemainsEnd19 TFloat, Amount_Sale19 TFloat
             , RemainsEnd20 TFloat, Amount_Sale20 TFloat
             , RemainsEnd21 TFloat, Amount_Sale21 TFloat
             , RemainsEnd22 TFloat, Amount_Sale22 TFloat
             , RemainsEnd23 TFloat, Amount_Sale23 TFloat
             , RemainsEnd24 TFloat, Amount_Sale24 TFloat
             , RemainsEnd25 TFloat, Amount_Sale25 TFloat
             , RemainsEnd26 TFloat, Amount_Sale26 TFloat
             , RemainsEnd27 TFloat, Amount_Sale27 TFloat
             , RemainsEnd28 TFloat, Amount_Sale28 TFloat
             , RemainsEnd29 TFloat, Amount_Sale29 TFloat
             , RemainsEnd30 TFloat, Amount_Sale30 TFloat
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitCount Integer;
  -- DECLARE vbObjectId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    --vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- отбросили время
    inStartDate:= DATE_TRUNC ('DAY', inStartDate);
    inEndDate  := DATE_TRUNC ('DAY', inEndDate);


    -- Результат
    RETURN QUERY
      WITH 
      -- Подразделения для отчета
      tmpUnit AS (SELECT ObjectBoolean_Unit_UploadBadm.ObjectId  AS UnitId
                       , ROW_NUMBER() OVER (ORDER BY ObjectBoolean_Unit_UploadBadm.ObjectId) AS Num
                  FROM ObjectBoolean AS ObjectBoolean_Unit_UploadBadm
                  WHERE ObjectBoolean_Unit_UploadBadm.DescId = zc_ObjectBoolean_Unit_UploadBadm()
                    AND ObjectBoolean_Unit_UploadBadm.ValueData = TRUE
                  )
      -- Товары для отчета
      , tmpGoods_Jur AS ( SELECT ObjectLink_LinkGoods_GoodsMain.ChildObjectId               AS GoodsMainId
                               , MAX (ObjectLink_Goods_Object.ObjectId) AS GoodsId_Jur
                          FROM ObjectBoolean AS ObjectBoolean_Goods_UploadBadm
                          -- поставщик БаДМ
                              INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ObjectId = ObjectBoolean_Goods_UploadBadm.Objectid
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                     AND ObjectLink_Goods_Object.ChildObjectId = 59610--inObjectId

                              LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                     ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                    AND ObjectLink_LinkGoods_Goods.ChildObjectId =  ObjectLink_Goods_Object.ObjectId  --

                              LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                     ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                                    AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          WHERE ObjectBoolean_Goods_UploadBadm.DescId = zc_ObjectBoolean_Goods_UploadBadm()
                            AND ObjectBoolean_Goods_UploadBadm.ValueData = TRUE
                          GROUP BY ObjectLink_LinkGoods_GoodsMain.ChildObjectId    
                         )
       -- товары сети
      , tmpGoods AS (SELECT ObjectLink_Child.ChildObjectId AS GoodsId
                          , tmpGoods_Jur.GoodsId_Jur
                     FROM tmpGoods_Jur
                          -- связь с товарами сети
                          LEFT JOIN ObjectLink AS ObjectLink_Main 
                                 ON ObjectLink_Main.ChildObjectId = tmpGoods_Jur.GoodsMainId
                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                          LEFT JOIN ObjectLink AS ObjectLink_Child 
                                 ON ObjectLink_Child.ObjectId = ObjectLink_Main.ObjectId
                                AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()

                          -- связь с Торговая сеть или ...
                          INNER JOIN ObjectLink AS ObjectLink_Goods_Retail
                                  ON ObjectLink_Goods_Retail.ObjectId = ObjectLink_Child.ChildObjectId
                                 AND ObjectLink_Goods_Retail.DescId = zc_ObjectLink_Goods_Object()
                          INNER JOIN Object AS Object_GoodsObject
                                  ON Object_GoodsObject.Id = ObjectLink_Goods_Retail.ChildObjectId
                                 AND COALESCE (Object_GoodsObject.DescId, 0) = zc_Object_Retail()
                      )

       -- таблица остатков
      , tmpRemains AS (SELECT tmp.UnitId
                            , tmp.GoodsId
                            , SUM (tmp.RemainsEnd) AS RemainsEnd
                       FROM (SELECT tmpUnit.UnitId
                                  , Container.ObjectId   AS GoodsId
                                  , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS RemainsEnd
                            FROM Container
                                 INNER JOIN tmpUnit ON tmpUnit.UnitId = Container.WhereObjectId
                                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId
                                 LEFT JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate > inEndDate
                                                               -- AND MIContainer.OperDate > '02.12.2016' --inEndDate
                            WHERE Container.DescId = zc_Container_Count()
                            GROUP BY tmpUnit.UnitId
                                   , Container.ObjectId
                                   , Container.Amount
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                            ) AS tmp
                       GROUP BY tmp.UnitId
                              , tmp.GoodsId
                       )
      -- чеки, определение периода прожажи  --  ,  tmpCheck_ALL 
     /* , tmpCheck AS (SELECT MIContainer.WhereObjectId_analyzer AS UnitId
                          , MIContainer.ObjectId_analyzer               AS GoodsId
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount_Sale
                     FROM MovementItemContainer AS MIContainer
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                      WHERE MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.MovementDescId = zc_Movement_Check()
                        AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 Day'
                         --AND MIContainer.OperDate >= '01.12.2016' AND MIContainer.OperDate < '02.12.2016'
                      GROUP BY MIContainer.WhereObjectId_analyzer
                             , MIContainer.ObjectId_analyzer
                      HAVING SUM(COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                      ) 
*/
      , tmpCheck AS (SELECT MIContainer.WhereObjectId_analyzer AS UnitId
                          , MIContainer.ObjectId_analyzer               AS GoodsId
                          , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount_Sale
                     FROM tmpGoods
                          LEFT JOIN MovementItemContainer AS MIContainer
                                                          ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                                                         AND MIContainer.DescId = zc_MIContainer_Count()
                                                         AND MIContainer.MovementDescId = zc_Movement_Check()
                                                         AND MIContainer.OperDate >= inStartDate AND MIContainer.OperDate < inEndDate + INTERVAL '1 Day'
                                                          --AND MIContainer.OperDate >= '01.12.2016' AND MIContainer.OperDate < '02.12.2016' 
                          INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                          --INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_analyzer
                      GROUP BY MIContainer.WhereObjectId_analyzer
                             , MIContainer.ObjectId_analyzer
                      HAVING SUM(COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                      ) 

        --результат
  SELECT Object_Goods.ObjectCode           AS GoodsCode
       , Object_Goods.ValueData            AS GoodsName
       , Sum(tmp.RemainsEnd1)      ::TFloat
       , Sum(tmp.Amount_Sale1)     ::TFloat
       , Sum(tmp.RemainsEnd2)      ::TFloat
       , Sum(tmp.Amount_Sale2)     ::TFloat
       , Sum(tmp.RemainsEnd3)      ::TFloat
       , Sum(tmp.Amount_Sale3)     ::TFloat
       , Sum(tmp.RemainsEnd4)      ::TFloat
       , Sum(tmp.Amount_Sale4)     ::TFloat
       , Sum(tmp.RemainsEnd5)      ::TFloat
       , Sum(tmp.Amount_Sale5)     ::TFloat
       , Sum(tmp.RemainsEnd6)      ::TFloat
       , Sum(tmp.Amount_Sale6)     ::TFloat
       , Sum(tmp.RemainsEnd7)      ::TFloat
       , Sum(tmp.Amount_Sale7)     ::TFloat
       , Sum(tmp.RemainsEnd8)      ::TFloat
       , Sum(tmp.Amount_Sale8)     ::TFloat
       , Sum(tmp.RemainsEnd9)      ::TFloat
       , Sum(tmp.Amount_Sale9)     ::TFloat
       , Sum(tmp.RemainsEnd10)      ::TFloat
       , Sum(tmp.Amount_Sale10)     ::TFloat
       , Sum(tmp.RemainsEnd11)      ::TFloat
       , Sum(tmp.Amount_Sale11)     ::TFloat
       , Sum(tmp.RemainsEnd12)      ::TFloat
       , Sum(tmp.Amount_Sale12)     ::TFloat
       , Sum(tmp.RemainsEnd13)      ::TFloat
       , Sum(tmp.Amount_Sale13)     ::TFloat
       , Sum(tmp.RemainsEnd14)      ::TFloat
       , Sum(tmp.Amount_Sale14)     ::TFloat
       , Sum(tmp.RemainsEnd15)      ::TFloat
       , Sum(tmp.Amount_Sale15)     ::TFloat
       , Sum(tmp.RemainsEnd16)      ::TFloat
       , Sum(tmp.Amount_Sale16)     ::TFloat
       , Sum(tmp.RemainsEnd17)      ::TFloat
       , Sum(tmp.Amount_Sale17)     ::TFloat
       , Sum(tmp.RemainsEnd18)      ::TFloat
       , Sum(tmp.Amount_Sale18)     ::TFloat
       , Sum(tmp.RemainsEnd19)      ::TFloat
       , Sum(tmp.Amount_Sale19)     ::TFloat
       , Sum(tmp.RemainsEnd20)      ::TFloat
       , Sum(tmp.Amount_Sale20)     ::TFloat
       , Sum(tmp.RemainsEnd21)      ::TFloat
       , Sum(tmp.Amount_Sale21)     ::TFloat
       , Sum(tmp.RemainsEnd22)      ::TFloat
       , Sum(tmp.Amount_Sale22)     ::TFloat
       , Sum(tmp.RemainsEnd23)      ::TFloat
       , Sum(tmp.Amount_Sale23)     ::TFloat
       , Sum(tmp.RemainsEnd24)      ::TFloat
       , Sum(tmp.Amount_Sale24)     ::TFloat
       , Sum(tmp.RemainsEnd25)      ::TFloat
       , Sum(tmp.Amount_Sale25)     ::TFloat
       , Sum(tmp.RemainsEnd26)      ::TFloat
       , Sum(tmp.Amount_Sale26)     ::TFloat
       , Sum(tmp.RemainsEnd27)      ::TFloat
       , Sum(tmp.Amount_Sale27)     ::TFloat
       , Sum(tmp.RemainsEnd28)      ::TFloat
       , Sum(tmp.Amount_Sale28)     ::TFloat
       , Sum(tmp.RemainsEnd29)      ::TFloat
       , Sum(tmp.Amount_Sale29)     ::TFloat
       , Sum(tmp.RemainsEnd30)      ::TFloat
       , Sum(tmp.Amount_Sale30)     ::TFloat
  FROM (
        SELECT tmpGoods.GoodsId
             , tmpGoods.GoodsId_Jur
             , CASE WHEN tmpUnit.Num = 1 THEN tmpRemains.RemainsEnd ELSE 0 END  AS RemainsEnd1
             , CASE WHEN tmpUnit.Num = 1 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale1
             , CASE WHEN tmpUnit.Num = 2 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd2
             , CASE WHEN tmpUnit.Num = 2 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale2
             , CASE WHEN tmpUnit.Num = 3 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd3
             , CASE WHEN tmpUnit.Num = 3 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale3
             , CASE WHEN tmpUnit.Num = 4 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd4
             , CASE WHEN tmpUnit.Num = 4 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale4
             , CASE WHEN tmpUnit.Num = 5 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd5
             , CASE WHEN tmpUnit.Num = 5 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale5
             , CASE WHEN tmpUnit.Num = 6 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd6
             , CASE WHEN tmpUnit.Num = 6 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale6
             , CASE WHEN tmpUnit.Num = 7 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd7
             , CASE WHEN tmpUnit.Num = 7 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale7
             , CASE WHEN tmpUnit.Num = 8 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd8
             , CASE WHEN tmpUnit.Num = 8 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale8
             , CASE WHEN tmpUnit.Num = 9 THEN tmpRemains.RemainsEnd ELSE 0 END    AS RemainsEnd9
             , CASE WHEN tmpUnit.Num = 9 THEN tmpCheck.Amount_Sale ELSE 0 END     AS Amount_Sale9
             , CASE WHEN tmpUnit.Num = 10 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd10
             , CASE WHEN tmpUnit.Num = 10 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale10
             , CASE WHEN tmpUnit.Num = 11 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd11
             , CASE WHEN tmpUnit.Num = 11 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale11
             , CASE WHEN tmpUnit.Num = 12 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd12
             , CASE WHEN tmpUnit.Num = 12 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale12
             , CASE WHEN tmpUnit.Num = 13 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd13
             , CASE WHEN tmpUnit.Num = 13 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale13
             , CASE WHEN tmpUnit.Num = 14 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd14
             , CASE WHEN tmpUnit.Num = 14 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale14
             , CASE WHEN tmpUnit.Num = 15 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd15
             , CASE WHEN tmpUnit.Num = 15 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale15
             , CASE WHEN tmpUnit.Num = 16 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd16
             , CASE WHEN tmpUnit.Num = 16 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale16
             , CASE WHEN tmpUnit.Num = 17 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd17
             , CASE WHEN tmpUnit.Num = 17 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale17
             , CASE WHEN tmpUnit.Num = 18 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd18
             , CASE WHEN tmpUnit.Num = 18 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale18
             , CASE WHEN tmpUnit.Num = 19 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd19
             , CASE WHEN tmpUnit.Num = 19 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale19
             , CASE WHEN tmpUnit.Num = 20 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd20
             , CASE WHEN tmpUnit.Num = 20 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale20
             , CASE WHEN tmpUnit.Num = 21 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd21
             , CASE WHEN tmpUnit.Num = 21 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale21
             , CASE WHEN tmpUnit.Num = 22 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd22
             , CASE WHEN tmpUnit.Num = 22 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale22
             , CASE WHEN tmpUnit.Num = 23 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd23
             , CASE WHEN tmpUnit.Num = 23 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale23
             , CASE WHEN tmpUnit.Num = 24 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd24
             , CASE WHEN tmpUnit.Num = 24 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale24
             , CASE WHEN tmpUnit.Num = 25 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd25
             , CASE WHEN tmpUnit.Num = 25 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale25
             , CASE WHEN tmpUnit.Num = 26 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd26
             , CASE WHEN tmpUnit.Num = 26 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale26
             , CASE WHEN tmpUnit.Num = 27 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd27
             , CASE WHEN tmpUnit.Num = 27 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale27
             , CASE WHEN tmpUnit.Num = 28 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd28
             , CASE WHEN tmpUnit.Num = 28 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale28
             , CASE WHEN tmpUnit.Num = 29 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd29
             , CASE WHEN tmpUnit.Num = 29 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale29
             , CASE WHEN tmpUnit.Num = 30 THEN tmpRemains.RemainsEnd ELSE 0 END   AS RemainsEnd30
             , CASE WHEN tmpUnit.Num = 30 THEN tmpCheck.Amount_Sale ELSE 0 END    AS Amount_Sale30

        FROM tmpUnit
             LEFT JOIN tmpGoods ON 1=1
             LEFT JOIN tmpRemains ON tmpRemains.UnitId  = tmpUnit.UnitId
                                 AND tmpRemains.GoodsId = tmpGoods.GoodsId
             LEFT JOIN tmpCheck ON tmpCheck.UnitId  = tmpUnit.UnitId
                               AND tmpCheck.GoodsId = tmpGoods.GoodsId
        
        ) AS tmp
       LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId_Jur
  GROUP BY Object_Goods.ObjectCode
         , Object_Goods.ValueData 
             
;             
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 18.01.17         *
*/

-- тест
--
--SELECT * FROM gpReport_Badm(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('01.12.2016')::TDateTime , inSession := '3');