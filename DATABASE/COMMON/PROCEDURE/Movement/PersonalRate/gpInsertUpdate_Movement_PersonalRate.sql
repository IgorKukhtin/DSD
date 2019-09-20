-- Function: gpInsertUpdate_Movement_PersonalRate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalRate (Integer, TVarChar, TDateTime, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PersonalRate (Integer, TVarChar, TDateTime, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PersonalRate(
 INOUT ioId                     Integer   , -- ���� ������� <��������>
    IN inInvNumber              TVarChar  , -- ����� ���������
    IN inOperDate               TDateTime , -- ���� ���������
    IN inComment                TVarChar  , -- ����������
    IN inPersonalServiceListId  Integer   , --
    IN inSession                TVarChar    -- ������ ������������
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PersonalRate());

     -- ��������
     IF inOperDate <> DATE_TRUNC ('day', inOperDate)
     THEN
         RAISE EXCEPTION '������.�������� ������ ����.';
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PersonalRate(), inInvNumber, inOperDate, Null);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalServiceList(), ioId, inPersonalServiceListId);

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
 20.09.19          *
*/

-- ����
--select * from gpInsertUpdate_Movement_PersonalRate(ioId := 0 , inInvNumber := '4'::TVarChar , inOperDate := ('30.09.2019')::TDateTime , inComment := ''::TVarChar , inPersonalServiceListId := 0 ,  inSession := '5'::TVarChar);