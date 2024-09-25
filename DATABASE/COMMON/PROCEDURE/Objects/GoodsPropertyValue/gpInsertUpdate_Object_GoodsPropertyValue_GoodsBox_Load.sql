--
--gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load (TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue_GoodsBox_Load(
    IN inGoodsPropertyName  TVarChar,      -- ������������� ������� �������
    IN inGoodsCode          Integer,       -- ��� ������������ ������
    IN inGoodsName          TVarChar,      -- �������� ������������ ������
    IN inGoodsKindName      TVarChar,      -- ��� ������������ ������
    IN inGoodsBoxName       TVarChar,      -- �������� ������ ���������
    IN inSession            TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsId Integer; 
  DECLARE vbGoodsKindId Integer;
  DECLARE vbGoodsPropertyId Integer;
  DECLARE vbGoodsBoxId Integer;
  DECLARE vbGoodsPropertyValueId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());
   
   IF COALESCE (inGoodsPropertyName,'') = ''
   THEN
        RAISE EXCEPTION '������.������������� ������� ������� �� �����.';
   END IF;
   
   IF COALESCE (inGoodsCode,0) = 0
   THEN
       RETURN;
   END IF;
   
   --������� ������
   vbGoodsId    := (SELECT Object.Id FROM Object WHERE Object.ObjectCode = inGoodsCode AND Object.DescId = zc_Object_Goods());
   -- ������� ��� ������
   vbGoodsKindId    := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind()); 
   -- ������� ����� ���������
   vbGoodsBoxId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsBoxName) AND Object.DescId = zc_Object_Goods());

   -- ������� vbGoodsPropertyId
   vbGoodsPropertyId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsPropertyName) AND Object.DescId = zc_Object_GoodsProperty());
               
   --�������  
   vbGoodsPropertyValueId := (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
                              FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = vbGoodsPropertyId
                                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                        ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                                       AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                              WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = vbGoodsId
                                AND COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) = COALESCE (vbGoodsKindId, 0)
                                );

   IF COALESCE (vbGoodsPropertyValueId,0) = 0
   THEN
       -- ��������� <������>
       vbGoodsPropertyValueId := lpInsertUpdate_Object(0, zc_Object_GoodsPropertyValue(), 0, '');

       -- ��������� �����
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), vbGoodsPropertyValueId, vbGoodsId);
       -- ��������� �����
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), vbGoodsPropertyValueId, vbGoodsKindId);
       -- ��������� �����
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), vbGoodsPropertyValueId, vbGoodsPropertyId);              
   END IF;

   -- ��������� �����  ����� ���������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsBox(), vbGoodsPropertyValueId, vbGoodsBoxId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.09.24         *
*/

-- ����
--