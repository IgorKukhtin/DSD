-- Function: gpInsertUpdate_Object_MarginReportItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginReportItem(
 INOUT ioId             Integer,       -- ���� ������� <���� ���� ������>
    IN inMarginReportId Integer,       -- 
    IN inUnitId         Integer,       -- 

    IN inPersent1       Tfloat,        -- ����. % ��� 1-��� ��������
    IN inPersent2       Tfloat,        -- ����. % ��� 2-��� ��������
    IN inPersent3       Tfloat,        -- ����. % ��� 3-��� ��������
    IN inPersent4       Tfloat,        -- ����. % ��� 4-��� ��������
    IN inPersent5       Tfloat,        -- ����. % ��� 5-��� ��������
    IN inPersent6       Tfloat,        -- ����. % ��� 6-��� ��������
    IN inPersent7       Tfloat,        -- ����. % ��� 7-��� �������� 
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS INTEGER AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginReportItem());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   Code_max := lfGet_ObjectCode(inCode, zc_Object_MarginReportItem());
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ����� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_MarginReportItem(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ����� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_MarginReportItem(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MarginReportItem(), Code_max, inName);
   
   -- ��������� �������� <����. % ��� 1-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent1(), ioId, inPersent1);
   -- ��������� �������� <����. % ��� 2-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent2(), ioId, inPersent2);
   -- ��������� �������� <����. % ��� 3-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent3(), ioId, inPersent3);
   -- ��������� �������� <����. % ��� 4-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent4(), ioId, inPersent4);
   -- ��������� �������� <����. % ��� 5-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent5(), ioId, inPersent5);
   -- ��������� �������� <����. % ��� 6-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent6(), ioId, inPersent6);
   -- ��������� �������� <����. % ��� 7-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent7(), ioId, inPersent7);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.16         *
*/

-- ����
-- BEGIN; SELECT * FROM gpInsertUpdate_Object_MarginReportItem(0, 2,'��','2'); ROLLBACK
