-- Function: gpSelect_Object_PromoItem (TVarChar)

-- DROP FUNCTION gpSelect_Object_PromoItem (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PromoItem(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased Boolean
) AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_PromoItem());
   vbUserId:= lpGetUserBySession (inSession);

    
   RETURN QUERY 
      SELECT
             Object.Id
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased
      FROM Object
      WHERE Object.DescId = zc_Object_PromoItem()
   
    UNION ALL
      SELECT 
             0 AS Id
           , NULL      :: Integer  AS Code
           , '�������' :: TVarChar AS Name
           , FALSE     :: Boolean  AS isErased
    ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PromoItem (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.08.24         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_PromoItem('2')
