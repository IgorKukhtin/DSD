-- Function: gpSelect_Movement_ChoiceCell()

DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceCell (TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ChoiceCell (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ChoiceCell(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inIsErased           Boolean   ,
    IN inUserId             Integer   ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , MovementItemId Integer
             , ChoiceCellId Integer, ChoiceCellCode Integer, ChoiceCellName TVarChar, ChoiceCellName_search TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , PartionGoodsDate TDateTime, PartionGoodsDate_next TDateTime
             , isChecked Boolean
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ChoiceCell());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     --PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                          )

      , tmpMovement AS (SELECT
                             Movement.Id               AS Id
                           , Movement.InvNumber        AS InvNumber
                           , Movement.OperDate         AS OperDate
                           , Object_Status.ObjectCode  AS StatusCode
                           , Object_Status.ValueData   AS StatusName

                        FROM tmpStatus
                             INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                AND Movement.DescId = zc_Movement_ChoiceCell()
                                                AND Movement.StatusId = tmpStatus.StatusId
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                        )

      , tmpMI AS (SELECT MovementItem.*
                  FROM tmpMovement AS Movement
                       INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                  )
      , tmpMIDate AS (SELECT *
                      FROM MovementItemDate
                      WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemDate.DescId IN (zc_MIDate_PartionGoods()
                                                      , zc_MIDate_PartionGoods_next()
                                                      , zc_MIDate_Insert()
                                                      , zc_MIDate_Update()
                                                       )
                      )
      , tmpMIBoolean AS (SELECT *
                         FROM MovementItemBoolean
                         WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                           AND MovementItemBoolean.DescId = zc_MIBoolean_Checked()
                        )

      , tmpMILO AS (SELECT *
                    FROM MovementItemLinkObject
                    WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Goods()
                                                          , zc_MILinkObject_GoodsKind()
                                                          , zc_MILinkObject_Insert()
                                                          , zc_MILinkObject_Update()
                                                           )
                    )

        -- Результат
        SELECT
             Movement.Id                     AS Id
           , Movement.InvNumber              AS InvNumber
           , Movement.OperDate               AS OperDate
           , Movement.StatusCode             AS StatusCode
           , Movement.StatusName             AS StatusName

           , MovementItem.Id                      AS MovementItemId
           , Object_ChoiceCell.Id                 AS ChoiceCellId
           , Object_ChoiceCell.ObjectCode         AS ChoiceCellCode
           , Object_ChoiceCell.ValueData          AS ChoiceCellName
           , (Object_ChoiceCell.ValueData ||'@'||REPLACE (REPLACE (REPLACE (REPLACE (REPLACE (Object_ChoiceCell.ValueData, '.', ''), '-', ''), ' ', ''), '=', ''), ',', '')) :: TVarChar AS ChoiceCellName_search

           , Object_Goods.Id          		      AS GoodsId
           , Object_Goods.ObjectCode  		      AS GoodsCode
           , Object_Goods.ValueData   		      AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsKind.Id                  AS GoodsKindId
           , Object_GoodsKind.ValueData           AS GoodsKindName
           , MIDate_PartionGoods.ValueData        AS PartionGoodsDate
           , MIDate_PartionGoods_next.ValueData   AS PartionGoodsDate_next

             -- Отметка что ждет по этому товару перемещение из места хранения
           , COALESCE (MIBoolean_Checked.ValueData, FALSE) :: Boolean AS isChecked

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate

           , MovementItem.isErased                                AS isErased
        FROM tmpMovement AS Movement
            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN Object AS Object_ChoiceCell ON Object_ChoiceCell.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIBoolean AS MIBoolean_Checked
                                   ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                  AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()

            LEFT JOIN tmpMIDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
            LEFT JOIN tmpMIDate AS MIDate_PartionGoods_next
                                       ON MIDate_PartionGoods_next.MovementItemId = MovementItem.Id
                                      AND MIDate_PartionGoods_next.DescId = zc_MIDate_PartionGoods_next()

            LEFT JOIN tmpMILO AS MILO_Goods
                              ON MILO_Goods.MovementItemId = MovementItem.Id
                             AND MILO_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILO_Goods.ObjectId

            LEFT JOIN tmpMILO AS MILO_GoodsKind
                              ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                             AND MILO_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILO_GoodsKind.ObjectId

            LEFT JOIN tmpMIDate AS MIDate_Insert
                                ON MIDate_Insert.MovementItemId = MovementItem.Id
                               AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN tmpMIDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = MovementItem.Id
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN tmpMILO AS MILO_Insert
                              ON MILO_Insert.MovementItemId = MovementItem.Id
                             AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN tmpMILO AS MILO_Update
                              ON MILO_Update.MovementItemId = MovementItem.Id
                             AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
        WHERE (Object_Insert.Id = inUserId OR COALESCE (inUserId,0) = 0)
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ChoiceCell (inStartDate:= '24.08.2024'::TDateTime, inEndDate:= CURRENT_DATE::TDateTime, inIsErased:= TRUE, inUserId:= 0, inSession:= zfCalc_UserAdmin())
