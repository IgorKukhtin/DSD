-- Function: zfCalc_PartionGoodsName_InvNumber

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_InvNumber(
    IN inInvNumber                 TVarChar,  -- 
    IN inOperDate                  TDateTime, -- 
    IN inPrice                     TFloat,    -- Цена
    IN inUnitName_Partion          TVarChar,  -- *Подразделение(для цены)
    IN inStorageName               TVarChar,  -- *Место хранения
    IN inGoodsName                 TVarChar   -- *Товар
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (TRIM (CASE WHEN inInvNumber <> '' THEN '№ <' || inInvNumber || '>' ELSE '' END
                || CASE WHEN inOperDate <> zc_DateStart() THEN ' <' || DATE (inOperDate) :: TVarChar || '>' ELSE '' END
                || ' цена : <'|| COALESCE (inPrice, 0) :: TVarChar || '>'
                || ' от : <'|| COALESCE (inUnitName_Partion, '') || '>'
                || CASE WHEN inStorageName <> '' THEN ' место хранениия : <'|| COALESCE (inStorageName, '') || '>' ELSE '' END
                  ));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.15                                        *
*/

-- тест
-- SELECT * FROM zfCalc_PartionGoodsName_InvNumber ('1', CURRENT_DATE, 12.3, '', '', '')
