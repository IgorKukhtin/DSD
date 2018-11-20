-- Function: gpInsertUpdate_Movement_ReportUnLiquid()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReportUnLiquid_Auto (Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReportUnLiquid_Auto (
 INOUT ioId                  Integer   ,
    IN inStartSale           TDateTime , -- ���� ������ ������
    IN inEndSale             TDateTime , -- ���� ��������� ������
    IN inUnitId              Integer   , -- ����������� ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReportUnLiquid());
     vbUserId := inSession;

     -- 
     ioId := lpInsertUpdate_Movement_ReportUnLiquid (ioId         := COALESCE (ioId, 0) :: Integer
                                                   , inInvNumber  := CAST (NEXTVAL ('movement_ReportUnLiquid_seq') AS TVarChar)
                                                   , inOperDate   := CURRENT_DATE       :: TDateTime
                                                   , inStartSale  := inStartSale
                                                   , inEndSale    := inEndSale
                                                   , inUnitId     := inUnitId
                                                   , inComment    := ''                 ::TVarChar
                                                   , inUserId     := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.18         *
*/

-- ����
--