-- Function: gpInsertUpdate_Object_ViewPriceList()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ViewPriceList (Integer, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ViewPriceList(
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ViewPriceList());


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
              FROM Object AS Object_ViewPriceList
                   LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_PriceList
                                        ON ObjectLink_ViewPriceList_PriceList.ObjectId = Object_ViewPriceList.Id
                                       AND ObjectLink_ViewPriceList_PriceList.DescId = zc_ObjectLink_ViewPriceList_PriceList()
        
                   LEFT JOIN ObjectLink AS ObjectLink_ViewPriceList_Member
                                        ON ObjectLink_ViewPriceList_Member.ObjectId = Object_ViewPriceList.Id
                                       AND ObjectLink_ViewPriceList_Member.DescId = zc_ObjectLink_ViewPriceList_Member()

              WHERE Object_ViewPriceList.DescId = zc_Object_ViewPriceList()
                AND ObjectLink_ViewPriceList_PriceList.ChildObjectId = inPriceListId
                AND ObjectLink_ViewPriceList_Member.ChildObjectId = inMemberId
                AND Object_ViewPriceList.Id <> ioId
              )
   THEN
       RAISE EXCEPTION '������.������ �� ���������';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ViewPriceList(), 0, '');
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ViewPriceList_PriceList(), ioId, inPriceListId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ViewPriceList_Member(), ioId, inMemberId);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_ViewPriceList_Comment(), ioId, inComment);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.24         *
*/

-- ����
-- 