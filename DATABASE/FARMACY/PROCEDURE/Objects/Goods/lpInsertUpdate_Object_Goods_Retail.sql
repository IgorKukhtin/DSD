-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Retail(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                TVarChar  ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inGoodsGroupId        Integer   ,    -- ������ �������
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inNDSKindId           Integer   ,    -- ���
    IN inMinimumLot          TFloat    ,    -- ��������� ��������
    IN inReferCode           Integer   ,    -- ��� ��� �������� �����������
    IN inReferPrice          TFloat    ,    -- ����������� ���� ��������
    IN inPrice               TFloat    ,    -- ���� ����������
    IN inIsClose             Boolean   ,    -- ��� ������
    IN inTOP                 Boolean   ,    -- ��� - �������
    IN inPercentMarkup	     TFloat    ,    -- % �������
    IN inNameUkr             TVarChar  ,    -- �������� ����������
    IN inCodeUKTZED          TVarChar  ,    -- ��� ������
    IN inExchangeId          Integer   ,    -- ��:
    IN inObjectId            Integer   ,    -- 
    IN inUserId              Integer        -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ <�������� ����>
     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', inUserId);

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <����� �������� ����>
     ioId:= lpInsertUpdate_Object_Goods (ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, inObjectId, inUserId, 0, '',
                                         True, 0, inNameUkr, inCodeUKTZED, inExchangeId   
                                       --, CASE WHEN inUserId = 3 THEN FALSE ELSE TRUE END -- !!!������ ����� ������ ����� ����!!!
                                        );

     -- !!!������!!!
     IF inMinimumLot = 0 THEN inMinimumLot := NULL; END IF;   	

     -- ��������� ��� �������� ��� <����� �������� ����>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferCode(), ioId, inReferCode);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferPrice(), ioId, inReferPrice);

         -- ������
         PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Close(), ioId, inIsClose);

     -- !!!������ ��� �������� ���� vbObjectId!!!
     IF vbObjectId = inObjectId
     THEN
         -- ��������� (���.����������
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), ioId, inMinimumLot);
         -- % �������
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), ioId, inPercentMarkup);
         -- ����
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), ioId, inPrice);
         -- ��� - �������
         PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), ioId, inTOP);
     END IF;


    IF vbIsInsert = TRUE THEN
       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, inUserId);
    ELSE 
       -- ��������� �������� <���� ����.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (����.)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, inUserId);
    END IF;

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (ioId, inUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer) OWNER TO postgres;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.09.18                                                       *
 13.07.16         * protocol
 25.03.16                                        *
*/
/*
select Object.*, Object2.*, ObjectLink_Goods_Object.ChildObjectId
         -- ��������� (���.����������
/ *         , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), Object2.Id, ObjectFloat_Goods_MinimumLot.ValueData)
         -- % �������
         , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), Object2.Id, ObjectFloat_Goods_PercentMarkup.ValueData)
         -- ����
         , lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), Object2.Id, ObjectFloat_Goods_Price.ValueData)
         -- ������
         , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Close(), Object2.Id, ObjectBoolean_Goods_Close.ValueData)
         -- ��� - �������
         , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), Object2.Id, ObjectBoolean_Goods_TOP.ValueData)
         -- 
         , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_First(), Object2.Id, ObjectBoolean_Goods_First.ValueData)
         -- 
         , lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Second(), Object2.Id, ObjectBoolean_Goods_Second.ValueData)
* /
from Object
            INNER JOIN ObjectLink AS ObjectLink_Goods_Object_jur
                                  ON ObjectLink_Goods_Object_jur.ObjectId = Object.Id
                                 AND ObjectLink_Goods_Object_jur.DescId = zc_ObjectLink_Goods_Object()
                                 AND ObjectLink_Goods_Object_jur.ChildObjectId = 4
                                    INNER JOIN ObjectLink AS ObjectLink_Child
                                                          ON ObjectLink_Child.ChildObjectId = Object.ID
                                                         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                             AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Main_NB ON ObjectLink_Main_NB.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                               AND ObjectLink_Main_NB.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                    INNER JOIN ObjectLink AS ObjectLink_Child_NB ON ObjectLink_Child_NB.ObjectId = ObjectLink_Main_NB.ObjectId
                                                                                AND ObjectLink_Child_NB.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                          ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_NB.ChildObjectId
                                                         AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                         AND ObjectLink_Goods_Object.ChildObjectId  = 2140932
            INNER JOIN Object AS Object2 ON Object2.Id = ObjectLink_Child_NB.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_MinimumLot
                              ON ObjectFloat_Goods_MinimumLot.ObjectId = Object.Id
                             AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()   
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_PercentMarkup
                              ON ObjectFloat_Goods_PercentMarkup.ObjectId = Object.Id
                             AND ObjectFloat_Goods_PercentMarkup.DescId = zc_ObjectFloat_Goods_PercentMarkup()   
        LEFT JOIN ObjectFloat AS ObjectFloat_Goods_Price
                              ON ObjectFloat_Goods_Price.ObjectId = Object.Id
                             AND ObjectFloat_Goods_Price.DescId = zc_ObjectFloat_Goods_Price()   
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Close
                                ON ObjectBoolean_Goods_Close.ObjectId = Object.Id
                               AND ObjectBoolean_Goods_Close.DescId = zc_ObjectBoolean_Goods_Close()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                ON ObjectBoolean_Goods_TOP.ObjectId = Object.Id
                               AND ObjectBoolean_Goods_TOP.DescId = zc_ObjectBoolean_Goods_TOP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_First
                                ON ObjectBoolean_Goods_First.ObjectId = Object.Id
                               AND ObjectBoolean_Goods_First.DescId = zc_ObjectBoolean_Goods_First()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_Second
                                ON ObjectBoolean_Goods_Second.ObjectId = Object.Id
                               AND ObjectBoolean_Goods_Second.DescId = zc_ObjectBoolean_Goods_Second()


where Object.DescId =  zc_Object_Goods()
*/
-- ����
-- SELECT * FROM lpInsertUpdate_Object_Goods_Retail
