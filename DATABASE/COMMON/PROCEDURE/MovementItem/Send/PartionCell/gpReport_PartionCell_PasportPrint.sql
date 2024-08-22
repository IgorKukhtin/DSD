
-- Function: gpReport_PartionCell_PasportPrint

DROP FUNCTION IF EXISTS gpReport_PartionCell_PasportPrint (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PartionCell_PasportPrint (Integer, Integer, Integer, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PartionCell_PasportPrint(
    IN inMovementItemId    Integer  , --
    IN inPartionCellId     Integer  , --
    IN inGoodsCode         Integer  , --
    IN inGoodsName         TVarChar  , --
    IN inGoodsKindName     TVarChar  , -- 
    IN inPartionGoodsDate  TDateTime , 
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (GoodsCode Integer, GoodsName TVarChar
             , GoodsKindName TVarChar
             , PartionGoodsDate TDateTime 
             , PartionCellName TVarChar
             , StoreKeeper TVarChar  
             , ChoiceCellCode      Integer
             , ChoiceCellName      TVarChar
             , ChoiceCellName_shot TVarChar
              )
AS                      
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inPartionCellId,0) = 0 
     THEN
         RETURN;  
         
     END IF;
     
  -- Результат
  RETURN QUERY
     WITH
             --ячейки отбора               
       tmpChoiceCell AS (SELECT tmp.*
                              , LEFT (tmp.Name, 1)::TVarChar AS CellName_shot
                              , ROW_NUMBER() OVER (PARTITION BY tmp.GoodsId, tmp.GoodsKindId ORDER BY tmp.NPP) AS Ord
                         FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS tmp
                         WHERE tmp.GoodsName = inGoodsName
                           AND COALESCE (tmp.GoodsKindName,'') = COALESCE (inGoodsKindName,'')
                         )
     --
     SELECT Object_Goods.ObjectCode            AS GoodsCode
          , Object_Goods.ValueData             AS GoodsName
          , Object_GoodsKind.ValueData         AS GoodsKindName 
          , COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) :: TDateTime AS PartionGoodsDate
          , Object_PartionCell.ValueData       AS PartionCellName
          , Object_Member.ValueData ::TVarChar AS StoreKeeper
          --ячейка отбора
          , tmpChoiceCell.Code          ::Integer  AS ChoiceCellCode
          , tmpChoiceCell.Name          ::TVarChar AS ChoiceCellName
          , tmpChoiceCell.CellName_shot ::TVarChar AS ChoiceCellName_shot 
     FROM MovementItem
          LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
          LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
   
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                    AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
          LEFT JOIN Object AS Object_PartionCell ON Object_PartionCell.Id = inPartionCellId

        /*LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = vbUserId
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()*/
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = vbUserId -- ObjectLink_User_Member.ChildObjectId

          LEFT JOIN tmpChoiceCell ON tmpChoiceCell.GoodsId = Object_Goods.Id
                                 AND COALESCE (tmpChoiceCell.GoodsKindId,0) = COALESCE (Object_GoodsKind.Id,0)
                                 AND tmpChoiceCell.Ord = 1

     WHERE MovementItem.Id = inMovementItemId
       AND MovementItem.DescId = zc_MI_Master()
       AND MovementItem.isErased = FALSE
       AND COALESCE (inMovementItemId, 0) <> 0
   UNION all
     SELECT inGoodsCode            AS GoodsCode
          , inGoodsName            AS GoodsName
          , inGoodsKindName        AS GoodsKindName 
          , inPartionGoodsDate :: TDateTime AS PartionGoodsDate
          , Object_PartionCell.ValueData       AS PartionCellName
          , Object_Member.ValueData ::TVarChar AS StoreKeeper
 
           --ячейка отбора
          , tmpChoiceCell.Code          ::Integer  AS ChoiceCellCode
          , tmpChoiceCell.Name          ::TVarChar AS ChoiceCellName
          , tmpChoiceCell.CellName_shot ::TVarChar AS ChoiceCellName_shot 
     FROM Object AS Object_PartionCell

        /*LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = vbUserId
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()*/
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = vbUserId -- ObjectLink_User_Member.ChildObjectId

         LEFT JOIN tmpChoiceCell ON tmpChoiceCell.GoodsName = inGoodsName
                                AND COALESCE (tmpChoiceCell.GoodsKindName,'') = COALESCE (inGoodsKindName,'')
                                AND tmpChoiceCell.Ord = 1
     WHERE Object_PartionCell.Id = inPartionCellId
       AND COALESCE (inMovementItemId, 0) = 0
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.07.24         *
 07.07.24         * 
*/

-- тест
--