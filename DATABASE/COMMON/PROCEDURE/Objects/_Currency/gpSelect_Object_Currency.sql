-- Function: gpSelect_Object_Currency()

--DROP FUNCTION gpSelect_Object_Currency();

CREATE OR REPLACE FUNCTION gpSelect_Object_Currency(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, InternalName TVarChar) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , ObjectString.ValueData AS InternalName
   FROM Object
   JOIN ObjectString
     ON ObjectString.ObjectId = Object.Id
    AND ObjectString.DescId = zc_objectString_Currency_InternalName()
   WHERE Object.DescId = zc_Object_Currency();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Currency(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Currency('2')