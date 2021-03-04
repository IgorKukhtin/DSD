-- Function: gpLink_Object_MemberSP_LikiDnipro()

DROP FUNCTION IF EXISTS gpLink_Object_MemberSP_LikiDnipro (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpLink_Object_MemberSP_LikiDnipro(
    IN inMemberSPId	         Integer   ,    -- ���� �������
    IN inLikiDniproId        Integer   ,    -- Id 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberSP());
   vbUserId := inSession;
   
   -- �������� ���������� ���.������.
   IF COALESCE (inMemberSPId, 0) = 0
   THEN
     RAISE EXCEPTION '������. �������� <�������> �� �����������.';
   END IF;
   
   -- ������ ����� � ���������� ��������� ���� ���� 
   IF EXISTS(SELECT *
             FROM ObjectFloat
              WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
                AND ObjectFloat.ObjectId <> inMemberSPId
                AND ObjectFloat.ValueData = inLikiDniproId)
   THEN
     UPDATE ObjectFloat SET ValueData = 0
     WHERE ObjectFloat.DescId = zc_ObjectFloat_MemberSP_LikiDniproId()
       AND ObjectFloat.ObjectId <> inMemberSPId
       AND ObjectFloat.ValueData = inLikiDniproId;
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_MemberSP_LikiDniproId(), inMemberSPId, inLikiDniproId);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inMemberSPId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.03.21                                                       *
*/

-- ����
-- SELECT * FROM gpLink_Object_MemberSP_LikiDnipro()
