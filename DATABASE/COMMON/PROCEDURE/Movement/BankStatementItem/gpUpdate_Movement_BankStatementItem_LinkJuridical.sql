-- Function: gpUpdate_Movement_BankStatementItem_LinkJuridical()

-- DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_LinkJuridical(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_BankStatementItem_LinkJuridical(Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_BankStatementItem_LinkJuridical(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inJuridicalId         Integer   , -- ��� 
    IN inServiceDate         TDateTime , --
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
     IF vbLinkJuridicalId <> 0
        AND (SELECT Object.DescId FROM Object WHERE Object.Id = vbLinkJuridicalId) <> (SELECT Object.DescId FROM Object WHERE Object.Id = inJuridicalId)
     THEN
         RAISE EXCEPTION '������.�������� ��� <�� ����, ���� (�������)> ��� ��������� - <%>.', lfGet_Object_ValueData_sh (vbLinkJuridicalId);
     END IF;
     

     -- ��������� ����� � <��. ����>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), inId, inJuridicalId);
     
     --
     IF (SELECT Object.DescId FROM Object WHERE Object.Id = inJuridicalId) = zc_Object_PersonalServiceList()
     THEN
         -- ��������� ����� � <���������� �����>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_InfoMoney(), inId, zc_Enum_InfoMoney_60101());

         -- ����������� �������� <����� ����������>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_ServiceDate(), inId, DATE_TRUNC ('MONTH', inServiceDate));

     END IF;

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

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