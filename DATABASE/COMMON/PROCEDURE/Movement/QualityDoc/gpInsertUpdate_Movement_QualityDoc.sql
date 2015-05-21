-- Function: gpInsertUpdate_Movement_QualityDoc (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_QualityDoc (Integer, TVarChar, TDateTime, Integer, TVarChar, Integer, Integer, Integer, TVarChar, Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_QualityDoc(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementId_Sale     Integer   , -- 
    IN inInvNumberMark       TVarChar  , -- 
    IN inCarId               Integer   , -- ����������
    IN inCarTrailerId        Integer   , -- ���������� (������)
    IN inPersonalDriverId    Integer   , -- ��������� (��������)
    IN inPersonalDriverName  TVarChar  , -- ��������� (��������)
    IN inRouteId             Integer   , -- 
    IN inMemberId1           Integer   , -- ������� ����/����������
    IN inMemberName1         TVarChar  , -- ������� ����/����������
    IN inMemberId2           Integer   , -- ��������� (����������� ����� �����������������)
    IN inMemberName2         TVarChar  , -- ��������� (����������� ����� �����������������)
    IN inMemberId3           Integer   , -- ³����� ��������
    IN inMemberName3         TVarChar  , -- ³����� ��������
    IN inMemberId4           Integer   , -- ���� (����������� ����� �����������������)
    IN inMemberName4         TVarChar  , -- ���� (����������� ����� �����������������)
    IN inMemberId5           Integer   , -- ������� ����/����������
    IN inMemberName5         TVarChar  , -- ������� ����/����������
    IN inMemberId6           Integer   , -- ���� ����/����������
    IN inMemberName6         TVarChar  , -- ���� ����/����������
    IN inMemberId7           Integer   , -- ������� (����������� ����� �����������������) 
    IN inMemberName7         TVarChar  , -- ������� (����������� ����� �����������������) 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_QualityDoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- ����� <��������� (��������)>
     inPersonalDriverId:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inPersonalDriverName) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inPersonalDriverId, 0) = 0 AND TRIM (inPersonalDriverName) <> ''
     THEN
         -- ��������
         inPersonalDriverId:= lpInsertUpdate_Object_MemberExternal (ioId    := inPersonalDriverId
                                                                  , inCode  := 0
                                                                  , inName  := inPersonalDriverName
                                                                  , inUserId:= vbUserId
                                                                   );
     END IF;

     -- ����� <������� ����/����������>
     inMemberId1:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName1) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId1, 0) = 0 AND TRIM (inMemberName1) <> ''
     THEN
         -- ��������
         inMemberId1:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId1
                                                           , inCode  := 0
                                                           , inName  := inMemberName1
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <��������� (����������� ����� �����������������)>
     inMemberId2:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName2) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId2, 0) = 0 AND TRIM (inMemberName2) <> ''
     THEN
         -- ��������
         inMemberId2:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId2
                                                           , inCode  := 0
                                                           , inName  := inMemberName2
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <³����� ��������>
     inMemberId3:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName3) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId3, 0) = 0 AND TRIM (inMemberName3) <> ''
     THEN
         -- ��������
         inMemberId3:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId3
                                                           , inCode  := 0
                                                           , inName  := inMemberName3
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <���� (����������� ����� �����������������)>
     inMemberId4:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName4) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId4, 0) = 0 AND TRIM (inMemberName4) <> ''
     THEN
         -- ��������
         inMemberId4:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId4
                                                           , inCode  := 0
                                                           , inName  := inMemberName4
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <������� ����/����������>
     inMemberId5:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName5) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId5, 0) = 0 AND TRIM (inMemberName5) <> ''
     THEN
         -- ��������
         inMemberId5:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId5
                                                           , inCode  := 0
                                                           , inName  := inMemberName5
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <���� ����/����������>
     inMemberId6:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName6) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId6, 0) = 0 AND TRIM (inMemberName6) <> ''
     THEN
         -- ��������
         inMemberId6:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId6
                                                           , inCode  := 0
                                                           , inName  := inMemberName6
                                                           , inUserId:= vbUserId
                                                            );
     END IF;

     -- ����� <������� (����������� ����� �����������������)>
     inMemberId7:= (SELECT Object_MemberExternal.Id FROM Object AS Object_MemberExternal WHERE Object_MemberExternal.ValueData = TRIM (inMemberName7) AND Object_MemberExternal.DescId = zc_Object_MemberExternal());
     IF COALESCE (inMemberId7, 0) = 0 AND TRIM (inMemberName7) <> ''
     THEN
         -- ��������
         inMemberId7:= lpInsertUpdate_Object_MemberExternal (ioId    := inMemberId7
                                                           , inCode  := 0
                                                           , inName  := inMemberName7
                                                           , inUserId:= vbUserId
                                                            );
     END IF;


     -- ��������� <��������>
     ioId:= lpInsertUpdate_Movement_QualityDoc (ioId              := ioId
                                                  , inInvNumber       := inInvNumber
                                                  , inOperDate        := inOperDate
                                                  , inMovementId_Sale := inMovementId_Sale
                                                  , inInvNumberMark   := inInvNumberMark
                                                  , inCarId           := inCarId
                                                  , inCarTrailerId    := inCarTrailerId
                                                  , inPersonalDriverId:= inPersonalDriverId
                                                  , inRouteId         := inRouteId
                                                  , inMemberId1       := inMemberId1
                                                  , inMemberId2       := inMemberId2
                                                  , inMemberId3       := inMemberId3
                                                  , inMemberId4       := inMemberId4
                                                  , inMemberId5       := inMemberId5
                                                  , inMemberId6       := inMemberId6
                                                  , inMemberId7       := inMemberId7
                                                  , inUserId          := vbUserId
                                                   );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 30.03.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_QualityDoc (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
