-- Function: gpSelect_MI_OrderInternal_Detail()

DROP FUNCTION IF EXISTS gpSelect_MI_OrderInternal_Detail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_OrderInternal_Detail(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsId_basis Integer, GoodsCode_basis Integer, GoodsName_basis TVarChar
             , GoodsId_complete Integer, GoodsCode_complete Integer, GoodsName_complete TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsKindId_complete Integer, GoodsKindName_complete TVarChar

             , Amount                    TFloat
             , AmountPack                TFloat
             , AmountPackSecond          TFloat
             , AmountPack_calc           TFloat
             , AmountPackSecond_calc     TFloat
             , AmountPackNext            TFloat
             , AmountPackNextSecond      TFloat
             , AmountPackNext_calc       TFloat
             , AmountPackNextSecond_calc TFloat
             , isCalculated              Boolean     

             , AmountPack_diff                TFloat
             , AmountPackSecond_diff          TFloat
             , AmountPack_calc_diff           TFloat
             , AmountPackSecond_calc_diff     TFloat
             , AmountPackNext_diff            TFloat
             , AmountPackNextSecond_diff      TFloat
             , AmountPackNext_calc_diff       TFloat
             , AmountPackNextSecond_calc_diff TFloat
             
             , NormInDays TFloat

             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
     tmpMI_master AS (SELECT MovementItem.Id                                       AS MovementItemId
                           , COALESCE (MIFloat_ContainerId.ValueData, 0)           AS ContainerId

                           , MovementItem.ObjectId                                 AS GoodsId
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)         AS GoodsKindId
                           
                           , COALESCE (MILinkObject_GoodsComplete.ObjectId, 0)     AS GoodsId_complete
                           , COALESCE (MILinkObject_GoodsKindComplete.ObjectId, 0) AS GoodsKindId_complete

                           , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis

                           /*, vbOperDate - (COALESCE (MIFloat_TermProduction.ValueData, 0) :: INteger :: TVarChar || ' DAY') :: INTERVAL AS PartionGoods_start
                           , ObjectDate_Value.ValueData                      AS PartionDate_pf
                           , CLO_GoodsKind.ObjectId                          AS GoodsKindId_pf
                           , CASE WHEN MIFloat_ContainerId.ValueData > 0 THEN COALESCE (ObjectLink_GoodsKindComplete.ChildObjectId, zc_GoodsKind_Basis()) END AS GoodsKindCompleteId_pf
                           , CLO_Unit.ObjectId                               AS UnitId_pf
                           */
                           , MovementItem.isErased                                 AS isErased

                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = tmpIsErased.isErased

                            LEFT JOIN MovementItemFloat AS MIFloat_ContainerId
                                                        ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ContainerId.DescId = zc_MIFloat_ContainerId()
                            --
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                             ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsComplete
                                                             ON MILinkObject_GoodsComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsComplete.DescId         = zc_MILinkObject_Goods()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                             ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKindComplete.DescId         = zc_MILinkObject_GoodsKindComplete()
                            --
                            /*LEFT JOIN ContainerLinkObject AS CLO_Unit
                                                          ON CLO_Unit.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_Unit.DescId      = zc_ContainerLinkObject_Unit()
                            LEFT JOIN ContainerLinkObject AS CLO_GoodsKind
                                                          ON CLO_GoodsKind.ContainerId = MIFloat_ContainerId.ValueData :: Integer
                                                         AND CLO_GoodsKind.DescId      = zc_ContainerLinkObject_GoodsKind()
                            
                            LEFT JOIN ObjectLink AS ObjectLink_GoodsKindComplete
                                                 ON ObjectLink_GoodsKindComplete.ObjectId = CLO_PartionGoods.ObjectId
                                                AND ObjectLink_GoodsKindComplete.DescId   = zc_ObjectLink_PartionGoods_GoodsKindComplete() 
                            */
                      )
                           

     --
   , tmpMI_detail AS (SELECT MovementItem.Id                   AS MovementItemId
                           , MovementItem.ParentId             AS ParentId
                           , MovementItem.ObjectId             AS Insertd
                           , MILO_Update.ObjectId              AS UpdateId
                           , MIDate_Insert.ValueData           AS InsertDate
                           , MIDate_Update.ValueData           AS UpdateDate
                           , MovementItem.Amount               AS Amount
                           , COALESCE (MIBoolean_Calculated.ValueData, FALSE) ::Boolean AS isCalculated
                           
                           , MIFloat_AmountPack.ValueData                AS AmountPack
                           , MIFloat_AmountPackSecond.ValueData          AS AmountPackSecond
                           , MIFloat_AmountPack_calc.ValueData           AS AmountPack_calc
                           , MIFloat_AmountPackSecond_calc.ValueData     AS AmountPackSecond_calc
                           , MIFloat_AmountPackNext.ValueData            AS AmountPackNext
                           , MIFloat_AmountPackNextSecond.ValueData      AS AmountPackNextSecond
                           , MIFloat_AmountPackNext_calc.ValueData       AS AmountPackNext_calc
                           , MIFloat_AmountPackNextSecond_calc.ValueData AS AmountPackNextSecond_calc
                           , MovementItem.isErased             AS isErased

                             -- № п/п
                           , ROW_NUMBER() OVER (PARTITION BY MovementItem.ParentId ORDER BY MovementItem.Id ASC) AS Ord

                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Detail()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                           
                           LEFT JOIN MovementItemBoolean AS MIBoolean_Calculated
                                                         ON MIBoolean_Calculated.MovementItemId = MovementItem.Id
                                                        AND MIBoolean_Calculated.DescId = zc_MIBoolean_Calculated()

                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPack
                                                       ON MIFloat_AmountPack.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPack.DescId = zc_MIFloat_AmountPack()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond
                                                       ON MIFloat_AmountPackSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackSecond.DescId = zc_MIFloat_AmountPackSecond()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPack_calc
                                                       ON MIFloat_AmountPack_calc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPack_calc.DescId = zc_MIFloat_AmountPack_calc()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackSecond_calc
                                                       ON MIFloat_AmountPackSecond_calc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackSecond_calc.DescId = zc_MIFloat_AmountPackSecond_calc()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext
                                                       ON MIFloat_AmountPackNext.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNext.DescId = zc_MIFloat_AmountPackNext()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond
                                                       ON MIFloat_AmountPackNextSecond.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNextSecond.DescId = zc_MIFloat_AmountPackNextSecond()                                                      
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNext_calc
                                                       ON MIFloat_AmountPackNext_calc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNext_calc.DescId = zc_MIFloat_AmountPackNext_calc()
                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPackNextSecond_calc
                                                       ON MIFloat_AmountPackNextSecond_calc.MovementItemId = MovementItem.Id
                                                      AND MIFloat_AmountPackNextSecond_calc.DescId = zc_MIFloat_AmountPackNextSecond_calc()

                           LEFT JOIN MovementItemDate AS MIDate_Insert
                                                      ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
                           LEFT JOIN MovementItemDate AS MIDate_Update
                                                      ON MIDate_Update.MovementItemId = MovementItem.Id
                                                     AND MIDate_Update.DescId = zc_MIDate_Update()
                           LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                            ON MILO_Update.MovementItemId = MovementItem.Id
                                                           AND MILO_Update.DescId = zc_MILinkObject_Update()

                      )


   , tmpGoodsByGoodsKind AS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId         AS GoodsId
                                  , ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId     AS GoodsKindId
                                  , COALESCE (ObjectFloat_NormInDays.ValueData,0) ::TFloat  AS NormInDays
                             FROM Object AS Object_GoodsByGoodsKind
                                  INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                        ON ObjectLink_GoodsByGoodsKind_Goods.ObjectId          = Object_GoodsByGoodsKind.Id
                                                       AND ObjectLink_GoodsByGoodsKind_Goods.DescId            = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = Object_GoodsByGoodsKind.Id
                                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()

                                  INNER JOIN ObjectFloat AS ObjectFloat_NormInDays
                                                         ON ObjectFloat_NormInDays.ObjectId = Object_GoodsByGoodsKind.Id
                                                        AND ObjectFloat_NormInDays.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormInDays() 
                                                        AND COALESCE (ObjectFloat_NormInDays.ValueData,0) <> 0
                             WHERE Object_GoodsByGoodsKind.DescId   = zc_Object_GoodsByGoodsKind()
                               AND Object_GoodsByGoodsKind.isErased = FALSE
                              )

       ------
       SELECT
             MI_Detail.MovementItemId                    AS Id
           , MI_Detail.ParentId                          AS ParentId
           , Object_Goods.Id                             AS GoodsId
           , Object_Goods.ObjectCode                     AS GoodsCode
           , Object_Goods.ValueData                      AS GoodsName
           , Object_Goods_basis.Id                       AS GoodsId_basis
           , Object_Goods_basis.ObjectCode               AS GoodsCode_basis
           , Object_Goods_basis.ValueData                AS GoodsName_basis
           , Object_Goods_complete.Id                    AS GoodsId_complete
           , Object_Goods_complete.ObjectCode            AS GoodsCode_complete
           , Object_Goods_complete.ValueData             AS GoodsName_complete
           --, ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_GoodsKind_complete.Id                AS GoodsKindId_complete
           , Object_GoodsKind_complete.ValueData         AS GoodsKindName_complete
         
           , MI_Detail.Amount                    ::TFloat AS Amount
                           
           , MI_Detail.AmountPack                ::TFloat AS AmountPack
           , MI_Detail.AmountPackSecond          ::TFloat AS AmountPackSecond
           , MI_Detail.AmountPack_calc           ::TFloat AS AmountPack_calc
           , MI_Detail.AmountPackSecond_calc     ::TFloat AS AmountPackSecond_calc
           , MI_Detail.AmountPackNext            ::TFloat AS AmountPackNext
           , MI_Detail.AmountPackNextSecond      ::TFloat AS AmountPackNextSecond
           , MI_Detail.AmountPackNext_calc       ::TFloat AS AmountPackNext_calc
           , MI_Detail.AmountPackNextSecond_calc ::TFloat AS AmountPackNextSecond_calc
           , MI_Detail.isCalculated             ::Boolean AS isCalculated           

           , (COALESCE (MI_Detail.AmountPack, 0)                - COALESCE (tmpMI_detail_old.AmountPack,                MI_Detail.AmountPack, 0))                ::TFloat AS AmountPack_diff
           , (COALESCE (MI_Detail.AmountPackSecond, 0)          - COALESCE (tmpMI_detail_old.AmountPackSecond,          MI_Detail.AmountPackSecond, 0))          ::TFloat AS AmountPackSecond_diff
           , (COALESCE (MI_Detail.AmountPack_calc, 0)           - COALESCE (tmpMI_detail_old.AmountPack_calc,           MI_Detail.AmountPack_calc, 0))           ::TFloat AS AmountPack_calc_diff
           , (COALESCE (MI_Detail.AmountPackSecond_calc, 0)     - COALESCE (tmpMI_detail_old.AmountPackSecond_calc,     MI_Detail.AmountPackSecond_calc, 0))     ::TFloat AS AmountPackSecond_calc_diff
           , (COALESCE (MI_Detail.AmountPackNext, 0)            - COALESCE (tmpMI_detail_old.AmountPackNext,            MI_Detail.AmountPackNext, 0))            ::TFloat AS AmountPackNext_diff
           , (COALESCE (MI_Detail.AmountPackNextSecond, 0)      - COALESCE (tmpMI_detail_old.AmountPackNextSecond,      MI_Detail.AmountPackNextSecond, 0))      ::TFloat AS AmountPackNextSecond_diff
           , (COALESCE (MI_Detail.AmountPackNext_calc, 0)       - COALESCE (tmpMI_detail_old.AmountPackNext_calc,       MI_Detail.AmountPackNext_calc, 0))       ::TFloat AS AmountPackNext_calc_diff
           , (COALESCE (MI_Detail.AmountPackNextSecond_calc, 0) - COALESCE (tmpMI_detail_old.AmountPackNextSecond_calc, MI_Detail.AmountPackNextSecond_calc, 0)) ::TFloat AS AmountPackNextSecond_calc_diff 
           
           , tmpGoodsByGoodsKind.NormInDays ::TFloat

           , Object_Insert.ValueData AS InsertName
           , Object_Update.ValueData AS UpdateName
           , MI_Detail.InsertDate
           , MI_Detail.UpdateDate

           , MI_Detail.isErased

       FROM tmpMI_detail AS MI_Detail
            LEFT JOIN tmpMI_master AS MI_Master ON MI_Master.MovementItemId = MI_Detail.ParentId

            LEFT JOIN tmpMI_detail AS tmpMI_detail_old ON tmpMI_detail_old.ParentId = MI_Detail.ParentId
                                                      AND tmpMI_detail_old.Amount   = MI_Detail.Amount - 1
            

            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MI_Detail.Insertd
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MI_Detail.UpdateId
            
            LEFT JOIN Object AS Object_Goods_complete ON Object_Goods_complete.Id = MI_Master.GoodsId_complete
            LEFT JOIN Object AS Object_GoodsKind_complete ON Object_GoodsKind_complete.Id = MI_Master.GoodsKindId_complete
            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = MI_Master.GoodsId_basis
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MI_Master.GoodsKindId  

            LEFT JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId = MI_Master.GoodsId
                                         AND tmpGoodsByGoodsKind.GoodsKindId = MI_Master.GoodsKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.23         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_OrderInternal_Detail(inMovementId := 24901327 , inIsErased := 'False' ,  inSession := '9457');
