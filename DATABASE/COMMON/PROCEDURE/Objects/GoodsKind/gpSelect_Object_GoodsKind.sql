-- Function: gpSelect_Object_GoodsKind()

--DROP FUNCTION gpSelect_Object_GoodsKind();

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsKind());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY 
   SELECT 
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_GoodsKind()
       AND (Object.Id <> 268778 OR vbUserId = 5) -- �����
  UNION ALL
   SELECT 0 AS Id
        , 0 AS Code
        , '�������' :: TVarChar AS Name
        , FALSE AS isErased
;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 100;
ALTER FUNCTION gpSelect_Object_GoodsKind(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.13          *
 00.06.13          
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsKind('2')
