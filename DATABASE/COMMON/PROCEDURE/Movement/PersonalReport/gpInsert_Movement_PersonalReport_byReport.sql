-- Function: gpInsert_Movement_PersonalReport_byReport()

DROP FUNCTION IF EXISTS gpInsert_Movement_PersonalReport_byReport (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_PersonalReport_byReport(
    IN inOperDate        TDateTime  ,  -- 
    IN inSession         TVarChar      -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
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
   PERFORM lpInsertUpdate_Movement_PersonalReport(ioId                := 0                            :: Integer   -- ���� ������� <��������>
                                                , inInvNumber         := CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar)       :: TVarChar   -- ����� ���������
                                                , inOperDate          := inOperDate                   :: TDateTime  -- ���� ���������
                                                , inAmount            := tmpReport.EndAmount          :: TFloat     -- ����� ��������
                                                , inComment           := ''                           :: TVarChar   -- ����������
                                                , inMemberId          := tmpReport.MemberId           :: Integer   
                                                , inInfoMoneyId       := 0                            :: Integer    -- ������ ����������
                                                , inContractId        := 0                            :: Integer    -- ��������
                                                , inUnitId            := 0                            :: Integer   
                                                , inMoneyPlaceId      := tmpReport.MoneyPlaceId       :: Integer   
                                                , inCarId             := 0                            :: Integer   
                                                , inUserId            := vbUserId                     :: Integer    -- ������������
                                                )
   FROM tmpReport;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.05.21         *
 */

-- ����
--