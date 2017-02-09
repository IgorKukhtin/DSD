-- Function: gpSelect_Object_ContractKind()

DROP FUNCTION IF EXISTS gpSelect_Object_MedocLoadInfo(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MedocLoadInfo(
    IN inStartDate   TDateTime,     -- Дата начальная 
    IN inEndDate     TDateTime,     -- Дата конечная
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
     WHERE Object_MedocLoadInfo_View.Period >= inStartDate AND Object_MedocLoadInfo_View.Period <= inEndDate;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MedocLoadInfo (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.05.15                         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_ContractKind('2')