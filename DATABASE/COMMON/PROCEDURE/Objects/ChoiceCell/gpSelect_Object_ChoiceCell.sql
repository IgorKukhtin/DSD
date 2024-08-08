-- Function: gpSelect_Object_ChoiceCell_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ChoiceCell (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ChoiceCell(
    IN inShowAll       Boolean , -- показать удаленные Да/нет
    IN inSession       TVarChar  -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar 
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar  
             , GoodsGroupName TVarChar, GoodsGroupNameFull TVarChar
             , NPP TFloat, BoxCount TFloat
             , Comment TVarChar
             , PartionGoodsDate_RK   TDateTime
             , PartionGoodsDate_real TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE curPartionCell refcursor;
   DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);
  

     --
     CREATE TEMP TABLE _tmpPartionCell (PartionCellId Integer, GoodsId Integer, GoodsKindId Integer, PartionGoodsDate TDateTime) ON COMMIT DROP;

     --
     OPEN curPartionCell FOR SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PartionCell() /*AND Object.Id = zc_PartionCell_RK()*/ ORDER BY Object.Id;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curPartionCell INTO vbPartionCellId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;

          -- Только заполненные ячейки + отбор
          INSERT INTO _tmpPartionCell (PartionCellId, GoodsId, GoodsKindId, PartionGoodsDate)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
                  , tmpMI AS (SELECT DISTINCT tmpMILO.ObjectId AS PartionCellId, MovementItem.ObjectId AS GoodsId, MILO_GoodsKind.ObjectId AS GoodsKindId, COALESCE (MIDate_PartionGoods.ValueData, Movement.OperDate) AS PartionGoodsDate
                              FROM tmpMILO
                                   LEFT JOIN MovementItem ON MovementItem.Id       = tmpMILO.MovementItemId
                                                         AND MovementItem.isErased = FALSE
                                   LEFT JOIN Movement ON Movement.Id = MovementItem.MovementId
                                   LEFT JOIN MovementBoolean AS MovementBoolean_isRePack
                                                             ON MovementBoolean_isRePack.MovementId = Movement.Id
                                                            AND MovementBoolean_isRePack.DescId     = zc_MovementBoolean_isRePack()
                                                            AND MovementBoolean_isRePack.ValueData  = TRUE
                                   LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                    ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                   AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                                   LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                              ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                             AND MIDate_PartionGoods.DescId         = zc_MIDate_PartionGoods()
                              -- Только заполненные
                              WHERE tmpMILO.ObjectId > 0
                                -- без ПЕРЕПАК
                                AND MovementBoolean_isRePack.MovementId IS NULL
                                --
                                AND tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
                             )
             -- Результат
             SELECT tmpMI.PartionCellId, tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
             FROM tmpMI
            ;
          --
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


     -- Результат
     RETURN QUERY 
       WITH tmpPartionCell_RK AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate DESC) AS Ord
                                  FROM (SELECT DISTINCT _tmpPartionCell.GoodsId, _tmpPartionCell.GoodsKindId, _tmpPartionCell.PartionGoodsDate
                                        FROM _tmpPartionCell
                                        WHERE _tmpPartionCell.PartionCellId = zc_PartionCell_RK()
                                       ) AS tmpMI
                                 )
        , tmpPartionCell_real AS (SELECT tmpMI.GoodsId, tmpMI.GoodsKindId, tmpMI.PartionGoodsDate
                                         -- № п/п
                                       , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId, tmpMI.GoodsKindId ORDER BY tmpMI.PartionGoodsDate ASC) AS Ord
                                  FROM (SELECT DISTINCT _tmpPartionCell.GoodsId, _tmpPartionCell.GoodsKindId, _tmpPartionCell.PartionGoodsDate
                                        FROM _tmpPartionCell
                                        WHERE _tmpPartionCell.PartionCellId <> zc_PartionCell_RK()
                                       ) AS tmpMI
                                 )
       

    -- Результат
    SELECT 
           Object_ChoiceCell.Id          AS Id
         , Object_ChoiceCell.ObjectCode  AS Code
         , Object_ChoiceCell.ValueData   AS Name

         , Object_Goods.Id         AS GoodsId
         , Object_Goods.ObjectCode AS GoodsCode
         , Object_Goods.ValueData  AS GoodsName

         , Object_GoodsKind.Id         AS GoodsKindId
         , Object_GoodsKind.ObjectCode AS GoodsKindCode
         , Object_GoodsKind.ValueData  AS GoodsKindName

         , Object_GoodsGroup.ValueData AS GoodsGroupName 
         , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

         , ObjectFloat_NPP.ValueData AS NPP
         , ObjectFloat_BoxCount.ValueData AS BoxCount

         , ObjectString_Comment.ValueData  AS Comment

         , tmpPartionCell_RK.PartionGoodsDate   :: TDateTime AS PartionGoodsDate_RK
         , tmpPartionCell_real.PartionGoodsDate :: TDateTime AS PartionGoodsDate_real

         , Object_ChoiceCell.isErased      AS isErased
       
    FROM Object AS Object_ChoiceCell 

        LEFT JOIN ObjectLink AS ObjectLink_Goods
                             ON ObjectLink_Goods.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_Goods.DescId = zc_ObjectLink_ChoiceCell_Goods()
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                             ON ObjectLink_GoodsKind.ObjectId = Object_ChoiceCell.Id
                            AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_ChoiceCell_GoodsKind()
        LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = ObjectLink_GoodsKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NPP
                              ON ObjectFloat_NPP.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_NPP.DescId = zc_ObjectFloat_ChoiceCell_NPP()

        LEFT JOIN ObjectFloat AS ObjectFloat_BoxCount
                              ON ObjectFloat_BoxCount.ObjectId = Object_ChoiceCell.Id
                             AND ObjectFloat_BoxCount.DescId = zc_ObjectFloat_ChoiceCell_BoxCount()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_ChoiceCell.Id
                              AND ObjectString_Comment.DescId = zc_ObjectString_ChoiceCell_Comment()
        --
        LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                             ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                            AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
        LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId
        LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                               ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                              AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

        LEFT JOIN tmpPartionCell_RK ON tmpPartionCell_RK.GoodsId     = Object_Goods.Id
                                   AND tmpPartionCell_RK.GoodsKindId = Object_GoodsKind.Id
                                   AND tmpPartionCell_RK.ord         = 1

        LEFT JOIN tmpPartionCell_real ON tmpPartionCell_real.GoodsId     = Object_Goods.Id
                                     AND tmpPartionCell_real.GoodsKindId = Object_GoodsKind.Id
                                     AND tmpPartionCell_real.ord         = 1

    WHERE Object_ChoiceCell.DescId = zc_Object_ChoiceCell()  
      AND (Object_ChoiceCell.isErased = FALSE OR inShowAll = TRUE)
    ORDER BY Object_ChoiceCell.ObjectCode
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_ChoiceCell (FALSE, zfCalc_UserAdmin())
