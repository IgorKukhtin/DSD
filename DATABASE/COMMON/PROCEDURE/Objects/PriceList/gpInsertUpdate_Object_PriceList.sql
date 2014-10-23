-- Function: gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId            Integer   ,     -- ���� ������� <����� �����> 
    IN inCode          Integer   ,     -- ��� ������� <����� �����> 
    IN inName          TVarChar  ,     -- �������� ������� <����� �����> 
    IN inPriceWithVAT  Boolean   ,     -- ���� � ��� (��/���)
    IN inVATPercent    TFloat    ,     -- % ���
    IN inSession       TVarChar        -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbCode:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PriceList());
   vbCode:= inSession;

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
   -- ��������� �������� <% ���>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_PriceList_VATPercent(), ioId, inVATPercent);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, Boolean, TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
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