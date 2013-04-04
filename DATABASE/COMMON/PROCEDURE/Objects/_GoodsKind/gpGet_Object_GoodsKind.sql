-- Function: gpGet_Object_GoodsKind()

--DROP FUNCTION gpGet_Object_GoodsKind();

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsKind(
IN inId          Integer,       /* Бизнесы */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   FROM Object
   WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_GoodsKind(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')