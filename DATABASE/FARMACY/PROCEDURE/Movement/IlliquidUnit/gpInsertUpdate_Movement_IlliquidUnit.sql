-- Function: gpInsertUpdate_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_IlliquidUnit(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inUnitId              Integer   , -- �������������
    IN inDayCount            Integer   , -- ���� ��� ������ ��
    IN inProcGoods           TFloat    , -- % ������� ��� ���. 
    IN inProcUnit            TFloat    , -- % ���. �� ������. 
    IN inPenalty             TFloat    , -- ����� �� 1% �����. 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; -- lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_IlliquidUnit());
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_IlliquidUnit (ioId               := ioId
                                                 , inInvNumber        := inInvNumber
                                                 , inOperDate         := inOperDate
                                                 , inUnitId           := inUnitId
                                                 , inDayCount         := inDayCount
                                                 , inProcGoods        := inProcGoods
                                                 , inProcUnit         := inProcUnit
                                                 , inPenalty          := inPenalty
                                                 , inComment          := inComment
                                                 , inUserId           := vbUserId
                                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_IlliquidUnit (Integer, TVarChar, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.19                                                       *
*/