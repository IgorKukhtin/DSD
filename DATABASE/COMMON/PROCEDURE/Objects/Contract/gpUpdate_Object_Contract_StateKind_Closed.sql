-- Function: gpUpdate_Object_Contract_StateKind_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Object_Contract_StateKind_Closed (Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Contract_StateKind_Closed(
    IN inId                  Integer,       -- ���� ������� <�������>
    IN inContractStateKindId Integer  ,     -- ��������� ��������
    IN inEndDate             TDateTime,     -- ���� �� ������� ��������� ������� 
    IN inEndDate_Term        TDateTime,     -- ���� �����������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbDebts TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Contract_StateKind_Closed());

   -- ���� ������� ������ ������ �� ������
   IF inContractStateKindId = zc_Enum_ContractStateKind_Close()
   THEN 
       RETURN;
   END IF;
   
   -- �������� ���� ����������
   IF COALESCE (inEndDate, zc_DateEnd()) > CURRENT_DATE
   THEN
       RAISE EXCEPTION '������.� �������� <%> ���� ���������� <%> ����� ������� ����.', lfGet_Object_ValueData (inId), inEndDate;
   END IF;

   -- �������� ���� �����������
   IF COALESCE (inEndDate_Term, zc_DateStart()) > CURRENT_DATE
   THEN
       RAISE EXCEPTION '������.� �������� <%> ����������� ���� ����������� <%>.', lfGet_Object_ValueData (inId), inEndDate_Term;
   END IF; 

   --����� ������� ������� ��� ������ ������ - ������, �� ������ ����  ������ (���������� � 1 ���, �.�. ����� ���� >1 ��� <-1)
   vbDebts := (SELECT * FROM gpGet_Object_Contract_debts (inId, inSession) AS tmp);
   IF COALESCE (vbDebts, 0) <> 0 
   THEN
       RAISE EXCEPTION '������.�� �������� <%> ���� ���� � ����� <%>.', lfGet_Object_ValueData (inId), vbDebts;
   END IF;


   -- ���� ���� ������ ������� ����� ���������
   -- ��������� ����� � <��������� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Contract_ContractStateKind(), inId, zc_Enum_ContractStateKind_Close());   
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE, inIsErased:= NULL);
   
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Contract_StateKind_Closed ()
