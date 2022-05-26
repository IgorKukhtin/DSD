-- Function: gpDelete_ObjectHistory()

DROP FUNCTION IF EXISTS gpDelete_ObjectHistoryLast (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_ObjectHistoryLast(
    IN inId                  Integer   ,  -- ���� ������� 
    IN inSession             TVarChar     -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_ObjectHistory_PriceListItem());

     
   --�������� ���� �� ��������� �������  ��  ������ 
   IF NOT EXISTS (SELECT ObjectHistory.Id
                  FROM ObjectHistory
                  WHERE ObjectHistory.Id = inId
                    AND ObjectHistory.DescId = zc_ObjectHistory_ServiceItem()
                    AND ObjectHistory.EndDate = zc_DateEnd() ) 
   THEN 
         RAISE EXCEPTION '������.������� ��������� ������ ��������� ��������.';
   END IF;
   
           -- ��������� �������� <���� �������������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ObjectHistory.ObjectId, CURRENT_TIMESTAMP)
           -- ��������� �������� <������������ (�������������)>
         , lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ObjectHistory.ObjectId, vbUserId)
   FROM ObjectHistory
   WHERE ObjectHistory.Id = inId;

   -- 
   PERFORM lpDelete_ObjectHistory (inId	      := inId
                                 , inUserId   := vbUserId
                                  );

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.22         *
*/

