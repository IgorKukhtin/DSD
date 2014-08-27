-- Function: gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink(
    IN inId                     Integer,    -- ����
    IN inCode                   Integer,    -- ���
    IN inName                   TVarChar,   -- ��������
    IN inGoodsId                Integer,    -- 
    IN inGoodsKindId            Integer,    -- 
    IN inBranchId               Integer,    -- 
    IN inBranchTopId            Integer,    -- 
    IN inIsSybase               Boolean  DEFAULT NULL,    -- 
    IN inSession                TVarChar DEFAULT ''       -- ������ ������������
)
  RETURNS TABLE (Id Integer, BranchId Integer, BranchName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBranchId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind1CLink());
   vbUserId := lpGetUserBySession (inSession);

   -- ���-��
   IF COALESCE(inBranchId, 0) = 0 THEN
      vbBranchId := inBranchTopId;
   ELSE
      vbBranchId := inBranchId;
   END IF;
   
   -- ��������
   IF COALESCE (inCode, 0) = 0 AND COALESCE (TRIM (inName), '') = '' THEN
       RAISE EXCEPTION '������. �� ���������� <���>.';
   END IF;
   -- ��������
   IF COALESCE (TRIM (inName), '') = '' THEN
       RAISE EXCEPTION '������. �� ����������� <��������>.';
   END IF;
   -- ��������
   IF COALESCE (vbBranchId, 0) = 0 THEN
       RAISE EXCEPTION '������. �� ���������� <������>.';
   END IF;
   -- ��������
   IF inId <> 0
   THEN
       IF COALESCE (inGoodsId, 0) = 0 THEN
           RAISE EXCEPTION '������. �� ���������� <�����>.';
       END IF;
       IF COALESCE (inGoodsKindId, 0) = 0 THEN
           RAISE EXCEPTION '������. �� ���������� <��� ������>.';
       END IF;
   END IF;

   -- �������� ������������ inCode ��� !!!������!! �������
   IF inCode <> 0
   THEN IF EXISTS (SELECT ObjectLink.ChildObjectId
                   FROM ObjectLink
                        JOIN Object ON Object.Id = ObjectLink.ObjectId
                                   AND Object.ObjectCode = inCode
                   WHERE ObjectLink.ChildObjectId = vbBranchId
                     AND ObjectLink.ObjectId <> COALESCE (inId, 0)
                     AND ObjectLink.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch())
        THEN
            RAISE EXCEPTION '������. ��� 1� <%> ��� ���������� � <%>. ', inCode, lfGet_Object_ValueData (vbBranchId);
        END IF;
   END IF;


   -- ��������� <������>
   inId := lpInsertUpdate_Object (inId, zc_Object_GoodsByGoodsKind1CLink(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_Goods(), inId, inGoodsId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_GoodsKind(), inId, inGoodsKindId);
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind1CLink_Branch(), inId, vbBranchId);
   IF inIsSybase IS NOT NULL THEN 
      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind1CLink_Sybase(), inId, inIsSybase);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

   -- ������� ��������
   RETURN 
     QUERY SELECT inId, Object.Id, Object.ValueData FROM Object WHERE Object.Id = vbBranchId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind1CLink (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Boolean, TVarChar)  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.02.14                                        * all
 11.02.14                        *
*/
