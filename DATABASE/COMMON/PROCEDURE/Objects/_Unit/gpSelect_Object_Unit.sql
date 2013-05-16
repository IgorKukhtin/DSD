-- Function: gpSelect_Object_Unit()

-- DROP FUNCTION gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, UnitGroupName TVarChar, Name TVarChar, isErased boolean, UnitGroupId Integer, BranchName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT 
          Object_UnitGroup.Id
        , Object_UnitGroup.ObjectCode
        , Object_UnitGroup.ValueData AS UnitGroupName
        , CAST ('' AS TVarChar)           AS Name
        , Object_UnitGroup.isErased
        , ObjectLink_UnitGroup_Parent.ChildObjectId AS UnitGroupId
        , CAST ('' AS TVarChar) AS BranchName
   FROM Object AS Object_UnitGroup
        LEFT JOIN ObjectLink AS ObjectLink_UnitGroup_Parent
                 ON ObjectLink_UnitGroup_Parent.ObjectId = Object_UnitGroup.Id
                AND ObjectLink_UnitGroup_Parent.DescId = zc_ObjectLink_UnitGroup_Parent()
   WHERE Object_UnitGroup.DescId = zc_Object_UnitGroup()
  UNION
   SELECT Object_Unit.Id
        , Object_Unit.ObjectCode
        , CAST ('' AS TVarChar)      AS UnitGroupName
        , Object_Unit.ValueData      AS Name
        , Object_Unit.isErased
        , ObjectLink_Unit_UnitGroup.ChildObjectId AS UnitGroupId
        , Object_Branch.ValueData AS BranchName
   FROM Object AS Object_Unit
        LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitGroup
                 ON ObjectLink_Unit_UnitGroup.ObjectId = Object_Unit.Id
                AND ObjectLink_Unit_UnitGroup.DescId = zc_ObjectLink_Unit_UnitGroup()
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()

        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

   WHERE Object_Unit.DescId = zc_Object_Unit();
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar)
  OWNER TO postgres;

-- SELECT * FROM gpSelect_Object_Unit ('2')