-- Function: gpSelect_GoodsOnUnit_ForSiteMobile()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSiteMobile (Text, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSiteMobile(
    IN inUnitId_list      Text     ,  -- Список Подразделений, через зпт
    IN inGoodsId_list     Text     ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer

             , deleted           Integer

             , UnitId            Integer   -- Аптека (информативно)
             , Remains           TFloat    -- Остаток (с учетом резерва)

             , Price_unit        TFloat -- цена аптеки
             , Price_unit_sale   TFloat -- цена аптеки со скидкой
             
             , Multiplicity      TFloat    -- Минимальная кратность при отпуске
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   -- DECLARE inUnitId Integer;

   DECLARE vbIndex Integer;

   DECLARE vbSiteDiscount TFloat;
   DECLARE vbQueryText Text;

   DECLARE vbDate0    TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;

   DECLARE vbMonth_0   TFloat;
   DECLARE vbMonth_1   TFloat;
   DECLARE vbMonth_6   TFloat;
   DECLARE vbIsMonth_0 Boolean;
   DECLARE vbIsMonth_1 Boolean;
   DECLARE vbIsMonth_6 Boolean;
   
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));

    -- получаем значения из справочника
    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_0, vbIsMonth_0
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0();
    --

    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_1, vbIsMonth_1
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1();
    --

    SELECT CASE WHEN ObjectFloat_Day.ValueData > 0 THEN ObjectFloat_Day.ValueData ELSE COALESCE (ObjectFloat_Month.ValueData, 0) END
         , CASE WHEN ObjectFloat_Day.ValueData > 0 THEN FALSE ELSE TRUE END
           INTO vbMonth_6, vbIsMonth_6
    FROM Object  AS Object_PartionDateKind
         LEFT JOIN ObjectFloat AS ObjectFloat_Month
                               ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
         LEFT JOIN ObjectFloat AS ObjectFloat_Day
                               ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                              AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
    WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6();

    -- таблица
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpGoodsMinPrice_List')
    THEN
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer, GoodsId_retail Integer, GoodsGroupId Integer, Multiplicity TFloat, isExpDateExcSite boolean, isPublished boolean) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;

    -- таблица
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpUnitMinPrice_List')
    THEN
        CREATE TEMP TABLE _tmpUnitMinPrice_List (UnitId Integer, AreaId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpUnitMinPrice_List;
    END IF;


    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + CASE WHEN vbIsMonth_6 = TRUE THEN vbMonth_6 ||' MONTH'  ELSE vbMonth_6 ||' DAY' END :: INTERVAL;
    vbDate30  := CURRENT_DATE + CASE WHEN vbIsMonth_1 = TRUE THEN vbMonth_1 ||' MONTH'  ELSE vbMonth_1 ||' DAY' END :: INTERVAL;
    vbDate0   := CURRENT_DATE + CASE WHEN vbIsMonth_0 = TRUE THEN vbMonth_0 ||' MONTH'  ELSE vbMonth_0 ||' DAY' END :: INTERVAL;


    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpUnitMinPrice_List (UnitId, AreaId)
           SELECT tmp.UnitId
                , COALESCE (OL_Unit_Area.ChildObjectId, zc_Area_Basis()) AS AreaId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
                LEFT JOIN ObjectLink AS OL_Unit_Area
                                     ON OL_Unit_Area.ObjectId = tmp.UnitId
                                    AND OL_Unit_Area.DescId   = zc_ObjectLink_Unit_Area()
          ;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    -- парсим товары
    IF COALESCE(inGoodsId_list, '') <> ''
    THEN
      vbQueryText := 'INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail, GoodsGroupId, Multiplicity, isExpDateExcSite, isPublished)
                      SELECT  Retail4.Id, Retail4.Id, RetailMain.GoodsGroupId, RetailMain.Multiplicity, RetailMain.isExpDateExcSite, RetailMain.isPublished
                      FROM Object_Goods_Retail AS Retail4
                          -- INNER JOIN Object_Goods_Retail AS RetailAll ON RetailAll.GoodsMainId  = Retail4.GoodsMainId
                           INNER JOIN Object_Goods_Main AS RetailMain ON RetailMain.Id  = Retail4.GoodsMainId
                      WHERE Retail4.Id IN ('||inGoodsId_list||')';

      EXECUTE vbQueryText;
    END IF;

    -- !!!Оптимизация!!!
    ANALYZE _tmpUnitMinPrice_List;


    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List WHERE GoodsId <> 0)
    THEN
         -- все остатки
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId, GoodsId_retail, GoodsGroupId, Multiplicity, isExpDateExcSite, isPublished)
           -- SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
           SELECT DISTINCT
                  ObjectLink_Child_NB.ChildObjectId AS ObjectID -- здесь товар "сети"
                , Container.ObjectId
                , ObjectLink_Goods_GoodsGroup.ChildObjectId
                , ObjectFloat_Goods_Multiplicity.ValueData
                , COALESCE (ObjectBoolean_Goods_ExpDateExcSite.ValueData, False) 
                , COALESCE (ObjectBoolean_Goods_Published.ValueData, False) 
           FROM _tmpUnitMinPrice_List
                INNER JOIN Container ON Container.WhereObjectId = _tmpUnitMinPrice_List.UnitId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.Amount <> 0
                -- !!!временно захардкодил, будет всегда товар НеБолей!!!!
                INNER JOIN ObjectLink AS ObjectLink_Child
                                      ON ObjectLink_Child.ChildObjectId = Container.ObjectId
                                     AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                         AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                           AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                            AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                      ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                     AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                     AND ObjectLink_Goods_Object.ChildObjectId = 4 -- !!!NeBoley!!!
                LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                     ON ObjectLink_Goods_GoodsGroup.ObjectId = Container.ObjectId
                                    AND ObjectLink_Goods_GoodsGroup.DescId        = zc_ObjectLink_Goods_GoodsGroup()
                LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Multiplicity
                                      ON ObjectFloat_Goods_Multiplicity.ObjectId = Container.ObjectId
                                     AND ObjectFloat_Goods_Multiplicity.DescId   = zc_ObjectFloat_Goods_Multiplicity()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_ExpDateExcSite
                                        ON ObjectBoolean_Goods_ExpDateExcSite.ObjectId = ObjectLink_Main.ChildObjectId
                                       AND ObjectBoolean_Goods_ExpDateExcSite.DescId   = zc_ObjectBoolean_Goods_ExpDateExcSite()
                LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                        ON ObjectBoolean_Goods_Published.ObjectId = Container.ObjectId
                                       AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
          ;
    END IF;


    -- !!!Оптимизация!!!
    ANALYZE _tmpGoodsMinPrice_List;

    -- еще оптимизируем - _tmpContainerCount
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCount'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCount (UnitId Integer, GoodsId Integer, GoodsId_retail Integer, Amount TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCount;
    END IF;
    --
    INSERT INTO _tmpContainerCount (UnitId, GoodsId, GoodsId_retail, Amount)
                WITH tmpContainer AS
               (SELECT Container.WhereObjectId                AS UnitId
                     , _tmpGoodsMinPrice_List.GoodsId         AS GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail  AS GoodsId_retail
                     , SUM (Container.Amount)                 AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                         AND Container.DescId   = zc_Container_Count()
                                         AND Container.Amount   <> 0
                                         AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)
                WHERE _tmpGoodsMinPrice_List.isPublished = True
                GROUP BY Container.WhereObjectId
                       , _tmpGoodsMinPrice_List.GoodsId
                       , _tmpGoodsMinPrice_List.GoodsId_retail
                HAVING SUM (Container.Amount) > 0
               )
                -- результат
                SELECT tmpContainer.UnitId
                     , tmpContainer.GoodsId
                     , tmpContainer.GoodsId_retail
                     , tmpContainer.Amount
                FROM tmpContainer
                     -- INNER JOIN _tmpUnitMinPrice_List ON _tmpUnitMinPrice_List.UnitId = tmpContainer.UnitId
               ;

    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCount;

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpMovementCheck'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpMovementCheck (Id Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpMovementCheck;
    END IF;
    --
    INSERT INTO _tmpMovementCheck (Id)
      WITH           -- Резервы по срокам
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                   AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 MONTH')
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData <> ''        AS  isCommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> ''                             )

          , tmpMovReserveAll AS (
                             SELECT Movement.Id
                             FROM tmpMovReserveId AS Movement
                             WHERE isDeferred = TRUE OR isCommentError = TRUE)

    SELECT Movement.Id FROM tmpMovReserveAll AS Movement;

    -- еще оптимизируем - _tmpContainerCountPD
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpContainerCountPD'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpContainerCountPD (UnitId Integer, GoodsId Integer, PartionDateKindId Integer, Amount TFloat, Remains TFloat, PriceWithVAT TFloat, PartionDateDiscount TFloat, Price TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpContainerCountPD;
    END IF;
    --

    INSERT INTO _tmpContainerCountPD (UnitId, GoodsId, PartionDateKindId, Amount, Remains, PriceWithVAT, PartionDateDiscount)
      WITH           -- Резервы по срокам
             MovementItemChildId AS (SELECT MovementItemChild.Id
                                          , MovementItemChild.Amount
                                     FROM _tmpMovementCheck AS Movement

                                          INNER JOIN MovementItem AS MovementItemChild
                                                                  ON MovementItemChild.MovementId = Movement.Id
                                                                 AND MovementItemChild.DescId     = zc_MI_Child()
                                                                 AND MovementItemChild.Amount     > 0
                                                                 AND MovementItemChild.isErased   = FALSE)
          , ReserveContainer AS (SELECT MIFloat_ContainerId.ValueData::Integer      AS ContainerId
                                      , Sum(MovementItemChildId.Amount)::TFloat       AS Amount
                                 FROM MovementItemChildId
                                 INNER JOIN MovementItemFloat AS MIFloat_ContainerId
                                                                  ON MIFloat_ContainerId.MovementItemId = MovementItemChildId.Id
                                                                 AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()

                                 GROUP BY MIFloat_ContainerId.ValueData
                                )
             -- Остатки по срокам
          , tmpPDContainerAll AS (SELECT Container.Id,
                                         Container.WhereObjectId,
                                         Container.ObjectId,
                                         Container.ParentId,
                                         Container.Amount                                        AS Amount,
                                         Container.Amount - COALESCE(ReserveContainer.Amount, 0) AS Remains,
                                         ContainerLinkObject.ObjectId                            AS PartionGoodsId,
                                         ReserveContainer.Amount                                 AS Reserve,
                                         _tmpGoodsMinPrice_List.GoodsGroupId                     AS GoodsGroupId
                                  FROM _tmpGoodsMinPrice_List

                                       INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                                           AND Container.DescId = zc_Container_CountPartionDate()
                                                           AND Container.WhereObjectId IN (SELECT _tmpUnitMinPrice_List.UnitId FROM _tmpUnitMinPrice_List)

                                       LEFT JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                                    AND ContainerLinkObject.DescId = zc_ContainerLinkObject_PartionGoods()

                                       LEFT OUTER JOIN ReserveContainer ON ReserveContainer.ContainerID = Container.Id
                                  WHERE (Container.Amount - COALESCE(ReserveContainer.Amount, 0)) > 0
                                    AND _tmpGoodsMinPrice_List.isExpDateExcSite = False
                                    AND _tmpGoodsMinPrice_List.isPublished = True)
          , tmpPDContainer AS (SELECT Container.Id,
                                      Container.WhereObjectId,
                                      Container.ObjectId,
                                      Container.Amount,
                                      Container.Remains,
                                      COALESCE (ObjectFloat_PartionGoods_ValueMin.ValueData, 0)     AS PercentMin,
                                      COALESCE (ObjectFloat_PartionGoods_Value.ValueData, 0)        AS Percent,
                                      COALESCE (ObjectFloat_PartionGoods_PriceWithVAT.ValueData, 0) AS PriceWithVAT,
                                      CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()  -- просрочено
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()  -- Меньше 1 месяца
                                           WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()  -- Меньше 6 месяца
                                           ELSE zc_Enum_PartionDateKind_Good() END                  AS PartionDateKindId           -- Востановлен с просрочки
                               FROM tmpPDContainerAll AS Container

                                    LEFT JOIN ObjectDate AS ObjectDate_ExpirationDate
                                                         ON ObjectDate_ExpirationDate.ObjectId = Container.PartionGoodsId
                                                        AND ObjectDate_ExpirationDate.DescId = zc_ObjectDate_PartionGoods_Value()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_ValueMin
                                                          ON ObjectFloat_PartionGoods_ValueMin.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_ValueMin.DescId = zc_ObjectFloat_PartionGoods_ValueMin()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_Value
                                                          ON ObjectFloat_PartionGoods_Value.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_Value.DescId = zc_ObjectFloat_PartionGoods_Value()

                                    LEFT JOIN ObjectFloat AS ObjectFloat_PartionGoods_PriceWithVAT
                                                          ON ObjectFloat_PartionGoods_PriceWithVAT.ObjectId =  Container.PartionGoodsId
                                                         AND ObjectFloat_PartionGoods_PriceWithVAT.DescId = zc_ObjectFloat_PartionGoods_PriceWithVAT()
                               WHERE CASE WHEN ObjectDate_ExpirationDate.ValueData <= vbDate0   THEN zc_Enum_PartionDateKind_0()  -- просрочено
                                          WHEN ObjectDate_ExpirationDate.ValueData <= vbDate30  THEN zc_Enum_PartionDateKind_1()  -- Меньше 1 месяца
                                          WHEN ObjectDate_ExpirationDate.ValueData <= vbDate180 THEN zc_Enum_PartionDateKind_6()  -- Меньше 6 месяца
                                          ELSE zc_Enum_PartionDateKind_Good() END <> zc_Enum_PartionDateKind_Good()
                                  AND Container.GoodsGroupId <> 394744
                                )

        SELECT Container.WhereObjectId
             , Container.ObjectId
             , Container.PartionDateKindId                                                  AS PartionDateKindId
             , SUM (Container.Amount)                                                       AS Amount
             , SUM (Container.Remains)                                                      AS Remains
             , Max(Container.PriceWithVAT)                                                  AS PriceWithVAT
             , MIN (CASE WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_Good()
                         THEN 0
                         WHEN Container.PartionDateKindId = zc_Enum_PartionDateKind_6()
                         THEN Container.Percent
                         ELSE Container.PercentMin END)::TFloat                             AS PartionDateDiscount
        FROM tmpPDContainer AS Container
        GROUP BY Container.WhereObjectId
               , Container.ObjectId
               , Container.PartionDateKindId;

    -- !!!Оптимизация!!!
    ANALYZE _tmpContainerCountPD;

    -- еще оптимизируем - _tmpList
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpList'))
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpList (UnitId Integer, AreaId Integer, GoodsId Integer, GoodsId_retail Integer, Multiplicity TFloat) ON COMMIT DROP;
    ELSE
        DELETE FROM _tmpList;
    END IF;
    --
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail, Multiplicity)

                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId_retail
                     , _tmpGoodsMinPrice_List.Multiplicity
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                          ON ObjectLink_Unit_Juridical.ObjectId = _tmpUnitMinPrice_List.UnitId
                                         AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                     LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                          ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                         AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                     INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                           ON ObjectLink_Goods_Object.ObjectId = _tmpGoodsMinPrice_List.GoodsId_retail
                                          AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                          AND ObjectLink_Goods_Object.ChildObjectId = ObjectLink_Juridical_Retail.ChildObjectId
                ;
    INSERT INTO _tmpList (UnitId, AreaId, GoodsId, GoodsId_retail, Multiplicity)
                SELECT DISTINCT
                       _tmpUnitMinPrice_List.UnitId
                     , _tmpUnitMinPrice_List.AreaId
                     , _tmpGoodsMinPrice_List.GoodsId
                     , _tmpGoodsMinPrice_List.GoodsId AS GoodsId_retail
                     , _tmpGoodsMinPrice_List.Multiplicity
                FROM _tmpGoodsMinPrice_List
                     CROSS JOIN _tmpUnitMinPrice_List -- ON 1=1
                     LEFT JOIN _tmpList ON _tmpList.UnitId = _tmpUnitMinPrice_List.UnitId
                                       AND _tmpList.GoodsId = _tmpGoodsMinPrice_List.GoodsId
                WHERE _tmpList.GoodsId IS NULL;


    -- !!!Оптимизация!!!
    ANALYZE _tmpList;

    -- Результат
    RETURN QUERY
       WITH tmpMI_DeferredAll AS
               (SELECT Movement.Id                        AS Id
                     , MovementLinkObject_Unit.ObjectId   AS UnitId
                FROM _tmpMovementCheck AS Movement

                     INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.movementid = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                            
               )
          , tmpMI_Deferred AS
               (SELECT Movement.UnitId
                     , MovementItem.ObjectId              AS GoodsId
                     , SUM (MovementItem.Amount)          AS Amount
                FROM tmpMI_DeferredAll AS Movement

                     INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                            AND MovementItem.DescId     = zc_MI_Master()
                                            AND MovementItem.isErased   = FALSE
                GROUP BY Movement.UnitId
                       , MovementItem.ObjectId
               )
          , Price_Unit_all AS
               (SELECT _tmpList.UnitId
                     , _tmpList.GoodsId
                     , CASE WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                             AND COALESCE (PriceSite_DiscontAmount.ValueData, 0) > 0
                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                 THEN ObjectFloat_Goods_Price.ValueData
                                            ELSE ObjectFloat_Price_Value.ValueData
                                       END - COALESCE (PriceSite_DiscontAmount.ValueData, 0), 2)
                            WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                             AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                             AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                             AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                             AND COALESCE (PriceSite_DiscontPercent.ValueData, 0) > 0 
                            THEN ROUND(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                             AND ObjectFloat_Goods_Price.ValueData > 0
                                                 THEN ObjectFloat_Goods_Price.ValueData
                                            ELSE ObjectFloat_Price_Value.ValueData
                                       END * (100 - COALESCE (PriceSite_DiscontPercent.ValueData, 0)) / 100, 1)
                            ELSE CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                       AND ObjectFloat_Goods_Price.ValueData > 0
                                           THEN ObjectFloat_Goods_Price.ValueData
                                      ELSE ObjectFloat_Price_Value.ValueData
                                 END 
                            END::TFloat       AS Price
                     , COALESCE (NULLIF (ObjectBoolean_Goods_TOP.ValueData, FALSE), COALESCE (ObjectBoolean_Goods_TOP.ValueData, FALSE))         AS isTop
                -- FROM _tmpGoodsMinPrice_List
                FROM _tmpList

                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                          AND ObjectLink_Price_Unit.ChildObjectId = _tmpList.UnitId
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpList.GoodsId_retail -- _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId 
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                             ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Goods.ObjectId
                                            AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                     -- Фикс цена для всей Сети
                     LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                            ON ObjectFloat_Goods_Price.ObjectId = ObjectLink_Price_Goods.ChildObjectId
                                           AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                     LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                             ON ObjectBoolean_Goods_TOP.ObjectId = _tmpList.GoodsId_retail
                                            AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                     LEFT JOIN ObjectDate AS PriceSite_DiscontStart
                                          ON PriceSite_DiscontStart.ObjectId = _tmpList.GoodsId_retail
                                         AND PriceSite_DiscontStart.DescId = zc_ObjectDate_Goods_DiscontSiteStart()
                     LEFT JOIN ObjectDate AS PriceSite_DiscontEnd
                                          ON PriceSite_DiscontEnd.ObjectId = _tmpList.GoodsId_retail
                                         AND PriceSite_DiscontEnd.DescId = zc_ObjectDate_Goods_DiscontSiteEnd()
                     LEFT JOIN ObjectFloat AS PriceSite_DiscontAmount
                                           ON PriceSite_DiscontAmount.ObjectId = _tmpList.GoodsId_retail
                                          AND PriceSite_DiscontAmount.DescId = zc_ObjectFloat_Goods_DiscontAmountSite()
                     LEFT JOIN ObjectFloat AS PriceSite_DiscontPercent
                                           ON PriceSite_DiscontPercent.ObjectId = _tmpList.GoodsId_retail
                                          AND PriceSite_DiscontPercent.DescId = zc_ObjectFloat_Goods_DiscontPercentSite()
               )
          , Price_Unit AS
               (SELECT Price_Unit_all.UnitId
                     , Price_Unit_all.GoodsId
                     , Price_Unit_all.Price
                     , Price_Unit_all.isTop
                FROM Price_Unit_all
               )
          , tmpPDGoodsRemains AS
               (SELECT PDGoodsRemains.GoodsId, PDGoodsRemains.UnitId, SUM( PDGoodsRemains.Amount) AS Amount
                FROM _tmpContainerCountPD AS PDGoodsRemains
                GROUP BY  PDGoodsRemains.GoodsId, PDGoodsRemains.UnitId
                )
          , tmpPrice_Site AS (SELECT Object_PriceSite.Id                        AS Id
                                   , CASE WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                           AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                           AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                           AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                           AND COALESCE (PriceSite_DiscontAmount.ValueData, 0) > 0
                                          THEN ROUND(Price_Value.ValueData - COALESCE (PriceSite_DiscontAmount.ValueData, 0), 2)
                                          WHEN PriceSite_DiscontStart.ValueData IS NOT NULL
                                           AND PriceSite_DiscontEnd.ValueData IS NOT NULL  
                                           AND PriceSite_DiscontStart.ValueData <= CURRENT_DATE
                                           AND PriceSite_DiscontEnd.ValueData >= CURRENT_DATE
                                           AND COALESCE (PriceSite_DiscontPercent.ValueData, 0) > 0 
                                          THEN ROUND(Price_Value.ValueData * (100 - COALESCE (PriceSite_DiscontPercent.ValueData, 0)) / 100, 1)
                                          ELSE ROUND(Price_Value.ValueData, 2) END::TFloat     AS Price
                                   , Price_Goods.ChildObjectId                  AS GoodsId
                                   , PriceSite_DiscontStart.ValueData           AS DiscontStart
                                   , PriceSite_DiscontEnd.ValueData             AS DiscontEnd
                                   , PriceSite_DiscontAmount.ValueData          AS DiscontAmount
                                   , PriceSite_DiscontPercent.ValueData         AS DiscontPercent
                              FROM Object AS Object_PriceSite
                                   INNER JOIN ObjectLink AS Price_Goods
                                           ON Price_Goods.ObjectId = Object_PriceSite.Id
                                          AND Price_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                   INNER JOIN (SELECT DISTINCT _tmpGoodsMinPrice_List.GoodsId FROM _tmpGoodsMinPrice_List) AS _List ON _List.GoodsId = Price_Goods.ChildObjectId  
                                   LEFT JOIN ObjectFloat AS Price_Value
                                          ON Price_Value.ObjectId = Object_PriceSite.Id
                                         AND Price_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                                   LEFT JOIN ObjectDate AS PriceSite_DiscontStart
                                                        ON PriceSite_DiscontStart.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_DiscontStart.DescId = zc_ObjectDate_PriceSite_DiscontStart()
                                   LEFT JOIN ObjectDate AS PriceSite_DiscontEnd
                                                        ON PriceSite_DiscontEnd.ObjectId = Object_PriceSite.Id
                                                       AND PriceSite_DiscontEnd.DescId = zc_ObjectDate_PriceSite_DiscontEnd()
                                   LEFT JOIN ObjectFloat AS PriceSite_DiscontAmount
                                                         ON PriceSite_DiscontAmount.ObjectId = Object_PriceSite.Id
                                                        AND PriceSite_DiscontAmount.DescId = zc_ObjectFloat_PriceSite_DiscontAmount()
                                   LEFT JOIN ObjectFloat AS PriceSite_DiscontPercent
                                                         ON PriceSite_DiscontPercent.ObjectId = Object_PriceSite.Id
                                                        AND PriceSite_DiscontPercent.DescId = zc_ObjectFloat_PriceSite_DiscontPercent()
                              WHERE Object_PriceSite.DescId = zc_Object_PriceSite()
                                AND Price_Goods.ChildObjectId NOT IN (SELECT DISTINCT ObjectLink_BarCode_Goods.ChildObjectId  AS GoodsId
                                                                      FROM Object AS Object_BarCode
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                                                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                                                           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                                                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                                                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                                                           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                                                      WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                                                        AND Object_BarCode.isErased = False
                                                                        AND Object_Object.isErased = False)
                                AND Price_Goods.ChildObjectId NOT IN (SELECT Promo.GoodsId
                                                                      FROM gpSelect_MovementItem_Promo(inMovementId := 20813880 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3') as Promo
                                                                      )
                                AND FALSE
                              )
                              
       -- Отложенные технические переучеты
       , tmpMovementTP AS (SELECT MovementItemMaster.ObjectId      AS GoodsId
                                , MovementLinkObject_Unit.ObjectId AS UnitId
                                , SUM(-MovementItemMaster.Amount)  AS Amount
                           FROM Movement AS Movement

                                INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                              ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                             AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                               
                                INNER JOIN MovementItem AS MovementItemMaster
                                                        ON MovementItemMaster.MovementId = Movement.Id
                                                       AND MovementItemMaster.DescId     = zc_MI_Master()
                                                       AND MovementItemMaster.isErased   = FALSE
                                                       AND MovementItemMaster.Amount     < 0
                                                         
                                INNER JOIN MovementItemBoolean AS MIBoolean_Deferred
                                                               ON MIBoolean_Deferred.MovementItemId = MovementItemMaster.Id
                                                              AND MIBoolean_Deferred.DescId         = zc_MIBoolean_Deferred()
                                                              AND MIBoolean_Deferred.ValueData      = TRUE
                                                               
                           WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                             AND Movement.StatusId = zc_Enum_Status_UnComplete()
                           GROUP BY MovementItemMaster.ObjectId
                                  , MovementLinkObject_Unit.ObjectId)                      
                           

        SELECT Object_Goods.Id                                                     AS Id

             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END::Integer   AS deleted

             , tmpList.UnitId                                                      AS UnitId
             , CASE WHEN (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0)) <= 0 THEN NULL
                    ELSE (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                            COALESCE (PDGoodsRemains.Amount, 0) -
                                            COALESCE (Reserve_TP.Amount, 0))
                    END ::TFloat                                                   AS Remains

             , CASE WHEN COALESCE((tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                  COALESCE (PDGoodsRemains.Amount, 0) -
                                  COALESCE (Reserve_TP.Amount, 0)), 0) <= 0
                    THEN Null
                    WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                    THEN CASE WHEN COALESCE(tmpPrice_Site.Price, 0) > 0 AND tmpPrice_Site.Price > Price_Unit.Price
                                        THEN tmpPrice_Site.Price ELSE Price_Unit.Price END
                    ELSE Price_Unit.Price END :: TFloat  AS Price_unit
             
             
             , CASE WHEN COALESCE((tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                  COALESCE (PDGoodsRemains.Amount, 0) -
                                  COALESCE (Reserve_TP.Amount, 0)), 0) <= 0
                    THEN Null
                    WHEN tmpList.GoodsId_retail = tmpList.GoodsId
                    THEN COALESCE (tmpPrice_Site.Price, Price_Unit.Price)
                    ELSE Price_Unit.Price END :: TFloat AS Price_unit_sale

             , COALESCE(tmpList.Multiplicity, 0) :: TFloat AS Multiplicity

        FROM _tmpList AS tmpList 

             LEFT JOIN tmpMI_Deferred ON tmpMI_Deferred.GoodsId = tmpList.GoodsId_retail
                                     AND tmpMI_Deferred.UnitId  = tmpList.UnitId

             LEFT OUTER JOIN tmpMovementTP AS Reserve_TP ON Reserve_TP.GoodsId = tmpList.GoodsId_retail
                                                        AND Reserve_TP.UnitId = tmpList.UnitId

             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = tmpList.GoodsId
                                     AND Price_Unit.UnitId      = tmpList.UnitId
                                     
             LEFT JOIN tmpPrice_Site  ON tmpPrice_Site.GoodsId     = tmpList.GoodsId
             
             
             LEFT JOIN _tmpContainerCount AS tmpList2
                                          ON tmpList2.GoodsId = tmpList.GoodsId
                                         AND tmpList2.UnitId  = tmpList.UnitId

             LEFT JOIN Object AS Object_Goods    ON Object_Goods.Id    = tmpList.GoodsId

             LEFT JOIN tmpPDGoodsRemains AS PDGoodsRemains
                                         ON PDGoodsRemains.GoodsId = tmpList.GoodsId_retail
                                        AND PDGoodsRemains.UnitId = tmpList.UnitId
        WHERE COALESCE(CASE WHEN (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                               COALESCE (PDGoodsRemains.Amount, 0) -
                                               COALESCE (Reserve_TP.Amount, 0)) <= 0 THEN NULL
                       ELSE (tmpList2.Amount - COALESCE (tmpMI_Deferred.Amount, 0) -
                                               COALESCE (PDGoodsRemains.Amount, 0) -
                                               COALESCE (Reserve_TP.Amount, 0))
                       END, 0) > 0
        ORDER BY Price_Unit.Price
       ;
       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 08.06.22                                                                    *
*/

-- тест


SELECT OBJECT_Unit.valuedata, OBJECT_Goods.valuedata, p.* FROM gpSelect_GoodsOnUnit_ForSiteMobile ('16240371,8156016,377610,11769526,183292,4135547,14422124,14422095,377606,6128298,13338606,377595,12607257,377605,494882,10779386,394426,183289,8393158,6309262,13311246,377613,7117700,377594,377574,15212291,12812109,13711869,183291,1781716,5120968,9771036,6608396,375626,375627,11152911,10128935,472116,15171089', 
                                                                                                   '6307 ', zfCalc_UserSite()) AS p
 LEFT JOIN OBJECT AS OBJECT_Unit ON OBJECT_Unit.ID = p.UnitId
 LEFT JOIN OBJECT AS OBJECT_Goods ON OBJECT_Goods.ID = p.Id;
 