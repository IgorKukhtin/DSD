-- Function: gpSelect_Object_Juridical_ForUnloadPrice()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_ForUnloadPrice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_ForUnloadPrice(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, FileName TVarChar) AS
$BODY$
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Juridical());

    RETURN QUERY 
        SELECT 59610::Integer AS Id, 'БаДМ_price.csv'::TVarChar AS FileName
        UNION ALL
        SELECT 59611::Integer AS Id, 'Оптима_price.csv'::TVarChar AS FileName
        UNION ALL
        SELECT 59612::Integer AS Id, 'Вента_price.csv'::TVarChar AS FileName
        UNION ALL
        SELECT 59614::Integer AS Id, 'Фра-М_price.csv'::TVarChar AS FileName
        UNION ALL
        SELECT 183311::Integer AS Id, 'Инт-МЭ_price.csv'::TVarChar AS FileName;
        
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical_ForUnloadPrice(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 12.01.16                                                         *
 
*/
-- тест
-- SELECT * FROM gpSelect_Object_Juridical_ForUnloadPrice ('2')