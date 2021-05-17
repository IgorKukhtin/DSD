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

   CREATE TEMP TABLE tmpReport (MemberId Integer, MoneyPlaceId Integer, EndAmount TFloat) ON COMMIT DROP;
     INSERT INTO tmpReport (MemberId, MoneyPlaceId, EndAmount)
        SELECT tmp.MemberId
             , tmp.MoneyPlaceId
             , tmp.EndAmount
        FROM gpReport_Member(inStartDate := inOperDate ::TDateTime
                           , inEndDate   := inOperDate ::TDateTime
                           , inAccountId := 0
                           , inBranchId  := 0
                           , inInfoMoneyId      := 0
                           , inInfoMoneyGroupId := 0
                           , inInfoMoneyDestinationId := 0
                           , inMemberId  := 0
                           , inSession   := inSession) AS tmp
        WHERE COALESCE (tmp.EndAmount,0) <> 0;

   --
   PERFORM lpInsertUpdate_Movement_PersonalReport(ioId                := 0                            :: Integer   -- Ключ объекта <Документ>
                                                , inInvNumber         := CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar)       :: TVarChar   -- Номер документа
                                                , inOperDate          := inOperDate                   :: TDateTime  -- Дата документа
                                                , inAmount            := tmpReport.EndAmount          :: TFloat     -- Сумма операции
                                                , inComment           := ''                           :: TVarChar   -- Примечание
                                                , inMemberId          := tmpReport.MemberId           :: Integer   
                                                , inInfoMoneyId       := 0                            :: Integer    -- Статьи назначения
                                                , inContractId        := 0                            :: Integer    -- Договора
                                                , inUnitId            := 0                            :: Integer   
                                                , inMoneyPlaceId      := tmpReport.MoneyPlaceId       :: Integer   
                                                , inCarId             := 0                            :: Integer   
                                                , inUserId            := vbUserId                     :: Integer    -- пользователь
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