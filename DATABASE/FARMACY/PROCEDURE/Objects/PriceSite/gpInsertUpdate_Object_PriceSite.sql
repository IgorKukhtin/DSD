-- Function: gpInsertUpdate_Object_PriceSite (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PriceSite (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceSite(
 INOUT ioId                       Integer   ,    -- ���� ������� < ���� >
    IN inGoodsId                  Integer   ,    -- �����
    IN inPrice                    TFloat    ,    -- ����
    IN inPercentMarkup            TFloat    ,    -- % �������
    IN inFix                      Boolean   ,    -- ������������� ����
   OUT outDateChange              TDateTime ,    -- ���� ��������� ����
   OUT outFixDateChange           TDateTime ,    -- ���� ��������� �������� "������������� ����"
   OUT outPercentMarkupDateChange TDateTime ,    -- ���� ��������� �������� % �������
   OUT outStartDate               TDateTime ,    -- ����
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS record AS
$body$
    DECLARE
        vbUserId       Integer;
        vbPrice        TFloat;
        vbFix          Boolean;
        vbPercentMarkup TFloat;
        vbDate         TDateTime;
    DECLARE vbUpdateProtocol boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;

    -- ��������� ������������ ����
    IF COALESCE(inPrice, 0) <= 0
    THEN
        RAISE EXCEPTION '������. ���� <%> ������ ���� ������ 0.', inPrice;
    END IF;
        
    vbUpdateProtocol := False;
    
    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Id, 
           Price, 
           Fix,
           PercentMarkup,
           DateChange
      INTO ioId, 
           vbPrice, 
           vbFix,
           vbPercentMarkup,
           outDateChange
    FROM (WITH tmp1 AS (SELECT Object_PriceSite.Id                                    AS Id
                             , ROUND(PriceSite_Value.ValueData,2)::TFloat             AS Price
                             , COALESCE(PriceSite_Fix.ValueData,False)                AS Fix
                             , COALESCE(PriceSite_PercentMarkup.ValueData, 0)::TFloat AS PercentMarkup
                             , PriceSite_datechange.valuedata                         AS DateChange
                           FROM Object AS Object_PriceSite
                               INNER JOIN ObjectLink AS PriceSite_Goods
                                                     ON PriceSite_Goods.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_Goods.DescId = zc_ObjectLink_PriceSite_Goods()
                                                    AND PriceSite_Goods.ChildObjectId = inGoodsId
                               LEFT JOIN ObjectFloat AS PriceSite_Value
                                                     ON PriceSite_Value.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_Value.DescId = zc_ObjectFloat_PriceSite_Value()
                               LEFT JOIN ObjectDate AS PriceSite_DateChange
                                                    ON PriceSite_DateChange.ObjectId = Object_PriceSite.Id
                                                   AND PriceSite_DateChange.DescId = zc_ObjectDate_PriceSite_DateChange()
                               LEFT JOIN ObjectBoolean AS PriceSite_Fix
                                                       ON PriceSite_Fix.ObjectId = Object_PriceSite.Id
                                                      AND PriceSite_Fix.DescId = zc_ObjectBoolean_PriceSite_Fix()
                               LEFT JOIN ObjectFloat AS PriceSite_PercentMarkup                                                   
                                                     ON PriceSite_PercentMarkup.ObjectId = Object_PriceSite.Id
                                                    AND PriceSite_PercentMarkup.DescId = zc_ObjectFloat_PriceSite_PercentMarkup()
                              WHERE  Object_PriceSite.DescId = zc_Object_PriceSite())
          SELECT  * FROM tmp1) AS tmp;
   
    IF COALESCE(ioId,0)=0
    THEN
        -- ���������/�������� <������> �� ��
        ioId := lpInsertUpdate_Object (ioId, zc_Object_PriceSite(), 0, '');

        -- ��������� ����� � <�����>
        PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_PriceSite_Goods(), ioId, inGoodsId);

        vbUpdateProtocol := True;
    END IF;
    
    IF COALESCE(vbFix, False) <> COALESCE(inFix, FALSE)
    THEN
        -- ��������� �������� <������������� ����>
        PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_PriceSite_Fix(), ioId, inFix);
        -- ��������� ���� ��������� <������������� ����>
        outFixDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_FixDateChange(), ioId, outFixDateChange);

        vbUpdateProtocol := True;
    END IF;    

    -- ��������� ��-�� < ���� >
    IF inPrice <> COALESCE(vbPrice,0)
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceSite_Value(), ioId, inPrice);
        -- ��������� ��-�� < ���� ��������� >
        outDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_DateChange(), ioId, outDateChange);

        vbUpdateProtocol := True;
    END IF;

    -- ��������� ��-�� < % ������� >
    IF (inPercentMarkup is not null) AND (inPercentMarkup <> COALESCE(vbPercentMarkup,0))
    THEN
        PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_PriceSite_PercentMarkup(), ioId, inPercentMarkup);
        -- ��������� ��-�� < ���� ��������� >
        outPercentMarkupDateChange := CURRENT_DATE;
        PERFORM lpInsertUpdate_objectDate(zc_ObjectDate_PriceSite_PercentMarkupDateChange(), ioId, outPercentMarkupDateChange);

        vbUpdateProtocol := True;
    END IF;

    -- ��������� �������
    IF inPrice <> COALESCE(vbPrice,0)
    THEN
        -- ��������� �������
        PERFORM gpInsertUpdate_ObjectHistory_PriceSite(
                ioId           := 0 :: Integer,                                    -- ���� ������� <������� ������� ������>
                inPriceSiteId  := ioId,                                        -- �����
                inOperDate     := CURRENT_TIMESTAMP                  :: TDateTime, -- ���� �������� ������
                inPrice        := COALESCE (inPrice, vbPrice):: TFloat,            -- ����
                inSession      := inSession);
        outStartDate:= (SELECT MAX (StartDate) FROM ObjectHistory WHERE ObjectHistory.ObjectId = ioId AND DescId = zc_ObjectHistory_PriceSite());

    END IF;

    -- ��������� ��������
    IF vbUpdateProtocol = TRUE
    THEN
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
    END IF;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.06.21                                                       *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PriceSite()