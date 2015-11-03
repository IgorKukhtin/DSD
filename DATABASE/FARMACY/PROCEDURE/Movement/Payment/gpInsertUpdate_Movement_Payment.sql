-- Function: gpInsertUpdate_Movement_Payment()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Payment(
 INOUT ioId                    Integer    , -- ���� ������� <�������� ������ ��������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inJuridicalId           Integer    , -- ������ ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Payment());
    vbUserId := inSession;
    --��������� ���������� ������
    IF COALESCE(inJuridicalId,0) = 0
    THEN
        RAISE EXCEPTION '������. �� ��������� ������.';
    END IF;
    --��������� ������� ���������� ����� � ������
    IF NOT EXISTS(SELECT 1 FROM Object_BankAccount_View
                  WHERE JuridicalId = inJuridicalId)
    THEN
        RAISE EXCEPTION '������. ��� ���������� ������ �� ������� �� ������ ���������� �����.';
    END IF;
    
    --�������� ����� �������� � �������� ���
    IF EXISTS(SELECT 1 
              FROM Movement_Payment_View AS Movement
              WHERE
                  Movement.OperDate = inOperdate
                  AND
                  Movement.JuridicalId = inJuridicalId
                  AND
                  Movement.StatusId <> zc_Enum_Status_Erased()
                  AND
                  Movement.Id <> COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION '������. � ����� ���� <%>, �� ������ ������ <%> ����� ���� ������ ���� �������� ������.', inOperDate,(Select ValueData from Object Where Id = inJuridicalId);
    END IF;
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Payment (ioId          := ioId
                                           , inInvNumber   := inInvNumber
                                           , inOperDate    := inOperDate
                                           , inJuridicalId := inJuridicalId
                                           , inUserId      := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Payment (Integer, TVarChar, TDateTime, Integer, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 29.10.15                                                                    *
*/