-- �������� ��� �������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CashFlow_Load (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);
--gpinsertupdate_object_cashflow_from_excel

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CashFlow_Load(
    IN inCashFlowCode_in          Integer,       -- ��� ������ ��� ������
    IN inCashFlowName_in          TVarChar,      -- �������� ������ ��� ������
    IN inCashFlowCode_out         Integer,       -- ��� ������ ��� ������
    IN inCashFlowName_out         TVarChar,      -- �������� ������ ��� ������
    IN inInfoMoneyName            TVarChar,      -- �������� ������ ��
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCashFlowId Integer;
  DECLARE vbInfoMoneyId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CashFlow());
   vbUserId:= lpGetUserBySession (inSession);

   -- ������� �� ����. ������ �� '�� ������ ���������� : '
   inInfoMoneyName:= TRIM (REPLACE (TRIM(inInfoMoneyName), '�� ������ ���������� : ', ''));
   -- ������� ������ ��
   vbInfoMoneyId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Infomoney() AND TRIM (Object.ValueData) = TRIM (inInfoMoneyName) limit 1);


   IF COALESCE (inCashFlowCode_out,0) <> 0
   THEN
       -- ����� � ���. ������� ��� ������� ������
       vbCashFlowId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.isErased = FALSE AND Object.ObjectCode = inCashFlowCode_out limit 1);
       
       -- E��� �� ����� ����������
       IF COALESCE (vbCashFlowId,0) = 0
       THEN
           vbCashFlowId := gpInsertUpdate_Object_CashFlow (ioId      := COALESCE (vbCashFlowId)
                                                         , inCode    := inCashFlowCode_out
                                                         , inName    := TRIM (inCashFlowName_out)
                                                         , inSession := inSession
                                                           );
       END IF;
    
       -- ���������� ����� zc_ObjectLink_InfoMoney_CashFlow_out ���� ����� ���
       IF COALESCE (vbInfoMoneyId,0) <> 0 AND COALESCE (vbCashFlowId,0) <> 0
          AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_InfoMoney_CashFlow_out() AND ObjectLink.ObjectId = vbInfoMoneyId AND ObjectLink.ChildObjectId = vbCashFlowId)
       THEN
           -- ��������� ����� � <������ ������ ��� ������>
           PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_out(), vbInfoMoneyId, vbCashFlowId);
           
           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (vbInfoMoneyId, vbUserId);
       
       END IF;
   END IF;
   
   -- ���������� �� ������� ��� ������
       
   IF COALESCE (inCashFlowCode_in,0) <> 0
   THEN
       -- ����� � ���. ������� ��� ������� ������
       vbCashFlowId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CashFlow() AND Object.isErased = FALSE AND Object.ObjectCode = inCashFlowCode_in limit 1);
       
       -- E��� �� ����� ����������
       IF COALESCE (vbCashFlowId,0) = 0
       THEN
           vbCashFlowId := gpInsertUpdate_Object_CashFlow (ioId      := COALESCE (vbCashFlowId)
                                                         , inCode    := inCashFlowCode_in
                                                         , inName    := TRIM (inCashFlowName_in)
                                                         , inSession := inSession
                                                           );
       END IF;
           
       -- ���������� ����� zc_ObjectLink_InfoMoney_CashFlow_in ���� ����� ���
       IF COALESCE (vbInfoMoneyId,0) <> 0 AND COALESCE (vbCashFlowId,0) <> 0
          AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_InfoMoney_CashFlow_in() AND ObjectLink.ObjectId = vbInfoMoneyId AND ObjectLink.ChildObjectId = vbCashFlowId)
       THEN
           -- ��������� ����� � <������ ������ ��� ������>
           PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_InfoMoney_CashFlow_in(), vbInfoMoneyId, vbCashFlowId);

           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (vbInfoMoneyId, vbUserId);
       END IF;
   END IF;
  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
22.06.20          *
*/

-- ����
--