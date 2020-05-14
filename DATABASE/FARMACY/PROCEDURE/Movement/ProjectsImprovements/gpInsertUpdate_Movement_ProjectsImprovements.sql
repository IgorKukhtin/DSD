-- Function: gpInsertUpdate_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProjectsImprovements(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ������� ����������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
 INOUT ioOperDate            TDateTime , -- ���� ���������
    IN inTitle               TVarChar  , -- ��������
    IN inDescription         Text      , -- ������� �������� 
    IN inComment             TVarChar  , -- ���������� 
   OUT outisApprovedBy       Boolean   , -- ����������
   OUT outStatusCode         Integer   ,
   OUT outStatusName         TVarChar  ,
   OUT outUserName           TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)                               
RETURNS Record AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProjectsImprovements());
     
     IF COALESCE(ioInvNumber, '') = ''
     THEN
       ioInvNumber := CAST (NEXTVAL ('Movement_ProjectsImprovements_seq') AS TVarChar);
     END IF;
     
     IF ioOperDate IS NULL
     THEN
       ioOperDate := CURRENT_DATE;
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ProjectsImprovements (ioId               := ioId
                                                         , inInvNumber        := ioInvNumber
                                                         , inOperDate         := ioOperDate
                                                         , inTitle            := inTitle
                                                         , inDescription      := inDescription
                                                         , inComment          := inComment
                                                         , inUserId           := vbUserId
                                                          );
                                                          
     SELECT T1.StatusCode, T1.StatusName, T1.isApprovedBy, T1.UserName
     INTO outStatusCode, outStatusName, outisApprovedBy, outUserName
     FROM gpGet_Movement_ProjectsImprovements (ioId, inSession) AS T1;
                                    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
ALTER FUNCTION gpInsertUpdate_Movement_ProjectsImprovements (Integer, TVarChar, TDateTime, TVarChar, Text, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.05.20                                                       *
*/

-- select * from gpInsertUpdate_Movement_ProjectsImprovements(ioId := 18831165 , ioInvNumber := '103' , ioOperDate := ('13.05.2020')::TDateTime , inTitle := '����� 1' , inDescription := '����� �������' , inComment := '' ,  inSession := '3');