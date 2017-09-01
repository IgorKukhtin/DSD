-- Function: zfCalc_PartionGoodsName_Asset

DROP FUNCTION IF EXISTS zfCalc_PartionGoodsName_Asset (Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_PartionGoodsName_Asset(
    IN inMovementId                Integer,   -- Партия - документ
    IN inInvNumber                 TVarChar,  -- Инвентарный номер - Прочие ТМЦ + МНМА
    IN inOperDate                  TDateTime, -- Дата ввода в эксплуатацию
    IN inUnitName                  TVarChar,  -- *Подразделение использования
    IN inStorageName               TVarChar,  -- *Место хранения
    IN inGoodsName                 TVarChar   -- *Основные средства или Товар
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (TRIM (CASE WHEN inInvNumber <> '' AND inInvNumber <> '0'  THEN 'ОС инв.№ <' || inInvNumber || '>' ELSE 'ОС № <' || COALESCE ((SELECT InvNumber FROM Movement WHERE Id = inMovementId), '') || '> от <' || COALESCE (zfConvert_DateToString (((SELECT OperDate FROM Movement WHERE Id = inMovementId))), '') || '>'  END
                || CASE WHEN COALESCE (inOperDate, zc_DateStart()) NOT IN (zc_DateStart(), zc_DateEnd()) THEN ' ввод в экспл. : <' || zfConvert_DateToString (COALESCE (inOperDate, zc_DateStart())) || '>' ELSE '' END
                || CASE WHEN inUnitName    <> '' THEN ' подр. использования : <' || COALESCE (inUnitName, '')    || '>' ELSE '' END
                || CASE WHEN inStorageName <> '' THEN ' место хранениия : <'     || COALESCE (inStorageName, '') || '>' ELSE '' END
                  ));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.08.17                                        *
*/

-- тест
-- SELECT * FROM zfCalc_PartionGoodsName_Asset (1, '1', CURRENT_DATE, '', '', '')
