-- Function: gpSelect_Object_GoodsGroupProperty_Parent()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupProperty_Parent(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupProperty_Parent(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar  
             , ColorReport Integer, ColorReport_text TVarChar
             , isErased boolean
) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupProperty()());

   RETURN QUERY
   WITH
       tmpParent AS (SELECT ObjectLink_GoodsGroupProperty_Parent.ChildObjectId AS Id
                     FROM ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                     WHERE ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                     )
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name  
        , 0      ::Integer  AS ParentId
        , ''     ::TVarChar AS ParentName    
        , COALESCE (ObjectFloat_ColorReport.ValueData, zc_Color_Black())    ::Integer  AS ColorReport
        , CASE WHEN COALESCE (ObjectFloat_ColorReport.ValueData,-1)   = -1 THEN '' ELSE 'Текст' END ::TVarChar  AS ColorReport_text
        , Object.isErased   AS isErased
   FROM Object 
       LEFT JOIN ObjectFloat AS ObjectFloat_ColorReport
                             ON ObjectFloat_ColorReport.ObjectId = Object.Id 
                            AND ObjectFloat_ColorReport.DescId = zc_ObjectFloat_GoodsGroupProperty_ColorReport()
   WHERE Object.DescId = zc_Object_GoodsGroupProperty()
     AND Object.Id In (SELECT DISTINCT tmpParent.Id FROM tmpParent)
   ;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.23         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_GoodsGroupProperty_Parent('2')