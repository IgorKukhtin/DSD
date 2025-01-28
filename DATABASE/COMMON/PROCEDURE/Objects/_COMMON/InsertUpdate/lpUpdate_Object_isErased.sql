-- Function: lpUpdate_Object_isErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpUpdate_Object_isErased (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_isErased(
    IN inObjectId    Integer, 
    IN inUserId      Integer
)
RETURNS VOID AS
$BODY$
   DECLARE vbIsErased Boolean;
   DECLARE vbDescId Integer;
BEGIN
   -- !!!������ �������� �������!!!
   PERFORM lpCheckPeriodClose_auditor (NULL, NULL, NULL, NULL, inObjectId, inUserId);

   IF inUserId IN (5, 9457) AND 1=0
   THEN 
       RAISE EXCEPTION '������.%��� ���� ������� = <%>.'
                          , CHR (13)
                          , (SELECT ObjectDesc.ItemName FROM ObjectDesc JOIN Object ON Object.Id = inObjectId WHERE Object.DescId = ObjectDesc.Id)
                           ;
   END IF;

   -- ��������
   IF COALESCE (inObjectId, 0) <= 0
   THEN
       RAISE EXCEPTION '������.������� �� ������.';
   END IF;


   -- ��������
   UPDATE Object SET isErased = NOT isErased WHERE Id = inObjectId  RETURNING DescId, isErased INTO vbDescId, vbIsErased;


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
ALTER FUNCTION lpUpdate_Object_isErased (Integer, Integer) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 12.09.14                                        * add �������������� ��������
 08.05.14                                        *
*/
