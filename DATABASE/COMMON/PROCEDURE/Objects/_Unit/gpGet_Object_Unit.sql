-- Function: gpGet_Object_Unit()

--DROP FUNCTION gpGet_Object_Unit();

CREATE OR REPLACE FUNCTION gpGet_Object_Unit(
IN inId          Integer,       /* Подразделение */
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, UnitGroupId Integer, UnitGroupName TVarChar, BranchId Integer, BranchName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
     Object.Id
   , Object.ObjectCode
   , Object.ValueData
   , Object.isErased
   , UnitGroup.Id AS UnitGroupId
   , UnitGroup.ValueData AS UnitGroupName
   , Branch.Id AS BranchId
   , Branch.ValueData AS BranchName
   FROM Object
   JOIN ObjectLink AS Unit_UnitGroup
     ON Unit_UnitGroup.ObjectId = Object.Id
    AND Unit_UnitGroup.DescId = zc_ObjectLink_Unit_UnitGroup()
   JOIN Object AS UnitGroup
     ON UnitGroup.Id = Unit_UnitGroup.ChildObjectId
   JOIN ObjectLink AS Unit_Branch
     ON Unit_Branch.ObjectId = Object.Id
    AND Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
   JOIN Object AS Branch
     ON Branch.Id = Unit_Branch.ChildObjectId
   WHERE Object.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION gpGet_Object_Unit(integer, TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_User('2')