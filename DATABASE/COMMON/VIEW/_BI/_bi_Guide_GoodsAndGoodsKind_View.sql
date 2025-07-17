-- View: _bi_Guide_GoodsAndGoodsKind_View

DROP VIEW IF EXISTS _bi_Guide_GoodsAndGoodsKind_View;

-- Справочник Товар + Вид товара
/*
--Id элемента Товар
GoodsId
GoodsCode
GoodsName

--Id элемента Вид Товара
GoodsKindId
GoodsKindCode
GoodsKindName

-- Св-во "Срок годности в днях"
NormInDays

-- Св-во "ТОП да/нет"
isTop

-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_GoodsAndGoodsKind_View
AS
       SELECT
           --Object_GoodsByGoodsKind.Id         AS Id
             -- Товар
             Object_Goods.Id                    AS GoodsId
           , Object_Goods.ObjectCode            AS GoodsCode
           , Object_Goods.ValueData             AS GoodsName
            -- Вид Товара
           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ObjectCode        AS GoodsKindCode
           , Object_GoodsKind.ValueData         AS GoodsKindName

             -- Св-во "Срок годности в днях"
           , COALESCE (ObjectFloat_NormInDays.ValueData, 0) :: TFloat AS NormInDays

             -- Св-во "ТОП да/нет"
           , COALESCE (ObjectBoolean_Top.ValueData, FALSE) :: Boolean AS isTop

             -- Признак "Удален да/нет"
           , Object_GoodsByGoodsKind.isErased   AS isErased

       FROM Object AS Object_GoodsByGoodsKind
            -- Товар
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                 ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_Goods.DescId   = zc_ObjectLink_GoodsByGoodsKind_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
            -- Вид Товара
            LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                 ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = Object_GoodsByGoodsKind.Id
                                AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId   = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId

            -- Св-во "Срок годности в днях"
            LEFT JOIN ObjectFloat AS ObjectFloat_NormInDays
                                  ON ObjectFloat_NormInDays.ObjectId = Object_GoodsByGoodsKind.Id
                                 AND ObjectFloat_NormInDays.DescId   = zc_ObjectFloat_GoodsByGoodsKind_NormInDays()
            -- Св-во "ТОП да/нет"
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                    ON ObjectBoolean_Top.ObjectId = Object_GoodsByGoodsKind.Id
                                   AND ObjectBoolean_Top.DescId   = zc_ObjectBoolean_GoodsByGoodsKind_Top()

       WHERE Object_GoodsByGoodsKind.DescId = zc_Object_GoodsByGoodsKind()
       AND (ObjectFloat_NormInDays.ValueData > 0
         OR ObjectBoolean_Top.ValueData      = TRUE
           )
      ;

ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO postgres;
ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO project;
ALTER TABLE _bi_Guide_GoodsAndGoodsKind_View  OWNER TO admin;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_GoodsAndGoodsKind_View
