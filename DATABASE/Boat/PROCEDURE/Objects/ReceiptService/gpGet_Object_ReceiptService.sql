--
DROP FUNCTION IF EXISTS gpGet_Object_ReceiptService (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_ReceiptService(
    IN inId          Integer,       -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Article TVarChar
             , Comment TVarChar , NumReplace TVarChar
             , TaxKindId Integer, TaxKindName TVarChar 
             , PartnerId Integer, PartnerName TVarChar  
             , ReceiptServiceGroupId Integer, ReceiptServiceGroupName TVarChar
             , ReceiptServiceModelId Integer, ReceiptServiceModelName TVarChar
             , ReceiptServiceMaterialId Integer, ReceiptServiceMaterialName TVarChar
             , EKPrice TFloat, SalePrice TFloat
             , NPP TFloat
             ) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ReceiptService());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer     AS Id
           , lfGet_ObjectCode (0, zc_Object_ReceiptService()) AS Code
           , '' :: TVarChar           AS Name
           , '' :: TVarChar           AS Article
           , '' :: TVarChar           AS Comment   
           , '' :: TVarChar           AS NumReplace
           , Object_TaxKind.Id        AS TaxKindId
           , (Object_TaxKind.ValueData || ' ' || zfConvert_FloatToString (ObjectFloat_TaxKind_Value.ValueData) ||'%') :: TVarChar AS TaxKindName

           , 0                        AS PartnerId
           , '' :: TVarChar           AS PartnerName

           , 0                        AS ReceiptServiceGroupId
           , '' :: TVarChar           AS ReceiptServiceGroupName
           , 0                        AS ReceiptServiceModelId
           , '' :: TVarChar           AS ReceiptServiceModelName
           , 0                        AS ReceiptServiceMaterialId
           , '' :: TVarChar           AS ReceiptServiceMaterialName

           , 0  :: TFloat             AS EKPrice
           , 0  :: TFloat             AS SalePrice
           , 0  :: TFloat             AS NPP
       FROM Object AS Object_TaxKind
           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                AND ObjectFloat_TaxKind_Value.DescId   = zc_ObjectFloat_TaxKind_Value()
       WHERE Object_TaxKind.Id = zc_Enum_TaxKind_WithVAT()
      ;

   ELSE
       RETURN QUERY
       SELECT
             Object_ReceiptService.Id         AS Id
           , Object_ReceiptService.ObjectCode AS Code
           , Object_ReceiptService.ValueData  AS Name
           , ObjectString_Article.ValueData   AS Article
           , COALESCE (ObjectString_Comment.ValueData, NULL)    :: TVarChar AS Comment
           , COALESCE (ObjectString_NumReplace.ValueData, NULL) :: TVarChar AS NumReplace

           , Object_TaxKind.Id                                     AS TaxKindId
           , (Object_TaxKind.ValueData || ' ' || zfConvert_FloatToString (ObjectFloat_TaxKind_Value.ValueData) ||'%') :: TVarChar AS TaxKindName

           , Object_Partner.Id                                     AS PartnerId
           , Object_Partner.ValueData                              AS PartnerName

           , Object_ReceiptServiceGroup.Id            AS ReceiptServiceGroupId
           , Object_ReceiptServiceGroup.ValueData     AS ReceiptServiceGroupName
           , Object_ReceiptServiceModel.Id            AS ReceiptServiceModelId
           , Object_ReceiptServiceModel.ValueData     AS ReceiptServiceModelName
           , Object_ReceiptServiceMaterial.Id         AS ReceiptServiceMaterialId
           , Object_ReceiptServiceMaterial.ValueData  AS ReceiptServiceMaterialName

           , COALESCE (ObjectFloat_EKPrice.ValueData,0)   ::TFloat AS EKPrice
           , COALESCE (ObjectFloat_SalePrice.ValueData,0) ::TFloat AS SalePrice
           
           , COALESCE (ObjectFloat_NPP.ValueData,0)       ::TFloat AS NPP
           
       FROM Object AS Object_ReceiptService
           LEFT JOIN ObjectString AS ObjectString_Comment
                                  ON ObjectString_Comment.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Comment.DescId = zc_ObjectString_ReceiptService_Comment()
           LEFT JOIN ObjectString AS ObjectString_Article
                                  ON ObjectString_Article.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_Article.DescId = zc_ObjectString_Article()

           LEFT JOIN ObjectString AS ObjectString_NumReplace
                                  ON ObjectString_NumReplace.ObjectId = Object_ReceiptService.Id
                                 AND ObjectString_NumReplace.DescId = zc_ObjectString_ReceiptService_NumReplace()

           LEFT JOIN ObjectFloat AS ObjectFloat_EKPrice
                                 ON ObjectFloat_EKPrice.ObjectId = Object_ReceiptService.Id
                                AND ObjectFloat_EKPrice.DescId = zc_ObjectFloat_ReceiptService_EKPrice()

           LEFT JOIN ObjectFloat AS ObjectFloat_SalePrice
                                 ON ObjectFloat_SalePrice.ObjectId = Object_ReceiptService.Id
                                AND ObjectFloat_SalePrice.DescId = zc_ObjectFloat_ReceiptService_SalePrice()

            LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                                  ON ObjectFloat_NPP.ObjectId = Object_ReceiptService.Id
                                 AND ObjectFloat_NPP.DescId = zc_ObjectFloat_ReceiptService_NPP()

           LEFT JOIN ObjectLink AS ObjectLink_Partner
                                ON ObjectLink_Partner.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_Partner.DescId = zc_ObjectLink_ReceiptService_Partner()
           LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_ReceiptServiceGroup
                                ON ObjectLink_ReceiptServiceGroup.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_ReceiptServiceGroup.DescId = zc_ObjectLink_ReceiptService_ReceiptServiceGroup()
           LEFT JOIN Object AS Object_ReceiptServiceGroup ON Object_ReceiptServiceGroup.Id = ObjectLink_ReceiptServiceGroup.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_ReceiptServiceModel
                                ON ObjectLink_ReceiptServiceModel.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_ReceiptServiceModel.DescId = zc_ObjectLink_ReceiptService_ReceiptServiceModel()
           LEFT JOIN Object AS Object_ReceiptServiceModel ON Object_ReceiptServiceModel.Id = ObjectLink_ReceiptServiceModel.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_ReceiptServiceMaterial
                                ON ObjectLink_ReceiptServiceMaterial.ObjectId = Object_ReceiptService.Id
                               AND ObjectLink_ReceiptServiceMaterial.DescId = zc_ObjectLink_ReceiptService_ReceiptServiceMaterial()
           LEFT JOIN Object AS Object_ReceiptServiceMaterial ON Object_ReceiptServiceMaterial.Id = ObjectLink_ReceiptServiceMaterial.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_TaxKind
                                ON ObjectLink_TaxKind.ObjectId = Object_Partner.Id
                               AND ObjectLink_TaxKind.DescId   = zc_ObjectLink_Partner_TaxKind()

           LEFT JOIN Object AS Object_TaxKind ON Object_TaxKind.Id = COALESCE (ObjectLink_TaxKind.ChildObjectId, zc_Enum_TaxKind_WithVAT())

           LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                 ON ObjectFloat_TaxKind_Value.ObjectId = Object_TaxKind.Id
                                AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()


       WHERE Object_ReceiptService.Id = inId;
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
24.07.23          * Partner
11.12.20          *
*/

-- тест
-- SELECT * FROM gpGet_Object_ReceiptService (0, zfCalc_UserAdmin())
