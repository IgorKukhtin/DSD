-- Function: gpReport_PriceCheck()

DROP FUNCTION IF EXISTS gpReport_PriceCheck (TFloat, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceCheck(
    IN inPercent          TFloat    , -- Процент отклонения
    IN inUserId           Integer   , -- Сотрудник
    IN inisHideExceptRed  Boolean   , -- Скрыть кроме красных
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE curUnit refcursor;
   DECLARE vbQueryText Text;
   DECLARE vbID Integer;
   DECLARE vbUnitID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

      -- Подразделения
    CREATE TEMP TABLE tmpUnitManager (
            UnitId          Integer,
            ManagerId       Integer
      ) ON COMMIT DROP;

    WITH tmpUnit AS (SELECT DISTINCT MovementLinkObject_Unit.ObjectId           AS UnitId
                     FROM Movement

                          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                     WHERE Movement.DescId = zc_Movement_Check()
                       AND Movement.OperDate >= CURRENT_DATE - INTERVAL '7 DAY')

    INSERT INTO tmpUnitManager (UnitId, ManagerId)
    SELECT tmpUnit.UnitId
         , ObjectLink_Unit_UserManager.ChildObjectId             AS ManagerId
    FROM tmpUnit

         LEFT JOIN ObjectLink AS ObjectLink_Unit_UserManager
                              ON ObjectLink_Unit_UserManager.ObjectId = tmpUnit.UnitId
                             AND ObjectLink_Unit_UserManager.DescId = zc_ObjectLink_Unit_UserManager()
    ;

      -- Цены по подразделениям
    CREATE TEMP TABLE tmpUnitPrice (
            UnitId          Integer,
            GoodsId         Integer,
            Price           TFloat ,
            Ord             Integer,
            ManagerId       Integer
      ) ON COMMIT DROP;

    WITH tmpContainerAll AS (SELECT DISTINCT
                                    Container.WhereObjectId                 AS UnitID
                                  , Container.ObjectId                      AS GoodsId
                             FROM Container

                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount > 0
                               AND Container.WhereObjectId IN (SELECT tmpUnitManager.UnitId FROM tmpUnitManager)
                            ),

         tmpPrice AS (SELECT ObjectLink_Price_Unit.ChildObjectId                   AS UnitId
                           , Object_Goods_Retail.GoodsMainId                       AS GoodsId
                           , ROUND (Price_Value.ValueData, 2):: TFloat             AS Price
                           , ROW_NUMBER() OVER (PARTITION BY Price_Goods.ChildObjectId ORDER BY Price_Value.ValueData) AS Ord
                           , tmpUnitManager.ManagerId                              AS ManagerId
                      FROM ObjectLink AS ObjectLink_Price_Unit
                           INNER JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Price_Goods.ChildObjectId

                           INNER JOIN tmpContainerAll ON tmpContainerAll.UnitID = ObjectLink_Price_Unit.ChildObjectId
                                                     AND tmpContainerAll.GoodsId = Price_Goods.ChildObjectId

                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()

                           LEFT JOIN tmpUnitManager ON tmpUnitManager.UnitId = ObjectLink_Price_Unit.ChildObjectId

                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ROUND (Price_Value.ValueData, 2) > 0)

    INSERT INTO tmpUnitPrice (UnitId, GoodsId, Price, Ord, ManagerId)
    SELECT tmpPrice.UnitId
         , tmpPrice.GoodsId
         , tmpPrice.Price
         , tmpPrice.Ord
         , tmpPrice.ManagerId
    FROM tmpPrice;


      -- Pезультат
    CREATE TEMP TABLE tmpResult (
            GoodsId         Integer,
            GoodsCode       Integer,
            GoodsName       TVarChar,
            UnitCount       Integer,
            BadPriceCount   Integer,
            BadPriceMinus   Integer,
            isBadPriceUser  Boolean,
            PriceIn         TFLoat,
            DateIn          TDateTime,
            JuridicalInName TVarChar,
            JuridicalPrice  TFLoat,
            PriceAverage    TFLoat,
            PriceMin        TFLoat,
            PriceMax        TFLoat

      ) ON COMMIT DROP;

    -- Собираем товары
    INSERT INTO tmpResult (GoodsId, GoodsCode, GoodsName, UnitCount, BadPriceCount, isBadPriceUser, BadPriceMinus, PriceAverage, PriceMin, PriceMax)
    SELECT tmpUnitPrice.GoodsId
         , Object_Goods.ObjectCode       AS GoodsCode
         , Object_Goods.ValueData        AS GoodsName
         , COUNT(*)
         , 0
         , False
         , 0
         , 0
         , MIN(tmpUnitPrice.Price)
         , MAX(tmpUnitPrice.Price)
    FROM tmpUnitPrice
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpUnitPrice.GoodsId
    GROUP BY tmpUnitPrice.GoodsId, Object_Goods.ObjectCode, Object_Goods.ValueData
    HAVING (MIN(tmpUnitPrice.Price) * (100.0 + inPercent) / 100.0) < MAX(tmpUnitPrice.Price)
    ORDER BY tmpUnitPrice.GoodsId;

    -- Расчитываем среднюю цену
    UPDATE tmpResult SET PriceAverage = T1.PriceAverage
    FROM (SELECT tmpUnitPrice.GoodsId
               , ROUND(SUM(tmpUnitPrice.Price) / COUNT(*), 2) AS PriceAverage
          FROM tmpUnitPrice
               INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
          WHERE tmpResult.UnitCount <= 2
             OR tmpResult.UnitCount > 2 AND tmpResult.UnitCount <= 5 AND tmpUnitPrice.Ord > 1 AND tmpUnitPrice.Ord < tmpResult.UnitCount
             OR tmpResult.UnitCount > 5 AND tmpUnitPrice.Ord > 2 AND tmpUnitPrice.Ord < tmpResult.UnitCount - 2
          GROUP BY tmpUnitPrice.GoodsId) AS T1
    WHERE tmpResult.GoodsId = T1.GoodsId;

    -- Удаляем что номально
    DELETE FROM tmpResult
    WHERE tmpResult.PriceAverage * (100.0 + inPercent) / 100.0 <= tmpResult.PriceMax
       AND tmpResult.PriceAverage * (100.0 - inPercent) / 100.0 >= tmpResult.PriceMin;

      -- Подразделения
    CREATE TEMP TABLE tmpUnit (
            Id              Integer,
            UnitId          Integer,
            ManagerId       Integer
           ) ON COMMIT DROP;

    INSERT INTO tmpUnit (Id, UnitId, ManagerId)
    SELECT ROW_NUMBER() OVER (ORDER BY tmpUnitPrice.UnitID) AS Id
         , tmpUnitPrice.UnitID
         , tmpUnitPrice.ManagerId
    FROM tmpUnitPrice
         INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
    GROUP BY tmpUnitPrice.UnitID, tmpUnitPrice.ManagerId
    ORDER BY tmpUnitPrice.UnitID;

      -- Заполняем подразделение

    OPEN curUnit FOR SELECT * FROM tmpUnit ORDER BY tmpUnit;
    LOOP
        FETCH curUnit INTO vbID, vbUnitID;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Price' || COALESCE (vbID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
          ' , ADD COLUMN Color_calc' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT zc_Color_Black() ';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE tmpResult set Price' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.T_Price, 0)' ||
          ', Color_calc' || COALESCE (vbID, 0)::Text || ' = COALESCE (T1.T_Color_calc, 0)' ||
          ', BadPriceCount = BadPriceCount + CASE WHEN COALESCE (T1.T_Color_calc, 0) = zc_Color_Red() THEN 1 ELSE 0 END' ||
          ', BadPriceMinus = BadPriceMinus + CASE WHEN COALESCE (T1.T_Color_calc, 0) = zc_Color_Red() AND COALESCE (T1.T_Price, 0) < tmpResult.PriceAverage THEN 1 ELSE 0 END' ||
          ', isBadPriceUser = isBadPriceUser OR CASE WHEN COALESCE (T1.T_Color_calc, 0) = zc_Color_Red() AND T1.ManagerId = '||inUserId::Text||'  THEN TRUE ELSE FALSE END' ||
          ' FROM (SELECT
             tmpUnitPrice.GoodsID AS GoodsID,
             tmpUnitPrice.Price AS T_Price,
             CASE WHEN tmpResult.PriceAverage * (100.0 + '||inPercent::Text||') / 100.0 < tmpUnitPrice.Price
                    OR tmpResult.PriceAverage * (100.0 - '||inPercent::Text||') / 100.0 > tmpUnitPrice.Price
                  THEN zc_Color_Red() ELSE zc_Color_Black() END AS T_Color_calc,
             tmpUnitPrice.ManagerId
           FROM tmpUnitPrice
                INNER JOIN tmpResult ON tmpResult.GoodsId = tmpUnitPrice.GoodsId
           WHERE tmpUnitPrice.UnitID = ' || COALESCE (vbUnitID, 0)::Text||') AS T1
           WHERE tmpResult.GoodsId = T1.GoodsId'||
            ' AND (COALESCE (T1.T_Color_calc, 0) = zc_Color_Red() OR '||COALESCE(inisHideExceptRed, False)::Text||' = FALSE)';
        EXECUTE vbQueryText;

    END LOOP;
    CLOSE curUnit;

    -- Удаляем что номально
    DELETE FROM tmpResult
    WHERE tmpResult.BadPriceCount = 0;

    -- Удаляем ксли нет аптек менеджера
    IF COALESCE (inUserId, 0) <> 0
    THEN
      DELETE FROM tmpResult
      WHERE tmpResult.isBadPriceUser = False;
    END IF;


    -- Ищем последнюю цену в приходах
    UPDATE tmpResult SET PriceIn = T1.PriceWithVAT, DateIn = T1.OperDate, JuridicalInName = T1.FromName
    FROM (WITH tmpUnit AS (SELECT tmpUnitManager.UnitId            AS UnitId
                           FROM tmpUnitManager

                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                      ON ObjectLink_Unit_Area.ObjectId = tmpUnitManager.UnitId
                                                     AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()

                           WHERE ObjectLink_Unit_Area.ChildObjectId = 5803492)
             , tmpGoods AS (SELECT tmpResult.GoodsId      AS GoodsId
                                 , Object_Goods_Retail.Id AS GoodsRetailID
                            FROM tmpResult

                                 INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainID = tmpResult.GoodsId
                                                               AND Object_Goods_Retail.RetailID = 4
                            )
             , tmpContainer AS (SELECT Container.ObjectId                        AS GoodsId
                                     , MAX(Container.Id)                         AS ContainerId
                                FROM Container
                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.ObjectId IN (SELECT tmpGoods.GoodsRetailID FROM tmpGoods)
                                  AND Container.WhereObjectId IN (SELECT tmpUnit.UnitId FROM tmpUnit)
                                GROUP BY Container.ObjectId)
             , tmpMI AS (SELECT Container.GoodsId                                                                            AS GoodsId
                              , COALESCE((MIFloat_MovementItem.ValueData :: Integer), Object_PartionMovementItem.ObjectCode) AS MovementItemId
                         FROM tmpContainer AS Container

                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerId
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = Object_PartionMovementItem.ObjectCode
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()

                         )

          SELECT Object_Goods_Retail.GoodsMainID AS GoodsID
               , Movement.OperDate
               , Object_From.ValueData           AS FromName
               , MIFloat_PriceWithVAT.ValueData  AS PriceWithVAT
          FROM tmpMI

               INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = tmpMI.GoodsId

               INNER JOIN MovementItem ON MovementItem.ID = tmpMI.MovementItemId

               LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                           ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                          AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()

               INNER JOIN Movement ON Movement.ID = MovementItem.MovementID

               LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                            ON MovementLinkObject_From.MovementId = Movement.Id
                                           AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
               LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId) AS T1
    WHERE tmpResult.GoodsId = T1.GoodsId;

    -- Последняя цена из прайса Днепр
    UPDATE tmpResult SET JuridicalPrice = T1.JuridicalPrice
    FROM (WITH DD AS (SELECT DISTINCT
            Object_MarginCategoryItem_View.MarginPercent,
            Object_MarginCategoryItem_View.MinPrice,
            Object_MarginCategoryItem_View.MarginCategoryId,
            ROW_NUMBER()OVER(PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) as ORD
        FROM Object_MarginCategoryItem_View
             INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                           AND Object_MarginCategoryItem.isErased = FALSE
                )
        , MarginCondition AS (SELECT
            D1.MarginCategoryId,
            D1.MarginPercent,
            D1.MinPrice,
            COALESCE(D2.MinPrice, 1000000) AS MaxPrice
        FROM DD AS D1
            LEFT OUTER JOIN DD AS D2 ON D1.MarginCategoryId = D2.MarginCategoryId AND D1.ORD = D2.ORD-1)

          , tmpContractSettings AS (SELECT Object_ContractSettings.Id               AS Id
                                         , Object_ContractSettings.isErased         AS isErased
                                         , ObjectLink_MainJuridical.ChildObjectId   AS MainJuridicalId
                                         , ObjectLink_Contract.ChildObjectId        AS ContractId
                                         , ObjectLink_Area.ChildObjectId            AS AreaId
                                    FROM ObjectLink AS ObjectLink_MainJuridical
                                       INNER JOIN ObjectLink AS ObjectLink_Contract
                                                             ON ObjectLink_Contract.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                            AND ObjectLink_Contract.DescId = zc_ObjectLink_ContractSettings_Contract()
                                       LEFT JOIN ObjectLink AS ObjectLink_Area
                                                            ON ObjectLink_Area.ObjectId = ObjectLink_MainJuridical.ObjectId
                                                           AND ObjectLink_Area.DescId = zc_ObjectLink_ContractSettings_Area()

                                       LEFT JOIN Object AS Object_ContractSettings ON Object_ContractSettings.Id = ObjectLink_MainJuridical.ObjectId
                                    WHERE ObjectLink_MainJuridical.DescId = zc_ObjectLink_ContractSettings_MainJuridical()
                                    )

          , tmpMainJuridicalArea AS (SELECT DISTINCT ObjectLink_JuridicalRetail.ObjectId      AS MainJuridicalId
                                          , ObjectLink_Unit_Area.ChildObjectId                AS AreaId
                                     FROM ObjectLink AS ObjectLink_JuridicalRetail
                                          LEFT JOIN ObjectLink AS OL_Unit_Juridical
                                                               ON OL_Unit_Juridical.ChildObjectId = ObjectLink_JuridicalRetail.ObjectId
                                                              AND OL_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                          LEFT JOIN ObjectLink AS ObjectLink_Unit_Area
                                                               ON ObjectLink_Unit_Area.ObjectId = OL_Unit_Juridical.ObjectId
                                                              AND ObjectLink_Unit_Area.DescId = zc_ObjectLink_Unit_Area()
                                                             AND  ObjectLink_Unit_Area.ChildObjectId  <> 0
                                     WHERE ObjectLink_JuridicalRetail.DescId = zc_ObjectLink_Juridical_Retail()
                                       AND ObjectLink_JuridicalRetail.ChildObjectId = 4
                                     )
          , tmpNDSKind AS
                (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                       , ObjectFloat_NDSKind_NDS.ValueData
                 FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                 WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                )
          , tmpGoodsPrice AS (SELECT

                                     LoadPriceListItem.GoodsId           AS GoodsId,
                                     LoadPriceList.JuridicalId           AS JuridicalId,
                                     LoadPriceList.ContractId            AS ContractId,
                                     LoadPriceList.AreaId                AS AreaId,
                                     MAX(LoadPriceListItem.Price * (100 + COALESCE(CASE WHEN LoadPriceListItem.GoodsNDS LIKE '%2%' THEN 20
                                                                                                                     WHEN LoadPriceListItem.GoodsNDS LIKE '%7%' THEN 7
                                                                                                                     WHEN LoadPriceListItem.GoodsNDS IN ('0', 'Без НДС') THEN 0 END,
                                                                                                                     ObjectFloat_NDSKind_NDS.ValueData, 0))/100)     AS JuridicalPrice

                                   FROM LoadPriceList

                                        INNER JOIN tmpMainJuridicalArea ON (LoadPriceList.AreaId = COALESCE (tmpMainJuridicalArea.AreaId, 0)
                                                                   OR COALESCE (LoadPriceList.AreaId, 0)  = 0
                                                                      )

                                        LEFT JOIN tmpContractSettings ON tmpContractSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                                                     AND tmpContractSettings.ContractId = LoadPriceList.ContractId
                                                                     AND (COALESCE (tmpContractSettings.AreaId, 0) = COALESCE (LoadPriceList.AreaId, 0))

                                        LEFT JOIN
                                            (SELECT DISTINCT
                                                    ObjectLink_JuridicalSettings_Juridical.ChildObjectId                AS JuridicalId
                                                  , ObjectLink_JuridicalSettings_MainJuridical.ChildObjectId            AS MainJuridicalId
                                                  , COALESCE (ObjectLink_JuridicalSettings_Contract.ChildObjectId, 0)   AS ContractId
                                                  , COALESCE (ObjectBoolean_isPriceCloseOrder.ValueData, FALSE)         AS isPriceCloseOrder
                                             FROM ObjectLink AS ObjectLink_JuridicalSettings_Retail

                                                  JOIN ObjectLink AS ObjectLink_JuridicalSettings_Juridical
                                                                  ON ObjectLink_JuridicalSettings_Juridical.DescId = zc_ObjectLink_JuridicalSettings_Juridical()
                                                                 AND ObjectLink_JuridicalSettings_Juridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId

                                                  JOIN ObjectLink AS ObjectLink_JuridicalSettings_MainJuridical
                                                                  ON ObjectLink_JuridicalSettings_MainJuridical.DescId = zc_ObjectLink_JuridicalSettings_MainJuridical()
                                                                 AND ObjectLink_JuridicalSettings_MainJuridical.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId

                                                  LEFT JOIN ObjectLink AS ObjectLink_JuridicalSettings_Contract
                                                                       ON ObjectLink_JuridicalSettings_Contract.DescId = zc_ObjectLink_JuridicalSettings_Contract()
                                                                      AND ObjectLink_JuridicalSettings_Contract.ObjectId = ObjectLink_JuridicalSettings_Juridical.ObjectId

                                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceCloseOrder
                                                                          ON ObjectBoolean_isPriceCloseOrder.ObjectId = ObjectLink_JuridicalSettings_Retail.ObjectId
                                                                         AND ObjectBoolean_isPriceCloseOrder.DescId = zc_ObjectBoolean_JuridicalSettings_isPriceCloseOrder()

                                             WHERE ObjectLink_JuridicalSettings_Retail.DescId = zc_ObjectLink_JuridicalSettings_Retail()
                                             AND ObjectLink_JuridicalSettings_Retail.ChildObjectId = 4) AS JuridicalSettings
                                                                                                                 ON JuridicalSettings.JuridicalId = LoadPriceList.JuridicalId
                                                                                                                AND JuridicalSettings.MainJuridicalId = tmpMainJuridicalArea.MainJuridicalId
                                                                                                                AND JuridicalSettings.ContractId = COALESCE (LoadPriceList.ContractId, 0)

                                        INNER JOIN LoadPriceListItem ON LoadPriceList.Id = LoadPriceListItem.LoadPriceListId

                                        INNER JOIN tmpResult ON tmpResult.GoodsId = LoadPriceListItem.GoodsId

                                        INNER JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = LoadPriceListItem.GoodsId

                                        LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                                                             ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods.NDSKindId

                                 WHERE COALESCE (tmpContractSettings.isErased, False) = False
                                   AND COALESCE (JuridicalSettings.isPriceCloseOrder, TRUE) = False
                                   AND LoadPriceList.AreaId = 5803492
                                 GROUP BY LoadPriceListItem.GoodsId,
                                          LoadPriceList.JuridicalId,
                                          LoadPriceList.ContractId,
                                          LoadPriceList.AreaId)
          , tmpGoodsPriceOrd AS (SELECT tmpGoodsPrice.GoodsId                          AS GoodsId,
                                        ROUND(tmpGoodsPrice.JuridicalPrice, 2)::TFloat AS JuridicalPrice,
                                        ROW_NUMBER() OVER (PARTITION BY tmpGoodsPrice.GoodsId ORDER BY tmpGoodsPrice.JuridicalPrice) AS Ord
                                   FROM tmpGoodsPrice
                                 )

          SELECT tmpGoodsPriceOrd.GoodsId                 AS GoodsId,
                 tmpGoodsPriceOrd.JuridicalPrice          AS JuridicalPrice
          FROM tmpGoodsPriceOrd
          WHERE tmpGoodsPriceOrd.Ord = 1) AS T1
    WHERE tmpResult.GoodsId = T1.GoodsId;

       -- Вывод результата
       -- Подразделения для кросса
    OPEN cur1 FOR
    SELECT tmpUnit.ID
         , tmpUnit.UnitID
         , Object_Unit.ValueData||COALESCE(CHR(13)||Object_Manager.ValueData, '')  AS UnitName
    FROM tmpUnit
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitID
         LEFT JOIN Object AS Object_Manager ON Object_Manager.Id = tmpUnit.ManagerId
    ORDER BY tmpUnit.UnitID;
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
 07.11.20                                                       *
*/

-- тест
--
select * from gpReport_PriceCheck(inPercent := 5, inUserId := 0, inisHideExceptRed := False, inSession := '3');               