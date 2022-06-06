-- Function: gpSelect_Cash_DiffKindPrice(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Cash_DiffKindPrice(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_DiffKindPrice(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (DiffKindId Integer
             , MinPrice TFloat
             , MaxPrice TFloat
             , Amount TFloat
             , Summa TFloat) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());

   RETURN QUERY 
   WITH tmpDiffKindPrice AS (SELECT ObjectLink_DiffKind.ChildObjectId                    AS DiffKindId
                                  , ObjectFloat_DiffKindPrice_MinPrice.ValueData         AS MinPrice
                                  , ObjectFloat_DiffKindPrice_Amount.ValueData           AS Amount
                                  , ObjectFloat_DiffKindPrice_Summa.ValueData            AS Summa
                                  , ROW_NUMBER() OVER (PARTITION BY ObjectLink_DiffKind.ChildObjectId ORDER BY ObjectFloat_DiffKindPrice_MinPrice.ValueData)  AS Ord
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
                               AND Object_DiffKindPrice.isErased = False)

     SELECT DiffKindPrice.DiffKindId
          , DiffKindPrice.MinPrice
          , COALESCE(DiffKindPrice_Next.MinPrice, 1000000)::TFloat AS MaxPrice
          , DiffKindPrice.Amount
          , DiffKindPrice.Summa
     FROM tmpDiffKindPrice AS DiffKindPrice

          LEFT JOIN tmpDiffKindPrice AS DiffKindPrice_Next
                                     ON DiffKindPrice_Next.DiffKindId = DiffKindPrice.DiffKindId
                                    AND DiffKindPrice_Next.Ord = DiffKindPrice.Ord + 1

     ORDER BY DiffKindPrice.DiffKindId
            , DiffKindPrice.MinPrice;
  
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