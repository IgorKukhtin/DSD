-- Function: gpGet_MI_Send_PartionCell_isManyAll()

DROP FUNCTION IF EXISTS gpGet_MI_Send_PartionCell_isManyAll (Integer, Integer, Integer, Integer,Integer, TDateTime,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MI_Send_PartionCell_isManyAll(
    IN inMovementId            Integer,       -- ключ Документа
    IN inMovementItemId        Integer,       --
    IN inUnitId                Integer  , --
    IN inGoodsId               Integer  ,
    IN inGoodsKindId           Integer  ,
    IN inPartionGoodsDate      TDateTime, --
    IN inSession               TVarChar       -- сессия пользователя
)
RETURNS TABLE (PartionCellId_1     Integer
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
             , PartionCellId_13     Integer
             , PartionCellCode_13   Integer
             , PartionCellName_13   TVarChar
             , PartionCellId_14     Integer
             , PartionCellCode_14   Integer
             , PartionCellName_14   TVarChar
             , PartionCellId_15     Integer
             , PartionCellCode_15   Integer
             , PartionCellName_15   TVarChar
             , PartionCellId_16     Integer
             , PartionCellCode_16   Integer
             , PartionCellName_16   TVarChar
             , PartionCellId_17     Integer
             , PartionCellCode_17   Integer
             , PartionCellName_17   TVarChar
             , PartionCellId_18     Integer
             , PartionCellCode_18   Integer
             , PartionCellName_18   TVarChar
             , PartionCellId_19     Integer
             , PartionCellCode_19   Integer
             , PartionCellName_19   TVarChar
             , PartionCellId_20     Integer
             , PartionCellCode_20   Integer
             , PartionCellName_20   TVarChar
             , PartionCellId_21     Integer
             , PartionCellCode_21   Integer
             , PartionCellName_21   TVarChar
             , PartionCellId_22     Integer
             , PartionCellCode_22   Integer
             , PartionCellName_22   TVarChar
            
             , isMany_1  Boolean
             , isMany_2  Boolean
             , isMany_3  Boolean
             , isMany_4  Boolean
             , isMany_5  Boolean
             , isMany_6  Boolean
             , isMany_7  Boolean
             , isMany_8  Boolean
             , isMany_9  Boolean
             , isMany_10  Boolean
             , isMany_11  Boolean
             , isMany_12  Boolean
             , isMany_13  Boolean
             , isMany_14  Boolean
             , isMany_15  Boolean
             , isMany_16  Boolean
             , isMany_17  Boolean
             , isMany_18  Boolean
             , isMany_19  Boolean
             , isMany_20  Boolean
             , isMany_21  Boolean
             , isMany_22  Boolean
               )
AS
$BODY$
  DECLARE vbUserId Integer;
          vbIsWeighing Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inMovementItemId,0) <> 0
    THEN
     RETURN QUERY
     SELECT  Object_PartionCell_1.Id            AS PartionCellId_1
           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , (Object_PartionCell_1.ValueData ):: TVarChar AS PartionCellName_1

           , Object_PartionCell_2.Id            AS PartionCellId_2
           , Object_PartionCell_2.ObjectCode    AS PartionCellCode_2
           , (Object_PartionCell_2.ValueData ):: TVarChar AS PartionCellName_2

           , Object_PartionCell_3.Id            AS PartionCellId_3
           , Object_PartionCell_3.ObjectCode    AS PartionCellCode_3
           , (Object_PartionCell_3.ValueData ):: TVarChar AS PartionCellName_3

           , Object_PartionCell_4.Id            AS PartionCellId_4
           , Object_PartionCell_4.ObjectCode    AS PartionCellCode_4
           , (Object_PartionCell_4.ValueData ):: TVarChar AS PartionCellName_4

           , Object_PartionCell_5.Id            AS PartionCellId_5
           , Object_PartionCell_5.ObjectCode    AS PartionCellCode_5
           , (Object_PartionCell_5.ValueData):: TVarChar  AS PartionCellName_5

           , Object_PartionCell_6.Id            AS PartionCellId_6
           , Object_PartionCell_6.ObjectCode    AS PartionCellCode_6
           , (Object_PartionCell_6.ValueData):: TVarChar  AS PartionCellName_6

           , Object_PartionCell_7.Id            AS PartionCellId_7
           , Object_PartionCell_7.ObjectCode    AS PartionCellCode_7
           , (Object_PartionCell_7.ValueData):: TVarChar  AS PartionCellName_7

           , Object_PartionCell_8.Id            AS PartionCellId_8
           , Object_PartionCell_8.ObjectCode    AS PartionCellCode_8
           , (Object_PartionCell_8.ValueData):: TVarChar  AS PartionCellName_8

           , Object_PartionCell_9.Id            AS PartionCellId_9
           , Object_PartionCell_9.ObjectCode    AS PartionCellCode_9
           , (Object_PartionCell_9.ValueData):: TVarChar  AS PartionCellName_9

           , Object_PartionCell_10.Id            AS PartionCellId_10
           , Object_PartionCell_10.ObjectCode    AS PartionCellCode_10
           , (Object_PartionCell_10.ValueData):: TVarChar AS PartionCellName_10

           , Object_PartionCell_11.Id            AS PartionCellId_11
           , Object_PartionCell_11.ObjectCode    AS PartionCellCode_11
           , (Object_PartionCell_11.ValueData):: TVarChar AS PartionCellName_11

           , Object_PartionCell_12.Id            AS PartionCellId_12
           , Object_PartionCell_12.ObjectCode    AS PartionCellCode_12
           , (Object_PartionCell_12.ValueData):: TVarChar AS PartionCellName_12
           
           , Object_PartionCell_13.Id            AS PartionCellId_13
           , Object_PartionCell_13.ObjectCode    AS PartionCellCode_13
           , (Object_PartionCell_13.ValueData):: TVarChar AS PartionCellName_13
           , Object_PartionCell_14.Id            AS PartionCellId_14
           , Object_PartionCell_14.ObjectCode    AS PartionCellCode_14
           , (Object_PartionCell_14.ValueData):: TVarChar AS PartionCellName_14
           , Object_PartionCell_15.Id            AS PartionCellId_15
           , Object_PartionCell_15.ObjectCode    AS PartionCellCode_15
           , (Object_PartionCell_15.ValueData):: TVarChar AS PartionCellName_15
           , Object_PartionCell_16.Id            AS PartionCellId_16
           , Object_PartionCell_16.ObjectCode    AS PartionCellCode_16
           , (Object_PartionCell_16.ValueData):: TVarChar AS PartionCellName_16
           , Object_PartionCell_17.Id            AS PartionCellId_17
           , Object_PartionCell_17.ObjectCode    AS PartionCellCode_17                                                                           
           , (Object_PartionCell_17.ValueData):: TVarChar AS PartionCellName_17
           , Object_PartionCell_18.Id            AS PartionCellId_18
           , Object_PartionCell_18.ObjectCode    AS PartionCellCode_18
           , (Object_PartionCell_18.ValueData):: TVarChar AS PartionCellName_18
           , Object_PartionCell_19.Id            AS PartionCellId_19
           , Object_PartionCell_19.ObjectCode    AS PartionCellCode_19
           , (Object_PartionCell_19.ValueData):: TVarChar AS PartionCellName_19
           , Object_PartionCell_20.Id            AS PartionCellId_20
           , Object_PartionCell_20.ObjectCode    AS PartionCellCode_20
           , (Object_PartionCell_20.ValueData):: TVarChar AS PartionCellName_20
           , Object_PartionCell_21.Id            AS PartionCellId_21
           , Object_PartionCell_21.ObjectCode    AS PartionCellCode_21
           , (Object_PartionCell_21.ValueData):: TVarChar AS PartionCellName_21
           , Object_PartionCell_22.Id            AS PartionCellId_22
           , Object_PartionCell_22.ObjectCode    AS PartionCellCode_22
           , (Object_PartionCell_22.ValueData):: TVarChar AS PartionCellName_22

          
           , COALESCE (MIBoolean_PartionCell_Many_1.ValueData, FALSE) ::Boolean AS isMany_1
           , COALESCE (MIBoolean_PartionCell_Many_2.ValueData, FALSE) ::Boolean AS isMany_2
           , COALESCE (MIBoolean_PartionCell_Many_3.ValueData, FALSE) ::Boolean AS isMany_3
           , COALESCE (MIBoolean_PartionCell_Many_4.ValueData, FALSE) ::Boolean AS isMany_4
           , COALESCE (MIBoolean_PartionCell_Many_5.ValueData, FALSE) ::Boolean AS isMany_5
           , COALESCE (MIBoolean_PartionCell_Many_6.ValueData, FALSE) ::Boolean AS isMany_6 
           , COALESCE (MIBoolean_PartionCell_Many_7.ValueData, FALSE) ::Boolean AS isMany_7 
           , COALESCE (MIBoolean_PartionCell_Many_8.ValueData, FALSE) ::Boolean AS isMany_8 
           , COALESCE (MIBoolean_PartionCell_Many_9.ValueData, FALSE) ::Boolean AS isMany_9 
           , COALESCE (MIBoolean_PartionCell_Many_10.ValueData, FALSE) ::Boolean AS isMany_10
           , COALESCE (MIBoolean_PartionCell_Many_11.ValueData, FALSE) ::Boolean AS isMany_11
           , COALESCE (MIBoolean_PartionCell_Many_12.ValueData, FALSE) ::Boolean AS isMany_12
           , COALESCE (MIBoolean_PartionCell_Many_13.ValueData, FALSE) ::Boolean AS isMany_13
           , COALESCE (MIBoolean_PartionCell_Many_14.ValueData, FALSE) ::Boolean AS isMany_14
           , COALESCE (MIBoolean_PartionCell_Many_15.ValueData, FALSE) ::Boolean AS isMany_15
           , COALESCE (MIBoolean_PartionCell_Many_16.ValueData, FALSE) ::Boolean AS isMany_16
           , COALESCE (MIBoolean_PartionCell_Many_17.ValueData, FALSE) ::Boolean AS isMany_17
           , COALESCE (MIBoolean_PartionCell_Many_18.ValueData, FALSE) ::Boolean AS isMany_18
           , COALESCE (MIBoolean_PartionCell_Many_19.ValueData, FALSE) ::Boolean AS isMany_19
           , COALESCE (MIBoolean_PartionCell_Many_20.ValueData, FALSE) ::Boolean AS isMany_20
           , COALESCE (MIBoolean_PartionCell_Many_21.ValueData, FALSE) ::Boolean AS isMany_21
           , COALESCE (MIBoolean_PartionCell_Many_22.ValueData, FALSE) ::Boolean AS isMany_22
     FROM MovementItem
                                                  
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_1
                                          ON MIBoolean_PartionCell_Many_1.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_1.DescId = zc_MIBoolean_PartionCell_Many_1()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_2
                                          ON MIBoolean_PartionCell_Many_2.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_2.DescId = zc_MIBoolean_PartionCell_Many_2()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_3
                                          ON MIBoolean_PartionCell_Many_3.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_3.DescId = zc_MIBoolean_PartionCell_Many_3()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_4
                                          ON MIBoolean_PartionCell_Many_4.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_4.DescId = zc_MIBoolean_PartionCell_Many_4()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_5
                                          ON MIBoolean_PartionCell_Many_5.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_5.DescId = zc_MIBoolean_PartionCell_Close_5()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_6
                                          ON MIBoolean_PartionCell_Many_6.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_6.DescId = zc_MIBoolean_PartionCell_Many_6()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_7
                                          ON MIBoolean_PartionCell_Many_7.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_7.DescId = zc_MIBoolean_PartionCell_Many_7()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_8
                                          ON MIBoolean_PartionCell_Many_8.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_8.DescId = zc_MIBoolean_PartionCell_Many_8()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_9
                                          ON MIBoolean_PartionCell_Many_9.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_9.DescId = zc_MIBoolean_PartionCell_Many_9()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_10
                                          ON MIBoolean_PartionCell_Many_10.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_10.DescId = zc_MIBoolean_PartionCell_Many_10()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_11
                                          ON MIBoolean_PartionCell_Many_11.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_11.DescId = zc_MIBoolean_PartionCell_Many_11()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_12
                                          ON MIBoolean_PartionCell_Many_12.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_12.DescId = zc_MIBoolean_PartionCell_Many_12()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_13
                                          ON MIBoolean_PartionCell_Many_13.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_13.DescId = zc_MIBoolean_PartionCell_Many_13()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_14
                                          ON MIBoolean_PartionCell_Many_14.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_14.DescId = zc_MIBoolean_PartionCell_Many_14()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_15
                                          ON MIBoolean_PartionCell_Many_15.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_15.DescId = zc_MIBoolean_PartionCell_Many_15()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_16
                                          ON MIBoolean_PartionCell_Many_16.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_16.DescId = zc_MIBoolean_PartionCell_Many_16()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_17
                                          ON MIBoolean_PartionCell_Many_17.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_17.DescId = zc_MIBoolean_PartionCell_Many_17()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_18
                                          ON MIBoolean_PartionCell_Many_18.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_18.DescId = zc_MIBoolean_PartionCell_Many_18()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_19
                                          ON MIBoolean_PartionCell_Many_19.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_19.DescId = zc_MIBoolean_PartionCell_Many_19()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_20
                                          ON MIBoolean_PartionCell_Many_20.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_20.DescId = zc_MIBoolean_PartionCell_Many_20()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_21
                                          ON MIBoolean_PartionCell_Many_21.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_21.DescId = zc_MIBoolean_PartionCell_Many_21()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_22
                                          ON MIBoolean_PartionCell_Many_22.MovementItemId = MovementItem.Id
                                         AND MIBoolean_PartionCell_Many_22.DescId = zc_MIBoolean_PartionCell_Many_22()

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_13
                                             ON MILinkObject_PartionCell_13.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_13.DescId = zc_MILinkObject_PartionCell_13()
            LEFT JOIN Object AS Object_PartionCell_13 ON Object_PartionCell_13.Id = MILinkObject_PartionCell_13.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_14
                                             ON MILinkObject_PartionCell_14.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_14.DescId = zc_MILinkObject_PartionCell_14()
            LEFT JOIN Object AS Object_PartionCell_14 ON Object_PartionCell_14.Id = MILinkObject_PartionCell_14.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_15
                                             ON MILinkObject_PartionCell_15.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_15.DescId = zc_MILinkObject_PartionCell_15()
            LEFT JOIN Object AS Object_PartionCell_15 ON Object_PartionCell_15.Id = MILinkObject_PartionCell_15.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_16
                                             ON MILinkObject_PartionCell_16.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_16.DescId = zc_MILinkObject_PartionCell_16()
            LEFT JOIN Object AS Object_PartionCell_16 ON Object_PartionCell_16.Id = MILinkObject_PartionCell_16.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_17
                                             ON MILinkObject_PartionCell_17.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_17.DescId = zc_MILinkObject_PartionCell_17()
            LEFT JOIN Object AS Object_PartionCell_17 ON Object_PartionCell_17.Id = MILinkObject_PartionCell_17.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_18
                                             ON MILinkObject_PartionCell_18.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_18.DescId = zc_MILinkObject_PartionCell_18()
            LEFT JOIN Object AS Object_PartionCell_18 ON Object_PartionCell_18.Id = MILinkObject_PartionCell_18.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_19
                                             ON MILinkObject_PartionCell_19.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_19.DescId = zc_MILinkObject_PartionCell_19()
            LEFT JOIN Object AS Object_PartionCell_19 ON Object_PartionCell_19.Id = MILinkObject_PartionCell_19.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_20
                                             ON MILinkObject_PartionCell_20.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_20.DescId = zc_MILinkObject_PartionCell_20()
            LEFT JOIN Object AS Object_PartionCell_20 ON Object_PartionCell_20.Id = MILinkObject_PartionCell_20.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_21
                                             ON MILinkObject_PartionCell_21.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_21.DescId = zc_MILinkObject_PartionCell_21()
            LEFT JOIN Object AS Object_PartionCell_21 ON Object_PartionCell_21.Id = MILinkObject_PartionCell_21.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_22
                                             ON MILinkObject_PartionCell_22.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PartionCell_22.DescId = zc_MILinkObject_PartionCell_22()
            LEFT JOIN Object AS Object_PartionCell_22 ON Object_PartionCell_22.Id = MILinkObject_PartionCell_22.ObjectId


     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.Id = inMovementItemId
       AND MovementItem.DescId = zc_MI_Master();
    ELSE
         vbIsWeighing:= TRUE; -- inUserId = 5;

     -- !!!замена!!!
     IF COALESCE (inUnitId,0) = 0
     THEN
         inUnitId := zc_Unit_RK();
     END IF;


     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmpItem_PartionCell')
     THEN
         DELETE FROM _tmpItem_PartionCell;
     ELSE
         -- таблица - элементы
         CREATE TEMP TABLE _tmpItem_PartionCell (MovementId Integer, MovementItemId Integer, Amount TFloat, DescId_MILO Integer, PartionCellId Integer, isRePack Boolean) ON COMMIT DROP;
     END IF;


     INSERT INTO _tmpItem_PartionCell (MovementId, MovementItemId, Amount, DescId_MILO, PartionCellId, isRePack)
       WITH -- для Партия дата
            tmpMI_PartionDate AS (SELECT MovementItem.MovementId                  AS MovementId
                                       , MovementItem.Id                          AS MovementItemId
                                       , MovementItem.Amount                      AS Amount
                                         -- текущее значение
                                       , COALESCE (MILO_PartionCell.DescId, 0)    AS DescId_MILO
                                       , COALESCE (MILO_PartionCell.ObjectId, 0)  AS PartionCellId

                                  FROM MovementItemDate AS MIDate_PartionGoods
                                       INNER JOIN MovementItem ON MovementItem.Id       = MIDate_PartionGoods.MovementItemId
                                                              AND MovementItem.DescId   = zc_MI_Master()
                                                              AND MovementItem.isErased = FALSE
                                                              -- ограничили товаром
                                                              AND MovementItem.ObjectId = inGoodsId

                                       LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId

                                       LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                        ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                                       AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

                                       LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                                        ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                                       AND MILO_PartionCell.ObjectId       > 0
                                                                       AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                             , zc_MILinkObject_PartionCell_2()
                                                                                                             , zc_MILinkObject_PartionCell_3()
                                                                                                             , zc_MILinkObject_PartionCell_4()
                                                                                                             , zc_MILinkObject_PartionCell_5()
                                                                                                             , zc_MILinkObject_PartionCell_6()
                                                                                                             , zc_MILinkObject_PartionCell_7()
                                                                                                             , zc_MILinkObject_PartionCell_8()
                                                                                                             , zc_MILinkObject_PartionCell_9()
                                                                                                             , zc_MILinkObject_PartionCell_10()
                                                                                                             , zc_MILinkObject_PartionCell_11()
                                                                                                             , zc_MILinkObject_PartionCell_12()
                                                                                                             , zc_MILinkObject_PartionCell_13()
                                                                                                             , zc_MILinkObject_PartionCell_14()
                                                                                                             , zc_MILinkObject_PartionCell_15()
                                                                                                             , zc_MILinkObject_PartionCell_16()
                                                                                                             , zc_MILinkObject_PartionCell_17()
                                                                                                             , zc_MILinkObject_PartionCell_18()
                                                                                                             , zc_MILinkObject_PartionCell_19()
                                                                                                             , zc_MILinkObject_PartionCell_20()
                                                                                                             , zc_MILinkObject_PartionCell_21()
                                                                                                             , zc_MILinkObject_PartionCell_22()
                                                                                                              )
                                                                       -- !!!
                                                                       -- AND 1=0

                                  -- ограничили Партия дата, если установлена для MI
                                  WHERE MIDate_PartionGoods.ValueData = inPartionGoodsDate
                                    AND MIDate_PartionGoods.DescId    = zc_MIDate_PartionGoods()
                                    -- ограничили видом
                                    AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                                    -- Перемещение + Взвешивание
                                    AND ((Movement.DescId = zc_Movement_Send() AND Movement.StatusId = zc_Enum_Status_Complete())
                                      OR (Movement.DescId = zc_Movement_WeighingProduction() AND Movement.StatusId = zc_Enum_Status_UnComplete() AND vbIsWeighing = TRUE)
                                        )
                                 )

            -- или документы за период, дата документа = дата партии
          , tmpMovement AS (-- Перемещение
                            SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                            WHERE Movement.OperDate = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_Send()
                              AND Movement.StatusId = zc_Enum_Status_Complete()
 
                           UNION ALL
                            -- Взвешивание
                            SELECT Movement.*
                            FROM Movement
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement.Id
                                                              AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From.ObjectId   IN (zc_Unit_Pack(), zc_Unit_RK_Label())
                                 INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement.Id
                                                              AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId   = inUnitId
                                 LEFT JOIN MovementFloat AS MovementFloat_BranchCode
                                                         ON MovementFloat_BranchCode.MovementId = Movement.Id
                                                        AND MovementFloat_BranchCode.DescId     = zc_MovementFloat_BranchCode()
                                 LEFT JOIN MovementFloat AS MovementFloat_MovementDescNumber
                                                         ON MovementFloat_MovementDescNumber.MovementId =  Movement.Id
                                                        AND MovementFloat_MovementDescNumber.DescId     = zc_MovementFloat_MovementDescNumber()
                                                        AND MovementFloat_MovementDescNumber.ValueData  = 25 -- Перепак
                                                        -- !!!
                                                        AND MovementFloat_BranchCode.ValueData          = 1
                           WHERE Movement.OperDate  = inPartionGoodsDate -- BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId   = zc_Movement_WeighingProduction()
                              AND Movement.StatusId = zc_Enum_Status_UnComplete()
                              AND vbIsWeighing = TRUE
                              -- без Перепак
                              AND MovementFloat_MovementDescNumber.MovementId IS NULL
                           )

          , tmpMI AS (SELECT MovementItem.MovementId        AS MovementId
                           , MovementItem.Id                AS MovementItemId
                           , MovementItem.Amount            AS Amount
                             -- текущее значение
                           , COALESCE (MILO_PartionCell.DescId, 0)    AS DescId_MILO
                           , COALESCE (MILO_PartionCell.ObjectId, 0)  AS PartionCellId
                             --
                           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) AS isRePack

                      FROM MovementItem
                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = MovementItem.MovementId
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()

                           LEFT JOIN tmpMI_PartionDate ON tmpMI_PartionDate.MovementItemId = MovementItem.Id
                           -- выбрали только с пустой Партия дата
                           LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                      ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                     AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                           LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                            ON MILO_GoodsKind.MovementItemId  = MovementItem.Id
                                                           AND MILO_GoodsKind.DescId          = zc_MILinkObject_GoodsKind()

                           LEFT JOIN MovementItemLinkObject AS MILO_PartionCell
                                                            ON MILO_PartionCell.MovementItemId = MovementItem.Id
                                                           AND MILO_PartionCell.ObjectId       > 0
                                                           AND MILO_PartionCell.DescId         IN (zc_MILinkObject_PartionCell_1()
                                                                                                 , zc_MILinkObject_PartionCell_2()
                                                                                                 , zc_MILinkObject_PartionCell_3()
                                                                                                 , zc_MILinkObject_PartionCell_4()
                                                                                                 , zc_MILinkObject_PartionCell_5()
                                                                                                 , zc_MILinkObject_PartionCell_6()
                                                                                                 , zc_MILinkObject_PartionCell_7()
                                                                                                 , zc_MILinkObject_PartionCell_8()
                                                                                                 , zc_MILinkObject_PartionCell_9()
                                                                                                 , zc_MILinkObject_PartionCell_10()
                                                                                                 , zc_MILinkObject_PartionCell_11()
                                                                                                 , zc_MILinkObject_PartionCell_12()
                                                                                                 , zc_MILinkObject_PartionCell_13()
                                                                                                 , zc_MILinkObject_PartionCell_14()
                                                                                                 , zc_MILinkObject_PartionCell_15()
                                                                                                 , zc_MILinkObject_PartionCell_16()
                                                                                                 , zc_MILinkObject_PartionCell_17()
                                                                                                 , zc_MILinkObject_PartionCell_18()
                                                                                                 , zc_MILinkObject_PartionCell_19()
                                                                                                 , zc_MILinkObject_PartionCell_20()
                                                                                                 , zc_MILinkObject_PartionCell_21()
                                                                                                 , zc_MILinkObject_PartionCell_22()
                                                                                                  )
                                                           -- !!!
                                                           -- AND 1=0

                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                        AND MovementItem.DescId   = zc_MI_Master()
                        AND MovementItem.isErased = FALSE
                        -- ограничили товаром
                        AND MovementItem.ObjectId = inGoodsId
                        -- ограничили видом
                        AND COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId
                        -- пустая Партия дата
                        AND MIDate_PartionGoods.ValueData IS NULL
                        -- нет в этом списке
                        AND tmpMI_PartionDate.MovementItemId IS NULL

                     UNION ALL
                      SELECT tmpMI_PartionDate.MovementId
                           , tmpMI_PartionDate.MovementItemId
                           , tmpMI_PartionDate.Amount
                             -- текущее значение
                           , tmpMI_PartionDate.DescId_MILO
                           , tmpMI_PartionDate.PartionCellId
                             --
                           , COALESCE (MovementBoolean_isRePack.ValueData, FALSE) AS isRePack

                      FROM tmpMI_PartionDate
                           LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                     ON MovementBoolean_isRePack.MovementId = tmpMI_PartionDate.MovementId
                                                    AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
                     )
       -- Результат
       SELECT MovementId, MovementItemId, Amount
              -- текущее значение
            , DescId_MILO
            , PartionCellId
              -- 
            , isRePack

       FROM tmpMI;

     RETURN QUERY 
     WITH
     tmpMI AS (
               SELECT MILinkObject_PartionCell_1.ObjectId  AS PartionCellId_1
                    , MILinkObject_PartionCell_2.ObjectId  AS PartionCellId_2
                    , MILinkObject_PartionCell_3.ObjectId  AS PartionCellId_3
                    , MILinkObject_PartionCell_4.ObjectId  AS PartionCellId_4
                    , MILinkObject_PartionCell_5.ObjectId  AS PartionCellId_5
                    , MILinkObject_PartionCell_6.ObjectId  AS PartionCellId_6
                    , MILinkObject_PartionCell_7.ObjectId  AS PartionCellId_7
                    , MILinkObject_PartionCell_8.ObjectId  AS PartionCellId_8
                    , MILinkObject_PartionCell_9.ObjectId  AS PartionCellId_9
                    , MILinkObject_PartionCell_10.ObjectId AS PartionCellId_10
                    , MILinkObject_PartionCell_11.ObjectId AS PartionCellId_11
                    , MILinkObject_PartionCell_12.ObjectId AS PartionCellId_12
                    , MILinkObject_PartionCell_13.ObjectId AS PartionCellId_13
                    , MILinkObject_PartionCell_14.ObjectId AS PartionCellId_14
                    , MILinkObject_PartionCell_15.ObjectId AS PartionCellId_15
                    , MILinkObject_PartionCell_16.ObjectId AS PartionCellId_16
                    , MILinkObject_PartionCell_17.ObjectId AS PartionCellId_17
                    , MILinkObject_PartionCell_18.ObjectId AS PartionCellId_18
                    , MILinkObject_PartionCell_19.ObjectId AS PartionCellId_19
                    , MILinkObject_PartionCell_20.ObjectId AS PartionCellId_20
                    , MILinkObject_PartionCell_21.ObjectId AS PartionCellId_21
                    , MILinkObject_PartionCell_22.ObjectId AS PartionCellId_22

                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_1.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_1 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_2.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_2 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_3.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_3 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_4.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_4 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_5.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_5 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_6.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_6 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_7.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_7 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_8.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_8 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_9.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)   AS isMany_9 
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_10.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_10
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_11.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_11
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_12.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_12
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_13.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_13
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_14.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_14
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_15.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_15
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_16.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_16
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_17.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_17
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_18.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_18
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_19.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_19
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_20.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_20
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_21.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_21
                    , SUM (CASE WHEN COALESCE (MIBoolean_PartionCell_Many_22.ValueData, FALSE)= FALSE THEN 0 ELSE 1 END)  AS isMany_22

               FROM _tmpItem_PartionCell
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_1
                                          ON MIBoolean_PartionCell_Many_1.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_1.DescId = zc_MIBoolean_PartionCell_Many_1()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_2
                                          ON MIBoolean_PartionCell_Many_2.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_2.DescId = zc_MIBoolean_PartionCell_Many_2()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_3
                                          ON MIBoolean_PartionCell_Many_3.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_3.DescId = zc_MIBoolean_PartionCell_Many_3()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_4
                                          ON MIBoolean_PartionCell_Many_4.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_4.DescId = zc_MIBoolean_PartionCell_Many_4()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_5
                                          ON MIBoolean_PartionCell_Many_5.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_5.DescId = zc_MIBoolean_PartionCell_Close_5()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_6
                                          ON MIBoolean_PartionCell_Many_6.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_6.DescId = zc_MIBoolean_PartionCell_Many_6()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_7
                                          ON MIBoolean_PartionCell_Many_7.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_7.DescId = zc_MIBoolean_PartionCell_Many_7()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_8
                                          ON MIBoolean_PartionCell_Many_8.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_8.DescId = zc_MIBoolean_PartionCell_Many_8()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_9
                                          ON MIBoolean_PartionCell_Many_9.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_9.DescId = zc_MIBoolean_PartionCell_Many_9()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_10
                                          ON MIBoolean_PartionCell_Many_10.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_10.DescId = zc_MIBoolean_PartionCell_Many_10()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_11
                                          ON MIBoolean_PartionCell_Many_11.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_11.DescId = zc_MIBoolean_PartionCell_Many_11()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_12
                                          ON MIBoolean_PartionCell_Many_12.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_12.DescId = zc_MIBoolean_PartionCell_Many_12()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_13
                                          ON MIBoolean_PartionCell_Many_13.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_13.DescId = zc_MIBoolean_PartionCell_Many_13()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_14
                                          ON MIBoolean_PartionCell_Many_14.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_14.DescId = zc_MIBoolean_PartionCell_Many_14()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_15
                                          ON MIBoolean_PartionCell_Many_15.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_15.DescId = zc_MIBoolean_PartionCell_Many_15()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_16
                                          ON MIBoolean_PartionCell_Many_16.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_16.DescId = zc_MIBoolean_PartionCell_Many_16()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_17
                                          ON MIBoolean_PartionCell_Many_17.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_17.DescId = zc_MIBoolean_PartionCell_Many_17()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_18
                                          ON MIBoolean_PartionCell_Many_18.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_18.DescId = zc_MIBoolean_PartionCell_Many_18()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_19
                                          ON MIBoolean_PartionCell_Many_19.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_19.DescId = zc_MIBoolean_PartionCell_Many_19()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_20
                                          ON MIBoolean_PartionCell_Many_20.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_20.DescId = zc_MIBoolean_PartionCell_Many_20()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_21
                                          ON MIBoolean_PartionCell_Many_21.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_21.DescId = zc_MIBoolean_PartionCell_Many_21()
            LEFT JOIN MovementItemBoolean AS MIBoolean_PartionCell_Many_22
                                          ON MIBoolean_PartionCell_Many_22.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                         AND MIBoolean_PartionCell_Many_22.DescId = zc_MIBoolean_PartionCell_Many_22()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_1
                                             ON MILinkObject_PartionCell_1.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_1.DescId = zc_MILinkObject_PartionCell_1()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_2
                                             ON MILinkObject_PartionCell_2.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_2.DescId = zc_MILinkObject_PartionCell_2()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_3
                                             ON MILinkObject_PartionCell_3.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_3.DescId = zc_MILinkObject_PartionCell_3()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_4
                                             ON MILinkObject_PartionCell_4.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_4.DescId = zc_MILinkObject_PartionCell_4()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_5
                                             ON MILinkObject_PartionCell_5.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_5.DescId = zc_MILinkObject_PartionCell_5()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_6
                                             ON MILinkObject_PartionCell_6.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_6.DescId = zc_MILinkObject_PartionCell_6()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_7
                                             ON MILinkObject_PartionCell_7.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_7.DescId = zc_MILinkObject_PartionCell_7()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_8
                                             ON MILinkObject_PartionCell_8.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_8.DescId = zc_MILinkObject_PartionCell_8()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_9
                                             ON MILinkObject_PartionCell_9.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_9.DescId = zc_MILinkObject_PartionCell_9()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_10
                                             ON MILinkObject_PartionCell_10.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_10.DescId = zc_MILinkObject_PartionCell_10()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_11
                                             ON MILinkObject_PartionCell_11.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_11.DescId = zc_MILinkObject_PartionCell_11()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_12
                                             ON MILinkObject_PartionCell_12.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_12.DescId = zc_MILinkObject_PartionCell_12()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_13
                                             ON MILinkObject_PartionCell_13.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_13.DescId = zc_MILinkObject_PartionCell_13()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_14
                                             ON MILinkObject_PartionCell_14.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_14.DescId = zc_MILinkObject_PartionCell_14()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_15
                                             ON MILinkObject_PartionCell_15.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_15.DescId = zc_MILinkObject_PartionCell_15()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_16
                                             ON MILinkObject_PartionCell_16.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_16.DescId = zc_MILinkObject_PartionCell_16()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_17
                                             ON MILinkObject_PartionCell_17.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_17.DescId = zc_MILinkObject_PartionCell_17()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_18
                                             ON MILinkObject_PartionCell_18.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_18.DescId = zc_MILinkObject_PartionCell_18()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_19
                                             ON MILinkObject_PartionCell_19.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_19.DescId = zc_MILinkObject_PartionCell_19()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_20
                                             ON MILinkObject_PartionCell_20.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_20.DescId = zc_MILinkObject_PartionCell_20()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_21
                                             ON MILinkObject_PartionCell_21.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_21.DescId = zc_MILinkObject_PartionCell_21()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionCell_22
                                             ON MILinkObject_PartionCell_22.MovementItemId = _tmpItem_PartionCell.MovementItemId
                                            AND MILinkObject_PartionCell_22.DescId = zc_MILinkObject_PartionCell_22()
 
           GROUP BY  MILinkObject_PartionCell_1.ObjectId
                   , MILinkObject_PartionCell_2.ObjectId
                   , MILinkObject_PartionCell_3.ObjectId
                   , MILinkObject_PartionCell_4.ObjectId
                   , MILinkObject_PartionCell_5.ObjectId
                   , MILinkObject_PartionCell_6.ObjectId
                   , MILinkObject_PartionCell_7.ObjectId
                   , MILinkObject_PartionCell_8.ObjectId
                   , MILinkObject_PartionCell_9.ObjectId
                   , MILinkObject_PartionCell_10.ObjectId
                   , MILinkObject_PartionCell_11.ObjectId
                   , MILinkObject_PartionCell_12.ObjectId
                   , MILinkObject_PartionCell_13.ObjectId
                   , MILinkObject_PartionCell_14.ObjectId
                   , MILinkObject_PartionCell_15.ObjectId
                   , MILinkObject_PartionCell_16.ObjectId
                   , MILinkObject_PartionCell_17.ObjectId
                   , MILinkObject_PartionCell_18.ObjectId
                   , MILinkObject_PartionCell_19.ObjectId
                   , MILinkObject_PartionCell_20.ObjectId
                   , MILinkObject_PartionCell_21.ObjectId
                   , MILinkObject_PartionCell_22.ObjectId
               
               )
     SELECT  Object_PartionCell_1.Id            AS PartionCellId_1
           , Object_PartionCell_1.ObjectCode    AS PartionCellCode_1
           , (Object_PartionCell_1.ValueData ):: TVarChar AS PartionCellName_1

           , Object_PartionCell_2.Id            AS PartionCellId_2
           , Object_PartionCell_2.ObjectCode    AS PartionCellCode_2
           , (Object_PartionCell_2.ValueData ):: TVarChar AS PartionCellName_2

           , Object_PartionCell_3.Id            AS PartionCellId_3
           , Object_PartionCell_3.ObjectCode    AS PartionCellCode_3
           , (Object_PartionCell_3.ValueData ):: TVarChar AS PartionCellName_3

           , Object_PartionCell_4.Id            AS PartionCellId_4
           , Object_PartionCell_4.ObjectCode    AS PartionCellCode_4
           , (Object_PartionCell_4.ValueData ):: TVarChar AS PartionCellName_4

           , Object_PartionCell_5.Id            AS PartionCellId_5
           , Object_PartionCell_5.ObjectCode    AS PartionCellCode_5
           , (Object_PartionCell_5.ValueData):: TVarChar  AS PartionCellName_5

           , Object_PartionCell_6.Id            AS PartionCellId_6
           , Object_PartionCell_6.ObjectCode    AS PartionCellCode_6
           , (Object_PartionCell_6.ValueData):: TVarChar  AS PartionCellName_6

           , Object_PartionCell_7.Id            AS PartionCellId_7
           , Object_PartionCell_7.ObjectCode    AS PartionCellCode_7
           , (Object_PartionCell_7.ValueData):: TVarChar  AS PartionCellName_7

           , Object_PartionCell_8.Id            AS PartionCellId_8
           , Object_PartionCell_8.ObjectCode    AS PartionCellCode_8
           , (Object_PartionCell_8.ValueData):: TVarChar  AS PartionCellName_8

           , Object_PartionCell_9.Id            AS PartionCellId_9
           , Object_PartionCell_9.ObjectCode    AS PartionCellCode_9
           , (Object_PartionCell_9.ValueData):: TVarChar  AS PartionCellName_9

           , Object_PartionCell_10.Id            AS PartionCellId_10
           , Object_PartionCell_10.ObjectCode    AS PartionCellCode_10
           , (Object_PartionCell_10.ValueData):: TVarChar AS PartionCellName_10

           , Object_PartionCell_11.Id            AS PartionCellId_11
           , Object_PartionCell_11.ObjectCode    AS PartionCellCode_11
           , (Object_PartionCell_11.ValueData):: TVarChar AS PartionCellName_11

           , Object_PartionCell_12.Id            AS PartionCellId_12
           , Object_PartionCell_12.ObjectCode    AS PartionCellCode_12
           , (Object_PartionCell_12.ValueData):: TVarChar AS PartionCellName_12
           
           , Object_PartionCell_13.Id            AS PartionCellId_13
           , Object_PartionCell_13.ObjectCode    AS PartionCellCode_13
           , (Object_PartionCell_13.ValueData):: TVarChar AS PartionCellName_13
           , Object_PartionCell_14.Id            AS PartionCellId_14
           , Object_PartionCell_14.ObjectCode    AS PartionCellCode_14
           , (Object_PartionCell_14.ValueData):: TVarChar AS PartionCellName_14
           , Object_PartionCell_15.Id            AS PartionCellId_15
           , Object_PartionCell_15.ObjectCode    AS PartionCellCode_15
           , (Object_PartionCell_15.ValueData):: TVarChar AS PartionCellName_15
           , Object_PartionCell_16.Id            AS PartionCellId_16
           , Object_PartionCell_16.ObjectCode    AS PartionCellCode_16
           , (Object_PartionCell_16.ValueData):: TVarChar AS PartionCellName_16
           , Object_PartionCell_17.Id            AS PartionCellId_17
           , Object_PartionCell_17.ObjectCode    AS PartionCellCode_17                                                                           
           , (Object_PartionCell_17.ValueData):: TVarChar AS PartionCellName_17
           , Object_PartionCell_18.Id            AS PartionCellId_18
           , Object_PartionCell_18.ObjectCode    AS PartionCellCode_18
           , (Object_PartionCell_18.ValueData):: TVarChar AS PartionCellName_18
           , Object_PartionCell_19.Id            AS PartionCellId_19
           , Object_PartionCell_19.ObjectCode    AS PartionCellCode_19
           , (Object_PartionCell_19.ValueData):: TVarChar AS PartionCellName_19
           , Object_PartionCell_20.Id            AS PartionCellId_20
           , Object_PartionCell_20.ObjectCode    AS PartionCellCode_20
           , (Object_PartionCell_20.ValueData):: TVarChar AS PartionCellName_20
           , Object_PartionCell_21.Id            AS PartionCellId_21
           , Object_PartionCell_21.ObjectCode    AS PartionCellCode_21
           , (Object_PartionCell_21.ValueData):: TVarChar AS PartionCellName_21
           , Object_PartionCell_22.Id            AS PartionCellId_22
           , Object_PartionCell_22.ObjectCode    AS PartionCellCode_22
           , (Object_PartionCell_22.ValueData):: TVarChar AS PartionCellName_22

          
           , CASE WHEN tmpMI.isMany_1 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_1
           , CASE WHEN tmpMI.isMany_2 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_2
           , CASE WHEN tmpMI.isMany_3 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_3
           , CASE WHEN tmpMI.isMany_4 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_4
           , CASE WHEN tmpMI.isMany_5 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_5
           , CASE WHEN tmpMI.isMany_6 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_6 
           , CASE WHEN tmpMI.isMany_7 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_7 
           , CASE WHEN tmpMI.isMany_8 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_8 
           , CASE WHEN tmpMI.isMany_9 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_9 
           , CASE WHEN tmpMI.isMany_10 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_10
           , CASE WHEN tmpMI.isMany_11 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_11
           , CASE WHEN tmpMI.isMany_12 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_12
           , CASE WHEN tmpMI.isMany_13 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_13
           , CASE WHEN tmpMI.isMany_14 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_14
           , CASE WHEN tmpMI.isMany_15 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_15
           , CASE WHEN tmpMI.isMany_16 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_16
           , CASE WHEN tmpMI.isMany_17 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_17
           , CASE WHEN tmpMI.isMany_18 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_18
           , CASE WHEN tmpMI.isMany_19 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_19
           , CASE WHEN tmpMI.isMany_20 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_20
           , CASE WHEN tmpMI.isMany_21 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_21
           , CASE WHEN tmpMI.isMany_22 = 0 THEN FALSE ELSE TRUE END ::Boolean AS isMany_22
     FROM tmpMI
            LEFT JOIN Object AS Object_PartionCell_1 ON Object_PartionCell_1.Id = tmpMI.PartionCellId_1
            LEFT JOIN Object AS Object_PartionCell_2 ON Object_PartionCell_2.Id = tmpMI.PartionCellId_2
            LEFT JOIN Object AS Object_PartionCell_3 ON Object_PartionCell_3.Id = tmpMI.PartionCellId_3
            LEFT JOIN Object AS Object_PartionCell_4 ON Object_PartionCell_4.Id = tmpMI.PartionCellId_4
            LEFT JOIN Object AS Object_PartionCell_5 ON Object_PartionCell_5.Id = tmpMI.PartionCellId_5
            LEFT JOIN Object AS Object_PartionCell_6 ON Object_PartionCell_6.Id = tmpMI.PartionCellId_6
            LEFT JOIN Object AS Object_PartionCell_7 ON Object_PartionCell_7.Id = tmpMI.PartionCellId_7
            LEFT JOIN Object AS Object_PartionCell_8 ON Object_PartionCell_8.Id = tmpMI.PartionCellId_8
            LEFT JOIN Object AS Object_PartionCell_9 ON Object_PartionCell_9.Id = tmpMI.PartionCellId_9
            LEFT JOIN Object AS Object_PartionCell_10 ON Object_PartionCell_10.Id = tmpMI.PartionCellId_10
            LEFT JOIN Object AS Object_PartionCell_11 ON Object_PartionCell_11.Id = tmpMI.PartionCellId_11
            LEFT JOIN Object AS Object_PartionCell_12 ON Object_PartionCell_12.Id = tmpMI.PartionCellId_12
            LEFT JOIN Object AS Object_PartionCell_13 ON Object_PartionCell_13.Id = tmpMI.PartionCellId_13
            LEFT JOIN Object AS Object_PartionCell_14 ON Object_PartionCell_14.Id = tmpMI.PartionCellId_14
            LEFT JOIN Object AS Object_PartionCell_15 ON Object_PartionCell_15.Id = tmpMI.PartionCellId_15
            LEFT JOIN Object AS Object_PartionCell_16 ON Object_PartionCell_16.Id = tmpMI.PartionCellId_16
            LEFT JOIN Object AS Object_PartionCell_17 ON Object_PartionCell_17.Id = tmpMI.PartionCellId_17
            LEFT JOIN Object AS Object_PartionCell_18 ON Object_PartionCell_18.Id = tmpMI.PartionCellId_18
            LEFT JOIN Object AS Object_PartionCell_19 ON Object_PartionCell_19.Id = tmpMI.PartionCellId_19
            LEFT JOIN Object AS Object_PartionCell_20 ON Object_PartionCell_20.Id = tmpMI.PartionCellId_20
            LEFT JOIN Object AS Object_PartionCell_21 ON Object_PartionCell_21.Id = tmpMI.PartionCellId_21
            LEFT JOIN Object AS Object_PartionCell_22 ON Object_PartionCell_22.Id = tmpMI.PartionCellId_22

     ;
    
    
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.25         *
*/

-- тест
-- SELECT * FROM gpGet_MI_Send_PartionCell_isManyAll (inMovementId := 0, inMovementItemId:=0, inUnitId:=0, inGoodsId:=0, inGoodsKindId:=0, inPartionGoodsDate := '01.01.2014', inSession:= '2')
-- select * from gpGet_MI_Send_PartionCell_isManyAll(inMovementId := 0 , inMovementItemId := 0 , inUnitId := 8459 , inGoodsId := 2894 , inGoodsKindId := 8344 , inPartionGoodsDate := ('18.05.2025')::TDateTime ,  inSession := '9457');