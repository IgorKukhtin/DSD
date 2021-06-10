 -- Function: lpInsertUpdate_Object_PriceSite (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PriceSite (Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PriceSite(
    IN inGoodsId        Integer  , -- �� ������
    IN inPrice          tFloat,    -- ����
    IN inDate           TDateTime, -- ���� ���������
    IN inUserId         Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbId Integer;
    DECLARE vbPrice_Value TFloat;
    DECLARE vbDateChange TDateTime;

    -- DECLARE vbOperDate_StartBegin1 TDateTime;
    DECLARE vbOperDate_StartBegin2 TDateTime;
BEGIN

   -- ���� ����� ������ ���� - ������� � ����� ����.-�����
   SELECT Price_Goods.ObjectId                     AS Id
        , ROUND(Price_Value.ValueData,2)::TFloat   AS Price_Value
        , Price_DateChange.valuedata               AS DateChange
          INTO vbId
             , vbPrice_Value
             , vbDateChange
   FROM ObjectLink AS Price_Goods
        LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = Price_Goods.ObjectId
                              AND Price_Value.DescId   = zc_ObjectFloat_PriceSite_Value()
        LEFT JOIN ObjectDate AS Price_DateChange
                             ON Price_DateChange.ObjectId = Price_Goods.ObjectId
                            AND Price_DateChange.DescId   = zc_ObjectDate_PriceSite_DateChange()
   WHERE Price_Goods.DescId        = zc_ObjectLink_PriceSite_Goods()
     AND Price_Goods.ChildObjectId = inGoodsId;

    IF COALESCE(inPrice, 0) = COALESCE(vbPrice_Value, 0)
    THEN
      RETURN;
    END IF;

    IF COALESCE(vbId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        vbId := lpInsertUpdate_Object (vbId, zc_Object_PriceSite(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceSite_Goods(), vbId, inGoodsId);

    END IF;

    -- ��������� ��-�� <����>
    PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_PriceSite_Value(), vbId, inPrice);


    -- ��������� �������
    PERFORM gpInsertUpdate_ObjectHistory_PriceSite
                  (ioId           := 0                           :: Integer     -- ���� ������� <������� ������� ������>
                 , inPriceSiteId  := vbId                                       -- �����
                 , inOperDate     := CURRENT_TIMESTAMP           :: TDateTime   -- ���� �������� ������
                 , inPrice        := inPrice                     :: TFloat      -- ����
                 , inSession      := inUserId :: TVarChar
                  );

    -- ��������� ��-�� < ���� ��������� >
    PERFORM lpInsertUpdate_objectDate (zc_ObjectDate_PriceSite_DateChange(), vbId, inDate);

    -- ��������� �������� - !!!��������-���.
    PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.06.21                                                       *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_PriceSite (inGoodsId := 1, inUnitId := 1, inPrice := 10.0, inUserId := 3)
