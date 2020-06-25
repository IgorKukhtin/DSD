-- Function: gpInsertUpdate_Movement_OrderExternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderExternal (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderExternal(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inContractId          Integer   , -- �������
    IN inInternalOrderId     Integer   , -- ������ �� ���������� ����� 
    IN inisDeferred          Boolean   , -- �������
    IN inLetterSubject       TVarChar  , -- ���� ������
    IN inUserId              Integer    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    IF (COALESCE(ioId, 0) = 0) AND (COALESCE(inInvNumber, '') = '') THEN
        inInvNumber := (NEXTVAL ('Movement_OrderExternal_seq'))::TVarChar;
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL);

     IF COALESCE(inLetterSubject, '') = '' AND COALESCE (inToId, 0) <> 0 AND COALESCE (inContractId, 0) <> 0
     THEN
       WITH tmpObject_ImportExportLink AS (SELECT Object_ImportExportLink.ValueData    AS StringKey
                                                , ObjectLink_ObjectMain.ChildObjectId  AS ObjectMainId
                                                , ObjectLink_ObjectChild.ChildObjectId AS ObjectChildId
                                           FROM Object AS Object_ImportExportLink
                                               LEFT JOIN ObjectLink AS ObjectLink_ObjectMain
                                                                    ON ObjectLink_ObjectMain.ObjectId = Object_ImportExportLink.Id
                                                                   AND ObjectLink_ObjectMain.DescId = zc_ObjectLink_ImportExportLink_ObjectMain()

                                               LEFT JOIN ObjectLink AS ObjectLink_ObjectChild
                                                                    ON ObjectLink_ObjectChild.ObjectId = Object_ImportExportLink.Id
                                                                   AND ObjectLink_ObjectChild.DescId = zc_ObjectLink_ImportExportLink_ObjectChild()

                                               LEFT JOIN ObjectLink AS ObjectLink_LinkType
                                                                    ON ObjectLink_LinkType.ObjectId = Object_ImportExportLink.Id
                                                                   AND ObjectLink_LinkType.DescId = zc_ObjectLink_ImportExportLink_LinkType()
                                                                       
                                          WHERE Object_ImportExportLink.DescId = zc_Object_ImportExportLink()
                                            AND COALESCE (Object_ImportExportLink.isErased, False) = False
                                            AND ObjectLink_LinkType.ChildObjectId = 399921)

       SELECT tmpObject_ImportExportLink.StringKey
       INTO inLetterSubject
       FROM tmpObject_ImportExportLink 
       WHERE tmpObject_ImportExportLink.ObjectMainId = inToId
         AND tmpObject_ImportExportLink.ObjectChildId = inContractId
       LIMIT 1;
     END IF;

     -- ��������� ����� � <�� ���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_From(), ioId, inFromId);
     -- ��������� ����� � <���� (� ���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), ioId, inToId);
     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);

     -- ��������� 
     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, inisDeferred);

     -- ��������� ����� � <���������� �������>
     PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), ioId, inInternalOrderId);

     -- ��������� <���� ������>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_LetterSubject(), ioId, inLetterSubject);

     -- ����������� �������� ����� �� ���������
--     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (ioId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (ioId, inUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.12.16         * 
 02.10.14                        *
 01.07.14                                                        *


*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_OrderExternal (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
