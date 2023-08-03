-- Function: zfCalc_PartionGoodsName_InvNumber

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_InvNumber (TVarChar, TDateTime, TFloat, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_InvNumber(
    IN inInvNumber                 TVarChar,  -- Инвентарный номер - Прочие ТМЦ + МНМА
    IN inOperDate                  TDateTime, -- Дата перемещения
    IN inPrice                     TFloat,    -- Цена
    IN inUnitName_Partion          TVarChar,  -- *Подразделение(для цены)
    IN inStorageName               TVarChar,  -- *Место хранения
    IN inGoodsName                 TVarChar   -- *Товар
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (TRIM (CASE WHEN TRIM (inInvNumber) <> '' AND inInvNumber <> '0'  THEN inInvNumber
                        ELSE CASE WHEN inInvNumber <> '' AND inInvNumber <> '0'  THEN 'инв. № <' || inInvNumber || '>' ELSE '' END
                         || ' цена : <'|| zfConvert_FloatToString (COALESCE (inPrice, 0)) || '>'
                         || ' от : <' || zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart())) || '>'
                         || '  <'|| COALESCE (inUnitName_Partion, '') || '>'
                         || CASE WHEN inStorageName <> '' THEN ' место хранениия : <'|| COALESCE (inStorageName, '') || '>' ELSE '' END
                   END
                  ) :: TVarChar);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.15                                        *
*/

-- тест
-- SELECT * FROM zfCalc_PartionGoodsName_InvNumber ('1', CURRENT_DATE, 12.3, '', '', '')
