-- Function: gpGet_ObjectHistory_PriceListItem_error (Integer, Integer, Integer, TDateTime, TFloat, Boolean, TVarChar)
-- ���������� ����� ������ ��������, �������� ����, �.�. � ������ ������ �� ���������� ������ ���� ������� � �� ������� ������ ������ �� ������������

DROP FUNCTION IF EXISTS gpGet_ObjectHistory_PriceListItem_error (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_ObjectHistory_PriceListItem_error(
    IN inPriceListId            Integer,    -- �����-����
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem()); -- zc_Enum_Process_InsertUpdate_OH_PriceListItem_zero


   -- ���� �� ��������� ���� <�����-���� - ��������� � ����� ������>
   IF NOT EXISTS (SELECT 1 FROM Object_Role_Process_View WHERE ProcessId = zc_Enum_Process_Update_PriceListItem() AND UserId = vbUserId)
      OR EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
   THEN
       -- ����� � ���������� "������ � ������"
       IF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
       THEN
           RAISE EXCEPTION '������. ��� ���� �������������� ����� <%>', lfGet_Object_ValueData (inPriceListId);

       -- �������� � ���������� "������ � ������" - ��� ��� ������ ��� �����
       ELSEIF NOT EXISTS (SELECT 1 FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId AND MemberPriceList_View.PriceListId = inPriceListId)
       THEN
           RAISE EXCEPTION '������. � ������������ <%>.%��� ���� �������������� ����� <%>.%����� �������������� ������ ����� ������:% %'
                         , lfGet_Object_ValueData (vbUserId)
                         , CHR (13)
                         , lfGet_Object_ValueData (inPriceListId)
                         , CHR (13)
                         , CHR (13)
                         , (SELECT STRING_AGG ('< ' || MemberPriceList_View.PriceListName || ' >', '; ') FROM Object_MemberPriceList_View AS MemberPriceList_View WHERE MemberPriceList_View.UserId = vbUserId)
                          ;
       END IF;
   END IF;


   -- ����������� - ���� ���� ���������� ���������-����
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = 78489 AND UserId = vbUserId)
      AND NOT EXISTS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)
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

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.05.21         * ��������� ����� �� ��������� ���                                  *
*/
