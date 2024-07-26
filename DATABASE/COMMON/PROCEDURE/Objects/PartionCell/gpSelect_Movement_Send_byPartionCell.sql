-- Function: gpSelect_Movement_Send_byPartionCell()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send_byPartionCell (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send_byPartionCell(
    IN inPartionCellId      Integer ,
    IN inSession            TVarChar            -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
             , FromId Integer, FromName TVarChar, ItemName_from TVarChar
             , ToId Integer, ToName TVarChar, ItemName_to TVarChar
             , DocumentKindId Integer, DocumentKindName TVarChar
             , Comment TVarChar
             , isAuto Boolean
              )
AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE curPartionCell refcursor;
 DECLARE vbPartionCellId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PartionCell());
     vbUserId:= lpGetUserBySession (inSession);


     --все МИ где участвует данная ячейка
     CREATE TEMP TABLE _tmpPartionCell_mi (MovementItemId Integer, DescId Integer, ObjectId Integer) ON COMMIT DROP;

     --
     OPEN curPartionCell FOR SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_PartionCell() ORDER BY Object.Id;
     -- начало цикла по курсору
     LOOP
          -- данные
          FETCH curPartionCell INTO vbPartionCellId;
          -- если данных нет, то мы выходим
          IF NOT FOUND THEN
             EXIT;
          END IF;

          --
          INSERT INTO _tmpPartionCell_mi (MovementItemId, DescId, ObjectId)
             WITH tmpMILO AS (SELECT * FROM MovementItemLinkObject AS MILO WHERE MILO.ObjectId = vbPartionCellId)
             SELECT tmpMILO.MovementItemId, tmpMILO.DescId, tmpMILO.ObjectId
             FROM tmpMILO
             WHERE tmpMILO.DescId IN (zc_MILinkObject_PartionCell_1()
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
               AND (tmpMILO.ObjectId = inPartionCellId OR COALESCE (inPartionCellId, 0) = 0) 
            ;
          --
     END LOOP; -- финиш цикла по курсору
     CLOSE curPartionCell; -- закрыли курсор


      RETURN QUERY
      WITH
      -- все документы
      tmpMovement AS (SELECT DISTINCT MovementItem.MovementId
                      FROM MovementItem
                      WHERE MovementItem.Id IN (SELECT DISTINCT _tmpPartionCell_mi.MovementItemId FROM _tmpPartionCell_mi)
                        AND MovementItem.isErased = FALSE 
                      )

       --
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName
           , MovementFloat_TotalCount.ValueData     AS TotalCount
           , Object_From.Id                         AS FromId
           , Object_From.ValueData                  AS FromName
           , ObjectDesc_from.ItemName               AS ItemName_from
           , Object_To.Id                           AS ToId
           , Object_To.ValueData                    AS ToName
           , ObjectDesc_to.ItemName                 AS ItemName_to
           , Object_DocumentKind.Id                 AS DocumentKindId
           , Object_DocumentKind.ValueData          AS DocumentKindName
           , MovementString_Comment.ValueData       AS Comment
           , COALESCE(MovementBoolean_isAuto.ValueData, False) :: Boolean  AS isAuto
       FROM tmpMovement                  
            JOIN Movement ON Movement.Id       = tmpMovement.MovementId
 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_from ON ObjectDesc_from.Id = Object_From.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_to ON ObjectDesc_to.Id = Object_To.DescId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind()
            LEFT JOIN Object AS Object_DocumentKind ON Object_DocumentKind.Id = MovementLinkObject_DocumentKind.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
            LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                      ON MovementBoolean_isAuto.MovementId = Movement.Id
                                     AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto() 

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
      ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.07.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send_byPartionCell (0, zfCalc_UserAdmin())
