-- Function: lpInsertUpdate_Movement_HospitalDoc_1C ()

--DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_HospitalDoc_1C (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_HospitalDoc_1C (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_HospitalDoc_1C(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inServiceDate         TDateTime   , -- 
    IN inStartStop           TDateTime  , -- 
    IN inEndStop             TDateTime   , --
    IN inPersonalId          Integer   , -- 
    IN inCode1C              TVarChar  , -- 
    IN inINN                 TVarChar  , -- 
    IN inFIO                 TVarChar  , -- 
    IN inComment             TVarChar  , -- 
    --IN inError               TVarChar  , -- 
    IN inInvNumberPartner    TVarChar  , -- 
    IN inInvNumberHospital   TVarChar  , -- 
    IN inNumHospital         TVarChar  , -- 
    IN inSummStart           TFloat  , -- 
    IN inSummPF              TFloat  , -- 
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- ���������� ���� �������
     --vbAccessKeyId:= lpGetAccessKey (inUserId, zc_Enum_Process_InsertUpdate_Movement_HospitalDoc_1C());
     --vbUserId:= lpGetUserBySession (inSession);

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_HospitalDoc_1C(), inInvNumber, inOperDate, NULL);

     -- ������ - 1-�� ����� ������
     inServiceDate:= DATE_TRUNC ('MONTH', inServiceDate);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), ioId, inServiceDate);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartStop(), ioId, inStartStop);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndStop(), ioId, inEndStop);
 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Code1C(), ioId, inCode1C); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_INN(), ioId, inINN); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_FIO(), ioId, inFIO); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment); 
     -- ��������� �������� <>
     --PERFORM lpInsertUpdate_MovementString (zc_MovementString_Error(), ioId, inError); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberHospital(), ioId, inInvNumberHospital); 
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_NumHospital(), ioId, inNumHospital); 


     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummStart(), ioId, inSummStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummPF(), ioId, inSummPF);
               
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
     
     IF vbIsInsert = TRUE
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.07.25         *
*/

-- ����
--