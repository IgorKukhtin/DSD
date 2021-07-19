-- Function: gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase

DROP FUNCTION IF EXISTS gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (Integer, Integer, Integer, TDateTime, TDateTime, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase(
 INOUT ioId                     Integer,    -- ���� ������� <������� �������>
    IN inUnitId                 Integer,    -- �������������
    IN inGoodsId                Integer,    -- �����
    IN inStartDate              TDateTime,  -- ���� �������� % ������
    IN inEndDate                TDateTime,  -- ���� �������� % ������
    IN inValue                  TFloat,     -- % ������
    IN inValueNext              TFloat,     -- % ������ ���.
    IN inIsLast                 Boolean,    --
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
DECLARE
   DECLARE vbItemId Integer;
BEGIN
   -- !!!������ ��������!!!
   IF inIsLast = TRUE
   THEN
        -- ���� ioId - �� ��� �� ����, �.�. StartDate = inStartDate
        ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_DiscountPeriodItem()
                                                             AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.StartDate = inStartDate);
        --
        SELECT tmp.ioId INTO ioId
        FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItemLast (ioId          := ioId
                                                                , inUnitId      := inUnitId
                                                                , inGoodsId     := inGoodsId
                                                                , inOperDate    := inStartDate
                                                                , inValue       := inValue
                                                                , inValueNext   := inValueNext
                                                                , inIsLast      := inIsLast
                                                                , inSession     := inSession
                                                                 ) AS tmp;
   ELSE
        -- ����� <�������>
        vbItemId:= lpGetInsert_Object_DiscountPeriodItem (inUnitId, inGoodsId, inSession :: Integer);

        -- ���� ioId - �� inEndDate
        ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.EndDate = inEndDate);

        IF ioId > 0
        THEN
            -- �������� inValue
            IF NOT EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId AND ValueData = inValue)
               AND EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId AND ValueData > 0)
               AND inValue > 0
            THEN
                RAISE EXCEPTION 'DIFF VALUE on EndDate <%> <%>', inValue, (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId);
            END IF;

            -- ��������� Value
            IF inValue = 0 THEN inValue:= COALESCE ((SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId), 0); END IF;
            -- ��������� inStartDate
            inStartDate:= (SELECT (tmp.StartDate) FROM (SELECT StartDate FROM ObjectHistory WHERE Id = ioId /*UNION SELECT inStartDate AS StartDate*/) AS tmp);

        ELSE
            -- ���� ioId - �� ��� �� ����, �.�. StartDate = inStartDate
            ioId:= (SELECT ObjectHistory.Id FROM ObjectHistory WHERE ObjectHistory.DescId = zc_ObjectHistory_DiscountPeriodItem() AND ObjectHistory.ObjectId = vbItemId AND ObjectHistory.StartDate = inStartDate);

            IF ioId > 0
            THEN
                -- �������� inValue
                IF NOT EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId AND ValueData = inValue)
                   AND EXISTS (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId AND ValueData > 0)
                   AND inValue > 0
                THEN
                    RAISE EXCEPTION 'DIFF VALUE on StartDate <%> <%>', inValue, (SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId);
                END IF;

                -- ��������� Value
                IF inValue = 0 THEN inValue:= COALESCE ((SELECT ValueData FROM ObjectHistoryFloat WHERE DescId = zc_ObjectHistoryFloat_DiscountPeriodItem_Value() AND ObjectHistoryId = ioId), 0); END IF;
                -- ��������� inEndDate
                inEndDate:= (SELECT (tmp.EndDate) FROM (SELECT EndDate FROM ObjectHistory WHERE Id = ioId /*UNION SELECT inEndDate AS EndDate*/) AS tmp);

            END IF;

        END IF;


        IF COALESCE (ioId, 0) = 0
        THEN
           -- �������� ������� �������: <���� ������ �������> , <��� �������> , <������> � ������� �������� <�����>
           INSERT INTO ObjectHistory (DescId, ObjectId, StartDate, EndDate)
                  VALUES (zc_ObjectHistory_DiscountPeriodItem(), vbItemId, inStartDate, inEndDate) RETURNING Id INTO ioId;
        ELSE
           -- �������� ������� ������� �� �������� <�����>: <��� �������>, <������>
           UPDATE ObjectHistory SET StartDate = inStartDate, EndDate = inEndDate, ObjectId = vbItemId WHERE Id = ioId;
           IF NOT FOUND THEN
              RAISE EXCEPTION 'NOT FOUND';
           END IF;
        END IF;

        -- ��������� ������
        PERFORM lpInsertUpdate_ObjectHistoryFloat (zc_ObjectHistoryFloat_DiscountPeriodItem_Value(), ioId, inValue);

        -- ��������� ��������
        PERFORM lpInsert_ObjectHistoryProtocol (inObjectId:= vbItemId, inUserId:= inSession :: Integer, inStartDate:= inStartDate, inEndDate:= inEndDate, inPrice:= inValue, inIsUpdate:= TRUE, inIsErased:= FALSE);

   END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.04.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ObjectHistory_DiscountPeriodItem_sybase (ioId:= 0, inUnitId:= 1154, inGoodsId:= 45766, inStartDate:= '06.03.2011', inEndDate:= '14.08.2011', inValue:= 90, inIsLast:= FALSE, inSession:= zfCalc_UserAdmin());
