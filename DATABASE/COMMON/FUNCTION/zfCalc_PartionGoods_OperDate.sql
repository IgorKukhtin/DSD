-- Function: zfCalc_PartionGoods_OperDate

DROP FUNCTION IF EXISTS zfCalc_PartionGoods_OperDate (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoods_OperDate(
    IN inPartionGoods TVarChar  -- 
)
RETURNS TDateTime
AS
$BODY$
BEGIN
     -- результат
     RETURN (CASE WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 4)) IS NOT NULL
                       THEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 4))
                  WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 3)) IS NOT NULL
                       THEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 3))
                  WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 2)) IS NOT NULL
                       THEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 2))
                  WHEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 1)) IS NOT NULL
                       THEN zfConvert_StringToDate (split_part (TRIM (inPartionGoods), '-', 1))
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
-- SELECT zfCalc_PartionGoods_OperDate ('мо-4218-235870-14.06.2019'),  zfCalc_PartionGoods_OperDate ('')
