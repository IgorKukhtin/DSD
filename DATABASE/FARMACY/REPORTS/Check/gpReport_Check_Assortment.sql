-- Function:  gpReport_Movement_Check_Light()

DROP FUNCTION IF EXISTS gpReport_Check_Assortment (Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Check_Assortment(
    IN inUnitId           Integer  ,  -- Подразделение
    --IN inRetailId         Integer  ,  -- ссылка на торг.сеть
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inisUnitList       Boolean,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  GoodsId        Integer, 
  GoodsMainId    Integer, 
  GoodsCode      Integer, 
  GoodsName      TVarChar,
  GoodsGroupName TVarChar, 
  NDSKindName    TVarChar,
  NDS            TFloat,
  ConditionsKeepName    TVarChar,
  Amount                TFloat,
  PriceSale             TFloat,
  SummaSale             TFloat,
  CountUnit             TFloat,
  MCS_Value             TFloat,
  UnitName              Tblob,
  
  IsClose Boolean, UpdateDate TDateTime,
  isTop boolean, isFirst boolean, isSecond boolean,
  isSP Boolean, isPromo boolean,
  MCSNotRecalc boolean
)
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbDateStartPromo TDateTime;
   DECLARE vbDatEndPromo TDateTime;
   DECLARE vbRetailId    Integer;
   DECLARE vbCountUnit   TFloat;
   DECLARE vbName        TVarChar;
   DECLARE vbIndex       Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    
    -- торговая сеть текущей аптеки 
    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     AND ObjectLink_Unit_Juridical.ObjectId = inUnitId);
                    
    -- количество точек в торг.сети
    vbCountUnit := (SELECT Count(*)
                    FROM ObjectLink AS ObjectLink_Unit_Juridical
                         INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                              AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                              AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                    );
   
    -- Результат
    RETURN QUERY
    WITH
     tmpUnit AS (SELECT inUnitId AS UnitId
                 WHERE COALESCE (inUnitId, 0) <> 0 
                UNION 
                 SELECT ObjectLink_Unit_Juridical.ObjectId     AS UnitId
                 FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                           AND ObjectLink_Juridical_Retail.ChildObjectId = vbRetailId
                 WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   AND inisUnitList = FALSE
                UNION
                 SELECT ObjectBoolean_Report.ObjectId          AS UnitId
                 FROM ObjectBoolean AS ObjectBoolean_Report
                 WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Unit_Report()
                   AND ObjectBoolean_Report.ValueData = TRUE
                   AND inisUnitList = TRUE
              )
             
             
   -- продажи за период по всем выбранным подразделениям
   , tmpContainer AS (SELECT MIContainer.WhereObjectId_analyzer          AS UnitId
                           , MIContainer.ObjectId_analyzer               AS GoodsId
                           , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                           , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIContainer.Price,0)) AS SummaSale
                      FROM MovementItemContainer AS MIContainer
                           INNER JOIN tmpUnit ON tmpUnit.UnitId = MIContainer.WhereObjectId_analyzer
                      WHERE MIContainer.DescId = zc_MIContainer_Count()
                        AND MIContainer.MovementDescId = zc_Movement_Check()
                        AND MIContainer.OperDate >= inDateStart AND MIContainer.OperDate < inDateFinal + INTERVAL '1 DAY'
                      GROUP BY MIContainer.ObjectId_analyzer
                             , MIContainer.WhereObjectId_analyzer 
                      HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                      )

   -- товары, остаток <> 0, текущей аптеки  --  товары сети
   , tmpRemains_Ret AS (SELECT tmp.GoodsId
                             , SUM (tmp.Amount)    AS Amount
                        FROM (SELECT Container.Objectid      AS GoodsId
                                   , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0))  AS Amount
                              FROM Container 
                                   LEFT JOIN MovementItemContainer AS MIContainer
                                                                   ON MIContainer.ContainerId = Container.Id
                                                                  AND MIContainer.OperDate >= inDateFinal --inDateStart
                              WHERE Container.WhereObjectId = inUnitId
                                AND Container.DescId = zc_Container_Count()
                              GROUP BY Container.Objectid, Container.Amount
                              HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0
                              ) AS tmp
                        GROUP BY tmp.GoodsId
                        HAVING SUM (tmp.Amount) <> 0
                       )

   -- НТЗ , Спецконтроль кода текущей аптеки
   , tmpPrice_Ret AS (SELECT Price_Goods.ChildObjectId                AS GoodsId
                           , COALESCE(MCS_Value.ValueData, 0)         AS MCS_Value
                           , COALESCE(MCS_NotRecalc.ValueData, False) AS MCSNotRecalc
                      FROM ObjectLink AS ObjectLink_Price_Unit
                         LEFT JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         LEFT JOIN ObjectFloat AS MCS_Value
                                               ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                              AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                                             -- AND COALESCE(MCS_Value.ValueData,0) = 0
                         LEFT JOIN ObjectBoolean AS MCS_NotRecalc
                                                 ON MCS_NotRecalc.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_NotRecalc.DescId = zc_ObjectBoolean_Price_MCSNotRecalc()
                      WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                        AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                        --AND COALESCE(MCS_Value.ValueData,0) = 0
                      )

    -- Товары соц-проект (документ)
   , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                    FROM lpSelect_MovementItem_GoodsSPUnit_onDate (inStartDate:= inDateStart, inEndDate:= inDateFinal, inUnitId := inUnitId) AS tmp
                    )

   -- связь товара сети и главного товара и свойства 
   , tmpGoods AS (SELECT tmp.GoodsId                                                   AS GoodsId
                       , ObjectLink_Main.ChildObjectId                                 AS GoodsMainId
                       , COALESCE (tmpGoodsSP.isSP, False)                   ::Boolean AS isSP
                  FROM (SELECT DISTINCT tmpContainer.GoodsId
                        FROM tmpContainer
                       UNION
                        SELECT DISTINCT tmpRemains_Ret.GoodsId
                        FROM tmpRemains_Ret
                       UNION
                        SELECT tmpPrice_Ret.GoodsId
                        FROM tmpPrice_Ret
                        ) AS tmp
                       -- получается GoodsMainId
                       LEFT JOIN ObjectLink AS ObjectLink_Child ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                             AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                       LEFT JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                             AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()

                       LEFT JOIN tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId
                       /*LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_SP 
                              ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                             AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()*/
                  )
                  
   -- + главный товар
   , tmpData_Container AS (SELECT tmp.UnitId
                                , tmp.GoodsId
                                , tmpGoods.GoodsMainId
                                , tmp.Amount
                                , tmp.SummaSale
                           FROM tmpContainer AS tmp
                                LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
                           )
   -- остатки гл.товар
   , tmpRemains AS (SELECT tmpGoods.GoodsMainId
                         , tmp.GoodsId
                         , tmp.Amount
                    FROM tmpRemains_Ret AS tmp
                         LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
                    )
   -- + гл.товар
   , tmpPrice AS (SELECT tmpGoods.GoodsMainId
                       , tmp.GoodsId
                       , tmp.MCS_Value
                       , tmp.MCSNotRecalc
                  FROM tmpPrice_Ret AS tmp
                       LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
                  )

   -- ассортимент продаж текущей аптеки
   , tmpAssortmentCheck AS (SELECT DISTINCT tmpData_Container.GoodsMainId, tmpData_Container.GoodsId
                            FROM tmpData_Container
                            WHERE tmpData_Container.UnitId = inUnitId
                            )
                  
  /* -- ассортимент товаров текущей аптеки, которые нужно исключить из выборки
   , tmpAssortment AS (SELECT tmpAssortmentCheck.GoodsId
                       FROM tmpAssortmentCheck
                       WHERE tmpRemains.GoodsId IS NOT NULL
                          OR COALESCE (tmpMCS.MCS_Value, 0) <> 0
                       ) 
 */                                        
   -- данные продаж для отчета                        
   , tmpData AS (SELECT tmpData_Container.UnitId
                      , tmpData_Container.GoodsMainId
                      , SUM (COALESCE (tmpData_Container.Amount, 0))    AS Amount
                      , SUM (COALESCE (tmpData_Container.SummaSale, 0)) AS SummaSale
                 FROM tmpData_Container
                      --LEFT JOIN tmpAssortment ON tmpAssortment.GoodsId = tmpData_Container.GoodsId
                      LEFT JOIN tmpRemains ON tmpRemains.GoodsMainId = tmpData_Container.GoodsMainId
                      LEFT JOIN tmpPrice   ON tmpPrice.GoodsMainId   = tmpData_Container.GoodsMainId
                 WHERE tmpData_Container.UnitId <> inUnitId
                   AND tmpData_Container.GoodsMainId NOT IN (SELECT tmpAssortmentCheck.GoodsMainId FROM tmpAssortmentCheck)
                   AND COALESCE (tmpRemains.Amount, 0) = 0
                   AND COALESCE (tmpPrice.MCS_Value, 0) = 0
                 GROUP BY tmpData_Container.GoodsMainId
                        , tmpData_Container.UnitId
                )
 
   , tmpDataRez AS (SELECT tmp.UnitName
                         , tmp.CountUnit
                         --, ((tmp.CountUnit * 100) / vbCountUnit) AS PersentUnit
                         , tmp.GoodsMainId
                         , tmp.Amount
                         , tmp.SummaSale
                    FROM (SELECT STRING_AGG (Object_Unit.ValueData, '; ') AS UnitName
                               , COUNT (Object_Unit.ValueData) AS CountUnit
                               , tmpData.GoodsMainId           AS GoodsMainId
                               , SUM (tmpData.Amount)          AS Amount
                               , SUM (tmpData.SummaSale)       AS SummaSale
                          FROM tmpData
                               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
                          GROUP BY tmpData.GoodsMainId
                          ) AS tmp
                    WHERE ((tmp.CountUnit * 100) / vbCountUnit) >= 50 OR inisUnitList = TRUE
                    )
                     
   -- Маркетинговый контракт
   , GoodsPromo AS (SELECT DISTINCT tmp.GoodsId                  AS GoodsMainId -- главный товар
                    --     , ObjectLink_Child_retail.ChildObjectId AS GoodsId     -- здесь товар "сети"
                    FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                        /* INNER JOIN ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = tmp.GoodsId
                                              AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                  AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Main_retail ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Child_retail ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                                         AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                        */
                         /*INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                               ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                              AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                              AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId*/
                    )
                       
   -- уже сохранненные данные По НТЗ из zc_Object_DataExcel
   , tmpDataExcel AS (SELECT CAST (zfCalc_Word_Split (inValue:= Object_DataExcel.ValueData, inSep:= ';', inIndex:= 2) AS Integer) AS GoodsId
                           , CAST (zfCalc_Word_Split (inValue:= Object_DataExcel.ValueData, inSep:= ';', inIndex:= 3) AS TFloat)  AS MCSValue
                      FROM Object AS Object_DataExcel
                           INNER JOIN ObjectLink AS ObjectLink_Insert
                                                 ON ObjectLink_Insert.ObjectId = Object_DataExcel.Id
                                                AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
                                                AND ObjectLink_Insert.ChildObjectId = vbUserId
                      WHERE Object_DataExcel.DescId = zc_Object_DataExcel()
                          AND Object_DataExcel.ObjectCode = 1
                          AND Object_DataExcel.ValueData LIKE '%'|| inUnitId ||'%'
                      )
                     
  -- свойства для товаров тек. аптеки
  , tmpGoodsParam AS (SELECT tmp.GoodsId     -- товар сети
                           , tmp.GoodsMainId -- главный товар
                           , COALESCE(Object_ConditionsKeep.ValueData, '') ::TVarChar          AS ConditionsKeepName 
                           , Object_GoodsGroup.ValueData                                       AS GoodsGroupName  
                           , Object_NDSKind.ValueData                                          AS NDSKindName
                           , ObjectFloat_NDSKind_NDS.ValueData                                 AS NDS 
                           , COALESCE(ObjectBoolean_Goods_Close.ValueData, False)  :: Boolean  AS isClose
                           , COALESCE(ObjectDate_Update.ValueData, Null)          ::TDateTime  AS UpdateDate 
                           , COALESCE(ObjectBoolean_Goods_TOP.ValueData, false)    :: Boolean  AS isTOP
                           , COALESCE(ObjectBoolean_Goods_First.ValueData, False)  :: Boolean  AS isFirst
                           , COALESCE(ObjectBoolean_Goods_Second.ValueData, False) :: Boolean  AS isSecond
                         FROM (SELECT DISTINCT ObjectLink_Child_to.ChildObjectId AS GoodsId
                                   , tmpDataRez.GoodsMainId
                               FROM tmpDataRez
                                INNER JOIN ObjectLink AS ObjectLink_Main_to ON ObjectLink_Main_to.ChildObjectId = tmpDataRez.GoodsMainId -- ObjectLink_Main.ChildObjectId
                                                                           AND ObjectLink_Main_to.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                INNER JOIN ObjectLink AS ObjectLink_Child_to ON ObjectLink_Child_to.ObjectId = ObjectLink_Main_to.ObjectId
                                                                            AND ObjectLink_Child_to.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_to.ChildObjectId
                                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                     AND ObjectLink_Goods_Object.ChildObjectId = vbRetailId
                                --INNER JOIN Object ON Object.Id = ObjectLink_Goods_Object.ChildObjectId
                                --                 AND Object.DescId = zc_Object_Retail()
                               ) AS tmp
                              -- условия хранения
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_ConditionsKeep 
                                                   ON ObjectLink_Goods_ConditionsKeep.ObjectId = tmp.GoodsId
                                                  AND ObjectLink_Goods_ConditionsKeep.DescId = zc_ObjectLink_Goods_ConditionsKeep()
                              LEFT JOIN Object AS Object_ConditionsKeep ON Object_ConditionsKeep.Id = ObjectLink_Goods_ConditionsKeep.ChildObjectId
                  
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                                   ON ObjectLink_Goods_GoodsGroup.ObjectId = tmp.GoodsId
                                                  AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                              LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
                              
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                                      ON ObjectBoolean_Goods_Close.ObjectId = tmp.GoodsId
                                                     AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()  
                                                     
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                                   ON ObjectLink_Goods_NDSKind.ObjectId = tmp.GoodsId
                                                  AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                              LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
                 
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   
                 
                              LEFT JOIN ObjectDate AS ObjectDate_Update
                                                   ON ObjectDate_Update.ObjectId = tmp.GoodsId
                                                  AND ObjectDate_Update.DescId = zc_ObjectDate_Protocol_Update()  
                 
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                      ON ObjectBoolean_Goods_TOP.ObjectId = tmp.GoodsId
                                                     AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()  
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                                      ON ObjectBoolean_Goods_First.ObjectId = tmp.GoodsId
                                                     AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First() 
                              LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                                      ON ObjectBoolean_Goods_Second.ObjectId = tmp.GoodsId
                                                     AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second() 
                      ) 

        -- результат
        SELECT tmpGoodsParam.GoodsId                                             AS GoodsId
             , Object_Goods.Id                                                   AS GoodsMainId
             , Object_Goods.ObjectCode                                           AS GoodsCode
             , Object_Goods.ValueData                                            AS GoodsName
             , tmpGoodsParam.GoodsGroupName                                      AS GoodsGroupName
             , tmpGoodsParam.NDSKindName                                         AS NDSKindName
             , tmpGoodsParam.NDS                                                 AS NDS
             , COALESCE(tmpGoodsParam.ConditionsKeepName, '') ::TVarChar         AS ConditionsKeepName           
  
             , tmpData.Amount                                        :: TFloat   AS Amount
             , CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale
             , tmpData.SummaSale                                     :: TFloat   AS SummaSale
  
             , tmpData.CountUnit                                     :: TFloat   AS CountUnit
             , COALESCE(tmpDataExcel.MCSValue, 0)                    :: TFloat   AS MCS_Value
             , tmpData.UnitName                                      :: Tblob    AS UnitName
  
             , COALESCE(tmpGoodsParam.isClose, False)                :: Boolean  AS isClose
             , COALESCE(tmpGoodsParam.UpdateDate, Null)             ::TDateTime  AS UpdateDate   
             
             , COALESCE(tmpGoodsParam.isTOP, false)                  :: Boolean  AS isTOP
             , COALESCE(tmpGoodsParam.isFirst, FALSE)                :: Boolean  AS isFirst
             , COALESCE(tmpGoodsParam.isSecond, FALSE)               :: Boolean  AS isSecond
             
             , COALESCE (tmpGoods.isSP, FALSE)                       :: Boolean  AS isSP
             , CASE WHEN COALESCE(GoodsPromo.GoodsMainId,0) <> 0 THEN TRUE ELSE FALSE END AS isPromo
             , COALESCE(tmpPrice.MCSNotRecalc, FALSE)                :: Boolean  AS MCSNotRecalc
           
        FROM tmpDataRez AS tmpData
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id  = tmpData.GoodsMainId
             LEFT JOIN (SELECT DISTINCT tmpGoods.GoodsMainId, tmpGoods.isSP FROM tmpGoods) AS tmpGoods ON tmpGoods.GoodsMainId = tmpData.GoodsMainId
             LEFT JOIN tmpGoodsParam ON tmpGoodsParam.GoodsMainId = tmpData.GoodsMainId

             LEFT JOIN GoodsPromo ON GoodsPromo.GoodsMainId = tmpData.GoodsMainId
             LEFT JOIN tmpPrice   ON tmpPrice.GoodsMainId   = tmpData.GoodsMainId
            
             LEFT JOIN tmpDataExcel ON tmpDataExcel.GoodsId = tmpGoodsParam.GoodsId --tmpGoods.GoodsMainId
                                                                                       
        ORDER BY tmpGoodsParam.GoodsGroupName
               , Object_Goods.ValueData;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         * признак Товары соц-проект берем и документа
 19.05.18         *
 07.01.18         *
 29.08.17         *
*/

-- тест
-- select * from gpReport_Check_Assortment(inUnitId := 183292 , inDateStart := ('01.01.2016')::TDateTime , inDateFinal := ('01.01.2016')::TDateTime , inisUnitList := 'False' :: Boolean,  inSession := '3'::TVarChar);
-- select * from gpReport_Check_Assortment(inUnitId := 394426 , inDateStart := ('01.11.2016')::TDateTime , inDateFinal := ('30.11.2016')::TDateTime , inisUnitList := 'False' ,  inSession := '3');
