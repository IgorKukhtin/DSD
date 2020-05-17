-- Function: gpInsertUpdate_Movement_PUSH()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PUSH (Integer, TVarChar, TDateTime, TDateTime, Integer, Boolean, TBlob, TVarChar, Boolean, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PUSH(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inDateEndPUSH           TDateTime  ,
    IN inReplays               Integer    , -- ���������� ��������  
    IN inDaily                 Boolean    , -- ����. ���������
    IN inMessage               TBlob      , -- ���������
    IN inFunction              TVarChar   , -- �������
    IN inisPoll                Boolean    , -- �����
    IN inisPharmacist          Boolean    , -- ������ �����������
    IN inRetailId              Integer    , -- ������ ��� �������� ���� 
    IN inForm                  TVarChar   , -- ��������� ����� ���� ������� ���������� �� �����
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_UnnamedEnterprises());
    vbUserId := inSession;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_PUSH (ioId              := ioId
                                        , inInvNumber       := inInvNumber
                                        , inOperDate        := inOperDate
                                        , inDateEndPUSH     := inDateEndPUSH
                                        , inReplays         := inReplays 
                                        , inDaily           := inDaily 
                                        , inMessage         := inMessage
                                        , inFunction        := inFunction
                                        , inisPoll          := inisPoll
                                        , inisPharmacist    := inisPharmacist
                                        , inRetailId        := inRetailId
                                        , inForm            := inForm
                                        , inUserId          := vbUserId
                                        );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������ �.�.
 05.03.20        *
 19.02.20        *
 11.05.19        *
 13.03.19        *
 10.03.19        *
*/