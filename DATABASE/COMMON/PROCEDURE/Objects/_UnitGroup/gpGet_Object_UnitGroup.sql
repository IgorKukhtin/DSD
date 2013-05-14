-- Function: gpGet_Object_UnitGroup()

--DROP FUNCTION gpGet_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_UnitGroup(
IN inId          Integer,       /* Касса */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer, ParentName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , UnitGroup.Id AS ParentId
   , UnitGroup.ValueData AS ParentName
   FROM Object
   JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_UnitGroup_Parent()
   JOIN Object AS UnitGroup
     ON UnitGroup.Id = ObjectLink.ChildObjectId
   WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_UnitGroup(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')