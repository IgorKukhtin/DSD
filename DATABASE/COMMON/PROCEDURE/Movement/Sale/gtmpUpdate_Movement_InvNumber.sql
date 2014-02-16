-- Function: gtmpUpdate_Movement_InvNumber()

-- DROP FUNCTION gtmpUpdate_Movement_InvNumber (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gtmpUpdate_Movement_InvNumber(
    IN inId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     UPDATE Movement SET InvNumber = inInvNumber WHERE Id = inId;
     IF NOT found THEN
       RAISE EXCEPTION 'gtmpUpdate_Movement_InvNumber';
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.08.13                                        * ��� ������ ������ ��� Load_PostgreSql

*/

-- ����
-- SELECT * FROM gtmpUpdate_Movement_InvNumber (inId:= 0, inInvNumber:= '-1', inSession:= '2');
