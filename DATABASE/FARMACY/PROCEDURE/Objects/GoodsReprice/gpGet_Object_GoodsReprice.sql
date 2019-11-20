-- Function: gpGet_Object_GoodsReprice()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsReprice(Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsReprice(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , isEnabled Boolean
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsReprice());

   IF COALESCE (inId, 0) = 0 
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 AS Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_GoodsReprice()) AS Code
           , CAST ('' AS TVarChar)  AS Name
           , FALSE     ::Boolean    AS isEnabled
           , FALSE     ::Boolean    AS isErased;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_GoodsReprice.Id          AS Id
           , Object_GoodsReprice.ObjectCode  AS Code
           , Object_GoodsReprice.ValueData   AS Name
           , COALESCE (ObjectBoolean_Enabled.ValueData, FALSE) ::Boolean AS isEnabled
           , Object_GoodsReprice.isErased    AS isErased
           
       FROM Object AS Object_GoodsReprice
           LEFT JOIN ObjectBoolean AS ObjectBoolean_Enabled
                                   ON ObjectBoolean_Enabled.ObjectId = Object_GoodsReprice.Id
                                  AND ObjectBoolean_Enabled.DescId = zc_ObjectBoolean_GoodsReprice_Enabled()
       WHERE Object_GoodsReprice.Id = inId;
      
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.19         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsReprice (2, '')
