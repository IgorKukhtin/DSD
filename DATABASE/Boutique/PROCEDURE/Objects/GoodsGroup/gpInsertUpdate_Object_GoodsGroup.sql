-- Function: gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroup (Integer,Integer,TVarChar,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
 INOUT ioId                       Integer   ,    -- ���� ������� <������ ������>
 INOUT ioCode                     Integer   ,    -- ��� ������� <������ ������>
    IN inName                     TVarChar  ,    -- �������� ������� <������ ������>
    IN inParentId                 Integer   ,    -- ���� ������� <������ ������>
    IN inInfoMoneyId              Integer   ,    -- ���� ������� <������ ���������� 	>
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroup());
   vbUserId:= lpGetUserBySession (inSession);


   IF vbUserId = zc_User_Sybase() AND ioId > 0 AND NOT EXISTS (SELECT 1 FROM Object WHERE Id = ioId)
   THEN ioId:= 0;
   END IF;

   /*IF vbUserId = zc_User_Sybase() AND ioId > 0 AND NOT EXISTS (SELECT 1
                                                               FROM Object
                                                                    LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                                                                         ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                                                                        AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                                                               WHERE Object.DescId = zc_Object_GoodsGroup() 
                                                                 AND Object.Id     = ioId
                                                                 AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                                                              )
   THEN ioId:= 0;
   END IF;*/

   -- ����� ��� Sybase
   IF vbUserId = zc_User_Sybase() AND COALESCE (ioId, 0) = 0
   THEN ioId:= (SELECT Object.Id
                FROM Object
                     LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                          ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                         AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
                  AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                ORDER BY Object.Id
                -- !!!����� ������!!!
                -- LIMIT 1
               );
   END IF;


   IF vbUserId = zc_User_Sybase() AND COALESCE (ioId, 0) = 0
   THEN
       -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0
       ioCode := NEXTVAL ('Object_GoodsGroup_seq');

   ELSEIF vbUserId = zc_User_Sybase()
   THEN
       -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0
       ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);

   -- ����� ������ - ��� ����� ����� � ioCode -> ioCode
   ELSEIF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_GoodsGroup_seq');
   END IF;


   -- ��������
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION '������.���������� ������ ��������.';
   END IF;

   -- �������� ������������ <��������> ��� !!!<������>!!
   -- IF vbUserId <> zc_User_Sybase() -- !!!����� ������!!!
   -- THEN
   IF EXISTS (SELECT Object.Id
              FROM Object
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsGroup_Parent
                                        ON ObjectLink_GoodsGroup_Parent.ObjectId = Object.Id
                                       AND ObjectLink_GoodsGroup_Parent.DescId   = zc_ObjectLink_GoodsGroup_Parent()
              WHERE Object.DescId = zc_Object_GoodsGroup() AND TRIM (LOWER (Object.ValueData)) = TRIM (LOWER (inName))
                AND COALESCE (ObjectLink_GoodsGroup_Parent.ChildObjectId, 0) = COALESCE (inParentId, 0)
                AND Object.Id <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION '������.������ ������ <%> ��� <%> ��� ����������.', TRIM (inName), lfGet_Object_ValueData_sh (inParentId);
   END IF;

   -- END IF;


   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroup(), ioCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroup(), ioCode, inName);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_Parent(), ioId, inParentId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsGroup_InfoMoney(), ioId, inInfoMoneyId);



   -- �������� �������� <�� ������> � ���� ������� ���� ������
   PERFORM CASE WHEN inInfoMoneyId <> 0
                THEN lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ObjectLink.ObjectId, inInfoMoneyId)
                ELSE lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ObjectLink.ObjectId, lfGet_Object_GoodsGroup_InfoMoneyId (ObjectLink.ChildObjectId))
           END
   FROM ObjectLink
   WHERE DescId = zc_ObjectLink_Goods_GoodsGroup()
     AND ChildObjectId IN -- !!! ���������� �� ��� ������ ���� !!!!
                     (SELECT ioId
                     UNION ALL
                      SELECT ObjectLink.ObjectId
                      FROM ObjectLink
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child1.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child2.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child3.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child4.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     UNION ALL
                      SELECT ObjectLink_Child5.ObjectId
                      FROM ObjectLink
                           JOIN ObjectLink AS ObjectLink_Child1 ON ObjectLink_Child1.ChildObjectId = ObjectLink.ObjectId
                                                               AND ObjectLink_Child1.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child2 ON ObjectLink_Child2.ChildObjectId = ObjectLink_Child1.ObjectId
                                                               AND ObjectLink_Child2.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child3 ON ObjectLink_Child3.ChildObjectId = ObjectLink_Child2.ObjectId
                                                               AND ObjectLink_Child3.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child4 ON ObjectLink_Child4.ChildObjectId = ObjectLink_Child3.ObjectId
                                                               AND ObjectLink_Child4.DescId = zc_ObjectLink_GoodsGroup_Parent()
                           JOIN ObjectLink AS ObjectLink_Child5 ON ObjectLink_Child5.ChildObjectId = ObjectLink_Child4.ObjectId
                                                               AND ObjectLink_Child5.DescId = zc_ObjectLink_GoodsGroup_Parent()
                      WHERE ObjectLink.DescId = zc_ObjectLink_GoodsGroup_Parent()
                        AND ObjectLink.ChildObjectId = ioId
                     )
  ;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
07.06.17          * InfoMoney
13.05.17                                                           *
06.03.17                                                           *
20.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsGroup (ioId := 0 , ioCode := 0 , inName := '������ ������ 2' ::TVarChar, inParentId := 0 , inInfoMoneyId := 0 ,  inSession := '2'::TVarChar);
