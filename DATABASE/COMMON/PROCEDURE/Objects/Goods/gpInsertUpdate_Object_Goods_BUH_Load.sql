-- Function: gpInsertUpdate_Object_Goods_BUH_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_BUH_Load (TDateTime, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_BUH_Load(
    IN inDate_BUH            TDateTime ,
    IN inGoodsCode           Integer   , -- ��� ������� <�����>
    IN inGoodsName           TVarChar  , --
    IN inGoodsName_New       TVarChar  , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbGoodsName_BUH TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());


     IF vbUserId = 5 THEN vbUserId:= zc_Enum_Process_Auto_PrimeCost(); END IF;


     -- !!!������ ��� - ����������!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!�����!!!
     END IF;


     -- ��������
     IF COALESCE (inGoodsCode, 0) = 41 AND 1=0 THEN
        RAISE EXCEPTION '������.(%)   (%)   (%)    (%)> .'
                       , inDate_BUH
                       , inGoodsCode
                       , inGoodsName
                       , inGoodsName_New
                       ;
     END IF;

     -- !!!����� �� ������!!!
     vbGoodsId:= (SELECT Object_Goods.Id
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.ObjectCode = inGoodsCode
                    AND Object_Goods.DescId     = zc_Object_Goods()
                    AND inGoodsCode > 0
                 );
     -- ��������
     IF COALESCE (vbGoodsId, 0) = 0 THEN
        --RETURN;
        RAISE EXCEPTION '������.�� ������ ����� - <(%) %> .', inGoodsCode, inGoodsName;
     END IF;


     -- � ���� ����� �����
     IF EXISTS (SELECT 1 FROM ObjectDate WHERE ObjectDate.ObjectId = vbGoodsId AND ObjectDate.DescId = zc_ObjectDate_Goods_BUH() AND ObjectDate.ValueData = inDate_BUH)
     THEN
         RETURN;
     END IF;


     -- ����������� �������� ��������� �  zc_ObjectString_Goods_BUH �� ����, ���� zc_ObjectString_Goods_BUH �� �����  = ������
     vbGoodsName_BUH := (SELECT OS.ValueData
                         FROM ObjectString AS OS
                              JOIN ObjectDate ON ObjectDate.ObjectId = vbGoodsId AND ObjectDate.DescId = zc_ObjectDate_Goods_BUH() AND ObjectDate.ValueData IS NOT NULL
                         WHERE OS.DescId = zc_ObjectString_Goods_BUH() and OS.ObjectId = vbGoodsId
                        );

     IF vbGoodsName_BUH <> ''
     THEN
         -- � ���� ����� �����
         -- RETURN;
         --
         RAISE EXCEPTION '������.��� ������ - <(%) %> ��� ���������%<�������� (����.)> = <%>.%������ ���������� ����� �������� = <%>.'
                       , inGoodsCode
                       , inGoodsName
                       , CHR (13)
                       , vbGoodsName_BUH
                       , CHR (13)
                       , (SELECT OS.ValueData
                          FROM ObjectString AS OS
                          WHERE OS.DescId = zc_ObjectString_Goods_BUH() and OS.ObjectId = vbGoodsId
                         )
                        ;

     END IF;


     vbGoodsName := (SELECT Object.ValueData FROM Object WHERE Object.DescId = zc_Object_Goods() and Object.Id = vbGoodsId);

     -- ��������� ����� ��������
     PERFORM lpInsertUpdate_Object (vbGoodsId, zc_Object_Goods(), inGoodsCode, inGoodsName_New);

     -- ��������� �������� <�������� ����>
     PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), vbGoodsId, vbGoodsName);
     -- ��������� �������� <���� �� ������� ��������� �������� ������(����.)>
     PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_BUH(), vbGoodsId, inDate_BUH);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbGoodsId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.10.197         *
*/

/*
-- update Object set ValueData = tmp.ValueData from (

SELECT OS.*
-- ObjectDate.ObjectId = vbGoodsId 

     -- , lpInsertUpdate_ObjectString (zc_ObjectString_Goods_BUH(), ObjectDate.ObjectId, '')
     -- , lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_BUH(), ObjectDate.ObjectId, null)


 FROM ObjectDate 
      join ObjectString AS OS on OS.DescId = zc_ObjectString_Goods_BUH() and OS.ObjectId = ObjectDate.ObjectId 

WHERE ObjectDate.DescId = zc_ObjectDate_Goods_BUH() AND ObjectDate.ValueData = '01.05.2023'

 -- ) as tmp where tmp.ObjectId = Id 
*/
-- ����
--
