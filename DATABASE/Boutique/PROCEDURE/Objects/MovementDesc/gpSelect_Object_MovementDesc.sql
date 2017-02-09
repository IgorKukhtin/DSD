-- Function: gpSelect_Object_MovementDesc (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_MovementDesc (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_MovementDesc(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code TVarChar, Name TVarChar
              ) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementDesc());

  RETURN QUERY 
   SELECT
        MovementDesc.Id        AS Id 
      , MovementDesc.Code      AS Code
      , MovementDesc.ItemName  AS NAME
       
   FROM MovementDesc
   ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_MovementDesc (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_MovementDesc('2')
