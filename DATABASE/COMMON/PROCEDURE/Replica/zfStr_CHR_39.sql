-- Function: zfStr_CHR_39 (TVarChar)

DROP FUNCTION IF EXISTS _replica.zfStr_CHR_39 (TVarChar);
DROP FUNCTION IF EXISTS _replica.zfStr_CHR_39 (Text);

CREATE OR REPLACE FUNCTION _replica.zfStr_CHR_39 (inValue Text)
RETURNS Text AS
$BODY$
BEGIN

     RETURN (CHR (39) || inValue || CHR (39)) ;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.07.20                                        * 
*/

-- тест
-- SELECT * FROM _replica.zfStr_CHR_39 ('2')
