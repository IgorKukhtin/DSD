-- Function: gpInsertUpdate_Object_ExchangeRates()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ExchangeRates(Integer, TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ExchangeRates(
 INOUT ioId                 Integer   ,     -- ���� ������� <����������> 
    IN inOperDate           TDateTime ,     -- ���� ������ ��������
    IN inExchange           TFloat    ,     -- ����
    IN inSession            TVarChar        -- ����������� ������ �� ��������� �����
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ExchangeRates());

   vbUserId := inSession::Integer;

   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId IN (zc_Enum_Role_Admin(), zc_Enum_Role_PharmacyManager(), zc_Enum_Role_SeniorManager()))
   THEN
     RAISE EXCEPTION '��������� ������ ���������� ��������������';
   END IF;
   
   IF EXISTS(SELECT Object_ExchangeRates.Id                             AS Id 
             FROM Object AS Object_ExchangeRates

                  LEFT JOIN ObjectDate AS ObjectDate_ExchangeRates_OperDate
                                       ON ObjectDate_ExchangeRates_OperDate.ObjectId = Object_ExchangeRates.Id
                                      AND ObjectDate_ExchangeRates_OperDate.DescId = zc_ObjectDate_ExchangeRates_OperDate()


             WHERE Object_ExchangeRates.DescId = zc_Object_ExchangeRates()
               AND Object_ExchangeRates.Id <> COALESCE(ioId, 0)
               AND ObjectDate_ExchangeRates_OperDate.ValueData = inOperDate)
   THEN
     RAISE EXCEPTION '�� ���� <%> ���� ��� ����������.', zfConvert_DateShortToString(inOperDate);
   END IF;
   
   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_ExchangeRates());
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ExchangeRates(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ExchangeRates(), vbCode_calc, '');

   -- ��������� ���� ������ ��������
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ExchangeRates_OperDate(), ioId, inOperDate);
   -- ��������� ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ExchangeRates_Exchange(), ioId, inExchange);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.02.22                                                       *
*/

-- ����