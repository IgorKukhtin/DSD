 -- Function: lpComplete_Movement_PriceChangeChange (Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PriceChange (Integer, Integer, TFloat, TDateTime, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_PriceChange (Integer, Integer, Integer, TFloat, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_PriceChange(
    IN inGoodsId        Integer  , -- �� ������
    IN inRetailId       Integer,   -- 
    IN inUnitId         Integer,   -- 
    IN inPriceChange    TFloat,    -- 
    IN inDate           TDateTime, -- 
    IN inUserId         Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbId            Integer;
    DECLARE vbPriceChange   TFloat;
    DECLARE vbDateChange    TDateTime;
    DECLARE vbFixValue      TFloat;
    DECLARE vbFixPercent    TFloat;
    DECLARE vbPercentMarkup TFloat;

    -- DECLARE vbOperDate_StartBegin1 TDateTime;
    DECLARE vbOperDate_StartBegin2 TDateTime;
BEGIN

    -- ��������
    IF COALESCE (inRetailId, 0) <> 0 AND COALESCE (inUnitId, 0) <> 0
    THEN
         RAISE EXCEPTION '������.������ ���� ������ ���� �� ���������� ����.���� ��� �������������';
    END IF;

    -- ���� ����� ������ ���� - ������� � ����� ����.����-����� ��� ����.-�����
    SELECT ObjectLink_Retail.ObjectId                    AS Id
         , ROUND(PriceChange_Value.ValueData,2)::TFloat  AS PriceChange
         , PriceChange_DateChange.valuedata              AS DateChange
         , ObjectFloat_FixValue.ValueData                AS FixValue
         , ObjectFloat_PercentMarkup.ValueData           AS PercentMarkup
         , ObjectFloat_FixPercent.ValueData              AS FixPercent
           INTO vbId
              , vbPriceChange
              , vbDateChange
              , vbFixValue
              , vbPercentMarkup
              , vbFixPercent
    FROM ObjectLink AS ObjectLink_Goods
         LEFT JOIN ObjectLink AS ObjectLink_Retail
                              ON ObjectLink_Retail.ObjectId = ObjectLink_Goods.ObjectId
                             AND ObjectLink_Retail.DescId = zc_ObjectLink_PriceChange_Retail()
         LEFT JOIN ObjectLink AS ObjectLink_Unit
                              ON ObjectLink_Unit.ObjectId = ObjectLink_Goods.ObjectId
                             AND ObjectLink_Unit.DescId = zc_ObjectLink_PriceChange_Unit()
         LEFT JOIN ObjectFloat AS PriceChange_Value
                               ON PriceChange_Value.ObjectId = ObjectLink_Goods.ObjectId
                              AND PriceChange_Value.DescId   = zc_ObjectFloat_PriceChange_Value()
         LEFT JOIN ObjectDate AS PriceChange_DateChange
                              ON PriceChange_DateChange.ObjectId = ObjectLink_Goods.ObjectId
                             AND PriceChange_DateChange.DescId   = zc_ObjectDate_PriceChange_DateChange()
         LEFT JOIN ObjectFloat AS ObjectFloat_FixValue
                               ON ObjectFloat_FixValue.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectFloat_FixValue.DescId   = zc_ObjectFloat_PriceChange_FixValue()
         LEFT JOIN ObjectFloat AS ObjectFloat_PercentMarkup
                               ON ObjectFloat_PercentMarkup.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectFloat_PercentMarkup.DescId   = zc_ObjectFloat_PriceChange_PercentMarkup()
         LEFT JOIN ObjectFloat AS ObjectFloat_FixPercent
                               ON ObjectFloat_FixPercent.ObjectId = ObjectLink_Goods.ObjectId
                              AND ObjectFloat_FixPercent.DescId   = zc_ObjectFloat_PriceChange_FixPercent()
    WHERE ObjectLink_Goods.DescId = zc_ObjectLink_PriceChange_Goods()
      AND ObjectLink_Goods.ChildObjectId = inGoodsId
      AND ((ObjectLink_Retail.ChildObjectId = inRetailId AND inRetailId <> 0)
        OR (ObjectLink_Unit.ChildObjectId = inUnitId AND inUnitId <> 0)
          )
     ;


    IF COALESCE(vbId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        vbId := lpInsertUpdate_Object (vbId, zc_Object_PriceChange(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Goods(), vbId, inGoodsId);

        -- ��������� ���� �� ������� 
        IF COALESCE(inRetailId, 0) <> 0
        THEN
            -- ��������� ����� � <�������� ���� >
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Retail(), ioId, inRetailId);
        END IF;
        IF COALESCE(inUnitId, 0) <> 0
        THEN
            -- ��������� ����� � <�������������>
            PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceChange_Unit(), ioId, inUnitId);
        END IF;
    END IF;

    IF (vbDateChange is null or inDate >= vbDateChange)
    THEN
        IF COALESCE (vbPriceChange,0) <> inPriceChange
        THEN
            -- ��������� ��-�� <����>
            PERFORM lpInsertUpdate_objectFloat (zc_ObjectFloat_PriceChange_Value(), vbId, inPriceChange);

            -- !!!�������� - ������� ��������!!!
            vbOperDate_StartBegin2:= CLOCK_TIMESTAMP();

            -- ��������� �������
            PERFORM gpInsertUpdate_ObjectHistory_PriceChange (ioId             := 0                           :: Integer     -- ���� �������
                                                            , inPriceChangeId  := vbId                                       -- 
                                                            , inOperDate       := CURRENT_TIMESTAMP           :: TDateTime   -- ���� �������� ������
                                                            , inPriceChange    := inPriceChange               :: TFloat      -- ����
                                                            , inFixValue       := vbFixValue                  :: TFloat
                                                            , inFixPercent     := vbFixPercent                :: TFloat
                                                            , inPercentMarkup  := COALESCE (vbPercentMarkup, 0) :: TFloat
                                                            , inSession  := inUserId :: TVarChar
                                                             );

        END IF;

        -- ��������� ��-�� < ���� ��������� >
        PERFORM lpInsertUpdate_objectDate (zc_ObjectDate_PriceChange_DateChange(), vbId, inDate);

        -- ��������� �������� - !!!��������-���.
        PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 28.09.18         * add inUnitId
 12.06.17         * ������ Object_PriceChange_View
 22.12.15                                                                      *
 11.02.14                        *
 05.02.14                        *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_PriceChange (inGoodsId := 1, inRetailId := 1, inPriceChange := 10.0, inUserId := 3)
