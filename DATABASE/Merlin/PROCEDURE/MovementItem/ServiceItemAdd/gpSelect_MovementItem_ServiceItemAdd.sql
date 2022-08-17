-- Function: gpSelect_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItemAdd (Integer, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ServiceItemAdd (Integer, Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ServiceItemAdd(
    IN inMovementId       Integer      , -- ключ Документа
    IN inInfoMoneyId      Integer   ,
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, UnitName_Full TVarChar
             , UnitGroupNameFull TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar

             , DateStart TDateTime, DateEnd TDateTime
             , MonthNameStart TDateTime, MonthNameEnd   TDateTime
             , NumYearStart   Integer            --год старт
             , NumYearEnd     Integer            --год енд
             , NumStartDate   Integer            --номер месяца старт
             , NumEndDate     Integer            --номер месяца енд
             , Amount TFloat

             , DateStart_Main TDateTime, DateEnd_Main TDateTime
             , Amount_Main TFloat, Price_Main TFloat, Area_Main TFloat

             , MonthNameStart_before  TDateTime
             , MonthNameEnd_before TDateTime
             , Amount_before TFloat

             , isErased Boolean

              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ServiceItemAdd());
     vbUserId:= lpGetUserBySession (inSession);
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     IF inShowAll = TRUE
     THEN
        -- Показываем ВСЕ
        RETURN QUERY
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                          FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                               JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = tmpIsErased.isErased

                               LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                          ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                               LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                          ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                         AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                                ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_InfoMoney.DescId         = zc_MILinkObject_InfoMoney()

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                                ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                          )

             , tmpUnit AS (SELECT Object_Unit.Id AS UnitId
                           FROM Object AS Object_Unit
                           WHERE Object_Unit.DescId = zc_Object_Unit()
                             AND Object_Unit.isErased = FALSE
                          )
               -- Базовые условия - на дату vbOperDate
             , tmpMI_Main AS (SELECT *
                              FROM gpSelect_MovementItem_ServiceItem_onDate (inOperDate := vbOperDate, inUnitId:= 0, inInfoMoneyId:= inInfoMoneyId, inSession := inSession) AS gpSelect
                              WHERE gpSelect.Amount > 0
                             )
               -- поиск предыдущего дополнения
             , tmp_last AS (SELECT tmp.*
                            FROM (SELECT tmpMI.Id AS MovementItemId_find
                                       , tmp_View.*
                                       , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.OperDate DESC, tmp_View.MovementId DESC) AS ord
                                  FROM tmpMI
                                       INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                               ON tmp_View.UnitId      = tmpMI.UnitId
                                                                              AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                                                                              AND tmp_View.isErased    = FALSE
                                                                              AND tmpMI.DateStart BETWEEN tmp_View.DateStart AND tmp_View.DateEnd
                                                                              AND tmp_View.OperDate    < vbOperDate
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                           )

           -- Результат
           SELECT 0                             AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName 
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id           AS InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                , Object_InfoMoney.ValueData    AS InfoMoneyName

                , 0              AS CommentInfoMoneyId
                , 0              AS CommentInfoMoneyCode
                , '' ::TVarChar  AS CommentInfoMoneyName

                , tmpMI_Main.DateStart                    :: TDateTime AS DateStart
                , tmpMI_Main.DateEnd                      :: TDateTime AS DateEnd
                , tmpMI_Main.DateStart                    :: TDateTime AS MonthNameStart
                , tmpMI_Main.DateEnd                      :: TDateTime AS MonthNameEnd

                , (EXTRACT (Year FROM tmpMI_Main.DateStart) - 2000) ::Integer  AS NumYearStart    --год старт
                , (EXTRACT (Year FROM tmpMI_Main.DateEnd)   - 2000) ::Integer  AS NumYearEnd      --год енд
                , EXTRACT (MONTH FROM tmpMI_Main.DateStart) ::Integer  AS NumStartDate            --номер месяца старт
                , EXTRACT (MONTH FROM tmpMI_Main.DateEnd)   ::Integer  AS NumEndDate              --номер месяца енд

                , 0                          :: TFloat    AS Amount

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , NULL            :: TDateTime AS MonthNameStart_before
                , NULL            :: TDateTime AS MonthNameEnd_before
                , NULL            :: TFloat    AS Amount_before

                , FALSE           :: Boolean   AS isErased

           FROM tmpUnit
                INNER JOIN tmpMI_Main ON tmpMI_Main.UnitId = tmpUnit.UnitId
                --                    AND tmpMI_Main.InfoMoneyId = tmpMI.InfoMoneyId

                LEFT JOIN tmpMI ON tmpMI.UnitId = tmpUnit.UnitId

                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUnit.UnitId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpUnit.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = COALESCE(tmpMI_Main.InfoMoneyId,76878)

           WHERE tmpMI.UnitId IS NULL

         UNION ALL
           -- текушие элементы документа
           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName  
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id           AS InfoMoneyId
                , Object_InfoMoney.ObjectCode   AS InfoMoneyCode
                , Object_InfoMoney.ValueData    AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.DateStart            :: TDateTime AS MonthNameStart
                , tmpMI.DateEnd              :: TDateTime AS MonthNameEnd
                , (EXTRACT (Year FROM tmpMI.DateStart) - 2000) ::Integer  AS NumYearStart            --год старт
                , (EXTRACT (Year FROM tmpMI.DateEnd)   - 2000) ::Integer  AS NumYearEnd              --год енд
                , EXTRACT (MONTH FROM tmpMI.DateStart) ::Integer  AS NumStartDate            --номер месяца старт
                , EXTRACT (MONTH FROM tmpMI.DateEnd)   ::Integer  AS NumEndDate              --номер месяца енд

                , tmpMI.Amount               :: TFloat    AS Amount

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , tmp_last.DateStart       :: TDateTime AS MonthNameStart_before
                , tmp_last.DateEnd         :: TDateTime AS MonthNameEnd_before
                , tmp_last.Amount          :: TFloat    AS Amount_before

                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId

                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                -- Базовые условия - на дату
                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := tmpMI.DateStart
                                                                  , inUnitId     := tmpMI.UnitId
                                                                  , inInfoMoneyId:= tmpMI.InfoMoneyId
                                                                  , inSession    := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI.DateStart BETWEEN tmpMI_Main.DateStart AND tmpMI_Main.DateEnd
                                                                    AND tmpMI_Main.Amount > 0

                LEFT JOIN tmp_last ON tmp_last.MovementItemId_find = tmpMI.Id
          ;

     ELSE
         -- Результат - только текущие элементы документа
         RETURN QUERY
          WITH tmpMI AS (SELECT MovementItem.Id
                              , MovementItem.ObjectId                  AS UnitId
                              , MILinkObject_InfoMoney.ObjectId        AS InfoMoneyId
                              , MILinkObject_CommentInfoMoney.ObjectId AS CommentInfoMoneyId
                              , MovementItem.Amount
                              , COALESCE (MIDate_DateStart.ValueData, vbOperDate) AS DateStart
                              , COALESCE (MIDate_DateEnd.ValueData, zc_DateEnd()) AS DateEnd
                              , MovementItem.isErased
                         FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                              JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased

                              LEFT JOIN MovementItemDate AS MIDate_DateStart
                                                         ON MIDate_DateStart.MovementItemId = MovementItem.Id
                                                        AND MIDate_DateStart.DescId = zc_MIDate_DateStart()
                              LEFT JOIN MovementItemDate AS MIDate_DateEnd
                                                         ON MIDate_DateEnd.MovementItemId = MovementItem.Id
                                                        AND MIDate_DateEnd.DescId = zc_MIDate_DateEnd()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                               ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

                              LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                                               ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                                              AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
                        )

               -- поиск предыдущего дополнения
             , tmp_last AS (SELECT tmp.*
                            FROM (SELECT tmpMI.Id AS MovementItemId_find
                                       , tmp_View.*
                                       , ROW_NUMBER() OVER (PARTITION BY tmp_View.UnitId, tmp_View.InfoMoneyId ORDER BY tmp_View.OperDate DESC, tmp_View.MovementId DESC) AS ord
                                  FROM tmpMI
                                       INNER JOIN Movement_ServiceItemAdd_View AS tmp_View
                                                                               ON tmp_View.UnitId      = tmpMI.UnitId
                                                                              AND tmp_View.InfoMoneyId = tmpMI.InfoMoneyId
                                                                              AND tmp_View.isErased    = FALSE
                                                                              AND tmpMI.DateStart BETWEEN tmp_View.DateStart AND tmp_View.DateEnd
                                                                              AND tmp_View.OperDate    < vbOperDate
                                  ) AS tmp
                            WHERE tmp.Ord = 1
                           )
           -- Результат
           SELECT tmpMI.Id                      AS Id
                , Object_Unit.Id                AS UnitId
                , Object_Unit.ObjectCode        AS UnitCode
                , Object_Unit.ValueData         AS UnitName
                , TRIM (COALESCE (ObjectString_Unit_GroupNameFull.ValueData,'')||' '||Object_Unit.ValueData) ::TVarChar AS UnitName_Full
                , ObjectString_Unit_GroupNameFull.ValueData AS UnitGroupNameFull

                , Object_InfoMoney.Id         AS InfoMoneyId
                , Object_InfoMoney.ObjectCode AS InfoMoneyCode
                , Object_InfoMoney.ValueData  AS InfoMoneyName

                , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
                , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
                , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

                , tmpMI.DateStart            :: TDateTime AS DateStart
                , tmpMI.DateEnd              :: TDateTime AS DateEnd
                , tmpMI.DateStart            :: TDateTime AS MonthNameStart
                , tmpMI.DateEnd              :: TDateTime AS MonthNameEnd
                , (EXTRACT (Year FROM tmpMI.DateStart) - 2000) ::Integer  AS NumYearStart            --год старт
                , (EXTRACT (Year FROM tmpMI.DateEnd)   - 2000) ::Integer  AS NumYearEnd              --год енд
                , EXTRACT (MONTH FROM tmpMI.DateStart) ::Integer  AS NumStartDate            --номер месяца старт
                , EXTRACT (MONTH FROM tmpMI.DateEnd)   ::Integer  AS NumEndDate              --номер месяца енд

                , tmpMI.Amount               :: TFloat    AS Amount

                , tmpMI_Main.DateStart       :: TDateTime AS DateStart_Main
                , tmpMI_Main.DateEnd         :: TDateTime AS DateEnd_Main
                , tmpMI_Main.Amount          :: TFloat    AS Amount_Main
                , tmpMI_Main.Price           :: TFloat    AS Price_Main
                , tmpMI_Main.Area            :: TFloat    AS Area_Main

                , tmp_last.DateStart       :: TDateTime AS MonthNameStart_before
                , tmp_last.DateEnd         :: TDateTime AS MonthNameEnd_before
                , tmp_last.Amount          :: TFloat    AS Amount_before

                , tmpMI.isErased
           FROM tmpMI
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMI.UnitId
                LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = tmpMI.CommentInfoMoneyId
                LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpMI.InfoMoneyId

                LEFT JOIN ObjectString AS ObjectString_Unit_GroupNameFull
                                       ON ObjectString_Unit_GroupNameFull.ObjectId = tmpMI.UnitId
                                      AND ObjectString_Unit_GroupNameFull.DescId   = zc_ObjectString_Unit_GroupNameFull()

                -- Базовые условия - на дату
                LEFT JOIN gpSelect_MovementItem_ServiceItem_onDate (inOperDate   := tmpMI.DateStart
                                                                  , inUnitId     := tmpMI.UnitId
                                                                  , inInfoMoneyId:= tmpMI.InfoMoneyId
                                                                  , inSession    := inSession
                                                                   ) AS tmpMI_Main
                                                                     ON tmpMI.DateStart BETWEEN tmpMI_Main.DateStart AND tmpMI_Main.DateEnd
                                                                    AND tmpMI_Main.Amount > 0

                LEFT JOIN tmp_last ON tmp_last.MovementItemId_find = tmpMI.Id
           ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.06.22         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inInfoMoneyId:= 76878, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ServiceItemAdd (inMovementId:= 7, inInfoMoneyId:= 76878, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
