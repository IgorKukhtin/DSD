-- Function: gpSelect_Object_ProdOptItems()

DROP FUNCTION IF EXISTS gpSelect_Object_ProdOptItems (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdOptItems(
    IN inIsShowAll   Boolean,            -- ������� �������� ��� (���������� �� ����� �����������)
    IN inIsErased    Boolean,            -- ������� �������� ��������� �� / ��� 
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , PriceIn TFloat, PriceOut TFloat
             , PartNumber TVarChar, Comment TVarChar
             , ProductId Integer, ProductName TVarChar
             , ProdOptionsId Integer, ProdOptionsName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isErased boolean) AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdOptItems());
   vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
     tmpProdOptItemsAll AS (SELECT DISTINCT 
                                   Object_ProdOptions.Id            AS ProdOptionsId
                                 , Object_ProdOptions.ValueData     AS ProdOptionsName
                            FROM Object AS Object_ProdOptItems
                                 LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                                                      ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                                                     AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
                                 LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId 
                            WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
                            AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
                            AND inIsShowAll = TRUE
                            )
   , tmpAll AS (SELECT Object_Product.Id        AS ProductId
                     , Object_Product.ValueData AS ProductName
                     , tmpProdOptItemsAll.ProdOptionsId
                     , tmpProdOptItemsAll.ProdOptionsName
                FROM Object AS Object_Product
                     LEFT JOIN tmpProdOptItemsAll ON 1=1
                WHERE Object_Product.DescId = zc_Object_Product()
                 AND (Object_Product.isErased = FALSE OR inIsErased = TRUE)
                 AND inIsShowAll = TRUE
               )

     SELECT 
           Object_ProdOptItems.Id             ::Integer   AS Id 
         , Object_ProdOptItems.ObjectCode     ::Integer   AS Code
         , Object_ProdOptItems.ValueData      ::TVarChar  AS Name

         , ObjectFloat_PriceIn.ValueData      ::TFloat    AS PriceIn
         , ObjectFloat_PriceOut.ValueData     ::TFloat    AS PriceOut
         , ObjectString_PartNumber.ValueData  ::TVarChar  AS PartNumber
         , ObjectString_Comment.ValueData     ::TVarChar  AS Comment

         , Object_Product.Id                  ::Integer   AS ProductId
         , Object_Product.ValueData           ::TVarChar  AS ProductName

         , Object_ProdOptions.Id              ::Integer  AS ProdOptionsId
         , Object_ProdOptions.ValueData       ::TVarChar AS ProdOptionsName

         , Object_Insert.ValueData            ::TVarChar  AS InsertName
         , ObjectDate_Insert.ValueData        ::TDateTime AS InsertDate
         , Object_ProdOptItems.isErased       ::Boolean   AS isErased
         
     FROM Object AS Object_ProdOptItems
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ProdOptItems_Comment()  
          LEFT JOIN ObjectString AS ObjectString_PartNumber
                                 ON ObjectString_PartNumber.ObjectId = Object_ProdOptItems.Id
                                AND ObjectString_PartNumber.DescId = zc_ObjectString_ProdOptItems_PartNumber()

          LEFT JOIN ObjectFloat AS ObjectFloat_PriceIn
                                ON ObjectFloat_PriceIn.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceIn.DescId = zc_ObjectFloat_ProdOptItems_PriceIn()
          LEFT JOIN ObjectFloat AS ObjectFloat_PriceOut
                                ON ObjectFloat_PriceOut.ObjectId = Object_ProdOptItems.Id
                               AND ObjectFloat_PriceOut.DescId = zc_ObjectFloat_ProdOptItems_PriceOut()

          LEFT JOIN ObjectLink AS ObjectLink_Product
                               ON ObjectLink_Product.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Product.DescId = zc_ObjectLink_ProdOptItems_Product()
          LEFT JOIN Object AS Object_Product ON Object_Product.Id = ObjectLink_Product.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ProdOptions
                               ON ObjectLink_ProdOptions.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_ProdOptions.DescId = zc_ObjectLink_ProdOptItems_ProdOptions()
          LEFT JOIN Object AS Object_ProdOptions ON Object_ProdOptions.Id = ObjectLink_ProdOptions.ChildObjectId 

          LEFT JOIN ObjectLink AS ObjectLink_Insert
                               ON ObjectLink_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId 

          LEFT JOIN ObjectDate AS ObjectDate_Insert
                               ON ObjectDate_Insert.ObjectId = Object_ProdOptItems.Id
                              AND ObjectDate_Insert.DescId = zc_ObjectDate_Protocol_Insert()

     WHERE Object_ProdOptItems.DescId = zc_Object_ProdOptItems()
      AND (Object_ProdOptItems.isErased = FALSE OR inIsErased = TRUE)
    UNION ALL
     SELECT 0                         ::Integer   AS Id 
          , 0                         ::Integer   AS Code
          , ''                        ::TVarChar  AS Name
          , 0                         ::TFloat    AS PriceIn
          , 0                         ::TFloat    AS PriceOut
          , ''                        ::TVarChar  AS PartNumber
          , ''                        ::TVarChar  AS Comment
          , tmpAll.ProductId          ::Integer   AS ProductId
          , tmpAll.ProductName        ::TVarChar  AS ProductName
          , tmpAll.ProdOptionsId      ::Integer   AS ProdOptionsId
          , tmpAll.ProdOptionsName    ::TVarChar  AS ProdOptionsName
          , ''                        ::TVarChar  AS InsertName
          , NULL                      ::TDateTime AS InsertDate
          , FALSE                     ::Boolean   AS isErased
     FROM tmpAll
     ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.20         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ProdOptItems (true, true, zfCalc_UserAdmin())
