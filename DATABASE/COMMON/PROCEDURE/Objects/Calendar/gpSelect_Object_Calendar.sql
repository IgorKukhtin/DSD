-- Function: gpSelect_Object_Calendar(TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Calendar(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Calendar(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Working Boolean
             , Value TDateTime
             , isErased Boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Calendar());

   RETURN QUERY 
  
   
     SELECT 
           Object_Calendar.Id         AS Id
  
         , ObjectBoolean_Working.ValueData     AS Working  
         
         , ObjectDate_Value.ValueData      AS Value
                                                        
         , Object_Calendar.isErased AS isErased
         
     FROM ObjectDate AS ObjectDate_Period
      
          LEFT JOIN ObjectDate AS ObjectDate_Value
                               ON ObjectDate_Value.ObjectId = ObjectDate_Period.ObjectId
                              AND ObjectDate_Value.DescId = zc_ObjectDate_Calendar_Value()
                              
          LEFT JOIN Object AS Object_Calendar ON Object_Calendar.Id = ObjectDate_Value.ObjectId
         
          LEFT JOIN ObjectBoolean AS ObjectBoolean_Working 
                                ON ObjectBoolean_Working.ObjectId = Object_Calendar.Id 
                               AND ObjectBoolean_Working.DescId = zc_ObjectBoolean_Calendar_Working()
          
     WHERE ObjectDate_period.ValueData BETWEEN inStartDate AND inEndDate
       AND Object_Calendar.DescId = zc_Object_Calendar();
     
     
     
     
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Calendar (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Calendar (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inSession:='2')