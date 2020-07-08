-- Function: gpSelect_Object_HouseholdInventory()

DROP FUNCTION IF EXISTS gpSelect_Object_HouseholdInventory(boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_HouseholdInventory(
    IN inisErased    boolean,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN


   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
   SELECT
          Object_HouseholdInventory.Id                 AS Id
        , Object_HouseholdInventory.ObjectCode         AS Code
        , Object_HouseholdInventory.ValueData          AS Name

        , Object_HouseholdInventory.isErased           AS isErased

   FROM Object AS Object_HouseholdInventory
   WHERE Object_HouseholdInventory.DescId = zc_Object_HouseholdInventory()
     AND (Object_HouseholdInventory.isErased = False or inIsErased = True);

END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_HouseholdInventory(boolean, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 08.07.20                                                       *
*/

-- ����
-- SELECT * FROM gpSelect_Object_HouseholdInventory(False, '3')