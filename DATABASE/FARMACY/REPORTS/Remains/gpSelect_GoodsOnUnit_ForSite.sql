
DROP FUNCTION IF EXISTS gpSelect_GoodsOnUnit_ForSite (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsOnUnit_ForSite(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inGoodsId_list     TVarChar ,  -- Список товаров, через зпт
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id integer, GoodsCode Integer, GoodsName TVarChar, GoodsGroupName TVarChar
             , OperAmount TFloat, Price TFloat, NDSKindName TVarChar
             , OperSum TFloat, PriceOut TFloat, SumOut TFloat
             , MinExpirationDate TDateTime)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbIndex Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);


    -- таблица
    CREATE TEMP TABLE _tmpGoodsMinPrice_List (GoodsId Integer);

    -- парсим типы документов
    vbIndex := 1;
    WHILE SPLIT_PART (inGoodsId_list, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpGoodsMinPrice_List (GoodsId) SELECT SPLIT_PART (inGoodsId_list, ',', vbIndex);
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;


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

        SELECT Object_Goods.Id                             AS Id
             , Object_Goods.ObjectCode                     AS Article
             , ObjectFloat_Goods_Site.ValueData :: Integer AS Id_Site
             , ObjectBlob_Site.ValueData                   AS Name_Site
             , Object_Goods.GoodsName                      AS Name
             , ObjectString_Foto.ValueData                             as foto
             , ObjectString_Thumb.ValueData                            as thumb
             , ObjectBlob_Description.ValueData                        as description
             , Object_Goods.MakerName                                  as manufacturer
             , ObjectLink_Goods_Appointment.ChildObjectId              as appointment_id
             , Object_Goods.GoodsGroupId                               as category_id

             , CASE WHEN COALESCE(ObjectBoolean_Goods_Published.ValueData,FALSE)=TRUE THEN 1::Integer ELSE 0::Integer END as published
             , CASE WHEN Object_Goods.isErased=TRUE THEN 1::Integer ELSE 0::Integer END                                   as deleted
             , Object_Goods.ObjectId                                   as ObjectId

        FROM _tmpGoodsMinPrice_List
             LEFT JOIN MinPrice_List ON MinPrice_List.GoodsId = _tmpGoodsMinPrice_List.GoodsId

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpGoodsMinPrice_List.GoodsId

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
                                   ON ObjectLink_Goods_Appointment.ObjectId = Object_Goods.ObjectId
                                  AND ObjectLink_Goods_Appointment.DescId = zc_ObjectLink_Goods_Appointment();
       ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsOnUnit_ForSite (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.04.16                                        *
*/

-- тест
--select * from gpSelect_GoodsOnUnit_ForSite(inUnitId := 377613 , inRemainsDate := ('16.09.2015')::TDateTime ,  inSession := '3');