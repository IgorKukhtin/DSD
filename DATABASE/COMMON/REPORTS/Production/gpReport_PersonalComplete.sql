-- Function: gpReport_PersonalComplete()

DROP FUNCTION IF EXISTS gpReport_PersonalComplete (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PersonalComplete (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpReport_PersonalComplete (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_PersonalComplete (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PersonalComplete(
    IN inStartDate   TDateTime ,              --
    IN inEndDate     TDateTime ,              --
    IN inPersonalId  Integer   ,              -- сотудник
    IN inPositionId  Integer   ,              -- должность
    IN inBranchId    Integer   ,              -- филиал
    IN inIsDay       Boolean   ,              -- признак группировки по дням - да/нет
    IN inIsMonth     Boolean   ,              -- признак группировки по месяцам - да/нет
    IN inIsDetail    Boolean   DEFAULT FALSE, -- признак группировки по дням - да/нет
    IN inisMovement  Boolean   DEFAULT FALSE, -- показать док
    IN inSession     TVarChar  DEFAULT ''      -- сессия пользователя
)
RETURNS TABLE (InvNumber TVarChar
             , OperDate TDateTime
             , MonthDate TDateTime
             , OperDate_parent TDateTime
             , InvNumber_parent TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelCode Integer, PositionLevelName TVarChar

             , MovementDescId Integer, MovementDescName TVarChar
             , BranchFromName TVarChar, BranchToName TVarChar
             , FromName TVarChar, ToName TVarChar

             , TotalCount      TFloat   -- Количество (компл.)
             , TotalCountKg    TFloat   -- Вес (компл.)
             , CountMI         TFloat   -- Кол. строк (компл.)
             , CountMovement   TFloat   -- Кол. док. (компл.)

             , TotalCount1     TFloat   -- Количество (клдв)
             , TotalCountKg1   TFloat   -- Вес (клдв)
             , CountMI1        TFloat   -- Кол. строк (клдв)
             , CountMovement1  TFloat   -- Кол. док. (клдв)

             , TotalCountStick TFloat   -- Количество шт. (стикеровщик) - Кол-во Упаковок (пакетов)

             , BranchName  TVarChar
             , FromId Integer, ToId  Integer

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalComplete());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
        WITH
        -- сотрудники
        tmpPersonal_all AS (SELECT Object_Personal_View.MemberId, Object_Personal_View.PersonalId, Object_Personal_View.UnitId, Object_Personal_View.PositionId, Object_Personal_View.PositionLevelId
                                 , COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) AS BranchId
                            FROM Object_Personal_View
                                 LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                      ON ObjectLink_Unit_Branch.ObjectId =  Object_Personal_View.UnitId
                                                     AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                            WHERE (Object_Personal_View.PersonalId = inPersonalId OR inPersonalId = 0)
                              AND (COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis()) = inBranchId OR inBranchId = 0)
                           )
        -- Пользователи - и для них сотрудники
      , tmpUser_findPersonal AS
                           (SELECT lfSelect.MemberId, lfSelect.PersonalId, lfSelect.UnitId, lfSelect.PositionId, lfSelect.PositionLevelId
                                 , COALESCE (lfSelect.BranchId, zc_Branch_Basis()) AS BranchId
                                 , ObjectLink_User_Member.ObjectId AS UserId
                            FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                 INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                       ON ObjectLink_User_Member.ChildObjectId =  lfSelect.MemberId
                                                      AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
                            WHERE (lfSelect.PersonalId = inPersonalId OR inPersonalId = 0)
                            --  AND (COALESCE (lfSelect.BranchId, zc_Branch_Basis()) = inBranchId OR inBranchId = 0)
                           )
            -- Свойства - Комплектовщики
          , tmpListDesc AS (SELECT zc_MovementLinkObject_PersonalComplete1() AS PersonalDescId
                           UNION ALL
                            SELECT zc_MovementLinkObject_PersonalComplete2() AS PersonalDescId
                           UNION ALL
                            SELECT zc_MovementLinkObject_PersonalComplete3() AS PersonalDescId
                           UNION ALL
                            SELECT zc_MovementLinkObject_PersonalComplete4() AS PersonalDescId
                           UNION ALL
                            SELECT zc_MovementLinkObject_PersonalComplete5() AS PersonalDescId
                          UNION ALL
                           SELECT zc_MovementLinkObject_PersonalStick1()     AS PersonalDescId
                           )
        -- Все документы
      , tmpMovement_all AS (SELECT Movement.Id AS MovementId
                                 , CASE WHEN inIsDetail = TRUE OR inisMovement = TRUE 
                                        THEN Movement.ParentId :: Integer 
                                        ELSE 0 
                                   END AS MovementId_parent
                                 , CASE WHEN inIsDetail = TRUE OR inisMovement = TRUE 
                                        THEN COALESCE (MovementFloat_MovementDesc.ValueData, Movement.DescId) :: Integer 
                                        ELSE 0 
                                   END AS MovementDescId
                                 , CASE WHEN inisMovement = TRUE 
                                        THEN Movement.InvNumber
                                        ELSE NULL
                                   END AS InvNumber
                                 , Movement.OperDate
                                 , CASE WHEN MovementLinkObject_Personal.DescId = zc_MovementLinkObject_PersonalStick1() THEN TRUE ELSE FALSE END AS isStick
                                 , MovementLinkObject_Personal.ObjectId                        AS PersonalId
                                 , MovementLinkObject_User.ObjectId                            AS UserId
                                 , COALESCE (tmpUser_findPersonal.BranchId, zc_Branch_Basis()) AS BranchId
                                 , COALESCE (MovementFloat_TotalCount.ValueData, 0)            AS TotalCount
                                 , COALESCE (MovementFloat_TotalCountKg.ValueData, 0)          AS TotalCountKg
                                 , COALESCE (MovementLinkObject_From.ObjectId, 0)              AS FromId
                                 , COALESCE (MovementLinkObject_To.ObjectId, 0)                AS ToId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                             AND inIsDetail = TRUE
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                             AND inIsDetail = TRUE
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                              ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                             AND MovementLinkObject_Personal.DescId     IN (SELECT tmpListDesc.PersonalDescId FROM tmpListDesc)
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                              ON MovementLinkObject_User.MovementId = Movement.Id
                                                             AND MovementLinkObject_User.DescId     = zc_MovementLinkObject_User()

                                 LEFT JOIN tmpUser_findPersonal ON tmpUser_findPersonal.UserId = MovementLinkObject_User.ObjectId

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                         ON MovementFloat_TotalCount.MovementId = Movement.Id
                                                        AND MovementFloat_TotalCount.DescId     = zc_MovementFloat_TotalCount()
                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                         ON MovementFloat_TotalCountKg.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCountKg.DescId     = zc_MovementFloat_TotalCountKg()
                                 LEFT JOIN MovementFloat AS MovementFloat_MovementDesc
                                                         ON MovementFloat_MovementDesc.MovementId =  Movement.Id
                                                        AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()


                            WHERE Movement.DescId   = zc_Movement_WeighingPartner()
                              -- AND Movement.Id = 7594708
                              AND Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND (MovementLinkObject_Personal.ObjectId = inPersonalId OR tmpUser_findPersonal.PersonalId = inPersonalId OR inPersonalId = 0)
                              AND (COALESCE (tmpUser_findPersonal.BranchId, zc_Branch_Basis()) = inBranchId OR inBranchId = 0)
                              -- !!!временное решение!!!
                              AND Movement.ParentId NOT IN (SELECT Movement_Report_Wage_Model_View.Id FROM Movement_Report_Wage_Model_View)
                           )
        -- Только если выборка была для одного inPersonalId, надо дотянуть остальных для пропорции
      , tmpMovement_add AS (SELECT MovementLinkObject_Personal.MovementId
                                 , MovementLinkObject_Personal.ObjectId AS PersonalId
                            FROM MovementLinkObject AS MovementLinkObject_Personal
                            WHERE MovementLinkObject_Personal.MovementId IN (SELECT DISTINCT tmpMovement_all.MovementId FROM tmpMovement_all WHERE tmpMovement_all.isStick = FALSE)
                              AND MovementLinkObject_Personal.DescId     IN (SELECT tmpListDesc.PersonalDescId FROM tmpListDesc WHERE tmpListDesc.PersonalDescId <> zc_MovementLinkObject_PersonalStick1())
                              AND inPersonalId <> 0
                           )
            -- Сгруппировали и ...
          , tmpMovement AS (SELECT tmpMovement_all.MovementId
                                   -- если выборка была для одного inPersonalId - дотянули остальных и только тогда узнали COUNT
                                 , COUNT (COALESCE (tmpMovement_add.PersonalId, tmpMovement_all.PersonalId)) :: TFloat AS CountPersonal
                            FROM tmpMovement_all
                                 LEFT JOIN tmpMovement_add ON tmpMovement_add.MovementId = tmpMovement_all.MovementId
                            WHERE tmpMovement_all.isStick = FALSE
                            GROUP BY tmpMovement_all.MovementId
                           )
         -- Строчная часть
       , tmpMI_all AS (SELECT MovementItem.MovementId   AS MovementId
                            , MovementItem.ObjectId     AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , COUNT (*) :: TFloat       AS CountMI_detail
                            , SUM (MovementItem.Amount) AS Amount
                       FROM MovementItem
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                       WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.MovementId FROM tmpMovement)
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                       GROUP BY MovementItem.MovementId
                              , MovementItem.ObjectId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                      )
         -- Строчная часть
       , tmpMI AS (SELECT tmpMI.MovementId           AS MovementId
                          -- Кол-во строк !!!ДЛЯ Комлектовщика!!!
                        , COUNT (*)        :: TFloat AS CountMI
                          -- Кол-во строк !!!ДЛЯ Пользователя - Кладовщик!!!
                        , SUM (tmpMI.CountMI_detail) AS CountMI_detail

                   FROM tmpMI_all AS tmpMI
                   GROUP BY tmpMI.MovementId
                  )
        -- Результат
        SELECT  tmp.InvNumber ::TVarChar
              , tmp.OperDate
              , DATE_TRUNC ('MONTH', tmp.OperDate):: TDateTime AS MonthDate
              , Movement_parent.OperDate  AS OperDate_parent
              , Movement_parent.InvNumber AS InvNumber_parent
              , tmp.UnitId
              , tmp.UnitCode
              , tmp.UnitName
              , tmp.PersonalId
              , tmp.PersonalCode
              , tmp.PersonalName
              , tmp.PositionId
              , tmp.PositionCode
              , tmp.PositionName
              , tmp.PositionLevelId
              , tmp.PositionLevelCode
              , tmp.PositionLevelName

              , tmp.MovementDescId          AS MovementDescId
              , MovementDesc.ItemName       AS MovementDescName
              , Object_BranchFrom.ValueData AS BranchFromName
              , Object_BranchTo.ValueData   AS BranchToName
              , Object_From.ValueData       AS FromName
              , Object_To.ValueData         AS ToName

              , SUM (tmp.TotalCount)        :: TFloat AS TotalCount
              , SUM (tmp.TotalCountKg)      :: TFloat AS TotalCountKg
              , SUM (tmp.CountMI)           :: TFloat AS CountMI
              , SUM (tmp.CountMovement)     :: TFloat AS CountMovement

              , SUM (tmp.TotalCount1)       :: TFloat AS TotalCount1
              , SUM (tmp.TotalCountKg1)     :: TFloat AS TotalCountKg1
              , SUM (tmp.CountMI1)          :: TFloat AS CountMI1
              , SUM (tmp.CountMovement1)    :: TFloat AS CountMovement1

              , SUM (tmp.TotalCountStick)   :: TFloat AS TotalCountStick

              , Object_Branch.ValueData AS BranchName

              , tmp.FromId
              , tmp.ToId

        FROM (-- ДЛЯ Комлектовщика
              SELECT CASE WHEN inIsDay = TRUE OR inisMovement = TRUE THEN tmpMovement_all.OperDate 
                          ELSE CASE WHEN inIsMonth = TRUE THEN DATE_TRUNC ('MONTH', tmpMovement_all.OperDate) 
                                    ELSE inEndDate
                               END
                     END ::TDateTime AS OperDate
                   , tmpMovement_all.InvNumber
                   , tmpMovement_all.MovementId_parent
                   , Object_Unit.Id             AS UnitId
                   , Object_Unit.ObjectCode     AS UnitCode
                   , Object_Unit.ValueData      AS UnitName
                   , Object_Personal.Id         AS PersonalId
                   , Object_Personal.ObjectCode AS PersonalCode
                   , Object_Personal.ValueData  AS PersonalName
                   , Object_Position.Id         AS PositionId
                   , Object_Position.ObjectCode AS PositionCode
                   , Object_Position.ValueData  AS PositionName
                   , Object_PositionLevel.Id         AS PositionLevelId
                   , Object_PositionLevel.ObjectCode AS PositionLevelCode
                   , Object_PositionLevel.ValueData  AS PositionLevelName

                   , CASE WHEN tmpMovement.CountPersonal > 0 THEN tmpMovement_all.TotalCount   / tmpMovement.CountPersonal :: TFloat ELSE tmpMovement_all.TotalCount   END AS TotalCount
                   , CASE WHEN tmpMovement.CountPersonal > 0 THEN tmpMovement_all.TotalCountKg / tmpMovement.CountPersonal :: TFloat ELSE tmpMovement_all.TotalCountKg END AS TotalCountKg
                   , CASE WHEN tmpMovement.CountPersonal > 0 THEN tmpMI.CountMI                / tmpMovement.CountPersonal :: TFloat ELSE tmpMI.CountMI                END AS CountMI
                   , CASE WHEN tmpMovement.CountPersonal > 0 THEN 1                            / tmpMovement.CountPersonal :: TFloat ELSE 1                            END AS CountMovement
                   -- , 1 AS CountMovement

                   , 0 AS TotalCount1
                   , 0 AS TotalCountKg1
                   , 0 AS CountMI1
                   , 0 AS CountMovement1

                   , 0 AS TotalCountStick

                   , tmpMovement_all.BranchId
                   , tmpMovement_all.FromId
                   , tmpMovement_all.ToId
                   , tmpMovement_all.MovementDescId

              FROM tmpMovement_all
                   INNER JOIN tmpPersonal_all               ON tmpPersonal_all.PersonalId = tmpMovement_all.PersonalId
                   LEFT JOIN Object AS Object_Unit          ON Object_Unit.Id             = tmpPersonal_all.UnitId
                   LEFT JOIN Object AS Object_Personal      ON Object_Personal.Id         = tmpPersonal_all.PersonalId
                   LEFT JOIN Object AS Object_Position      ON Object_Position.Id         = tmpPersonal_all.PositionId
                   LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id    = tmpPersonal_all.PositionLevelId
                   

                   INNER JOIN tmpMovement ON tmpMovement.MovementId = tmpMovement_all.MovementId
                   INNER JOIN tmpMI       ON tmpMI.MovementId       = tmpMovement_all.MovementId
              WHERE tmpMovement_all.isStick = FALSE

             UNION ALL
              -- ДЛЯ Пользователя - Кладовщик
              SELECT CASE WHEN inIsDay = TRUE OR inisMovement = TRUE THEN tmpMovement_all.OperDate
                          ELSE CASE WHEN inIsMonth = TRUE THEN DATE_TRUNC ('MONTH', tmpMovement_all.OperDate) 
                                    ELSE inEndDate
                               END
                     END ::TDateTime AS OperDate
                   , tmpMovement_all.InvNumber
                   , tmpMovement_all.MovementId_parent
                   , Object_Unit.Id             AS UnitId
                   , Object_Unit.ObjectCode     AS UnitCode
                   , Object_Unit.ValueData      AS UnitName
                   , Object_Personal.Id         AS PersonalId
                   , Object_Personal.ObjectCode AS PersonalCode
                   , Object_Personal.ValueData  AS PersonalName
                   , Object_Position.Id         AS PositionId
                   , Object_Position.ObjectCode AS PositionCode
                   , Object_Position.ValueData  AS PositionName
                   , Object_PositionLevel.Id         AS PositionLevelId
                   , Object_PositionLevel.ObjectCode AS PositionLevelCode
                   , Object_PositionLevel.ValueData  AS PositionLevelName

                   , 0 AS TotalCount
                   , 0 AS TotalCountKg
                   , 0 AS CountMI
                   , 0 AS CountMovement

                   , tmpMovement_all.TotalCount   AS TotalCount
                   , tmpMovement_all.TotalCountKg AS TotalCountKg
                   , tmpMI.CountMI_detail         AS CountMI1
                   , 1                            AS CountMovement1

                   , 0 AS TotalCountStick

                   , tmpMovement_all.BranchId
                   , tmpMovement_all.FromId
                   , tmpMovement_all.ToId
                   , tmpMovement_all.MovementDescId

              FROM (SELECT DISTINCT tmpMovement_all.MovementId
                                  , tmpMovement_all.MovementId_parent
                                  , tmpMovement_all.InvNumber
                                  , tmpMovement_all.OperDate
                                  , tmpMovement_all.UserId
                                  , tmpMovement_all.TotalCount
                                  , tmpMovement_all.TotalCountKg
                                  , tmpMovement_all.BranchId
                                  , tmpMovement_all.FromId
                                  , tmpMovement_all.ToId 
                                  , tmpMovement_all.MovementDescId
                    FROM tmpMovement_all
                    WHERE tmpMovement_all.isStick = FALSE
                    ) AS tmpMovement_all
                    LEFT JOIN tmpUser_findPersonal ON tmpUser_findPersonal.UserId = tmpMovement_all.UserId

                    LEFT JOIN Object AS Object_Unit          ON Object_Unit.Id             = tmpUser_findPersonal.UnitId
                    LEFT JOIN Object AS Object_Personal      ON Object_Personal.Id         = COALESCE (tmpUser_findPersonal.PersonalId, tmpMovement_all.UserId)
                    LEFT JOIN Object AS Object_Position      ON Object_Position.Id         = tmpUser_findPersonal.PositionId
                    LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id    = tmpUser_findPersonal.PositionLevelId

                    INNER JOIN tmpMI       ON tmpMI.MovementId       = tmpMovement_all.MovementId

              WHERE tmpUser_findPersonal.UserId > 0 OR inPersonalId = 0


             UNION ALL
              -- ДЛЯ Сотрудник - Стикеровщик
              SELECT CASE WHEN inIsDay = TRUE OR inisMovement = TRUE THEN tmpMovement_all.OperDate
                          ELSE CASE WHEN inIsMonth = TRUE THEN DATE_TRUNC ('MONTH', tmpMovement_all.OperDate) 
                                    ELSE inEndDate
                               END
                     END ::TDateTime AS OperDate
                   , tmpMovement_all.InvNumber
                   , tmpMovement_all.MovementId_parent
                   , Object_Unit.Id             AS UnitId
                   , Object_Unit.ObjectCode     AS UnitCode
                   , Object_Unit.ValueData      AS UnitName
                   , Object_Personal.Id         AS PersonalId
                   , Object_Personal.ObjectCode AS PersonalCode
                   , Object_Personal.ValueData  AS PersonalName
                   , Object_Position.Id         AS PositionId
                   , Object_Position.ObjectCode AS PositionCode
                   , Object_Position.ValueData  AS PositionName
                   , Object_PositionLevel.Id         AS PositionLevelId
                   , Object_PositionLevel.ObjectCode AS PositionLevelCode
                   , Object_PositionLevel.ValueData  AS PositionLevelName

                   , 0 AS TotalCount
                   , 0 AS TotalCountKg
                   , 0 AS CountMI
                   , 0 AS CountMovement

                   , 0 AS TotalCount1
                   , 0 AS TotalCountKg1
                   , 0 AS CountMI1
                   , 0 AS CountMovement1

                     -- Кол-во Упаковок (пакетов)
                   , CASE WHEN ObjectFloat_WeightTotal.ValueData <> 0
                               THEN CAST ((tmpMI.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END)
                                        / ObjectFloat_WeightTotal.ValueData AS NUMERIC (16, 0))
                          ELSE 0
                     END AS TotalCountStick

                   , tmpMovement_all.BranchId
                   , tmpMovement_all.FromId
                   , tmpMovement_all.ToId
                   , tmpMovement_all.MovementDescId

              FROM tmpMovement_all
                   INNER JOIN tmpPersonal_all               ON tmpPersonal_all.PersonalId = tmpMovement_all.PersonalId

                   LEFT JOIN Object AS Object_Unit          ON Object_Unit.Id             = tmpPersonal_all.UnitId
                   LEFT JOIN Object AS Object_Personal      ON Object_Personal.Id         = tmpPersonal_all.PersonalId
                   LEFT JOIN Object AS Object_Position      ON Object_Position.Id         = tmpPersonal_all.PositionId
                   LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id    = tmpPersonal_all.PositionLevelId

                   INNER JOIN tmpMI_all AS tmpMI ON tmpMI.MovementId       = tmpMovement_all.MovementId

                   -- Товар и Вид товара
                   LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId     = tmpMI.GoodsId
                                                         AND Object_GoodsByGoodsKind_View.GoodsKindId = tmpMI.GoodsKindId
                   -- вес в упаковке: "чистый" вес + вес 1-ого пакета
                   LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                         ON ObjectFloat_WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                        AND ObjectFloat_WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()

                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                   -- вес 1 шт, только для штучного товара, ???почему??? = вес в упаковке
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = tmpMI.GoodsId
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()
              WHERE tmpMovement_all.isStick = TRUE

            ) AS tmp

            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = tmp.BranchId

            LEFT JOIN Object AS Object_From   ON Object_From.Id   = tmp.FromId
            LEFT JOIN Object AS Object_To     ON Object_To.Id     = tmp.ToId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_BranchFrom
                                 ON ObjectLink_Unit_BranchFrom.ObjectId =  tmp.FromId
                                AND ObjectLink_Unit_BranchFrom.DescId   = zc_ObjectLink_Unit_Branch()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_BranchTo
                                 ON ObjectLink_Unit_BranchTo.ObjectId =  tmp.ToId
                                AND ObjectLink_Unit_BranchTo.DescId   = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_BranchFrom ON Object_BranchFrom.Id = ObjectLink_Unit_BranchFrom.ChildObjectId
            LEFT JOIN Object AS Object_BranchTo   ON Object_BranchTo.Id   = ObjectLink_Unit_BranchTo.ChildObjectId

            LEFT JOIN MovementDesc ON MovementDesc.Id   = tmp.MovementDescId
            LEFT JOIN Movement AS Movement_parent ON Movement_parent.Id = tmp.MovementId_parent

        GROUP BY tmp.OperDate
               , tmp.InvNumber
               , Movement_parent.OperDate
               , Movement_parent.InvNumber
               , tmp.UnitId
               , tmp.UnitCode
               , tmp.UnitName
               , tmp.PersonalId
               , tmp.PersonalCode
               , tmp.PersonalName
               , tmp.PositionId
               , tmp.PositionCode
               , tmp.PositionName
               , tmp.PositionLevelId
               , tmp.PositionLevelCode
               , tmp.PositionLevelName
               , Object_Branch.ValueData
               , tmp.FromId
               , tmp.ToId
               , Object_BranchFrom.ValueData
               , Object_BranchTo.ValueData
               , Object_From.ValueData
               , Object_To.ValueData
               , MovementDesc.ItemName
               , tmp.MovementDescId
                ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.23         *
 12.07.19         *
 17.12.18         * add PersonalComplete5
 26.11.17                                        * all
 15.12.15         * add Branch
 27.05.15         *
*/

-- тест
-- SELECT * FROM gpReport_PersonalComplete (inStartDate:= '01.10.2019', inEndDate:= '31.10.2019', inPersonalId:= 0, inPositionId:= 0, inBranchId:= 0, inIsDay:= FALSE, inIsDetail:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpReport_PersonalComplete (inStartDate:= '01.11.2024', inEndDate:= '02.11.2024', inPersonalId:= 0, inPositionId:= 0, inBranchId:= 0, inIsDay:= FALSE, inIsMonth:= True, inIsDetail:= FALSE, inSession:= zfCalc_UserAdmin())
