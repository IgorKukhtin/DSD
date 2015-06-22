DROP FUNCTION IF EXISTS gpGet_Object_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Price(
    IN inId          Integer,       -- ���� ������� <>
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Price TFloat
             , GoodsId Integer, GoodsName TVarChar
             , UnitId Integer, UnitName TVarChar
             , isErased boolean
             ) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Price());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Float)      AS Price

           , CAST (0 as Integer)    AS GoodsId
           , CAST ('' as TVarChar)  AS GoodsName

           , CAST (0 as Integer)    AS UnitId
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (NULL AS Boolean) AS isErased;
   ELSE
       RETURN QUERY
       SELECT
           Object_Price_View.Id
           ,Object_Price_View.Price

           ,Object_Price_View.GoodsId
           ,Object_Price_View.GoodsName

           ,Object_Price_View.UnitId
           ,Object_Price_View.UnitName

           ,Object_Price_View.isErased

       FROM Object_Price_View
       WHERE Object_Price_View.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Price (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.05.14         *
*/

-- ����
-- SELECT * FROM gpGet_Object_Price (2, '')
