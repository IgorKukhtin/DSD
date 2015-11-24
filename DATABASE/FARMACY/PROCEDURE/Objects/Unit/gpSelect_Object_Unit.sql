-- Function: gpSelect_Object_Unit()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer
             , JuridicalName TVarChar, MarginCategoryName TVarChar, isLeaf boolean, isErased boolean
             , RouteId integer, RouteName TVarChar
             , RouteSortingId integer, RouteSortingName TVarChar) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Unit());

   RETURN QUERY 
       SELECT 

             Object_Unit_View.Id
           , Object_Unit_View.Code
           , Object_Unit_View.Name
           , Object_Unit_View.ParentId
           , Object_Unit_View.JuridicalName
           , Object_Unit_View.MarginCategoryName
           , Object_Unit_View.isLeaf
           , Object_Unit_View.isErased
           , 0 as RouteId
           , ''::TVarChar as RouteName 
           , 0 as RouteSortingId
           , ''::TVarChar as RouteSortingName 
           
       FROM Object_Unit_View;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.08.14                         *
 27.06.14         *
 25.06.13                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit ('2')