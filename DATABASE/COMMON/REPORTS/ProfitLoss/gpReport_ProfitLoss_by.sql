-- Function: gpReport_ProfitLoss_by()

DROP FUNCTION IF EXISTS gpReport_ProfitLoss_by (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ProfitLoss_by(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate           TDateTime
            , Month               TDateTime
            , MovementId          Integer
            , MovementDescName    TVarChar
            , InvNumber           Integer
            , Comment             TVarChar
            , ProfitLossId        Integer
            , ProfitLossGroupName     TVarChar
            , ProfitLossDirectionName TVarChar
            , ProfitLossCode          Integer
            , ProfitLossName          TVarChar
            , BusinessId          Integer
            , BusinessName        TVarChar
            , BranchId_pl         Integer
            , BranchName_pl       TVarChar
            , UnitId_pl           Integer
            , UnitName_pl         TVarChar
            , Unit_plDescName     TVarChar
            , CFOId Integer, CFOName TVarChar
            , DepartmentId Integer, DepartmentName TVarChar
            , Department_twoId Integer, Department_twoName TVarChar
            , InfoMoneyId               Integer
            , InfoMoneyGroupCode        Integer
            , InfoMoneyDestinationCode  Integer
            , InfoMoneyCode             Integer
            , InfoMoneyGroupName        TVarChar
            , InfoMoneyDestinationName  TVarChar
            , InfoMoneyName             TVarChar
            , UnitId              Integer
            , UnitName            TVarChar
            , AssetId             Integer
            , AssetName           TVarChar
            , CarId               Integer
            , CarName             TVarChar
            , MemberId            Integer
            , MemberCode          Integer
            , MemberName          TVarChar
            , ArticleLossId       Integer
            , ArticleLossName     TVarChar
            , DirectionId         Integer
            , DirectionName       TVarChar
            , DirectionDescName   TVarChar
            , DestinationId       Integer
            , DestinationName     TVarChar
            , DestinationDescName TVarChar
            , FromId              Integer
            , FromName            TVarChar
            , FromDescName        TVarChar
            , ToId                Integer
            , ToName              TVarChar
            , ToDescName          TVarChar
            , GoodsId             Integer
            , GoodsCode           Integer
            , GoodsName           TVarChar
            , GoodsKindId         Integer
            , GoodsKindName       TVarChar
            , GoodsKindId_gp      Integer
            , GoodsKindName_gp    TVarChar
            , OperCount           TFloat
            , OperCount_sh        TFloat
            , OperSumm            TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUserRole_8813637 Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_ProfitLoss());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- !!!Проверка прав роль - Ограничение - нет вообще доступа к просмотру данных ЗП!!!
     vbIsUserRole_8813637:= /*EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 8813637)
                         -- или если Ограничение - нет доступа к просмотру ведомость Админ ЗП
                         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 11026035)
                            */
                         -- Разрешение ОПиУ - есть доступ к просмотру ведомость Админ ЗП14:50 18.11.2025
                         NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 12966257)
                         AND vbUserId NOT IN (5)
                           ;

     -- Ограниченние - нет доступа к ОПиУ
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657330)
        OR vbIsUserRole_8813637 = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав к отчету ОПиУ-BI.';
     END IF;

     /*
     -- Блокируем ему просмотр
     IF vbUserId = 9457 -- Климентьев К.И.
     THEN
         vbUserId:= NULL;
         RETURN;
     END IF; */


     -- Результат
     RETURN QUERY
     WITH
     tmpData AS (
                 SELECT
                       -- Id партии
                         CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.ContainerId_pl END ::Integer AS ContainerId_pl
                       -- Дата
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN DATE_TRUNC ('MONTH', tmp.OperDate) ELSE tmp.OperDate END ::TDateTime AS OperDate
                       -- Id документа
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.MovementId END ::Integer AS MovementId
                       -- Вид документа
                       , tmp.MovementDescId      ::Integer
                       -- № документа
                       , tmp.InvNumber           ::Integer
                       -- Примечание документ
                       , tmp.MovementId_comment  ::Integer
                       -- Статья ОПиУ
                       , tmp.ProfitLossId        ::Integer
                       -- Бизнес
                       , tmp.BusinessId         ::Integer
                       -- Филиал затрат (Філія)
                       , tmp.BranchId_pl         ::Integer
                       -- Подразделение затрат (Підрозділ)
                       , tmp.UnitId_pl           ::Integer
                       -- Статья УП
                       , tmp.InfoMoneyId         ::Integer
                       -- Подразделение учета (Місце обліку)
                       , tmp.UnitId              ::Integer
                       -- Оборудование (Направление затрат)
                       , tmp.AssetId             ::Integer
                       -- Автомобиль (Направление затрат, место учета)
                       , tmp.CarId               ::Integer
                       -- Физ лицо
                       , CASE WHEN vbUserId IN (5, 9457, 6604558, 2573318) THEN tmp.MemberId ELSE 0 END ::Integer AS MemberId 
                       -- Статья списания (Стаття списання, Направление затрат)
                       , tmp.ArticleLossId       ::Integer
                       -- Об'єкт напрявлення
                       , tmp.DirectionId         ::Integer
                       -- Об'єкт призначення
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 WHEN vbUserId IN (5, 9457, 6604558, 2573318) THEN tmp.DestinationId ELSE 0 END ::Integer AS DestinationId
                       -- От кого (место учета) - информативно
                       , tmp.FromId              ::Integer
                       -- Кому (место учета, Направление затрат) - информативно
                       , tmp.ToId                ::Integer

                       -- Товар
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsId END        ::Integer AS GoodsId
                       -- Вид Товара
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsKindId END    ::Integer AS GoodsKindId
                       -- Вид Товара (только при производстве сырой ПФ)
                       , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsKindId_gp END ::Integer AS GoodsKindId_gp

                       -- Кол-во (вес)
                       , SUM (tmp.OperCount)           ::TFloat AS OperCount
                       -- Кол-во (шт.)
                       , SUM (tmp.OperCount_sh)        ::TFloat AS OperCount_sh
                       -- Сумма
                       , SUM (tmp.OperSumm)            ::TFloat AS OperSumm

                 FROM _bi_Table_ProfitLoss AS tmp
                      LEFT JOIN Object AS Object_ProfitLoss ON Object_ProfitLoss.Id     = tmp.ProfitLossId
                 WHERE tmp.OperDate BETWEEN inStartDate AND inEndDate
                 GROUP BY -- Id партии
                           CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.ContainerId_pl END
                         -- Дата
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN DATE_TRUNC ('MONTH', tmp.OperDate) ELSE tmp.OperDate END
                         -- Id документа
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.MovementId END
                         -- Вид документа
                         , tmp.MovementDescId
                         -- № документа
                         , tmp.InvNumber
                         -- Примечание документ
                         , tmp.MovementId_comment
                         -- Статья ОПиУ
                         , tmp.ProfitLossId
                         -- Бизнес
                         , tmp.BusinessId
                         -- Филиал затрат (Філія)
                         , tmp.BranchId_pl
                         -- Подразделение затрат (Підрозділ)
                         , tmp.UnitId_pl
                         -- Статья УП
                         , tmp.InfoMoneyId
                         -- Подразделение учета (Місце обліку)
                         , tmp.UnitId
                         -- Оборудование (Направление затрат)
                         , tmp.AssetId
                         -- Автомобиль (Направление затрат, место учета)
                         , tmp.CarId
                         -- Физ лицо
                         , CASE WHEN vbUserId IN (5, 9457, 6604558, 2573318) THEN tmp.MemberId ELSE 0 END
                         -- Статья списания (Стаття списання, Направление затрат)
                         , tmp.ArticleLossId
                          -- Об'єкт напрявлення
                         , tmp.DirectionId
                         -- Об'єкт призначення
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 WHEN vbUserId IN (5, 9457, 6604558, 2573318) THEN tmp.DestinationId ELSE 0 END
                         -- От кого (место учета) - информативно
                         , tmp.FromId
                         -- Кому (место учета, Направление затрат) - информативно
                         , tmp.ToId

                         -- Товар
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsId END
                         -- Вид Товара
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsKindId END
                         -- Вид Товара (только при производстве сырой ПФ)
                         , CASE WHEN Object_ProfitLoss.ObjectCode < 11100 THEN 0 ELSE tmp.GoodsKindId_gp END
                 )
   , tmpMovementString AS (SELECT MovementString.*
                           FROM MovementString
                           WHERE MovementString.DescId = zc_MovementString_Comment()
                             AND MovementString.MovementId IN (SELECT DISTINCT tmpData.MovementId_comment FROM tmpData)
                           )

   , tmpObjectLink AS (SELECT ObjectLink.*
                       FROM ObjectLink
                       WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.UnitId_pl FROM tmpData)
                         AND ObjectLink.DescId IN (zc_ObjectLink_Unit_CFO()
                                                 , zc_ObjectLink_Unit_Department()
                                                 , zc_ObjectLink_Unit_Department_two()
                                                 )
                       )

       SELECT -- Дата
              tmp.OperDate            ::TDateTime
            -- месяц
            , DATE_TRUNC ('MONTH', tmp.OperDate) ::TDateTime  AS Month
            -- Id документа
            , tmp.MovementId          ::Integer
            -- Вид документа
            , MovementDesc.ItemName    ::TVarChar AS MovementDescName
            -- № документа
            , tmp.InvNumber           ::Integer
            -- Примечание документ
            , MovementString_Commet.ValueData  ::TVarChar AS Comment
            -- Статья ОПиУ
            , tmp.ProfitLossId                        ::Integer  AS ProfitLossId
            , View_ProfitLoss.ProfitLossGroupName     ::TVarChar
            , View_ProfitLoss.ProfitLossDirectionName ::TVarChar
            , View_ProfitLoss.ProfitLossCode          ::Integer
            , View_ProfitLoss.ProfitLossName          ::TVarChar
            -- Бизнес
            , tmp.BusinessId            ::Integer  AS BusinessId
            , Object_Business.ValueData ::TVarChar AS BusinessName
            -- Филиал затрат (Філія)
            , tmp.BranchId_pl            ::Integer  AS BranchId_pl
            , Object_Branch_pl.ValueData ::TVarChar AS BranchName_pl
            -- Подразделение затрат (Підрозділ)
            , tmp.UnitId_pl            ::Integer  AS UnitId_pl
            , Object_Unit_pl.ValueData ::TVarChar AS UnitName_pl
            , ObjectDesc_Unit_pl.ItemName ::TVarChar AS Unit_plDescName
            , Object_CFO.Id              ::Integer   AS CFOId
            , Object_CFO.ValueData       ::TVarChar  AS CFOName
            , Object_Department.Id                   AS DepartmentId
            , Object_Department.ValueData            AS DepartmentName
            , Object_Department_two.Id               AS Department_twoId
            , Object_Department_two.ValueData        AS Department_twoName

            -- Статья УП
            , tmp.InfoMoneyId                          ::Integer
            , View_InfoMoney.InfoMoneyGroupCode        ::Integer
            , View_InfoMoney.InfoMoneyDestinationCode  ::Integer
            , View_InfoMoney.InfoMoneyCode             ::Integer
            , View_InfoMoney.InfoMoneyGroupName        ::TVarChar
            , View_InfoMoney.InfoMoneyDestinationName  ::TVarChar
            , View_InfoMoney.InfoMoneyName             ::TVarChar
            -- Подразделение учета (Місце обліку)
            , tmp.UnitId              ::Integer  AS UnitId
            , Object_Unit.ValueData   ::TVarChar AS UnitName
            -- Оборудование (Направление затрат)
            , tmp.AssetId             ::Integer  AS AssetId
            , Object_Asset.ValueData  ::TVarChar AS AssetName
            -- Автомобиль (Направление затрат, место учета)
            , tmp.CarId               ::Integer  AS CarId
            , Object_Car.ValueData    ::TVarChar AS CarName
            -- Физ лицо
            , tmp.MemberId             ::Integer  AS MemberId
            , Object_Member.ObjectCode ::Integer  AS MemberCode
            , Object_Member.ValueData  ::TVarChar AS MemberName
            -- Статья списания (Стаття списання, Направление затрат)
            , tmp.ArticleLossId            ::Integer  AS ArticleLossId
            , Object_ArticleLoss.ValueData ::TVarChar AS ArticleLossName
            -- Об'єкт напрявлення
            , tmp.DirectionId               ::Integer  AS DirectionId
            , Object_Direction.ValueData    ::TVarChar AS DirectionName
            , ObjectDesc_Direction.ItemName ::TVarChar AS DirectionDescName
            -- Об'єкт призначення
            , tmp.DestinationId               ::Integer  AS DestinationId
            , Object_Destination.ValueData    ::TVarChar AS DestinationName
            , ObjectDesc_Destination.ItemName ::TVarChar AS DestinationDescName
            -- От кого (место учета) - информативно
            , tmp.FromId               ::Integer  AS FromId
            , Object_From.ValueData    ::TVarChar AS FromName
            , ObjectDesc_From.ItemName ::TVarChar AS DescName_From
            -- Кому (место учета, Направление затрат) - информативно
            , tmp.ToId               ::Integer  AS ToId
            , Object_To.ValueData    ::TVarChar AS ToName
            , ObjectDesc_To.ItemName ::TVarChar AS DescName_To
            -- Товар
            , tmp.GoodsId             ::Integer  AS GoodsId
            , Object_Goods.ObjectCode ::Integer  AS GoodsCode
            , Object_Goods.ValueData  ::TVarChar AS GoodsName
            -- Вид Товара
            , tmp.GoodsKindId            ::Integer  AS GoodsKindId
            , Object_GoodsKind.ValueData ::TVarChar AS GoodsKindName
            -- Вид Товара (только при производстве сырой ПФ)
            , tmp.GoodsKindId_gp            ::Integer  AS GoodsKindId_gp
            , Object_GoodsKind_gp.ValueData ::TVarChar AS GoodsKindName_gp

            -- Кол-во (вес)
            , tmp.OperCount           ::TFloat
            -- Кол-во (шт.)
            , tmp.OperCount_sh        ::TFloat
            -- Сумма
            , tmp.OperSumm            ::TFloat

       FROM tmpData AS tmp
            LEFT JOIN MovementDesc ON MovementDesc.Id = tmp.MovementDescId
            LEFT JOIN Object_ProfitLoss_View AS View_ProfitLoss ON View_ProfitLoss.ProfitLossId = tmp.ProfitLossId
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = tmp.BusinessId
            LEFT JOIN Object AS Object_Branch_pl ON Object_Branch_pl.Id = tmp.BranchId_pl

            LEFT JOIN Object AS Object_Unit_pl ON Object_Unit_pl.Id = tmp.UnitId_pl
            LEFT JOIN ObjectDesc AS ObjectDesc_Unit_pl ON ObjectDesc_Unit_pl.Id = Object_Unit_pl.DescId

            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = tmp.InfoMoneyId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmp.UnitId
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = tmp.AssetId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmp.CarId
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmp.MemberId
            LEFT JOIN Object AS Object_ArticleLoss ON Object_ArticleLoss.Id = tmp.ArticleLossId

            LEFT JOIN Object AS Object_Direction ON Object_Direction.Id = tmp.DirectionId
            LEFT JOIN ObjectDesc AS ObjectDesc_Direction ON ObjectDesc_Direction.Id = Object_Direction.DescId

            LEFT JOIN Object AS Object_Destination ON Object_Destination.Id = tmp.DestinationId
            LEFT JOIN ObjectDesc AS ObjectDesc_Destination ON ObjectDesc_Destination.Id = Object_Destination.DescId

            LEFT JOIN Object AS Object_From ON Object_From.Id = tmp.FromId
            LEFT JOIN ObjectDesc AS ObjectDesc_From ON ObjectDesc_From.Id = Object_From.DescId

            LEFT JOIN Object AS Object_To ON Object_To.Id = tmp.ToId
            LEFT JOIN ObjectDesc AS ObjectDesc_To ON ObjectDesc_To.Id = Object_To.DescId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmp.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmp.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind_gp ON Object_GoodsKind_gp.Id = tmp.GoodsKindId_gp

            LEFT JOIN tmpMovementString AS MovementString_Commet
                                        ON MovementString_Commet.MovementId = tmp.MovementId_comment
                                       AND MovementString_Commet.DescId = zc_MovementString_Comment()

            LEFT JOIN tmpObjectLink AS ObjectLink_Unit_CFO
                                 ON ObjectLink_Unit_CFO.ObjectId = Object_Unit_pl.Id
                                AND ObjectLink_Unit_CFO.DescId = zc_ObjectLink_Unit_CFO()
            LEFT JOIN Object AS Object_CFO ON Object_CFO.Id = ObjectLink_Unit_CFO.ChildObjectId

            LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Department
                                 ON ObjectLink_Unit_Department.ObjectId = Object_Unit_pl.Id
                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
            LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId

            LEFT JOIN tmpObjectLink AS ObjectLink_Unit_Department_two
                                 ON ObjectLink_Unit_Department_two.ObjectId = Object_Unit_pl.Id
                                AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
            LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId
       ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.25         *
*/

-- тест
-- SELECT * FROM gpReport_ProfitLoss_by (inStartDate:= '04.09.2025', inEndDate:= '04.09.2025', inSession:= '5')