-- Function: gpSelect_Object_Unit_For2gis()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_For2gis(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_For2gis(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
   SELECT
         Object_Unit_View.Id
       , REPLACE(Object_Unit_View.Name, '/', '-')::TVarChar
   FROM Object_Unit_View AS Object_Unit_View 
   WHERE Object_Unit_View.Id  in (183289	,
                                  183290	,
                                  183291	,
                                  183292	,
                                  375626	,
                                  375627	,
                                  377574	,
                                  377594	,
                                  377595	,
                                  377605	,
                                  377606	,
                                  377610	,
                                  377613	,
                                  394426	,
                                  472116	,
                                  494882	,
                                  1781716	,
                                  4135547	,
                                  5120968	,
                                  6128298	,
                                  6309262	,
                                  6608396	,
                                  6741875	,
                                  7117700	,
                                  8698426	,
                                  9771036	,
                                  9951517	,
                                  10128935	,
                                  10779386	,
                                  11152911	,
                                  11300059	,
                                  11769526	,
                                  12607257	,
                                  12812109	,
                                  13311246	,
                                  13338606	,
                                  13711869)
   ORDER BY Object_Unit_View.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 18.02.19        *
 19.07.18        *
 07.06.18        *

*/

-- тест
-- SELECT * FROM Object WHERE DescId = zc_Object_Unit();
-- SELECT * FROM gpSelect_Object_Unit_For2gis ('3')
