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
             , GoodsId_detail Integer, GoodsCode_detail Integer, GoodsName_detail TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , GoodsKindId_detail Integer, GoodsKindName_detail TVarChar
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
     tmpMI_master AS (SELECT MovementItem.Id                     AS MovementItemId
                           , MovementItem.ObjectId               AS GoodsId_detail
                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId_detail

                           , COALESCE (MILinkObject_Goods.ObjectId
                                     , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                 THEN MovementItem.ObjectId
                                            ELSE 0
                                       END
                                      )AS GoodsId
                           , COALESCE (MILinkObject_GoodsBasis.ObjectId, 0)        AS GoodsId_basis
                           , COALESCE (MILinkObject_GoodsKindComplete.ObjectId
                                     , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId NOT IN (zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201())
                                                 THEN zc_GoodsKind_Basis()
                                            ELSE 0
                                      END
                                      ) AS GoodsKindId_complete
                      FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = tmpIsErased.isErased
                           LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                ON ObjectLink_Goods_InfoMoney.ObjectId = MovementItem.ObjectId
                                               AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
--                                                       AND  = Object_InfoMoney_View.InfoMoneyId

                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                            ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsBasis.DescId = zc_MILinkObject_GoodsBasis()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                            ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                            ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                            ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
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
           , Object_Goods_detail.Id                      AS GoodsId_detail
           , Object_Goods_detail.ObjectCode              AS GoodsCode_detail
           , Object_Goods_detail.ValueData               AS GoodsName_detail
           --, ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_GoodsKind_detail.Id                  AS GoodsKindId_detail
           , Object_GoodsKind_detail.ValueData           AS GoodsKindName_detail
           
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

           , Object_Insert.ValueData AS InsertName
           , Object_Update.ValueData AS UpdateName
           , MI_Detail.InsertDate
           , MI_Detail.UpdateDate

           , MI_Detail.isErased

       FROM tmpMI_detail AS MI_Detail
            LEFT JOIN tmpMI_master AS MI_Master ON MI_Master.MovementItemId = MI_Detail.ParentId

            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MI_Detail.Insertd
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MI_Detail.UpdateId
            
            LEFT JOIN Object AS Object_Goods_detail ON Object_Goods_detail.Id = MI_Master.GoodsId_detail
            LEFT JOIN Object AS Object_GoodsKind_detail ON Object_GoodsKind_detail.Id = MI_Master.GoodsKindId_detail
            LEFT JOIN Object AS Object_Goods_basis ON Object_Goods_basis.Id = MI_Master.GoodsId_basis
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_Master.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = GoodsKindId_complete
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
-- select * from gpSelect_MI_OrderInternal_Detail(inMovementId := 24884712 , inIsErased := 'False' ,  inSession := '9457');