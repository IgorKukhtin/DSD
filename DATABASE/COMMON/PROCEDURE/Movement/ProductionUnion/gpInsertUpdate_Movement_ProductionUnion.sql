-- Function: gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionUnion (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionUnion(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inDocumentKindId      Integer   , -- ��� ��������� (� ���������)
    IN inSubjectDocId        Integer               , --
    IN inIsPeresort          Boolean   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

   -- ��������� <��������>
   ioId := lpInsertUpdate_Movement_ProductionUnion (ioId             := ioId
                                                  , inInvNumber      := inInvNumber
                                                  , inOperDate       := inOperDate
                                                  , inFromId         := inFromId
                                                  , inToId           := inToId
                                                  , inDocumentKindId := inDocumentKindId 
                                                  , inIsPeresort     := inIsPeresort
                                                  , inUserId         := vbUserId
                                                   );
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), ioId, inSubjectDocId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.10.23         * inSubjectDocId
 13.06.16         *
 20.03.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ProductionUnion (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
