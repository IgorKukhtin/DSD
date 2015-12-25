-- Function: gpInsertUpdate_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpInsert_Movement_ReturnOutFromIncome
   (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_ReturnOutFromIncome(
   OUT outId                 Integer   , -- ���� ������� <�������� �����������>
    IN inParentId            Integer   , -- ��������� ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnOut());
     vbUserId := inSession;

   

    SELECT lpInsertUpdate_Movement_ReturnOut(0, CAST (NEXTVAL ('movement_ReturnOut_seq') AS TVarChar) , Current_Date
                                             , NULL::TVarChar, NULL::TDateTime, Movement_Income.PriceWithVAT
                                             , Movement_Income.ToId, Movement_Income.FromId
                                             , Movement_Income.NDSKindId, inParentId, NULL, vbUserId) INTO outId
     FROM  Movement_Income_View AS Movement_Income 
     WHERE Movement_Income.Id = inParentId;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.15                         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnOut (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inOperDateMark:= '01.01.2013', inInvNumberPartner:= 'xxx', inFromId:= 1, inPersonalId:= 0, inRouteId:= 0, inRouteSortingId:= 0, inSession:= '2')
