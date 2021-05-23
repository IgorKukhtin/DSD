-- Function: gpInsertUpdate_Object_MemberPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberPriceList (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberPriceList(
 INOUT ioId             Integer   ,     -- ���� ������� <>
    IN inPriceListId    Integer   ,     -- �����
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberPriceList());


   -- ��������
   IF COALESCE (inPriceListId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<����� ����> �� ������.';
   END IF;
   IF COALESCE (inMemberId, 0) = 0
   THEN
      RAISE EXCEPTION '������.<���.����> �� �������.';
   END IF;
   
   -- ��������� �� ������������ PriceList + Member3
   IF EXISTS (SELECT 1 
              FROM Object AS Object_MemberPriceList
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_PriceList
                                        ON ObjectLink_MemberPriceList_PriceList.ObjectId = Object_MemberPriceList.Id
                                       AND ObjectLink_MemberPriceList_PriceList.DescId = zc_ObjectLink_MemberPriceList_PriceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_MemberPriceList_Member
                                        ON ObjectLink_MemberPriceList_Member.ObjectId = Object_MemberPriceList.Id
                                       AND ObjectLink_MemberPriceList_Member.DescId = zc_ObjectLink_MemberPriceList_Member()

              WHERE Object_MemberPriceList.DescId = zc_Object_MemberPriceList()
                AND ObjectLink_MemberPriceList_PriceList.ChildObjectId   = inPriceListId
                AND ObjectLink_MemberPriceList_Member.ChildObjectId = inMemberId
                AND Object_MemberPriceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.������ �� ���������';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_MemberPriceList(), 0, '');
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPriceList_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_MemberPriceList_Member(), ioId, inMemberId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_MemberPriceList_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.04.21         *
*/

-- ����
-- 