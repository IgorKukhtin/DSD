 -- Function: gpSelect_MI_Send_PartionCell()

DROP FUNCTION IF EXISTS gpSelect_MI_Send_PartionCell (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Send_PartionCell(
    IN inMovementId  Integer      , -- ���� ���������
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar 
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , PartionGoodsDate TDateTime
             , Amount TFloat
             , PartionCell_Amount_1  TFloat
             , PartionCell_Amount_2  TFloat
             , PartionCell_Amount_3  TFloat
             , PartionCell_Amount_4  TFloat
             , PartionCell_Amount_5  TFloat
             , PartionCell_Amount_6  TFloat
             , PartionCell_Amount_7  TFloat
             , PartionCell_Amount_8  TFloat
             , PartionCell_Amount_9  TFloat
             , PartionCell_Amount_10  TFloat
             , PartionCell_Amount_11  TFloat
             , PartionCell_Amount_12  TFloat 
             , PartionCell_Last      TFloat
            
             , isPartionCell_Close_1 Boolean
             , isPartionCell_Close_2 Boolean
             , isPartionCell_Close_3 Boolean
             , isPartionCell_Close_4 Boolean
             , isPartionCell_Close_5 Boolean
             , isPartionCell_Close_6  Boolean
             , isPartionCell_Close_7  Boolean
             , isPartionCell_Close_8  Boolean
             , isPartionCell_Close_9  Boolean
             , isPartionCell_Close_10 Boolean
             , isPartionCell_Close_11 Boolean
             , isPartionCell_Close_12 Boolean
              
             , PartionCellId_1     Integer
             , PartionCellCode_1   Integer
             , PartionCellName_1   TVarChar
  
             , PartionCellId_2     Integer 
             , PartionCellCode_2   Integer 
             , PartionCellName_2   TVarChar
  
             , PartionCellId_3     Integer 
             , PartionCellCode_3   Integer 
             , PartionCellName_3   TVarChar
  
             , PartionCellId_4     Integer 
             , PartionCellCode_4   Integer 
             , PartionCellName_4   TVarChar
  
             , PartionCellId_5     Integer 
             , PartionCellCode_5   Integer 
             , PartionCellName_5   TVarChar

             , PartionCellId_6     Integer 
             , PartionCellCode_6   Integer 
             , PartionCellName_6   TVarChar
             
             , PartionCellId_7     Integer 
             , PartionCellCode_7   Integer 
             , PartionCellName_7   TVarChar
             
             , PartionCellId_8     Integer 
             , PartionCellCode_8   Integer 
             , PartionCellName_8   TVarChar
             
             , PartionCellId_9     Integer 
             , PartionCellCode_9   Integer 
             , PartionCellName_9   TVarChar
             
             , PartionCellId_10     Integer 
             , PartionCellCode_10   Integer 
             , PartionCellName_10   TVarChar
             
             , PartionCellId_11     Integer 
             , PartionCellCode_11   Integer 
             , PartionCellName_11   TVarChar
             
             , PartionCellId_12     Integer 
             , PartionCellCode_12   Integer 
             , PartionCellName_12   TVarChar  
             
             , PartionCellName_real_1    TVarChar
             , PartionCellName_real_2    TVarChar
             , PartionCellName_real_3    TVarChar
             , PartionCellName_real_4    TVarChar
             , PartionCellName_real_5    TVarChar
             , PartionCellName_real_6    TVarChar
             , PartionCellName_real_7    TVarChar
             , PartionCellName_real_8    TVarChar
             , PartionCellName_real_9    TVarChar
             , PartionCellName_real_10   TVarChar
             , PartionCellName_real_11   TVarChar
             , PartionCellName_real_12   TVarChar
             
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Send());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �����
     RETURN QUERY
       SELECT
             MovementItem.Id                      AS Id
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName
           , Object_GoodsKind.Id                   AS GoodsKindId
           , Object_GoodsKind.ValueData            AS GoodsKindName
           , MIDate_PartionGoods.ValueData   :: TDateTime AS PartionGoodsDate
           , MovementItem.Amount                   AS Amount
           
           , MIFloat_PartionCell_Amount_1.ValueData  ::TFloat AS PartionCell_Amount_1
           , MIFloat_PartionCell_Amount_2.ValueData  ::TFloat AS PartionCell_Amount_2
           , MIFloat_PartionCell_Amount_3.ValueData  ::TFloat AS PartionCell_Amount_3
           , MIFloat_PartionCell_Amount_4.ValueData  ::TFloat AS PartionCell_Amount_4
           , MIFloat_PartionCell_Amount_5.ValueData  ::TFloat AS PartionCell_Amount_5
           , MIFloat_PartionCell_Amount_6.ValueData  ::TFloat AS PartionCell_Amount_6 
           , MIFloat_PartionCell_Amount_7.ValueData  ::TFloat AS PartionCell_Amount_7 
           , MIFloat_PartionCell_Amount_8.ValueData  ::TFloat AS PartionCell_Amount_8 
           , MIFloat_PartionCell_Amount_9.ValueData  ::TFloat AS PartionCell_Amount_9 
           , MIFloat_PartionCell_Amount_10.ValueData  ::TFloat AS PartionCell_Amount_10
           , MIFloat_PartionCell_Amount_11.ValueData  ::TFloat AS PartionCell_Amount_11
           , MIFloat_PartionCell_Amount_12.ValueData  ::TFloat AS PartionCell_Amount_12
           
           , MIFloat_PartionCell_Last.ValueData  ::TFloat AS PartionCell_Last
          
           , COALESCE (MIBoolean_PartionCell_Close_1.ValueData, FALSE) ::Boolean AS isPartionCell_Close_1
           , COALESCE (MIBoolean_PartionCell_Close_2.ValueData, FALSE) ::Boolean AS isPartionCell_Close_2
           , COALESCE (MIBoolean_PartionCell_Close_3.ValueData, FALSE) ::Boolean AS isPartionCell_Close_3
           , COALESCE (MIBoolean_PartionCell_Close_4.ValueData, FALSE) ::Boolean AS isPartionCell_Close_4
           , COALESCE (MIBoolean_PartionCell_Close_5.ValueData, FALSE) ::Boolean AS isPartionCell_Close_5
           , COALESCE (MIBoolean_PartionCell_Close_6.ValueData, FALSE) ::Boolean AS isPartionCell_Close_6 
           , COALESCE (MIBoolean_PartionCell_Close_7.ValueData, FALSE) ::Boolean AS isPartionCell_Close_7 
           , COALESCE (MIBoolean_PartionCell_Close_8.ValueData, FALSE) ::Boolean AS isPartionCell_Close_8 
           , COALESCE (MIBoolean_PartionCell_Close_9.ValueData, FALSE) ::Boolean AS isPartionCell_Close_9 
           , COALESCE (MIBoolean_PartionCell_Close_10.ValueData, FALSE) ::Boolean AS isPartionCell_Close_10
           , COALESCE (MIBoolean_PartionCell_Close_11.ValueData, FALSE) ::Boolean AS isPartionCell_Close_11
           , COALESCE (MIBoolean_PartionCell_Close_12.ValueData, FALSE) ::Boolean AS isPartionCell_Close_12
            
           , Object_PartionCell_1.Id            AS PartionCellId_1
           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , (Object_PartionCell_1.ObjectCode :: TVarChar || '-' || Object_PartionCell_1.ValueData ):: TVarChar        AS PartionCellName_1

           , Object_PartionCell_2.Id            AS PartionCellId_2
           , Object_PartionCell_2.ObjectCode    AS PartionCellCode_2
           , (Object_PartionCell_2.ObjectCode :: TVarChar || '-'  || Object_PartionCell_2.ValueData ):: TVarChar        AS PartionCellName_2

           , Object_PartionCell_3.Id            AS PartionCellId_3
           , Object_PartionCell_3.ObjectCode    AS PartionCellCode_3
           , (Object_PartionCell_3.ObjectCode :: TVarChar || '-'  || Object_PartionCell_3.ValueData ):: TVarChar        AS PartionCellName_3

           , Object_PartionCell_4.Id            AS PartionCellId_4
           , Object_PartionCell_4.ObjectCode    AS PartionCellCode_4
           , (Object_PartionCell_4.ObjectCode :: TVarChar || '-'  || Object_PartionCell_4.ValueData ):: TVarChar     AS PartionCellName_4

           , Object_PartionCell_5.Id            AS PartionCellId_5
           , Object_PartionCell_5.ObjectCode    AS PartionCellCode_5
           , (Object_PartionCell_5.ObjectCode :: TVarChar || '-'  || Object_PartionCell_5.ValueData):: TVarChar        AS PartionCellName_5

           , Object_PartionCell_6.Id            AS PartionCellId_6
           , Object_PartionCell_6.ObjectCode    AS PartionCellCode_6
           , (Object_PartionCell_6.ObjectCode :: TVarChar || '-'  || Object_PartionCell_6.ValueData):: TVarChar        AS PartionCellName_6

           , Object_PartionCell_7.Id            AS PartionCellId_7
           , Object_PartionCell_7.ObjectCode    AS PartionCellCode_7
           , (Object_PartionCell_7.ObjectCode :: TVarChar || '-'  || Object_PartionCell_7.ValueData):: TVarChar        AS PartionCellName_7

           , Object_PartionCell_8.Id            AS PartionCellId_8
           , Object_PartionCell_8.ObjectCode    AS PartionCellCode_8
           , (Object_PartionCell_8.ObjectCode :: TVarChar || '-'  || Object_PartionCell_8.ValueData):: TVarChar        AS PartionCellName_8

           , Object_PartionCell_9.Id            AS PartionCellId_9
           , Object_PartionCell_9.ObjectCode    AS PartionCellCode_9
           , (Object_PartionCell_9.ObjectCode :: TVarChar || '-'  || Object_PartionCell_9.ValueData):: TVarChar        AS PartionCellName_9

           , Object_PartionCell_10.Id            AS PartionCellId_10
           , Object_PartionCell_10.ObjectCode    AS PartionCellCode_10
           , (Object_PartionCell_10.ObjectCode :: TVarChar || '-'  || Object_PartionCell_10.ValueData):: TVarChar        AS PartionCellName_10

           , Object_PartionCell_11.Id            AS PartionCellId_11
           , Object_PartionCell_11.ObjectCode    AS PartionCellCode_11
           , (Object_PartionCell_11.ObjectCode :: TVarChar || '-'  || Object_PartionCell_11.ValueData):: TVarChar        AS PartionCellName_11

           , Object_PartionCell_12.Id            AS PartionCellId_12
           , Object_PartionCell_12.ObjectCode    AS PartionCellCode_12
           , (Object_PartionCell_12.ObjectCode :: TVarChar || '-'  || Object_PartionCell_12.ValueData):: TVarChar        AS PartionCellName_12

           , (Object_PartionCell_real_1.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_1.ValueData):: TVarChar AS PartionCellName_real_1 
           , (Object_PartionCell_real_2.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_2.ValueData):: TVarChar AS PartionCellName_real_2 
           , (Object_PartionCell_real_3.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_3.ValueData):: TVarChar AS PartionCellName_real_3 
           , (Object_PartionCell_real_4.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_4.ValueData):: TVarChar AS PartionCellName_real_4 
           , (Object_PartionCell_real_5.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_5.ValueData):: TVarChar AS PartionCellName_real_5 
           , (Object_PartionCell_real_6.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_6.ValueData):: TVarChar AS PartionCellName_real_6 
           , (Object_PartionCell_real_7.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_7.ValueData):: TVarChar AS PartionCellName_real_7 
           , (Object_PartionCell_real_8.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_8.ValueData):: TVarChar AS PartionCellName_real_8 
           , (Object_PartionCell_real_9.ObjectCode :: TVarChar || '-'  || Object_PartionCell_real_9.ValueData):: TVarChar AS PartionCellName_real_9 
           , (Object_PartionCell_real_10.ObjectCode :: TVarChar|| '-'  || Object_PartionCell_real_10.ValueData)::TVarChar AS PartionCellName_real_10
           , (Object_PartionCell_real_11.ObjectCode :: TVarChar|| '-'  || Object_PartionCell_real_11.ValueData)::TVarChar AS PartionCellName_real_11
           , (Object_PartionCell_real_12.ObjectCode :: TVarChar|| '-'  || Object_PartionCell_real_12.ValueData)::TVarChar AS PartionCellName_real_12
                      
           , MovementItem.isErased                 AS isErased
           
       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_1
                                             ON MILinkObject_PartionCell_1.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_1.DescId = zc_MILinkObject_PartionCell_1()
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = MILinkObject_PartionCell_1.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_2
                                             ON MILinkObject_PartionCell_2.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_2.DescId = zc_MILinkObject_PartionCell_2()
            LEFT JOIN Object AS Object_PartionCell_2 ON Object_PartionCell_2.Id = MILinkObject_PartionCell_2.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_3
                                             ON MILinkObject_PartionCell_3.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_3.DescId = zc_MILinkObject_PartionCell_3()
            LEFT JOIN Object AS Object_PartionCell_3 ON Object_PartionCell_3.Id = MILinkObject_PartionCell_3.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_4
                                             ON MILinkObject_PartionCell_4.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_4.DescId = zc_MILinkObject_PartionCell_4()
            LEFT JOIN Object AS Object_PartionCell_4 ON Object_PartionCell_4.Id = MILinkObject_PartionCell_4.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_5
                                             ON MILinkObject_PartionCell_5.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_5.DescId = zc_MILinkObject_PartionCell_5()
            LEFT JOIN Object AS Object_PartionCell_5 ON Object_PartionCell_5.Id = MILinkObject_PartionCell_5.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_6
                                             ON MILinkObject_PartionCell_6.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_6.DescId = zc_MILinkObject_PartionCell_6()
            LEFT JOIN Object AS Object_PartionCell_6 ON Object_PartionCell_6.Id = MILinkObject_PartionCell_6.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_7
                                             ON MILinkObject_PartionCell_7.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_7.DescId = zc_MILinkObject_PartionCell_7()
            LEFT JOIN Object AS Object_PartionCell_7 ON Object_PartionCell_7.Id = MILinkObject_PartionCell_7.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_8
                                             ON MILinkObject_PartionCell_8.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_8.DescId = zc_MILinkObject_PartionCell_8()
            LEFT JOIN Object AS Object_PartionCell_8 ON Object_PartionCell_8.Id = MILinkObject_PartionCell_8.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_9
                                             ON MILinkObject_PartionCell_9.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_9.DescId = zc_MILinkObject_PartionCell_9()
            LEFT JOIN Object AS Object_PartionCell_9 ON Object_PartionCell_9.Id = MILinkObject_PartionCell_9.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_10
                                             ON MILinkObject_PartionCell_10.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_10.DescId = zc_MILinkObject_PartionCell_10()
            LEFT JOIN Object AS Object_PartionCell_10 ON Object_PartionCell_10.Id = MILinkObject_PartionCell_10.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_11
                                             ON MILinkObject_PartionCell_11.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_11.DescId = zc_MILinkObject_PartionCell_11()
            LEFT JOIN Object AS Object_PartionCell_11 ON Object_PartionCell_11.Id = MILinkObject_PartionCell_11.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_12
                                             ON MILinkObject_PartionCell_12.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_12.DescId = zc_MILinkObject_PartionCell_12()
            LEFT JOIN Object AS Object_PartionCell_12 ON Object_PartionCell_12.Id = MILinkObject_PartionCell_12.ObjectId

  ---
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_1
                                             ON MILinkObject_PartionCell_real_1.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_1.DescId = zc_MILinkObject_PartionCell_real_1()
            LEFT JOIN Object AS Object_PartionCell_real_1 ON Object_PartionCell_real_1.Id = MILinkObject_PartionCell_real_1.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_2
                                             ON MILinkObject_PartionCell_real_2.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_2.DescId = zc_MILinkObject_PartionCell_real_2()
            LEFT JOIN Object AS Object_PartionCell_real_2 ON Object_PartionCell_real_2.Id = MILinkObject_PartionCell_real_2.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_3
                                             ON MILinkObject_PartionCell_real_3.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_3.DescId = zc_MILinkObject_PartionCell_real_3()
            LEFT JOIN Object AS Object_PartionCell_real_3 ON Object_PartionCell_real_3.Id = MILinkObject_PartionCell_real_3.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_4
                                             ON MILinkObject_PartionCell_real_4.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_4.DescId = zc_MILinkObject_PartionCell_real_4()
            LEFT JOIN Object AS Object_PartionCell_real_4 ON Object_PartionCell_real_4.Id = MILinkObject_PartionCell_real_4.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_5
                                             ON MILinkObject_PartionCell_real_5.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_5.DescId = zc_MILinkObject_PartionCell_real_5()
            LEFT JOIN Object AS Object_PartionCell_real_5 ON Object_PartionCell_real_5.Id = MILinkObject_PartionCell_real_5.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_6
                                             ON MILinkObject_PartionCell_real_6.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_6.DescId = zc_MILinkObject_PartionCell_real_6()
            LEFT JOIN Object AS Object_PartionCell_real_6 ON Object_PartionCell_real_6.Id = MILinkObject_PartionCell_real_6.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_7
                                             ON MILinkObject_PartionCell_real_7.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_7.DescId = zc_MILinkObject_PartionCell_real_7()
            LEFT JOIN Object AS Object_PartionCell_real_7 ON Object_PartionCell_real_7.Id = MILinkObject_PartionCell_real_7.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_8
                                             ON MILinkObject_PartionCell_real_8.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_8.DescId = zc_MILinkObject_PartionCell_real_8()
            LEFT JOIN Object AS Object_PartionCell_real_8 ON Object_PartionCell_real_8.Id = MILinkObject_PartionCell_real_8.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_9
                                             ON MILinkObject_PartionCell_real_9.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_9.DescId = zc_MILinkObject_PartionCell_real_9()
            LEFT JOIN Object AS Object_PartionCell_real_9 ON Object_PartionCell_real_9.Id = MILinkObject_PartionCell_real_9.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_10
                                             ON MILinkObject_PartionCell_real_10.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_10.DescId = zc_MILinkObject_PartionCell_real_10()
            LEFT JOIN Object AS Object_PartionCell_real_10 ON Object_PartionCell_real_10.Id = MILinkObject_PartionCell_real_10.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_11
                                             ON MILinkObject_PartionCell_real_11.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_11.DescId = zc_MILinkObject_PartionCell_real_11()
            LEFT JOIN Object AS Object_PartionCell_real_11 ON Object_PartionCell_real_11.Id = MILinkObject_PartionCell_real_11.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_real_12
                                             ON MILinkObject_PartionCell_real_12.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_real_12.DescId = zc_MILinkObject_PartionCell_real_12()
            LEFT JOIN Object AS Object_PartionCell_real_12 ON Object_PartionCell_real_12.Id = MILinkObject_PartionCell_real_12.ObjectId
  ---
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_1
                                        ON MIFloat_PartionCell_Amount_1.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_1.DescId         = zc_MIFloat_PartionCell_Amount_1()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_2
                                        ON MIFloat_PartionCell_Amount_2.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_2.DescId         = zc_MIFloat_PartionCell_Amount_2()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_3
                                        ON MIFloat_PartionCell_Amount_3.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_3.DescId         = zc_MIFloat_PartionCell_Amount_3()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_4
                                        ON MIFloat_PartionCell_Amount_4.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_4.DescId         = zc_MIFloat_PartionCell_Amount_4()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_5
                                        ON MIFloat_PartionCell_Amount_5.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_5.DescId         = zc_MIFloat_PartionCell_Amount_5()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_6
                                        ON MIFloat_PartionCell_Amount_6.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_6.DescId         = zc_MIFloat_PartionCell_Amount_6()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_7
                                        ON MIFloat_PartionCell_Amount_7.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_7.DescId         = zc_MIFloat_PartionCell_Amount_7()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_8
                                        ON MIFloat_PartionCell_Amount_8.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_8.DescId         = zc_MIFloat_PartionCell_Amount_8()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_9
                                        ON MIFloat_PartionCell_Amount_9.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_9.DescId         = zc_MIFloat_PartionCell_Amount_9()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_10
                                        ON MIFloat_PartionCell_Amount_10.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_10.DescId         = zc_MIFloat_PartionCell_Amount_10()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_11
                                        ON MIFloat_PartionCell_Amount_11.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_11.DescId         = zc_MIFloat_PartionCell_Amount_11()
            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Amount_12
                                        ON MIFloat_PartionCell_Amount_12.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Amount_12.DescId         = zc_MIFloat_PartionCell_Amount_12()

            LEFT JOIN MovementItemFloat AS MIFloat_PartionCell_Last
                                        ON MIFloat_PartionCell_Last.MovementItemId = MovementItem.Id
                                       AND MIFloat_PartionCell_Last.DescId         = zc_MIFloat_PartionCell_Last()
                                                  
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_1
                                          ON MIBoolean_PartionCell_Close_1.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_1.DescId = zc_MIBoolean_PartionCell_Close_1()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_2
                                          ON MIBoolean_PartionCell_Close_2.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_2.DescId = zc_MIBoolean_PartionCell_Close_2()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_3
                                          ON MIBoolean_PartionCell_Close_3.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_3.DescId = zc_MIBoolean_PartionCell_Close_3()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_4
                                          ON MIBoolean_PartionCell_Close_4.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_4.DescId = zc_MIBoolean_PartionCell_Close_4()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_5
                                          ON MIBoolean_PartionCell_Close_5.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_5.DescId = zc_MIBoolean_PartionCell_Close_5()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_6
                                          ON MIBoolean_PartionCell_Close_6.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_6.DescId = zc_MIBoolean_PartionCell_Close_6()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_7
                                          ON MIBoolean_PartionCell_Close_7.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_7.DescId = zc_MIBoolean_PartionCell_Close_7()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_8
                                          ON MIBoolean_PartionCell_Close_8.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_8.DescId = zc_MIBoolean_PartionCell_Close_8()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_9
                                          ON MIBoolean_PartionCell_Close_9.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_9.DescId = zc_MIBoolean_PartionCell_Close_9()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_10
                                          ON MIBoolean_PartionCell_Close_10.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_10.DescId = zc_MIBoolean_PartionCell_Close_10()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_11
                                          ON MIBoolean_PartionCell_Close_11.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_11.DescId = zc_MIBoolean_PartionCell_Close_11()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Close_12
                                          ON MIBoolean_PartionCell_Close_12.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Close_12.DescId = zc_MIBoolean_PartionCell_Close_12()
            
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.05.24         *
 28.12.23         *
*/

-- ����
-- SELECT * FROM gpSelect_MI_Send_PartionCell (inMovementId:= 25173, inIsErased:= FALSE, inSession:= '9818')
