-- Function: gpSelect_PromoCodeGoodsOnUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_PromoCodeGoodsOnUnit_ForSite (Integer, TVarChar, Text, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_PromoCodeGoodsOnUnit_ForSite (Text, TVarChar, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoCodeGoodsOnUnit_ForSite(
    IN inUnitId_list      Text,   -- Список подразделений, через зпт
    IN inGUID             TVarChar,   -- Промо код
    IN inGoodsId_list     Text,       -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (UnitId                Integer
             , GoodsId               Integer
             , IsDiscount            Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbIndex Integer;

   DECLARE vbMovementID Integer;
   DECLARE vbMovementItemID Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- определяется <Торговая сеть>
    vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

    -- Определяем акцию и код промокода
    SELECT
      MovementID,
      MovementItemID
    INTO
      vbMovementID,
      vbMovementItemID
    FROM gpGet_PromoCodeUnitToID_ForSite(0, inGUID, True, inSession);

    IF vbMovementItemID IS NULL
    THEN
      RETURN;
    END IF;


    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'tmpGoodsMinPrice')
    THEN
        -- таблица
        CREATE TEMP TABLE tmpGoodsMinPrice (GoodsId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM tmpGoodsMinPrice;
    END IF;
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'tmpUnitMinPrice')
    THEN
        -- таблица
        CREATE TEMP TABLE tmpUnitMinPrice (UnitId Integer) ON COMMIT DROP;
    ELSE
        DELETE FROM tmpUnitMinPrice;
    END IF;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inUnitId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
      IF NOT EXISTS(SELECT 1 FROM tmpUnitMinPrice WHERE tmpUnitMinPrice.UnitId = SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer)
      THEN  
        INSERT INTO tmpUnitMinPrice (UnitId)
           SELECT tmp.UnitId
           FROM (SELECT SPLIT_PART (inUnitId_list, ',', vbIndex) :: Integer AS UnitId
                ) AS tmp
             INNER JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
                              AND Object_Unit.DescId = zc_Object_Unit();
      END IF;
        -- теперь следуюющий
      vbIndex := vbIndex + 1;
    END LOOP;

    -- парсим товары
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
      IF NOT EXISTS(SELECT 1 FROM tmpGoodsMinPrice WHERE tmpGoodsMinPrice.GoodsId = SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer)
      THEN  
        INSERT INTO tmpGoodsMinPrice (GoodsId)
           SELECT tmp.GoodsId
           FROM (SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer AS GoodsId
                ) AS tmp
             INNER JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
                              AND Object_Goods.DescId = zc_Object_Goods();
      END IF;
        -- теперь следуюющий
      vbIndex := vbIndex + 1;
    END LOOP;


    -- !!!Оптимизация!!!
    ANALYZE tmpUnitMinPrice;

    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM tmpGoodsMinPrice)
    THEN
         -- все товары учачтвующие в акции
         INSERT INTO tmpGoodsMinPrice (GoodsId)
         SELECT  MI_PromoCode.ObjectId AS GoodsId
         FROM MovementItem AS MI_PromoCode
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoCode.ObjectId
         WHERE MI_PromoCode.MovementId = vbMovementID
           AND MI_PromoCode.DescId = zc_MI_Master()
           AND MI_PromoCode.isErased = FALSE
           AND MI_PromoCode.Amount = 1;

    END IF;


    -- !!!Оптимизация!!!
    ANALYZE tmpGoodsMinPrice;


    IF EXISTS(SELECT 1 
              FROM MovementItem AS MI_PromoCode
                   INNER JOIN tmpGoodsMinPrice ON tmpGoodsMinPrice.GoodsId = MI_PromoCode.ObjectId
              WHERE MI_PromoCode.MovementId = vbMovementID
                AND MI_PromoCode.DescId = zc_MI_Master()
                AND MI_PromoCode.isErased = FALSE
                AND MI_PromoCode.Amount = 1)                   
    THEN
      -- Результат
      RETURN QUERY
       WITH Goods_PromoCode AS
               (SELECT DISTINCT MI_PromoCode.ObjectId     AS GoodsId
                FROM MovementItem AS MI_PromoCode
                      INNER JOIN tmpGoodsMinPrice ON tmpGoodsMinPrice.GoodsId = MI_PromoCode.ObjectId

                WHERE MI_PromoCode.MovementId = vbMovementID
                  AND MI_PromoCode.DescId = zc_MI_Master()
                  AND MI_PromoCode.isErased = FALSE
                  AND MI_PromoCode.Amount = 1),
           Unit_PromoCode AS
               (SELECT DISTINCT MI_PromoCode.ObjectId     AS UnitId
                FROM MovementItem AS MI_PromoCode
                      INNER JOIN tmpUnitMinPrice ON tmpUnitMinPrice.UnitId = MI_PromoCode.ObjectId

                WHERE MI_PromoCode.MovementId = vbMovementID
                  AND MI_PromoCode.DescId = zc_MI_Child()
                  AND MI_PromoCode.isErased = FALSE
                  AND MI_PromoCode.Amount = 1)


        SELECT tmpUnitMin.UnitId                                           AS UnitId
             , tmpGoodsMin.GoodsId                                         AS GoodsId
             , CASE WHEN Goods_PromoCode.GoodsId IS NOT NULL AND Unit_PromoCode.UnitId IS NOT NULL
                            THEN True ELSE False END                       AS IsDiscount

        FROM tmpGoodsMinPrice AS tmpGoodsMin
        
             INNER JOIN tmpUnitMinPrice AS tmpUnitMin ON 1 = 1

             LEFT JOIN Goods_PromoCode ON Goods_PromoCode.GoodsId = tmpGoodsMin.GoodsId

             LEFT JOIN Unit_PromoCode ON Unit_PromoCode.UnitId = tmpUnitMin.UnitId

        ORDER BY tmpUnitMin.UnitId, tmpGoodsMin.GoodsId;
    ELSE
      -- Результат
      RETURN QUERY
       WITH Unit_PromoCode AS
               (SELECT DISTINCT MI_PromoCode.ObjectId     AS UnitId
                FROM MovementItem AS MI_PromoCode
                      INNER JOIN tmpUnitMinPrice ON tmpUnitMinPrice.UnitId = MI_PromoCode.ObjectId

                WHERE MI_PromoCode.MovementId = vbMovementID
                  AND MI_PromoCode.DescId = zc_MI_Child()
                  AND MI_PromoCode.isErased = FALSE
                  AND MI_PromoCode.Amount = 1)


        SELECT tmpUnitMin.UnitId                                           AS UnitId
             , tmpGoodsMin.GoodsId                                         AS GoodsId
             , True                                                        AS IsDiscount

        FROM tmpGoodsMinPrice AS tmpGoodsMin
        
             INNER JOIN tmpUnitMinPrice AS tmpUnitMin ON 1 = 1

             LEFT JOIN Unit_PromoCode ON Unit_PromoCode.UnitId = tmpUnitMin.UnitId

        ORDER BY tmpUnitMin.UnitId, tmpGoodsMin.GoodsId;    
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 03.12.18        *
 24.07.18        *
 15.06.18        *
*/

-- тест
-- SELECT * FROM gpSelect_PromoCodeGoodsOnUnit_ForSite ('183292', 'ae4cf931', '', zfCalc_UserSite()) ORDER BY 1;
-- SELECT * FROM gpSelect_PromoCodeGoodsOnUnit_ForSite ('183290,377613,183292,183292', 'ae4cf931', '18922, 25429, 400, 56308, 346', zfCalc_UserSite()) ORDER BY 1;
