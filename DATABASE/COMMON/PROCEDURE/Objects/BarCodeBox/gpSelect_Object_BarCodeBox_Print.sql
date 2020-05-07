-- Function: gpSelect_Object_BarCodeBox (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_BarCodeBox_Print (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BarCodeBox_Print(
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar, AmountPrint TFloat
              ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());

   RETURN QUERY
   WITH tmpList AS (SELECT tmp.Amount, GENERATE_SERIES (1, tmp.Amount :: Integer) AS Ord
                    FROM (SELECT DISTINCT ObjectFloat.ValueData AS Amount
                          FROM ObjectFloat
                          WHERE ObjectFloat.DescId = zc_ObjectFloat_BarCodeBox_Print()
                          ) AS tmp
                   )

       SELECT Object_BarCodeBox.ValueData     AS BarCode
            , 1 :: TFloat AS AmountPrint
 
       FROM Object AS Object_BarCodeBox

            LEFT JOIN ObjectFloat AS ObjectFloat_Print
                                  ON ObjectFloat_Print.ObjectId = Object_BarCodeBox.Id
                                 AND ObjectFloat_Print.DescId = zc_ObjectFloat_BarCodeBox_Print()

            LEFT JOIN tmpList ON tmpList.Amount = ObjectFloat_Print.ValueData
      WHERE Object_BarCodeBox.DescId = zc_Object_BarCodeBox()
        AND Object_BarCodeBox.isErased = FALSE
        AND COALESCE (ObjectFloat_Print.ValueData,0) <> 0
      ORDER BY Object_BarCodeBox.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.20         *
*/

-- тест
--SELECT * FROM gpSelect_Object_BarCodeBox_Print ('2')