-- Function: gpSelect_Object_DiffKindCash(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DiffKindCash(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DiffKindCash(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , MaxOrderUnitAmount TFloat
             , MaxOrderAmount TFloat
             , MaxOrderAmountSecond TFloat
             , DaysForSale Integer
             , isLessYear Boolean) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbNotCashListDiff Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_DiffKind());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   
   vbNotCashListDiff := COALESCE((SELECT COALESCE (ObjectBoolean_NotCashListDiff.ValueData, FALSE)
                                  FROM ObjectBoolean AS ObjectBoolean_NotCashListDiff
                                  WHERE ObjectBoolean_NotCashListDiff.ObjectId = vbUnitId
                                    AND ObjectBoolean_NotCashListDiff.DescId = zc_ObjectBoolean_Unit_NotCashListDiff()), FALSE);

   RETURN QUERY 
     SELECT Object_DiffKind.Id                                                   AS Id
          , Object_DiffKind.ObjectCode                                           AS Code
          , Object_DiffKind.ValueData                                            AS Name
          , CASE WHEN vbNotCashListDiff = TRUE 
                 THEN ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData 
                 ELSE ObjectFloat_DiffKind_MaxOrderAmount.ValueData END::TFloat  AS MaxOrderUnitAmount
          , ObjectFloat_DiffKind_MaxOrderAmount.ValueData                        AS MaxOrderAmount
          , ObjectFloat_DiffKind_MaxOrderAmountSecond.ValueData                  AS MaxOrderAmountSecond
          , 0 /*ObjectFloat_DiffKind_DaysForSale.ValueData::Integer*/            AS DaysForSale
          , COALESCE(ObjectBoolean_DiffKind_LessYear.ValueData, FALSE)           AS isLessYear
     FROM Object AS Object_DiffKind
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmount
                                ON ObjectFloat_DiffKind_MaxOrderAmount.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmount.DescId = zc_ObjectFloat_MaxOrderAmount() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_MaxOrderAmountSecond
                                ON ObjectFloat_DiffKind_MaxOrderAmountSecond.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_MaxOrderAmountSecond.DescId = zc_ObjectFloat_MaxOrderAmountSecond() 
          LEFT JOIN ObjectFloat AS ObjectFloat_DiffKind_DaysForSale
                                ON ObjectFloat_DiffKind_DaysForSale.ObjectId = Object_DiffKind.Id 
                               AND ObjectFloat_DiffKind_DaysForSale.DescId = zc_ObjectFloat_DiffKind_DaysForSale() 
          LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_LessYear
                                  ON ObjectBoolean_DiffKind_LessYear.ObjectId = Object_DiffKind.Id
                                 AND ObjectBoolean_DiffKind_LessYear.DescId = zc_ObjectBoolean_DiffKind_LessYear()   
     WHERE Object_DiffKind.DescId = zc_Object_DiffKind()
       AND Object_DiffKind.isErased = FALSE
     ORDER BY Object_DiffKind.ValueData;
  
END;
$BODY$
 
LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.12.18                                                       *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_DiffKindCash('3')