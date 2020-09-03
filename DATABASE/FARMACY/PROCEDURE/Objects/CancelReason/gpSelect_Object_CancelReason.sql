-- Function: gpSelect_Object_CancelReason()

DROP FUNCTION IF EXISTS gpSelect_Object_CancelReason(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CancelReason(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());

   RETURN QUERY 
   SELECT Object_CancelReason.Id                             AS Id 
        , Object_CancelReason.ObjectCode                     AS Code
        , Object_CancelReason.ValueData                      AS Name
        , Object_CancelReason.isErased                       AS isErased
   FROM Object AS Object_CancelReason

   WHERE Object_CancelReason.DescId = zc_Object_CancelReason();
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CancelReason(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.20                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_Object_CancelReason('3')