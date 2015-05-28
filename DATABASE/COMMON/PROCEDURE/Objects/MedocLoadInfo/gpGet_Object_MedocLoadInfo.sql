-- Function: gpSelect_Object_ContractKind()

DROP FUNCTION IF EXISTS gpGet_Object_MedocLoadInfo(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MedocLoadInfo(
    IN inDate        TDateTime,     -- Дата 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Period TDateTime, LoadDateTime TDateTime) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());

   RETURN QUERY 
   SELECT 
         Object_MedocLoadInfo_View.Period     
       , Object_MedocLoadInfo_View.LoadDateTime     
      FROM  Object_MedocLoadInfo_View 
     WHERE Object_MedocLoadInfo_View.Period = date_trunc('month', inDate);
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_MedocLoadInfo (TDateTime,  TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.15                         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractKind('2')