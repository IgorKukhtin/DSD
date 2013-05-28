-- Function: gpGet_Object_InfoMoneyDestination()

--DROP FUNCTION gpGet_Object_InfoMoneyDestination();

CREATE OR REPLACE FUNCTION gpGet_Object_InfoMoneyDestination(
IN inId          Integer,       /* Группы управленческих аналитик */
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
ALTER FUNCTION gpGet_Object_InfoMoneyDestination(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')