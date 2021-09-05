-- Function: gpReport_LayoutCheckRemains()

DROP FUNCTION IF EXISTS gpReport_LayoutCheckRemains (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_LayoutCheckRemains(
    IN inLayoutId         Integer   , -- Сотрудник
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

    -- Выкладки
    CREATE TEMP TABLE tmpMovementLayout ON COMMIT DROP AS
    (SELECT Movement.Id   AS Id
          , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE) AS isPharmacyItem
     FROM Movement
          LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                    ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                   AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
     WHERE Movement.DescId = zc_Movement_Layout()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND (Movement.Id = inLayoutId OR COALESCE(inLayoutId, 0) = 0)
    );
    

      -- Подразделения
    CREATE TEMP TABLE tmpUnit ON COMMIT DROP AS
    (SELECT ROW_NUMBER()OVER(ORDER BY MovementItem.ObjectId)::Integer as Id
          , MovementItem.ObjectId         AS UnitId
          , Object_Unit.ObjectCode        AS UnitCode
          , Object_Unit.ValueData         AS UnitName
     FROM tmpMovementLayout AS Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId = zc_MI_Child()
                                 AND MovementItem.isErased = FALSE
                                 AND MovementItem.Amount > 0
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId  
     GROUP BY MovementItem.ObjectId
            , Object_Unit.ObjectCode
            , Object_Unit.ValueData 
    );


  


      -- Pезультат
    CREATE TEMP TABLE tmpResult (
            GoodsId               Integer,
            GoodsCode             Integer,
            GoodsName             TVarChar,
            Amount                TFloat

      ) ON COMMIT DROP;

    WITH tmpLayoutGoods AS (SELECT MovementItem.ObjectId              AS GoodsId
                                 , MAX(MovementItem.Amount)::TFloat   AS Amount
                            FROM tmpMovementLayout AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                            GROUP BY MovementItem.ObjectId 
                           )
                      
    INSERT INTO tmpResult (GoodsId, GoodsCode, GoodsName, Amount)
    SELECT tmpLayoutGoods.GoodsId
         , Object_Goods_Main.ObjectCode
         , Object_Goods_Main.Name
         , tmpLayoutGoods.Amount
    FROM tmpLayoutGoods
    
         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpLayoutGoods.GoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
    ;


      -- Заполняем подразделение

    OPEN curUnit FOR SELECT * FROM tmpUnit 
                     ORDER BY tmpUnit;
    LOOP
        FETCH curUnit INTO vbID, vbUnitID;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Remains' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
          ' , ADD COLUMN Color_CalcRemains' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT 14211288';
        EXECUTE vbQueryText;
        
        vbQueryText := 'UPDATE tmpResult set Remains' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Remains, 0)' ||
          ', Color_CalcRemains' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.Color_CalcRemains, 0)' ||
          ' FROM (WITH    
                      tmpLayout AS (SELECT Movement.ID                        AS Id
                                          , MovementItem.ObjectId              AS GoodsId
                                          , MovementItem.Amount                AS Amount
                                          , Movement.isPharmacyItem            AS isPharmacyItem
                                     FROM tmpMovementLayout AS Movement
                                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                 AND MovementItem.DescId = zc_MI_Master()
                                                                 AND MovementItem.isErased = FALSE
                                                                 AND MovementItem.Amount > 0
                                    )
                    , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                             , MovementItem.ObjectId              AS UnitId
                                        FROM tmpMovementLayout AS Movement
                                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                                    AND MovementItem.DescId = zc_MI_Child()
                                                                    AND MovementItem.isErased = FALSE
                                                                    AND MovementItem.Amount > 0
                                                                    AND MovementItem.ObjectId  = ' || COALESCE (vbUnitID, 0)::Text||'
                                                                    
                                             LEFT JOIN ObjectBoolean AS Unit_PharmacyItem
                                                                     ON Unit_PharmacyItem.ObjectId  = MovementItem.ObjectId 
                                                                    AND Unit_PharmacyItem.DescId    = zc_ObjectBoolean_Unit_PharmacyItem()
                                        WHERE (COALESCE (Unit_PharmacyItem.ValueData, False) = False OR Movement.isPharmacyItem = True)
                                       )
                    , tmpLayoutCurr AS (SELECT tmpLayout.GoodsId
                                             , MAX(tmpLayout.Amount)       AS Amount
                                        FROM tmpLayout

                                             INNER JOIN tmpLayoutUnit ON tmpLayoutUnit.ID = tmpLayout.ID
                                        GROUP BY tmpLayout.GoodsId)
                    , tmpRemains AS (SELECT tmpLayoutCurr.GoodsId
                                          , tmpLayoutCurr.Amount
                                          , SUM (Container.Amount) AS Remains 
                                     FROM tmpLayoutCurr 
                                     
                                          LEFT JOIN Container ON Container.WhereObjectId = ' || COALESCE (vbUnitID, 0)::Text||'
                                                             AND Container.ObjectId = tmpLayoutCurr.GoodsId
                                                             AND Container.DescId = zc_Container_Count()
                                                             AND Container.Amount <> 0
                                                              
                                     GROUP BY tmpLayoutCurr.GoodsId
                                            , tmpLayoutCurr.Amount                          
                                     )  
                            
           SELECT tmpRemains.GoodsId
                , tmpRemains.Remains
                , CASE WHEN COALESCE(tmpRemains.Remains, 0) >= tmpRemains.Amount THEN zc_Color_White() 
                       WHEN COALESCE(tmpRemains.Remains, 0) > 0 THEN zc_Color_Yelow() 
                       ELSE 11394815 END  AS Color_CalcRemains
           FROM tmpRemains) AS T1
           WHERE tmpResult.GoodsId = T1.GoodsId';
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curUnit;        

       -- Вывод результата
       -- Подразделения для кросса
    OPEN cur1 FOR
    SELECT tmpUnit.ID
         , tmpUnit.UnitID
         , tmpUnit.UnitName
    FROM tmpUnit
    ORDER BY tmpUnit.ID;
    RETURN NEXT cur1;


    OPEN cur2 FOR
    SELECT *
    FROM tmpResult
    ORDER BY tmpResult.GoodsName;
    RETURN NEXT cur2;

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
select * from gpReport_LayoutCheckRemains(inLayoutId := 0 ,  inSession := '3');