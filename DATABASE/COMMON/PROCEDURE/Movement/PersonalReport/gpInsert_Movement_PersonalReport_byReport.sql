-- Function: gpInsert_Movement_PersonalReport_byReport()

DROP FUNCTION IF EXISTS gpInsert_Movement_PersonalReport_byReport (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PersonalReport_byReport(
    IN inOperDate        TDateTime  ,  --
    IN inSession         TVarChar      -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
      vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Movement_PersonalReport_byReport());

      -- 
      CREATE TEMP TABLE tmpReport (ContainerId Integer, MemberId Integer, InfoMoneyId Integer, CarId Integer, EndAmount TFloat) ON COMMIT DROP;
      WITH tmpContainer AS (SELECT CLO_Member.ContainerId AS ContainerId
                                 , Container.Amount
                                 , COALESCE (ObjectLink_Personal_Member_find.ChildObjectId, CLO_Member.ObjectId) AS MemberId
                                 , CLO_InfoMoney.ObjectId AS InfoMoneyId
                                 , CLO_Car.ObjectId       AS CarId
                            FROM ContainerLinkObject AS CLO_Member
                                 INNER JOIN Container ON Container.Id = CLO_Member.ContainerId AND Container.DescId = zc_Container_Summ()

                                 LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                               ON CLO_InfoMoney.ContainerId = Container.Id
                                                              AND CLO_InfoMoney.DescId      = zc_ContainerLinkObject_InfoMoney()

                                 LEFT JOIN ContainerLinkObject AS CLO_Car
                                                               ON CLO_Car.ContainerId = Container.Id
                                                              AND CLO_Car.DescId = zc_ContainerLinkObject_Car()

                                 LEFT JOIN ObjectLink AS ObjectLink_Account_AccountDirection
                                                      ON ObjectLink_Account_AccountDirection.ObjectId = Container.ObjectId
                                                     AND ObjectLink_Account_AccountDirection.DescId   = zc_ObjectLink_Account_AccountDirection()
                                 LEFT JOIN ObjectLink AS ObjectLink_Personal_Member_find
                                                      ON ObjectLink_Personal_Member_find.ObjectId = CLO_Member.ObjectId
                                                     AND ObjectLink_Personal_Member_find.DescId   = zc_ObjectLink_Personal_Member()

                            WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
                              AND ObjectLink_Account_AccountDirection.ChildObjectId = zc_Enum_AccountDirection_30500() -- сотрудники (подотчетные лица)
                              AND Container.ObjectId <> zc_Enum_Account_30510()
                           )
          , tmpReport AS (SELECT tmpContainer.ContainerId
                               , tmpContainer.MemberId
                               , tmpContainer.InfoMoneyId
                               , tmpContainer.CarId
                               , tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) AS EndAmount
                          FROM tmpContainer
                               LEFT JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.ContainerId = tmpContainer.ContainerId
                                                              AND MIContainer.OperDate    > inOperDate
                          GROUP BY tmpContainer.ContainerId, tmpContainer.Amount, tmpContainer.MemberId, tmpContainer.InfoMoneyId, tmpContainer.CarId
                          HAVING tmpContainer.Amount - COALESCE(SUM (MIContainer.Amount), 0) <> 0
                         )
      --
      INSERT INTO tmpReport (ContainerId, MemberId, InfoMoneyId, CarId, EndAmount)
         SELECT tmpReport.ContainerId
              , tmpReport.MemberId
              , tmpReport.InfoMoneyId
              , tmpReport.CarId
              , tmpReport.EndAmount
         FROM tmpReport
        ;

    --
    PERFORM lpInsertUpdate_Movement_PersonalReport(ioId                := 0
                                                 , inInvNumber         := CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar)       :: TVarChar   -- Номер документа
                                                 , inOperDate          := inOperDate
                                                 , inAmount            := -1 * tmpReport.EndAmount
                                                 , inComment           := 'взаимозачет'
                                                 , inMemberId          := tmpReport.MemberId
                                                 , inInfoMoneyId       := tmpReport.InfoMoneyId
                                                 , inMoneyPlaceId      := tmpReport.MemberId
                                                 , inCarId             := tmpReport.CarId
                                                 , inContainerId       := tmpReport.ContainerId
                                                 , inUserId            := vbUserId
                                                  )
    FROM tmpReport;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.05.21         *
 */

-- тест
--
