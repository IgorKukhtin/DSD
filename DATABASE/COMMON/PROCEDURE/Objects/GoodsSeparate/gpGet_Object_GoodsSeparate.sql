-- Function: gpGet_Object_GoodsSeparate(integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_GoodsSeparate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsSeparate(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, isCalculated Boolean,
               GoodsMasterId Integer, GoodsMasterCode Integer, GoodsMasterName TVarChar,
               GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,               
               GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
               ) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_GoodsSeparate());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
         
           , CAST (FALSE AS Boolean) AS isCalculated

           , CAST (0 as Integer)   AS GoodsMasterId  
           , CAST (0 as Integer)   AS GoodsMasterCode
           , CAST ('' as TVarChar) AS GoodsMasterName

           , CAST (0 as Integer)   AS GoodsId
           , CAST (0 as Integer)   AS GoodsCode
           , CAST ('' as TVarChar) AS GoodsName

           , CAST (0 as Integer)   AS GoodsKindId
           , CAST (0 as Integer)   AS GoodsKindCode
           , CAST ('' as TVarChar) AS GoodsKindName
       ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_GoodsSeparate.Id            AS Id
         
         , ObjectBoolean_Calculated.ValueData AS isCalculated

         , Object_GoodsMaster.Id             AS GoodsMasterId
         , Object_GoodsMaster.ObjectCode     AS GoodsMasterCode
         , Object_GoodsMaster.ValueData      AS GoodsMasterName

         , Object_Goods.Id             AS GoodsId
         , Object_Goods.ObjectCode     AS GoodsCode
         , Object_Goods.ValueData      AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

     FROM Object AS Object_GoodsSeparate
          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_Goods
                               ON ObjectLink_GoodsSeparate_Goods.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_GoodsSeparate_Goods.DescId = zc_ObjectLink_GoodsSeparate_Goods()
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_GoodsSeparate_Goods.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_GoodsKind
                              ON ObjectLink_GoodsSeparate_GoodsKind.ObjectId = Object_GoodsSeparate.Id
                             AND ObjectLink_GoodsSeparate_GoodsKind.DescId = zc_ObjectLink_GoodsSeparate_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsSeparate_GoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsSeparate_GoodsMaster
                               ON ObjectLink_GoodsSeparate_GoodsMaster.ObjectId = Object_GoodsSeparate.Id
                              AND ObjectLink_GoodsSeparate_GoodsMaster.DescId = zc_ObjectLink_GoodsSeparate_GoodsMaster()
          LEFT JOIN Object AS Object_GoodsMaster ON Object_GoodsMaster.Id = ObjectLink_GoodsSeparate_GoodsMaster.ChildObjectId

          LEFT JOIN ObjectBoolean AS ObjectBoolean_Calculated
                                  ON ObjectBoolean_Calculated.ObjectId = Object_GoodsSeparate.Id 
                                 AND ObjectBoolean_Calculated.DescId = zc_ObjectBoolean_GoodsSeparate_Calculated()

     WHERE Object_GoodsSeparate.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_GoodsSeparate(integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.18         *
 07.10.18         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GoodsSeparate (100, '2')
