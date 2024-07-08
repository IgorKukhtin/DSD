-- Function: gpSelect_Object_ModelServiceItemChild()

DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(Boolean,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_ModelServiceItemChild(Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ModelServiceItemChild(
    IN inIsShowAll        Boolean, 
    IN inIsShowbyGroup    Boolean,       --показать товары приход / расход
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar, DescName_from TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar, DescName_to TVarChar

             , FromGoodsKindId Integer, FromGoodsKindName TVarChar
             , ToGoodsKindId Integer, ToGoodsKindName TVarChar
             , FromGoodsKindCompleteId Integer, FromGoodsKindCompleteName TVarChar
             , ToGoodsKindCompleteId Integer, ToGoodsKindCompleteName TVarChar

             , ModelServiceItemMasterId Integer, ModelServiceItemMasterName TVarChar

             , FromStorageLineId Integer, FromStorageLineName TVarChar
             , ToStorageLineId Integer, ToStorageLineName TVarChar

             , isErased boolean 
             
             , GoodsCode_to          Integer
             , GoodsName_to          TVarChar
             , GoodsGroupName_to     TVarChar      
             , GoodsGroupNameFull_to TVarChar   
             , GroupStatName_to      TVarChar   
             , GoodsGroupAnalystName_to  TVarChar
             , TradeMarkName_to      TVarChar  
             , GoodsTagName_to       TVarChar   
             , GoodsPlatformName_to  TVarChar  
             --
             , GoodsCode_from        Integer
             , GoodsName_from        TVarChar
             , GoodsGroupName_from   TVarChar     
             , GoodsGroupNameFull_from  TVarChar  
             , GroupStatName_from       TVarChar   
             , GoodsGroupAnalystName_from  TVarChar
             , TradeMarkName_from     TVarChar     
             , GoodsTagName_from      TVarChar     
             , GoodsPlatformName_from TVarChar
             , UpdateName TVarChar, UpdateDate TDateTime 
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ModelServiceItemChild());

   RETURN QUERY 
   WITH
   tmpObject AS (SELECT Object_ModelServiceItemChild.* 
                      , ObjectLink_ModelServiceItemChild_From.ChildObjectId AS FromId
                      , ObjectLink_ModelServiceItemChild_To.ChildObjectId   AS ToId
                 FROM Object AS Object_ModelServiceItemChild
                      LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_From
                                           ON ObjectLink_ModelServiceItemChild_From.ObjectId = Object_ModelServiceItemChild.Id
                                          AND ObjectLink_ModelServiceItemChild_From.DescId = zc_ObjectLink_ModelServiceItemChild_From()
            
                      LEFT JOIN ObjectLink AS ObjectLink_ModelServiceItemChild_To
                                           ON ObjectLink_ModelServiceItemChild_To.ObjectId = Object_ModelServiceItemChild.Id
                                          AND ObjectLink_ModelServiceItemChild_To.DescId = zc_ObjectLink_ModelServiceItemChild_To()
                 WHERE Object_ModelServiceItemChild.DescId = zc_Object_ModelServiceItemChild()
                   AND (Object_ModelServiceItemChild.isErased = False OR inIsShowAll = True)
                 )      
, tmpGoods AS (SELECT  tmp.GoodsGroupId
                     , Object_Goods.Id             AS GoodsId
                     , Object_Goods.ObjectCode     AS GoodsCode
                     , Object_Goods.ValueData :: TVarChar AS GoodsName
                     , Object_GoodsGroup.ValueData AS GoodsGroupName
                     , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                     , Object_GoodsGroupStat.ValueData AS GroupStatName
                     , Object_GoodsGroupAnalyst.ValueData AS GoodsGroupAnalystName

                     , Object_TradeMark.ValueData      AS TradeMarkName
                     , Object_GoodsTag.ValueData       AS GoodsTagName
                     , Object_GoodsPlatform.ValueData  AS GoodsPlatformName
               FROM (
                     SELECT tmpObject.Id AS GoodsGroupId, tmp.GoodsId 
                     FROM (SELECT DISTINCT tmpObject.ToId AS Id FROM tmpObject
                     UNION SELECT DISTINCT tmpObject.FromId AS Id FROM tmpObject) AS tmpObject
                          LEFT JOIN lfSelect_Object_Goods_byGoodsGroup (tmpObject.Id) AS tmp ON 1 = 1
                     WHERE COALESCE (tmp.GoodsId,0) <> 0 
                       AND inIsShowbyGroup = TRUE
                     ) AS tmp
                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId

                     LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                          ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
                     LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId

                     LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupStat
                                          ON ObjectLink_Goods_GoodsGroupStat.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_GoodsGroupStat.DescId = zc_ObjectLink_Goods_GoodsGroupStat()
                     LEFT JOIN Object AS Object_GoodsGroupStat ON Object_GoodsGroupStat.Id = ObjectLink_Goods_GoodsGroupStat.ChildObjectId

                     LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupAnalyst
                                          ON ObjectLink_Goods_GoodsGroupAnalyst.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_GoodsGroupAnalyst.DescId = zc_ObjectLink_Goods_GoodsGroupAnalyst()
                     LEFT JOIN Object AS Object_GoodsGroupAnalyst ON Object_GoodsGroupAnalyst.Id = ObjectLink_Goods_GoodsGroupAnalyst.ChildObjectId
        
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsTag
                                          ON ObjectLink_Goods_GoodsTag.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_GoodsTag.DescId = zc_ObjectLink_Goods_GoodsTag()
                     LEFT JOIN Object AS Object_GoodsTag ON Object_GoodsTag.Id = ObjectLink_Goods_GoodsTag.ChildObjectId
        
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                          ON ObjectLink_Goods_TradeMark.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                     LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId
        
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsPlatform
                                          ON ObjectLink_Goods_GoodsPlatform.ObjectId = Object_Goods.Id
                                         AND ObjectLink_Goods_GoodsPlatform.DescId = zc_ObjectLink_Goods_GoodsPlatform()
                     LEFT JOIN Object AS Object_GoodsPlatform ON Object_GoodsPlatform.Id = ObjectLink_Goods_GoodsPlatform.ChildObjectId
        
                     LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                            ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                           AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
                )  
      
   , tmpProtocol AS (SELECT tmp.ObjectId
                          , tmp.UserId
                          , Object_User.ValueData AS UserName
                          , tmp.OperDate
                     FROM (SELECT ObjectProtocol.*
                                  -- № п/п
                                , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate DESC) AS Ord
                           FROM ObjectProtocol
                           WHERE ObjectProtocol.ObjectId IN (SELECT tmpObject.Id FROM tmpObject)
                           ) AS tmp 
                           LEFT JOIN Object AS Object_User ON Object_User.Id = tmp.UserId  
                     WHERE tmp.Ord = 1
                     )

     ---
     SELECT
           Object_ModelServiceItemChild.Id    AS Id

         , ObjectString_Comment.ValueData      AS Comment

         , Object_From.Id          AS FromId
         , CASE WHEN Object_From.ObjectCode > 0 THEN Object_From.ObjectCode ELSE Object_From.Id END :: Integer AS FromCode
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN /*'(' || Object_From.ObjectCode :: TvarChar || ') ' ||*/ Object_From.ValueData
                ELSE COALESCE (Object_GoodsGroup_Parent_from_next2.ValueData || ' ', '')
                  || COALESCE (Object_GoodsGroup_Parent_from_next.ValueData || ' ', '')
                  || COALESCE (Object_GoodsGroup_Parent_from.ValueData || ' ', '') || Object_From.ValueData
                  || CASE WHEN Object_From.ObjectCode > 0 THEN '' ELSE '' END 
           END :: TVarChar AS FromName
         , ObjectDesc_From.ItemName  ::TVarChar AS DescName_from

         , Object_To.Id         AS ToId
         , CASE WHEN Object_To.ObjectCode > 0 THEN Object_To.ObjectCode ELSE Object_To.Id END :: Integer AS ToCode
         , CASE WHEN Object_From.DescId = zc_Object_Goods() THEN /*'(' || Object_To.ObjectCode :: TvarChar || ') ' ||*/ Object_To.ValueData
                ELSE COALESCE (Object_GoodsGroup_Parent_to_next2.ValueData || ' ', '')
                  || COALESCE (Object_GoodsGroup_Parent_to_next.ValueData || ' ', '')
                  || COALESCE (Object_GoodsGroup_Parent_to.ValueData || ' ', '') || Object_To.ValueData
                  || CASE WHEN Object_To.ObjectCode > 0 THEN '' ELSE '' END
           END :: TVarChar AS ToName
         , ObjectDesc_To.ItemName  ::TVarChar AS DescName_to 

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
         --
         , tmpGoods_to.GoodsCode              AS GoodsCode_to
         , tmpGoods_to.GoodsName              AS GoodsName_to
         , tmpGoods_to.GoodsGroupName         AS GoodsGroupName_to       
         , tmpGoods_to.GoodsGroupNameFull     AS GoodsGroupNameFull_to   
         , tmpGoods_to.GroupStatName          AS GroupStatName_to        
         , tmpGoods_to.GoodsGroupAnalystName  AS GoodsGroupAnalystName_to
         , tmpGoods_to.TradeMarkName          AS TradeMarkName_to        
         , tmpGoods_to.GoodsTagName           AS GoodsTagName_to         
         , tmpGoods_to.GoodsPlatformName      AS GoodsPlatformName_to   
         --
         , tmpGoods_from.GoodsCode              AS GoodsCode_from
         , tmpGoods_from.GoodsName              AS GoodsName_from
         , tmpGoods_from.GoodsGroupName         AS GoodsGroupName_from       
         , tmpGoods_from.GoodsGroupNameFull     AS GoodsGroupNameFull_from   
         , tmpGoods_from.GroupStatName          AS GroupStatName_from        
         , tmpGoods_from.GoodsGroupAnalystName  AS GoodsGroupAnalystName_from
         , tmpGoods_from.TradeMarkName          AS TradeMarkName_from        
         , tmpGoods_from.GoodsTagName           AS GoodsTagName_from         
         , tmpGoods_from.GoodsPlatformName      AS GoodsPlatformName_from   

         , tmpProtocol.UserName    ::TVarChar  AS UpdateName
         , tmpProtocol.OperDate    ::TDateTime AS UpdateDate                     
     FROM tmpObject AS Object_ModelServiceItemChild
          LEFT JOIN Object AS Object_From ON Object_From.Id = Object_ModelServiceItemChild.FromId 
          LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId
          LEFT JOIN Object AS Object_To ON Object_To.Id = Object_ModelServiceItemChild.ToId 
          LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

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

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_from
                               ON ObjectLink_GoodsGroup_Parent_from.ObjectId = Object_From.Id
                              AND ObjectLink_GoodsGroup_Parent_from.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_from ON Object_GoodsGroup_Parent_from.Id = ObjectLink_GoodsGroup_Parent_from.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_from_next
                               ON ObjectLink_GoodsGroup_Parent_from_next.ObjectId = Object_GoodsGroup_Parent_from.Id
                              AND ObjectLink_GoodsGroup_Parent_from_next.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_from_next ON Object_GoodsGroup_Parent_from_next.Id = ObjectLink_GoodsGroup_Parent_from_next.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_from_next2
                               ON ObjectLink_GoodsGroup_Parent_from_next2.ObjectId = Object_GoodsGroup_Parent_from_next.Id
                              AND ObjectLink_GoodsGroup_Parent_from_next2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_from_next2 ON Object_GoodsGroup_Parent_from_next2.Id = ObjectLink_GoodsGroup_Parent_from_next2.ChildObjectId


          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_to
                               ON ObjectLink_GoodsGroup_Parent_to.ObjectId = Object_To.Id
                              AND ObjectLink_GoodsGroup_Parent_to.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_to ON Object_GoodsGroup_Parent_to.Id = ObjectLink_GoodsGroup_Parent_to.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_to_next
                               ON ObjectLink_GoodsGroup_Parent_to_next.ObjectId = Object_GoodsGroup_Parent_to.Id
                              AND ObjectLink_GoodsGroup_Parent_to_next.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_to_next ON Object_GoodsGroup_Parent_to_next.Id = ObjectLink_GoodsGroup_Parent_to_next.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent_to_next2
                               ON ObjectLink_GoodsGroup_Parent_to_next2.ObjectId = Object_GoodsGroup_Parent_to_next.Id
                              AND ObjectLink_GoodsGroup_Parent_to_next2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
          LEFT JOIN Object AS Object_GoodsGroup_Parent_to_next2 ON Object_GoodsGroup_Parent_to_next2.Id = ObjectLink_GoodsGroup_Parent_to_next2.ChildObjectId

          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_ModelServiceItemChild.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_ModelServiceItemChild_Comment()

          --
          --LEFT JOIN tmpGoods AS tmpGoods_to ON tmpGoods_to.GoodsGroupId = Object_To.Id AND COALESCE (Object_From.Id,0) = 0
          --LEFT JOIN tmpGoods AS tmpGoods_from ON tmpGoods_from.GoodsGroupId = Object_From.Id AND COALESCE (Object_To.Id,0) = 0 
          LEFT JOIN tmpGoods AS tmpGoods_to ON tmpGoods_to.GoodsGroupId = Object_To.Id
          LEFT JOIN tmpGoods AS tmpGoods_from ON tmpGoods_from.GoodsGroupId = Object_From.Id 
                                            AND (tmpGoods_from.GoodsId = tmpGoods_to.GoodsId OR COALESCE (tmpGoods_to.GoodsId,0) = 0)

          LEFT JOIN tmpProtocol ON tmpProtocol.ObjectId = Object_ModelServiceItemChild.Id
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.08.23         *
 02.06.17         * add inIsShowAll
 26.05.17         * add StorageLine
 27.12.16         *
 20.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ModelServiceItemChild (False, False,'2')
