-- Function: gpInsertUpdate_Movement_TestingTuning()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TestingTuning(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inTimeTest            Integer   , -- ����� �� ���� (���)
    IN inTimeTestStorekeeper Integer   , -- ����� �� ���� ��������� (���) 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession::Integer;
	 
     -- ��������� <��������>
     -- ��������� ������ ����������� � ������� ������    
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin()))
    THEN
      RAISE EXCEPTION '��� ��������� �������� ��������� ������������';
    END IF;
    
    
    ioId := lpInsertUpdate_Movement_TestingTuning (ioId                   := ioId
                                                 , inInvNumber            := inInvNumber
                                                 , inOperDate             := inOperDate
                                                 , inTimeTest             := inTimeTest
                                                 , inTimeTestStorekeeper  := inTimeTestStorekeeper
                                                 , inComment              := inComment
                                                 , inUserId               := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_TestingTuning (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.07.21                                                       *
 */

-- ����
-- select * from gpInsertUpdate_Movement_TestingTuning(ioId := 23977600 , inInvNumber := '1' , inOperDate := ('06.07.2021')::TDateTime , inTimeTest := 250 , inTimeTestStorekeeper := 60 , inComment := '' ,  inSession := '3');