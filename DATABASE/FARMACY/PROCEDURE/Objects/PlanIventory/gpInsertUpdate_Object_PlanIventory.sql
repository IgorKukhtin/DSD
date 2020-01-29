-- Function: gpInsertUpdate_Object_PlanIventory (Integer, TVarChar, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PlanIventory (Integer, TVarChar, Integer, Integer, Integer, TDateTime, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PlanIventory(
 INOUT ioId              Integer   ,    -- ���� ������� <�������������>
    IN inName            TVarChar  ,    -- �����������
    IN inUnitId          Integer   ,    -- ������
    IN inMemberId        Integer   ,    -- ��� ��������������
    IN inMemberReturnId  Integer   ,    -- ��� �������������� �� �������
    IN inOperDate        TDateTime,     -- ���� ��������������
    IN inDateStart       TDateTime,     -- ���� ������
    IN inDateEnd         TDateTime,     -- ���� ���������
    IN inSession         TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;  
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_PlanIventory());
   vbUserId := inSession; 
  
   -- �������� � 1 ���� �� ������ ������ 1 ������
   IF EXISTS (SELECT 1
              FROM Object
                   INNER JOIN ObjectLink AS ObjectLink_Unit 
                                         ON ObjectLink_Unit.ObjectId = Object.Id 
                                        AND ObjectLink_Unit.DescId = zc_ObjectLink_PlanIventory_Unit()
                                        ANd ObjectLink_Unit.ChildObjectId = inUnitId
                   INNER JOIN ObjectDate AS ObjectDate_OperDate
                                         ON ObjectDate_OperDate.ObjectId = Object.Id
                                        AND ObjectDate_OperDate.DescId = zc_ObjectDate_PlanIventory_OperDate()
                                        AND ObjectDate_OperDate.ValueData = inOperDate
              WHERE Object.DescId = zc_Object_PlanIventory() 
                AND Object.Id <> ioId)
   THEN
       RAISE EXCEPTION '������.�� <%> ��� ������� ���� �������������� <%>.', lfGet_Object_ValueData (inUnitId), inOperDate::Date;
   END IF;
   
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PlanIventory(), 0, inName);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_Member(), ioId, inMemberId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PlanIventory_MemberReturn(), ioId, inMemberReturnId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_OperDate(), ioId, inOperDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_DateStart(), ioId, inDateStart);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_PlanIventory_DateEnd(), ioId, inDateEnd);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$ LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.01.20         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PlanIventory()