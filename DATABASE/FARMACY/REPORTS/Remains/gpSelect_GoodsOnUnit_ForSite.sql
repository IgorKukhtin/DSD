-- Function: gpSelect_GoodsOnUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inGoodsId_list     TVarChar ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Article           Integer
             , Id_Site           Integer
             , Name_Site         TBlob
             , Name              TVarChar
             , foto              TVarChar
             , thumb             TVarChar
             , description       TBlob
             , appointment_id    Integer
             , category_id       Integer
             , Name_category     TVarChar
             , published         Integer
             , deleted           Integer
             , ObjectId          Integer
             , ObjectName        TVarChar
             , UnitId            Integer
             , UnitName          TVarChar
             , Remains           TFloat

             , JuridicalId       Integer
             , JuridicalName     TVarChar
             , ContractId        Integer
             , ContractName      TVarChar
             , Manufacturer      TVarChar
             , MinExpirationDate TDateTime
             , Price_unit        TFloat
             , Price_minO        TFloat
             , Price_min         TFloat
             , Price_minD        TFloat

             , MarginPercent           TFloat
             , MarginPercent_site      TFloat
             , MarginCategoryName      TVarChar
             , MarginCategoryName_site TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbIndex Integer;
   DECLARE vbMarginCategoryId Integer;
   DECLARE vbMarginCategoryId_site Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', vbUserId);


    -- поиск категории
    vbMarginCategoryId:= (SELECT ObjectLink_MarginCategory.ChildObjectId
                          FROM ObjectLink AS ObjectLink_MarginCategoryLink_Unit
                               LEFT JOIN ObjectLink AS ObjectLink_MarginCategory
                                                    ON ObjectLink_MarginCategory.ObjectId = ObjectLink_MarginCategoryLink_Unit.ObjectId
                                                   AND ObjectLink_MarginCategory.DescId   = zc_ObjectLink_MarginCategoryLink_MarginCategory()
                               LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                                     ON ObjectFloat_Percent.ObjectId = ObjectLink_MarginCategory.ChildObjectId
                                                    AND ObjectFloat_Percent.DescId   = zc_ObjectFloat_MarginCategory_Percent()
                          WHERE ObjectLink_MarginCategoryLink_Unit.ChildObjectId = inUnitId
                            AND ObjectLink_MarginCategoryLink_Unit.DescId        = zc_ObjectLink_MarginCategoryLink_Unit()
                            AND COALESCE (ObjectFloat_Percent.ValueData, 0) = 0 -- !!!вот так криво!!!
                          LIMIT 1
                         );
    -- поиск категории для сайта
    vbMarginCategoryId_site:= (SELECT ObjectBoolean.ObjectId
                               FROM ObjectBoolean
                               WHERE ObjectBoolean.ValueData = TRUE
                                 AND ObjectBoolean.DescId = zc_ObjectBoolean_MarginCategory_Site()
                               LIMIT 1
                              );

    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = '_tmpgoodsminprice_list')
    THEN
        -- таблица
        CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer);
    ELSE
        DELETE FROM _tmpGoodsMinPrice_List;
    END IF;

    -- парсим типы документов
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId) SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex) :: Integer;
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    -- если нет товаров
    IF NOT EXISTS (SELECT 1 FROM _tmpGoodsMinPrice_List)
    THEN
         -- все остатки
         INSERT INTO _tmpGoodsMinPrice_List (GoodsId)
           SELECT DISTINCT Container.ObjectId -- здесь товар "сети"
           FROM Container
           WHERE Container.DescId = zc_Container_Count()
             AND Container.WhereObjectId = inUnitId
             AND Container.Amount <> 0;
    END IF;

    -- Результат
    RETURN QUERY
       WITH ContainerCount AS
               (SELECT Container.ObjectId     AS GoodsId
                     , SUM (Container.Amount) AS Amount
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN Container ON Container.ObjectId = _tmpGoodsMinPrice_List.GoodsId
                                         AND Container.WhereObjectId = inUnitId
                                         AND Container.DescId        = zc_Container_Count()
                                         AND Container.Amount <> 0
                GROUP BY Container.ObjectId
                HAVING SUM (Container.Amount) > 0
               )
          , MinPrice_List AS
               (SELECT tmp.*
                FROM lpSelectMinPrice_List (inUnitId  := inUnitId
                                          , inObjectId:= vbObjectId
                                          , inUserId  := vbUserId
                                           ) AS tmp
               )
          , Price_Unit AS
               (SELECT _tmpGoodsMinPrice_List.GoodsId
                     , ROUND (ObjectFloat_Price_Value.ValueData, 2) :: TFloat AS Price
                FROM _tmpGoodsMinPrice_List
                     INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                           ON ObjectLink_Price_Goods.ChildObjectId = _tmpGoodsMinPrice_List.GoodsId
                                          AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                     INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                           ON ObjectLink_Price_Unit.ObjectId      = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectLink_Price_Unit.ChildObjectId = inUnitId
                                          AND ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                     LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                           ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Goods.ObjectId
                                          AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
               )
          , MarginCategory_all AS
               (SELECT DISTINCT 
                       Object_MarginCategoryItem_View.MarginPercent
                     , Object_MarginCategoryItem_View.MinPrice
                     , Object_MarginCategoryItem_View.MarginCategoryId
                     , ROW_NUMBER() OVER (PARTITION BY Object_MarginCategoryItem_View.MarginCategoryId ORDER BY Object_MarginCategoryItem_View.MinPrice) AS ORD
                FROM Object_MarginCategoryItem_View
                WHERE MarginCategoryId IN (vbMarginCategoryId, vbMarginCategoryId_site)
               )
          , MarginCategory AS
               (SELECT DISTINCT 
                       MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice 
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId = vbMarginCategoryId
               )
          , MarginCategory_site AS
               (SELECT DISTINCT 
                       MarginCategory_all.MarginPercent
                     , MarginCategory_all.MinPrice
                     , COALESCE (MarginCategory_all_next.MinPrice, 1000000) AS MaxPrice 
                FROM MarginCategory_all
                     LEFT JOIN MarginCategory_all AS MarginCategory_all_next ON MarginCategory_all_next.MarginCategoryId = MarginCategory_all.MarginCategoryId
                                                                            AND MarginCategory_all_next.ORD = MarginCategory_all.ORD + 1
                WHERE MarginCategory_all.MarginCategoryId = vbMarginCategoryId_site
               )

        SELECT Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.ValueData                      AS Name
             , ObjectString_Foto.ValueData                             AS foto
             , ObjectString_Thumb.ValueData                            AS thumb
             , ObjectBlob_Description.ValueData                        AS description
             , ObjectLink_Goods_Appointment.ChildObjectId              AS appointment_id
             , ObjectLink_Goods_GoodsGroup.ChildObjectId               AS category_id
             , Object_GoodsGroup.ValueData                             AS Name_category

             , CASE WHEN ObjectBoolean_Goods_Published.ValueData = TRUE THEN 1 ELSE 0 END :: Integer AS published
             , CASE WHEN Object_Goods.isErased = TRUE THEN 1 ELSE 0 END                   :: Integer AS deleted

             , ObjectLink_Goods_Object.ChildObjectId                   AS ObjectId
             , Object.ValueData                                        AS ObjectName
             , Object_Unit.Id                                          AS UnitId
             , Object_Unit.ValueData                                   AS UnitName

             , ContainerCount.Amount                         :: TFloat AS Remains

             , MinPrice_List.JuridicalId
             , MinPrice_List.JuridicalName
             , MinPrice_List.ContractId
             , Object_Contract.ValueData       AS ContractName
             , MinPrice_List.MakerName         AS Manufacturer
             , MinPrice_List.PartionGoodsDate

             , Price_Unit.Price    AS Price_unit
             , MinPrice_List.Price AS Price_minO
             , ROUND (MinPrice_List.Price * (1 + COALESCE (MarginCategory.MarginPercent, 0)      / 100), 2) :: TFloat  AS Price_min
             , ROUND (MinPrice_List.Price * (1 + COALESCE (MarginCategory_site.MarginPercent, 0) / 100), 2) :: TFloat  AS Price_minD

             , MarginCategory.MarginPercent         AS MarginPercent
             , MarginCategory_site.MarginPercent    AS MarginPercent_site
             , Object_MarginCategory.ValueData      AS MarginCategoryName
             , Object_MarginCategory_site.ValueData AS MarginCategoryName_site

        FROM _tmpGoodsMinPrice_List
             LEFT JOIN Price_Unit     ON Price_Unit.GoodsId     = _tmpGoodsMinPrice_List.GoodsId
             LEFT JOIN ContainerCount ON ContainerCount.GoodsId = _tmpGoodsMinPrice_List.GoodsId
             LEFT JOIN MinPrice_List  ON MinPrice_List.GoodsId  = _tmpGoodsMinPrice_List.GoodsId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = inUnitId
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoodsMinPrice_List.GoodsId
             LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MinPrice_List.ContractId

             /*LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                    ON ObjectString_Goods_Maker.ObjectId = Object_Goods.Id
                                   AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker()*/
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                  ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
             LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                                  ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
             LEFT JOIN Object ON Object.Id = ObjectLink_Goods_Object.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Site
                                   ON ObjectFloat_Goods_Site.ObjectId = Object_Goods.Id
                                  AND ObjectFloat_Goods_Site.DescId = zc_ObjectFloat_Goods_Site()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Published
                                     ON ObjectBoolean_Goods_Published.ObjectId = Object_Goods.Id
                                    AND ObjectBoolean_Goods_Published.DescId = zc_ObjectBoolean_Goods_Published()
             LEFT JOIN ObjectString AS ObjectString_Foto
                                     ON ObjectString_Foto.ObjectId = Object_Goods.Id 
                                    AND ObjectString_Foto.DescId = zc_ObjectString_Goods_Foto()
             LEFT JOIN ObjectString AS ObjectString_Thumb
                                     ON ObjectString_Thumb.ObjectId = Object_Goods.Id
                                    AND ObjectString_Thumb.DescId = zc_ObjectString_Goods_Thumb()
             LEFT JOIN ObjectBlob AS ObjectBlob_Site
                                   ON ObjectBlob_Site.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Site.DescId = zc_objectBlob_Goods_Site()
             LEFT JOIN ObjectBlob AS ObjectBlob_Description
                                   ON ObjectBlob_Description.ObjectId = Object_Goods.Id
                                  AND ObjectBlob_Description.DescId = zc_objectBlob_Goods_Description()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Appointment
                                  ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.Id
                                 AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment()

             LEFT JOIN MarginCategory      ON MinPrice_List.Price >= MarginCategory.MinPrice      AND MinPrice_List.Price < MarginCategory.MaxPrice
             LEFT JOIN MarginCategory_site ON MinPrice_List.Price >= MarginCategory_site.MinPrice AND MinPrice_List.Price < MarginCategory_site.MaxPrice
             LEFT JOIN Object AS Object_MarginCategory      ON Object_MarginCategory.Id      = vbMarginCategoryId
             LEFT JOIN Object AS Object_MarginCategory_site ON Object_MarginCategory_site.Id = vbMarginCategoryId_site
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnit_ForSite (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.04.16                                        *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsOnUnit_ForSite (inUnitId:= 377613, inGoodsId_list:= '376', inSession:= '3');
