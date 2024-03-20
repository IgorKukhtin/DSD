-- Function: gpGet_Object_ReceiptGoodsChild()

DROP FUNCTION IF EXISTS gpGet_Object_ReceiptGoodsChild (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptGoodsChild(
    IN inId          Integer ,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, NPP_service Integer
             , Comment TVarChar
             , Value TFloat
             , ReceiptGoodsId Integer, ReceiptGoodsName TVarChar
             , ObjectId Integer, ObjectName TVarChar
) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , 0  :: Integer            AS NPP_service
           , '' :: TVarChar           AS Comment
           , 0  :: TFloat             AS Value
           , 0  :: Integer            AS ReceiptGoodsId
           , '' :: TVarChar           AS ReceiptGoodsName
           , 0  :: Integer            AS ObjectId
           , '' :: TVarChar           AS ObjectName 
           
       ;
   ELSE
     RETURN QUERY

     SELECT 
           Object_ReceiptGoodsChild.Id              AS Id 
         , ObjectFloat_NPP_service.ValueData  ::Integer AS NPP_service
         , Object_ReceiptGoodsChild.ValueData       AS Comment

         , ObjectFloat_Value.ValueData   ::TFloat   AS Value

         , Object_ReceiptGoods.Id        ::Integer  AS ReceiptGoodsId
         , Object_ReceiptGoods.ValueData ::TVarChar AS ReceiptGoodsName

         , Object_Object.Id               ::Integer  AS ObjectId
         , Object_Object.ValueData        ::TVarChar AS ObjectName
     FROM Object AS Object_ReceiptGoodsChild
 
          LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                ON ObjectFloat_Value.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_Value.DescId   = zc_ObjectFloat_ReceiptGoodsChild_Value() 
          LEFT JOIN ObjectFloat AS ObjectFloat_ForCount
                                ON ObjectFloat_ForCount.ObjectId = Object_ReceiptGoodsChild.Id
                               AND ObjectFloat_ForCount.DescId   = zc_ObjectFloat_ReceiptGoodsChild_ForCount()
 
          LEFT JOIN ObjectFloat AS ObjectFloat_NPP_service
                               ON ObjectFloat_NPP_service.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectFloat_NPP_service.DescId   = zc_ObjectFloat_ReceiptGoodsChild_NPP_service()
                              
          LEFT JOIN ObjectLink AS ObjectLink_ReceiptGoods
                               ON ObjectLink_ReceiptGoods.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_ReceiptGoods.DescId = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
          LEFT JOIN Object AS Object_ReceiptGoods ON Object_ReceiptGoods.Id = ObjectLink_ReceiptGoods.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Object
                               ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                              AND ObjectLink_Object.DescId = zc_ObjectLink_ReceiptGoodsChild_Object()
          LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_Object.ChildObjectId

     WHERE Object_ReceiptGoodsChild.DescId = zc_Object_ReceiptGoodsChild()
      AND Object_ReceiptGoodsChild.Id = inId
     ;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.03.24         *
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ReceiptGoodsChild (0, zfCalc_UserAdmin())
