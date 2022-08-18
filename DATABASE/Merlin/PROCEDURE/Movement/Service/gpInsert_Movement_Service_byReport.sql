--
DROP FUNCTION IF EXISTS gpInsert_Movement_Service_byReport (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Service_byReport(
    IN inOperDate             TDateTime,     -- 
    IN inServiceDate          TDateTime,     --
    IN inUnitId               Integer,
    IN inInfoMoneyId          Integer,
    IN inSession              TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   --
   RAISE EXCEPTION '������.��� ����.';

   --�������� ���������� ���������� �� ������ �������������
   PERFORM lpInsertUpdate_Movement_Service (ioId                   := 0
                                          , inInvNumber            := CAST (NEXTVAL ('movement_service_seq') AS TVarChar)
                                          , inOperDate             := CURRENT_DATE ::TDateTime --inOperDate
                                          , inServiceDate          := DATE_TRUNC ('Month', inServiceDate) ::TDateTime
                                          , inAmount               := tmpOH_ServiceItem.Value
                                          , inUnitId               := tmpOH_ServiceItem.UnitId
                                          , inInfoMoneyId          := tmpOH_ServiceItem.InfoMoneyId
                                          , inCommentInfoMoneyId   := tmpOH_ServiceItem.CommentInfoMoneyId
                                          , inUserId               := vbUserId
                                           )
   FROM gpSelect_ObjectHistory_ServiceItem(inUnitId := inUnitId , inInfoMoneyId := inInfoMoneyId ,  inSession := inSession) AS tmpOH_ServiceItem
   WHERE tmpOH_ServiceItem.StartDate <= inServiceDate
     AND tmpOH_ServiceItem.EndDate   >= inServiceDate
     AND COALESCE (tmpOH_ServiceItem.Value,0) <> 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.04.22          *
*/

-- ����
--          52595 