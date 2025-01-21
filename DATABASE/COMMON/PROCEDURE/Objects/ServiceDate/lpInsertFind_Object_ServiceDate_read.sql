-- Function: lpInsertFind_Object_ServiceDate_read (TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ServiceDate_read (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ServiceDate_read(
    IN inOperDate  TDateTime -- Месяц начислений
)
  RETURNS Integer AS
$BODY$
   DECLARE vbServiceDateId Integer;
   DECLARE vbOperDate_str   TVarChar;
BEGIN

     -- меняем параметр
     IF COALESCE (inOperDate, zc_DateEnd()) = zc_DateEnd() OR COALESCE (inOperDate, zc_DateStart()) = zc_DateStart()
     THEN
         vbOperDate_str:= '';
         inOperDate:= NULL;
     ELSE
         -- расчет - 1-ое число месяца
         inOperDate:= DATE_TRUNC ('MONTH', inOperDate);
         -- форматируем в строчку
         vbOperDate_str:= TO_CHAR (inOperDate, 'YYYY MONTH');
     END IF;

     -- Находим по св-ву
     vbServiceDateId:= (SELECT Object.Id
                         FROM Object
                         WHERE Object.ValueData = vbOperDate_str
                           AND Object.DescId = zc_Object_ServiceDate()
                        );

     -- Возвращаем значение
     RETURN (vbServiceDateId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.01.25                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= NULL);
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= '31.01.2013');
