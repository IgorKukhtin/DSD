-- Function: gpSelect_Object_UnitGroup()

--DROP FUNCTION gpSelect_Object_UnitGroup();

CREATE OR REPLACE FUNCTION gpSelect_Object_UnitGroup(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, ParentId Integer) AS
$BODY$BEGIN

   --PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , ObjectLink.ChildObjectId AS ParentId
   FROM Object
   JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_UnitGroup_Parent()
   WHERE Object.DescId = zc_Object_UnitGroup();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_UnitGroup(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_UnitGroup('2')