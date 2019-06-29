-- Function: zfCalc_PartionGoods

DROP FUNCTION IF EXISTS zfCalc_PartionGoods (Integer, Integer, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoods(
    IN inGoodsCode   Integer  , -- 
    IN inPartnerCode Integer  , -- 
    IN inOperDate    TDateTime  -- 
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- результат
     RETURN (CAST (COALESCE (inGoodsCode, 0)   AS TVarChar)
   || '-' || CAST (COALESCE (inPartnerCode, 0) AS TVarChar)
   || '-' || TO_CHAR (inOperDate, 'DD.MM.YYYY')
            );

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
-- SELECT zfCalc_PartionGoods (1, 1, '14.06.2019')
