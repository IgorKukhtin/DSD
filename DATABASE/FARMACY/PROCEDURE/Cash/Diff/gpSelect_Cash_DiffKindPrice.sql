-- Function: gpSelect_Cash_DiffKindPrice(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Cash_DiffKindPrice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_DiffKindPrice(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (DiffKindId Integer
             , MinPrice TFloat
             , Amount TFloat
             , Summa TFloat) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
     SELECT ObjectLink_DiffKind.ChildObjectId                    AS DiffKindId
          , ObjectFloat_DiffKindPrice_MinPrice.ValueData         AS MinPrice
          , ObjectFloat_DiffKindPrice_Amount.ValueData           AS Amount
          , ObjectFloat_DiffKindPrice_Summa.ValueData            AS Summa
     FROM Object AS Object_DiffKindPrice
          LEFT JOIN ObjectLink AS ObjectLink_DiffKind
                               ON ObjectLink_DiffKind.ObjectId = Object_DiffKindPrice.Id
                              AND ObjectLink_DiffKind.DescId = zc_ObjectLink_DiffKindPrice_DiffKind()   
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_MinPrice
                                ON ObjectFloat_DiffKindPrice_MinPrice.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_MinPrice.DescId = zc_ObjectFloat_DiffKindPrice_MinPrice() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Amount
                                ON ObjectFloat_DiffKindPrice_Amount.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Amount.DescId = zc_ObjectFloat_DiffKindPrice_Amount() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKindPrice_Summa
                                ON ObjectFloat_DiffKindPrice_Summa.ObjectId = Object_DiffKindPrice.Id 
                               AND ObjectFloat_DiffKindPrice_Summa.DescId = zc_ObjectFloat_DiffKindPrice_Summa() 
     WHERE Object_DiffKindPrice.DescId = zc_Object_DiffKindPrice()
       AND Object_DiffKindPrice.isErased = False
     ORDER BY ObjectFloat_DiffKindPrice_MinPrice.ValueData;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.05.22                                                       * 
*/

-- тест
-- 
SELECT * FROM gpSelect_Cash_DiffKindPrice('3')