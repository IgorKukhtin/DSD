-- Function: lpSelect_Movement_ChoiceCell_mi(Integer)

DROP FUNCTION IF EXISTS lpSelect_Movement_ChoiceCell_mi (Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_ChoiceCell_mi(
    IN inUserId Integer
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusId Integer, StatusCode Integer, StatusName TVarChar
             , MovementItemId Integer
             , ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime

             , isChecked Boolean
             , Ord Integer
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY
        WITH tmpMovement AS (SELECT Movement.Id                     AS MovementId
                                  , Movement.InvNumber              AS InvNumber
                                  , Movement.OperDate               AS OperDate
                                  , Movement.StatusId               AS StatusId
                                  , Object_Status.ObjectCode        AS StatusCode
                                  , Object_Status.ValueData         AS StatusName

                                  , MovementItem.Id                      AS MovementItemId
                                  , Object_ChoiceCell.Id                 AS ChoiceCellId
                                  , Object_ChoiceCell.ObjectCode         AS ChoiceCellCode
                                  , Object_ChoiceCell.ValueData          AS ChoiceCellName

                                  , Object_Goods.Id          		         AS GoodsId
                                  , Object_Goods.ObjectCode  		         AS GoodsCode
                                  , Object_Goods.ValueData   		         AS GoodsName
                                  , COALESCE (Object_GoodsKind.Id, 0) :: Integer AS GoodsKindId
                                  , Object_GoodsKind.ValueData                   AS GoodsKindName
                                  , MIDate_PartionGoods.ValueData                AS PartionGoodsDate
                                  , MIDate_PartionGoods_next.ValueData           AS PartionGoodsDate_next

                                    --  Отмечен для хранения
                                  , MIBoolean_Checked.ValueData AS isChecked

                                  , Object_Insert.ValueData    AS InsertName
                                  , Object_Update.ValueData    AS UpdateName
                                  , MIDate_Insert.ValueData    AS InsertDate
                                  , MIDate_Update.ValueData    AS UpdateDate

                                  , ROW_NUMBER() OVER (PARTITION BY MILO_Goods.ObjectId, MILO_GoodsKind.ObjectId ORDER BY Movement.OperDate DESC, MovementItem.Id DESC) AS Ord

                             FROM Movement
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased   = FALSE
                                  INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                                 ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                                AND MIBoolean_Checked.DescId         = zc_MIBoolean_Checked()
                                                                AND MIBoolean_Checked.ValueData      = TRUE

                                  LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                                  LEFT JOIN Object AS Object_ChoiceCell ON Object_ChoiceCell.Id = MovementItem.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILO_Goods
                                                                   ON MILO_Goods.MovementItemId = MovementItem.Id
                                                                  AND MILO_Goods.DescId = zc_MILinkObject_Goods()
                                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILO_Goods.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                                   ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                             ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                            AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods_next
                                                             ON MIDate_PartionGoods_next.MovementItemId = MovementItem.Id
                                                            AND MIDate_PartionGoods_next.DescId = zc_MIDate_PartionGoods_next()


                                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                                  LEFT JOIN MovementItemDate AS MIDate_Update
                                                             ON MIDate_Update.MovementItemId = MovementItem.Id
                                                            AND MIDate_Update.DescId = zc_MIDate_Update()

                                  LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                                   ON MILO_Insert.MovementItemId = MovementItem.Id
                                                                  AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                                  LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

                                  LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                                   ON MILO_Update.MovementItemId = MovementItem.Id
                                                                  AND MILO_Update.DescId = zc_MILinkObject_Update()
                                  LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

                             WHERE Movement.OperDate BETWEEN CURRENT_DATE - INTERVAL '1 MONTH' AND CURRENT_DATE + INTERVAL '1 DAY'
                               AND Movement.DescId = zc_Movement_ChoiceCell()
                               AND Movement.StatusId <> zc_Enum_Status_Erased()
                            )

        -- Результат
        SELECT
             tmpMovement.MovementId
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , tmpMovement.StatusId
           , tmpMovement.StatusCode
           , tmpMovement.StatusName

           , tmpMovement.MovementItemId
           , tmpMovement.ChoiceCellId
           , tmpMovement.ChoiceCellCode
           , tmpMovement.ChoiceCellName

           , tmpMovement.GoodsId
           , tmpMovement.GoodsCode
           , tmpMovement.GoodsName
           , tmpMovement.GoodsKindId
           , tmpMovement.GoodsKindName
           , tmpMovement.PartionGoodsDate
           , tmpMovement.PartionGoodsDate_next

             -- Отметка что ждет по этому товару перемещение из места хранения
           , tmpMovement.isChecked
             --
           , tmpMovement.Ord :: Integer

           , tmpMovement.InsertName
           , tmpMovement.UpdateName
           , tmpMovement.InsertDate
           , tmpMovement.UpdateDate

        FROM tmpMovement
        --WHERE tmpMovement.Ord = 1
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.09.24                                        *
*/

-- тест
-- SELECT * FROM lpSelect_Movement_ChoiceCell_mi (inUserId:= zfCalc_UserAdmin() :: Integer)
