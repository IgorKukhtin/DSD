-- Function: gpSelect_Object_Unit()

--DROP FUNCTION gpSelect_Object_Unit();

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, UnitGroupId Integer, BranchName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , Unit_UnitGroup.ChildObjectId AS UnitGroupId
   , Branch.ValueData AS BranchName
   FROM Object
   JOIN ObjectLink AS Unit_UnitGroup
     ON Unit_UnitGroup.ObjectId = Object.Id
    AND Unit_UnitGroup.DescId = zc_ObjectLink_Unit_UnitGroup()
   JOIN ObjectLink AS Unit_Branch
     ON Unit_Branch.ObjectId = Object.Id
    AND Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
   JOIN Object AS Branch
     ON Branch.Id = Unit_Branch.ChildObjectId
  WHERE Object.DescId = zc_Object_Unit();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_UnitGroup('2')