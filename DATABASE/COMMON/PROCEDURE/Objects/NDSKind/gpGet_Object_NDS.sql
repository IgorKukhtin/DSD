-- Function: gpGet_Object_NDS (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_NDS (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_NDS(
    IN inNDSKindId      Integer   ,    -- Тип НДС
   OUT outNDS           TFloat    ,    -- НДС
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TFloat AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_NDSKind());

    IF NOT EXISTS(SELECT 1
                  FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                  WHERE ObjectFloat_NDSKind_NDS.ObjectId = inNDSKindId
                    AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()) 
    THEN
        RAISE EXCEPTION 'Ошибка. Не выбран НДС.';
    END IF;

   SELECT
     ObjectFloat_NDSKind_NDS.ValueData   AS NDS
   INTO
     outNDS      
   FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
   WHERE ObjectFloat_NDSKind_NDS.ObjectId = inNDSKindId
     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS();     
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_NDS (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 25.01.21                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_NDS(9, '2')


