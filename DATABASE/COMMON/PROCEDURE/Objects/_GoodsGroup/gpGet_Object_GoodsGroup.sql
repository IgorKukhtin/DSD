-- Function: gpGet_Object_GoodsGroup()

--DROP FUNCTION gpGet_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsGroup(
IN inId          Integer,       /* Группа товаров */
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
   , GoodsGroup.Id AS ParentId
   , GoodsGroup.ValueData AS ParentName
   FROM Object
   JOIN ObjectLink 
     ON ObjectLink.ObjectId = Object.Id
    AND ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
   JOIN Object AS GoodsGroup
     ON GoodsGroup.Id = ObjectLink.ChildObjectId
   WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_GoodsGroup(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')