-- Function: gpSelect_Object_ModelServiceItemChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelServiceItemChild(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar                
             , ToId Integer, ToCode Integer, ToName TVarChar  

             , FromGoodsKindId Integer, FromGoodsKindName TVarChar                
             , ToGoodsKindId Integer, ToGoodsKindName TVarChar  
             , FromGoodsKindCompleteId Integer, FromGoodsKindCompleteName TVarChar                
             , ToGoodsKindCompleteId Integer, ToGoodsKindCompleteName TVarChar  

             , ModelServiceItemMasterId Integer, ModelServiceItemMasterName TVarChar 

             , FromStorageLineId Integer, FromStorageLineName TVarChar                
             , ToStorageLineId Integer, ToStorageLineName TVarChar 

             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelServiceItemChild());

   RETURN QUERY 
     SELECT 
           Object_ModelServiceItemChild.Id    AS Id
 
         , ObjectString_Comment.ValueData      AS Comment
                                                        
         , Object_From.Id          AS FromId
         , Object_From.ObjectCode  AS FromCode
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN /*'(' || Object_From.ObjectCode :: TvarChar || ') ' ||*/ Object_From.ValueData ELSE Object_From.ValueData END :: TVarChar AS FromName

         , Object_To.Id         AS ToId
         , Object_To.ObjectCode AS ToCode
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN /*'(' || Object_To.ObjectCode :: TvarChar || ') ' ||*/ Object_To.ValueData ELSE Object_To.ValueData END :: TVarChar AS ToName

         , Object_FromGoodsKind.Id          AS FromGoodsKindId
         , Object_FromGoodsKind.ValueData   AS FromGoodsKindName
         , Object_ToGoodsKind.Id            AS ToGoodsKindId
         , Object_ToGoodsKind.ValueData     AS ToGoodsKindName

         , Object_FromGoodsKindComplete.Id          AS FromGoodsKindCompleteId
         , Object_FromGoodsKindComplete.ValueData   AS FromGoodsKindCompleteName
         , Object_ToGoodsKindComplete.Id            AS ToGoodsKindCompleteId
         , Object_ToGoodsKindComplete.ValueData     AS ToGoodsKindCompleteName

         , Object_ModelServiceItemMaster.Id         AS ModelServiceItemMasterId
         , Object_ModelServiceItemMaster.ValueData  AS ModelServiceItemMasterName

         , Object_FromStorageLine.Id                AS FromStorageLineId
         , Object_FromStorageLine.ValueData         AS FromStorageLineName
         , Object_ToStorageLine.Id                  AS ToStorageLineId
         , Object_ToStorageLine.ValueData           AS ToStorageLineName

         , Object_ModelServiceItemChild.isErased AS isErased
         
     FROM OBJECT AS Object_ModelServiceItemChild
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                               ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = ObjectLink_ModelServiceItemChild_From.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                               ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = ObjectLink_ModelServiceItemChild_To.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_FromGoodsKind
                               ON ObjectLink_ModelServiceItemChild_FromGoodsKind.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_FromGoodsKind.DescId = zc_ObjectLink_ModelServiceItemChild_FromGoodsKind()
          LEFT JOIN Object AS Object_FromGoodsKind ON Object_FromGoodsKind.Id = ObjectLink_ModelServiceItemChild_FromGoodsKind.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ToGoodsKind
                               ON ObjectLink_ModelServiceItemChild_ToGoodsKind.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_ToGoodsKind.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKind()
          LEFT JOIN Object AS Object_ToGoodsKind ON Object_ToGoodsKind.Id = ObjectLink_ModelServiceItemChild_ToGoodsKind.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_FromGoodsKindComplete
                               ON ObjectLink_ModelServiceItemChild_FromGoodsKindComplete.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_FromGoodsKindComplete.DescId = zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete()
          LEFT JOIN Object AS Object_FromGoodsKindComplete ON Object_FromGoodsKindComplete.Id = ObjectLink_ModelServiceItemChild_FromGoodsKindComplete.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ToGoodsKindComplete
                               ON ObjectLink_ModelServiceItemChild_ToGoodsKindComplete.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_ToGoodsKindComplete.DescId = zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete()
          LEFT JOIN Object AS Object_ToGoodsKindComplete ON Object_ToGoodsKindComplete.Id = ObjectLink_ModelServiceItemChild_ToGoodsKindComplete.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ModelServiceItemMaster
                               ON ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.DescId = zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster()
          LEFT JOIN Object AS Object_ModelServiceItemMaster ON Object_ModelServiceItemMaster.Id = ObjectLink_ModelServiceItemChild_ModelServiceItemMaster.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_FromStorageLine
                               ON ObjectLink_ModelServiceItemChild_FromStorageLine.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_FromStorageLine.DescId = zc_ObjectLink_ModelServiceItemChild_FromStorageLine()
          LEFT JOIN Object AS Object_FromStorageLine ON Object_FromStorageLine.Id = ObjectLink_ModelServiceItemChild_FromStorageLine.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_ToStorageLine
                               ON ObjectLink_ModelServiceItemChild_ToStorageLine.ObjectId = Object_ModelServiceItemChild.Id
                              AND ObjectLink_ModelServiceItemChild_ToStorageLine.DescId = zc_ObjectLink_ModelServiceItemChild_ToStorageLine()
          LEFT JOIN Object AS Object_ToStorageLine ON Object_ToStorageLine.Id = ObjectLink_ModelServiceItemChild_ToStorageLine.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ModelServiceItemChild.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_ModelServiceItemChild_Comment()

     WHERE Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild();
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.05.17         * add StorageLine
 27.12.16         *
 20.10.13         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_ModelServiceItemChild ('2')
