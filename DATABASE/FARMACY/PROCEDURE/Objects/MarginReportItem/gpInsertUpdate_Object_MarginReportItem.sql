-- Function: gpInsertUpdate_Object_MarginReportItem(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MarginReportItem (Integer, Integer, Tfloat, Tfloat,Tfloat,Tfloat,Tfloat,Tfloat,Tfloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MarginReportItem(
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
   DECLARE vbid Integer;   
   
BEGIN
 
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_MarginReportItem());
   UserId := inSession;

   -- �������� inMarginReportId ������ ���� ����������
   IF COALESCE (inMarginReportId, 0) = 0
   THEN
       RAISE EXCEPTION '������. �������� <��������� ������� ��� ������ (������� �����������)> ������ ���� �����������.';
   END IF;

   vbid := (SELECT  ObjectLink_MarginReport.ObjectId AS Id 
            FROM ObjectLink AS ObjectLink_MarginReport
               INNER JOIN ObjectLink AS ObjectLink_Unit
                                     ON ObjectLink_Unit.DescId = zc_ObjectLink_MarginReportItem_Unit()
                                    AND ObjectLink_Unit.ObjectId = ObjectLink_MarginReport.ObjectId
                                    AND ObjectLink_Unit.ChildObjectId = inUnitId --2082813
            WHERE ObjectLink_MarginReport.DescId = zc_ObjectLink_MarginReportItem_MarginReport()
              AND ObjectLink_MarginReport.ChildObjectId = inMarginReportId );--2082813 

   -- ��������� <������>
   vbid := lpInsertUpdate_Object (COALESCE (vbid,0), zc_Object_MarginReportItem(), 0, '');
   
   -- ��������� �������� <����. % ��� 1-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent1(), vbid, inPersent1);
   -- ��������� �������� <����. % ��� 2-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent2(), vbid, inPersent2);
   -- ��������� �������� <����. % ��� 3-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent3(), vbid, inPersent3);
   -- ��������� �������� <����. % ��� 4-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent4(), vbid, inPersent4);
   -- ��������� �������� <����. % ��� 5-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent5(), vbid, inPersent5);
   -- ��������� �������� <����. % ��� 6-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent6(), vbid, inPersent6);
   -- ��������� �������� <����. % ��� 7-��� ��������>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_MarginReportItem_Percent7(), vbid, inPersent7);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MarginReportItem_MarginReport(), vbid, inMarginReportId);
    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_MarginReportItem_Unit(), vbid, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbid, UserId);

   
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
