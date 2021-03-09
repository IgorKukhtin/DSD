-- Function: gpInsertUpdate_Movement_ProfitLossResult()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossResult (Integer, TVarChar, TDateTime, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossResult(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inAccountId           Integer   , -- 
    IN inisCorrective        Boolean   , -- 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossResult());

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ProfitLossResult (ioId           := ioId
                                                     , inInvNumber    := inInvNumber
                                                     , inOperDate     := inOperDate
                                                     , inAccountId    := inAccountId
                                                     , inisCorrective := inisCorrective
                                                     , inComment      := inComment
                                                     , inUserId       := vbUserId
                                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.03.21         *
*/

-- ����
--