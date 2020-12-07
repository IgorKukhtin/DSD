-- Function: gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, Boolean, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_PriceListItemLast (Integer, Integer, Integer, TDateTime, TFloat, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_PriceListItemLast(
 INOUT ioId                     Integer,    -- ���� ������� <������� �����-�����>
    IN inPriceListId            Integer,    -- �����-����
    IN inGoodsId                Integer,    -- �����
    IN inOperDate               TDateTime,  -- ���� �������� ����
   OUT outStartDate             TDateTime,  -- ���� �������� ����
   OUT outEndDate               TDateTime,  -- ���� �������� ����
--    IN inValue                  TFloat,     -- �������� ���� ��� ���
 INOUT ioPriceNoVAT             TFloat,     -- �������� ���� ��� ���
 INOUT ioPriceWVAT              TFloat,     -- �������� ���� � ���
    IN inIsLast                 Boolean,    -- 
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
   DECLARE vbPriceListItemId Integer;
   DECLARE vbPriceWithVAT Boolean;
   DECLARE vbVATPercent TFloat;
   DECLARE vbValue TFloat;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

/*
   -- ����������� - ���� ���� ��������� ���������
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 80548 AND UserId = vbUserId)
      AND COALESCE (inPriceListId, 0) NOT IN (140208 -- ���-�� ������
                                            , 140209 -- ���-�� �������
                                             )
   THEN
       RAISE EXCEPTION '������. ��� ���� �������������� ����� <%>', lfGet_Object_ValueData (inPriceListId);
   END IF;


   -- ����������� - ���� ���� ���������� ���������-����
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
      AND COALESCE (inPriceListId, 0) NOT IN (SELECT zc_PriceList_Fuel()
                                             UNION
                                              SELECT DISTINCT ObjectLink_Contract_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_Contract_InfoMoney
                                                   INNER JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                                                         ON ObjectLink_Contract_PriceList.ObjectId      = ObjectLink_Contract_InfoMoney.ObjectId
                                                                        AND ObjectLink_Contract_PriceList.DescId        = zc_ObjectLink_Contract_PriceList()
                                                                        AND ObjectLink_Contract_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_Contract_InfoMoney.DescId        = zc_ObjectLink_Contract_InfoMoney()
                                                AND ObjectLink_Contract_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20401() -- ���
                                             UNION
                                              SELECT DISTINCT ObjectLink_Juridical_PriceList.ChildObjectId
                                              FROM ObjectLink AS ObjectLink_CardFuel_Juridical
                                                   INNER JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                                                         ON ObjectLink_Juridical_PriceList.ObjectId      = ObjectLink_CardFuel_Juridical.ObjectId
                                                                        AND ObjectLink_Juridical_PriceList.DescId        = zc_ObjectLink_Juridical_PriceList()
                                                                        AND ObjectLink_Juridical_PriceList.ChildObjectId > 0
                                              WHERE ObjectLink_CardFuel_Juridical.ObjectId > 0
                                                AND ObjectLink_CardFuel_Juridical.DescId   = zc_ObjectLink_CardFuel_Juridical()
                                             )
   THEN
       RAISE EXCEPTION '������. ��� ���� �������������� ����� <%>', lfGet_Object_ValueData (inPriceListId);
   END IF;
*/


   -- ��������� ����� �����
   vbPriceWithVAT := (SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
                      FROM ObjectBoolean AS ObjectBoolean_PriceWithVAT
                      WHERE ObjectBoolean_PriceWithVAT.ObjectId = inPriceListId
                        AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
                      );

   -- ��� ��� � % ����� �� ������
   vbVATPercent := (SELECT ObjectFloat_TaxKind_Value.ValueData AS VATPercent
                    FROM ObjectLink AS ObjectLink_Goods_TaxKind
                         LEFT JOIN ObjectFloat AS ObjectFloat_TaxKind_Value
                                               ON ObjectFloat_TaxKind_Value.ObjectId = ObjectLink_Goods_TaxKind.ChildObjectId 
                                              AND ObjectFloat_TaxKind_Value.DescId = zc_ObjectFloat_TaxKind_Value()
                    WHERE ObjectLink_Goods_TaxKind.ObjectId = inGoodsId
                      AND ObjectLink_Goods_TaxKind.DescId = zc_ObjectLink_Goods_TaxKind()
                    );

   -- ������ ���� ��� ���, �� 4 ������
   ioPriceNoVAT := (CASE WHEN vbPriceWithVAT = FALSE THEN ioPriceNoVAT ELSE CAST ( ioPriceWVAT * ( 1 - COALESCE (vbVATPercent,0) / 100) AS NUMERIC (16, 2)) END) ::TFloat;

   -- ������ ���� � ���, �� 4 ������
   ioPriceWVAT := (CASE WHEN vbPriceWithVAT = TRUE THEN ioPriceWVAT ELSE CAST ( ioPriceNoVAT * (1 + COALESCE (vbVATPercent,0) / 100)  AS NUMERIC (16, 2)) END) ::TFloat;

   -- ������������ ����� �������� ���������. ���� ����� ��� ��� - �� ���� ��� ���, ���� ����� � ��� - �� ��������� ���� � ���
   vbValue := (CASE WHEN vbPriceWithVAT = FALSE THEN ioPriceNoVAT ELSE ioPriceWVAT END) ::TFLOAT;

   -- !!!������������!!!
   IF inIsLast = TRUE THEN ioId:= 0; END IF;

   -- �������� ������ �� ������ ���
   vbPriceListItemId := lpGetInsert_Object_PriceListItem (inPriceListId, inGoodsId, vbUserId);
 
   -- ��������� ��� ������ ������ ������� ���
   ioId := lpInsertUpdate_ObjectHistory (ioId, zc_ObjectHistory_PriceListItem(), vbPriceListItemId, inOperDate, vbUserId);
   
   -- ������������� ����
   PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_PriceListItem_Value(), ioId, vbValue);

   --
   IF inIsLast = TRUE AND EXISTS (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate)
   THEN
         -- ��������� �������� - "��������"
         PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, ObjectHistoryFloat_Value.ValueData, TRUE, TRUE)
         FROM ObjectHistory
              LEFT JOIN ObjectHistoryFloat AS ObjectHistoryFloat_Value
                                           ON ObjectHistoryFloat_Value.ObjectHistoryId = ObjectHistory.Id
                                          AND ObjectHistoryFloat_Value.DescId = zc_ObjectHistoryFloat_PriceListItem_Value()
         WHERE ObjectHistory.DescId = zc_ObjectHistory_PriceListItem() AND ObjectHistory.ObjectId = vbPriceListItemId AND ObjectHistory.StartDate > inOperDate;

         -- �������
         DELETE FROM ObjectHistoryDate WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryFloat WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryString WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistoryLink WHERE ObjectHistoryId IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         DELETE FROM ObjectHistory WHERE Id IN (SELECT Id FROM ObjectHistory WHERE DescId = zc_ObjectHistory_PriceListItem() AND ObjectId = vbPriceListItemId AND StartDate > inOperDate);
         -- ����� ���� �������� ��-�� EndDate
         UPDATE ObjectHistory SET EndDate = zc_DateEnd() WHERE Id = ioId;
   END IF;


   -- ������� ��������
   SELECT StartDate, EndDate INTO outStartDate, outEndDate FROM ObjectHistory WHERE Id = ioId;

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbPriceListItemId, inUserId:= vbUserId, inStartDate:= outStartDate, inEndDate:= outEndDate, inPrice:= vbValue, inIsUpdate:= TRUE, inIsErased:= FALSE);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.11.20         *
 28.11.19         * add inGoodsKindId
 24.07.19         *
 20.08.15         * lpInsert_ObjectHistoryProtocol
 09.12.14                                        *
*/
