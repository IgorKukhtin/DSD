-- Function: gpUpdate_Movement_BankStatementItem_LinkJuridical()

DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_LinkJuridical(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem_LinkJuridical(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inJuridicalId         Integer   , -- ��� 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbLinkJuridicalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_BankStatementItem());
  
     IF inJuridicalId = 0
     THEN
         RAISE EXCEPTION '������.�� ������� �������� ��� <�� ����, ���� (�������)>.';
     END IF; 

     -- ������� ����������� ��������
     vbLinkJuridicalId := (SELECT MovementLinkObject.ObjectId 
                           FROM MovementLinkObject
                           WHERE MovementLinkObject.MovementId = inId
                             AND MovementLinkObject.DescId = zc_MovementLinkObject_Juridical()
                           );
     
     -- ���� �������� ��� ��������� ������ ������
     IF COALESCE (vbLinkJuridicalId,0) <> 0
     THEN
         RAISE EXCEPTION '������.�������� ��� <�� ����, ���� (�������)> ��� ��������� - <%>.', lfGet_Object_ValueData_sh (vbLinkJuridicalId);
     END IF;
     

     -- ��������� ����� � <��. ����>
    -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inId, inJuridicalId);

     -- ��������� ��������
    -- PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.03.23         *
*/

-- ����
--