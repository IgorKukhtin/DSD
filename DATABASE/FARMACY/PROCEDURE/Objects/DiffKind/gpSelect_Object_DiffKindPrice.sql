-- Function: gpSelect_Object_DiffKindPrice(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKindPrice(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKindPrice(
    IN inDiffKindId  Integer  ,     -- Вид отказа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , DiffKindId Integer
             , Price TFloat
             , Amount TFloat
             , isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT Object_DiffKindPrice.Id                              AS Id
          , Object_DiffKindPrice.ObjectCode                      AS Code
          , Object_DiffKindPrice.ValueData                       AS Name
          , ObjectLink_DiffKind.ChildObjectId                    AS DiffKindId
          , ObjectFloat_DiffKindPrice_Price.ValueData            AS Price
          , ObjectFloat_DiffKindPrice_Amount.ValueData           AS Amount
          , Object_DiffKindPrice.isErased                        AS isErased
     FROM Object AS Object_DiffKindPrice
          LEFT JOIN ObjectLink AS ObjectLink_DiffKind
                               ON ObjectLink_DiffKind.ObjectId = Object_DiffKindPrice.Id
                              AND ObjectLink_DiffKind.DescId = zc_ObjectLink_DiffKindPrice_DiffKind()   
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Price
                                ON ObjectFloat_DiffKindPrice_Price.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Price.DescId = zc_ObjectFloat_DiffKindPrice_Price() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Amount
                                ON ObjectFloat_DiffKindPrice_Amount.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Amount.DescId = zc_ObjectFloat_DiffKindPrice_Amount() 
     WHERE Object_DiffKindPrice.DescId = zc_Object_DiffKindPrice()
     ORDER BY ObjectFloat_DiffKindPrice_Price.ValueData;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.05.22                                                       * 
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_DiffKindPrice(1, '3')