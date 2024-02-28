-- Function: gpInsertUpdate_Movement_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalGroupSummAdd (Integer, TVarChar, TDateTime, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalGroupSummAdd(                               
 INOUT ioId                     Integer   , -- ���� ������� <��������>
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� ��������� 
    IN inNormHour               TFloat    , --NormHour
    IN inComment                TVarChar  , -- ����������
    IN inPersonalServiceListId  Integer   , -- 
    IN inUnitId                 Integer   , -- 
    IN inPersonalGroupId        Integer   , -- 
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalGroupSummAdd());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- �������������� ���� ��������� - ����� ���������� = ������ ����� ������
     inOperDate:= DATE_TRUNC ('MONTH', inOperDate);

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalGroupSummAdd(), inInvNumber, inOperDate, Null);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalGroup(), ioId, inPersonalGroupId);
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_NormHour(), ioId, inNormHour);
     
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.02.24         *
*/

-- ����
--