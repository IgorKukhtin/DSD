-- Function: zfCalc_PartionGoods_GoodsCode

DROP FUNCTION IF EXISTS zfCalc_PartionGoods_GoodsCode (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoods_GoodsCode(
    IN inPartionGoods TVarChar  -- 
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- результат
     RETURN (CASE WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 4)) IS NOT NULL
                       THEN zfConvert_StringToNumber (split_part (TRIM (inPartionGoods), '-', 2))
                  WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 3)) IS NOT NULL
                       THEN zfConvert_StringToNumber (split_part (TRIM (inPartionGoods), '-', 1))
                  ELSE NULL
             END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.06.19                                        *
*/

-- тест
-- SELECT * FROM Object WHERE ObjectCode in (zfCalc_PartionGoods_GoodsCode ('мо-4218-235870-14.06.2019'),  zfCalc_PartionGoods_GoodsCode ('')) AND DescId = zc_Object_Goods()
