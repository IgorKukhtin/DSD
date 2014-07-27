-- Function: lpInsertFind_Object_PartionGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inStorageId  Integer -- ����� ��������
    IN inInvNumber  TVarChar  -- ����������� �����
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- ������ ��������
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= '0';
     END IF;

     -- �������
     IF COALESCE (inStorageId, 0) = 0
     THEN 
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                                       AND ObjectLink.DescId = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink.ChildObjectId IS NULL
                             WHERE Object.ValueData = inInvNumber
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     THEN 
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                                       AND ObjectLink.DescId = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink.ChildObjectId = inStorageId
                             WHERE Object.ValueData = inInvNumber
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     END IF;

     -- ���� �� �����
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- ��������� <������>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inInvNumber);

         -- ���������
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId = 0 THEN NULL ELSE inStorageId END);

     END IF;

     -- ���������� ��������
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.07.14                                        *
*/

-- ����
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);