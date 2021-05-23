-- Function: gpInsertUpdate_Object_MemberSheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberSheetWorkTime (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberSheetWorkTime(
 INOUT ioId             Integer   ,     -- ���� ������� <>
    IN inUnitId         Integer   ,     -- �������������
    IN inMemberId       Integer   ,     -- ���������� ����
    IN inComment        TVarChar  ,     -- ����������
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSheetWorkTime());


   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<�������������> �� �������.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<���.����> �� �������.';
   END IF;
   
   -- ��������� �� ������������ Unit + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberSheetWorkTime
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Unit
                                        ON ObjectLink_MemberSheetWorkTime_Unit.ObjectId = Object_MemberSheetWorkTime.Id
                                       AND ObjectLink_MemberSheetWorkTime_Unit.DescId = zc_ObjectLink_MemberSheetWorkTime_Unit()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberSheetWorkTime_Member
                                        ON ObjectLink_MemberSheetWorkTime_Member.ObjectId = Object_MemberSheetWorkTime.Id
                                       AND ObjectLink_MemberSheetWorkTime_Member.DescId = zc_ObjectLink_MemberSheetWorkTime_Member()

              WHERE Object_MemberSheetWorkTime.DescId = zc_Object_MemberSheetWorkTime()
                AND ObjectLink_MemberSheetWorkTime_Unit.ChildObjectId   = inUnitId
                AND ObjectLink_MemberSheetWorkTime_Member.ChildObjectId = inMemberId
                AND Object_MemberSheetWorkTime.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.������ �� ���������';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberSheetWorkTime(), 0, '');
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberSheetWorkTime_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberSheetWorkTime_Member(), ioId, inMemberId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberSheetWorkTime_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 18.04.18         *
*/

-- ����
-- 