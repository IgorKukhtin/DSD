-- Function: lpInsertFind_Object_ServiceDate (TDateTime)

DROP FUNCTION IF EXISTS lpInsertFind_Object_ServiceDate (TDateTime);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_ServiceDate(
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

     -- Если не нашли
     IF COALESCE (vbServiceDateId, 0) = 0
     THEN
         -- сохранили <Полное значение партии>
         vbServiceDateId := lpInsertUpdate_Object (vbServiceDateId, zc_Object_ServiceDate(), 0, vbOperDate_str);

         IF vbOperDate_str <> ''
         THEN
             -- сохранили <Дата>
              PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ServiceDate_Value(), vbServiceDateId, inOperDate);
             -- сохранили <Год>
              PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ServiceDate_Year(), vbServiceDateId, DATE_PART ('YEAR', inOperDate) :: TFloat);
             -- сохранили <Месяц>
              PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ServiceDate_Month(), vbServiceDateId, DATE_PART ('MONTH', inOperDate) :: TFloat);
         END IF;

     END IF;

     -- Возвращаем значение
     RETURN (vbServiceDateId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_ServiceDate (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.09.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= NULL);
-- SELECT * FROM lpInsertFind_Object_ServiceDate (inOperDate:= '31.01.2013');
