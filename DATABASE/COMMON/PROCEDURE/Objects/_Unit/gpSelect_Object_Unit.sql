-- Function: gpSelect_Object_Unit()

-- DROP FUNCTION gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
IN inSession     TVarChar       /* текущий пользователь */)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean, UnitGroupId Integer, BranchName TVarChar) AS
$BODY$BEGIN

--   PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_Unit.Id
        , Object_Unit.ObjectCode
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