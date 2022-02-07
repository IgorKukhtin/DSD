-- Function: gpInsertUpdate_ObjectHistory_ServiceItem ()

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_ServiceItem (Integer, Integer, TDateTime, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_ServiceItem(
 INOUT ioId                     Integer,    -- ���� ������� <>
    IN inUnitId                 Integer,    -- 
    IN inOperDate               TDateTime,  -- ���� �������� 
    IN inInfoMoneyId            Integer,    -- 
    IN inCommentInfoMoneyId     Integer,    -- 
    IN inValue                  TFloat,   --
    IN inPrice	                TFloat,   -- 
    IN inArea                   TFloat,   -- 
    IN inSession                TVarChar    -- ������ ������������
)
  RETURNS Integer AS
$BODY$
 DECLARE vbUserId Integer;
 DECLARE vbServiceItemId Integer;
 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ���������� <�����>.';
   END IF;
 
   -- �������� ������ �� ServiceItem ���� inUnitId + inInfoMoneyId
   vbServiceItemId := lpGetInsert_Object_ServiceItem (inUnitId, inInfoMoneyId, vbUserId);

   -- ��������� ��� ������ ������ �������
   ioId := lpInsertUpdate_ObjectHistory(ioId, zc_ObjectHistory_ServiceItem(), vbServiceItemId, inOperDate, vbUserId);

   -- ������ ������/������
   --PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_ServiceItem_InfoMoney(), ioId, inInfoMoneyId);
   -- ���������� ������/������ 	
   PERFORM lpInsertUpdate_ObjectHistoryLink(zc_ObjectHistoryLink_ServiceItem_CommentInfoMoney(), ioId, inCommentInfoMoneyId);
   
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Value(), ioId, inValue);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Price(), ioId, inPrice);
   -- 
   PERFORM lpInsertUpdate_ObjectHistoryFloat(zc_ObjectHistoryFloat_ServiceItem_Area(), ioId, inArea);

   -- ��������� ��������
   PERFORM lpInsert_ObjectHistoryProtocol (ObjectHistory.ObjectId, vbUserId, ObjectHistory.StartDate, ObjectHistory.EndDate, 0)
   FROM ObjectHistory WHERE Id = ioId;
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.22         *
*/