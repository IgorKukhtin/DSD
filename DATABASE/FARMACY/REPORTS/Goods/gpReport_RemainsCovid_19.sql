-- Function: gpReport_RemainsCovid_19()

DROP FUNCTION IF EXISTS gpReport_RemainsCovid_19 (TDateTime, Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainsCovid_19(
    IN inOperDate         TDateTime ,  -- Список Подразделений, через зпт
    IN inJuridical        Integer   ,  -- Список товаров, через зпт
    IN inGoodsList        Text      ,  -- Список товаров, через зпт
    IN inSession          TVarChar     -- сессия пользователя
)
RETURNS TABLE (JuridicalId       Integer
             , JuridicalCode     Integer
             , JuridicalName     TVarChar

             , GoodsId           Integer   -- Товар (id)
             , GoodsCode         Integer   -- Товар (Код)
             , GoodsName         TVarChar  -- Товар (название)

             , Remains           TFloat    -- Остаток
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer; 
   
   DECLARE vbQueryText Text;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
    

    -- таблица
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpGoods_List')
    THEN
        CREATE TEMP TABLE _tmpGoods_List (GoodsMainId Integer, GoodsId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoods_List;
    END IF;
    
    -- таблица
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpUnit_List')
    THEN
        CREATE TEMP TABLE _tmpUnit_List (UnitId Integer, JuridicalId Integer, RetailId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnit_List;
    END IF;


    -- Добавляем подразделения
    INSERT INTO _tmpUnit_List (UnitId, JuridicalId, RetailId)
    SELECT ObjectLink_Unit_Juridical.ObjectId         AS UnitId
         , ObjectLink_Unit_Juridical.ChildObjectId    AS JuridicalId
         , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
    FROM ObjectLink AS ObjectLink_Unit_Juridical
       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                            AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR COALESCE (inJuridical, 0) <> 0)
       INNER JOIN Object AS Object_Juridical ON Object_Juridical.ID = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND Object_Juridical.isErased = False
    WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
      AND (COALESCE (ObjectLink_Unit_Juridical.ChildObjectId, 0) = inJuridical OR COALESCE (inJuridical, 0) = 0)
      AND ObjectLink_Unit_Juridical.ChildObjectId <> 393053;
      
--    RAISE notice '<%>', (SELECT COUNT (*) FROM _tmpUnit_List);

    -- парсим товары
    IF COALESCE(inGoodsList, '') <> ''
    THEN
      vbQueryText := 'INSERT INTO _tmpGoods_List (GoodsMainId, GoodsId)
                      SELECT  RetailMain.Id, RetailAll.Id
                      FROM Object_Goods_Main AS RetailMain
                           INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.GoodsMainId  = RetailMain.Id
                                                                      AND RetailAll.RetailId IN (SELECT DISTINCT _tmpUnit_List.RetailId FROM _tmpUnit_List) 
                      WHERE RetailMain.ObjectCode IN ('||inGoodsList||')';

      EXECUTE vbQueryText;
    END IF;

--    RAISE notice '<%>', (SELECT COUNT (*) FROM _tmpGoods_List);

    -- Результат
    RETURN QUERY
    WITH 
          -- таблица остатков
          tmpContainerAll AS (SELECT Container.Id            AS ContainerId
                                   , Container.ObjectId      AS GoodsId
                                   , Container.WhereObjectId AS UnitId
                                   , Container.Amount        AS Amount
                              FROM Container 
                              WHERE Container.DescId = zc_Container_Count()
                                AND Container.ObjectId IN (SELECT _tmpGoods_List.GoodsId FROM _tmpGoods_List)
                                AND Container.WhereObjectId IN (SELECT _tmpUnit_List.UnitId FROM _tmpUnit_List)
                              )
        , tmpContainerRemains AS (SELECT Container.ContainerId                                      AS ContainerId
                                       , Container.GoodsId                                          AS GoodsId
                                       , Container.UnitId                                           AS UnitId
                                       , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)  AS Remains
                                  FROM tmpContainerAll AS Container                                                        

                                       LEFT JOIN MovementItemContainer AS MIContainer
                                                                       ON MIContainer.ContainerId = Container.ContainerId
                                                                      AND MIContainer.OperDate >= inOperDate + INTERVAL '1 DAY'
                                                                      AND MIContainer.DescId = zc_Container_Count()

                                  GROUP BY Container.ContainerId
                                         , Container.GoodsId
                                         , Container.Amount
                                         , Container.UnitId
                                  HAVING (Container.Amount - COALESCE (SUM (MIContainer.Amount), 0)) <> 0
                                  )

       , tmpContainerPG AS (SELECT ContainerRemains.ContainerId
                                 , COALESCE (ObjectDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                                 , ROW_NUMBER() OVER (PARTITION BY ContainerRemains.ContainerId ORDER BY ContainerLinkObject.ObjectId DESC) AS Ord
                            FROM tmpContainerRemains AS ContainerRemains
                            
                                  INNER JOIN Container ON Container.ParentId = ContainerRemains.ContainerId
                                                      AND Container.DescId  = zc_Container_CountPartionDate()

                                  LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                               AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                  LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                       ON ObjectDate_ExpirationDate.ObjectId = ContainerLinkObject.ObjectId
                                                      AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()
                            )

        , tmpContainerPD AS (SELECT Container.ContainerId   AS ContainerId
                                  , Container.GoodsId       AS GoodsId
                                  , Container.UnitId        AS UnitId
                                  , Container.Remains       AS Remains
                                  , COALESCE (tmpContainerPG.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd()) AS ExpirationDate
                             FROM tmpContainerRemains AS Container 
                             
                                  LEFT JOIN tmpContainerPG ON tmpContainerPG.ContainerId = Container.ContainerId
                                                          AND tmpContainerPG.Ord = 1

                                  LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerId
                                                              AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                  LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                  -- элемент прихода
                                  LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                  -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                              ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                             AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                  -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                  LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                       -- AND 1=0

                                  LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                   ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)
                                                                  AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                             )
    
    
    
    
        , tmpRemains AS (SELECT tmpContainerPD.GoodsId                    AS GoodsId
                             , _tmpUnit_List.JuridicalId                  AS JuridicalId
                             , Sum(tmpContainerPD.Remains)::TFloat        AS Remains
                        FROM tmpContainerPD
                             INNER JOIN _tmpUnit_List ON _tmpUnit_List.UnitId = tmpContainerPD.UnitId 
                        WHERE tmpContainerPD.ExpirationDate > inOperDate
                        GROUP BY tmpContainerPD.GoodsId
                               , _tmpUnit_List.JuridicalId
                        HAVING Sum(tmpContainerPD.Remains) <> 0
                        )
                            
        SELECT 
               Object_Juridical.Id             AS JuridicalId
             , Object_Juridical.ObjectCode     AS JuridicalCode
             , Object_Juridical.ValueData      AS JuridicalName

             , Object_Goods_Retail.ID          AS GoodsId
             , Object_Goods_Main.ObjectCode    AS GoodsCode
             , Object_Goods_Main.Name          AS GoodsName

             , tmpRemains.Remains::TFloat      AS Remains
        FROM tmpRemains

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id  = tmpRemains.GoodsId        

             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id  = Object_Goods_Retail.GoodsMainId     

             LEFT JOIN Object  AS Object_Juridical ON Object_Juridical.Id  = tmpRemains.JuridicalId     
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.21                                                       *
*/



--select * from gpReport_RemainsCovid_19(inOperDate := ('30.06.2021')::TDateTime , inJuridical := 0 /*393054 */ , inGoodsList := '2041,1756,2145,1761,2854,3147,5084,5115,1392,1693,1838,2423,2938,3104,3111,3134,3556,3737,4278,4279,4555,4568,4740,4831,5647,5793,6078,6069,7761,8902,9331,9365,7089,6427,9194,9151,6371,9279,8474,772,10890,9,11039,874,10762,10892,10763,12661,13314,13412,14603,14883,15234,15848,14993,15410,16592,16633,9942,1091,13889,18390,19040,19228,19519,19790,20731,20758,20959,21786,22058,22140,22502,22608,22708,23267,23554,23739,23758,24242,26158,26549,27119,27185,28290,28579,29262,29680,29683,29955,30012,30055,30078,30281,30488,30873,30989,31110,31173,31432,31481,31651,31835,32302,32851,32875,33015,33016,33017,33546,33559,33562,33563,33852,34038,34218,34219,34525,35060,35567,35574' ,  inSession := '3');




