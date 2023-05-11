-- Function: gpReport_BanToTransferTimeGoods()

DROP FUNCTION IF EXISTS gpReport_BanToTransferTimeGoods (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_BanToTransferTimeGoods(
    IN inisAllRemains     Boolean   , -- Ост по всем аптекам
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE vbQueryText Text;

   DECLARE curUnit refcursor;
   DECLARE vbID Integer;
   DECLARE vbUnitID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    raise notice 'Value 1: %', CLOCK_TIMESTAMP();
    
    -- Подразделения
    CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
      SELECT Row_Number() OVER (ORDER BY Object_Unit_View.Name)::integer  AS ID
           , Object_Unit_View.Id            AS UnitId
           , Object_Unit_View.Code          AS UnitCode
           , Object_Unit_View.Name          AS UnitName
           , Object_Unit_View.ParentName
       FROM Object_Unit_View
       WHERE Object_Unit_View.iserased = False 
         AND COALESCE (Object_Unit_View.ParentId, 0) <> 377612
         AND Object_Unit_View.Id <> 389328
         AND Object_Unit_View.Name NOT ILIKE 'Зачинена%'
         AND COALESCE (Object_Unit_View.ParentId, 0) IN 
             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
         AND Object_Unit_View.isErased = False
       ORDER BY Object_Unit_View.Name
      ;
      
    ANALYSE tmpUnit;

    raise notice 'Value 2: %', CLOCK_TIMESTAMP();
  
    -- Остатки
    CREATE TEMP TABLE tmpRemains ON COMMIT DROP AS
      SELECT 
             Container.WhereObjectId  AS UnitId
           , Container.ObjectId       AS GoodsId
           , SUM(Container.Amount)    AS Amount
       FROM Container
       WHERE Container.DescId = zc_Container_count()
         AND Container.Amount > 0
         AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
       GROUP BY Container.WhereObjectId
              , Container.ObjectId;
              
    ANALYSE tmpRemains;
    
    
    ANALYSE tmpRemains;

    raise notice 'Value 3: %', CLOCK_TIMESTAMP();


    -- Pезультат
    CREATE TEMP TABLE tmpResult ON COMMIT DROP AS
    SELECT tmpGoods.GoodsId
         , Object_Goods_Retail.GoodsMainId
         , Object_Goods_Main.ObjectCode          AS GoodsCode
         , Object_Goods_Main.Name                AS GoodsName
         , Object_Goods_Main.isNotTransferTime
         , Object_Group.ValueData                AS GoodsGroupName
         , tmpGoods.Amount
    FROM (SELECT tmpRemains.GoodsId, SUM(tmpRemains.Amount) AS Amount FROM tmpRemains GROUP BY tmpRemains.GoodsId) AS tmpGoods
    
         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpGoods.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
         
         LEFT JOIN Object AS Object_Group ON Object_Group.Id = Object_Goods_Main.GoodsGroupId
    ;


    raise notice 'Value 4: %', CLOCK_TIMESTAMP();

      -- Заполняем подразделение

    OPEN curUnit FOR SELECT tmpUnit.Id, tmpUnit.UnitID FROM tmpUnit 
                     ORDER BY tmpUnit.Id;
    LOOP
        FETCH curUnit INTO vbID, vbUnitID;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Remains' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ';
        EXECUTE vbQueryText;
        
        vbQueryText := 'UPDATE tmpResult set Amount = tmpResult.Amount + COALESCE (T1.Amount, 0)
                                           , Remains' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Amount, 0)
        
           FROM tmpRemains AS T1
           WHERE tmpResult.GoodsId = T1.GoodsId
             AND T1.UnitId = '|| COALESCE (vbUnitID, 0)::Text;
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curUnit;        

    raise notice 'Value 5: %', CLOCK_TIMESTAMP();

       -- Вывод результата
       -- Подразделения для кросса
    OPEN cur1 FOR
    SELECT tmpUnit.ID
         , tmpUnit.UnitId
         , tmpUnit.UnitCode
         , tmpUnit.UnitName
    FROM tmpUnit
    WHERE  inisAllRemains = TRUE
    ORDER BY tmpUnit.ID;
    RETURN NEXT cur1;


    OPEN cur2 FOR
    SELECT *
    FROM tmpResult
    ORDER BY tmpResult.GoodsName;
    RETURN NEXT cur2;
    
    raise notice 'Value 6: %', CLOCK_TIMESTAMP();


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.21                                                       *
*/

-- тест 
-- 
select * from gpReport_BanToTransferTimeGoods(inisAllRemains := True ,  inSession := '3');