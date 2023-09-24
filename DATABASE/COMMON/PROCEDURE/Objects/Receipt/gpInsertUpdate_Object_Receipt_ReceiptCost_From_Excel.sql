 -- Function: gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel (Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Receipt_ReceiptCost_From_Excel(
    IN inReceiptCode         Integer   ,
    IN inReceiptName         TVarChar   ,
    IN inGoodsCode           Integer   , -- ��� ������� <�����>
    IN inGoodsName           TVarChar   , -- ��� ������� <�����> 
    IN inGoodsKindName       TVarChar  ,
    IN inReceiptCostName     TVarChar  ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbReceiptId Integer; 
   DECLARE vbGoodsKindId Integer;
   DECLARE vbReceiptCostId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession); 
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Receipt());

    
     -- !!!
     --IF inGoodsKindName ILIKE '�/�*' THEN inGoodsKindName:= '�/�'; END IF;

     -- !!!������ ���������- ����������!!!
     IF COALESCE (inReceiptCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;

     -- !!!����� �� ���������!!!
     vbReceiptId:= (SELECT Object.Id
                    FROM Object
                    WHERE Object.ObjectCode = inReceiptCode
                      AND Object.DescId     = zc_Object_Receipt()
                      AND Object.isErased   = FALSE
                      AND inReceiptCode > 0
                   );
     -- ��������
     IF COALESCE (vbReceiptId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ������� ��������� <(%) %> .', inReceiptCode, inReceiptName;
     END IF;

     -- !!!����� �� ������!!!
     vbGoodsId:= (SELECT Object.Id
                  FROM Object
                  WHERE Object.ObjectCode = inGoodsCode
                    AND Object.DescId     = zc_Object_Goods()
                    AND Object.isErased   = FALSE
                    AND inGoodsCode > 0
                 );
     -- ��������
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ������ ����� <(%) %>.', inGoodsCode, inGoodsName;
     END IF;

     -- !!!����� �� ��� ������!!!
     vbGoodsKindId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (Object.ValueData) ILIKE TRIM (inGoodsKindName)
                        AND Object.DescId     = zc_Object_GoodsKind()
                        --AND Object.isErased   = FALSE
                        AND TRIM (inGoodsKindName) <> ''
                     );
     -- ��������
     IF COALESCE (vbGoodsKindId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ������ ��� ������ <%>.', inGoodsKindName;
     END IF;
  
     -- !!!����� �� �������!!!
     vbReceiptCostId:= (SELECT Object.Id
                        FROM Object
                        WHERE TRIM (Object.ValueData) ILIKE TRIM (inReceiptCostName)
                          AND Object.DescId     = zc_Object_Goods()
                          AND Object.isErased   = FALSE
                          AND TRIM (inReceiptCostName) <> ''
                       );
     -- ��������
     IF COALESCE (vbReceiptCostId, 0) = 0 THEN
        RAISE EXCEPTION '������.�� ������� �������� ������ <%>.', inReceiptCostName;
     END IF;

   --
   IF EXISTS (SELECT 1
              FROM Object AS Object_Receipt
                   INNER JOIN ObjectLink AS ObjectLink_Receipt_Goods
                                         ON ObjectLink_Receipt_Goods.ObjectId      = Object_Receipt.Id
                                        AND ObjectLink_Receipt_Goods.DescId        = zc_ObjectLink_Receipt_Goods()
                                        AND ObjectLink_Receipt_Goods.ChildObjectId = vbGoodsId
                   INNER JOIN ObjectLink AS ObjectLink_Receipt_GoodsKind
                                         ON ObjectLink_Receipt_GoodsKind.ObjectId      = Object_Receipt.Id
                                        AND ObjectLink_Receipt_GoodsKind.DescId        = zc_ObjectLink_Receipt_GoodsKind()
                                        AND ObjectLink_Receipt_GoodsKind.ChildObjectId = vbGoodsKindId
              WHERE Object_Receipt.Id = vbReceiptId
             )
   THEN 
        -- ��������� ����� � <������� � ����������>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Receipt_ReceiptCost(), vbReceiptId, vbReceiptCostId); 
   ELSE
       RAISE EXCEPTION '������.��������� <(%) %> ��� ������ <(%) %> + <%> �� �������.', inReceiptCode, inReceiptName, inGoodsCode, inGoodsName, inGoodsKindName;
   END IF;
   
   IF vbUserId = 5 AND 1=0
   THEN
         RAISE EXCEPTION '����. ��. <%> <%>', vbReceiptCostId, inReceiptCostName; 
   END IF;   
   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.09.23         *
*/

-- ����
--