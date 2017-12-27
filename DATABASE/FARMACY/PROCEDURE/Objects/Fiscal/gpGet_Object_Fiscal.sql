-- Function: gpGet_Object_Fiscal (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Fiscal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Fiscal(
    IN inId                     Integer,       -- ключ объекта <>
    IN inSession                TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , SerialNumber TVarChar, InvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Fiscal());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Fiscal()) AS Code
           , CAST ('' as TVarChar)  AS NAME
           
           , CAST ('' as TVarChar)  AS SerialNumber
           , CAST ('' as TVarChar)  AS InvNumber

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Fiscal.Id            AS Id
           , Object_Fiscal.ObjectCode    AS Code
           , Object_Fiscal.ValueData     AS Name
           
           , ObjectString_SerialNumber.ValueData  AS SerialNumber
           , ObjectString_InvNumber.ValueData     AS InvNumber 
         
           , Object_Unit.Id              AS UnitId
           , Object_Unit.ValueData       AS UnitName 
           
           , Object_Fiscal.isErased      AS isErased
           
       FROM Object AS Object_Fiscal
       
            LEFT JOIN ObjectString AS ObjectString_SerialNumber
                                   ON ObjectString_SerialNumber.ObjectId = Object_Fiscal.Id 
                                  AND ObjectString_SerialNumber.DescId = zc_ObjectString_Fiscal_SerialNumber()
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Fiscal.Id 
                                  AND ObjectString_InvNumber.DescId = zc_ObjectString_Fiscal_InvNumber()
                                                             
            LEFT JOIN ObjectLink AS ObjectLink_Fiscal_Unit
                                 ON ObjectLink_Fiscal_Unit.ObjectId = Object_Fiscal.Id 
                                AND ObjectLink_Fiscal_Unit.DescId = zc_ObjectLink_Fiscal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Fiscal_Unit.ChildObjectId                           

       WHERE Object_Fiscal.Id = inId;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.12.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Fiscal (inId:=0, inSession := '5')
