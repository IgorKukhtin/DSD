-- Function: gpSelect_MovementItem_OrderGoods()

 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Integer, TDateTime, Boolean, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderGoods (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderGoods(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar
             , Amount TFloat       --��
             , AmountSecond TFloat --�����
             , Total_kg TFloat     -- ����� ���
             , Price TFloat, Summa TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbPriceWithVAT    Boolean;
  DECLARE vbPriceListId     Integer;
  DECLARE vbUnitId          Integer;
  DECLARE vbOperDate        TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������ ���������
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_PriceList.ObjectId, zc_PriceList_Basis()) AS PriceListId
          , MovementLinkObject_Unit.ObjectId AS UnitId
            INTO vbOperDate, vbPriceListId, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_OrderGoods();

     -- ���� � ���
     vbPriceWithVAT:= (SELECT MB.ValueData FROM ObjectBoolean AS MB WHERE MB.ObjectId = vbPriceListId AND MB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     
     -- ���������
     IF inShowAll THEN
     RETURN QUERY
       WITH 
       -- ���� �� ������
       tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                             , lfSelect.GoodsKindId AS GoodsKindId
                             , lfSelect.ValuePrice  AS Price_PriceList
                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect 
                       )
       -- ����������� ��� �� - ����� ������ ��������
     , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                    , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                               FROM ObjectBoolean AS ObjectBoolean_Order
                                    LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId

                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                         ON ObjectLink_Goods_InfoMoney.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                        AND vbUnitId = 8459 --"����� ����������"

                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                               WHERE ObjectBoolean_Order.ValueData = TRUE
                                 AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                 AND ( (vbUnitId = 8459 AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- ������� ���������
                                                                                                           , zc_Enum_InfoMoneyDestination_30200() -- �������
                                                                                                             ) 
                                        ) OR vbUnitId <> 8459)
                              )

       -- ������������ MovementItem
     , tmpMI_G AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount     AS Amount
                        , MovementItem.isErased
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                        INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
                   )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                       FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                         AND MovementItemFloat.DescId IN (zc_MIFloat_Price(), zc_MIFloat_AmountSecond())
                      )
     , tmpMI_String AS (SELECT MovementItemString.*
                        FROM MovementItemString
                        WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                          AND MovementItemString.DescId IN (zc_MIString_Comment())
                       )

     , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                      , MovementItem.GoodsId                          AS GoodsId
                      , MovementItem.Amount                           AS Amount
                      , COALESCE (MIFloat_AmountSecond.ValueData, 0)  AS AmountSecond
                      , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                      , MIString_Comment.ValueData        :: TVarChar AS Comment
                      , MovementItem.isErased
                 FROM tmpMI_G AS MovementItem

                      LEFT JOIN tmpMI_Float AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                      LEFT JOIN tmpMI_Float AS MIFloat_AmountSecond
                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                      LEFT JOIN tmpMI_String AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                 )

       SELECT
             0 :: Integer               AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Measure.ValueData           AS MeasureName
           , 0 :: TFloat AS Amount
           , 0 :: TFloat AS AmountSecond
           , 0 :: TFloat AS Total_kg
           , COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist) :: TFloat AS Price
           , 0 :: TFloat AS Summa
           , '' :: TVarChar AS Comment

           , '' ::TVarChar       AS InsertName
           , '' ::TVarChar       AS UpdateName
           , CURRENT_TIMESTAMP ::TDateTime AS InsertDate
           , NULL ::TDateTime    AS UpdateDate

           , FALSE AS isErased
       FROM tmpGoodsByGoodsKind AS tmpGoods

            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           --AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId

            -- ����������� 2 ���� �� ���� ������ � ���
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId                   = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Measure.ValueData           AS MeasureName

           , tmpMI.Amount            :: TFloat  AS Amount
           , tmpMI.AmountSecond      :: TFloat  AS AmountSecond

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN tmpMI.AmountSecond * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE tmpMI.Amount
             END                      ::TFloat   AS Total_kg
             
           , tmpMI.Price  ::TFloat   AS Price
           , (COALESCE (tmpMI.Amount,0) * tmpMI.Price) ::TFloat AS Summa

           , tmpMI.Comment  :: TVarChar AS Comment

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
          LEFT JOIN MovementItemDate AS MIDate_Update
                                     ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                    AND MIDate_Update.DescId = zc_MIDate_Update()

          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                           ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_Update
                                           ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                          AND MILO_Update.DescId = zc_MILinkObject_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
    ;
     ELSE

     -- ��������� ������
     RETURN QUERY

       WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                     )

        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Measure.ValueData           AS MeasureName

           , tmpMI.Amount                   :: TFloat AS Amount
           , MIFloat_AmountSecond.ValueData :: TFloat AS AmountSecond

           , CASE WHEN Object_Measure.Id = zc_Measure_Sh() 
                  THEN MIFloat_AmountSecond.ValueData * COALESCE (ObjectFloat_Weight.ValueData,1)
                  ELSE tmpMI.Amount
             END                      ::TFloat   AS Total_kg
             
           , MIFloat_Price.ValueData  ::TFloat   AS Price
           , CASE WHEN  Object_Measure.Id = zc_Measure_Sh()
                    THEN COALESCE( MIFloat_AmountSecond.ValueData,0) * MIFloat_Price.ValueData
                  ELSE COALESCE (tmpMI.Amount,0) * MIFloat_Price.ValueData
             END ::TFloat AS Summa
           , MIString_Comment.ValueData :: TVarChar AS Comment

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = tmpMI.MovementItemId
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

           LEFT JOIN MovementItemString AS MIString_Comment
                                        ON MIString_Comment.MovementItemId = tmpMI.MovementItemId
                                       AND MIString_Comment.DescId = zc_MIString_Comment()

           LEFT JOIN MovementItemDate AS MIDate_Insert
                                      ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                     AND MIDate_Insert.DescId = zc_MIDate_Insert()
           LEFT JOIN MovementItemDate AS MIDate_Update
                                      ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                     AND MIDate_Update.DescId = zc_MIDate_Update()

           LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                            ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                           AND MILO_Insert.DescId = zc_MILinkObject_Insert()
           LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

           LEFT JOIN MovementItemLinkObject AS MILO_Update
                                            ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                           AND MILO_Update.DescId = zc_MILinkObject_Update()
           LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
           ;

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.06.21         *
 08.06.21         *
*/

-- ����
-- select * from gpSelect_MovementItem_OrderGoods(inMovementId := 18298048 , inShowAll:= False, inIsErased := 'False' ,  inSession := '5')