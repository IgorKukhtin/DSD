-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar, Percent_Juridical TFloat,
               Deferment Integer, Percent TFloat, 
               Comment TVarChar,
               StartDate TDateTime, EndDate TDateTime,
               isReport Boolean,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Contract());

   RETURN QUERY 
       SELECT 
             Object_Contract_View.Id
           , Object_Contract_View.Code
           , Object_Contract_View.Name
         
           , Object_Contract_View.JuridicalBasisId
           , Object_Contract_View.JuridicalBasisName 
                     
           , Object_Contract_View.JuridicalId
           , Object_Contract_View.JuridicalName 
           , ObjectFloat_Percent.ValueData      AS Percent_Juridical
           , Object_Contract_View.Deferment
           , Object_Contract_View.Percent


           , Object_Contract_View.Comment

           , ObjectDate_Start.ValueData   AS StartDate 
           , ObjectDate_End.ValueData     AS EndDate   
           , COALESCE (ObjectBoolean_Report.ValueData, FALSE)  AS isReport
           , Object_Contract_View.isErased
       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()  

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Contract_View.JuridicalId
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Report
                                   ON ObjectBoolean_Report.ObjectId = Object_Contract_View.Id
                                  AND ObjectBoolean_Report.DescId = zc_ObjectBoolean_Contract_Report()
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.17         * add isReport
 08.12.16         * add Percent
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract ('2')