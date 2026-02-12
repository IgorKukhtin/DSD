-- View: _bi_Guide_GoodsPropertyValue_plu_View - Классификатор по сетям - только PLU

DROP VIEW IF EXISTS _bi_Guide_GoodsPropertyValue_plu_View;

-- Справочник Классификатор = Товар + Вид товара + только PLU
/*
--Id элемента Товар
GoodsId
GoodsCode
GoodsName

--Id элемента Вид Товара
GoodsKindId
GoodsKindCode
GoodsKindName

-- Св-во "PLU"
NormInDays

-- Признак "Удален да/нет"
isErased
*/

CREATE OR REPLACE VIEW _bi_Guide_GoodsPropertyValue_plu_View
AS
       SELECT MIN (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId) :: Integer AS GoodsPropertyId_min
            , MAX (ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId) :: Integer AS GoodsPropertyId_max
              -- Товар
            , Object_Goods.Id                    AS GoodsId
            , Object_Goods.ObjectCode            AS GoodsCode
            , Object_Goods.ValueData             AS GoodsName
             -- Вид Товара
            , Object_GoodsKind.Id                AS GoodsKindId
            , Object_GoodsKind.ObjectCode        AS GoodsKindCode
            , Object_GoodsKind.ValueData         AS GoodsKindName

              -- ПЛУ
            , ObjectString_CodeSticker.ValueData AS Code_PLU

       FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
            -- Товар
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
            -- Вид Товара
            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                 ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId

            -- Классификатор
            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                 ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

            -- ПЛУ
            INNER JOIN ObjectString AS ObjectString_CodeSticker
                                    ON ObjectString_CodeSticker.ObjectId  = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                   AND ObjectString_CodeSticker.DescId    = zc_ObjectString_GoodsPropertyValue_CodeSticker()
                                   AND ObjectString_CodeSticker.ValueData <> ''
 
       WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
       GROUP BY -- Товар
                Object_Goods.Id
              , Object_Goods.ObjectCode
              , Object_Goods.ValueData
               -- Вид Товара
              , Object_GoodsKind.Id
              , Object_GoodsKind.ObjectCode
              , Object_GoodsKind.ValueData
                -- ПЛУ
              , ObjectString_CodeSticker.ValueData
      ;

ALTER TABLE _bi_Guide_GoodsPropertyValue_plu_View  OWNER TO postgres;
ALTER TABLE _bi_Guide_GoodsPropertyValue_plu_View  OWNER TO project;
ALTER TABLE _bi_Guide_GoodsPropertyValue_plu_View  OWNER TO admin;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.02.26                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_GoodsPropertyValue_plu_View WHERE Code_PLU IN (SELECT Code_PLU FROM _bi_Guide_GoodsPropertyValue_plu_View group by Code_PLU having count(*) > 1) ORDER BY Code_PLU
-- SELECT * FROM _bi_Guide_GoodsPropertyValue_plu_View
