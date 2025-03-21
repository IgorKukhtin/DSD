-- Function: gpGet_Object_ProdOptItems()

DROP FUNCTION IF EXISTS gpGet_Object_ProdOptItems (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ProdOptItems(
    IN inId          Integer ,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Amount TFloat
             , PriceIn TFloat, PriceOut TFloat, DiscountTax TFloat
             , PartNumber TVarChar, Comment TVarChar, CommentOpt TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , ProdOptPatternId Integer, ProdOptPatternName TVarChar
             ) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer            AS Id
           , lfGet_ObjectCode(0, zc_Object_Brand())   AS Code
           , '' :: TVarChar           AS Name
           ,  0 :: TFloat             AS Amount
           ,  0 :: TFloat             AS PriceIn
           ,  0 :: TFloat             AS PriceOut
           ,  0 :: TFloat             AS DiscountTax
           , '' :: TVarChar           AS PartNumber
           , '' :: TVarChar           AS Comment
           , '' :: TVarChar           AS CommentOpt
           ,  0 :: Integer            AS ProductId
           , '' :: TVarChar           AS ProductName
           ,  0 :: Integer            AS ProdOptionsId
           , '' :: TVarChar           AS ProdOptionsName
           ,  0 :: Integer            AS ProdOptPatternId
           , '' :: TVarChar           AS ProdOptPatternName
       ;
   ELSE
     RETURN QUERY
     SELECT 
           Object_ProdOptItems.Id             ::Integer   AS Id 
         , Object_ProdOptItems.ObjectCode     ::Integer   AS Code
         , Object_ProdOptItems.ValueData      ::TVarChar  AS Name

         , COALESCE (ObjectFloat_Count.ValueData,1) ::TFloat AS Amount
         , ObjectFloat_PriceIn.ValueData      ::TFloat    AS PriceIn
         , ObjectFloat_PriceOut.ValueData     ::TFloat    AS PriceOut
         , ObjectFloat_DiscountTax.ValueData  ::TFloat    AS DiscountTax
         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment
         , ObjectString_CommentOpt.ValueData  ::TVarChar  AS CommentOpt

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id              ::Integer  AS ProdOptionsId
         , Object_ProdOptions.ValueData       ::TVarChar AS ProdOptionsName
         
         , Object_ProdOptPattern.Id           ::Integer  AS ProdOptPatternId
         , Object_ProdOptPattern.ValueData    ::TVarChar AS ProdOptPatternName
         
     FROM Object AS Object_ProdOptItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptItems_Comment()  
          LEFT JOIN ObjectString AS ObjectString_CommentOpt
                                 ON ObjectString_CommentOpt.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_CommentOpt.DescId = zc_ObjectString_ProdOptItems_CommentOpt()
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

          LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
          LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()
          LEFT JOIN ObjectFloat AS ObjectFloat_DiscountTax
                                ON ObjectFloat_DiscountTax.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_DiscountTax.DescId = zc_ObjectFloat_Client_DiscountTax()

          -- ���-�� ����� �����
          LEFT JOIN ObjectFloat AS ObjectFloat_Count
                                ON ObjectFloat_Count.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_Count.DescId   = zc_ObjectFloat_ProdOptItems_Count()

          LEFT JOIN ObjectLink AS ObjectLink_Product
                               ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = ObjectLink_Product.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdOptPattern
                               ON ObjectLink_ProdOptPattern.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptPattern.DescId = zc_ObjectLink_ProdOptItems_ProdOptPattern()
          LEFT JOIN Object AS Object_ProdOptPattern ON Object_ProdOptPattern.Id = ObjectLink_ProdOptPattern.ChildObjectId 
          
          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId 

     WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
       AND Object_ProdOptItems.Id = inId
     ;  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.23         *
 04.01.21         * DiscountTax
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpGet_Object_ProdOptItems (0, zfCalc_UserAdmin())
