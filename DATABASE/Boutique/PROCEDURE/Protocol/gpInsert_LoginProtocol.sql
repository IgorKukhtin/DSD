-- DROP FUNCTION gpInsert_LoginProtocol;

DROP FUNCTION IF EXISTS gpInsert_LoginProtocol (TVarChar, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_LoginProtocol(
    IN inIP           TVarChar,
    IN inIsConnect    Boolean,
    IN inIsProcess    Boolean,
    IN inIsExit       Boolean,
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������� ��� ������������
     PERFORM lpInsert_LoginProtocol (inUserLogin  := (SELECT Object.ValueData FROM Object WHERE Object.Id = vbUserId)
                                   , inIP         := inIP
                                   , inUserId     := vbUserId
                                   , inIsConnect  := inIsConnect
                                   , inIsProcess  := inIsProcess
                                   , inIsExit     := inIsExit
                                    );
   
END;           
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_LoginProtocol (TVarChar, Boolean, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 07.11.16                                        *
*/
