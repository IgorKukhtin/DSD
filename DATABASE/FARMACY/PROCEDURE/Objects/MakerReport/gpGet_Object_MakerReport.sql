--
-- Function: gpGet_Object_MakerReport()

DROP FUNCTION IF EXISTS gpGet_Object_MakerReport(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_MakerReport(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MakerId Integer, MakerCode Integer, MakerName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar
             , isErased   Boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Maker());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           
           , CAST (0 as Integer)    AS MakerId
           , CAST (0 as Integer)    AS MakerCode
           , CAST ('' as TVarChar)  AS MakerName

           , CAST (0 as Integer)    AS JuridicalId
           , CAST (0 as Integer)    AS JuridicalCode
           , CAST ('' as TVarChar)  AS JuridicalName

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_MakerReport.Id        AS Id
          
           , Object_Maker.Id              AS MakerId
           , Object_Maker.ObjectCode      AS MakerCode
           , Object_Maker.ValueData       AS MakerName

           , Object_Juridical.Id          AS JuridicalId
           , Object_Juridical.ObjectCode  AS JuridicalCode
           , Object_Juridical.ValueData   AS JuridicalName

           , Object_MakerReport.isErased  AS isErased
           
       FROM Object AS Object_MakerReport
   
           LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()
           LEFT JOIN Object AS Object_Maker ON Object_Maker.Id = ObjectLink_Maker.ChildObjectId              

           LEFT JOIN ObjectLink AS ObjectLink_Juridical 
                                ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()
           LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId 

       WHERE Object_MakerReport.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.19         *
*/

-- тест
-- SELECT * FROM gpGet_Object_MakerReport (2, '')
   select * from gpGet_Object_MakerReport(inId := 9845927 ,  inSession := '3'::TVarChar);