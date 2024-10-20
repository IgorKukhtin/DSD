-- Function: lpUpdate_Object_isErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_isErased(
    IN inObjectId    Integer,
    IN inIsErased    Boolean, 
    IN inUserId      Integer
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsErased Boolean;
   DECLARE vbDescId Integer;
BEGIN

   -- ��������
   UPDATE Object SET isErased = inIsErased WHERE Id = inObjectId  RETURNING DescId, isErased INTO vbDescId, vbIsErased;


   IF vbDescId = zc_Object_Member() AND vbIsErased = TRUE
   THEN
        -- �������������� ��������
        UPDATE Object SET isErased = vbIsErased
        FROM Object_Personal_View
        WHERE Object_Personal_View.MemberId = inObjectId
          AND Object_Personal_View.PersonalId = Object.Id;

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (inObjectId:= Object_Personal_View.PersonalId, inUserId:= inUserId, inIsUpdate:= TRUE, inIsErased:= TRUE)
        FROM Object_Personal_View
        WHERE Object_Personal_View.MemberId = inObjectId;

   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inObjectId, inUserId:= inUserId, inIsUpdate:= TRUE, inIsErased:= TRUE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 04.05.17                                                         * inIsErased
 12.09.14                                        * add �������������� ��������
 08.05.14                                        *
*/
