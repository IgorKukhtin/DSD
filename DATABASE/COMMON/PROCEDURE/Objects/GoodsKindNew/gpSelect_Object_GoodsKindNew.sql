-- Function: gpSelect_Object_GoodsKindNew()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsKindNew (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsKindNew(
    IN inShowAll        Boolean, 
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsKindNew());
   vbUserId:= lpGetUserBySession (inSession);


   IF EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE UserId = vbUserId AND BranchId <> 0 AND BranchId NOT IN (301310, 8109544 )) -- ������ ��������� + ����
   THEN
       -- ��������� �����
       RETURN QUERY 
       WITH tmpGoodsKindNew AS (SELECT DISTINCT ObjectLink_GoodsByGoodsKind_GoodsKindNew.ChildObjectId AS GoodsKindNewId
                             FROM ObjectBoolean AS ObjectBoolean_Order
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKindNew
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKindNew.ObjectId = ObjectBoolean_Order.ObjectId
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKindNew.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKindNew()
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKindNew.ChildObjectId > 0
                             WHERE ObjectBoolean_Order.ValueData = TRUE
                               AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                            )

       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM tmpGoodsKindNew
            INNER JOIN Object ON Object.Id = tmpGoodsKindNew.GoodsKindNewId
                             AND (Object.isErased = FALSE OR inShowAll = TRUE)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , '�������' :: TVarChar AS Name
            , FALSE AS isErased
      ;
   ELSE
       -- ��������� ������
       RETURN QUERY 
       SELECT 
             Object.Id         AS Id 
           , Object.ObjectCode AS Code
           , Object.ValueData  AS Name
           , Object.isErased   AS isErased
       FROM Object
       WHERE Object.DescId = zc_Object_GoodsKindNew()
           AND (Object.Id <> 268778 OR vbUserId = 5) -- "������ - ��" + �����
           AND (Object.isErased = FALSE OR inShowAll = TRUE)
      UNION ALL
       SELECT 0 AS Id
            , 0 AS Code
            , '�������' :: TVarChar AS Name
            , FALSE AS isErased
      ;
   END IF;
     
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsKindNew (inShowAll := false, inSession:= zfCalc_UserAdmin())
