-- Function: gpGet_Object_Sticker_ReportName()

DROP FUNCTION IF EXISTS gpGet_Object_Sticker_ReportName (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Object_Sticker_ReportName (
    IN inObjectId           Integer  , -- ключ спарвочника
    IN inSession            TVarChar   -- сессия пользователя
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbPrintFormName TVarChar;
BEGIN
       -- проверка прав пользователя на вызов процедуры
       -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());


       -- поиск формы
       SELECT COALESCE (PrintForms_View.PrintFormName, 'PrintObject_Sticker')
              INTO vbPrintFormName
       FROM Object AS Object_Sticker
            LEFT JOIN PrintForms_View ON PrintForms_View.DescId = Object_Sticker.DescId
       WHERE Object_Sticker.Id = inObjectId
       ;

       -- Результат
       RETURN (vbPrintFormName);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 26.10.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Sticker_ReportName (inObjectId:= 1005830 , inSession:= '5'); -- все
