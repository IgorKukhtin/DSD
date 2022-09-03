-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar,TVarChar )

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, TDateTime, TFloat, Integer );
--DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, Integer );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_JuridicalDefermentPayment (Integer, Integer, Integer, Integer, Integer, TDateTime, TFloat, TDateTime, TFloat, Integer );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_JuridicalDefermentPayment (
    IN inId                Integer   , -- ���� ������� <>
    IN inJuridicalId       Integer   , -- 
    IN inContractId        Integer   , -- 
    IN inPaidKindId        Integer   , -- 
    IN inPartnerId         Integer   , -- 
    IN inOperDate          TDateTime , -- ���� ��������� ������
    IN inAmount            TFloat    , -- ����� ��������� ������ 
    IN inOperDateIn        TDateTime , -- ���� ���������� �������
    IN inAmountIn          TFloat    , -- ����� ���������� �������
    IN inUserId            Integer 
)
RETURNS VOID AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- ��������� <������>
   inId := lpInsertUpdate_Object (inId, zc_Object_JuridicalDefermentPayment(), 0, '');
   
   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Juridical(), inId, inJuridicalId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Contract(), inId, inContractId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_PaidKind(), inId, inPaidKindId); 
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_JuridicalDefermentPayment_Partner(), inId, inPartnerId); 

   -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_JuridicalDefermentPayment_OperDate(), inId, inOperDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalDefermentPayment_Amount(), inId, inAmount);
   
    -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_JuridicalDefermentPayment_OperDateIn(), inId, inOperDateIn);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_JuridicalDefermentPayment_AmountIn(), inId, inAmountIn);
     
   -- ��������� ��������
   --PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.12.21         *
 02.12.21         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Calendar (0,  true, '12.11.2013')