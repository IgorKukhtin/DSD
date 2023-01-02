-- Function: zfCalc_GoodsName_all (TVarChar, Boolean)

DROP FUNCTION IF EXISTS zfCalc_GoodsName_all (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_GoodsName_all (inArticle TVarChar, inGoodsName TVarChar)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN ('(' || COALESCE (inArticle, '') || ') '
                  || COALESCE (inGoodsName, '')
             );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21                                        *
*/

-- тест
-- SELECT zfCalc_GoodsName_all ('1111', 'primary')
