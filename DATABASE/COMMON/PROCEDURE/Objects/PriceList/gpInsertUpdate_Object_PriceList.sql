-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, Boolean, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId            Integer   ,     -- ���� ������� <����� �����> 
    IN inCode          Integer   ,     -- ��� ������� <����� �����> 
    IN inName          TVarChar  ,     -- �������� ������� <����� �����> 
    IN inPriceWithVAT  Boolean   ,     -- ���� � ��� (��/���)  
    IN inisUser        Boolean   ,     -- ������������ ������
    IN inVATPercent    TFloat    ,     -- % ���
    IN inCurrencyId    Integer   ,     -- ������
    IN inSession       TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbCode:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PriceList());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inCurrencyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <������>.';
   END IF;


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_PriceList());
   
   -- �������� ���� ������������ ��� �������� <������������ ����� �����>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- �������� ���� ������������ ��� �������� <��� ����� �����>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), vbCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceList(), vbCode, inName);

   -- ��������� �������� <���� � ��� (��/���)>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_PriceWithVAT(), ioId, inPriceWithVAT);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_PriceList_User(), ioId, inisUser);
   
   -- ��������� �������� <% ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);
   
   -- ��������� �������� <������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PriceList_Currency(), ioId, inCurrencyId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.03.24          * inisUser 
 16.11.14                                        * add Currency...
 11.01.13                                        * add lfGet_ObjectCode
 07.09.13                                        * add PriceWithVAT and VATPercent
 14.06.13          *
*/
/*
!!!Sybase!!!
select * 
from (
select PriceListId, min (Bill.isNds) as a1, max (Bill.isNds) as a2
from dba.ScaleHistory_byObvalka
     join dba.Bill on Bill.Id = BillId
where ScaleHistory_byObvalka.InsertDate > '2014-01-01' and ScaleHistory_byObvalka.BillKind=zc_bkSaleToClient()
  and ScaleHistory_byObvalka.BillId <> 0
group by PriceListId
having a1 <> a2
) as tmp
left join dba.PriceList_byHistory on PriceList_byHistory.Id = tmp.PriceListId
*/
-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceList ()