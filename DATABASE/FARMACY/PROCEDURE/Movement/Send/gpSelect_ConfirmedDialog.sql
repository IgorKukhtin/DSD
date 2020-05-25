-- Function: gpSelect_ConfirmedDialog()

DROP FUNCTION IF EXISTS gpSelect_ConfirmedDialog(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ConfirmedDialog(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, isConfirmed  Boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT 1::Integer                                AS Id 
        , 'Установит <Подтвержден>'::TVarChar       AS Name
        , True                                      AS isConfirmed
   UNION ALL
   SELECT 2::Integer
        , 'Установит <Не подтвержден>'::TVarChar
        , False;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_ConfirmedDialog(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.05.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_ConfirmedDialog('3')